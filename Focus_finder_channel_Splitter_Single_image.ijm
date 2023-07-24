/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "CH1 Output directory", style = "directory") ch1output
#@ File (label = "CH2 Output directory", style = "directory") ch2output
#@ File (label = "Mask Output directory", style = "directory") maskoutput
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.
processFolder(input);
print("Job is done!");

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, ch1output, ch2output, maskoutput, list[i]);
	}
}

function processFile(input, ch1output, ch2output, maskoutput, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	run("Bio-Formats Windowless Importer", "open=[" + input+File.separator+file +"] autoscale color_mode=Composite rois_import=[ROI manager] view=DataBrowser stack_order=XYCZT");
	imageId = getTitle();
	Ch1name="C1-"+imageId;
	Ch2name="C2-"+imageId;
	run("Split Channels");
	selectWindow(Ch1name);
	run("Enhance Contrast...", "saturated=0.3 normalize process_all");
	run("Find focused slices", "select=100 variance=0.8 edge log");
	IJ.renameResults("Find_Focus","Results");
	slice = getResult('Slice',0);
	endslice=slice+6;
	selectWindow(Ch1name);
	setSlice(slice);
	run("Duplicate...", "use");
	saveAs("Tiff",ch1output+File.separator+Ch1name);
	C1Id=getTitle();	
	run("Gaussian Blur...", "sigma=5 stack");
	run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'"+C1Id+"', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.0', 'outputType':'Label Image', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
	setThreshold(1, 65535, "raw");
	run("Convert to Mask", "method=Default background=Dark");
	run("Erode", "stack");
	run("Analyze Particles...", "size=250-Infinity show=Masks");
	saveAs("Tiff",maskoutput+File.separator+Ch1name);
	selectWindow(Ch2name);
	run("Duplicate...", "duplicate range="+slice+"-"+slice);
	saveAs("Tiff",ch2output+File.separator+Ch2name);
	close("*");
	close("Results");
	}
	