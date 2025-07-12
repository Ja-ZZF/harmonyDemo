// commons/timeUtils.ets

export function formatTime(date: Date): string {
  const d = new Date(date);
  const year = d.getFullYear();
  const month = d.getMonth() + 1;
  const day = d.getDate();
  const hour = d.getHours().toString().padStart(2, '0');
  const minute = d.getMinutes().toString().padStart(2, '0');
  return `${year}-${month}-${day} ${hour}:${minute}`;
}

export function formatSmartTime(date: Date): string {
  const now = new Date();

  const target = new Date(date);
  const isSameDay = now.getFullYear() === target.getFullYear()
    && now.getMonth() === target.getMonth()
    && now.getDate() === target.getDate();

  // 昨天
  const yesterday = new Date(now);
  yesterday.setDate(now.getDate() - 1);
  const isYesterday = target.getFullYear() === yesterday.getFullYear()
    && target.getMonth() === yesterday.getMonth()
    && target.getDate() === yesterday.getDate();

  if (isSameDay) {
    const h = target.getHours().toString().padStart(2, '0');
    const m = target.getMinutes().toString().padStart(2, '0');
    return `${h}:${m}`;
  } else if (isYesterday) {
    return '昨天';
  } else {
    const y = target.getFullYear();
    const m = (target.getMonth() + 1).toString().padStart(2, '0');
    const d = target.getDate().toString().padStart(2, '0');
    return `${y}-${m}-${d}`;
  }
}
