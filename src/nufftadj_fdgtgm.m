function im_est = nufftadj_fdgtgm(vis, st, h, D, M, S)

%the structure st is different for the NUFFT toolbox used to have the
%Kaiser-Bessel kernel in the interpolation matrix
Nx1=st.Nd(1);
Ny1=st.Nd(2);
Nx2=st.Kd(1);
Ny2=st.Kd(2);

%Gridding
vis2 = S'*vis;
vis2d = reshape(vis2, Ny2, Nx2);
spec = ifft2(vis2d);
%specd = bsxfun(@times, spec, D);
specd = D.* spec(:);
spec_est=M'*(h'*specd);
spec_est=reshape(spec_est,Ny2,Nx2);

%FFT: NO Quadrant swap before computing the IFFT
%spec_est = fftshift(spec_est1);
im21 = ifft2(spec_est);%*sqrt(Nx2*Ny2); Multiplying factor removed, because in the gassfwd_kbkern function 
% the normalisation of the FFT has been removed, 
% since the nufft_init function that we use to simulate v0 does not use the normalised FFT

%Cropping
%Find image first point (centered image): Note: No centered image while
%using the NUFFT package
%Zero padding done around the image, and image is not moved to the centre,
%because that's how the nufft_init function does it while simulating v0
% xo = floor(Nx2/2) - floor(Nx1/2);
% yo = floor(Ny2/2) - floor(Ny1/2);
xo = 0; yo = 0;
im_est = st.sn .* im21(yo+1:yo+Ny1,xo+1:xo+Nx1);