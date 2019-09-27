
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "cognitiveservices-QnAMaker"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AlterationsReplace_593884 = ref object of OpenApiRestCall_593425
proc url_AlterationsReplace_593886(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlterationsReplace_593885(path: JsonNode; query: JsonNode;
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

proc call*(call_593943: Call_AlterationsReplace_593884; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593943.validator(path, query, header, formData, body)
  let scheme = call_593943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593943.url(scheme.get, call_593943.host, call_593943.base,
                         call_593943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593943, url, valid)

proc call*(call_593944: Call_AlterationsReplace_593884; wordAlterations: JsonNode): Recallable =
  ## alterationsReplace
  ##   wordAlterations: JObject (required)
  ##                  : New alterations data.
  var body_593945 = newJObject()
  if wordAlterations != nil:
    body_593945 = wordAlterations
  result = call_593944.call(nil, nil, nil, nil, body_593945)

var alterationsReplace* = Call_AlterationsReplace_593884(
    name: "alterationsReplace", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/alterations", validator: validate_AlterationsReplace_593885, base: "",
    url: url_AlterationsReplace_593886, schemes: {Scheme.Https})
type
  Call_AlterationsGet_593647 = ref object of OpenApiRestCall_593425
proc url_AlterationsGet_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlterationsGet_593648(path: JsonNode; query: JsonNode;
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

proc call*(call_593762: Call_AlterationsGet_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593762.validator(path, query, header, formData, body)
  let scheme = call_593762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593762.url(scheme.get, call_593762.host, call_593762.base,
                         call_593762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593762, url, valid)

proc call*(call_593846: Call_AlterationsGet_593647): Recallable =
  ## alterationsGet
  result = call_593846.call(nil, nil, nil, nil, nil)

var alterationsGet* = Call_AlterationsGet_593647(name: "alterationsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/alterations",
    validator: validate_AlterationsGet_593648, base: "", url: url_AlterationsGet_593649,
    schemes: {Scheme.Https})
type
  Call_EndpointSettingsGetSettings_593947 = ref object of OpenApiRestCall_593425
proc url_EndpointSettingsGetSettings_593949(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EndpointSettingsGetSettings_593948(path: JsonNode; query: JsonNode;
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

proc call*(call_593950: Call_EndpointSettingsGetSettings_593947; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593950.validator(path, query, header, formData, body)
  let scheme = call_593950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593950.url(scheme.get, call_593950.host, call_593950.base,
                         call_593950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593950, url, valid)

proc call*(call_593951: Call_EndpointSettingsGetSettings_593947): Recallable =
  ## endpointSettingsGetSettings
  result = call_593951.call(nil, nil, nil, nil, nil)

var endpointSettingsGetSettings* = Call_EndpointSettingsGetSettings_593947(
    name: "endpointSettingsGetSettings", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/endpointSettings",
    validator: validate_EndpointSettingsGetSettings_593948, base: "",
    url: url_EndpointSettingsGetSettings_593949, schemes: {Scheme.Https})
type
  Call_EndpointSettingsUpdateSettings_593952 = ref object of OpenApiRestCall_593425
proc url_EndpointSettingsUpdateSettings_593954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EndpointSettingsUpdateSettings_593953(path: JsonNode;
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

proc call*(call_593956: Call_EndpointSettingsUpdateSettings_593952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593956.validator(path, query, header, formData, body)
  let scheme = call_593956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593956.url(scheme.get, call_593956.host, call_593956.base,
                         call_593956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593956, url, valid)

proc call*(call_593957: Call_EndpointSettingsUpdateSettings_593952;
          endpointSettingsPayload: JsonNode): Recallable =
  ## endpointSettingsUpdateSettings
  ##   endpointSettingsPayload: JObject (required)
  ##                          : Post body of the request.
  var body_593958 = newJObject()
  if endpointSettingsPayload != nil:
    body_593958 = endpointSettingsPayload
  result = call_593957.call(nil, nil, nil, nil, body_593958)

var endpointSettingsUpdateSettings* = Call_EndpointSettingsUpdateSettings_593952(
    name: "endpointSettingsUpdateSettings", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/endpointSettings",
    validator: validate_EndpointSettingsUpdateSettings_593953, base: "",
    url: url_EndpointSettingsUpdateSettings_593954, schemes: {Scheme.Https})
type
  Call_EndpointKeysGetKeys_593959 = ref object of OpenApiRestCall_593425
proc url_EndpointKeysGetKeys_593961(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EndpointKeysGetKeys_593960(path: JsonNode; query: JsonNode;
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

proc call*(call_593962: Call_EndpointKeysGetKeys_593959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_EndpointKeysGetKeys_593959): Recallable =
  ## endpointKeysGetKeys
  result = call_593963.call(nil, nil, nil, nil, nil)

var endpointKeysGetKeys* = Call_EndpointKeysGetKeys_593959(
    name: "endpointKeysGetKeys", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/endpointkeys", validator: validate_EndpointKeysGetKeys_593960,
    base: "", url: url_EndpointKeysGetKeys_593961, schemes: {Scheme.Https})
type
  Call_EndpointKeysRefreshKeys_593964 = ref object of OpenApiRestCall_593425
proc url_EndpointKeysRefreshKeys_593966(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointKeysRefreshKeys_593965(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   keyType: JString (required)
  ##          : Type of Key
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `keyType` field"
  var valid_593981 = path.getOrDefault("keyType")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "keyType", valid_593981
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_EndpointKeysRefreshKeys_593964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_EndpointKeysRefreshKeys_593964; keyType: string): Recallable =
  ## endpointKeysRefreshKeys
  ##   keyType: string (required)
  ##          : Type of Key
  var path_593984 = newJObject()
  add(path_593984, "keyType", newJString(keyType))
  result = call_593983.call(path_593984, nil, nil, nil, nil)

var endpointKeysRefreshKeys* = Call_EndpointKeysRefreshKeys_593964(
    name: "endpointKeysRefreshKeys", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/endpointkeys/{keyType}",
    validator: validate_EndpointKeysRefreshKeys_593965, base: "",
    url: url_EndpointKeysRefreshKeys_593966, schemes: {Scheme.Https})
type
  Call_KnowledgebaseListAll_593986 = ref object of OpenApiRestCall_593425
proc url_KnowledgebaseListAll_593988(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_KnowledgebaseListAll_593987(path: JsonNode; query: JsonNode;
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

proc call*(call_593989: Call_KnowledgebaseListAll_593986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_KnowledgebaseListAll_593986): Recallable =
  ## knowledgebaseListAll
  result = call_593990.call(nil, nil, nil, nil, nil)

var knowledgebaseListAll* = Call_KnowledgebaseListAll_593986(
    name: "knowledgebaseListAll", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/knowledgebases", validator: validate_KnowledgebaseListAll_593987,
    base: "", url: url_KnowledgebaseListAll_593988, schemes: {Scheme.Https})
type
  Call_KnowledgebaseCreate_593991 = ref object of OpenApiRestCall_593425
proc url_KnowledgebaseCreate_593993(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_KnowledgebaseCreate_593992(path: JsonNode; query: JsonNode;
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

proc call*(call_593995: Call_KnowledgebaseCreate_593991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_KnowledgebaseCreate_593991; createKbPayload: JsonNode): Recallable =
  ## knowledgebaseCreate
  ##   createKbPayload: JObject (required)
  ##                  : Post body of the request.
  var body_593997 = newJObject()
  if createKbPayload != nil:
    body_593997 = createKbPayload
  result = call_593996.call(nil, nil, nil, nil, body_593997)

var knowledgebaseCreate* = Call_KnowledgebaseCreate_593991(
    name: "knowledgebaseCreate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/knowledgebases/create", validator: validate_KnowledgebaseCreate_593992,
    base: "", url: url_KnowledgebaseCreate_593993, schemes: {Scheme.Https})
type
  Call_KnowledgebaseReplace_594005 = ref object of OpenApiRestCall_593425
proc url_KnowledgebaseReplace_594007(protocol: Scheme; host: string; base: string;
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

proc validate_KnowledgebaseReplace_594006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_594008 = path.getOrDefault("kbId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "kbId", valid_594008
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

proc call*(call_594010: Call_KnowledgebaseReplace_594005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_KnowledgebaseReplace_594005; kbId: string;
          replaceKb: JsonNode): Recallable =
  ## knowledgebaseReplace
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   replaceKb: JObject (required)
  ##            : An instance of ReplaceKbDTO which contains list of qnas to be uploaded
  var path_594012 = newJObject()
  var body_594013 = newJObject()
  add(path_594012, "kbId", newJString(kbId))
  if replaceKb != nil:
    body_594013 = replaceKb
  result = call_594011.call(path_594012, nil, nil, nil, body_594013)

var knowledgebaseReplace* = Call_KnowledgebaseReplace_594005(
    name: "knowledgebaseReplace", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebaseReplace_594006,
    base: "", url: url_KnowledgebaseReplace_594007, schemes: {Scheme.Https})
type
  Call_KnowledgebasePublish_594014 = ref object of OpenApiRestCall_593425
proc url_KnowledgebasePublish_594016(protocol: Scheme; host: string; base: string;
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

proc validate_KnowledgebasePublish_594015(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_594017 = path.getOrDefault("kbId")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "kbId", valid_594017
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_KnowledgebasePublish_594014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_KnowledgebasePublish_594014; kbId: string): Recallable =
  ## knowledgebasePublish
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  var path_594020 = newJObject()
  add(path_594020, "kbId", newJString(kbId))
  result = call_594019.call(path_594020, nil, nil, nil, nil)

var knowledgebasePublish* = Call_KnowledgebasePublish_594014(
    name: "knowledgebasePublish", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebasePublish_594015,
    base: "", url: url_KnowledgebasePublish_594016, schemes: {Scheme.Https})
type
  Call_KnowledgebaseGetDetails_593998 = ref object of OpenApiRestCall_593425
proc url_KnowledgebaseGetDetails_594000(protocol: Scheme; host: string; base: string;
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

proc validate_KnowledgebaseGetDetails_593999(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_594001 = path.getOrDefault("kbId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "kbId", valid_594001
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_KnowledgebaseGetDetails_593998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_KnowledgebaseGetDetails_593998; kbId: string): Recallable =
  ## knowledgebaseGetDetails
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  var path_594004 = newJObject()
  add(path_594004, "kbId", newJString(kbId))
  result = call_594003.call(path_594004, nil, nil, nil, nil)

var knowledgebaseGetDetails* = Call_KnowledgebaseGetDetails_593998(
    name: "knowledgebaseGetDetails", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebaseGetDetails_593999,
    base: "", url: url_KnowledgebaseGetDetails_594000, schemes: {Scheme.Https})
type
  Call_KnowledgebaseUpdate_594028 = ref object of OpenApiRestCall_593425
proc url_KnowledgebaseUpdate_594030(protocol: Scheme; host: string; base: string;
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

proc validate_KnowledgebaseUpdate_594029(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_594031 = path.getOrDefault("kbId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "kbId", valid_594031
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

proc call*(call_594033: Call_KnowledgebaseUpdate_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_KnowledgebaseUpdate_594028; kbId: string;
          updateKb: JsonNode): Recallable =
  ## knowledgebaseUpdate
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   updateKb: JObject (required)
  ##           : Post body of the request.
  var path_594035 = newJObject()
  var body_594036 = newJObject()
  add(path_594035, "kbId", newJString(kbId))
  if updateKb != nil:
    body_594036 = updateKb
  result = call_594034.call(path_594035, nil, nil, nil, body_594036)

var knowledgebaseUpdate* = Call_KnowledgebaseUpdate_594028(
    name: "knowledgebaseUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebaseUpdate_594029,
    base: "", url: url_KnowledgebaseUpdate_594030, schemes: {Scheme.Https})
type
  Call_KnowledgebaseDelete_594021 = ref object of OpenApiRestCall_593425
proc url_KnowledgebaseDelete_594023(protocol: Scheme; host: string; base: string;
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

proc validate_KnowledgebaseDelete_594022(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kbId: JString (required)
  ##       : Knowledgebase id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kbId` field"
  var valid_594024 = path.getOrDefault("kbId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "kbId", valid_594024
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594025: Call_KnowledgebaseDelete_594021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_KnowledgebaseDelete_594021; kbId: string): Recallable =
  ## knowledgebaseDelete
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  var path_594027 = newJObject()
  add(path_594027, "kbId", newJString(kbId))
  result = call_594026.call(path_594027, nil, nil, nil, nil)

var knowledgebaseDelete* = Call_KnowledgebaseDelete_594021(
    name: "knowledgebaseDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/knowledgebases/{kbId}", validator: validate_KnowledgebaseDelete_594022,
    base: "", url: url_KnowledgebaseDelete_594023, schemes: {Scheme.Https})
type
  Call_KnowledgebaseDownload_594037 = ref object of OpenApiRestCall_593425
proc url_KnowledgebaseDownload_594039(protocol: Scheme; host: string; base: string;
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

proc validate_KnowledgebaseDownload_594038(path: JsonNode; query: JsonNode;
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
  var valid_594040 = path.getOrDefault("kbId")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "kbId", valid_594040
  var valid_594054 = path.getOrDefault("environment")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = newJString("Prod"))
  if valid_594054 != nil:
    section.add "environment", valid_594054
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594055: Call_KnowledgebaseDownload_594037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_KnowledgebaseDownload_594037; kbId: string;
          environment: string = "Prod"): Recallable =
  ## knowledgebaseDownload
  ##   kbId: string (required)
  ##       : Knowledgebase id.
  ##   environment: string (required)
  ##              : Specifies whether environment is Test or Prod.
  var path_594057 = newJObject()
  add(path_594057, "kbId", newJString(kbId))
  add(path_594057, "environment", newJString(environment))
  result = call_594056.call(path_594057, nil, nil, nil, nil)

var knowledgebaseDownload* = Call_KnowledgebaseDownload_594037(
    name: "knowledgebaseDownload", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/knowledgebases/{kbId}/{environment}/qna",
    validator: validate_KnowledgebaseDownload_594038, base: "",
    url: url_KnowledgebaseDownload_594039, schemes: {Scheme.Https})
type
  Call_OperationsGetDetails_594058 = ref object of OpenApiRestCall_593425
proc url_OperationsGetDetails_594060(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsGetDetails_594059(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_594061 = path.getOrDefault("operationId")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "operationId", valid_594061
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594062: Call_OperationsGetDetails_594058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594062.validator(path, query, header, formData, body)
  let scheme = call_594062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594062.url(scheme.get, call_594062.host, call_594062.base,
                         call_594062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594062, url, valid)

proc call*(call_594063: Call_OperationsGetDetails_594058; operationId: string): Recallable =
  ## operationsGetDetails
  ##   operationId: string (required)
  ##              : Operation id.
  var path_594064 = newJObject()
  add(path_594064, "operationId", newJString(operationId))
  result = call_594063.call(path_594064, nil, nil, nil, nil)

var operationsGetDetails* = Call_OperationsGetDetails_594058(
    name: "operationsGetDetails", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/operations/{operationId}", validator: validate_OperationsGetDetails_594059,
    base: "", url: url_OperationsGetDetails_594060, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
