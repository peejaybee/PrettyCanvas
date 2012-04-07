jQuery ->
    x = 0
    vx = 0
    y = 0
    vy = 0
    t = 0
    thrust = 1
    vmax = 20

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
    colorPeriod = 1000
    
    canvas = jQuery("#canvas")[0]
    context = canvas.getContext("2d")
#    context.strokeStyle = "#fff"
#    context.fillStyle = "#fff"

    pickColor = ->
        hue = 180 + 180 * Math.sin((t % colorPeriod) / colorPeriod * 2 * Math.PI)
        
    pickRadius = ->
        radius = minRad + (minRad + maxRad) / 2 + (minRad + maxRad) / 2 * Math.sin((t % oscillatePeriod) / oscillatePeriod * 2 * Math.PI)

    
    setPosition = ->
        theta = 2 * Math.PI * Math.random()
        vxp = vx + thrust * Math.cos(theta)
        vyp = vy + thrust * Math.sin(theta)
        
        if Math.sqrt(Math.pow(vxp ,2) + Math.pow(vyp ,2)) <= vmax
            vx = vxp
            vy = vyp
       
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
 #       alert "I'm helping!"
        
    x = canvas.width / 2
    y = canvas.height / 2
            
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
    