import yargs = require("yargs");

yargs
  .commandDir("../build/commands")
  .env()
  .help()
  .demandCommand()
  .argv;
