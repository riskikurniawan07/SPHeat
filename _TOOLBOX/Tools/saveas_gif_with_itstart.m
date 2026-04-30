function saveas_gif_with_itstart(savegif, savename, i, Nt, itstart, delayGif)

% SAVEAS GIF
if (savegif == 1)
    set(gcf,'renderer','zbuffer');
    gifname     = [savename,'.gif'];
    drawnow;
    frame       = getframe(gcf); % close;
    im          = frame2im(frame);
    [imind,cm] = rgb2ind(im,256,'nodither');
    if i==itstart 
        imwrite(imind,cm, gifname,'gif','DelayTime',delayGif,'loopcount',5);
    else
        imwrite(imind,cm, gifname,'gif' ,'DelayTime',delayGif, 'Writemode', 'append');
    end
    
    if i==Nt
        disp(['Save the animation as : ',savename,'.gif']);
    end
end
