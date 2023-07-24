
directory = "D:/121421_long_9mA/"
open(toString(directory+"/cropped/cyst1.tif")); 
Stack.getDimensions(width, height, channels, slices, frames);

firstTP=1; //first t point--below will add two zeroes for assuming a 3-digit number
lastTP=frames; //last t point
stackSize = slices;
close();

numCysts= 46; // number of cysts in this experiment
// calculate focused slides, add 1, then save into results file

for (nc=1; nc<=numCysts; nc++) {

	
	cystnum = toString(nc);
	open(toString(directory+"cropped/cyst"+toString(nc)+".tif")); 

	cystname = "cyst"+cystnum+".tif";
	slices = newArray(lastTP);
	selectWindow(cystname);
	
	
	for (i=1; i<=lastTP; i++) {
	
		newFrame = toString(i);
		selectWindow(cystname);
		run("Duplicate...", "duplicate frames="+newFrame);
		run("Find focused slices", "select=100 variance=0.8 edge log");
		
		slice = getResult('Slice',0);
		slices[i-1] = slice + 1;
	
		
		selectWindow("cyst"+cystnum+"-1.tif");
		close();
		selectWindow("Focused slices of cyst"+cystnum+"-1.tif_100.0%");
		close();
	
	}

	
	for (i=1; i<=lastTP; i++) {
		
		setResult("Focus", i-1, slices[i-1]);
	}
	
	updateResults();
	saveAs("Results", directory+"cyst"+cystnum+".csv"); 
	
	if (isOpen("Results")) {
         selectWindow("Results"); 
         run("Close" );
	}
    if (isOpen("Log")) {
         selectWindow("Log");
         run("Close" );
    }
     while (nImages()>0) {
          selectImage(nImages());  
          run("Close");
    }
}

// find focused slides and concatenate

File.makeDirectory(directory+File.separator+"focused_gs");

for (nc=1; nc<=numCysts; nc++) {

	cystnum = toString(nc);
	
	open(toString(directory+"cropped/cyst"+toString(nc)+".tif")); 
	sliceInfo = "cyst"+cystnum+".csv";
	open(directory+sliceInfo);
	
	for (i=1; i<=lastTP; i++) {
		
		stack = getResult('Focus',i-1);
		
		if (stack == stackSize + 1){
			stack = stackSize;
		}

		
		zframe = toString(stack);
		
		selectWindow("cyst"+toString(nc)+".tif");
		run("Make Substack...", "slices="+zframe+" frames="+i);
	}
	
	selectWindow("cyst"+toString(nc)+".tif");
	close();
	run("Concatenate...", "all_open");
	saveAs("Tiff", directory+File.separator+"focused_gs"+File.separator+"cyst"+toString(nc)+"_focused.tif");
	close();
	close("cyst"+cystnum+".csv");
	
}

// binarize focused slides


File.makeDirectory(directory+File.separator+"binarized_gs");

for (nc=1; nc<=numCysts; nc++) {

	cystnum = toString(nc);
	
	open(toString(directory+"/focused_gs/cyst"+toString(nc)+"_focused.tif")); 

	run("Enhance Contrast...", "saturated=0.5 normalize process_all");
	run("Subtract Background...", "rolling=1 create disable stack");
	run("Find Edges", "stack");
	run("Gaussian Blur...", "sigma=2 scaled stack");
	setAutoThreshold("Default dark");
	
	setOption("BlackBackground", false);
	run("Convert to Mask", "method=Default background=Dark");
	
	run("Dilate", "stack");
	run("Dilate", "stack");
	run("Dilate", "stack");
		run("Fill Holes", "stack");
	run("Erode", "stack") ;
	run("Erode", "stack") ;
	run("Erode", "stack") ;

	run("Analyze Particles...", "size=1000-Infinity show=Masks display clear stack");
	
	selectWindow("Mask of cyst"+toString(nc)+"_focused.tif");
	saveAs("Tiff", directory+File.separator+"binarized_gs"+File.separator+"cyst"+toString(nc)+"_binarized.tif");
	close();
}

  macro "Close All Windows" { 
      while (nImages>0) {
          selectImage(nImages);
          close(); 
      } 
  } 