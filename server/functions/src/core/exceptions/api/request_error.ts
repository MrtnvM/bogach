export class RequestError implements Error {
  constructor(public name: string, public message: string) {}
}
