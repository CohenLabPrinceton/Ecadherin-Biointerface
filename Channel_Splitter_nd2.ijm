/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "CH1 Output directory", style = "directory") ch1output
#@ File (label = "CH2 Output directory", style = "directory") ch2output
#@ File (label = "CH3 Output directory", style = "directory") ch3output
#@ File (label = "CH4 Output directory", style = "directory") ch4output
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.
setBatchMode(true);
processFolder(input);
setBatchMode(false);
print("Job is done!");

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, ch1output, ch2output, ch3output, ch4output, list[i]);
	}
}

function processFile(input, ch1output, ch2output, ch3output, ch4output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	run("Bio-Formats Windowless Importer", "open=[" + input+File.separator+file +"] autoscale color_mode=Composite rois_import=[ROI manager] view=DataBrowser stack_order=XYCZT");
	ch1outputpath=ch1output+ File.separator +"C1-"+ file;
	ch2outputpath=ch2output+ File.separator +"C2-"+ file;
	ch3outputpath=ch3output+ File.separator +"C3-"+ file;
	ch4outputpath=ch4output+ File.separator +"C4-"+ file;
	run("Split Channels");
	n = nImages;
	for (i=1; i<=n; i++) {
		selectImage(i);
		imageTitle = getTitle();
		imageId = getImageID();
		if (startsWith(imageTitle, "C1")){
			print("Saving to: " + ch1outputpath);
			saveAs("Tiff",ch1outputpath);}
		if (startsWith(imageTitle, "C2")){
			print("Saving to: " + ch2outputpath);
			saveAs("Tiff",ch2outputpath);}		
		if (startsWith(imageTitle, "C3")){
			print("Saving to: " + ch3outputpath);
			saveAs("Tiff",ch3outputpath);}
		if (startsWith(imageTitle, "C4")){
			print("Saving to: " + ch4outputpath);
			saveAs("Tiff",ch4outputpath);}	
	}
	close("*");
}
