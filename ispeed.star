load("render.star", "render")
load("time.star", "time")

def main(config):
    # 1. Fetch the raw CSV string from the configuration parameter
    # Passed via: pixlet render speed.star -t data="2026-01-16T23:08:22Z,548912592,41435344"
    raw_text = config.get("data")
    
    if not raw_text:
        return render_full_screen("NO DATA", "#ff0000")

    # 2. Parse Data
    # Format: "TIMESTAMP,DOWNLOAD_BPS,UPLOAD_BPS"
    parts = raw_text.split(",")
    if len(parts) < 2:
        return render_full_screen("FORMAT ERR", "#ff0000")

    # 3. Parse Time & Expiration (90 minutes = 5400 seconds)
    data_time = time.parse_time(parts[0]).unix
    current_time = time.now().unix
    
    if (current_time - data_time) > 5400:
        return render_full_screen("NO VALUE", "#ff8800")

    # 4. Process Speed (Bits per second to Mb/s)
    bits_per_sec = float(parts[1])
    mbps = int(bits_per_sec / 1000000)

    # 5. Render Main UI
    return render.Root(
        child = render.Row(
            expanded=True,
            main_align="center",
            cross_align="center",
            children = [
                render_arrow(),
                render.Column(
                    cross_align="center",
                    children = [
                        render.Text(content=str(mbps), color="#00ff00", font="6x10"),
                        render.Text(content="Mb/s", color="#666", font="tb-8"),
                    ],
                ),
            ],
        )
    )

def render_arrow():
    return render.Animation(
        children = [
            render.Padding(pad=(0, 0, 2, 0), child=render.Text(content="↓", color="#00ff00")),
            render.Padding(pad=(0, 2, 2, 0), child=render.Text(content="↓", color="#00ff00")),
            render.Padding(pad=(0, 4, 2, 0), child=render.Text(content="↓", color="#00ff00")),
        ]
    )

def render_full_screen(msg, color):
    return render.Root(
        # child = render.Center(child = render.Text(content=msg, color=color))
        child = render.Text(content=msg, color=color)
    )
