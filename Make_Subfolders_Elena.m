function Make_Subfolders_Elena(subfolder)
[~,foldername,~]=fileparts(subfolder);
    GFP_output=fullfile(subfolder,[foldername,'_GFP']);
    if ~isfolder(GFP_output);
    mkdir (GFP_output);
    end
    TRITC_output=fullfile(subfolder,[foldername,'_TRITC']);
    if ~isfolder(TRITC_output);
    mkdir (TRITC_output);
    end
%     Cy5_output=fullfile(subfolder,[foldername,'_Cy5']);
%     if ~isfolder(Cy5_output);
%     mkdir (Cy5_output);
%     end
    DIC_output=fullfile(subfolder,[foldername,'_DIC']);
    if ~isfolder(DIC_output);
    mkdir (DIC_output);
    end
    nuc_output=fullfile(subfolder,[foldername,'_Nuc_Mask']);
    if ~isfolder(nuc_output);
    mkdir (nuc_output);
    end
    DIC_Contrast_output=fullfile(subfolder,[foldername,'_DIC_Contrast']);
    if ~isfolder(DIC_Contrast_output);
    mkdir (DIC_Contrast_output);
    end
    JV_output=fullfile(subfolder,[foldername,'_JV']);
    if ~isfolder(JV_output);
    mkdir (JV_output);
    end

end