% Clear all variables.
clearvars

% These are used for determining the state of the button to run or reset the animation.
global button_state
global abort

% Set the default values of the parameters.
button_state=0;
abort=0;
seed=0;
time_max = 80;
time_increment = 0.2;
time_next = time_increment;
time = 0;
delay = 50;
N = 100;
color_X=0xFF0000;
color_Y=0x00FF00;
color_Z=0x0000FF;

% These are used for positioning controls in the uifigure.
vertical_offset=40;
b=275;

% This is used for positioning the uifigure.
a=get(groot,"ScreenSize");

% Create the uifigure.
fig=uifigure("Name","3d Corner Growth: Parameters","Position",[a(3)-400 a(4)-400 375 340]);

% Create the labels and text boxes.
uilabel(fig,"Position",[20 fig.Position(4)-vertical_offset 250 22],"Text","Pseudorandom number seed (hexadecimal):");
text_prng_seed=uitextarea(fig,"Position",[b fig.Position(4)-vertical_offset 80 22],"Value",num2str(seed));
uilabel(fig,"Position",[20 fig.Position(4)-vertical_offset-30 250 22],"Text","Linear size of the axes:");
text_N=uitextarea(fig,"Position",[b fig.Position(4)-vertical_offset-30 80 22],"Value",num2str(N));
uilabel(fig,"Position",[20 fig.Position(4)-vertical_offset-60 250 22],"Text","Maximum time of the simulation:");
text_time_max=uitextarea(fig,"Position",[b fig.Position(4)-vertical_offset-60 80 22],"Value",num2str(time_max));
uilabel(fig,"Position",[20 fig.Position(4)-vertical_offset-85 250 22],"Text","Time step of the simulation:");
text_time_increment=uitextarea(fig,"Position",[b fig.Position(4)-vertical_offset-85 80 22],"Value",num2str(time_increment));
uilabel(fig,"Position",[20 fig.Position(4)-vertical_offset-115 250 22],"Text","Time between frames of the animation (ms):");
text_delay=uitextarea(fig,"Position",[b fig.Position(4)-vertical_offset-115 80 22],"Value",num2str(delay));
uilabel(fig,"Position",[20 fig.Position(4)-vertical_offset-145 250 22],"Text","Color of X faces (hexadecimal):");
text_color_X=uitextarea(fig,"Position",[b fig.Position(4)-vertical_offset-145 80 22],"Value",num2str(color_X,'%06X'));
uilabel(fig,"Position",[20 fig.Position(4)-vertical_offset-170 250 22],"Text","Color of Y faces (hexadecimal):");
text_color_Y=uitextarea(fig,"Position",[b fig.Position(4)-vertical_offset-170 80 22],"Value",num2str(color_Y,'%06X'));
uilabel(fig,"Position",[20 fig.Position(4)-vertical_offset-195 250 22],"Text","Color of Z faces (hexadecimal):");
text_color_Z=uitextarea(fig,"Position",[b fig.Position(4)-vertical_offset-195 80 22],"Value",num2str(color_Z,'%06X'));

% Create the check box.
chk=uicheckbox(fig,"Position",[20 fig.Position(4)-vertical_offset-230 135 22],"Text","Show edges of cubes","Value",1);

% Create the buttons.
cambtn=uibutton(fig,"Position",[20 20 150 30],"ButtonPushedFcn",@(src,event) CameraButtonPushed(N),"Text","Reset Camera Position");
btn=uibutton(fig,"Position",[205 20 150 30],"Text","Run Simulation");
set(btn,"ButtonPushedFcn",@(src,event) ButtonPushed(btn,cambtn,N,text_prng_seed,text_N,text_time_max,text_time_increment,text_delay,text_color_X,text_color_Y,text_color_Z,chk))

% Create the figure window.
figure("Name","3d Corner Growth")
set(gcf, 'Position', get(0, 'Screensize'));

% Create the axes.
set_axis(N)

% Set the default camera position.
campos([2*N 2*N 2*N])

% Initialize the pseudorandom number generator.
rng("default")

function set_axis(N)

    % Set up the axes.

    axis('off', 'equal', [0 N 0 N 0 N])

    line([0 0],[0 4*N/5],[N/5 N/5],'Color','k','LineStyle','--');
    line([0 0],[0 3*N/5],[2*N/5 2*N/5],'Color','k','LineStyle','--');
    line([0 0],[0 2*N/5],[3*N/5 3*N/5],'Color','k','LineStyle','--');
    line([0 0],[0 N/5],[4*N/5 4*N/5],'Color','k','LineStyle','--');
    line([0 0],[N/5 N/5],[0 4*N/5],'Color','k','LineStyle','--');
    line([0 0],[2*N/5 2*N/5],[0 3*N/5],'Color','k','LineStyle','--');
    line([0 0],[3*N/5 3*N/5],[0 2*N/5],'Color','k','LineStyle','--');
    line([0 0],[4*N/5 4*N/5],[0 N/5],'Color','k','LineStyle','--');

    line([0 4*N/5],[N/5 N/5],[0 0],'Color','k','LineStyle','--');
    line([0 3*N/5],[2*N/5 2*N/5],[0 0],'Color','k','LineStyle','--');
    line([0 2*N/5],[3*N/5 3*N/5],[0 0],'Color','k','LineStyle','--');
    line([0 N/5],[4*N/5 4*N/5],[0 0],'Color','k','LineStyle','--');
    line([N/5 N/5],[0 4*N/5],[0 0],'Color','k','LineStyle','--');
    line([2*N/5 2*N/5],[0 3*N/5],[0 0],'Color','k','LineStyle','--');
    line([3*N/5 3*N/5],[0 2*N/5],[0 0],'Color','k','LineStyle','--');
    line([4*N/5 4*N/5],[0 N/5],[0 0],'Color','k','LineStyle','--');

    line([N/5 N/5],[0 0],[0 4*N/5],'Color','k','LineStyle','--');
    line([2*N/5 2*N/5],[0 0],[0 3*N/5],'Color','k','LineStyle','--');
    line([3*N/5 3*N/5],[0 0],[0 2*N/5],'Color','k','LineStyle','--');
    line([4*N/5 4*N/5],[0 0],[0 N/5],'Color','k','LineStyle','--');
    line([0 4*N/5],[0 0],[N/5 N/5],'Color','k','LineStyle','--');
    line([0 3*N/5],[0 0],[2*N/5 2*N/5],'Color','k','LineStyle','--');
    line([0 2*N/5],[0 0],[3*N/5 3*N/5],'Color','k','LineStyle','--');
    line([0 N/5],[0 0],[4*N/5 4*N/5],'Color','k','LineStyle','--');

    axis off
    axis([0 N 0 N 0 N])
    set(gca,'Projection','orthographic')
    patch([0 0 0 0],[0 N 0 0],[0 0 N 0],[0.9 0.9 0.9],'FaceAlpha',0.5)
    patch([0 0 N 0],[0 0 0 0],[0 N 0 0],[0.9 0.9 0.9],'FaceAlpha',0.5)
    patch([0 N 0 0],[0 0 N 0],[0 0 0 0],[0.9 0.9 0.9],'FaceAlpha',0.5)
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
    set(gca,'ZTickLabel',[])
    set(gca,'TickLength',[0 0])

end

function run_status = run(N,time_max,time_increment,delay,colorX,colorY,colorZ,edges)

    % Run the animation.

    global button_state
    global abort

    time_next=time_increment;
    time=0;

    h = zeros (N, N);
    h_map = zeros (N, N);
    h_map(1,1) = 1;
    h_list = zeros (1, N*N);
    h_list(1,1) = 0;
    h_list_size = 1;

    loop_index=1;

    while time<time_max

        % Determine which height variable is to be incremented.
        h_list_index = fix(rand*h_list_size)+1;

        % Determine the (x,y) coordinates of the height variable to be incremented.
        x = mod(h_list(1,h_list_index),N);
        y = (h_list(1,h_list_index)-x)/N;

        % Check if the interface grew too big.
        if x==N-2 || y==N-2 || (x==0 && y==0 && h(1,1)==N-2)
            run_status=2;
            return;
        end

        % Save the (x,y,z) coordinates of the next cube.
        steps(1,loop_index)=h_list(1,h_list_index);
        steps_z(1,loop_index)=h(x+1,y+1);
        steps_time(1,loop_index)=time;

        % Increment the selected height variable.
        h(x+1,y+1)=h(x+1,y+1)+1;

        % Check if the height at (x,y) became inactive.
        if (x==0 && y>0 && h(x+1,y)==h(x+1,y+1)) || (x>0 && y==0 && h(x,y+1)==h(x+1,y+1)) || (x>0 && y>0 && (h(x+1,y)==h(x+1,y+1) || h(x,y+1)==h(x+1,y+1)))

            % If so, then delete its location in h_list.
            x_temp = mod(h_list(1,h_list_size),N);
            y_temp = (h_list(1,h_list_size)-x_temp)/N;
            h_map(x_temp+1,y_temp+1)=h_list_index;
            h_list(1,h_list_index)=h_list(1,h_list_size);
            h_list_size=h_list_size-1;
            h_map(x+1,y+1)=0;

        end

        % Check if the height at (x+1,y) became active.
        if h_map(x+2,y+1)==0 && (y==0 || (y>0 && h(x+2,y)>h(x+2,y+1)))

            % If so, then add its location to h_list.
            h_list_size=h_list_size+1;
            h_list(1,h_list_size)=(x+1)+y*N;
            h_map(x+2,y+1)=h_list_size;

        end
    
        % Check if the height at (x,y+1) became active.
        if h_map(x+1,y+2)==0 && (x==0 || (x>0 && h(x,y+2)>h(x+1,y+2)))

            % If so, then add its location to h_list.
            h_list_size=h_list_size+1;
            h_list(1,h_list_size)=x+(y+1)*N;
            h_map(x+1,y+2)=h_list_size;

        end

        % Update the time elapsed.
        time = time - log(1-rand)/h_list_size;

        loop_index=loop_index+1;

    end

    pause on

    for i=1:loop_index-1

        % Determine the coordinates where the next cube was added.
        x = mod(steps(1,i),N);
        y = (steps(1,i)-x)/N;
        z = steps_z(1,i);

        % Determine the face colors.
        veccolorZ=[bitshift(colorZ,-16)/255 bitshift(bitand(colorZ,65535),-8)/255 bitand(colorZ,255)/255];
        veccolorX=[bitshift(colorX,-16)/255 bitshift(bitand(colorX,65535),-8)/255 bitand(colorX,255)/255];
        veccolorY=[bitshift(colorY,-16)/255 bitshift(bitand(colorY,65535),-8)/255 bitand(colorY,255)/255];

        % Update the patches to show the new cube.
        if z==0
            patch([x x+1 x+1 x], [y y y+1 y+1], [z z z z], veccolorZ, 'EdgeAlpha', edges)
            z_handle(x+1,y+1) = patch([x x+1 x+1 x], [y y y+1 y+1], [z+1 z+1 z+1 z+1], veccolorZ, 'EdgeAlpha', edges);
        else
            z_handle(x+1,y+1).ZData = [z+1,z+1,z+1,z+1];
        end
        if x==0
            patch([x x x x], [y y+1 y+1 y], [z z z+1 z+1], veccolorX, 'EdgeAlpha', edges)
            x_handle(y+1,z+1) = patch([x+1 x+1 x+1 x+1], [y y+1 y+1 y], [z z z+1 z+1], veccolorX, 'EdgeAlpha', edges);
        else
            x_handle(y+1,z+1).XData = [x+1,x+1,x+1,x+1];
        end
        if y==0
            patch([x x x+1 x+1], [y y y y], [z z+1 z+1 z], veccolorY, 'EdgeAlpha', edges)
            y_handle(z+1,x+1) = patch([x x x+1 x+1], [y+1 y+1 y+1 y+1], [z z+1 z+1 z], veccolorY, 'EdgeAlpha', edges);
        else
            y_handle(z+1,x+1).YData = [y+1,y+1,y+1,y+1];
        end

        % Show the frames of the animation.
        while steps_time(1,i)>time_next
            pause(delay)
            drawnow
            time_next=time_next+time_increment;
        end

        % Check if the button to abort the animation was clicked.
        if abort==1
            run_status=1;
            return;
        end
    end

    % This indicates that the animation is complete.
    run_status=0;

end

function ButtonPushed(btn,cambtn,N,text_prng_seed,text_N,text_time_max,text_time_increment,text_delay,text_color_X,text_color_Y,text_color_Z,chk)

    global button_state
    global abort

    if button_state==0

        % Get the parameters, and check if they are within acceptable values.

        seed=str2double(strcat('0x',text_prng_seed.Value));
        if isnan(seed) || (~isnan(seed) && (seed<0 || seed>0xFFFFFFFF))
            set(cambtn,'Enable','off')
            set(btn,'Enable','off')
            waitfor(msgbox('The pseudorandom number seed must be >= 0 and <= FFFFFFFF (in hexadecimal).','Error'))
            set(btn,'Enable','on')
            set(cambtn,'Enable','on')
            return
        end
        rng(seed)

        N=str2double(text_N.Value);
        if isnan(N) || (~isnan(N) && (N<10 || N>200))
            set(cambtn,'Enable','off')
            set(btn,'Enable','off')
            waitfor(msgbox('The linear size of the axes must be >= 10 and <= 200.','Error'))
            set(btn,'Enable','on')
            set(cambtn,'Enable','on')
            return
        end
        camera_position=campos;
        delete(gca)
        set_axis(N)
        campos(camera_position)

        time_max=str2double(text_time_max.Value);
        if isnan(time_max) || (~isnan(time_max) && time_max<0)
            set(cambtn,'Enable','off')
            set(btn,'Enable','off')
            waitfor(msgbox('The maximum time of the simulation must be positive.','Error'))
            set(btn,'Enable','on')
            set(cambtn,'Enable','on')
            return
        end

        time_increment=str2double(text_time_increment.Value);
        if isnan(time_increment) || (~isnan(time_increment) && time_increment<0)
            set(cambtn,'Enable','off')
            set(btn,'Enable','off')
            waitfor(msgbox('The time step of the simulation must be positive.','Error'))
            set(btn,'Enable','on')
            set(cambtn,'Enable','on')
            return
        end

        delay=str2double(text_delay.Value)/1000;
        if isnan(delay) || (~isnan(delay) && (delay<0.001 || delay>10))
            set(cambtn,'Enable','off')
            set(btn,'Enable','off')
            waitfor(msgbox('The time between frames of the animation must be >= 1 and <= 10000 (in milliseconds).','Error'))
            set(btn,'Enable','on')
            set(cambtn,'Enable','on')
            return
        end

        colorX=str2double(strcat('0x',text_color_X.Value));
        if isnan(colorX) || (~isnan(colorX) && (colorX<0 || colorX>0xFFFFFF))
            set(cambtn,'Enable','off')
            set(btn,'Enable','off')
            waitfor(msgbox('The color of X faces must be >= 0 and <= FFFFFF (in hexadecimal).','Error'))
            set(btn,'Enable','on')
            set(cambtn,'Enable','on')
            return
        end

        colorY=str2double(strcat('0x',text_color_Y.Value));
        if isnan(colorY) || (~isnan(colorY) && (colorY<0 || colorY>0xFFFFFF))
            set(cambtn,'Enable','off')
            set(btn,'Enable','off')
            waitfor(msgbox('The color of Y faces must be >= 0 and <= FFFFFF (in hexadecimal).','Error'))
            set(btn,'Enable','on')
            set(cambtn,'Enable','on')
            return
        end

        colorZ=str2double(strcat('0x',text_color_Z.Value));
        if isnan(colorZ) || (~isnan(colorZ) && (colorZ<0 || colorZ>0xFFFFFF))
            set(cambtn,'Enable','off')
            set(btn,'Enable','off')
            waitfor(msgbox('The color of Z faces must be >= 0 and <= FFFFFF (in hexadecimal).','Error'))
            set(btn,'Enable','on')
            set(cambtn,'Enable','on')
            return
        end

        % This indicates that the animation is in progress.
        button_state=1;

        set(btn,'Text','Reset Simulation')

        % Run the animation.
        run_status = run(N,time_max,time_increment,delay,colorX,colorY,colorZ,double(chk.Value));

        % Check if the simulation finished successfully.
        if run_status==0

            button_state=2;

        % Check if the simulation was aborted.
        elseif run_status==1

            % Redraw the axes.
            camera_position=campos;
            delete(gca)
            set_axis(N)
            campos(camera_position)

            % This indicates that the animation has been reset.
            abort=0;
            button_state=0;
            
        % Check if the interface grew too big.
        else

            set(cambtn,'Enable','off')
            set(btn,'Enable','off')
            waitfor(msgbox('The maximum time of the simulation was too large relative to the linear size of the axes.','Error'))
            set(btn,'Enable','on')
            set(cambtn,'Enable','on')

            button_state=0;

        end

        if button_state==0
            set(btn,'Text','Run Simulation')
        end

    elseif button_state==1

        % This indicates that the animation is to be reset.
        abort=1;

    else

        % Redraw the axes.
        camera_position=campos;
        delete(gca)
        set_axis(N)
        campos(camera_position)

        set(btn,'Text','Run Simulation')

        % This indicates that the animation has been reset.
        button_state=0;
    end

end

function CameraButtonPushed(N)

    % Set the default camera position.
    campos([2*N 2*N 2*N])

end
