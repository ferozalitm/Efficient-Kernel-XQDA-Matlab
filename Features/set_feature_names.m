function [ param ] = set_feature_names( lf_type )
% set default parameter 

    switch lf_type
        case 1
            lf_name = 'yMthetaRGB';
        case 2
            lf_name = 'yMthetaLab';
        case 3
            lf_name = 'yMthetaHSV';
        case 4
            lf_name = 'yMthetanRnG';
        otherwise
            fprintf('lf_type = %d is not defined', lf_type);
    end

    param.name = strcat('GOG', lf_name);
end

