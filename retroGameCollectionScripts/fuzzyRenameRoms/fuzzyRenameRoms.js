
// Get our passed args
var args = process.argv.slice(2);

// Check the length of the arges
if(args.length !== 4) {
  console.log('Did not pass all required fields\n');
  console.log('Usage: node fuzzyRenameRoms.js [folder 1] [folder 2] [file exenstions of folder 1] [file extensions of folder two]');
  return;
}

// Import our node modules
const Fuse = require('fuse.js');
const yesno = require('yesno');
const fs = require('fs');

// Read our first folder
const folderOneFiles = [];
const folderOneArg = args[0];
const folderOneExtArg = '.' + args[2];
fs.readdirSync(folderOneArg).forEach(file => {
  if(fs.lstatSync(folderOneArg + '/' + file).isFile() &&
    file.includes(folderOneExtArg)) {
    // Get the file without it's extension
    file = file.replace(folderOneExtArg, '');
    folderOneFiles.push({
      title: file
    });
  }
});

// Read our second folder
const folderTwoFiles = [];
const folderTwoArg = args[1];
const folderTwoExtArg = '.' + args[3];
fs.readdirSync(folderTwoArg).forEach(file => {
  if(fs.lstatSync(folderTwoArg + '/' + file).isFile() &&
    file.includes(folderTwoExtArg)) {
    // Get the file without it's extension
    file = file.replace(folderTwoExtArg, '');
    folderTwoFiles.push({
      title: file
    });
  }
});

// Log our Folder Items
console.log(' ');
console.log('-------------------------------------------------------------');
console.log('Folder One: ');
console.log('-------------------------------------------------------------');
console.log(' ');
console.log(folderOneFiles);


console.log(' ');
console.log('-------------------------------------------------------------');
console.log('Folder Two: ');
console.log('-------------------------------------------------------------');
console.log(' ');
console.log(folderTwoFiles);

// Prepare Fuse.js to do our fuzzy searching
var options = {
  shouldSort: true,
  includeScore: true,
  threshold: 0.4,
  location: 0,
  distance: 100,
  maxPatternLength: 200,
  minMatchCharLength: 1,
  keys: [
    "title"
]};
const fuse = new Fuse(folderTwoFiles, options);

// Check each file in folder one with each file on folder two
console.log(' ');
console.log('-------------------------------------------------------------');
console.log('The Following Renames will be performed: ');
console.log('-------------------------------------------------------------');
const conversions = [];
folderOneFiles.forEach((fileObject) => {
  const result = fuse.search(fileObject.title);
  //Take the first result, if we have results
  if(result.length &&
    fileObject.title.toUpperCase() !== result[0].item.title.toUpperCase()) {
    console.log(' ');
    console.log(fileObject.title + ' --> ' + result[0].item.title);
    conversions.push({
      fileToConvert: folderOneArg + fileObject.title + folderOneExtArg,
      newFileName: folderOneArg + result[0].item.title + folderOneExtArg
    });
    //Rename the file to the result's title, if we dont have the --test flag
  }
});
console.log(' ');

if(conversions.length <= 0) {
  console.log('No renames found, have a nice day!');
  process.exit();
}

// Ask if we would like to perform the rename
yesno.ask('Would you like to perform these conversions? (y/n)\n', true, function(ok) {
    if(ok) {
      console.log(' ');
      console.log('-------------------------------------------------------------');
      console.log('Performing the Following Renames: ');
      console.log('-------------------------------------------------------------');
        conversions.forEach((rename) => {
          fs.rename(rename.fileToConvert, rename.newFileName, function(err) {
              if ( err ) console.log('Failure renaming:\n' + err);
          });
          console.log(' ');
          console.log('Renamed: ' + rename.fileToConvert + ' --> ' + rename.newFileName);
        });
    console.log(' ');
    console.log('Performed all conversions. Have a nice day!');
    } else {
        console.log("Conversions will not be performed. Have a nice day!");
    }
    process.exit();
});
