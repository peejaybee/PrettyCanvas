jQuery ->
    x = 0
    vx = 0
    y = 0
    vy = 0
    t = 0
    thrust = 3
    vmax = 20
    gravity = 2

    framerate = 60
    frametimes = [0,0,0,0,0,0,0,0,0,0]
    
    radius = 20
    minRad = 5
    maxRad = 50

    hue = 180
    saturation = ",100%"
    lightness = ",50%"
    sl = saturation + lightness

    #periods in milliseconds
    movePeriod = 5000
    oscillatePeriod = 2000
    colorPeriod = 10000
    
    canvas = jQuery("#canvas")[0]
    context = canvas.getContext("2d")
    x = canvas.width / 2
    y = canvas.height / 2

    pickColor = ->
        hue = 180 + 180 * Math.sin((t % colorPeriod) / colorPeriod * 2 * Math.PI)
        
    pickRadius = ->
        radius = minRad + (minRad + maxRad) / 2 + (minRad + maxRad) / 2 * Math.sin((t % oscillatePeriod) / oscillatePeriod * 2 * Math.PI)

    
    setPosition = ->
        #acceleration from random thrust
        thetai = 2 * Math.PI * Math.random()
        ax = thrust * Math.cos(thetai)
        ay = thrust * Math.sin(thetai)
        
        #acceleration from "gravity"
        dx = x - canvas.width / 2
        dy = y - canvas.width / 2
        dist =  Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))
        ax -= gravity * dx / dist
        ay -= gravity * dy / dist
        
        #limit the maximum velocity by refusing to apply accelerations that will make it go faster
        vxp = vx + ax
        vyp = vy + ay
        if Math.sqrt(Math.pow(vxp ,2) + Math.pow(vyp ,2)) <= vmax
            vx = vxp
            vy = vyp
       
        #now move object according to the new velocity, wrapping around screen edges
        x += vx
        if x < 0
            x += canvas.width
        if x > canvas.width
            x -= canvas.width
        y += vy
        if y < 0
            y += canvas.height
        if y > canvas.height
            y -= canvas.height

    # probe wraps around actions to time them.
    #use this way:
    # probe ->
    #   action1
    #   action2
    #   action3
    # action4
    #
    # The total time for actions 1 through 3 will be measured and printed to the debug console
    probe = (x) ->
        probeStart  = new Date().getTime()
        x()
        probeEnd = new Date().getTime()
        probeTime = probeEnd - probeStart
        console.log "probe time " + probeTime
        
    drawFrame = ->
        context.clearRect(0, 0, canvas.width, canvas.height)
        context.beginPath()
        context.arc(x, y, radius , 0, 2 * Math.PI, false)
        grad = context.createRadialGradient(x,y,0,x,y,radius)
        grad.addColorStop(0,"hsla(" + hue + sl + ",1.0)")
        grad.addColorStop(.5,"hsla(" + hue + sl + ",1.0)")
        grad.addColorStop(1,"hsla(" + hue + sl + ",0.0)")
        context.fillStyle = grad
        context.fill()
    
    
    #Main method flow    
            
    setInterval =>
        now = new Date()
        t = now.getTime()
        pickColor()
        pickRadius()
        setPosition()
        drawFrame()
        frametimes[0..8] = frametimes[1..9]
        frametimes[9] = t
        measured_framerate = 10000 / (frametimes[9] - frametimes[0])
        jQuery("#framecounter").text( "FPS: " + measured_framerate)

    , 1000 / framerate
    