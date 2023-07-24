

#@ File (label = "CH1 Input directory", style = "directory") ch1input
#@ File (label = "CH2 Input directory", style = "directory") ch2input
#@ File (label = "CH3 Input directory", style = "directory") ch3input
#@ File (label = "Output directory", style = "directory") output
#@ int (label = "Number of Sample") sample_number

ch1foldername=File.getName(ch1input);
ch2foldername=File.getName(ch2input);
ch3foldername=File.getName(ch3input);

setBatchMode(true);

for (i = 1; i <= sample_number; i++) {
	print("Processing: " + String.pad(i,2)+"/"+String.pad(sample_number,2));
    sample_name="xy"+String.pad(i,2);
    outputpath=output+File.separator+sample_name;
    run("Image Sequence...", "dir="+ch1input + File.separator+" filter="+sample_name+" count=[] sort");
    run("Image Sequence...", "dir="+ch2input + File.separator+" filter="+sample_name+" count=[] sort");
    run("Image Sequence...", "dir="+ch3input + File.separator+" filter="+sample_name+" count=[] sort");
    run("16-bit");
	run("Merge Channels...", "c1="+ch1foldername+" c2="+ch2foldername+" c4="+ch3foldername+" create");
	saveAs("Tiff",outputpath);
	close("*");
	}
	
setBatchMode(false);

print("Job is done!");