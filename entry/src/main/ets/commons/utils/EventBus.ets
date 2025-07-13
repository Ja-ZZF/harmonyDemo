// utils/EventBus.ts
export interface EventPayload {
  type: string;
  data?: string;
}

type EventCallback = (payload: EventPayload) => void;

export class EventBus {
  private listeners: Map<string, EventCallback[]> = new Map();

  on(event: string, callback: EventCallback): void {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, []);
    }
    this.listeners.get(event)?.push(callback);
  }

  emit(event: string, payload: EventPayload): void {
    this.listeners.get(event)?.forEach(callback => callback(payload));
  }
}

export const eventBus = new EventBus();
