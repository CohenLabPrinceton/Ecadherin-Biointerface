/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Ch1 Input directory", style = "directory") ch1input
#@ File (label = "Ch2 Input directory", style = "directory") ch2input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.
setBatchMode(true);
processFolder(ch1input,ch2input);
print("Job is done!");
setBatchMode(false);
// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(ch1input,ch2input) {
	ch1list = getFileList(ch1input);
	ch1list = Array.sort(ch1list);
	ch2list = getFileList(ch2input);
	ch2list = Array.sort(ch2list);
	ch1list_sorted=newArray(0);
	ch2list_sorted=newArray(0);
	icounter=0;
	for (i = 0; i < ch1list.length; i++) {
		if(endsWith(ch1list[i], suffix)){
			ch1list_sorted[icounter]=ch1list[i];
			icounter=icounter+1;
		}
	}
	jcounter=0;
	for (j = 0; j < ch2list.length; j++) {
		if(endsWith(ch2list[j], suffix)){
			ch2list_sorted[jcounter]=ch2list[j];
			jcounter=jcounter+1;
		}
	}
	for (i = 0; i < ch1list_sorted.length; i++) {
			processFile(ch1input, ch2input, output, ch1list_sorted[i], ch2list_sorted[i]);
		
	}


	
}

function processFile(ch1input, ch2input, output, ch1file, ch2file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + ch1input + File.separator + ch1file + " and " + ch2input + File.separator + ch2file );
	open(ch1input+File.separator+ch1file);
	ch1ImageID=File.name;
	open(ch2input+File.separator+ch2file);
	ch2ImageID=File.name;
	outputfileID=substring(ch1ImageID,0,ch1ImageID.length-6);
    outputfilename=output+File.separator+outputfileID+".tif";
	imageCalculator("OR create", ch1ImageID, ch2ImageID);
    run("Analyze Particles...", "size=100-Infinity show=Masks");
    saveAs("Tiff",outputfilename);
	print("Saving to: " + output);
	close("*");
}
