
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: QnAMaker Client
## version: 4.0
## termsOfService: (not provided)
## license: (not provided)
## 
## An API for QnAMaker Service
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
  macServiceName = "cognitiveservices-QnAMaker"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AlterationsReplace_568117 = ref object of OpenApiRestCall_567658
proc url_AlterationsReplace_568119(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlterationsReplace_568118(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   wordAlterations: JObject (required)
  ##                  : New alterations data.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568176: Call_AlterationsReplace_568117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568176.validator(path, query, header, formData, body)
  let scheme = call_568176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568176.url(scheme.get, call_568176.host, call_568176.base,
                         call_568176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568176, url, valid)

proc call*(call_568177: Call_AlterationsReplace_568117; wordAlterations: JsonNode): Recallable =
  ## alterationsReplace
  ##   wordAlterations: JObject (required)
  ##                  : New alterations data.
  var body_568178 = newJObject()
  if wordAlterations != nil:
    body_568178 = wordAlterations
  result = call_568177.call(nil, nil, nil, nil, body_568178)

var alterationsReplace* = Call_AlterationsReplace_568117(
    name: "alterationsReplace", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/alterations", validator: validate_AlterationsReplace_568118, base: "",
    url: url_AlterationsReplace_568119, schemes: {Scheme.Https})
type
  Call_AlterationsGet_567880 = ref object of OpenApiRestCall_567658
proc url_AlterationsGet_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlterationsGet_567881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_567995: Call_AlterationsGet_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_567995.validator(path, query, header, formData, body)
  let scheme = call_567995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_567995.url(scheme.get, call_567995.host, call_567995.base,
                         call_567995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_567995, url, valid)

proc call*(call_568079: Call_AlterationsGet_567880): Recallable =
  ## alterationsGet
  result = call_568079.call(nil, nil, nil, nil, nil)

var alterationsGet* = Call_AlterationsGet_567880(name: "alterationsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/alterations",
    validator: validate_AlterationsGet_567881, base: "", url: url_AlterationsGet_567882,
    schemes: {Scheme.Https})
type
  Call_EndpointSettingsGetSettings_568180 = ref object of OpenApiRestCall_567658
proc url_EndpointSettingsGetSettings_568182(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EndpointSettingsGetSettings_568181(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568183: Call_EndpointSettingsGetSettings_568180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568183.validator(path, query, header, formData, body)
  let scheme = call_568183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568183.url(scheme.get, call_568183.host, call_568183.base,
                         call_568183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568183, url, valid)

proc call*(call_568184: Call_EndpointSettingsGetSettings_568180): Recallable =
  ## endpointSettingsGetSettings
  result = call_568184.call(nil, nil, nil, nil, nil)

var endpointSettingsGetSettings* = Call_EndpointSettingsGetSettings_568180(
    name: "endpointSettingsGetSettings", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/endpointSettings",
    validator: validate_EndpointSettingsGetSettings_568181, base: "",
    url: url_EndpointSettingsGetSettings_568182, schemes: {Scheme.Https})
type
  Call_EndpointSettingsUpdateSettings_568185 = ref object of OpenApiRestCall_567658
proc url_EndpointSettingsUpdateSettings_568187(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EndpointSettingsUpdateSettings_568186(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   endpointSettingsPayload: JObject (required)
  ##                          : Post body of the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568189: Call_EndpointSettingsUpdateSettings_568185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568189.validator(path, query, header, formData, body)
  let scheme = call_568189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568189.url(scheme.get, call_568189.host, call_568189.base,
                         call_568189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568189, url, valid)

proc call*(call_568190: Call_EndpointSettingsUpdateSettings_568185;
          endpointSettingsPayload: JsonNode): Recallable =
  ## endpointSettingsUpdateSettings
  ##   endpointSettingsPayload: JObject (required)
  ##                          : Post body of the request.
  var body_568191 = newJObject()
  if endpointSettingsPayload != nil:
    body_568191 = endpointSettingsPayload
  result = call_568190.call(nil, nil, nil, nil, body_568191)

var endpointSettingsUpdateSettings* = Call_EndpointSettingsUpdateSettings_568185(
    name: "endpointSettingsUpdateSettings", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/endpointSettings",
    validator: validate_EndpointSettingsUpdateSettings_568186, base: "",
    url: url_EndpointSettingsUpdateSettings_568187, schemes: {Scheme.Https})
type
  Call_EndpointKeysGetKeys_568192 = ref object of OpenApiRestCall_567658
proc url_EndpointKeysGetKeys_568194(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EndpointKeysGetKeys_568193(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568195: Call_EndpointKeysGetKeys_568192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568195.validator(path, query, header, formData, body)
  let scheme = call_568195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568195.url(scheme.get, call_568195.host, call_568195.base,
                         call_568195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568195, url, valid)

proc call*(call_568196: Call_EndpointKeysGetKeys_568192): Recallable =
  ## endpointKeysGetKeys
  result = call_568196.call(nil, nil, nil, nil, nil)

var endpointKeysGetKeys* = Call_EndpointKeysGetKeys_568192(
    name: "endpointKeysGetKeys", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/endpointkeys", validator: validate_EndpointKeysGetKeys_568193,
    base: "", url: url_EndpointKeysGetKeys_568194, schemes: {Scheme.Https})
type
  Call_EndpointKeysRefreshKeys_568197 = ref object of OpenApiRestCall_567658
proc url_EndpointKeysRefreshKeys_568199(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "keyType" in path, "`keyType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/endpointkeys/"),
               (kind: VariableSegment, value: "keyType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointKeysRefreshKeys_568198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   keyType: JString (required)
  ##          : Type of Key
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `keyType` field"
  var valid_568214 = path.getOrDefault("keyType")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "keyType", valid_568214
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_EndpointKeysRefreshKeys_568197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_EndpointKeysRefreshKeys_568197; keyType: string): Recallable =
  ## endpointKeysRefreshKeys
  ##   keyType: string (required)
  ##          : Type of Key
  var path_568217 = newJObject()
  add(path_568217, "keyType", newJString(keyType))
  result = call_568216.call(path_568217, nil, nil, nil, nil)

var endpointKeysRefreshKeys* = Call_EndpointKeysRefreshKeys_568197(
    name: "endpointKeysRefreshKeys", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/endpointkeys/{keyType}",
    validator: validate_EndpointKeysRefreshKeys_568198, base: "",
    url: url_EndpointKeysRefreshKeys_568199, schemes: {Scheme.Https})
type
  Call_KnowledgebaseListAll_568219 = ref object of OpenApiRestCall_567658
proc url_KnowledgebaseListAll_568221(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_KnowledgebaseListAll_568220(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_KnowledgebaseListAll_568219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_KnowledgebaseListAll_568219): Recallable =
  ## knowledgebaseListAll
  result = call_568223.call(nil, nil, nil, nil, nil)

var knowledgebaseListAll* = Call_KnowledgebaseListAll_568219(
    name: "knowledgebaseListAll", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/knowledgebases", validator: validate_KnowledgebaseListAll_568220,
    base: "", url: url_KnowledgebaseListAll_568221, schemes: {Scheme.Https})
type
  Call_KnowledgebaseCreate_568224 = ref object of OpenApiRestCall_567658
proc url_KnowledgebaseCreate_568226(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_KnowledgebaseCreate_568225(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createKbPayload: JObject (required)
  ##                  : Post body of the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_KnowledgebaseCreate_568224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_KnowledgebaseCreate_568224; createKbPayload: JsonNode): Recallable =
  ## knowledgebaseCreate
  ##   createKbPayload: JObject (required)
  ##                  : Post body of the request.
  var body_568230 = newJObject()
  if createKbPayload != nil:
    body_568230 = createKbPayload
  result = call_568229.call(nil, nil, nil, nil, body_568230)

var knowledgebaseCreate* = Call_KnowledgebaseCreate_568224(
    name: "knowledgebaseCreate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/knowledgebases/create", validator: validate_KnowledgebaseCreate_568225,
    base: "", url: url_KnowledgebaseCreate_568226, schemes: {Scheme.Https})
type
  Call_KnowledgebaseReplace_568238 = ref object of OpenApiRestCall_567658
proc url_KnowledgebaseReplace_568240(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "kbId" in path, "`kbId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/knowledgebases/"),
               (kind: VariableSegment, value: "kbId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_KnowledgebaseReplace_568239(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_568241 = path.getOrDefault("kbId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "kbId", valid_568241
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   replaceKb: JObject (required)
  ##            : An instance of ReplaceKbDTO which contains list of qnas to be uploaded
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_KnowledgebaseReplace_568238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_KnowledgebaseReplace_568238; kbId: string;
          replaceKb: JsonNode): Recallable =
  ## knowledgebaseReplace
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   replaceKb: JObject (required)
  ##            : An instance of ReplaceKbDTO which contains list of qnas to be uploaded
  var path_568245 = newJObject()
  var body_568246 = newJObject()
  add(path_568245, "kbId", newJString(kbId))
  if replaceKb != nil:
    body_568246 = replaceKb
  result = call_568244.call(path_568245, nil, nil, nil, body_568246)

var knowledgebaseReplace* = Call_KnowledgebaseReplace_568238(
    name: "knowledgebaseReplace", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebaseReplace_568239,
    base: "", url: url_KnowledgebaseReplace_568240, schemes: {Scheme.Https})
type
  Call_KnowledgebasePublish_568247 = ref object of OpenApiRestCall_567658
proc url_KnowledgebasePublish_568249(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "kbId" in path, "`kbId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/knowledgebases/"),
               (kind: VariableSegment, value: "kbId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_KnowledgebasePublish_568248(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_568250 = path.getOrDefault("kbId")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "kbId", valid_568250
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_KnowledgebasePublish_568247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_KnowledgebasePublish_568247; kbId: string): Recallable =
  ## knowledgebasePublish
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  var path_568253 = newJObject()
  add(path_568253, "kbId", newJString(kbId))
  result = call_568252.call(path_568253, nil, nil, nil, nil)

var knowledgebasePublish* = Call_KnowledgebasePublish_568247(
    name: "knowledgebasePublish", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebasePublish_568248,
    base: "", url: url_KnowledgebasePublish_568249, schemes: {Scheme.Https})
type
  Call_KnowledgebaseGetDetails_568231 = ref object of OpenApiRestCall_567658
proc url_KnowledgebaseGetDetails_568233(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "kbId" in path, "`kbId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/knowledgebases/"),
               (kind: VariableSegment, value: "kbId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_KnowledgebaseGetDetails_568232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_568234 = path.getOrDefault("kbId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "kbId", valid_568234
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_KnowledgebaseGetDetails_568231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_KnowledgebaseGetDetails_568231; kbId: string): Recallable =
  ## knowledgebaseGetDetails
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  var path_568237 = newJObject()
  add(path_568237, "kbId", newJString(kbId))
  result = call_568236.call(path_568237, nil, nil, nil, nil)

var knowledgebaseGetDetails* = Call_KnowledgebaseGetDetails_568231(
    name: "knowledgebaseGetDetails", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebaseGetDetails_568232,
    base: "", url: url_KnowledgebaseGetDetails_568233, schemes: {Scheme.Https})
type
  Call_KnowledgebaseUpdate_568261 = ref object of OpenApiRestCall_567658
proc url_KnowledgebaseUpdate_568263(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "kbId" in path, "`kbId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/knowledgebases/"),
               (kind: VariableSegment, value: "kbId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_KnowledgebaseUpdate_568262(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_568264 = path.getOrDefault("kbId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "kbId", valid_568264
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateKb: JObject (required)
  ##           : Post body of the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_KnowledgebaseUpdate_568261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_KnowledgebaseUpdate_568261; kbId: string;
          updateKb: JsonNode): Recallable =
  ## knowledgebaseUpdate
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   updateKb: JObject (required)
  ##           : Post body of the request.
  var path_568268 = newJObject()
  var body_568269 = newJObject()
  add(path_568268, "kbId", newJString(kbId))
  if updateKb != nil:
    body_568269 = updateKb
  result = call_568267.call(path_568268, nil, nil, nil, body_568269)

var knowledgebaseUpdate* = Call_KnowledgebaseUpdate_568261(
    name: "knowledgebaseUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebaseUpdate_568262,
    base: "", url: url_KnowledgebaseUpdate_568263, schemes: {Scheme.Https})
type
  Call_KnowledgebaseDelete_568254 = ref object of OpenApiRestCall_567658
proc url_KnowledgebaseDelete_568256(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "kbId" in path, "`kbId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/knowledgebases/"),
               (kind: VariableSegment, value: "kbId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_KnowledgebaseDelete_568255(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_568257 = path.getOrDefault("kbId")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "kbId", valid_568257
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568258: Call_KnowledgebaseDelete_568254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_KnowledgebaseDelete_568254; kbId: string): Recallable =
  ## knowledgebaseDelete
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  var path_568260 = newJObject()
  add(path_568260, "kbId", newJString(kbId))
  result = call_568259.call(path_568260, nil, nil, nil, nil)

var knowledgebaseDelete* = Call_KnowledgebaseDelete_568254(
    name: "knowledgebaseDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebaseDelete_568255,
    base: "", url: url_KnowledgebaseDelete_568256, schemes: {Scheme.Https})
type
  Call_KnowledgebaseDownload_568270 = ref object of OpenApiRestCall_567658
proc url_KnowledgebaseDownload_568272(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "kbId" in path, "`kbId` is a required path parameter"
  assert "environment" in path, "`environment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/knowledgebases/"),
               (kind: VariableSegment, value: "kbId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "environment"),
               (kind: ConstantSegment, value: "/qna")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_KnowledgebaseDownload_568271(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  ##   environment: JString (required)
  ##              : Specifies whether environment is Test or Prod.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_568273 = path.getOrDefault("kbId")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "kbId", valid_568273
  var valid_568287 = path.getOrDefault("environment")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = newJString("Prod"))
  if valid_568287 != nil:
    section.add "environment", valid_568287
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_KnowledgebaseDownload_568270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_KnowledgebaseDownload_568270; kbId: string;
          environment: string = "Prod"): Recallable =
  ## knowledgebaseDownload
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   environment: string (required)
  ##              : Specifies whether environment is Test or Prod.
  var path_568290 = newJObject()
  add(path_568290, "kbId", newJString(kbId))
  add(path_568290, "environment", newJString(environment))
  result = call_568289.call(path_568290, nil, nil, nil, nil)

var knowledgebaseDownload* = Call_KnowledgebaseDownload_568270(
    name: "knowledgebaseDownload", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/knowledgebases/{kbId}/{environment}/qna",
    validator: validate_KnowledgebaseDownload_568271, base: "",
    url: url_KnowledgebaseDownload_568272, schemes: {Scheme.Https})
type
  Call_OperationsGetDetails_568291 = ref object of OpenApiRestCall_567658
proc url_OperationsGetDetails_568293(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsGetDetails_568292(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_568294 = path.getOrDefault("operationId")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "operationId", valid_568294
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_OperationsGetDetails_568291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_OperationsGetDetails_568291; operationId: string): Recallable =
  ## operationsGetDetails
  ##   operationId: string (required)
  ##              : Operation id.
  var path_568297 = newJObject()
  add(path_568297, "operationId", newJString(operationId))
  result = call_568296.call(path_568297, nil, nil, nil, nil)

var operationsGetDetails* = Call_OperationsGetDetails_568291(
    name: "operationsGetDetails", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/operations/{operationId}", validator: validate_OperationsGetDetails_568292,
    base: "", url: url_OperationsGetDetails_568293, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
