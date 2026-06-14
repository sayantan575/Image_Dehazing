function depth = Depth_Map(t)
    t = max(t, 0.1);
    depth = -log(t);
    depth = mat2gray(depth);
end
