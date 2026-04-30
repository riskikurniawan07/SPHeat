function particle = Neumann_BC(particle,numRealParticles,N,Lx,Ly,dx,dy,t)
    for i=numRealParticles+1:N
        if particle.x(i) < 0 && particle.y(i) > 0 && particle.y(i) < Ly%west
            idx = find(particle.x==dx/2 & particle.y==particle.y(i));
            particle.T(i) = particle.T(idx);
        elseif particle.x(i) > Lx && particle.y(i) > 0 && particle.y(i) < Ly %east
            idx = find(particle.x>=Lx-dx/2-1e-4 & particle.x<=Lx-dx/2+1e-4 & particle.y==particle.y(i));
            particle.T(i) = particle.T(idx);
        elseif particle.x(i) > 0 && particle.x(i) < Lx && particle.y(i) < 0 %south
            idx = find(particle.x==particle.x(i) & particle.y==dy/2);
            particle.T(i) = particle.T(idx);
        elseif particle.x(i) > 0 && particle.x(i) < Lx && particle.y(i) > Ly %north
            idx = find(particle.x==particle.x(i) & particle.y>=Ly-dy/2-1e-4 & particle.y<=Ly-dy/2+1e-4);
            particle.T(i) = particle.T(idx);
        elseif particle.x(i) < 0 && particle.y(i) < 0 %southwest
            idx = find(particle.x==particle.x(i) & particle.y==dy/2);
            particle.T(i) = particle.T(idx);
        elseif particle.x(i) < 0 && particle.y(i) > Ly %northwest
            idx = find(particle.x==particle.x(i) & particle.y>=Ly-dy/2-1e-4 & particle.y<=Ly-dy/2+1e-4);
            particle.T(i) = particle.T(idx);
        elseif particle.x(i) > Lx && particle.y(i) < 0 %southeast
            idx = find(particle.x>=Lx-dx/2-1e-4 & particle.x<=Lx-dx/2+1e-4 & particle.y==particle.y(i));
            particle.T(i) = particle.T(idx);
        else %northeast
            particle.T(i) = particle.T(i-1);
        end
    end
end