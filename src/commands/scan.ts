import * as util from "util";
import* as fs from "fs";
import { logger } from "../logger";
import * as blc from "broken-link-checker";
import * as Octokit from "@octokit/rest";

exports.name = "scan";
exports.describe = "Scan a web site for broken links";
exports.builder = {
  url: {
    alias: "u",
    required: true,
  },
  excludeFile: {
    name: "exclude-file",
    alias: "e",
  },
};

exports.handler = async (argv) => {
  main(argv).catch((err) => {
    console.log(`Failed with error ${util.inspect(err)}`);
    process.exit(1);
  });
};

async function main(argv): Promise<any> {
  process.on('SIGTERM', function onSigterm () {
    logger.info(`Got SIGTERM, cleaning up`);
    process.exit();
  });

  // TODO consider exposing some of these in the Actino
  const blcCheckerOptions = {
    excludedKeywords: [],
    excludeExternalLinks: false,
    excludeInternalLinks: false,
    excludeLinksToSamePage: true,
    filterLevel: 1,
    honorRobotExclusions: true,
    maxSockets: 20,
    maxSocketsPerHost: 20,
    requestMethod: "head",
    userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9",
  };

  const brokenLinks: any[] = [];
  let workingLinkCount = 0;
  let linksChecked = 0;
  const handlers = {
    html: (tree, robots, response, pageUrl) => {

    },

    junk: () => {
    },

    link: (result) => {
      linksChecked++;

      if (result.broken) {
        console.log(`${result.base.original} has a broken link to ${result.url.original}`);
        brokenLinks.push({
          "source": result.base.original,
          "target": result.url.original,
        });
      } else {
        workingLinkCount++;
      }

      if (linksChecked % 100 === 0) {
        console.log(`Checked ${linksChecked} links. Found ${brokenLinks.length} broken and ${workingLinkCount} working.`);
      }
    },

    page: (error, pageUrl) => {

    },

    end: async () => {
      let messageBody;
      if (brokenLinks.length === 0) {
        messageBody = `The broken link check did not find anything to report. There are no broken links.`;
      } else {
        messageBody = `There ${brokenLinks.length === 1 ? "is" : "are"} ${brokenLinks.length} broken link${brokenLinks.length === 1 ? "" : "s"} in the hugo site:  \n\n`;
        messageBody = messageBody + `| URL containing broken link | Broken link referring to |\n`;
        messageBody = messageBody + `| -------------------------- | ------------------------ |\n`;

        for (let brokenLink of brokenLinks) {
          messageBody = messageBody + `| ${brokenLink.source} | ${brokenLink.target} |\n`;
        }

        messageBody = messageBody + `\n`;
      }

      if (!process.env["GITHUB_TOKEN"]) {
        console.error(`There is no GITHUB_TOKEN set in the environment. Unable to create a GitHub comment.`);
        console.log(messageBody);
        return;
      }

      const originalEvent = JSON.parse(fs.readFileSync(`/github/workflow/event.json`).toString());

      if (originalEvent.type !== "pull_request") {
        console.error(`event was not a pull request, cowardly refusing to create a comment`);
        return;
      }
      // Post as a comment on the PR
      const githubClient = new Octokit({
        auth: `token ${process.env["GITHUB_TOKEN"]}`,
      });

      const ownerAndRepo = process.env["GITHUB_REPOSITORY"]!.split("/");

      await githubClient.pulls.createComment({
        owner: ownerAndRepo[0],
        repo: ownerAndRepo[1],
        number: originalEvent.pull_request.number,
        body: messageBody,
        commit_id: originalEvent.pull_request.merge_commit_sha,
        path: "",
        position: 0,
      });
    },
  }
  // This implemnetation is copied from broken-link-checker/cli's run function
  const instance = new blc.SiteChecker(blcCheckerOptions, handlers);
  instance.enqueue(argv.url);

}