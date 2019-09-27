
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: QnAMaker Runtime Client
## version: 4.0
## termsOfService: (not provided)
## license: (not provided)
## 
## An API for QnAMaker runtime
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "cognitiveservices-QnAMakerRuntime"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RuntimeGenerateAnswer_593647 = ref object of OpenApiRestCall_593425
proc url_RuntimeGenerateAnswer_593649(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "kbId" in path, "`kbId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/knowledgebases/"),
               (kind: VariableSegment, value: "kbId"),
               (kind: ConstantSegment, value: "/generateAnswer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeGenerateAnswer_593648(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_593822 = path.getOrDefault("kbId")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "kbId", valid_593822
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   generateAnswerPayload: JObject (required)
  ##                        : Post body of the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593846: Call_RuntimeGenerateAnswer_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593846.validator(path, query, header, formData, body)
  let scheme = call_593846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593846.url(scheme.get, call_593846.host, call_593846.base,
                         call_593846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593846, url, valid)

proc call*(call_593917: Call_RuntimeGenerateAnswer_593647; kbId: string;
          generateAnswerPayload: JsonNode): Recallable =
  ## runtimeGenerateAnswer
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   generateAnswerPayload: JObject (required)
  ##                        : Post body of the request.
  var path_593918 = newJObject()
  var body_593920 = newJObject()
  add(path_593918, "kbId", newJString(kbId))
  if generateAnswerPayload != nil:
    body_593920 = generateAnswerPayload
  result = call_593917.call(path_593918, nil, nil, nil, body_593920)

var runtimeGenerateAnswer* = Call_RuntimeGenerateAnswer_593647(
    name: "runtimeGenerateAnswer", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/knowledgebases/{kbId}/generateAnswer",
    validator: validate_RuntimeGenerateAnswer_593648, base: "",
    url: url_RuntimeGenerateAnswer_593649, schemes: {Scheme.Https})
type
  Call_RuntimeTrain_593959 = ref object of OpenApiRestCall_593425
proc url_RuntimeTrain_593961(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "kbId" in path, "`kbId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/knowledgebases/"),
               (kind: VariableSegment, value: "kbId"),
               (kind: ConstantSegment, value: "/train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RuntimeTrain_593960(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_593962 = path.getOrDefault("kbId")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "kbId", valid_593962
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   trainPayload: JObject (required)
  ##               : Post body of the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_RuntimeTrain_593959; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_RuntimeTrain_593959; kbId: string;
          trainPayload: JsonNode): Recallable =
  ## runtimeTrain
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   trainPayload: JObject (required)
  ##               : Post body of the request.
  var path_593966 = newJObject()
  var body_593967 = newJObject()
  add(path_593966, "kbId", newJString(kbId))
  if trainPayload != nil:
    body_593967 = trainPayload
  result = call_593965.call(path_593966, nil, nil, nil, body_593967)

var runtimeTrain* = Call_RuntimeTrain_593959(name: "runtimeTrain",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/knowledgebases/{kbId}/train", validator: validate_RuntimeTrain_593960,
    base: "", url: url_RuntimeTrain_593961, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
