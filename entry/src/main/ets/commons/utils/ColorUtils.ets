//颜色相关的功能

//随机生成颜色
export function generateRandomColor(): string {
  const hexChars = "0123456789ABCDEF";
  let color = "#";
  for (let i = 0; i < 6; i++) {
    // 从hexChars中随机选取字符并添加到color变量
    color += hexChars.charAt(Math.floor(Math.random() * hexChars.length));
  }
  return color;
}
