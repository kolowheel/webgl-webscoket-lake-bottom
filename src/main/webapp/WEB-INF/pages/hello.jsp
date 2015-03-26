<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <style>
        body {
            color: #61443e;
            font-family: Monospace;
            font-size: 13px;
            text-align: center;

            background-color: #bfd1e5;
            margin: 0px;
            overflow: hidden;
        }

        #info {
            position: absolute;
            top: 0px;
            width: 100%;
            padding: 5px;
        }

        a {

            color: #a06851;
        }

    </style>
</head>
<body>
<di>
    <label>
        <input type="text" id="dnoId" value="1"/>
    </label>
    <label>
        <input type="text" id="soundSpeed" value="340"/>
    </label>
    <input type="button" onclick="sendDataOverSocket()" value="Get dno"/>
</di>
<div id="container"><br/><br/><br/><br/><br/>Generating world...</div>

<script src="http://threejs.org/build/three.min.js"></script>

<script src="http://threejs.org/examples/js/controls/OrbitControls.js"></script>

<script src="http://threejs.org/examples/js/ImprovedNoise.js"></script>
<script src="http://threejs.org/examples/js/Detector.js"></script>
<script src="http://threejs.org/examples/js/libs/stats.min.js"></script>
<script>
function draw(worldWidth, worldDepth, data1) {
    document.getElementById('container').innerHTML = "";


    var container, stats;

    var camera, controls, scene, renderer;

    var mesh, texture;

    // var worldWidth = 512, worldDepth = 512,
    var worldHalfWidth = worldWidth / 2, worldHalfDepth = worldDepth / 2;

    var clock = new THREE.Clock();
    // var data;
    var shouldSphereFollowMouse = true;
    var helper;

    init();
    animate();

    function init() {

        container = document.getElementById('container');

        camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 1, 20000);

        scene = new THREE.Scene();

        controls = new THREE.OrbitControls(camera);
        controls.center.set(0.0, 100.0, 0.0);
        controls.userPanSpeed = 100;

        var data = new Uint8Array(data1);
       // data = generateHeight(worldWidth,worldDepth);
        controls.center.y = data[ worldHalfWidth + worldHalfDepth * worldWidth ] + 500;
        camera.position.y = controls.center.y + 2000;
        camera.position.x = 2000;

        var geometry = new THREE.PlaneGeometry(7500, 7500, worldWidth - 1, worldDepth - 1);
        geometry.applyMatrix(new THREE.Matrix4().makeRotationX(-Math.PI / 2));

        for (var i = 0, l = geometry.vertices.length; i < l; i++) {

            geometry.vertices[ i ].y = data[ i ] * 10;

         }

        geometry.computeFaceNormals();

        texture = new THREE.Texture(generateTexture(data, worldWidth, worldDepth), new THREE.UVMapping(), THREE.ClampToEdgeWrapping, THREE.ClampToEdgeWrapping);
        texture.needsUpdate = true;

        ///* new THREE.MeshBasicMaterial({ map: texture })*/
        mesh = new THREE.Mesh(geometry, new THREE.MeshBasicMaterial({ map: texture }));
        scene.add(mesh);

        var geometry = new THREE.CylinderGeometry(0, 20, 100, 3);
        geometry.applyMatrix(new THREE.Matrix4().makeTranslation(0, 50, 0));
        geometry.applyMatrix(new THREE.Matrix4().makeRotationX(Math.PI / 2));
        helper = new THREE.Mesh(geometry, new THREE.MeshNormalMaterial());
        scene.add(helper);

        renderer = new THREE.WebGLRenderer();
        renderer.setClearColor(0xbfd1e5);
        renderer.setSize(window.innerWidth, window.innerHeight);

        container.innerHTML = "";

        container.appendChild(renderer.domElement);
        container.addEventListener('mousemove', onMouseMove, false);

        stats = new Stats();
        stats.domElement.style.position = 'absolute';
        stats.domElement.style.top = '0px';
        container.appendChild(stats.domElement);
        var light = new THREE.AmbientLight( 0x404040 ); // soft white light
        scene.add( light );

        //

//        window.addEventListener('resize', onWindowResize, false);

    }


    function generateTexture(data, width, height) {

        var canvas, canvasScaled, context, image, imageData,
                level, diff, vector3, sun, shade;

        vector3 = new THREE.Vector3(0, 0, 0);

        sun = new THREE.Vector3(1, 1, 1);
        sun.normalize();

        canvas = document.createElement('canvas');
        canvas.width = width;
        canvas.height = height;

        context = canvas.getContext('2d');
        context.fillStyle = '#000';
        context.fillRect(0, 0, width, height);

        image = context.getImageData(0, 0, canvas.width, canvas.height);
        imageData = image.data;

        for (var i = 0, j = 0, l = imageData.length; i < l; i += 4, j++) {

            vector3.x = data[ j - 2 ] - data[ j + 2 ];
            vector3.y = 2;
            vector3.z = data[ j - width * 2 ] - data[ j + width * 2 ];
            vector3.normalize();

            shade = vector3.dot(sun);

            imageData[ i ] = ( 96 + shade * 128 ) * ( 0.5 + data[ j ] * 0.007 );
            imageData[ i + 1 ] = ( 32 + shade * 96 ) * ( 0.5 + data[ j ] * 0.007 );
            imageData[ i + 2 ] = ( shade * 96 ) * ( 0.5 + data[ j ] * 0.007 );
        }

        context.putImageData(image, 0, 0);

        // Scaled 4x

        canvasScaled = document.createElement('canvas');
        canvasScaled.width = width * 4;
        canvasScaled.height = height * 4;

        context = canvasScaled.getContext('2d');
        context.scale(4, 4);
        context.drawImage(canvas, 0, 0);

        image = context.getImageData(0, 0, canvasScaled.width, canvasScaled.height);
        imageData = image.data;

        for (var i = 0, l = imageData.length; i < l; i += 4) {

            var v = ~~( Math.random() * 5 );

            imageData[ i ] += v;
            imageData[ i + 1 ] += v;
            imageData[ i + 2 ] += v;

        }

        context.putImageData(image, 0, 0);

        return canvasScaled;

    }

//

    function animate() {

        requestAnimationFrame(animate);

        render();
        stats.update();

    }

    function render() {

        controls.update(clock.getDelta());
        renderer.render(scene, camera);

    }

    function onMouseMove(event) {

        if (shouldSphereFollowMouse) {

            var mouseX = ( event.clientX / window.innerWidth ) * 2 - 1;
            var mouseY = -( event.clientY / window.innerHeight ) * 2 + 1;

            var vector = new THREE.Vector3(mouseX, mouseY, camera.near);

            // Convert the [-1, 1] screen coordinate into a world coordinate on the near plane
            var projector = new THREE.Projector();
            projector.unprojectVector(vector, camera);

            var raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());

            // See if the ray from the camera into the world hits one of our meshes
            var intersects = raycaster.intersectObject(mesh);
            lastIntersects = intersects;

            // Toggle rotation bool for meshes that we clicked
            if (intersects.length > 0) {

                helper.position.set(0, 0, 0);
                helper.lookAt(intersects[ 0 ].face.normal);

                helper.position.copy(intersects[ 0 ].point);

            }
        }
    }
}

function sendDataOverSocket() {
    var websocket = new WebSocket("ws://localhost:8089/myHandler")
    websocket.onmessage = function (onj) {
        try {
            var input = JSON.parse(onj.data);

        }
        catch (err) {
            console.log(onj.length)
            document.getElementById("demo").innerHTML = err.message;
        }

        console.log(input.data);
        input.data.splice(0,0,100);
        draw(input.width, input.length, input.data);
    };
    websocket.onopen = function () {
        websocket.send(JSON.stringify({"id": document.getElementById("dnoId").value, "soundSpeed":document.getElementById("soundSpeed").value}))
    }
}

</script>
</body>
</html>
