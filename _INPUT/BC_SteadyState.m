function particle = SteadyState_BC(particle,numRealParticles,N,Lx,Ly,dx,dy,t)
    for i=numRealParticles+1:N
        if particle.y(i) >= Ly
            particle.T(i) = 400/pi*sin(pi*particle.x(i));
        else
            particle.T(i) = 0;
        end
    end
end