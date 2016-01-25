function Ball(radius, color, bordercolor) {
    if (radius === undefined) {
        radius = 40;
    }
    if (color === undefined) {
        color = "#ff0000";
    }
    this.x = 0;
    this.y = 0;
    this.radius = radius;
    this.vx = 0;
    this.vy = 0;
    this.mass = Math.floor(this.radius / 4);
    this.rotation = 0;
    this.scaleX = 1;
    this.scaleY = 1;
//    this.shadowOffset = 0;
    this.color = utils.parseColor(color);
    this.strokeStyle = utils.parseColor(bordercolor);
    this.shadowBlur = Math.floor(this.radius)*2;
    this.shadowColor = this.strokeStyle;
    this.lineWidth = 1;
}

Ball.prototype.draw = function (context) {
    context.save();
    context.translate(this.x, this.y);
    context.rotate(this.rotation);
    context.scale(this.scaleX, this.scaleY);
    context.lineWidth = this.lineWidth;
    context.fillStyle = this.color;
    context.strokeStyle = this.strokeStyle;
    context.shadowBlur = this.shadowBlur;
   /* context.shadowOffsetX = this.shadowOffset;
    context.shadowOffsetY = this.shadowOffset;*/
    context.shadowColor = this.shadowColor;
    context.beginPath();
    context.arc(0, 0, this.radius, 0, (Math.PI * 2), true);
    context.closePath();
    context.stroke();
    context.fill();
    context.restore();
};

Ball.prototype.getBounds = function () {
    return {
        x: this.x - this.radius,
        y: this.y - this.radius,
        width: this.radius * 2,
        height: this.radius * 2
    };
};
