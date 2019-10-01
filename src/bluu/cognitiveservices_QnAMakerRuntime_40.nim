
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
  Call_RuntimeGenerateAnswer_567880 = ref object of OpenApiRestCall_567658
proc url_RuntimeGenerateAnswer_567882(protocol: Scheme; host: string; base: string;
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

proc validate_RuntimeGenerateAnswer_567881(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_568055 = path.getOrDefault("kbId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "kbId", valid_568055
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

proc call*(call_568079: Call_RuntimeGenerateAnswer_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568079.validator(path, query, header, formData, body)
  let scheme = call_568079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568079.url(scheme.get, call_568079.host, call_568079.base,
                         call_568079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568079, url, valid)

proc call*(call_568150: Call_RuntimeGenerateAnswer_567880; kbId: string;
          generateAnswerPayload: JsonNode): Recallable =
  ## runtimeGenerateAnswer
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   generateAnswerPayload: JObject (required)
  ##                        : Post body of the request.
  var path_568151 = newJObject()
  var body_568153 = newJObject()
  add(path_568151, "kbId", newJString(kbId))
  if generateAnswerPayload != nil:
    body_568153 = generateAnswerPayload
  result = call_568150.call(path_568151, nil, nil, nil, body_568153)

var runtimeGenerateAnswer* = Call_RuntimeGenerateAnswer_567880(
    name: "runtimeGenerateAnswer", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/knowledgebases/{kbId}/generateAnswer",
    validator: validate_RuntimeGenerateAnswer_567881, base: "",
    url: url_RuntimeGenerateAnswer_567882, schemes: {Scheme.Https})
type
  Call_RuntimeTrain_568192 = ref object of OpenApiRestCall_567658
proc url_RuntimeTrain_568194(protocol: Scheme; host: string; base: string;
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

proc validate_RuntimeTrain_568193(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_568195 = path.getOrDefault("kbId")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "kbId", valid_568195
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

proc call*(call_568197: Call_RuntimeTrain_568192; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_RuntimeTrain_568192; kbId: string;
          trainPayload: JsonNode): Recallable =
  ## runtimeTrain
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   trainPayload: JObject (required)
  ##               : Post body of the request.
  var path_568199 = newJObject()
  var body_568200 = newJObject()
  add(path_568199, "kbId", newJString(kbId))
  if trainPayload != nil:
    body_568200 = trainPayload
  result = call_568198.call(path_568199, nil, nil, nil, body_568200)

var runtimeTrain* = Call_RuntimeTrain_568192(name: "runtimeTrain",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/knowledgebases/{kbId}/train", validator: validate_RuntimeTrain_568193,
    base: "", url: url_RuntimeTrain_568194, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
