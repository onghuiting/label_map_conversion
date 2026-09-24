

// This macro converts Imaris trackID color-coded surfaces movies to label map movies..
// The input are .avi files from Imaris. Each avi file is a trackID color-coded surfaces movie which has same dimension as original input.
// This macro uses MorphoLibJ_-1.4.3 plugin.
//
// Written by hui ting, 19 Aug 2021.


///////////////////////////////////////////////////////////////////////////////////////////////////////


dir_input = getDirectory("Select your input folder that consists of multiple .avi files");
list = getFileList(dir_input);

dir_output = dir_input+"Results";
File.makeDirectory(dir_output);


for (i = 0; i < list.length; i++) {

if (endsWith(list[i], ".avi")){

name = list[i];

open(dir_input+name);
rename(name);

run("RGB Stack");
run("32-bit");
run("Split Channels");
selectWindow("C1-"+name);
run("Multiply...", "value=1000000.0000 stack");
selectWindow("C2-"+name);
run("Multiply...", "value=1000.0000 stack");
imageCalculator("Add create 32-bit stack", "C1-"+name,"C2-"+name);
imageCalculator("Add create 32-bit stack", "Result of C1-"+name,"C3-"+name);
run("Remap Labels");
run("glasbey inverted");
saveAs("Tiff", dir_output+File.separator+name+"_label_map.tif");

run("Close All");


}

	
}




