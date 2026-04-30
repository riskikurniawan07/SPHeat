function particle = Dirichlet_BC(particle,numRealParticles,N,Lx,Ly,dx,dy,t)
    for i=numRealParticles+1:N
        if particle.x(i) <= 0 || particle.x(i) >= Lx
            particle.T(i) = sin(pi*particle.y(i))*exp(-pi^2*particle.alpha*t);
        else
            particle.T(i) = sin(pi*particle.x(i))*exp(-pi^2*particle.alpha*t);
        end
    end
end