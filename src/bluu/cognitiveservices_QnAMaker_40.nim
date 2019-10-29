
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "cognitiveservices-QnAMaker"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AlterationsReplace_564015 = ref object of OpenApiRestCall_563556
proc url_AlterationsReplace_564017(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlterationsReplace_564016(path: JsonNode; query: JsonNode;
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

proc call*(call_564076: Call_AlterationsReplace_564015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564076.validator(path, query, header, formData, body)
  let scheme = call_564076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564076.url(scheme.get, call_564076.host, call_564076.base,
                         call_564076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564076, url, valid)

proc call*(call_564077: Call_AlterationsReplace_564015; wordAlterations: JsonNode): Recallable =
  ## alterationsReplace
  ##   wordAlterations: JObject (required)
  ##                  : New alterations data.
  var body_564078 = newJObject()
  if wordAlterations != nil:
    body_564078 = wordAlterations
  result = call_564077.call(nil, nil, nil, nil, body_564078)

var alterationsReplace* = Call_AlterationsReplace_564015(
    name: "alterationsReplace", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/alterations", validator: validate_AlterationsReplace_564016, base: "",
    url: url_AlterationsReplace_564017, schemes: {Scheme.Https})
type
  Call_AlterationsGet_563778 = ref object of OpenApiRestCall_563556
proc url_AlterationsGet_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlterationsGet_563779(path: JsonNode; query: JsonNode;
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

proc call*(call_563893: Call_AlterationsGet_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_563893.validator(path, query, header, formData, body)
  let scheme = call_563893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563893.url(scheme.get, call_563893.host, call_563893.base,
                         call_563893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563893, url, valid)

proc call*(call_563977: Call_AlterationsGet_563778): Recallable =
  ## alterationsGet
  result = call_563977.call(nil, nil, nil, nil, nil)

var alterationsGet* = Call_AlterationsGet_563778(name: "alterationsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/alterations",
    validator: validate_AlterationsGet_563779, base: "", url: url_AlterationsGet_563780,
    schemes: {Scheme.Https})
type
  Call_EndpointSettingsGetSettings_564080 = ref object of OpenApiRestCall_563556
proc url_EndpointSettingsGetSettings_564082(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EndpointSettingsGetSettings_564081(path: JsonNode; query: JsonNode;
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

proc call*(call_564083: Call_EndpointSettingsGetSettings_564080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564083.validator(path, query, header, formData, body)
  let scheme = call_564083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564083.url(scheme.get, call_564083.host, call_564083.base,
                         call_564083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564083, url, valid)

proc call*(call_564084: Call_EndpointSettingsGetSettings_564080): Recallable =
  ## endpointSettingsGetSettings
  result = call_564084.call(nil, nil, nil, nil, nil)

var endpointSettingsGetSettings* = Call_EndpointSettingsGetSettings_564080(
    name: "endpointSettingsGetSettings", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/endpointSettings",
    validator: validate_EndpointSettingsGetSettings_564081, base: "",
    url: url_EndpointSettingsGetSettings_564082, schemes: {Scheme.Https})
type
  Call_EndpointSettingsUpdateSettings_564085 = ref object of OpenApiRestCall_563556
proc url_EndpointSettingsUpdateSettings_564087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EndpointSettingsUpdateSettings_564086(path: JsonNode;
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

proc call*(call_564089: Call_EndpointSettingsUpdateSettings_564085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564089.validator(path, query, header, formData, body)
  let scheme = call_564089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564089.url(scheme.get, call_564089.host, call_564089.base,
                         call_564089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564089, url, valid)

proc call*(call_564090: Call_EndpointSettingsUpdateSettings_564085;
          endpointSettingsPayload: JsonNode): Recallable =
  ## endpointSettingsUpdateSettings
  ##   endpointSettingsPayload: JObject (required)
  ##                          : Post body of the request.
  var body_564091 = newJObject()
  if endpointSettingsPayload != nil:
    body_564091 = endpointSettingsPayload
  result = call_564090.call(nil, nil, nil, nil, body_564091)

var endpointSettingsUpdateSettings* = Call_EndpointSettingsUpdateSettings_564085(
    name: "endpointSettingsUpdateSettings", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/endpointSettings",
    validator: validate_EndpointSettingsUpdateSettings_564086, base: "",
    url: url_EndpointSettingsUpdateSettings_564087, schemes: {Scheme.Https})
type
  Call_EndpointKeysGetKeys_564092 = ref object of OpenApiRestCall_563556
proc url_EndpointKeysGetKeys_564094(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EndpointKeysGetKeys_564093(path: JsonNode; query: JsonNode;
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

proc call*(call_564095: Call_EndpointKeysGetKeys_564092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_EndpointKeysGetKeys_564092): Recallable =
  ## endpointKeysGetKeys
  result = call_564096.call(nil, nil, nil, nil, nil)

var endpointKeysGetKeys* = Call_EndpointKeysGetKeys_564092(
    name: "endpointKeysGetKeys", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/endpointkeys", validator: validate_EndpointKeysGetKeys_564093,
    base: "", url: url_EndpointKeysGetKeys_564094, schemes: {Scheme.Https})
type
  Call_EndpointKeysRefreshKeys_564097 = ref object of OpenApiRestCall_563556
proc url_EndpointKeysRefreshKeys_564099(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointKeysRefreshKeys_564098(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   keyType: JString (required)
  ##          : Type of Key
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `keyType` field"
  var valid_564114 = path.getOrDefault("keyType")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "keyType", valid_564114
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564115: Call_EndpointKeysRefreshKeys_564097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_EndpointKeysRefreshKeys_564097; keyType: string): Recallable =
  ## endpointKeysRefreshKeys
  ##   keyType: string (required)
  ##          : Type of Key
  var path_564117 = newJObject()
  add(path_564117, "keyType", newJString(keyType))
  result = call_564116.call(path_564117, nil, nil, nil, nil)

var endpointKeysRefreshKeys* = Call_EndpointKeysRefreshKeys_564097(
    name: "endpointKeysRefreshKeys", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/endpointkeys/{keyType}",
    validator: validate_EndpointKeysRefreshKeys_564098, base: "",
    url: url_EndpointKeysRefreshKeys_564099, schemes: {Scheme.Https})
type
  Call_KnowledgebaseListAll_564119 = ref object of OpenApiRestCall_563556
proc url_KnowledgebaseListAll_564121(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_KnowledgebaseListAll_564120(path: JsonNode; query: JsonNode;
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

proc call*(call_564122: Call_KnowledgebaseListAll_564119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_KnowledgebaseListAll_564119): Recallable =
  ## knowledgebaseListAll
  result = call_564123.call(nil, nil, nil, nil, nil)

var knowledgebaseListAll* = Call_KnowledgebaseListAll_564119(
    name: "knowledgebaseListAll", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/knowledgebases", validator: validate_KnowledgebaseListAll_564120,
    base: "", url: url_KnowledgebaseListAll_564121, schemes: {Scheme.Https})
type
  Call_KnowledgebaseCreate_564124 = ref object of OpenApiRestCall_563556
proc url_KnowledgebaseCreate_564126(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_KnowledgebaseCreate_564125(path: JsonNode; query: JsonNode;
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

proc call*(call_564128: Call_KnowledgebaseCreate_564124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_KnowledgebaseCreate_564124; createKbPayload: JsonNode): Recallable =
  ## knowledgebaseCreate
  ##   createKbPayload: JObject (required)
  ##                  : Post body of the request.
  var body_564130 = newJObject()
  if createKbPayload != nil:
    body_564130 = createKbPayload
  result = call_564129.call(nil, nil, nil, nil, body_564130)

var knowledgebaseCreate* = Call_KnowledgebaseCreate_564124(
    name: "knowledgebaseCreate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/knowledgebases/create", validator: validate_KnowledgebaseCreate_564125,
    base: "", url: url_KnowledgebaseCreate_564126, schemes: {Scheme.Https})
type
  Call_KnowledgebaseReplace_564138 = ref object of OpenApiRestCall_563556
proc url_KnowledgebaseReplace_564140(protocol: Scheme; host: string; base: string;
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

proc validate_KnowledgebaseReplace_564139(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_564141 = path.getOrDefault("kbId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "kbId", valid_564141
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

proc call*(call_564143: Call_KnowledgebaseReplace_564138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564143.validator(path, query, header, formData, body)
  let scheme = call_564143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564143.url(scheme.get, call_564143.host, call_564143.base,
                         call_564143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564143, url, valid)

proc call*(call_564144: Call_KnowledgebaseReplace_564138; kbId: string;
          replaceKb: JsonNode): Recallable =
  ## knowledgebaseReplace
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   replaceKb: JObject (required)
  ##            : An instance of ReplaceKbDTO which contains list of qnas to be uploaded
  var path_564145 = newJObject()
  var body_564146 = newJObject()
  add(path_564145, "kbId", newJString(kbId))
  if replaceKb != nil:
    body_564146 = replaceKb
  result = call_564144.call(path_564145, nil, nil, nil, body_564146)

var knowledgebaseReplace* = Call_KnowledgebaseReplace_564138(
    name: "knowledgebaseReplace", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebaseReplace_564139,
    base: "", url: url_KnowledgebaseReplace_564140, schemes: {Scheme.Https})
type
  Call_KnowledgebasePublish_564147 = ref object of OpenApiRestCall_563556
proc url_KnowledgebasePublish_564149(protocol: Scheme; host: string; base: string;
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

proc validate_KnowledgebasePublish_564148(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_564150 = path.getOrDefault("kbId")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "kbId", valid_564150
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564151: Call_KnowledgebasePublish_564147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564151.validator(path, query, header, formData, body)
  let scheme = call_564151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564151.url(scheme.get, call_564151.host, call_564151.base,
                         call_564151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564151, url, valid)

proc call*(call_564152: Call_KnowledgebasePublish_564147; kbId: string): Recallable =
  ## knowledgebasePublish
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  var path_564153 = newJObject()
  add(path_564153, "kbId", newJString(kbId))
  result = call_564152.call(path_564153, nil, nil, nil, nil)

var knowledgebasePublish* = Call_KnowledgebasePublish_564147(
    name: "knowledgebasePublish", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebasePublish_564148,
    base: "", url: url_KnowledgebasePublish_564149, schemes: {Scheme.Https})
type
  Call_KnowledgebaseGetDetails_564131 = ref object of OpenApiRestCall_563556
proc url_KnowledgebaseGetDetails_564133(protocol: Scheme; host: string; base: string;
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

proc validate_KnowledgebaseGetDetails_564132(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_564134 = path.getOrDefault("kbId")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "kbId", valid_564134
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_KnowledgebaseGetDetails_564131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_KnowledgebaseGetDetails_564131; kbId: string): Recallable =
  ## knowledgebaseGetDetails
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  var path_564137 = newJObject()
  add(path_564137, "kbId", newJString(kbId))
  result = call_564136.call(path_564137, nil, nil, nil, nil)

var knowledgebaseGetDetails* = Call_KnowledgebaseGetDetails_564131(
    name: "knowledgebaseGetDetails", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebaseGetDetails_564132,
    base: "", url: url_KnowledgebaseGetDetails_564133, schemes: {Scheme.Https})
type
  Call_KnowledgebaseUpdate_564161 = ref object of OpenApiRestCall_563556
proc url_KnowledgebaseUpdate_564163(protocol: Scheme; host: string; base: string;
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

proc validate_KnowledgebaseUpdate_564162(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_564164 = path.getOrDefault("kbId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "kbId", valid_564164
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

proc call*(call_564166: Call_KnowledgebaseUpdate_564161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564166.validator(path, query, header, formData, body)
  let scheme = call_564166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564166.url(scheme.get, call_564166.host, call_564166.base,
                         call_564166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564166, url, valid)

proc call*(call_564167: Call_KnowledgebaseUpdate_564161; kbId: string;
          updateKb: JsonNode): Recallable =
  ## knowledgebaseUpdate
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   updateKb: JObject (required)
  ##           : Post body of the request.
  var path_564168 = newJObject()
  var body_564169 = newJObject()
  add(path_564168, "kbId", newJString(kbId))
  if updateKb != nil:
    body_564169 = updateKb
  result = call_564167.call(path_564168, nil, nil, nil, body_564169)

var knowledgebaseUpdate* = Call_KnowledgebaseUpdate_564161(
    name: "knowledgebaseUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebaseUpdate_564162,
    base: "", url: url_KnowledgebaseUpdate_564163, schemes: {Scheme.Https})
type
  Call_KnowledgebaseDelete_564154 = ref object of OpenApiRestCall_563556
proc url_KnowledgebaseDelete_564156(protocol: Scheme; host: string; base: string;
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

proc validate_KnowledgebaseDelete_564155(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_564157 = path.getOrDefault("kbId")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "kbId", valid_564157
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564158: Call_KnowledgebaseDelete_564154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564158.validator(path, query, header, formData, body)
  let scheme = call_564158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564158.url(scheme.get, call_564158.host, call_564158.base,
                         call_564158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564158, url, valid)

proc call*(call_564159: Call_KnowledgebaseDelete_564154; kbId: string): Recallable =
  ## knowledgebaseDelete
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  var path_564160 = newJObject()
  add(path_564160, "kbId", newJString(kbId))
  result = call_564159.call(path_564160, nil, nil, nil, nil)

var knowledgebaseDelete* = Call_KnowledgebaseDelete_564154(
    name: "knowledgebaseDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebaseDelete_564155,
    base: "", url: url_KnowledgebaseDelete_564156, schemes: {Scheme.Https})
type
  Call_KnowledgebaseDownload_564170 = ref object of OpenApiRestCall_563556
proc url_KnowledgebaseDownload_564172(protocol: Scheme; host: string; base: string;
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

proc validate_KnowledgebaseDownload_564171(path: JsonNode; query: JsonNode;
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
  var valid_564173 = path.getOrDefault("kbId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "kbId", valid_564173
  var valid_564187 = path.getOrDefault("environment")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = newJString("Prod"))
  if valid_564187 != nil:
    section.add "environment", valid_564187
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564188: Call_KnowledgebaseDownload_564170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_KnowledgebaseDownload_564170; kbId: string;
          environment: string = "Prod"): Recallable =
  ## knowledgebaseDownload
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   environment: string (required)
  ##              : Specifies whether environment is Test or Prod.
  var path_564190 = newJObject()
  add(path_564190, "kbId", newJString(kbId))
  add(path_564190, "environment", newJString(environment))
  result = call_564189.call(path_564190, nil, nil, nil, nil)

var knowledgebaseDownload* = Call_KnowledgebaseDownload_564170(
    name: "knowledgebaseDownload", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/knowledgebases/{kbId}/{environment}/qna",
    validator: validate_KnowledgebaseDownload_564171, base: "",
    url: url_KnowledgebaseDownload_564172, schemes: {Scheme.Https})
type
  Call_OperationsGetDetails_564191 = ref object of OpenApiRestCall_563556
proc url_OperationsGetDetails_564193(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsGetDetails_564192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564194 = path.getOrDefault("operationId")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "operationId", valid_564194
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564195: Call_OperationsGetDetails_564191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564195.validator(path, query, header, formData, body)
  let scheme = call_564195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564195.url(scheme.get, call_564195.host, call_564195.base,
                         call_564195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564195, url, valid)

proc call*(call_564196: Call_OperationsGetDetails_564191; operationId: string): Recallable =
  ## operationsGetDetails
  ##   operationId: string (required)
  ##              : Operation id.
  var path_564197 = newJObject()
  add(path_564197, "operationId", newJString(operationId))
  result = call_564196.call(path_564197, nil, nil, nil, nil)

var operationsGetDetails* = Call_OperationsGetDetails_564191(
    name: "operationsGetDetails", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/operations/{operationId}", validator: validate_OperationsGetDetails_564192,
    base: "", url: url_OperationsGetDetails_564193, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
