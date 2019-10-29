
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: LUIS Authoring Client
## version: 2.0
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_563566 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563566](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563566): Option[Scheme] {.used.} =
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
  macServiceName = "cognitiveservices-LUIS-Authoring"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppsAdd_564101 = ref object of OpenApiRestCall_563566
proc url_AppsAdd_564103(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsAdd_564102(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new LUIS app.
  ## 
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
  ##   applicationCreateObject: JObject (required)
  ##                          : An application containing Name, Description (optional), Culture, Usage Scenario (optional), Domain (optional) and initial version ID (optional) of the application. Default value for the version ID is "0.1". Note: the culture cannot be changed after the app is created.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564105: Call_AppsAdd_564101; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new LUIS app.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_AppsAdd_564101; applicationCreateObject: JsonNode): Recallable =
  ## appsAdd
  ## Creates a new LUIS app.
  ##   applicationCreateObject: JObject (required)
  ##                          : An application containing Name, Description (optional), Culture, Usage Scenario (optional), Domain (optional) and initial version ID (optional) of the application. Default value for the version ID is "0.1". Note: the culture cannot be changed after the app is created.
  var body_564107 = newJObject()
  if applicationCreateObject != nil:
    body_564107 = applicationCreateObject
  result = call_564106.call(nil, nil, nil, nil, body_564107)

var appsAdd* = Call_AppsAdd_564101(name: "appsAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/apps/",
                                validator: validate_AppsAdd_564102, base: "",
                                url: url_AppsAdd_564103, schemes: {Scheme.Https})
type
  Call_AppsList_563788 = ref object of OpenApiRestCall_563566
proc url_AppsList_563790(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsList_563789(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the user's applications.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_563965 = query.getOrDefault("take")
  valid_563965 = validateParameter(valid_563965, JInt, required = false,
                                 default = newJInt(100))
  if valid_563965 != nil:
    section.add "take", valid_563965
  var valid_563966 = query.getOrDefault("skip")
  valid_563966 = validateParameter(valid_563966, JInt, required = false,
                                 default = newJInt(0))
  if valid_563966 != nil:
    section.add "skip", valid_563966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563989: Call_AppsList_563788; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the user's applications.
  ## 
  let valid = call_563989.validator(path, query, header, formData, body)
  let scheme = call_563989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563989.url(scheme.get, call_563989.host, call_563989.base,
                         call_563989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563989, url, valid)

proc call*(call_564060: Call_AppsList_563788; take: int = 100; skip: int = 0): Recallable =
  ## appsList
  ## Lists all of the user's applications.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  var query_564061 = newJObject()
  add(query_564061, "take", newJInt(take))
  add(query_564061, "skip", newJInt(skip))
  result = call_564060.call(nil, query_564061, nil, nil, nil)

var appsList* = Call_AppsList_563788(name: "appsList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/apps/",
                                  validator: validate_AppsList_563789, base: "",
                                  url: url_AppsList_563790,
                                  schemes: {Scheme.Https})
type
  Call_AppsListCortanaEndpoints_564108 = ref object of OpenApiRestCall_563566
proc url_AppsListCortanaEndpoints_564110(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListCortanaEndpoints_564109(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  ## 
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

proc call*(call_564111: Call_AppsListCortanaEndpoints_564108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  ## 
  let valid = call_564111.validator(path, query, header, formData, body)
  let scheme = call_564111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564111.url(scheme.get, call_564111.host, call_564111.base,
                         call_564111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564111, url, valid)

proc call*(call_564112: Call_AppsListCortanaEndpoints_564108): Recallable =
  ## appsListCortanaEndpoints
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  result = call_564112.call(nil, nil, nil, nil, nil)

var appsListCortanaEndpoints* = Call_AppsListCortanaEndpoints_564108(
    name: "appsListCortanaEndpoints", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/assistants", validator: validate_AppsListCortanaEndpoints_564109,
    base: "", url: url_AppsListCortanaEndpoints_564110, schemes: {Scheme.Https})
type
  Call_AppsListSupportedCultures_564113 = ref object of OpenApiRestCall_563566
proc url_AppsListSupportedCultures_564115(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListSupportedCultures_564114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of supported cultures. Cultures are equivalent to the written language and locale. For example,"en-us" represents the U.S. variation of English.
  ## 
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

proc call*(call_564116: Call_AppsListSupportedCultures_564113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of supported cultures. Cultures are equivalent to the written language and locale. For example,"en-us" represents the U.S. variation of English.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_AppsListSupportedCultures_564113): Recallable =
  ## appsListSupportedCultures
  ## Gets a list of supported cultures. Cultures are equivalent to the written language and locale. For example,"en-us" represents the U.S. variation of English.
  result = call_564117.call(nil, nil, nil, nil, nil)

var appsListSupportedCultures* = Call_AppsListSupportedCultures_564113(
    name: "appsListSupportedCultures", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/cultures",
    validator: validate_AppsListSupportedCultures_564114, base: "",
    url: url_AppsListSupportedCultures_564115, schemes: {Scheme.Https})
type
  Call_AppsAddCustomPrebuiltDomain_564123 = ref object of OpenApiRestCall_563566
proc url_AppsAddCustomPrebuiltDomain_564125(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsAddCustomPrebuiltDomain_564124(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a prebuilt domain along with its intent and entity models as a new application.
  ## 
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
  ##   prebuiltDomainCreateObject: JObject (required)
  ##                             : A prebuilt domain create object containing the name and culture of the domain.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564127: Call_AppsAddCustomPrebuiltDomain_564123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a prebuilt domain along with its intent and entity models as a new application.
  ## 
  let valid = call_564127.validator(path, query, header, formData, body)
  let scheme = call_564127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564127.url(scheme.get, call_564127.host, call_564127.base,
                         call_564127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564127, url, valid)

proc call*(call_564128: Call_AppsAddCustomPrebuiltDomain_564123;
          prebuiltDomainCreateObject: JsonNode): Recallable =
  ## appsAddCustomPrebuiltDomain
  ## Adds a prebuilt domain along with its intent and entity models as a new application.
  ##   prebuiltDomainCreateObject: JObject (required)
  ##                             : A prebuilt domain create object containing the name and culture of the domain.
  var body_564129 = newJObject()
  if prebuiltDomainCreateObject != nil:
    body_564129 = prebuiltDomainCreateObject
  result = call_564128.call(nil, nil, nil, nil, body_564129)

var appsAddCustomPrebuiltDomain* = Call_AppsAddCustomPrebuiltDomain_564123(
    name: "appsAddCustomPrebuiltDomain", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/customprebuiltdomains",
    validator: validate_AppsAddCustomPrebuiltDomain_564124, base: "",
    url: url_AppsAddCustomPrebuiltDomain_564125, schemes: {Scheme.Https})
type
  Call_AppsListAvailableCustomPrebuiltDomains_564118 = ref object of OpenApiRestCall_563566
proc url_AppsListAvailableCustomPrebuiltDomains_564120(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListAvailableCustomPrebuiltDomains_564119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the available custom prebuilt domains for all cultures.
  ## 
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

proc call*(call_564121: Call_AppsListAvailableCustomPrebuiltDomains_564118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available custom prebuilt domains for all cultures.
  ## 
  let valid = call_564121.validator(path, query, header, formData, body)
  let scheme = call_564121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564121.url(scheme.get, call_564121.host, call_564121.base,
                         call_564121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564121, url, valid)

proc call*(call_564122: Call_AppsListAvailableCustomPrebuiltDomains_564118): Recallable =
  ## appsListAvailableCustomPrebuiltDomains
  ## Gets all the available custom prebuilt domains for all cultures.
  result = call_564122.call(nil, nil, nil, nil, nil)

var appsListAvailableCustomPrebuiltDomains* = Call_AppsListAvailableCustomPrebuiltDomains_564118(
    name: "appsListAvailableCustomPrebuiltDomains", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/customprebuiltdomains",
    validator: validate_AppsListAvailableCustomPrebuiltDomains_564119, base: "",
    url: url_AppsListAvailableCustomPrebuiltDomains_564120,
    schemes: {Scheme.Https})
type
  Call_AppsListAvailableCustomPrebuiltDomainsForCulture_564130 = ref object of OpenApiRestCall_563566
proc url_AppsListAvailableCustomPrebuiltDomainsForCulture_564132(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "culture" in path, "`culture` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/customprebuiltdomains/"),
               (kind: VariableSegment, value: "culture")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsListAvailableCustomPrebuiltDomainsForCulture_564131(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets all the available prebuilt domains for a specific culture.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   culture: JString (required)
  ##          : Culture.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `culture` field"
  var valid_564147 = path.getOrDefault("culture")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "culture", valid_564147
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564148: Call_AppsListAvailableCustomPrebuiltDomainsForCulture_564130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available prebuilt domains for a specific culture.
  ## 
  let valid = call_564148.validator(path, query, header, formData, body)
  let scheme = call_564148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564148.url(scheme.get, call_564148.host, call_564148.base,
                         call_564148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564148, url, valid)

proc call*(call_564149: Call_AppsListAvailableCustomPrebuiltDomainsForCulture_564130;
          culture: string): Recallable =
  ## appsListAvailableCustomPrebuiltDomainsForCulture
  ## Gets all the available prebuilt domains for a specific culture.
  ##   culture: string (required)
  ##          : Culture.
  var path_564150 = newJObject()
  add(path_564150, "culture", newJString(culture))
  result = call_564149.call(path_564150, nil, nil, nil, nil)

var appsListAvailableCustomPrebuiltDomainsForCulture* = Call_AppsListAvailableCustomPrebuiltDomainsForCulture_564130(
    name: "appsListAvailableCustomPrebuiltDomainsForCulture",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/customprebuiltdomains/{culture}",
    validator: validate_AppsListAvailableCustomPrebuiltDomainsForCulture_564131,
    base: "", url: url_AppsListAvailableCustomPrebuiltDomainsForCulture_564132,
    schemes: {Scheme.Https})
type
  Call_AppsListDomains_564151 = ref object of OpenApiRestCall_563566
proc url_AppsListDomains_564153(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListDomains_564152(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the available application domains.
  ## 
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

proc call*(call_564154: Call_AppsListDomains_564151; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available application domains.
  ## 
  let valid = call_564154.validator(path, query, header, formData, body)
  let scheme = call_564154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564154.url(scheme.get, call_564154.host, call_564154.base,
                         call_564154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564154, url, valid)

proc call*(call_564155: Call_AppsListDomains_564151): Recallable =
  ## appsListDomains
  ## Gets the available application domains.
  result = call_564155.call(nil, nil, nil, nil, nil)

var appsListDomains* = Call_AppsListDomains_564151(name: "appsListDomains",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/domains",
    validator: validate_AppsListDomains_564152, base: "", url: url_AppsListDomains_564153,
    schemes: {Scheme.Https})
type
  Call_AppsImport_564156 = ref object of OpenApiRestCall_563566
proc url_AppsImport_564158(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsImport_564157(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports an application to LUIS, the application's structure is included in the request body.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   appName: JString
  ##          : The application name to create. If not specified, the application name will be read from the imported object. If the application name already exists, an error is returned.
  section = newJObject()
  var valid_564159 = query.getOrDefault("appName")
  valid_564159 = validateParameter(valid_564159, JString, required = false,
                                 default = nil)
  if valid_564159 != nil:
    section.add "appName", valid_564159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564161: Call_AppsImport_564156; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an application to LUIS, the application's structure is included in the request body.
  ## 
  let valid = call_564161.validator(path, query, header, formData, body)
  let scheme = call_564161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564161.url(scheme.get, call_564161.host, call_564161.base,
                         call_564161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564161, url, valid)

proc call*(call_564162: Call_AppsImport_564156; luisApp: JsonNode;
          appName: string = ""): Recallable =
  ## appsImport
  ## Imports an application to LUIS, the application's structure is included in the request body.
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  ##   appName: string
  ##          : The application name to create. If not specified, the application name will be read from the imported object. If the application name already exists, an error is returned.
  var query_564163 = newJObject()
  var body_564164 = newJObject()
  if luisApp != nil:
    body_564164 = luisApp
  add(query_564163, "appName", newJString(appName))
  result = call_564162.call(nil, query_564163, nil, nil, body_564164)

var appsImport* = Call_AppsImport_564156(name: "appsImport",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/apps/import",
                                      validator: validate_AppsImport_564157,
                                      base: "", url: url_AppsImport_564158,
                                      schemes: {Scheme.Https})
type
  Call_AppsListUsageScenarios_564165 = ref object of OpenApiRestCall_563566
proc url_AppsListUsageScenarios_564167(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListUsageScenarios_564166(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the application available usage scenarios.
  ## 
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

proc call*(call_564168: Call_AppsListUsageScenarios_564165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application available usage scenarios.
  ## 
  let valid = call_564168.validator(path, query, header, formData, body)
  let scheme = call_564168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564168.url(scheme.get, call_564168.host, call_564168.base,
                         call_564168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564168, url, valid)

proc call*(call_564169: Call_AppsListUsageScenarios_564165): Recallable =
  ## appsListUsageScenarios
  ## Gets the application available usage scenarios.
  result = call_564169.call(nil, nil, nil, nil, nil)

var appsListUsageScenarios* = Call_AppsListUsageScenarios_564165(
    name: "appsListUsageScenarios", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/usagescenarios", validator: validate_AppsListUsageScenarios_564166,
    base: "", url: url_AppsListUsageScenarios_564167, schemes: {Scheme.Https})
type
  Call_AppsUpdate_564177 = ref object of OpenApiRestCall_563566
proc url_AppsUpdate_564179(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsUpdate_564178(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the name or description of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564180 = path.getOrDefault("appId")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "appId", valid_564180
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applicationUpdateObject: JObject (required)
  ##                          : A model containing Name and Description of the application.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564182: Call_AppsUpdate_564177; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or description of the application.
  ## 
  let valid = call_564182.validator(path, query, header, formData, body)
  let scheme = call_564182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564182.url(scheme.get, call_564182.host, call_564182.base,
                         call_564182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564182, url, valid)

proc call*(call_564183: Call_AppsUpdate_564177; appId: string;
          applicationUpdateObject: JsonNode): Recallable =
  ## appsUpdate
  ## Updates the name or description of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   applicationUpdateObject: JObject (required)
  ##                          : A model containing Name and Description of the application.
  var path_564184 = newJObject()
  var body_564185 = newJObject()
  add(path_564184, "appId", newJString(appId))
  if applicationUpdateObject != nil:
    body_564185 = applicationUpdateObject
  result = call_564183.call(path_564184, nil, nil, nil, body_564185)

var appsUpdate* = Call_AppsUpdate_564177(name: "appsUpdate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local", route: "/apps/{appId}",
                                      validator: validate_AppsUpdate_564178,
                                      base: "", url: url_AppsUpdate_564179,
                                      schemes: {Scheme.Https})
type
  Call_AppsGet_564170 = ref object of OpenApiRestCall_563566
proc url_AppsGet_564172(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsGet_564171(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the application info.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564173 = path.getOrDefault("appId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "appId", valid_564173
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564174: Call_AppsGet_564170; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application info.
  ## 
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_AppsGet_564170; appId: string): Recallable =
  ## appsGet
  ## Gets the application info.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564176 = newJObject()
  add(path_564176, "appId", newJString(appId))
  result = call_564175.call(path_564176, nil, nil, nil, nil)

var appsGet* = Call_AppsGet_564170(name: "appsGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/apps/{appId}",
                                validator: validate_AppsGet_564171, base: "",
                                url: url_AppsGet_564172, schemes: {Scheme.Https})
type
  Call_AppsDelete_564186 = ref object of OpenApiRestCall_563566
proc url_AppsDelete_564188(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsDelete_564187(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564189 = path.getOrDefault("appId")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "appId", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   force: JBool
  ##        : A flag to indicate whether to force an operation.
  section = newJObject()
  var valid_564190 = query.getOrDefault("force")
  valid_564190 = validateParameter(valid_564190, JBool, required = false,
                                 default = newJBool(false))
  if valid_564190 != nil:
    section.add "force", valid_564190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564191: Call_AppsDelete_564186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application.
  ## 
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_AppsDelete_564186; appId: string; force: bool = false): Recallable =
  ## appsDelete
  ## Deletes an application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   force: bool
  ##        : A flag to indicate whether to force an operation.
  var path_564193 = newJObject()
  var query_564194 = newJObject()
  add(path_564193, "appId", newJString(appId))
  add(query_564194, "force", newJBool(force))
  result = call_564192.call(path_564193, query_564194, nil, nil, nil)

var appsDelete* = Call_AppsDelete_564186(name: "appsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local", route: "/apps/{appId}",
                                      validator: validate_AppsDelete_564187,
                                      base: "", url: url_AppsDelete_564188,
                                      schemes: {Scheme.Https})
type
  Call_AzureAccountsAssignToApp_564203 = ref object of OpenApiRestCall_563566
proc url_AzureAccountsAssignToApp_564205(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/azureaccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AzureAccountsAssignToApp_564204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Assigns an Azure account to the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564206 = path.getOrDefault("appId")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "appId", valid_564206
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Authorization: JString (required)
  ##                : The bearer authorization header to use; containing the user's ARM token used to validate Azure accounts information.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Authorization` field"
  var valid_564207 = header.getOrDefault("Authorization")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "Authorization", valid_564207
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   azureAccountInfoObject: JObject
  ##                         : The Azure account information object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564209: Call_AzureAccountsAssignToApp_564203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Assigns an Azure account to the application.
  ## 
  let valid = call_564209.validator(path, query, header, formData, body)
  let scheme = call_564209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564209.url(scheme.get, call_564209.host, call_564209.base,
                         call_564209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564209, url, valid)

proc call*(call_564210: Call_AzureAccountsAssignToApp_564203; appId: string;
          azureAccountInfoObject: JsonNode = nil): Recallable =
  ## azureAccountsAssignToApp
  ## Assigns an Azure account to the application.
  ##   azureAccountInfoObject: JObject
  ##                         : The Azure account information object.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564211 = newJObject()
  var body_564212 = newJObject()
  if azureAccountInfoObject != nil:
    body_564212 = azureAccountInfoObject
  add(path_564211, "appId", newJString(appId))
  result = call_564210.call(path_564211, nil, nil, nil, body_564212)

var azureAccountsAssignToApp* = Call_AzureAccountsAssignToApp_564203(
    name: "azureAccountsAssignToApp", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/azureaccounts",
    validator: validate_AzureAccountsAssignToApp_564204, base: "",
    url: url_AzureAccountsAssignToApp_564205, schemes: {Scheme.Https})
type
  Call_AzureAccountsGetAssigned_564195 = ref object of OpenApiRestCall_563566
proc url_AzureAccountsGetAssigned_564197(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/azureaccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AzureAccountsGetAssigned_564196(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the LUIS Azure accounts assigned to the application for the user using his ARM token.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564198 = path.getOrDefault("appId")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "appId", valid_564198
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Authorization: JString (required)
  ##                : The bearer authorization header to use; containing the user's ARM token used to validate Azure accounts information.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Authorization` field"
  var valid_564199 = header.getOrDefault("Authorization")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "Authorization", valid_564199
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564200: Call_AzureAccountsGetAssigned_564195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the LUIS Azure accounts assigned to the application for the user using his ARM token.
  ## 
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_AzureAccountsGetAssigned_564195; appId: string): Recallable =
  ## azureAccountsGetAssigned
  ## Gets the LUIS Azure accounts assigned to the application for the user using his ARM token.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564202 = newJObject()
  add(path_564202, "appId", newJString(appId))
  result = call_564201.call(path_564202, nil, nil, nil, nil)

var azureAccountsGetAssigned* = Call_AzureAccountsGetAssigned_564195(
    name: "azureAccountsGetAssigned", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/azureaccounts",
    validator: validate_AzureAccountsGetAssigned_564196, base: "",
    url: url_AzureAccountsGetAssigned_564197, schemes: {Scheme.Https})
type
  Call_AzureAccountsRemoveFromApp_564213 = ref object of OpenApiRestCall_563566
proc url_AzureAccountsRemoveFromApp_564215(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/azureaccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AzureAccountsRemoveFromApp_564214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes assigned Azure account from the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564216 = path.getOrDefault("appId")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "appId", valid_564216
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Authorization: JString (required)
  ##                : The bearer authorization header to use; containing the user's ARM token used to validate Azure accounts information.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Authorization` field"
  var valid_564217 = header.getOrDefault("Authorization")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "Authorization", valid_564217
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   azureAccountInfoObject: JObject
  ##                         : The Azure account information object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564219: Call_AzureAccountsRemoveFromApp_564213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes assigned Azure account from the application.
  ## 
  let valid = call_564219.validator(path, query, header, formData, body)
  let scheme = call_564219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564219.url(scheme.get, call_564219.host, call_564219.base,
                         call_564219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564219, url, valid)

proc call*(call_564220: Call_AzureAccountsRemoveFromApp_564213; appId: string;
          azureAccountInfoObject: JsonNode = nil): Recallable =
  ## azureAccountsRemoveFromApp
  ## Removes assigned Azure account from the application.
  ##   azureAccountInfoObject: JObject
  ##                         : The Azure account information object.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564221 = newJObject()
  var body_564222 = newJObject()
  if azureAccountInfoObject != nil:
    body_564222 = azureAccountInfoObject
  add(path_564221, "appId", newJString(appId))
  result = call_564220.call(path_564221, nil, nil, nil, body_564222)

var azureAccountsRemoveFromApp* = Call_AzureAccountsRemoveFromApp_564213(
    name: "azureAccountsRemoveFromApp", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/azureaccounts",
    validator: validate_AzureAccountsRemoveFromApp_564214, base: "",
    url: url_AzureAccountsRemoveFromApp_564215, schemes: {Scheme.Https})
type
  Call_AppsListEndpoints_564223 = ref object of OpenApiRestCall_563566
proc url_AppsListEndpoints_564225(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/endpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsListEndpoints_564224(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the available endpoint deployment regions and URLs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564226 = path.getOrDefault("appId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "appId", valid_564226
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_AppsListEndpoints_564223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the available endpoint deployment regions and URLs.
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_AppsListEndpoints_564223; appId: string): Recallable =
  ## appsListEndpoints
  ## Returns the available endpoint deployment regions and URLs.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564229 = newJObject()
  add(path_564229, "appId", newJString(appId))
  result = call_564228.call(path_564229, nil, nil, nil, nil)

var appsListEndpoints* = Call_AppsListEndpoints_564223(name: "appsListEndpoints",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/endpoints",
    validator: validate_AppsListEndpoints_564224, base: "",
    url: url_AppsListEndpoints_564225, schemes: {Scheme.Https})
type
  Call_PermissionsUpdate_564237 = ref object of OpenApiRestCall_563566
proc url_PermissionsUpdate_564239(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PermissionsUpdate_564238(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Replaces the current user access list with the new list sent in the body. If an empty list is sent, all access to other users will be removed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564240 = path.getOrDefault("appId")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "appId", valid_564240
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   collaborators: JObject (required)
  ##                : A model containing a list of user email addresses.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564242: Call_PermissionsUpdate_564237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces the current user access list with the new list sent in the body. If an empty list is sent, all access to other users will be removed.
  ## 
  let valid = call_564242.validator(path, query, header, formData, body)
  let scheme = call_564242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564242.url(scheme.get, call_564242.host, call_564242.base,
                         call_564242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564242, url, valid)

proc call*(call_564243: Call_PermissionsUpdate_564237; collaborators: JsonNode;
          appId: string): Recallable =
  ## permissionsUpdate
  ## Replaces the current user access list with the new list sent in the body. If an empty list is sent, all access to other users will be removed.
  ##   collaborators: JObject (required)
  ##                : A model containing a list of user email addresses.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564244 = newJObject()
  var body_564245 = newJObject()
  if collaborators != nil:
    body_564245 = collaborators
  add(path_564244, "appId", newJString(appId))
  result = call_564243.call(path_564244, nil, nil, nil, body_564245)

var permissionsUpdate* = Call_PermissionsUpdate_564237(name: "permissionsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsUpdate_564238,
    base: "", url: url_PermissionsUpdate_564239, schemes: {Scheme.Https})
type
  Call_PermissionsAdd_564246 = ref object of OpenApiRestCall_563566
proc url_PermissionsAdd_564248(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PermissionsAdd_564247(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564249 = path.getOrDefault("appId")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "appId", valid_564249
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   userToAdd: JObject (required)
  ##            : A model containing the user's email address.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564251: Call_PermissionsAdd_564246; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ## 
  let valid = call_564251.validator(path, query, header, formData, body)
  let scheme = call_564251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564251.url(scheme.get, call_564251.host, call_564251.base,
                         call_564251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564251, url, valid)

proc call*(call_564252: Call_PermissionsAdd_564246; userToAdd: JsonNode;
          appId: string): Recallable =
  ## permissionsAdd
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ##   userToAdd: JObject (required)
  ##            : A model containing the user's email address.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564253 = newJObject()
  var body_564254 = newJObject()
  if userToAdd != nil:
    body_564254 = userToAdd
  add(path_564253, "appId", newJString(appId))
  result = call_564252.call(path_564253, nil, nil, nil, body_564254)

var permissionsAdd* = Call_PermissionsAdd_564246(name: "permissionsAdd",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsAdd_564247,
    base: "", url: url_PermissionsAdd_564248, schemes: {Scheme.Https})
type
  Call_PermissionsList_564230 = ref object of OpenApiRestCall_563566
proc url_PermissionsList_564232(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PermissionsList_564231(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the list of user emails that have permissions to access your application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564233 = path.getOrDefault("appId")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "appId", valid_564233
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564234: Call_PermissionsList_564230; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of user emails that have permissions to access your application.
  ## 
  let valid = call_564234.validator(path, query, header, formData, body)
  let scheme = call_564234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564234.url(scheme.get, call_564234.host, call_564234.base,
                         call_564234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564234, url, valid)

proc call*(call_564235: Call_PermissionsList_564230; appId: string): Recallable =
  ## permissionsList
  ## Gets the list of user emails that have permissions to access your application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564236 = newJObject()
  add(path_564236, "appId", newJString(appId))
  result = call_564235.call(path_564236, nil, nil, nil, nil)

var permissionsList* = Call_PermissionsList_564230(name: "permissionsList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsList_564231,
    base: "", url: url_PermissionsList_564232, schemes: {Scheme.Https})
type
  Call_PermissionsDelete_564255 = ref object of OpenApiRestCall_563566
proc url_PermissionsDelete_564257(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PermissionsDelete_564256(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564258 = path.getOrDefault("appId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "appId", valid_564258
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   userToDelete: JObject (required)
  ##               : A model containing the user's email address.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564260: Call_PermissionsDelete_564255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ## 
  let valid = call_564260.validator(path, query, header, formData, body)
  let scheme = call_564260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564260.url(scheme.get, call_564260.host, call_564260.base,
                         call_564260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564260, url, valid)

proc call*(call_564261: Call_PermissionsDelete_564255; userToDelete: JsonNode;
          appId: string): Recallable =
  ## permissionsDelete
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ##   userToDelete: JObject (required)
  ##               : A model containing the user's email address.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564262 = newJObject()
  var body_564263 = newJObject()
  if userToDelete != nil:
    body_564263 = userToDelete
  add(path_564262, "appId", newJString(appId))
  result = call_564261.call(path_564262, nil, nil, nil, body_564263)

var permissionsDelete* = Call_PermissionsDelete_564255(name: "permissionsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsDelete_564256,
    base: "", url: url_PermissionsDelete_564257, schemes: {Scheme.Https})
type
  Call_AppsPublish_564264 = ref object of OpenApiRestCall_563566
proc url_AppsPublish_564266(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/publish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsPublish_564265(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Publishes a specific version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564267 = path.getOrDefault("appId")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "appId", valid_564267
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applicationPublishObject: JObject (required)
  ##                           : The application publish object. The region is the target region that the application is published to.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564269: Call_AppsPublish_564264; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a specific version of the application.
  ## 
  let valid = call_564269.validator(path, query, header, formData, body)
  let scheme = call_564269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564269.url(scheme.get, call_564269.host, call_564269.base,
                         call_564269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564269, url, valid)

proc call*(call_564270: Call_AppsPublish_564264; appId: string;
          applicationPublishObject: JsonNode): Recallable =
  ## appsPublish
  ## Publishes a specific version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   applicationPublishObject: JObject (required)
  ##                           : The application publish object. The region is the target region that the application is published to.
  var path_564271 = newJObject()
  var body_564272 = newJObject()
  add(path_564271, "appId", newJString(appId))
  if applicationPublishObject != nil:
    body_564272 = applicationPublishObject
  result = call_564270.call(path_564271, nil, nil, nil, body_564272)

var appsPublish* = Call_AppsPublish_564264(name: "appsPublish",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local",
                                        route: "/apps/{appId}/publish",
                                        validator: validate_AppsPublish_564265,
                                        base: "", url: url_AppsPublish_564266,
                                        schemes: {Scheme.Https})
type
  Call_AppsUpdatePublishSettings_564280 = ref object of OpenApiRestCall_563566
proc url_AppsUpdatePublishSettings_564282(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/publishsettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsUpdatePublishSettings_564281(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the application publish settings including 'UseAllTrainingData'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564283 = path.getOrDefault("appId")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "appId", valid_564283
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   publishSettingUpdateObject: JObject (required)
  ##                             : An object containing the new publish application settings.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564285: Call_AppsUpdatePublishSettings_564280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the application publish settings including 'UseAllTrainingData'.
  ## 
  let valid = call_564285.validator(path, query, header, formData, body)
  let scheme = call_564285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564285.url(scheme.get, call_564285.host, call_564285.base,
                         call_564285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564285, url, valid)

proc call*(call_564286: Call_AppsUpdatePublishSettings_564280;
          publishSettingUpdateObject: JsonNode; appId: string): Recallable =
  ## appsUpdatePublishSettings
  ## Updates the application publish settings including 'UseAllTrainingData'.
  ##   publishSettingUpdateObject: JObject (required)
  ##                             : An object containing the new publish application settings.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564287 = newJObject()
  var body_564288 = newJObject()
  if publishSettingUpdateObject != nil:
    body_564288 = publishSettingUpdateObject
  add(path_564287, "appId", newJString(appId))
  result = call_564286.call(path_564287, nil, nil, nil, body_564288)

var appsUpdatePublishSettings* = Call_AppsUpdatePublishSettings_564280(
    name: "appsUpdatePublishSettings", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/publishsettings",
    validator: validate_AppsUpdatePublishSettings_564281, base: "",
    url: url_AppsUpdatePublishSettings_564282, schemes: {Scheme.Https})
type
  Call_AppsGetPublishSettings_564273 = ref object of OpenApiRestCall_563566
proc url_AppsGetPublishSettings_564275(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/publishsettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsGetPublishSettings_564274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the application publish settings including 'UseAllTrainingData'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564276 = path.getOrDefault("appId")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "appId", valid_564276
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564277: Call_AppsGetPublishSettings_564273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the application publish settings including 'UseAllTrainingData'.
  ## 
  let valid = call_564277.validator(path, query, header, formData, body)
  let scheme = call_564277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564277.url(scheme.get, call_564277.host, call_564277.base,
                         call_564277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564277, url, valid)

proc call*(call_564278: Call_AppsGetPublishSettings_564273; appId: string): Recallable =
  ## appsGetPublishSettings
  ## Get the application publish settings including 'UseAllTrainingData'.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564279 = newJObject()
  add(path_564279, "appId", newJString(appId))
  result = call_564278.call(path_564279, nil, nil, nil, nil)

var appsGetPublishSettings* = Call_AppsGetPublishSettings_564273(
    name: "appsGetPublishSettings", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/publishsettings",
    validator: validate_AppsGetPublishSettings_564274, base: "",
    url: url_AppsGetPublishSettings_564275, schemes: {Scheme.Https})
type
  Call_AppsDownloadQueryLogs_564289 = ref object of OpenApiRestCall_563566
proc url_AppsDownloadQueryLogs_564291(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/querylogs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsDownloadQueryLogs_564290(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the logs of the past month's endpoint queries for the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564292 = path.getOrDefault("appId")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "appId", valid_564292
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_AppsDownloadQueryLogs_564289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the logs of the past month's endpoint queries for the application.
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_AppsDownloadQueryLogs_564289; appId: string): Recallable =
  ## appsDownloadQueryLogs
  ## Gets the logs of the past month's endpoint queries for the application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564295 = newJObject()
  add(path_564295, "appId", newJString(appId))
  result = call_564294.call(path_564295, nil, nil, nil, nil)

var appsDownloadQueryLogs* = Call_AppsDownloadQueryLogs_564289(
    name: "appsDownloadQueryLogs", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/querylogs", validator: validate_AppsDownloadQueryLogs_564290,
    base: "", url: url_AppsDownloadQueryLogs_564291, schemes: {Scheme.Https})
type
  Call_AppsUpdateSettings_564303 = ref object of OpenApiRestCall_563566
proc url_AppsUpdateSettings_564305(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/settings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsUpdateSettings_564304(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the application settings including 'UseAllTrainingData'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564306 = path.getOrDefault("appId")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "appId", valid_564306
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applicationSettingUpdateObject: JObject (required)
  ##                                 : An object containing the new application settings.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564308: Call_AppsUpdateSettings_564303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the application settings including 'UseAllTrainingData'.
  ## 
  let valid = call_564308.validator(path, query, header, formData, body)
  let scheme = call_564308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564308.url(scheme.get, call_564308.host, call_564308.base,
                         call_564308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564308, url, valid)

proc call*(call_564309: Call_AppsUpdateSettings_564303;
          applicationSettingUpdateObject: JsonNode; appId: string): Recallable =
  ## appsUpdateSettings
  ## Updates the application settings including 'UseAllTrainingData'.
  ##   applicationSettingUpdateObject: JObject (required)
  ##                                 : An object containing the new application settings.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564310 = newJObject()
  var body_564311 = newJObject()
  if applicationSettingUpdateObject != nil:
    body_564311 = applicationSettingUpdateObject
  add(path_564310, "appId", newJString(appId))
  result = call_564309.call(path_564310, nil, nil, nil, body_564311)

var appsUpdateSettings* = Call_AppsUpdateSettings_564303(
    name: "appsUpdateSettings", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/settings", validator: validate_AppsUpdateSettings_564304,
    base: "", url: url_AppsUpdateSettings_564305, schemes: {Scheme.Https})
type
  Call_AppsGetSettings_564296 = ref object of OpenApiRestCall_563566
proc url_AppsGetSettings_564298(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/settings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsGetSettings_564297(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the application settings including 'UseAllTrainingData'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564299 = path.getOrDefault("appId")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "appId", valid_564299
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564300: Call_AppsGetSettings_564296; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the application settings including 'UseAllTrainingData'.
  ## 
  let valid = call_564300.validator(path, query, header, formData, body)
  let scheme = call_564300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564300.url(scheme.get, call_564300.host, call_564300.base,
                         call_564300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564300, url, valid)

proc call*(call_564301: Call_AppsGetSettings_564296; appId: string): Recallable =
  ## appsGetSettings
  ## Get the application settings including 'UseAllTrainingData'.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564302 = newJObject()
  add(path_564302, "appId", newJString(appId))
  result = call_564301.call(path_564302, nil, nil, nil, nil)

var appsGetSettings* = Call_AppsGetSettings_564296(name: "appsGetSettings",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/settings",
    validator: validate_AppsGetSettings_564297, base: "", url: url_AppsGetSettings_564298,
    schemes: {Scheme.Https})
type
  Call_VersionsList_564312 = ref object of OpenApiRestCall_563566
proc url_VersionsList_564314(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsList_564313(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of versions for this application ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564315 = path.getOrDefault("appId")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "appId", valid_564315
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564316 = query.getOrDefault("take")
  valid_564316 = validateParameter(valid_564316, JInt, required = false,
                                 default = newJInt(100))
  if valid_564316 != nil:
    section.add "take", valid_564316
  var valid_564317 = query.getOrDefault("skip")
  valid_564317 = validateParameter(valid_564317, JInt, required = false,
                                 default = newJInt(0))
  if valid_564317 != nil:
    section.add "skip", valid_564317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564318: Call_VersionsList_564312; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of versions for this application ID.
  ## 
  let valid = call_564318.validator(path, query, header, formData, body)
  let scheme = call_564318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564318.url(scheme.get, call_564318.host, call_564318.base,
                         call_564318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564318, url, valid)

proc call*(call_564319: Call_VersionsList_564312; appId: string; take: int = 100;
          skip: int = 0): Recallable =
  ## versionsList
  ## Gets a list of versions for this application ID.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564320 = newJObject()
  var query_564321 = newJObject()
  add(query_564321, "take", newJInt(take))
  add(query_564321, "skip", newJInt(skip))
  add(path_564320, "appId", newJString(appId))
  result = call_564319.call(path_564320, query_564321, nil, nil, nil)

var versionsList* = Call_VersionsList_564312(name: "versionsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions",
    validator: validate_VersionsList_564313, base: "", url: url_VersionsList_564314,
    schemes: {Scheme.Https})
type
  Call_VersionsImport_564322 = ref object of OpenApiRestCall_563566
proc url_VersionsImport_564324(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsImport_564323(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Imports a new version into a LUIS application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564325 = path.getOrDefault("appId")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "appId", valid_564325
  result.add "path", section
  ## parameters in `query` object:
  ##   versionId: JString
  ##            : The new versionId to import. If not specified, the versionId will be read from the imported object.
  section = newJObject()
  var valid_564326 = query.getOrDefault("versionId")
  valid_564326 = validateParameter(valid_564326, JString, required = false,
                                 default = nil)
  if valid_564326 != nil:
    section.add "versionId", valid_564326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564328: Call_VersionsImport_564322; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a new version into a LUIS application.
  ## 
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_VersionsImport_564322; luisApp: JsonNode; appId: string;
          versionId: string = ""): Recallable =
  ## versionsImport
  ## Imports a new version into a LUIS application.
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  ##   versionId: string
  ##            : The new versionId to import. If not specified, the versionId will be read from the imported object.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564330 = newJObject()
  var query_564331 = newJObject()
  var body_564332 = newJObject()
  if luisApp != nil:
    body_564332 = luisApp
  add(query_564331, "versionId", newJString(versionId))
  add(path_564330, "appId", newJString(appId))
  result = call_564329.call(path_564330, query_564331, nil, nil, body_564332)

var versionsImport* = Call_VersionsImport_564322(name: "versionsImport",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/import", validator: validate_VersionsImport_564323,
    base: "", url: url_VersionsImport_564324, schemes: {Scheme.Https})
type
  Call_VersionsUpdate_564341 = ref object of OpenApiRestCall_563566
proc url_VersionsUpdate_564343(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsUpdate_564342(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the name or description of the application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564344 = path.getOrDefault("appId")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "appId", valid_564344
  var valid_564345 = path.getOrDefault("versionId")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "versionId", valid_564345
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   versionUpdateObject: JObject (required)
  ##                      : A model containing Name and Description of the application.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564347: Call_VersionsUpdate_564341; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or description of the application version.
  ## 
  let valid = call_564347.validator(path, query, header, formData, body)
  let scheme = call_564347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564347.url(scheme.get, call_564347.host, call_564347.base,
                         call_564347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564347, url, valid)

proc call*(call_564348: Call_VersionsUpdate_564341; versionUpdateObject: JsonNode;
          appId: string; versionId: string): Recallable =
  ## versionsUpdate
  ## Updates the name or description of the application version.
  ##   versionUpdateObject: JObject (required)
  ##                      : A model containing Name and Description of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564349 = newJObject()
  var body_564350 = newJObject()
  if versionUpdateObject != nil:
    body_564350 = versionUpdateObject
  add(path_564349, "appId", newJString(appId))
  add(path_564349, "versionId", newJString(versionId))
  result = call_564348.call(path_564349, nil, nil, nil, body_564350)

var versionsUpdate* = Call_VersionsUpdate_564341(name: "versionsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/",
    validator: validate_VersionsUpdate_564342, base: "", url: url_VersionsUpdate_564343,
    schemes: {Scheme.Https})
type
  Call_VersionsGet_564333 = ref object of OpenApiRestCall_563566
proc url_VersionsGet_564335(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsGet_564334(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the version information such as date created, last modified date, endpoint URL, count of intents and entities, training and publishing status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564336 = path.getOrDefault("appId")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "appId", valid_564336
  var valid_564337 = path.getOrDefault("versionId")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "versionId", valid_564337
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564338: Call_VersionsGet_564333; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the version information such as date created, last modified date, endpoint URL, count of intents and entities, training and publishing status.
  ## 
  let valid = call_564338.validator(path, query, header, formData, body)
  let scheme = call_564338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564338.url(scheme.get, call_564338.host, call_564338.base,
                         call_564338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564338, url, valid)

proc call*(call_564339: Call_VersionsGet_564333; appId: string; versionId: string): Recallable =
  ## versionsGet
  ## Gets the version information such as date created, last modified date, endpoint URL, count of intents and entities, training and publishing status.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564340 = newJObject()
  add(path_564340, "appId", newJString(appId))
  add(path_564340, "versionId", newJString(versionId))
  result = call_564339.call(path_564340, nil, nil, nil, nil)

var versionsGet* = Call_VersionsGet_564333(name: "versionsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/apps/{appId}/versions/{versionId}/",
                                        validator: validate_VersionsGet_564334,
                                        base: "", url: url_VersionsGet_564335,
                                        schemes: {Scheme.Https})
type
  Call_VersionsDelete_564351 = ref object of OpenApiRestCall_563566
proc url_VersionsDelete_564353(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsDelete_564352(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564354 = path.getOrDefault("appId")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "appId", valid_564354
  var valid_564355 = path.getOrDefault("versionId")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "versionId", valid_564355
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564356: Call_VersionsDelete_564351; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application version.
  ## 
  let valid = call_564356.validator(path, query, header, formData, body)
  let scheme = call_564356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564356.url(scheme.get, call_564356.host, call_564356.base,
                         call_564356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564356, url, valid)

proc call*(call_564357: Call_VersionsDelete_564351; appId: string; versionId: string): Recallable =
  ## versionsDelete
  ## Deletes an application version.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564358 = newJObject()
  add(path_564358, "appId", newJString(appId))
  add(path_564358, "versionId", newJString(versionId))
  result = call_564357.call(path_564358, nil, nil, nil, nil)

var versionsDelete* = Call_VersionsDelete_564351(name: "versionsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/",
    validator: validate_VersionsDelete_564352, base: "", url: url_VersionsDelete_564353,
    schemes: {Scheme.Https})
type
  Call_VersionsClone_564359 = ref object of OpenApiRestCall_563566
proc url_VersionsClone_564361(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/clone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsClone_564360(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new version from the selected version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564362 = path.getOrDefault("appId")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "appId", valid_564362
  var valid_564363 = path.getOrDefault("versionId")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "versionId", valid_564363
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   versionCloneObject: JObject (required)
  ##                     : A model containing the new version ID.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564365: Call_VersionsClone_564359; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new version from the selected version.
  ## 
  let valid = call_564365.validator(path, query, header, formData, body)
  let scheme = call_564365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564365.url(scheme.get, call_564365.host, call_564365.base,
                         call_564365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564365, url, valid)

proc call*(call_564366: Call_VersionsClone_564359; appId: string;
          versionCloneObject: JsonNode; versionId: string): Recallable =
  ## versionsClone
  ## Creates a new version from the selected version.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionCloneObject: JObject (required)
  ##                     : A model containing the new version ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564367 = newJObject()
  var body_564368 = newJObject()
  add(path_564367, "appId", newJString(appId))
  if versionCloneObject != nil:
    body_564368 = versionCloneObject
  add(path_564367, "versionId", newJString(versionId))
  result = call_564366.call(path_564367, nil, nil, nil, body_564368)

var versionsClone* = Call_VersionsClone_564359(name: "versionsClone",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/clone",
    validator: validate_VersionsClone_564360, base: "", url: url_VersionsClone_564361,
    schemes: {Scheme.Https})
type
  Call_ModelAddClosedList_564380 = ref object of OpenApiRestCall_563566
proc url_ModelAddClosedList_564382(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddClosedList_564381(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Adds a list entity model to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564383 = path.getOrDefault("appId")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "appId", valid_564383
  var valid_564384 = path.getOrDefault("versionId")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "versionId", valid_564384
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   closedListModelCreateObject: JObject (required)
  ##                              : A model containing the name and words for the new list entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564386: Call_ModelAddClosedList_564380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a list entity model to a version of the application.
  ## 
  let valid = call_564386.validator(path, query, header, formData, body)
  let scheme = call_564386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564386.url(scheme.get, call_564386.host, call_564386.base,
                         call_564386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564386, url, valid)

proc call*(call_564387: Call_ModelAddClosedList_564380;
          closedListModelCreateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelAddClosedList
  ## Adds a list entity model to a version of the application.
  ##   closedListModelCreateObject: JObject (required)
  ##                              : A model containing the name and words for the new list entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564388 = newJObject()
  var body_564389 = newJObject()
  if closedListModelCreateObject != nil:
    body_564389 = closedListModelCreateObject
  add(path_564388, "appId", newJString(appId))
  add(path_564388, "versionId", newJString(versionId))
  result = call_564387.call(path_564388, nil, nil, nil, body_564389)

var modelAddClosedList* = Call_ModelAddClosedList_564380(
    name: "modelAddClosedList", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists",
    validator: validate_ModelAddClosedList_564381, base: "",
    url: url_ModelAddClosedList_564382, schemes: {Scheme.Https})
type
  Call_ModelListClosedLists_564369 = ref object of OpenApiRestCall_563566
proc url_ModelListClosedLists_564371(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListClosedLists_564370(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about all the list entity models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564372 = path.getOrDefault("appId")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "appId", valid_564372
  var valid_564373 = path.getOrDefault("versionId")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "versionId", valid_564373
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564374 = query.getOrDefault("take")
  valid_564374 = validateParameter(valid_564374, JInt, required = false,
                                 default = newJInt(100))
  if valid_564374 != nil:
    section.add "take", valid_564374
  var valid_564375 = query.getOrDefault("skip")
  valid_564375 = validateParameter(valid_564375, JInt, required = false,
                                 default = newJInt(0))
  if valid_564375 != nil:
    section.add "skip", valid_564375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564376: Call_ModelListClosedLists_564369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the list entity models in a version of the application.
  ## 
  let valid = call_564376.validator(path, query, header, formData, body)
  let scheme = call_564376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564376.url(scheme.get, call_564376.host, call_564376.base,
                         call_564376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564376, url, valid)

proc call*(call_564377: Call_ModelListClosedLists_564369; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListClosedLists
  ## Gets information about all the list entity models in a version of the application.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564378 = newJObject()
  var query_564379 = newJObject()
  add(query_564379, "take", newJInt(take))
  add(query_564379, "skip", newJInt(skip))
  add(path_564378, "appId", newJString(appId))
  add(path_564378, "versionId", newJString(versionId))
  result = call_564377.call(path_564378, query_564379, nil, nil, nil)

var modelListClosedLists* = Call_ModelListClosedLists_564369(
    name: "modelListClosedLists", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists",
    validator: validate_ModelListClosedLists_564370, base: "",
    url: url_ModelListClosedLists_564371, schemes: {Scheme.Https})
type
  Call_ModelUpdateClosedList_564399 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateClosedList_564401(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateClosedList_564400(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the list entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The list model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564402 = path.getOrDefault("clEntityId")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "clEntityId", valid_564402
  var valid_564403 = path.getOrDefault("appId")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "appId", valid_564403
  var valid_564404 = path.getOrDefault("versionId")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "versionId", valid_564404
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   closedListModelUpdateObject: JObject (required)
  ##                              : The new list entity name and words list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564406: Call_ModelUpdateClosedList_564399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the list entity in a version of the application.
  ## 
  let valid = call_564406.validator(path, query, header, formData, body)
  let scheme = call_564406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564406.url(scheme.get, call_564406.host, call_564406.base,
                         call_564406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564406, url, valid)

proc call*(call_564407: Call_ModelUpdateClosedList_564399; clEntityId: string;
          closedListModelUpdateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelUpdateClosedList
  ## Updates the list entity in a version of the application.
  ##   clEntityId: string (required)
  ##             : The list model ID.
  ##   closedListModelUpdateObject: JObject (required)
  ##                              : The new list entity name and words list.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564408 = newJObject()
  var body_564409 = newJObject()
  add(path_564408, "clEntityId", newJString(clEntityId))
  if closedListModelUpdateObject != nil:
    body_564409 = closedListModelUpdateObject
  add(path_564408, "appId", newJString(appId))
  add(path_564408, "versionId", newJString(versionId))
  result = call_564407.call(path_564408, nil, nil, nil, body_564409)

var modelUpdateClosedList* = Call_ModelUpdateClosedList_564399(
    name: "modelUpdateClosedList", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelUpdateClosedList_564400, base: "",
    url: url_ModelUpdateClosedList_564401, schemes: {Scheme.Https})
type
  Call_ModelGetClosedList_564390 = ref object of OpenApiRestCall_563566
proc url_ModelGetClosedList_564392(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetClosedList_564391(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets information about a list entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The list model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564393 = path.getOrDefault("clEntityId")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "clEntityId", valid_564393
  var valid_564394 = path.getOrDefault("appId")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "appId", valid_564394
  var valid_564395 = path.getOrDefault("versionId")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "versionId", valid_564395
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564396: Call_ModelGetClosedList_564390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a list entity in a version of the application.
  ## 
  let valid = call_564396.validator(path, query, header, formData, body)
  let scheme = call_564396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564396.url(scheme.get, call_564396.host, call_564396.base,
                         call_564396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564396, url, valid)

proc call*(call_564397: Call_ModelGetClosedList_564390; clEntityId: string;
          appId: string; versionId: string): Recallable =
  ## modelGetClosedList
  ## Gets information about a list entity in a version of the application.
  ##   clEntityId: string (required)
  ##             : The list model ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564398 = newJObject()
  add(path_564398, "clEntityId", newJString(clEntityId))
  add(path_564398, "appId", newJString(appId))
  add(path_564398, "versionId", newJString(versionId))
  result = call_564397.call(path_564398, nil, nil, nil, nil)

var modelGetClosedList* = Call_ModelGetClosedList_564390(
    name: "modelGetClosedList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelGetClosedList_564391, base: "",
    url: url_ModelGetClosedList_564392, schemes: {Scheme.Https})
type
  Call_ModelPatchClosedList_564419 = ref object of OpenApiRestCall_563566
proc url_ModelPatchClosedList_564421(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelPatchClosedList_564420(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a batch of sublists to an existing list entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The list entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564422 = path.getOrDefault("clEntityId")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "clEntityId", valid_564422
  var valid_564423 = path.getOrDefault("appId")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "appId", valid_564423
  var valid_564424 = path.getOrDefault("versionId")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "versionId", valid_564424
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   closedListModelPatchObject: JObject (required)
  ##                             : A words list batch.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564426: Call_ModelPatchClosedList_564419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a batch of sublists to an existing list entity in a version of the application.
  ## 
  let valid = call_564426.validator(path, query, header, formData, body)
  let scheme = call_564426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564426.url(scheme.get, call_564426.host, call_564426.base,
                         call_564426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564426, url, valid)

proc call*(call_564427: Call_ModelPatchClosedList_564419; clEntityId: string;
          closedListModelPatchObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelPatchClosedList
  ## Adds a batch of sublists to an existing list entity in a version of the application.
  ##   clEntityId: string (required)
  ##             : The list entity model ID.
  ##   closedListModelPatchObject: JObject (required)
  ##                             : A words list batch.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564428 = newJObject()
  var body_564429 = newJObject()
  add(path_564428, "clEntityId", newJString(clEntityId))
  if closedListModelPatchObject != nil:
    body_564429 = closedListModelPatchObject
  add(path_564428, "appId", newJString(appId))
  add(path_564428, "versionId", newJString(versionId))
  result = call_564427.call(path_564428, nil, nil, nil, body_564429)

var modelPatchClosedList* = Call_ModelPatchClosedList_564419(
    name: "modelPatchClosedList", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelPatchClosedList_564420, base: "",
    url: url_ModelPatchClosedList_564421, schemes: {Scheme.Https})
type
  Call_ModelDeleteClosedList_564410 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteClosedList_564412(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteClosedList_564411(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a list entity model from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The list entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564413 = path.getOrDefault("clEntityId")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "clEntityId", valid_564413
  var valid_564414 = path.getOrDefault("appId")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "appId", valid_564414
  var valid_564415 = path.getOrDefault("versionId")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "versionId", valid_564415
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564416: Call_ModelDeleteClosedList_564410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a list entity model from a version of the application.
  ## 
  let valid = call_564416.validator(path, query, header, formData, body)
  let scheme = call_564416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564416.url(scheme.get, call_564416.host, call_564416.base,
                         call_564416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564416, url, valid)

proc call*(call_564417: Call_ModelDeleteClosedList_564410; clEntityId: string;
          appId: string; versionId: string): Recallable =
  ## modelDeleteClosedList
  ## Deletes a list entity model from a version of the application.
  ##   clEntityId: string (required)
  ##             : The list entity model ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564418 = newJObject()
  add(path_564418, "clEntityId", newJString(clEntityId))
  add(path_564418, "appId", newJString(appId))
  add(path_564418, "versionId", newJString(versionId))
  result = call_564417.call(path_564418, nil, nil, nil, nil)

var modelDeleteClosedList* = Call_ModelDeleteClosedList_564410(
    name: "modelDeleteClosedList", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelDeleteClosedList_564411, base: "",
    url: url_ModelDeleteClosedList_564412, schemes: {Scheme.Https})
type
  Call_ModelAddSubList_564430 = ref object of OpenApiRestCall_563566
proc url_ModelAddSubList_564432(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId"),
               (kind: ConstantSegment, value: "/sublists")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddSubList_564431(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Adds a sublist to an existing list entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The list entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564433 = path.getOrDefault("clEntityId")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "clEntityId", valid_564433
  var valid_564434 = path.getOrDefault("appId")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "appId", valid_564434
  var valid_564435 = path.getOrDefault("versionId")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "versionId", valid_564435
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   wordListCreateObject: JObject (required)
  ##                       : Words list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564437: Call_ModelAddSubList_564430; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a sublist to an existing list entity in a version of the application.
  ## 
  let valid = call_564437.validator(path, query, header, formData, body)
  let scheme = call_564437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564437.url(scheme.get, call_564437.host, call_564437.base,
                         call_564437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564437, url, valid)

proc call*(call_564438: Call_ModelAddSubList_564430; clEntityId: string;
          wordListCreateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelAddSubList
  ## Adds a sublist to an existing list entity in a version of the application.
  ##   clEntityId: string (required)
  ##             : The list entity extractor ID.
  ##   wordListCreateObject: JObject (required)
  ##                       : Words list.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564439 = newJObject()
  var body_564440 = newJObject()
  add(path_564439, "clEntityId", newJString(clEntityId))
  if wordListCreateObject != nil:
    body_564440 = wordListCreateObject
  add(path_564439, "appId", newJString(appId))
  add(path_564439, "versionId", newJString(versionId))
  result = call_564438.call(path_564439, nil, nil, nil, body_564440)

var modelAddSubList* = Call_ModelAddSubList_564430(name: "modelAddSubList",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists",
    validator: validate_ModelAddSubList_564431, base: "", url: url_ModelAddSubList_564432,
    schemes: {Scheme.Https})
type
  Call_ModelUpdateSubList_564441 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateSubList_564443(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  assert "subListId" in path, "`subListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId"),
               (kind: ConstantSegment, value: "/sublists/"),
               (kind: VariableSegment, value: "subListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateSubList_564442(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates one of the list entity's sublists in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The list entity extractor ID.
  ##   subListId: JInt (required)
  ##            : The sublist ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564444 = path.getOrDefault("clEntityId")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "clEntityId", valid_564444
  var valid_564445 = path.getOrDefault("subListId")
  valid_564445 = validateParameter(valid_564445, JInt, required = true, default = nil)
  if valid_564445 != nil:
    section.add "subListId", valid_564445
  var valid_564446 = path.getOrDefault("appId")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "appId", valid_564446
  var valid_564447 = path.getOrDefault("versionId")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "versionId", valid_564447
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   wordListBaseUpdateObject: JObject (required)
  ##                           : A sublist update object containing the new canonical form and the list of words.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564449: Call_ModelUpdateSubList_564441; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates one of the list entity's sublists in a version of the application.
  ## 
  let valid = call_564449.validator(path, query, header, formData, body)
  let scheme = call_564449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564449.url(scheme.get, call_564449.host, call_564449.base,
                         call_564449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564449, url, valid)

proc call*(call_564450: Call_ModelUpdateSubList_564441; clEntityId: string;
          subListId: int; appId: string; versionId: string;
          wordListBaseUpdateObject: JsonNode): Recallable =
  ## modelUpdateSubList
  ## Updates one of the list entity's sublists in a version of the application.
  ##   clEntityId: string (required)
  ##             : The list entity extractor ID.
  ##   subListId: int (required)
  ##            : The sublist ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   wordListBaseUpdateObject: JObject (required)
  ##                           : A sublist update object containing the new canonical form and the list of words.
  var path_564451 = newJObject()
  var body_564452 = newJObject()
  add(path_564451, "clEntityId", newJString(clEntityId))
  add(path_564451, "subListId", newJInt(subListId))
  add(path_564451, "appId", newJString(appId))
  add(path_564451, "versionId", newJString(versionId))
  if wordListBaseUpdateObject != nil:
    body_564452 = wordListBaseUpdateObject
  result = call_564450.call(path_564451, nil, nil, nil, body_564452)

var modelUpdateSubList* = Call_ModelUpdateSubList_564441(
    name: "modelUpdateSubList", meth: HttpMethod.HttpPut, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists/{subListId}",
    validator: validate_ModelUpdateSubList_564442, base: "",
    url: url_ModelUpdateSubList_564443, schemes: {Scheme.Https})
type
  Call_ModelDeleteSubList_564453 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteSubList_564455(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  assert "subListId" in path, "`subListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId"),
               (kind: ConstantSegment, value: "/sublists/"),
               (kind: VariableSegment, value: "subListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteSubList_564454(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a sublist of a specific list entity model from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The list entity extractor ID.
  ##   subListId: JInt (required)
  ##            : The sublist ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564456 = path.getOrDefault("clEntityId")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "clEntityId", valid_564456
  var valid_564457 = path.getOrDefault("subListId")
  valid_564457 = validateParameter(valid_564457, JInt, required = true, default = nil)
  if valid_564457 != nil:
    section.add "subListId", valid_564457
  var valid_564458 = path.getOrDefault("appId")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "appId", valid_564458
  var valid_564459 = path.getOrDefault("versionId")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "versionId", valid_564459
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564460: Call_ModelDeleteSubList_564453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a sublist of a specific list entity model from a version of the application.
  ## 
  let valid = call_564460.validator(path, query, header, formData, body)
  let scheme = call_564460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564460.url(scheme.get, call_564460.host, call_564460.base,
                         call_564460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564460, url, valid)

proc call*(call_564461: Call_ModelDeleteSubList_564453; clEntityId: string;
          subListId: int; appId: string; versionId: string): Recallable =
  ## modelDeleteSubList
  ## Deletes a sublist of a specific list entity model from a version of the application.
  ##   clEntityId: string (required)
  ##             : The list entity extractor ID.
  ##   subListId: int (required)
  ##            : The sublist ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564462 = newJObject()
  add(path_564462, "clEntityId", newJString(clEntityId))
  add(path_564462, "subListId", newJInt(subListId))
  add(path_564462, "appId", newJString(appId))
  add(path_564462, "versionId", newJString(versionId))
  result = call_564461.call(path_564462, nil, nil, nil, nil)

var modelDeleteSubList* = Call_ModelDeleteSubList_564453(
    name: "modelDeleteSubList", meth: HttpMethod.HttpDelete, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists/{subListId}",
    validator: validate_ModelDeleteSubList_564454, base: "",
    url: url_ModelDeleteSubList_564455, schemes: {Scheme.Https})
type
  Call_ModelCreateClosedListEntityRole_564472 = ref object of OpenApiRestCall_563566
proc url_ModelCreateClosedListEntityRole_564474(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateClosedListEntityRole_564473(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564475 = path.getOrDefault("entityId")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "entityId", valid_564475
  var valid_564476 = path.getOrDefault("appId")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "appId", valid_564476
  var valid_564477 = path.getOrDefault("versionId")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "versionId", valid_564477
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564479: Call_ModelCreateClosedListEntityRole_564472;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564479.validator(path, query, header, formData, body)
  let scheme = call_564479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564479.url(scheme.get, call_564479.host, call_564479.base,
                         call_564479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564479, url, valid)

proc call*(call_564480: Call_ModelCreateClosedListEntityRole_564472;
          entityId: string; entityRoleCreateObject: JsonNode; appId: string;
          versionId: string): Recallable =
  ## modelCreateClosedListEntityRole
  ##   entityId: string (required)
  ##           : The entity model ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564481 = newJObject()
  var body_564482 = newJObject()
  add(path_564481, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_564482 = entityRoleCreateObject
  add(path_564481, "appId", newJString(appId))
  add(path_564481, "versionId", newJString(versionId))
  result = call_564480.call(path_564481, nil, nil, nil, body_564482)

var modelCreateClosedListEntityRole* = Call_ModelCreateClosedListEntityRole_564472(
    name: "modelCreateClosedListEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles",
    validator: validate_ModelCreateClosedListEntityRole_564473, base: "",
    url: url_ModelCreateClosedListEntityRole_564474, schemes: {Scheme.Https})
type
  Call_ModelListClosedListEntityRoles_564463 = ref object of OpenApiRestCall_563566
proc url_ModelListClosedListEntityRoles_564465(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListClosedListEntityRoles_564464(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity Id
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564466 = path.getOrDefault("entityId")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "entityId", valid_564466
  var valid_564467 = path.getOrDefault("appId")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "appId", valid_564467
  var valid_564468 = path.getOrDefault("versionId")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "versionId", valid_564468
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564469: Call_ModelListClosedListEntityRoles_564463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564469.validator(path, query, header, formData, body)
  let scheme = call_564469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564469.url(scheme.get, call_564469.host, call_564469.base,
                         call_564469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564469, url, valid)

proc call*(call_564470: Call_ModelListClosedListEntityRoles_564463;
          entityId: string; appId: string; versionId: string): Recallable =
  ## modelListClosedListEntityRoles
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564471 = newJObject()
  add(path_564471, "entityId", newJString(entityId))
  add(path_564471, "appId", newJString(appId))
  add(path_564471, "versionId", newJString(versionId))
  result = call_564470.call(path_564471, nil, nil, nil, nil)

var modelListClosedListEntityRoles* = Call_ModelListClosedListEntityRoles_564463(
    name: "modelListClosedListEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles",
    validator: validate_ModelListClosedListEntityRoles_564464, base: "",
    url: url_ModelListClosedListEntityRoles_564465, schemes: {Scheme.Https})
type
  Call_ModelUpdateClosedListEntityRole_564493 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateClosedListEntityRole_564495(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateClosedListEntityRole_564494(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564496 = path.getOrDefault("entityId")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "entityId", valid_564496
  var valid_564497 = path.getOrDefault("appId")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "appId", valid_564497
  var valid_564498 = path.getOrDefault("versionId")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "versionId", valid_564498
  var valid_564499 = path.getOrDefault("roleId")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "roleId", valid_564499
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564501: Call_ModelUpdateClosedListEntityRole_564493;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564501.validator(path, query, header, formData, body)
  let scheme = call_564501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564501.url(scheme.get, call_564501.host, call_564501.base,
                         call_564501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564501, url, valid)

proc call*(call_564502: Call_ModelUpdateClosedListEntityRole_564493;
          entityId: string; entityRoleUpdateObject: JsonNode; appId: string;
          versionId: string; roleId: string): Recallable =
  ## modelUpdateClosedListEntityRole
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_564503 = newJObject()
  var body_564504 = newJObject()
  add(path_564503, "entityId", newJString(entityId))
  if entityRoleUpdateObject != nil:
    body_564504 = entityRoleUpdateObject
  add(path_564503, "appId", newJString(appId))
  add(path_564503, "versionId", newJString(versionId))
  add(path_564503, "roleId", newJString(roleId))
  result = call_564502.call(path_564503, nil, nil, nil, body_564504)

var modelUpdateClosedListEntityRole* = Call_ModelUpdateClosedListEntityRole_564493(
    name: "modelUpdateClosedListEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdateClosedListEntityRole_564494, base: "",
    url: url_ModelUpdateClosedListEntityRole_564495, schemes: {Scheme.Https})
type
  Call_ModelGetClosedListEntityRole_564483 = ref object of OpenApiRestCall_563566
proc url_ModelGetClosedListEntityRole_564485(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetClosedListEntityRole_564484(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564486 = path.getOrDefault("entityId")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "entityId", valid_564486
  var valid_564487 = path.getOrDefault("appId")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "appId", valid_564487
  var valid_564488 = path.getOrDefault("versionId")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "versionId", valid_564488
  var valid_564489 = path.getOrDefault("roleId")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "roleId", valid_564489
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564490: Call_ModelGetClosedListEntityRole_564483; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564490.validator(path, query, header, formData, body)
  let scheme = call_564490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564490.url(scheme.get, call_564490.host, call_564490.base,
                         call_564490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564490, url, valid)

proc call*(call_564491: Call_ModelGetClosedListEntityRole_564483; entityId: string;
          appId: string; versionId: string; roleId: string): Recallable =
  ## modelGetClosedListEntityRole
  ##   entityId: string (required)
  ##           : entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_564492 = newJObject()
  add(path_564492, "entityId", newJString(entityId))
  add(path_564492, "appId", newJString(appId))
  add(path_564492, "versionId", newJString(versionId))
  add(path_564492, "roleId", newJString(roleId))
  result = call_564491.call(path_564492, nil, nil, nil, nil)

var modelGetClosedListEntityRole* = Call_ModelGetClosedListEntityRole_564483(
    name: "modelGetClosedListEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles/{roleId}",
    validator: validate_ModelGetClosedListEntityRole_564484, base: "",
    url: url_ModelGetClosedListEntityRole_564485, schemes: {Scheme.Https})
type
  Call_ModelDeleteClosedListEntityRole_564505 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteClosedListEntityRole_564507(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteClosedListEntityRole_564506(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564508 = path.getOrDefault("entityId")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "entityId", valid_564508
  var valid_564509 = path.getOrDefault("appId")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "appId", valid_564509
  var valid_564510 = path.getOrDefault("versionId")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = nil)
  if valid_564510 != nil:
    section.add "versionId", valid_564510
  var valid_564511 = path.getOrDefault("roleId")
  valid_564511 = validateParameter(valid_564511, JString, required = true,
                                 default = nil)
  if valid_564511 != nil:
    section.add "roleId", valid_564511
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564512: Call_ModelDeleteClosedListEntityRole_564505;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564512.validator(path, query, header, formData, body)
  let scheme = call_564512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564512.url(scheme.get, call_564512.host, call_564512.base,
                         call_564512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564512, url, valid)

proc call*(call_564513: Call_ModelDeleteClosedListEntityRole_564505;
          entityId: string; appId: string; versionId: string; roleId: string): Recallable =
  ## modelDeleteClosedListEntityRole
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_564514 = newJObject()
  add(path_564514, "entityId", newJString(entityId))
  add(path_564514, "appId", newJString(appId))
  add(path_564514, "versionId", newJString(versionId))
  add(path_564514, "roleId", newJString(roleId))
  result = call_564513.call(path_564514, nil, nil, nil, nil)

var modelDeleteClosedListEntityRole* = Call_ModelDeleteClosedListEntityRole_564505(
    name: "modelDeleteClosedListEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles/{roleId}",
    validator: validate_ModelDeleteClosedListEntityRole_564506, base: "",
    url: url_ModelDeleteClosedListEntityRole_564507, schemes: {Scheme.Https})
type
  Call_ModelAddCompositeEntity_564526 = ref object of OpenApiRestCall_563566
proc url_ModelAddCompositeEntity_564528(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddCompositeEntity_564527(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a composite entity extractor to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564529 = path.getOrDefault("appId")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "appId", valid_564529
  var valid_564530 = path.getOrDefault("versionId")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "versionId", valid_564530
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   compositeModelCreateObject: JObject (required)
  ##                             : A model containing the name and children of the new entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564532: Call_ModelAddCompositeEntity_564526; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a composite entity extractor to a version of the application.
  ## 
  let valid = call_564532.validator(path, query, header, formData, body)
  let scheme = call_564532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564532.url(scheme.get, call_564532.host, call_564532.base,
                         call_564532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564532, url, valid)

proc call*(call_564533: Call_ModelAddCompositeEntity_564526;
          compositeModelCreateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelAddCompositeEntity
  ## Adds a composite entity extractor to a version of the application.
  ##   compositeModelCreateObject: JObject (required)
  ##                             : A model containing the name and children of the new entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564534 = newJObject()
  var body_564535 = newJObject()
  if compositeModelCreateObject != nil:
    body_564535 = compositeModelCreateObject
  add(path_564534, "appId", newJString(appId))
  add(path_564534, "versionId", newJString(versionId))
  result = call_564533.call(path_564534, nil, nil, nil, body_564535)

var modelAddCompositeEntity* = Call_ModelAddCompositeEntity_564526(
    name: "modelAddCompositeEntity", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities",
    validator: validate_ModelAddCompositeEntity_564527, base: "",
    url: url_ModelAddCompositeEntity_564528, schemes: {Scheme.Https})
type
  Call_ModelListCompositeEntities_564515 = ref object of OpenApiRestCall_563566
proc url_ModelListCompositeEntities_564517(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListCompositeEntities_564516(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about all the composite entity models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564518 = path.getOrDefault("appId")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "appId", valid_564518
  var valid_564519 = path.getOrDefault("versionId")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "versionId", valid_564519
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564520 = query.getOrDefault("take")
  valid_564520 = validateParameter(valid_564520, JInt, required = false,
                                 default = newJInt(100))
  if valid_564520 != nil:
    section.add "take", valid_564520
  var valid_564521 = query.getOrDefault("skip")
  valid_564521 = validateParameter(valid_564521, JInt, required = false,
                                 default = newJInt(0))
  if valid_564521 != nil:
    section.add "skip", valid_564521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564522: Call_ModelListCompositeEntities_564515; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the composite entity models in a version of the application.
  ## 
  let valid = call_564522.validator(path, query, header, formData, body)
  let scheme = call_564522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564522.url(scheme.get, call_564522.host, call_564522.base,
                         call_564522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564522, url, valid)

proc call*(call_564523: Call_ModelListCompositeEntities_564515; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListCompositeEntities
  ## Gets information about all the composite entity models in a version of the application.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564524 = newJObject()
  var query_564525 = newJObject()
  add(query_564525, "take", newJInt(take))
  add(query_564525, "skip", newJInt(skip))
  add(path_564524, "appId", newJString(appId))
  add(path_564524, "versionId", newJString(versionId))
  result = call_564523.call(path_564524, query_564525, nil, nil, nil)

var modelListCompositeEntities* = Call_ModelListCompositeEntities_564515(
    name: "modelListCompositeEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities",
    validator: validate_ModelListCompositeEntities_564516, base: "",
    url: url_ModelListCompositeEntities_564517, schemes: {Scheme.Https})
type
  Call_ModelUpdateCompositeEntity_564545 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateCompositeEntity_564547(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateCompositeEntity_564546(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a composite entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `cEntityId` field"
  var valid_564548 = path.getOrDefault("cEntityId")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "cEntityId", valid_564548
  var valid_564549 = path.getOrDefault("appId")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = nil)
  if valid_564549 != nil:
    section.add "appId", valid_564549
  var valid_564550 = path.getOrDefault("versionId")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "versionId", valid_564550
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   compositeModelUpdateObject: JObject (required)
  ##                             : A model object containing the new entity extractor name and children.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564552: Call_ModelUpdateCompositeEntity_564545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a composite entity in a version of the application.
  ## 
  let valid = call_564552.validator(path, query, header, formData, body)
  let scheme = call_564552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564552.url(scheme.get, call_564552.host, call_564552.base,
                         call_564552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564552, url, valid)

proc call*(call_564553: Call_ModelUpdateCompositeEntity_564545; cEntityId: string;
          compositeModelUpdateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelUpdateCompositeEntity
  ## Updates a composite entity in a version of the application.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   compositeModelUpdateObject: JObject (required)
  ##                             : A model object containing the new entity extractor name and children.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564554 = newJObject()
  var body_564555 = newJObject()
  add(path_564554, "cEntityId", newJString(cEntityId))
  if compositeModelUpdateObject != nil:
    body_564555 = compositeModelUpdateObject
  add(path_564554, "appId", newJString(appId))
  add(path_564554, "versionId", newJString(versionId))
  result = call_564553.call(path_564554, nil, nil, nil, body_564555)

var modelUpdateCompositeEntity* = Call_ModelUpdateCompositeEntity_564545(
    name: "modelUpdateCompositeEntity", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelUpdateCompositeEntity_564546, base: "",
    url: url_ModelUpdateCompositeEntity_564547, schemes: {Scheme.Https})
type
  Call_ModelGetCompositeEntity_564536 = ref object of OpenApiRestCall_563566
proc url_ModelGetCompositeEntity_564538(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetCompositeEntity_564537(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a composite entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `cEntityId` field"
  var valid_564539 = path.getOrDefault("cEntityId")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "cEntityId", valid_564539
  var valid_564540 = path.getOrDefault("appId")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "appId", valid_564540
  var valid_564541 = path.getOrDefault("versionId")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "versionId", valid_564541
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564542: Call_ModelGetCompositeEntity_564536; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a composite entity in a version of the application.
  ## 
  let valid = call_564542.validator(path, query, header, formData, body)
  let scheme = call_564542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564542.url(scheme.get, call_564542.host, call_564542.base,
                         call_564542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564542, url, valid)

proc call*(call_564543: Call_ModelGetCompositeEntity_564536; cEntityId: string;
          appId: string; versionId: string): Recallable =
  ## modelGetCompositeEntity
  ## Gets information about a composite entity in a version of the application.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564544 = newJObject()
  add(path_564544, "cEntityId", newJString(cEntityId))
  add(path_564544, "appId", newJString(appId))
  add(path_564544, "versionId", newJString(versionId))
  result = call_564543.call(path_564544, nil, nil, nil, nil)

var modelGetCompositeEntity* = Call_ModelGetCompositeEntity_564536(
    name: "modelGetCompositeEntity", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelGetCompositeEntity_564537, base: "",
    url: url_ModelGetCompositeEntity_564538, schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntity_564556 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteCompositeEntity_564558(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteCompositeEntity_564557(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a composite entity from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `cEntityId` field"
  var valid_564559 = path.getOrDefault("cEntityId")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "cEntityId", valid_564559
  var valid_564560 = path.getOrDefault("appId")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "appId", valid_564560
  var valid_564561 = path.getOrDefault("versionId")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "versionId", valid_564561
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564562: Call_ModelDeleteCompositeEntity_564556; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a composite entity from a version of the application.
  ## 
  let valid = call_564562.validator(path, query, header, formData, body)
  let scheme = call_564562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564562.url(scheme.get, call_564562.host, call_564562.base,
                         call_564562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564562, url, valid)

proc call*(call_564563: Call_ModelDeleteCompositeEntity_564556; cEntityId: string;
          appId: string; versionId: string): Recallable =
  ## modelDeleteCompositeEntity
  ## Deletes a composite entity from a version of the application.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564564 = newJObject()
  add(path_564564, "cEntityId", newJString(cEntityId))
  add(path_564564, "appId", newJString(appId))
  add(path_564564, "versionId", newJString(versionId))
  result = call_564563.call(path_564564, nil, nil, nil, nil)

var modelDeleteCompositeEntity* = Call_ModelDeleteCompositeEntity_564556(
    name: "modelDeleteCompositeEntity", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelDeleteCompositeEntity_564557, base: "",
    url: url_ModelDeleteCompositeEntity_564558, schemes: {Scheme.Https})
type
  Call_ModelAddCompositeEntityChild_564565 = ref object of OpenApiRestCall_563566
proc url_ModelAddCompositeEntityChild_564567(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/children")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddCompositeEntityChild_564566(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a single child in an existing composite entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `cEntityId` field"
  var valid_564568 = path.getOrDefault("cEntityId")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "cEntityId", valid_564568
  var valid_564569 = path.getOrDefault("appId")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "appId", valid_564569
  var valid_564570 = path.getOrDefault("versionId")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "versionId", valid_564570
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   compositeChildModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the new composite child model.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564572: Call_ModelAddCompositeEntityChild_564565; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a single child in an existing composite entity model in a version of the application.
  ## 
  let valid = call_564572.validator(path, query, header, formData, body)
  let scheme = call_564572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564572.url(scheme.get, call_564572.host, call_564572.base,
                         call_564572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564572, url, valid)

proc call*(call_564573: Call_ModelAddCompositeEntityChild_564565;
          cEntityId: string; appId: string;
          compositeChildModelCreateObject: JsonNode; versionId: string): Recallable =
  ## modelAddCompositeEntityChild
  ## Creates a single child in an existing composite entity model in a version of the application.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   compositeChildModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the new composite child model.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564574 = newJObject()
  var body_564575 = newJObject()
  add(path_564574, "cEntityId", newJString(cEntityId))
  add(path_564574, "appId", newJString(appId))
  if compositeChildModelCreateObject != nil:
    body_564575 = compositeChildModelCreateObject
  add(path_564574, "versionId", newJString(versionId))
  result = call_564573.call(path_564574, nil, nil, nil, body_564575)

var modelAddCompositeEntityChild* = Call_ModelAddCompositeEntityChild_564565(
    name: "modelAddCompositeEntityChild", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/children",
    validator: validate_ModelAddCompositeEntityChild_564566, base: "",
    url: url_ModelAddCompositeEntityChild_564567, schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntityChild_564576 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteCompositeEntityChild_564578(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  assert "cChildId" in path, "`cChildId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/children/"),
               (kind: VariableSegment, value: "cChildId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteCompositeEntityChild_564577(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a composite entity extractor child from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  ##   cChildId: JString (required)
  ##           : The hierarchical entity extractor child ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `cEntityId` field"
  var valid_564579 = path.getOrDefault("cEntityId")
  valid_564579 = validateParameter(valid_564579, JString, required = true,
                                 default = nil)
  if valid_564579 != nil:
    section.add "cEntityId", valid_564579
  var valid_564580 = path.getOrDefault("cChildId")
  valid_564580 = validateParameter(valid_564580, JString, required = true,
                                 default = nil)
  if valid_564580 != nil:
    section.add "cChildId", valid_564580
  var valid_564581 = path.getOrDefault("appId")
  valid_564581 = validateParameter(valid_564581, JString, required = true,
                                 default = nil)
  if valid_564581 != nil:
    section.add "appId", valid_564581
  var valid_564582 = path.getOrDefault("versionId")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "versionId", valid_564582
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564583: Call_ModelDeleteCompositeEntityChild_564576;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a composite entity extractor child from a version of the application.
  ## 
  let valid = call_564583.validator(path, query, header, formData, body)
  let scheme = call_564583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564583.url(scheme.get, call_564583.host, call_564583.base,
                         call_564583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564583, url, valid)

proc call*(call_564584: Call_ModelDeleteCompositeEntityChild_564576;
          cEntityId: string; cChildId: string; appId: string; versionId: string): Recallable =
  ## modelDeleteCompositeEntityChild
  ## Deletes a composite entity extractor child from a version of the application.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   cChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564585 = newJObject()
  add(path_564585, "cEntityId", newJString(cEntityId))
  add(path_564585, "cChildId", newJString(cChildId))
  add(path_564585, "appId", newJString(appId))
  add(path_564585, "versionId", newJString(versionId))
  result = call_564584.call(path_564585, nil, nil, nil, nil)

var modelDeleteCompositeEntityChild* = Call_ModelDeleteCompositeEntityChild_564576(
    name: "modelDeleteCompositeEntityChild", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/children/{cChildId}",
    validator: validate_ModelDeleteCompositeEntityChild_564577, base: "",
    url: url_ModelDeleteCompositeEntityChild_564578, schemes: {Scheme.Https})
type
  Call_ModelCreateCompositeEntityRole_564595 = ref object of OpenApiRestCall_563566
proc url_ModelCreateCompositeEntityRole_564597(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateCompositeEntityRole_564596(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `cEntityId` field"
  var valid_564598 = path.getOrDefault("cEntityId")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "cEntityId", valid_564598
  var valid_564599 = path.getOrDefault("appId")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "appId", valid_564599
  var valid_564600 = path.getOrDefault("versionId")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "versionId", valid_564600
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564602: Call_ModelCreateCompositeEntityRole_564595; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564602.validator(path, query, header, formData, body)
  let scheme = call_564602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564602.url(scheme.get, call_564602.host, call_564602.base,
                         call_564602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564602, url, valid)

proc call*(call_564603: Call_ModelCreateCompositeEntityRole_564595;
          cEntityId: string; entityRoleCreateObject: JsonNode; appId: string;
          versionId: string): Recallable =
  ## modelCreateCompositeEntityRole
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564604 = newJObject()
  var body_564605 = newJObject()
  add(path_564604, "cEntityId", newJString(cEntityId))
  if entityRoleCreateObject != nil:
    body_564605 = entityRoleCreateObject
  add(path_564604, "appId", newJString(appId))
  add(path_564604, "versionId", newJString(versionId))
  result = call_564603.call(path_564604, nil, nil, nil, body_564605)

var modelCreateCompositeEntityRole* = Call_ModelCreateCompositeEntityRole_564595(
    name: "modelCreateCompositeEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles",
    validator: validate_ModelCreateCompositeEntityRole_564596, base: "",
    url: url_ModelCreateCompositeEntityRole_564597, schemes: {Scheme.Https})
type
  Call_ModelListCompositeEntityRoles_564586 = ref object of OpenApiRestCall_563566
proc url_ModelListCompositeEntityRoles_564588(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListCompositeEntityRoles_564587(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `cEntityId` field"
  var valid_564589 = path.getOrDefault("cEntityId")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "cEntityId", valid_564589
  var valid_564590 = path.getOrDefault("appId")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "appId", valid_564590
  var valid_564591 = path.getOrDefault("versionId")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "versionId", valid_564591
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564592: Call_ModelListCompositeEntityRoles_564586; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564592.validator(path, query, header, formData, body)
  let scheme = call_564592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564592.url(scheme.get, call_564592.host, call_564592.base,
                         call_564592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564592, url, valid)

proc call*(call_564593: Call_ModelListCompositeEntityRoles_564586;
          cEntityId: string; appId: string; versionId: string): Recallable =
  ## modelListCompositeEntityRoles
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564594 = newJObject()
  add(path_564594, "cEntityId", newJString(cEntityId))
  add(path_564594, "appId", newJString(appId))
  add(path_564594, "versionId", newJString(versionId))
  result = call_564593.call(path_564594, nil, nil, nil, nil)

var modelListCompositeEntityRoles* = Call_ModelListCompositeEntityRoles_564586(
    name: "modelListCompositeEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles",
    validator: validate_ModelListCompositeEntityRoles_564587, base: "",
    url: url_ModelListCompositeEntityRoles_564588, schemes: {Scheme.Https})
type
  Call_ModelUpdateCompositeEntityRole_564616 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateCompositeEntityRole_564618(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateCompositeEntityRole_564617(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `cEntityId` field"
  var valid_564619 = path.getOrDefault("cEntityId")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "cEntityId", valid_564619
  var valid_564620 = path.getOrDefault("appId")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "appId", valid_564620
  var valid_564621 = path.getOrDefault("versionId")
  valid_564621 = validateParameter(valid_564621, JString, required = true,
                                 default = nil)
  if valid_564621 != nil:
    section.add "versionId", valid_564621
  var valid_564622 = path.getOrDefault("roleId")
  valid_564622 = validateParameter(valid_564622, JString, required = true,
                                 default = nil)
  if valid_564622 != nil:
    section.add "roleId", valid_564622
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564624: Call_ModelUpdateCompositeEntityRole_564616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564624.validator(path, query, header, formData, body)
  let scheme = call_564624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564624.url(scheme.get, call_564624.host, call_564624.base,
                         call_564624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564624, url, valid)

proc call*(call_564625: Call_ModelUpdateCompositeEntityRole_564616;
          cEntityId: string; entityRoleUpdateObject: JsonNode; appId: string;
          versionId: string; roleId: string): Recallable =
  ## modelUpdateCompositeEntityRole
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_564626 = newJObject()
  var body_564627 = newJObject()
  add(path_564626, "cEntityId", newJString(cEntityId))
  if entityRoleUpdateObject != nil:
    body_564627 = entityRoleUpdateObject
  add(path_564626, "appId", newJString(appId))
  add(path_564626, "versionId", newJString(versionId))
  add(path_564626, "roleId", newJString(roleId))
  result = call_564625.call(path_564626, nil, nil, nil, body_564627)

var modelUpdateCompositeEntityRole* = Call_ModelUpdateCompositeEntityRole_564616(
    name: "modelUpdateCompositeEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles/{roleId}",
    validator: validate_ModelUpdateCompositeEntityRole_564617, base: "",
    url: url_ModelUpdateCompositeEntityRole_564618, schemes: {Scheme.Https})
type
  Call_ModelGetCompositeEntityRole_564606 = ref object of OpenApiRestCall_563566
proc url_ModelGetCompositeEntityRole_564608(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetCompositeEntityRole_564607(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `cEntityId` field"
  var valid_564609 = path.getOrDefault("cEntityId")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "cEntityId", valid_564609
  var valid_564610 = path.getOrDefault("appId")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "appId", valid_564610
  var valid_564611 = path.getOrDefault("versionId")
  valid_564611 = validateParameter(valid_564611, JString, required = true,
                                 default = nil)
  if valid_564611 != nil:
    section.add "versionId", valid_564611
  var valid_564612 = path.getOrDefault("roleId")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "roleId", valid_564612
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564613: Call_ModelGetCompositeEntityRole_564606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564613.validator(path, query, header, formData, body)
  let scheme = call_564613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564613.url(scheme.get, call_564613.host, call_564613.base,
                         call_564613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564613, url, valid)

proc call*(call_564614: Call_ModelGetCompositeEntityRole_564606; cEntityId: string;
          appId: string; versionId: string; roleId: string): Recallable =
  ## modelGetCompositeEntityRole
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_564615 = newJObject()
  add(path_564615, "cEntityId", newJString(cEntityId))
  add(path_564615, "appId", newJString(appId))
  add(path_564615, "versionId", newJString(versionId))
  add(path_564615, "roleId", newJString(roleId))
  result = call_564614.call(path_564615, nil, nil, nil, nil)

var modelGetCompositeEntityRole* = Call_ModelGetCompositeEntityRole_564606(
    name: "modelGetCompositeEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles/{roleId}",
    validator: validate_ModelGetCompositeEntityRole_564607, base: "",
    url: url_ModelGetCompositeEntityRole_564608, schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntityRole_564628 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteCompositeEntityRole_564630(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteCompositeEntityRole_564629(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `cEntityId` field"
  var valid_564631 = path.getOrDefault("cEntityId")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "cEntityId", valid_564631
  var valid_564632 = path.getOrDefault("appId")
  valid_564632 = validateParameter(valid_564632, JString, required = true,
                                 default = nil)
  if valid_564632 != nil:
    section.add "appId", valid_564632
  var valid_564633 = path.getOrDefault("versionId")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "versionId", valid_564633
  var valid_564634 = path.getOrDefault("roleId")
  valid_564634 = validateParameter(valid_564634, JString, required = true,
                                 default = nil)
  if valid_564634 != nil:
    section.add "roleId", valid_564634
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564635: Call_ModelDeleteCompositeEntityRole_564628; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564635.validator(path, query, header, formData, body)
  let scheme = call_564635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564635.url(scheme.get, call_564635.host, call_564635.base,
                         call_564635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564635, url, valid)

proc call*(call_564636: Call_ModelDeleteCompositeEntityRole_564628;
          cEntityId: string; appId: string; versionId: string; roleId: string): Recallable =
  ## modelDeleteCompositeEntityRole
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_564637 = newJObject()
  add(path_564637, "cEntityId", newJString(cEntityId))
  add(path_564637, "appId", newJString(appId))
  add(path_564637, "versionId", newJString(versionId))
  add(path_564637, "roleId", newJString(roleId))
  result = call_564636.call(path_564637, nil, nil, nil, nil)

var modelDeleteCompositeEntityRole* = Call_ModelDeleteCompositeEntityRole_564628(
    name: "modelDeleteCompositeEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles/{roleId}",
    validator: validate_ModelDeleteCompositeEntityRole_564629, base: "",
    url: url_ModelDeleteCompositeEntityRole_564630, schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltDomain_564638 = ref object of OpenApiRestCall_563566
proc url_ModelAddCustomPrebuiltDomain_564640(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltdomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddCustomPrebuiltDomain_564639(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a customizable prebuilt domain along with all of its intent and entity models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564641 = path.getOrDefault("appId")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "appId", valid_564641
  var valid_564642 = path.getOrDefault("versionId")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "versionId", valid_564642
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   prebuiltDomainObject: JObject (required)
  ##                       : A prebuilt domain create object containing the name of the domain.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564644: Call_ModelAddCustomPrebuiltDomain_564638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a customizable prebuilt domain along with all of its intent and entity models in a version of the application.
  ## 
  let valid = call_564644.validator(path, query, header, formData, body)
  let scheme = call_564644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564644.url(scheme.get, call_564644.host, call_564644.base,
                         call_564644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564644, url, valid)

proc call*(call_564645: Call_ModelAddCustomPrebuiltDomain_564638; appId: string;
          prebuiltDomainObject: JsonNode; versionId: string): Recallable =
  ## modelAddCustomPrebuiltDomain
  ## Adds a customizable prebuilt domain along with all of its intent and entity models in a version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   prebuiltDomainObject: JObject (required)
  ##                       : A prebuilt domain create object containing the name of the domain.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564646 = newJObject()
  var body_564647 = newJObject()
  add(path_564646, "appId", newJString(appId))
  if prebuiltDomainObject != nil:
    body_564647 = prebuiltDomainObject
  add(path_564646, "versionId", newJString(versionId))
  result = call_564645.call(path_564646, nil, nil, nil, body_564647)

var modelAddCustomPrebuiltDomain* = Call_ModelAddCustomPrebuiltDomain_564638(
    name: "modelAddCustomPrebuiltDomain", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltdomains",
    validator: validate_ModelAddCustomPrebuiltDomain_564639, base: "",
    url: url_ModelAddCustomPrebuiltDomain_564640, schemes: {Scheme.Https})
type
  Call_ModelDeleteCustomPrebuiltDomain_564648 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteCustomPrebuiltDomain_564650(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltdomains/"),
               (kind: VariableSegment, value: "domainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteCustomPrebuiltDomain_564649(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a prebuilt domain's models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   domainName: JString (required)
  ##             : Domain name.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564651 = path.getOrDefault("appId")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "appId", valid_564651
  var valid_564652 = path.getOrDefault("domainName")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "domainName", valid_564652
  var valid_564653 = path.getOrDefault("versionId")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "versionId", valid_564653
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564654: Call_ModelDeleteCustomPrebuiltDomain_564648;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a prebuilt domain's models in a version of the application.
  ## 
  let valid = call_564654.validator(path, query, header, formData, body)
  let scheme = call_564654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564654.url(scheme.get, call_564654.host, call_564654.base,
                         call_564654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564654, url, valid)

proc call*(call_564655: Call_ModelDeleteCustomPrebuiltDomain_564648; appId: string;
          domainName: string; versionId: string): Recallable =
  ## modelDeleteCustomPrebuiltDomain
  ## Deletes a prebuilt domain's models in a version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   domainName: string (required)
  ##             : Domain name.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564656 = newJObject()
  add(path_564656, "appId", newJString(appId))
  add(path_564656, "domainName", newJString(domainName))
  add(path_564656, "versionId", newJString(versionId))
  result = call_564655.call(path_564656, nil, nil, nil, nil)

var modelDeleteCustomPrebuiltDomain* = Call_ModelDeleteCustomPrebuiltDomain_564648(
    name: "modelDeleteCustomPrebuiltDomain", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltdomains/{domainName}",
    validator: validate_ModelDeleteCustomPrebuiltDomain_564649, base: "",
    url: url_ModelDeleteCustomPrebuiltDomain_564650, schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltEntity_564665 = ref object of OpenApiRestCall_563566
proc url_ModelAddCustomPrebuiltEntity_564667(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddCustomPrebuiltEntity_564666(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a prebuilt entity model to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564668 = path.getOrDefault("appId")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "appId", valid_564668
  var valid_564669 = path.getOrDefault("versionId")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "versionId", valid_564669
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the prebuilt entity and the name of the domain to which this model belongs.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564671: Call_ModelAddCustomPrebuiltEntity_564665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a prebuilt entity model to a version of the application.
  ## 
  let valid = call_564671.validator(path, query, header, formData, body)
  let scheme = call_564671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564671.url(scheme.get, call_564671.host, call_564671.base,
                         call_564671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564671, url, valid)

proc call*(call_564672: Call_ModelAddCustomPrebuiltEntity_564665;
          prebuiltDomainModelCreateObject: JsonNode; appId: string;
          versionId: string): Recallable =
  ## modelAddCustomPrebuiltEntity
  ## Adds a prebuilt entity model to a version of the application.
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the prebuilt entity and the name of the domain to which this model belongs.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564673 = newJObject()
  var body_564674 = newJObject()
  if prebuiltDomainModelCreateObject != nil:
    body_564674 = prebuiltDomainModelCreateObject
  add(path_564673, "appId", newJString(appId))
  add(path_564673, "versionId", newJString(versionId))
  result = call_564672.call(path_564673, nil, nil, nil, body_564674)

var modelAddCustomPrebuiltEntity* = Call_ModelAddCustomPrebuiltEntity_564665(
    name: "modelAddCustomPrebuiltEntity", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltentities",
    validator: validate_ModelAddCustomPrebuiltEntity_564666, base: "",
    url: url_ModelAddCustomPrebuiltEntity_564667, schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltEntities_564657 = ref object of OpenApiRestCall_563566
proc url_ModelListCustomPrebuiltEntities_564659(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListCustomPrebuiltEntities_564658(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all prebuilt entities used in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564660 = path.getOrDefault("appId")
  valid_564660 = validateParameter(valid_564660, JString, required = true,
                                 default = nil)
  if valid_564660 != nil:
    section.add "appId", valid_564660
  var valid_564661 = path.getOrDefault("versionId")
  valid_564661 = validateParameter(valid_564661, JString, required = true,
                                 default = nil)
  if valid_564661 != nil:
    section.add "versionId", valid_564661
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564662: Call_ModelListCustomPrebuiltEntities_564657;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all prebuilt entities used in a version of the application.
  ## 
  let valid = call_564662.validator(path, query, header, formData, body)
  let scheme = call_564662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564662.url(scheme.get, call_564662.host, call_564662.base,
                         call_564662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564662, url, valid)

proc call*(call_564663: Call_ModelListCustomPrebuiltEntities_564657; appId: string;
          versionId: string): Recallable =
  ## modelListCustomPrebuiltEntities
  ## Gets all prebuilt entities used in a version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564664 = newJObject()
  add(path_564664, "appId", newJString(appId))
  add(path_564664, "versionId", newJString(versionId))
  result = call_564663.call(path_564664, nil, nil, nil, nil)

var modelListCustomPrebuiltEntities* = Call_ModelListCustomPrebuiltEntities_564657(
    name: "modelListCustomPrebuiltEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltentities",
    validator: validate_ModelListCustomPrebuiltEntities_564658, base: "",
    url: url_ModelListCustomPrebuiltEntities_564659, schemes: {Scheme.Https})
type
  Call_ModelCreateCustomPrebuiltEntityRole_564684 = ref object of OpenApiRestCall_563566
proc url_ModelCreateCustomPrebuiltEntityRole_564686(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateCustomPrebuiltEntityRole_564685(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564687 = path.getOrDefault("entityId")
  valid_564687 = validateParameter(valid_564687, JString, required = true,
                                 default = nil)
  if valid_564687 != nil:
    section.add "entityId", valid_564687
  var valid_564688 = path.getOrDefault("appId")
  valid_564688 = validateParameter(valid_564688, JString, required = true,
                                 default = nil)
  if valid_564688 != nil:
    section.add "appId", valid_564688
  var valid_564689 = path.getOrDefault("versionId")
  valid_564689 = validateParameter(valid_564689, JString, required = true,
                                 default = nil)
  if valid_564689 != nil:
    section.add "versionId", valid_564689
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564691: Call_ModelCreateCustomPrebuiltEntityRole_564684;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564691.validator(path, query, header, formData, body)
  let scheme = call_564691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564691.url(scheme.get, call_564691.host, call_564691.base,
                         call_564691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564691, url, valid)

proc call*(call_564692: Call_ModelCreateCustomPrebuiltEntityRole_564684;
          entityId: string; entityRoleCreateObject: JsonNode; appId: string;
          versionId: string): Recallable =
  ## modelCreateCustomPrebuiltEntityRole
  ##   entityId: string (required)
  ##           : The entity model ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564693 = newJObject()
  var body_564694 = newJObject()
  add(path_564693, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_564694 = entityRoleCreateObject
  add(path_564693, "appId", newJString(appId))
  add(path_564693, "versionId", newJString(versionId))
  result = call_564692.call(path_564693, nil, nil, nil, body_564694)

var modelCreateCustomPrebuiltEntityRole* = Call_ModelCreateCustomPrebuiltEntityRole_564684(
    name: "modelCreateCustomPrebuiltEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles",
    validator: validate_ModelCreateCustomPrebuiltEntityRole_564685, base: "",
    url: url_ModelCreateCustomPrebuiltEntityRole_564686, schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltEntityRoles_564675 = ref object of OpenApiRestCall_563566
proc url_ModelListCustomPrebuiltEntityRoles_564677(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListCustomPrebuiltEntityRoles_564676(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity Id
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564678 = path.getOrDefault("entityId")
  valid_564678 = validateParameter(valid_564678, JString, required = true,
                                 default = nil)
  if valid_564678 != nil:
    section.add "entityId", valid_564678
  var valid_564679 = path.getOrDefault("appId")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "appId", valid_564679
  var valid_564680 = path.getOrDefault("versionId")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "versionId", valid_564680
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564681: Call_ModelListCustomPrebuiltEntityRoles_564675;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564681.validator(path, query, header, formData, body)
  let scheme = call_564681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564681.url(scheme.get, call_564681.host, call_564681.base,
                         call_564681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564681, url, valid)

proc call*(call_564682: Call_ModelListCustomPrebuiltEntityRoles_564675;
          entityId: string; appId: string; versionId: string): Recallable =
  ## modelListCustomPrebuiltEntityRoles
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564683 = newJObject()
  add(path_564683, "entityId", newJString(entityId))
  add(path_564683, "appId", newJString(appId))
  add(path_564683, "versionId", newJString(versionId))
  result = call_564682.call(path_564683, nil, nil, nil, nil)

var modelListCustomPrebuiltEntityRoles* = Call_ModelListCustomPrebuiltEntityRoles_564675(
    name: "modelListCustomPrebuiltEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles",
    validator: validate_ModelListCustomPrebuiltEntityRoles_564676, base: "",
    url: url_ModelListCustomPrebuiltEntityRoles_564677, schemes: {Scheme.Https})
type
  Call_ModelUpdateCustomPrebuiltEntityRole_564705 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateCustomPrebuiltEntityRole_564707(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateCustomPrebuiltEntityRole_564706(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564708 = path.getOrDefault("entityId")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "entityId", valid_564708
  var valid_564709 = path.getOrDefault("appId")
  valid_564709 = validateParameter(valid_564709, JString, required = true,
                                 default = nil)
  if valid_564709 != nil:
    section.add "appId", valid_564709
  var valid_564710 = path.getOrDefault("versionId")
  valid_564710 = validateParameter(valid_564710, JString, required = true,
                                 default = nil)
  if valid_564710 != nil:
    section.add "versionId", valid_564710
  var valid_564711 = path.getOrDefault("roleId")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = nil)
  if valid_564711 != nil:
    section.add "roleId", valid_564711
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564713: Call_ModelUpdateCustomPrebuiltEntityRole_564705;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564713.validator(path, query, header, formData, body)
  let scheme = call_564713.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564713.url(scheme.get, call_564713.host, call_564713.base,
                         call_564713.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564713, url, valid)

proc call*(call_564714: Call_ModelUpdateCustomPrebuiltEntityRole_564705;
          entityId: string; entityRoleUpdateObject: JsonNode; appId: string;
          versionId: string; roleId: string): Recallable =
  ## modelUpdateCustomPrebuiltEntityRole
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_564715 = newJObject()
  var body_564716 = newJObject()
  add(path_564715, "entityId", newJString(entityId))
  if entityRoleUpdateObject != nil:
    body_564716 = entityRoleUpdateObject
  add(path_564715, "appId", newJString(appId))
  add(path_564715, "versionId", newJString(versionId))
  add(path_564715, "roleId", newJString(roleId))
  result = call_564714.call(path_564715, nil, nil, nil, body_564716)

var modelUpdateCustomPrebuiltEntityRole* = Call_ModelUpdateCustomPrebuiltEntityRole_564705(
    name: "modelUpdateCustomPrebuiltEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdateCustomPrebuiltEntityRole_564706, base: "",
    url: url_ModelUpdateCustomPrebuiltEntityRole_564707, schemes: {Scheme.Https})
type
  Call_ModelGetCustomEntityRole_564695 = ref object of OpenApiRestCall_563566
proc url_ModelGetCustomEntityRole_564697(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetCustomEntityRole_564696(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564698 = path.getOrDefault("entityId")
  valid_564698 = validateParameter(valid_564698, JString, required = true,
                                 default = nil)
  if valid_564698 != nil:
    section.add "entityId", valid_564698
  var valid_564699 = path.getOrDefault("appId")
  valid_564699 = validateParameter(valid_564699, JString, required = true,
                                 default = nil)
  if valid_564699 != nil:
    section.add "appId", valid_564699
  var valid_564700 = path.getOrDefault("versionId")
  valid_564700 = validateParameter(valid_564700, JString, required = true,
                                 default = nil)
  if valid_564700 != nil:
    section.add "versionId", valid_564700
  var valid_564701 = path.getOrDefault("roleId")
  valid_564701 = validateParameter(valid_564701, JString, required = true,
                                 default = nil)
  if valid_564701 != nil:
    section.add "roleId", valid_564701
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564702: Call_ModelGetCustomEntityRole_564695; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564702.validator(path, query, header, formData, body)
  let scheme = call_564702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564702.url(scheme.get, call_564702.host, call_564702.base,
                         call_564702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564702, url, valid)

proc call*(call_564703: Call_ModelGetCustomEntityRole_564695; entityId: string;
          appId: string; versionId: string; roleId: string): Recallable =
  ## modelGetCustomEntityRole
  ##   entityId: string (required)
  ##           : entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_564704 = newJObject()
  add(path_564704, "entityId", newJString(entityId))
  add(path_564704, "appId", newJString(appId))
  add(path_564704, "versionId", newJString(versionId))
  add(path_564704, "roleId", newJString(roleId))
  result = call_564703.call(path_564704, nil, nil, nil, nil)

var modelGetCustomEntityRole* = Call_ModelGetCustomEntityRole_564695(
    name: "modelGetCustomEntityRole", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles/{roleId}",
    validator: validate_ModelGetCustomEntityRole_564696, base: "",
    url: url_ModelGetCustomEntityRole_564697, schemes: {Scheme.Https})
type
  Call_ModelDeleteCustomEntityRole_564717 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteCustomEntityRole_564719(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteCustomEntityRole_564718(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564720 = path.getOrDefault("entityId")
  valid_564720 = validateParameter(valid_564720, JString, required = true,
                                 default = nil)
  if valid_564720 != nil:
    section.add "entityId", valid_564720
  var valid_564721 = path.getOrDefault("appId")
  valid_564721 = validateParameter(valid_564721, JString, required = true,
                                 default = nil)
  if valid_564721 != nil:
    section.add "appId", valid_564721
  var valid_564722 = path.getOrDefault("versionId")
  valid_564722 = validateParameter(valid_564722, JString, required = true,
                                 default = nil)
  if valid_564722 != nil:
    section.add "versionId", valid_564722
  var valid_564723 = path.getOrDefault("roleId")
  valid_564723 = validateParameter(valid_564723, JString, required = true,
                                 default = nil)
  if valid_564723 != nil:
    section.add "roleId", valid_564723
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564724: Call_ModelDeleteCustomEntityRole_564717; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564724.validator(path, query, header, formData, body)
  let scheme = call_564724.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564724.url(scheme.get, call_564724.host, call_564724.base,
                         call_564724.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564724, url, valid)

proc call*(call_564725: Call_ModelDeleteCustomEntityRole_564717; entityId: string;
          appId: string; versionId: string; roleId: string): Recallable =
  ## modelDeleteCustomEntityRole
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_564726 = newJObject()
  add(path_564726, "entityId", newJString(entityId))
  add(path_564726, "appId", newJString(appId))
  add(path_564726, "versionId", newJString(versionId))
  add(path_564726, "roleId", newJString(roleId))
  result = call_564725.call(path_564726, nil, nil, nil, nil)

var modelDeleteCustomEntityRole* = Call_ModelDeleteCustomEntityRole_564717(
    name: "modelDeleteCustomEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles/{roleId}",
    validator: validate_ModelDeleteCustomEntityRole_564718, base: "",
    url: url_ModelDeleteCustomEntityRole_564719, schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltIntent_564735 = ref object of OpenApiRestCall_563566
proc url_ModelAddCustomPrebuiltIntent_564737(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltintents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddCustomPrebuiltIntent_564736(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a customizable prebuilt intent model to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564738 = path.getOrDefault("appId")
  valid_564738 = validateParameter(valid_564738, JString, required = true,
                                 default = nil)
  if valid_564738 != nil:
    section.add "appId", valid_564738
  var valid_564739 = path.getOrDefault("versionId")
  valid_564739 = validateParameter(valid_564739, JString, required = true,
                                 default = nil)
  if valid_564739 != nil:
    section.add "versionId", valid_564739
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the customizable prebuilt intent and the name of the domain to which this model belongs.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564741: Call_ModelAddCustomPrebuiltIntent_564735; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a customizable prebuilt intent model to a version of the application.
  ## 
  let valid = call_564741.validator(path, query, header, formData, body)
  let scheme = call_564741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564741.url(scheme.get, call_564741.host, call_564741.base,
                         call_564741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564741, url, valid)

proc call*(call_564742: Call_ModelAddCustomPrebuiltIntent_564735;
          prebuiltDomainModelCreateObject: JsonNode; appId: string;
          versionId: string): Recallable =
  ## modelAddCustomPrebuiltIntent
  ## Adds a customizable prebuilt intent model to a version of the application.
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the customizable prebuilt intent and the name of the domain to which this model belongs.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564743 = newJObject()
  var body_564744 = newJObject()
  if prebuiltDomainModelCreateObject != nil:
    body_564744 = prebuiltDomainModelCreateObject
  add(path_564743, "appId", newJString(appId))
  add(path_564743, "versionId", newJString(versionId))
  result = call_564742.call(path_564743, nil, nil, nil, body_564744)

var modelAddCustomPrebuiltIntent* = Call_ModelAddCustomPrebuiltIntent_564735(
    name: "modelAddCustomPrebuiltIntent", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltintents",
    validator: validate_ModelAddCustomPrebuiltIntent_564736, base: "",
    url: url_ModelAddCustomPrebuiltIntent_564737, schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltIntents_564727 = ref object of OpenApiRestCall_563566
proc url_ModelListCustomPrebuiltIntents_564729(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltintents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListCustomPrebuiltIntents_564728(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about customizable prebuilt intents added to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564730 = path.getOrDefault("appId")
  valid_564730 = validateParameter(valid_564730, JString, required = true,
                                 default = nil)
  if valid_564730 != nil:
    section.add "appId", valid_564730
  var valid_564731 = path.getOrDefault("versionId")
  valid_564731 = validateParameter(valid_564731, JString, required = true,
                                 default = nil)
  if valid_564731 != nil:
    section.add "versionId", valid_564731
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564732: Call_ModelListCustomPrebuiltIntents_564727; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about customizable prebuilt intents added to a version of the application.
  ## 
  let valid = call_564732.validator(path, query, header, formData, body)
  let scheme = call_564732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564732.url(scheme.get, call_564732.host, call_564732.base,
                         call_564732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564732, url, valid)

proc call*(call_564733: Call_ModelListCustomPrebuiltIntents_564727; appId: string;
          versionId: string): Recallable =
  ## modelListCustomPrebuiltIntents
  ## Gets information about customizable prebuilt intents added to a version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564734 = newJObject()
  add(path_564734, "appId", newJString(appId))
  add(path_564734, "versionId", newJString(versionId))
  result = call_564733.call(path_564734, nil, nil, nil, nil)

var modelListCustomPrebuiltIntents* = Call_ModelListCustomPrebuiltIntents_564727(
    name: "modelListCustomPrebuiltIntents", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltintents",
    validator: validate_ModelListCustomPrebuiltIntents_564728, base: "",
    url: url_ModelListCustomPrebuiltIntents_564729, schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltModels_564745 = ref object of OpenApiRestCall_563566
proc url_ModelListCustomPrebuiltModels_564747(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltmodels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListCustomPrebuiltModels_564746(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all prebuilt intent and entity model information used in a version of this application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564748 = path.getOrDefault("appId")
  valid_564748 = validateParameter(valid_564748, JString, required = true,
                                 default = nil)
  if valid_564748 != nil:
    section.add "appId", valid_564748
  var valid_564749 = path.getOrDefault("versionId")
  valid_564749 = validateParameter(valid_564749, JString, required = true,
                                 default = nil)
  if valid_564749 != nil:
    section.add "versionId", valid_564749
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564750: Call_ModelListCustomPrebuiltModels_564745; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all prebuilt intent and entity model information used in a version of this application.
  ## 
  let valid = call_564750.validator(path, query, header, formData, body)
  let scheme = call_564750.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564750.url(scheme.get, call_564750.host, call_564750.base,
                         call_564750.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564750, url, valid)

proc call*(call_564751: Call_ModelListCustomPrebuiltModels_564745; appId: string;
          versionId: string): Recallable =
  ## modelListCustomPrebuiltModels
  ## Gets all prebuilt intent and entity model information used in a version of this application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564752 = newJObject()
  add(path_564752, "appId", newJString(appId))
  add(path_564752, "versionId", newJString(versionId))
  result = call_564751.call(path_564752, nil, nil, nil, nil)

var modelListCustomPrebuiltModels* = Call_ModelListCustomPrebuiltModels_564745(
    name: "modelListCustomPrebuiltModels", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltmodels",
    validator: validate_ModelListCustomPrebuiltModels_564746, base: "",
    url: url_ModelListCustomPrebuiltModels_564747, schemes: {Scheme.Https})
type
  Call_ModelAddEntity_564764 = ref object of OpenApiRestCall_563566
proc url_ModelAddEntity_564766(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddEntity_564765(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Adds a simple entity extractor to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564767 = path.getOrDefault("appId")
  valid_564767 = validateParameter(valid_564767, JString, required = true,
                                 default = nil)
  if valid_564767 != nil:
    section.add "appId", valid_564767
  var valid_564768 = path.getOrDefault("versionId")
  valid_564768 = validateParameter(valid_564768, JString, required = true,
                                 default = nil)
  if valid_564768 != nil:
    section.add "versionId", valid_564768
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   modelCreateObject: JObject (required)
  ##                    : A model object containing the name for the new simple entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564770: Call_ModelAddEntity_564764; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a simple entity extractor to a version of the application.
  ## 
  let valid = call_564770.validator(path, query, header, formData, body)
  let scheme = call_564770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564770.url(scheme.get, call_564770.host, call_564770.base,
                         call_564770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564770, url, valid)

proc call*(call_564771: Call_ModelAddEntity_564764; modelCreateObject: JsonNode;
          appId: string; versionId: string): Recallable =
  ## modelAddEntity
  ## Adds a simple entity extractor to a version of the application.
  ##   modelCreateObject: JObject (required)
  ##                    : A model object containing the name for the new simple entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564772 = newJObject()
  var body_564773 = newJObject()
  if modelCreateObject != nil:
    body_564773 = modelCreateObject
  add(path_564772, "appId", newJString(appId))
  add(path_564772, "versionId", newJString(versionId))
  result = call_564771.call(path_564772, nil, nil, nil, body_564773)

var modelAddEntity* = Call_ModelAddEntity_564764(name: "modelAddEntity",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities",
    validator: validate_ModelAddEntity_564765, base: "", url: url_ModelAddEntity_564766,
    schemes: {Scheme.Https})
type
  Call_ModelListEntities_564753 = ref object of OpenApiRestCall_563566
proc url_ModelListEntities_564755(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListEntities_564754(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets information about all the simple entity models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564756 = path.getOrDefault("appId")
  valid_564756 = validateParameter(valid_564756, JString, required = true,
                                 default = nil)
  if valid_564756 != nil:
    section.add "appId", valid_564756
  var valid_564757 = path.getOrDefault("versionId")
  valid_564757 = validateParameter(valid_564757, JString, required = true,
                                 default = nil)
  if valid_564757 != nil:
    section.add "versionId", valid_564757
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564758 = query.getOrDefault("take")
  valid_564758 = validateParameter(valid_564758, JInt, required = false,
                                 default = newJInt(100))
  if valid_564758 != nil:
    section.add "take", valid_564758
  var valid_564759 = query.getOrDefault("skip")
  valid_564759 = validateParameter(valid_564759, JInt, required = false,
                                 default = newJInt(0))
  if valid_564759 != nil:
    section.add "skip", valid_564759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564760: Call_ModelListEntities_564753; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the simple entity models in a version of the application.
  ## 
  let valid = call_564760.validator(path, query, header, formData, body)
  let scheme = call_564760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564760.url(scheme.get, call_564760.host, call_564760.base,
                         call_564760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564760, url, valid)

proc call*(call_564761: Call_ModelListEntities_564753; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListEntities
  ## Gets information about all the simple entity models in a version of the application.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564762 = newJObject()
  var query_564763 = newJObject()
  add(query_564763, "take", newJInt(take))
  add(query_564763, "skip", newJInt(skip))
  add(path_564762, "appId", newJString(appId))
  add(path_564762, "versionId", newJString(versionId))
  result = call_564761.call(path_564762, query_564763, nil, nil, nil)

var modelListEntities* = Call_ModelListEntities_564753(name: "modelListEntities",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities",
    validator: validate_ModelListEntities_564754, base: "",
    url: url_ModelListEntities_564755, schemes: {Scheme.Https})
type
  Call_ModelUpdateEntity_564783 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateEntity_564785(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateEntity_564784(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the name of an entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564786 = path.getOrDefault("entityId")
  valid_564786 = validateParameter(valid_564786, JString, required = true,
                                 default = nil)
  if valid_564786 != nil:
    section.add "entityId", valid_564786
  var valid_564787 = path.getOrDefault("appId")
  valid_564787 = validateParameter(valid_564787, JString, required = true,
                                 default = nil)
  if valid_564787 != nil:
    section.add "appId", valid_564787
  var valid_564788 = path.getOrDefault("versionId")
  valid_564788 = validateParameter(valid_564788, JString, required = true,
                                 default = nil)
  if valid_564788 != nil:
    section.add "versionId", valid_564788
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new entity extractor name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564790: Call_ModelUpdateEntity_564783; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name of an entity in a version of the application.
  ## 
  let valid = call_564790.validator(path, query, header, formData, body)
  let scheme = call_564790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564790.url(scheme.get, call_564790.host, call_564790.base,
                         call_564790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564790, url, valid)

proc call*(call_564791: Call_ModelUpdateEntity_564783; entityId: string;
          appId: string; modelUpdateObject: JsonNode; versionId: string): Recallable =
  ## modelUpdateEntity
  ## Updates the name of an entity in a version of the application.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new entity extractor name.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564792 = newJObject()
  var body_564793 = newJObject()
  add(path_564792, "entityId", newJString(entityId))
  add(path_564792, "appId", newJString(appId))
  if modelUpdateObject != nil:
    body_564793 = modelUpdateObject
  add(path_564792, "versionId", newJString(versionId))
  result = call_564791.call(path_564792, nil, nil, nil, body_564793)

var modelUpdateEntity* = Call_ModelUpdateEntity_564783(name: "modelUpdateEntity",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelUpdateEntity_564784, base: "",
    url: url_ModelUpdateEntity_564785, schemes: {Scheme.Https})
type
  Call_ModelGetEntity_564774 = ref object of OpenApiRestCall_563566
proc url_ModelGetEntity_564776(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetEntity_564775(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about an entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564777 = path.getOrDefault("entityId")
  valid_564777 = validateParameter(valid_564777, JString, required = true,
                                 default = nil)
  if valid_564777 != nil:
    section.add "entityId", valid_564777
  var valid_564778 = path.getOrDefault("appId")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "appId", valid_564778
  var valid_564779 = path.getOrDefault("versionId")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "versionId", valid_564779
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564780: Call_ModelGetEntity_564774; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an entity model in a version of the application.
  ## 
  let valid = call_564780.validator(path, query, header, formData, body)
  let scheme = call_564780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564780.url(scheme.get, call_564780.host, call_564780.base,
                         call_564780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564780, url, valid)

proc call*(call_564781: Call_ModelGetEntity_564774; entityId: string; appId: string;
          versionId: string): Recallable =
  ## modelGetEntity
  ## Gets information about an entity model in a version of the application.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564782 = newJObject()
  add(path_564782, "entityId", newJString(entityId))
  add(path_564782, "appId", newJString(appId))
  add(path_564782, "versionId", newJString(versionId))
  result = call_564781.call(path_564782, nil, nil, nil, nil)

var modelGetEntity* = Call_ModelGetEntity_564774(name: "modelGetEntity",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelGetEntity_564775, base: "", url: url_ModelGetEntity_564776,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteEntity_564794 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteEntity_564796(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteEntity_564795(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an entity from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564797 = path.getOrDefault("entityId")
  valid_564797 = validateParameter(valid_564797, JString, required = true,
                                 default = nil)
  if valid_564797 != nil:
    section.add "entityId", valid_564797
  var valid_564798 = path.getOrDefault("appId")
  valid_564798 = validateParameter(valid_564798, JString, required = true,
                                 default = nil)
  if valid_564798 != nil:
    section.add "appId", valid_564798
  var valid_564799 = path.getOrDefault("versionId")
  valid_564799 = validateParameter(valid_564799, JString, required = true,
                                 default = nil)
  if valid_564799 != nil:
    section.add "versionId", valid_564799
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564800: Call_ModelDeleteEntity_564794; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an entity from a version of the application.
  ## 
  let valid = call_564800.validator(path, query, header, formData, body)
  let scheme = call_564800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564800.url(scheme.get, call_564800.host, call_564800.base,
                         call_564800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564800, url, valid)

proc call*(call_564801: Call_ModelDeleteEntity_564794; entityId: string;
          appId: string; versionId: string): Recallable =
  ## modelDeleteEntity
  ## Deletes an entity from a version of the application.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564802 = newJObject()
  add(path_564802, "entityId", newJString(entityId))
  add(path_564802, "appId", newJString(appId))
  add(path_564802, "versionId", newJString(versionId))
  result = call_564801.call(path_564802, nil, nil, nil, nil)

var modelDeleteEntity* = Call_ModelDeleteEntity_564794(name: "modelDeleteEntity",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelDeleteEntity_564795, base: "",
    url: url_ModelDeleteEntity_564796, schemes: {Scheme.Https})
type
  Call_ModelCreateEntityRole_564812 = ref object of OpenApiRestCall_563566
proc url_ModelCreateEntityRole_564814(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateEntityRole_564813(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564815 = path.getOrDefault("entityId")
  valid_564815 = validateParameter(valid_564815, JString, required = true,
                                 default = nil)
  if valid_564815 != nil:
    section.add "entityId", valid_564815
  var valid_564816 = path.getOrDefault("appId")
  valid_564816 = validateParameter(valid_564816, JString, required = true,
                                 default = nil)
  if valid_564816 != nil:
    section.add "appId", valid_564816
  var valid_564817 = path.getOrDefault("versionId")
  valid_564817 = validateParameter(valid_564817, JString, required = true,
                                 default = nil)
  if valid_564817 != nil:
    section.add "versionId", valid_564817
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564819: Call_ModelCreateEntityRole_564812; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564819.validator(path, query, header, formData, body)
  let scheme = call_564819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564819.url(scheme.get, call_564819.host, call_564819.base,
                         call_564819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564819, url, valid)

proc call*(call_564820: Call_ModelCreateEntityRole_564812; entityId: string;
          entityRoleCreateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelCreateEntityRole
  ##   entityId: string (required)
  ##           : The entity model ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564821 = newJObject()
  var body_564822 = newJObject()
  add(path_564821, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_564822 = entityRoleCreateObject
  add(path_564821, "appId", newJString(appId))
  add(path_564821, "versionId", newJString(versionId))
  result = call_564820.call(path_564821, nil, nil, nil, body_564822)

var modelCreateEntityRole* = Call_ModelCreateEntityRole_564812(
    name: "modelCreateEntityRole", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles",
    validator: validate_ModelCreateEntityRole_564813, base: "",
    url: url_ModelCreateEntityRole_564814, schemes: {Scheme.Https})
type
  Call_ModelListEntityRoles_564803 = ref object of OpenApiRestCall_563566
proc url_ModelListEntityRoles_564805(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListEntityRoles_564804(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity Id
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564806 = path.getOrDefault("entityId")
  valid_564806 = validateParameter(valid_564806, JString, required = true,
                                 default = nil)
  if valid_564806 != nil:
    section.add "entityId", valid_564806
  var valid_564807 = path.getOrDefault("appId")
  valid_564807 = validateParameter(valid_564807, JString, required = true,
                                 default = nil)
  if valid_564807 != nil:
    section.add "appId", valid_564807
  var valid_564808 = path.getOrDefault("versionId")
  valid_564808 = validateParameter(valid_564808, JString, required = true,
                                 default = nil)
  if valid_564808 != nil:
    section.add "versionId", valid_564808
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564809: Call_ModelListEntityRoles_564803; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564809.validator(path, query, header, formData, body)
  let scheme = call_564809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564809.url(scheme.get, call_564809.host, call_564809.base,
                         call_564809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564809, url, valid)

proc call*(call_564810: Call_ModelListEntityRoles_564803; entityId: string;
          appId: string; versionId: string): Recallable =
  ## modelListEntityRoles
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564811 = newJObject()
  add(path_564811, "entityId", newJString(entityId))
  add(path_564811, "appId", newJString(appId))
  add(path_564811, "versionId", newJString(versionId))
  result = call_564810.call(path_564811, nil, nil, nil, nil)

var modelListEntityRoles* = Call_ModelListEntityRoles_564803(
    name: "modelListEntityRoles", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles",
    validator: validate_ModelListEntityRoles_564804, base: "",
    url: url_ModelListEntityRoles_564805, schemes: {Scheme.Https})
type
  Call_ModelUpdateEntityRole_564833 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateEntityRole_564835(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateEntityRole_564834(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564836 = path.getOrDefault("entityId")
  valid_564836 = validateParameter(valid_564836, JString, required = true,
                                 default = nil)
  if valid_564836 != nil:
    section.add "entityId", valid_564836
  var valid_564837 = path.getOrDefault("appId")
  valid_564837 = validateParameter(valid_564837, JString, required = true,
                                 default = nil)
  if valid_564837 != nil:
    section.add "appId", valid_564837
  var valid_564838 = path.getOrDefault("versionId")
  valid_564838 = validateParameter(valid_564838, JString, required = true,
                                 default = nil)
  if valid_564838 != nil:
    section.add "versionId", valid_564838
  var valid_564839 = path.getOrDefault("roleId")
  valid_564839 = validateParameter(valid_564839, JString, required = true,
                                 default = nil)
  if valid_564839 != nil:
    section.add "roleId", valid_564839
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564841: Call_ModelUpdateEntityRole_564833; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564841.validator(path, query, header, formData, body)
  let scheme = call_564841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564841.url(scheme.get, call_564841.host, call_564841.base,
                         call_564841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564841, url, valid)

proc call*(call_564842: Call_ModelUpdateEntityRole_564833; entityId: string;
          entityRoleUpdateObject: JsonNode; appId: string; versionId: string;
          roleId: string): Recallable =
  ## modelUpdateEntityRole
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_564843 = newJObject()
  var body_564844 = newJObject()
  add(path_564843, "entityId", newJString(entityId))
  if entityRoleUpdateObject != nil:
    body_564844 = entityRoleUpdateObject
  add(path_564843, "appId", newJString(appId))
  add(path_564843, "versionId", newJString(versionId))
  add(path_564843, "roleId", newJString(roleId))
  result = call_564842.call(path_564843, nil, nil, nil, body_564844)

var modelUpdateEntityRole* = Call_ModelUpdateEntityRole_564833(
    name: "modelUpdateEntityRole", meth: HttpMethod.HttpPut, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdateEntityRole_564834, base: "",
    url: url_ModelUpdateEntityRole_564835, schemes: {Scheme.Https})
type
  Call_ModelGetEntityRole_564823 = ref object of OpenApiRestCall_563566
proc url_ModelGetEntityRole_564825(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetEntityRole_564824(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564826 = path.getOrDefault("entityId")
  valid_564826 = validateParameter(valid_564826, JString, required = true,
                                 default = nil)
  if valid_564826 != nil:
    section.add "entityId", valid_564826
  var valid_564827 = path.getOrDefault("appId")
  valid_564827 = validateParameter(valid_564827, JString, required = true,
                                 default = nil)
  if valid_564827 != nil:
    section.add "appId", valid_564827
  var valid_564828 = path.getOrDefault("versionId")
  valid_564828 = validateParameter(valid_564828, JString, required = true,
                                 default = nil)
  if valid_564828 != nil:
    section.add "versionId", valid_564828
  var valid_564829 = path.getOrDefault("roleId")
  valid_564829 = validateParameter(valid_564829, JString, required = true,
                                 default = nil)
  if valid_564829 != nil:
    section.add "roleId", valid_564829
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564830: Call_ModelGetEntityRole_564823; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564830.validator(path, query, header, formData, body)
  let scheme = call_564830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564830.url(scheme.get, call_564830.host, call_564830.base,
                         call_564830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564830, url, valid)

proc call*(call_564831: Call_ModelGetEntityRole_564823; entityId: string;
          appId: string; versionId: string; roleId: string): Recallable =
  ## modelGetEntityRole
  ##   entityId: string (required)
  ##           : entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_564832 = newJObject()
  add(path_564832, "entityId", newJString(entityId))
  add(path_564832, "appId", newJString(appId))
  add(path_564832, "versionId", newJString(versionId))
  add(path_564832, "roleId", newJString(roleId))
  result = call_564831.call(path_564832, nil, nil, nil, nil)

var modelGetEntityRole* = Call_ModelGetEntityRole_564823(
    name: "modelGetEntityRole", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles/{roleId}",
    validator: validate_ModelGetEntityRole_564824, base: "",
    url: url_ModelGetEntityRole_564825, schemes: {Scheme.Https})
type
  Call_ModelDeleteEntityRole_564845 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteEntityRole_564847(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteEntityRole_564846(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564848 = path.getOrDefault("entityId")
  valid_564848 = validateParameter(valid_564848, JString, required = true,
                                 default = nil)
  if valid_564848 != nil:
    section.add "entityId", valid_564848
  var valid_564849 = path.getOrDefault("appId")
  valid_564849 = validateParameter(valid_564849, JString, required = true,
                                 default = nil)
  if valid_564849 != nil:
    section.add "appId", valid_564849
  var valid_564850 = path.getOrDefault("versionId")
  valid_564850 = validateParameter(valid_564850, JString, required = true,
                                 default = nil)
  if valid_564850 != nil:
    section.add "versionId", valid_564850
  var valid_564851 = path.getOrDefault("roleId")
  valid_564851 = validateParameter(valid_564851, JString, required = true,
                                 default = nil)
  if valid_564851 != nil:
    section.add "roleId", valid_564851
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564852: Call_ModelDeleteEntityRole_564845; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564852.validator(path, query, header, formData, body)
  let scheme = call_564852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564852.url(scheme.get, call_564852.host, call_564852.base,
                         call_564852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564852, url, valid)

proc call*(call_564853: Call_ModelDeleteEntityRole_564845; entityId: string;
          appId: string; versionId: string; roleId: string): Recallable =
  ## modelDeleteEntityRole
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_564854 = newJObject()
  add(path_564854, "entityId", newJString(entityId))
  add(path_564854, "appId", newJString(appId))
  add(path_564854, "versionId", newJString(versionId))
  add(path_564854, "roleId", newJString(roleId))
  result = call_564853.call(path_564854, nil, nil, nil, nil)

var modelDeleteEntityRole* = Call_ModelDeleteEntityRole_564845(
    name: "modelDeleteEntityRole", meth: HttpMethod.HttpDelete, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles/{roleId}",
    validator: validate_ModelDeleteEntityRole_564846, base: "",
    url: url_ModelDeleteEntityRole_564847, schemes: {Scheme.Https})
type
  Call_ModelListEntitySuggestions_564855 = ref object of OpenApiRestCall_563566
proc url_ModelListEntitySuggestions_564857(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/suggest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListEntitySuggestions_564856(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get suggested example utterances that would improve the accuracy of the entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The target entity extractor model to enhance.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564858 = path.getOrDefault("entityId")
  valid_564858 = validateParameter(valid_564858, JString, required = true,
                                 default = nil)
  if valid_564858 != nil:
    section.add "entityId", valid_564858
  var valid_564859 = path.getOrDefault("appId")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = nil)
  if valid_564859 != nil:
    section.add "appId", valid_564859
  var valid_564860 = path.getOrDefault("versionId")
  valid_564860 = validateParameter(valid_564860, JString, required = true,
                                 default = nil)
  if valid_564860 != nil:
    section.add "versionId", valid_564860
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_564861 = query.getOrDefault("take")
  valid_564861 = validateParameter(valid_564861, JInt, required = false,
                                 default = newJInt(100))
  if valid_564861 != nil:
    section.add "take", valid_564861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564862: Call_ModelListEntitySuggestions_564855; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get suggested example utterances that would improve the accuracy of the entity model in a version of the application.
  ## 
  let valid = call_564862.validator(path, query, header, formData, body)
  let scheme = call_564862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564862.url(scheme.get, call_564862.host, call_564862.base,
                         call_564862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564862, url, valid)

proc call*(call_564863: Call_ModelListEntitySuggestions_564855; entityId: string;
          appId: string; versionId: string; take: int = 100): Recallable =
  ## modelListEntitySuggestions
  ## Get suggested example utterances that would improve the accuracy of the entity model in a version of the application.
  ##   entityId: string (required)
  ##           : The target entity extractor model to enhance.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564864 = newJObject()
  var query_564865 = newJObject()
  add(path_564864, "entityId", newJString(entityId))
  add(query_564865, "take", newJInt(take))
  add(path_564864, "appId", newJString(appId))
  add(path_564864, "versionId", newJString(versionId))
  result = call_564863.call(path_564864, query_564865, nil, nil, nil)

var modelListEntitySuggestions* = Call_ModelListEntitySuggestions_564855(
    name: "modelListEntitySuggestions", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/suggest",
    validator: validate_ModelListEntitySuggestions_564856, base: "",
    url: url_ModelListEntitySuggestions_564857, schemes: {Scheme.Https})
type
  Call_ExamplesAdd_564866 = ref object of OpenApiRestCall_563566
proc url_ExamplesAdd_564868(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/example")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExamplesAdd_564867(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a labeled example utterance in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564869 = path.getOrDefault("appId")
  valid_564869 = validateParameter(valid_564869, JString, required = true,
                                 default = nil)
  if valid_564869 != nil:
    section.add "appId", valid_564869
  var valid_564870 = path.getOrDefault("versionId")
  valid_564870 = validateParameter(valid_564870, JString, required = true,
                                 default = nil)
  if valid_564870 != nil:
    section.add "versionId", valid_564870
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   exampleLabelObject: JObject (required)
  ##                     : A labeled example utterance with the expected intent and entities.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564872: Call_ExamplesAdd_564866; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a labeled example utterance in a version of the application.
  ## 
  let valid = call_564872.validator(path, query, header, formData, body)
  let scheme = call_564872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564872.url(scheme.get, call_564872.host, call_564872.base,
                         call_564872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564872, url, valid)

proc call*(call_564873: Call_ExamplesAdd_564866; appId: string; versionId: string;
          exampleLabelObject: JsonNode): Recallable =
  ## examplesAdd
  ## Adds a labeled example utterance in a version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   exampleLabelObject: JObject (required)
  ##                     : A labeled example utterance with the expected intent and entities.
  var path_564874 = newJObject()
  var body_564875 = newJObject()
  add(path_564874, "appId", newJString(appId))
  add(path_564874, "versionId", newJString(versionId))
  if exampleLabelObject != nil:
    body_564875 = exampleLabelObject
  result = call_564873.call(path_564874, nil, nil, nil, body_564875)

var examplesAdd* = Call_ExamplesAdd_564866(name: "examplesAdd",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/apps/{appId}/versions/{versionId}/example",
                                        validator: validate_ExamplesAdd_564867,
                                        base: "", url: url_ExamplesAdd_564868,
                                        schemes: {Scheme.Https})
type
  Call_ExamplesBatch_564887 = ref object of OpenApiRestCall_563566
proc url_ExamplesBatch_564889(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/examples")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExamplesBatch_564888(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a batch of labeled example utterances to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564890 = path.getOrDefault("appId")
  valid_564890 = validateParameter(valid_564890, JString, required = true,
                                 default = nil)
  if valid_564890 != nil:
    section.add "appId", valid_564890
  var valid_564891 = path.getOrDefault("versionId")
  valid_564891 = validateParameter(valid_564891, JString, required = true,
                                 default = nil)
  if valid_564891 != nil:
    section.add "versionId", valid_564891
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   exampleLabelObjectArray: JArray (required)
  ##                          : Array of example utterances.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564893: Call_ExamplesBatch_564887; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a batch of labeled example utterances to a version of the application.
  ## 
  let valid = call_564893.validator(path, query, header, formData, body)
  let scheme = call_564893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564893.url(scheme.get, call_564893.host, call_564893.base,
                         call_564893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564893, url, valid)

proc call*(call_564894: Call_ExamplesBatch_564887; appId: string; versionId: string;
          exampleLabelObjectArray: JsonNode): Recallable =
  ## examplesBatch
  ## Adds a batch of labeled example utterances to a version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   exampleLabelObjectArray: JArray (required)
  ##                          : Array of example utterances.
  var path_564895 = newJObject()
  var body_564896 = newJObject()
  add(path_564895, "appId", newJString(appId))
  add(path_564895, "versionId", newJString(versionId))
  if exampleLabelObjectArray != nil:
    body_564896 = exampleLabelObjectArray
  result = call_564894.call(path_564895, nil, nil, nil, body_564896)

var examplesBatch* = Call_ExamplesBatch_564887(name: "examplesBatch",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples",
    validator: validate_ExamplesBatch_564888, base: "", url: url_ExamplesBatch_564889,
    schemes: {Scheme.Https})
type
  Call_ExamplesList_564876 = ref object of OpenApiRestCall_563566
proc url_ExamplesList_564878(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/examples")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExamplesList_564877(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns example utterances to be reviewed from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564879 = path.getOrDefault("appId")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "appId", valid_564879
  var valid_564880 = path.getOrDefault("versionId")
  valid_564880 = validateParameter(valid_564880, JString, required = true,
                                 default = nil)
  if valid_564880 != nil:
    section.add "versionId", valid_564880
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564881 = query.getOrDefault("take")
  valid_564881 = validateParameter(valid_564881, JInt, required = false,
                                 default = newJInt(100))
  if valid_564881 != nil:
    section.add "take", valid_564881
  var valid_564882 = query.getOrDefault("skip")
  valid_564882 = validateParameter(valid_564882, JInt, required = false,
                                 default = newJInt(0))
  if valid_564882 != nil:
    section.add "skip", valid_564882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564883: Call_ExamplesList_564876; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns example utterances to be reviewed from a version of the application.
  ## 
  let valid = call_564883.validator(path, query, header, formData, body)
  let scheme = call_564883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564883.url(scheme.get, call_564883.host, call_564883.base,
                         call_564883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564883, url, valid)

proc call*(call_564884: Call_ExamplesList_564876; appId: string; versionId: string;
          take: int = 100; skip: int = 0): Recallable =
  ## examplesList
  ## Returns example utterances to be reviewed from a version of the application.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564885 = newJObject()
  var query_564886 = newJObject()
  add(query_564886, "take", newJInt(take))
  add(query_564886, "skip", newJInt(skip))
  add(path_564885, "appId", newJString(appId))
  add(path_564885, "versionId", newJString(versionId))
  result = call_564884.call(path_564885, query_564886, nil, nil, nil)

var examplesList* = Call_ExamplesList_564876(name: "examplesList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples",
    validator: validate_ExamplesList_564877, base: "", url: url_ExamplesList_564878,
    schemes: {Scheme.Https})
type
  Call_ExamplesDelete_564897 = ref object of OpenApiRestCall_563566
proc url_ExamplesDelete_564899(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "exampleId" in path, "`exampleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/examples/"),
               (kind: VariableSegment, value: "exampleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExamplesDelete_564898(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the labeled example utterances with the specified ID from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   exampleId: JInt (required)
  ##            : The example ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `exampleId` field"
  var valid_564900 = path.getOrDefault("exampleId")
  valid_564900 = validateParameter(valid_564900, JInt, required = true, default = nil)
  if valid_564900 != nil:
    section.add "exampleId", valid_564900
  var valid_564901 = path.getOrDefault("appId")
  valid_564901 = validateParameter(valid_564901, JString, required = true,
                                 default = nil)
  if valid_564901 != nil:
    section.add "appId", valid_564901
  var valid_564902 = path.getOrDefault("versionId")
  valid_564902 = validateParameter(valid_564902, JString, required = true,
                                 default = nil)
  if valid_564902 != nil:
    section.add "versionId", valid_564902
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564903: Call_ExamplesDelete_564897; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the labeled example utterances with the specified ID from a version of the application.
  ## 
  let valid = call_564903.validator(path, query, header, formData, body)
  let scheme = call_564903.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564903.url(scheme.get, call_564903.host, call_564903.base,
                         call_564903.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564903, url, valid)

proc call*(call_564904: Call_ExamplesDelete_564897; exampleId: int; appId: string;
          versionId: string): Recallable =
  ## examplesDelete
  ## Deletes the labeled example utterances with the specified ID from a version of the application.
  ##   exampleId: int (required)
  ##            : The example ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564905 = newJObject()
  add(path_564905, "exampleId", newJInt(exampleId))
  add(path_564905, "appId", newJString(appId))
  add(path_564905, "versionId", newJString(versionId))
  result = call_564904.call(path_564905, nil, nil, nil, nil)

var examplesDelete* = Call_ExamplesDelete_564897(name: "examplesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples/{exampleId}",
    validator: validate_ExamplesDelete_564898, base: "", url: url_ExamplesDelete_564899,
    schemes: {Scheme.Https})
type
  Call_VersionsExport_564906 = ref object of OpenApiRestCall_563566
proc url_VersionsExport_564908(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsExport_564907(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Exports a LUIS application to JSON format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564909 = path.getOrDefault("appId")
  valid_564909 = validateParameter(valid_564909, JString, required = true,
                                 default = nil)
  if valid_564909 != nil:
    section.add "appId", valid_564909
  var valid_564910 = path.getOrDefault("versionId")
  valid_564910 = validateParameter(valid_564910, JString, required = true,
                                 default = nil)
  if valid_564910 != nil:
    section.add "versionId", valid_564910
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564911: Call_VersionsExport_564906; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a LUIS application to JSON format.
  ## 
  let valid = call_564911.validator(path, query, header, formData, body)
  let scheme = call_564911.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564911.url(scheme.get, call_564911.host, call_564911.base,
                         call_564911.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564911, url, valid)

proc call*(call_564912: Call_VersionsExport_564906; appId: string; versionId: string): Recallable =
  ## versionsExport
  ## Exports a LUIS application to JSON format.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564913 = newJObject()
  add(path_564913, "appId", newJString(appId))
  add(path_564913, "versionId", newJString(versionId))
  result = call_564912.call(path_564913, nil, nil, nil, nil)

var versionsExport* = Call_VersionsExport_564906(name: "versionsExport",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/export",
    validator: validate_VersionsExport_564907, base: "", url: url_VersionsExport_564908,
    schemes: {Scheme.Https})
type
  Call_FeaturesList_564914 = ref object of OpenApiRestCall_563566
proc url_FeaturesList_564916(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/features")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesList_564915(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the extraction phraselist and pattern features in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564917 = path.getOrDefault("appId")
  valid_564917 = validateParameter(valid_564917, JString, required = true,
                                 default = nil)
  if valid_564917 != nil:
    section.add "appId", valid_564917
  var valid_564918 = path.getOrDefault("versionId")
  valid_564918 = validateParameter(valid_564918, JString, required = true,
                                 default = nil)
  if valid_564918 != nil:
    section.add "versionId", valid_564918
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564919 = query.getOrDefault("take")
  valid_564919 = validateParameter(valid_564919, JInt, required = false,
                                 default = newJInt(100))
  if valid_564919 != nil:
    section.add "take", valid_564919
  var valid_564920 = query.getOrDefault("skip")
  valid_564920 = validateParameter(valid_564920, JInt, required = false,
                                 default = newJInt(0))
  if valid_564920 != nil:
    section.add "skip", valid_564920
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564921: Call_FeaturesList_564914; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the extraction phraselist and pattern features in a version of the application.
  ## 
  let valid = call_564921.validator(path, query, header, formData, body)
  let scheme = call_564921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564921.url(scheme.get, call_564921.host, call_564921.base,
                         call_564921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564921, url, valid)

proc call*(call_564922: Call_FeaturesList_564914; appId: string; versionId: string;
          take: int = 100; skip: int = 0): Recallable =
  ## featuresList
  ## Gets all the extraction phraselist and pattern features in a version of the application.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564923 = newJObject()
  var query_564924 = newJObject()
  add(query_564924, "take", newJInt(take))
  add(query_564924, "skip", newJInt(skip))
  add(path_564923, "appId", newJString(appId))
  add(path_564923, "versionId", newJString(versionId))
  result = call_564922.call(path_564923, query_564924, nil, nil, nil)

var featuresList* = Call_FeaturesList_564914(name: "featuresList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/features",
    validator: validate_FeaturesList_564915, base: "", url: url_FeaturesList_564916,
    schemes: {Scheme.Https})
type
  Call_ModelAddHierarchicalEntity_564936 = ref object of OpenApiRestCall_563566
proc url_ModelAddHierarchicalEntity_564938(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddHierarchicalEntity_564937(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a hierarchical entity extractor to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564939 = path.getOrDefault("appId")
  valid_564939 = validateParameter(valid_564939, JString, required = true,
                                 default = nil)
  if valid_564939 != nil:
    section.add "appId", valid_564939
  var valid_564940 = path.getOrDefault("versionId")
  valid_564940 = validateParameter(valid_564940, JString, required = true,
                                 default = nil)
  if valid_564940 != nil:
    section.add "versionId", valid_564940
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   hierarchicalModelCreateObject: JObject (required)
  ##                                : A model containing the name and children of the new entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564942: Call_ModelAddHierarchicalEntity_564936; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a hierarchical entity extractor to a version of the application.
  ## 
  let valid = call_564942.validator(path, query, header, formData, body)
  let scheme = call_564942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564942.url(scheme.get, call_564942.host, call_564942.base,
                         call_564942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564942, url, valid)

proc call*(call_564943: Call_ModelAddHierarchicalEntity_564936;
          hierarchicalModelCreateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelAddHierarchicalEntity
  ## Adds a hierarchical entity extractor to a version of the application.
  ##   hierarchicalModelCreateObject: JObject (required)
  ##                                : A model containing the name and children of the new entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564944 = newJObject()
  var body_564945 = newJObject()
  if hierarchicalModelCreateObject != nil:
    body_564945 = hierarchicalModelCreateObject
  add(path_564944, "appId", newJString(appId))
  add(path_564944, "versionId", newJString(versionId))
  result = call_564943.call(path_564944, nil, nil, nil, body_564945)

var modelAddHierarchicalEntity* = Call_ModelAddHierarchicalEntity_564936(
    name: "modelAddHierarchicalEntity", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/hierarchicalentities",
    validator: validate_ModelAddHierarchicalEntity_564937, base: "",
    url: url_ModelAddHierarchicalEntity_564938, schemes: {Scheme.Https})
type
  Call_ModelListHierarchicalEntities_564925 = ref object of OpenApiRestCall_563566
proc url_ModelListHierarchicalEntities_564927(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListHierarchicalEntities_564926(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about all the hierarchical entity models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564928 = path.getOrDefault("appId")
  valid_564928 = validateParameter(valid_564928, JString, required = true,
                                 default = nil)
  if valid_564928 != nil:
    section.add "appId", valid_564928
  var valid_564929 = path.getOrDefault("versionId")
  valid_564929 = validateParameter(valid_564929, JString, required = true,
                                 default = nil)
  if valid_564929 != nil:
    section.add "versionId", valid_564929
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564930 = query.getOrDefault("take")
  valid_564930 = validateParameter(valid_564930, JInt, required = false,
                                 default = newJInt(100))
  if valid_564930 != nil:
    section.add "take", valid_564930
  var valid_564931 = query.getOrDefault("skip")
  valid_564931 = validateParameter(valid_564931, JInt, required = false,
                                 default = newJInt(0))
  if valid_564931 != nil:
    section.add "skip", valid_564931
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564932: Call_ModelListHierarchicalEntities_564925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the hierarchical entity models in a version of the application.
  ## 
  let valid = call_564932.validator(path, query, header, formData, body)
  let scheme = call_564932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564932.url(scheme.get, call_564932.host, call_564932.base,
                         call_564932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564932, url, valid)

proc call*(call_564933: Call_ModelListHierarchicalEntities_564925; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListHierarchicalEntities
  ## Gets information about all the hierarchical entity models in a version of the application.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564934 = newJObject()
  var query_564935 = newJObject()
  add(query_564935, "take", newJInt(take))
  add(query_564935, "skip", newJInt(skip))
  add(path_564934, "appId", newJString(appId))
  add(path_564934, "versionId", newJString(versionId))
  result = call_564933.call(path_564934, query_564935, nil, nil, nil)

var modelListHierarchicalEntities* = Call_ModelListHierarchicalEntities_564925(
    name: "modelListHierarchicalEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/hierarchicalentities",
    validator: validate_ModelListHierarchicalEntities_564926, base: "",
    url: url_ModelListHierarchicalEntities_564927, schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntity_564955 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateHierarchicalEntity_564957(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateHierarchicalEntity_564956(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the name and children of a hierarchical entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hEntityId` field"
  var valid_564958 = path.getOrDefault("hEntityId")
  valid_564958 = validateParameter(valid_564958, JString, required = true,
                                 default = nil)
  if valid_564958 != nil:
    section.add "hEntityId", valid_564958
  var valid_564959 = path.getOrDefault("appId")
  valid_564959 = validateParameter(valid_564959, JString, required = true,
                                 default = nil)
  if valid_564959 != nil:
    section.add "appId", valid_564959
  var valid_564960 = path.getOrDefault("versionId")
  valid_564960 = validateParameter(valid_564960, JString, required = true,
                                 default = nil)
  if valid_564960 != nil:
    section.add "versionId", valid_564960
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   hierarchicalModelUpdateObject: JObject (required)
  ##                                : Model containing names of the children of the hierarchical entity.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564962: Call_ModelUpdateHierarchicalEntity_564955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name and children of a hierarchical entity model in a version of the application.
  ## 
  let valid = call_564962.validator(path, query, header, formData, body)
  let scheme = call_564962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564962.url(scheme.get, call_564962.host, call_564962.base,
                         call_564962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564962, url, valid)

proc call*(call_564963: Call_ModelUpdateHierarchicalEntity_564955;
          hierarchicalModelUpdateObject: JsonNode; hEntityId: string; appId: string;
          versionId: string): Recallable =
  ## modelUpdateHierarchicalEntity
  ## Updates the name and children of a hierarchical entity model in a version of the application.
  ##   hierarchicalModelUpdateObject: JObject (required)
  ##                                : Model containing names of the children of the hierarchical entity.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564964 = newJObject()
  var body_564965 = newJObject()
  if hierarchicalModelUpdateObject != nil:
    body_564965 = hierarchicalModelUpdateObject
  add(path_564964, "hEntityId", newJString(hEntityId))
  add(path_564964, "appId", newJString(appId))
  add(path_564964, "versionId", newJString(versionId))
  result = call_564963.call(path_564964, nil, nil, nil, body_564965)

var modelUpdateHierarchicalEntity* = Call_ModelUpdateHierarchicalEntity_564955(
    name: "modelUpdateHierarchicalEntity", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelUpdateHierarchicalEntity_564956, base: "",
    url: url_ModelUpdateHierarchicalEntity_564957, schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntity_564946 = ref object of OpenApiRestCall_563566
proc url_ModelGetHierarchicalEntity_564948(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetHierarchicalEntity_564947(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a hierarchical entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hEntityId` field"
  var valid_564949 = path.getOrDefault("hEntityId")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "hEntityId", valid_564949
  var valid_564950 = path.getOrDefault("appId")
  valid_564950 = validateParameter(valid_564950, JString, required = true,
                                 default = nil)
  if valid_564950 != nil:
    section.add "appId", valid_564950
  var valid_564951 = path.getOrDefault("versionId")
  valid_564951 = validateParameter(valid_564951, JString, required = true,
                                 default = nil)
  if valid_564951 != nil:
    section.add "versionId", valid_564951
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564952: Call_ModelGetHierarchicalEntity_564946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a hierarchical entity in a version of the application.
  ## 
  let valid = call_564952.validator(path, query, header, formData, body)
  let scheme = call_564952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564952.url(scheme.get, call_564952.host, call_564952.base,
                         call_564952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564952, url, valid)

proc call*(call_564953: Call_ModelGetHierarchicalEntity_564946; hEntityId: string;
          appId: string; versionId: string): Recallable =
  ## modelGetHierarchicalEntity
  ## Gets information about a hierarchical entity in a version of the application.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564954 = newJObject()
  add(path_564954, "hEntityId", newJString(hEntityId))
  add(path_564954, "appId", newJString(appId))
  add(path_564954, "versionId", newJString(versionId))
  result = call_564953.call(path_564954, nil, nil, nil, nil)

var modelGetHierarchicalEntity* = Call_ModelGetHierarchicalEntity_564946(
    name: "modelGetHierarchicalEntity", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelGetHierarchicalEntity_564947, base: "",
    url: url_ModelGetHierarchicalEntity_564948, schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntity_564966 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteHierarchicalEntity_564968(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteHierarchicalEntity_564967(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a hierarchical entity from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hEntityId` field"
  var valid_564969 = path.getOrDefault("hEntityId")
  valid_564969 = validateParameter(valid_564969, JString, required = true,
                                 default = nil)
  if valid_564969 != nil:
    section.add "hEntityId", valid_564969
  var valid_564970 = path.getOrDefault("appId")
  valid_564970 = validateParameter(valid_564970, JString, required = true,
                                 default = nil)
  if valid_564970 != nil:
    section.add "appId", valid_564970
  var valid_564971 = path.getOrDefault("versionId")
  valid_564971 = validateParameter(valid_564971, JString, required = true,
                                 default = nil)
  if valid_564971 != nil:
    section.add "versionId", valid_564971
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564972: Call_ModelDeleteHierarchicalEntity_564966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a hierarchical entity from a version of the application.
  ## 
  let valid = call_564972.validator(path, query, header, formData, body)
  let scheme = call_564972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564972.url(scheme.get, call_564972.host, call_564972.base,
                         call_564972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564972, url, valid)

proc call*(call_564973: Call_ModelDeleteHierarchicalEntity_564966;
          hEntityId: string; appId: string; versionId: string): Recallable =
  ## modelDeleteHierarchicalEntity
  ## Deletes a hierarchical entity from a version of the application.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564974 = newJObject()
  add(path_564974, "hEntityId", newJString(hEntityId))
  add(path_564974, "appId", newJString(appId))
  add(path_564974, "versionId", newJString(versionId))
  result = call_564973.call(path_564974, nil, nil, nil, nil)

var modelDeleteHierarchicalEntity* = Call_ModelDeleteHierarchicalEntity_564966(
    name: "modelDeleteHierarchicalEntity", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelDeleteHierarchicalEntity_564967, base: "",
    url: url_ModelDeleteHierarchicalEntity_564968, schemes: {Scheme.Https})
type
  Call_ModelAddHierarchicalEntityChild_564975 = ref object of OpenApiRestCall_563566
proc url_ModelAddHierarchicalEntityChild_564977(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/children")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddHierarchicalEntityChild_564976(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a single child in an existing hierarchical entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hEntityId` field"
  var valid_564978 = path.getOrDefault("hEntityId")
  valid_564978 = validateParameter(valid_564978, JString, required = true,
                                 default = nil)
  if valid_564978 != nil:
    section.add "hEntityId", valid_564978
  var valid_564979 = path.getOrDefault("appId")
  valid_564979 = validateParameter(valid_564979, JString, required = true,
                                 default = nil)
  if valid_564979 != nil:
    section.add "appId", valid_564979
  var valid_564980 = path.getOrDefault("versionId")
  valid_564980 = validateParameter(valid_564980, JString, required = true,
                                 default = nil)
  if valid_564980 != nil:
    section.add "versionId", valid_564980
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   hierarchicalChildModelCreateObject: JObject (required)
  ##                                     : A model object containing the name of the new hierarchical child model.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564982: Call_ModelAddHierarchicalEntityChild_564975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a single child in an existing hierarchical entity model in a version of the application.
  ## 
  let valid = call_564982.validator(path, query, header, formData, body)
  let scheme = call_564982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564982.url(scheme.get, call_564982.host, call_564982.base,
                         call_564982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564982, url, valid)

proc call*(call_564983: Call_ModelAddHierarchicalEntityChild_564975;
          hierarchicalChildModelCreateObject: JsonNode; hEntityId: string;
          appId: string; versionId: string): Recallable =
  ## modelAddHierarchicalEntityChild
  ## Creates a single child in an existing hierarchical entity model in a version of the application.
  ##   hierarchicalChildModelCreateObject: JObject (required)
  ##                                     : A model object containing the name of the new hierarchical child model.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564984 = newJObject()
  var body_564985 = newJObject()
  if hierarchicalChildModelCreateObject != nil:
    body_564985 = hierarchicalChildModelCreateObject
  add(path_564984, "hEntityId", newJString(hEntityId))
  add(path_564984, "appId", newJString(appId))
  add(path_564984, "versionId", newJString(versionId))
  result = call_564983.call(path_564984, nil, nil, nil, body_564985)

var modelAddHierarchicalEntityChild* = Call_ModelAddHierarchicalEntityChild_564975(
    name: "modelAddHierarchicalEntityChild", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children",
    validator: validate_ModelAddHierarchicalEntityChild_564976, base: "",
    url: url_ModelAddHierarchicalEntityChild_564977, schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntityChild_564996 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateHierarchicalEntityChild_564998(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  assert "hChildId" in path, "`hChildId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/children/"),
               (kind: VariableSegment, value: "hChildId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateHierarchicalEntityChild_564997(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Renames a single child in an existing hierarchical entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hChildId: JString (required)
  ##           : The hierarchical entity extractor child ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hEntityId` field"
  var valid_564999 = path.getOrDefault("hEntityId")
  valid_564999 = validateParameter(valid_564999, JString, required = true,
                                 default = nil)
  if valid_564999 != nil:
    section.add "hEntityId", valid_564999
  var valid_565000 = path.getOrDefault("appId")
  valid_565000 = validateParameter(valid_565000, JString, required = true,
                                 default = nil)
  if valid_565000 != nil:
    section.add "appId", valid_565000
  var valid_565001 = path.getOrDefault("hChildId")
  valid_565001 = validateParameter(valid_565001, JString, required = true,
                                 default = nil)
  if valid_565001 != nil:
    section.add "hChildId", valid_565001
  var valid_565002 = path.getOrDefault("versionId")
  valid_565002 = validateParameter(valid_565002, JString, required = true,
                                 default = nil)
  if valid_565002 != nil:
    section.add "versionId", valid_565002
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   hierarchicalChildModelUpdateObject: JObject (required)
  ##                                     : Model object containing new name of the hierarchical entity child.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565004: Call_ModelUpdateHierarchicalEntityChild_564996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renames a single child in an existing hierarchical entity model in a version of the application.
  ## 
  let valid = call_565004.validator(path, query, header, formData, body)
  let scheme = call_565004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565004.url(scheme.get, call_565004.host, call_565004.base,
                         call_565004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565004, url, valid)

proc call*(call_565005: Call_ModelUpdateHierarchicalEntityChild_564996;
          hEntityId: string; hierarchicalChildModelUpdateObject: JsonNode;
          appId: string; hChildId: string; versionId: string): Recallable =
  ## modelUpdateHierarchicalEntityChild
  ## Renames a single child in an existing hierarchical entity model in a version of the application.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   hierarchicalChildModelUpdateObject: JObject (required)
  ##                                     : Model object containing new name of the hierarchical entity child.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565006 = newJObject()
  var body_565007 = newJObject()
  add(path_565006, "hEntityId", newJString(hEntityId))
  if hierarchicalChildModelUpdateObject != nil:
    body_565007 = hierarchicalChildModelUpdateObject
  add(path_565006, "appId", newJString(appId))
  add(path_565006, "hChildId", newJString(hChildId))
  add(path_565006, "versionId", newJString(versionId))
  result = call_565005.call(path_565006, nil, nil, nil, body_565007)

var modelUpdateHierarchicalEntityChild* = Call_ModelUpdateHierarchicalEntityChild_564996(
    name: "modelUpdateHierarchicalEntityChild", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelUpdateHierarchicalEntityChild_564997, base: "",
    url: url_ModelUpdateHierarchicalEntityChild_564998, schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntityChild_564986 = ref object of OpenApiRestCall_563566
proc url_ModelGetHierarchicalEntityChild_564988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  assert "hChildId" in path, "`hChildId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/children/"),
               (kind: VariableSegment, value: "hChildId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetHierarchicalEntityChild_564987(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the child's model contained in an hierarchical entity child model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hChildId: JString (required)
  ##           : The hierarchical entity extractor child ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hEntityId` field"
  var valid_564989 = path.getOrDefault("hEntityId")
  valid_564989 = validateParameter(valid_564989, JString, required = true,
                                 default = nil)
  if valid_564989 != nil:
    section.add "hEntityId", valid_564989
  var valid_564990 = path.getOrDefault("appId")
  valid_564990 = validateParameter(valid_564990, JString, required = true,
                                 default = nil)
  if valid_564990 != nil:
    section.add "appId", valid_564990
  var valid_564991 = path.getOrDefault("hChildId")
  valid_564991 = validateParameter(valid_564991, JString, required = true,
                                 default = nil)
  if valid_564991 != nil:
    section.add "hChildId", valid_564991
  var valid_564992 = path.getOrDefault("versionId")
  valid_564992 = validateParameter(valid_564992, JString, required = true,
                                 default = nil)
  if valid_564992 != nil:
    section.add "versionId", valid_564992
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564993: Call_ModelGetHierarchicalEntityChild_564986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the child's model contained in an hierarchical entity child model in a version of the application.
  ## 
  let valid = call_564993.validator(path, query, header, formData, body)
  let scheme = call_564993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564993.url(scheme.get, call_564993.host, call_564993.base,
                         call_564993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564993, url, valid)

proc call*(call_564994: Call_ModelGetHierarchicalEntityChild_564986;
          hEntityId: string; appId: string; hChildId: string; versionId: string): Recallable =
  ## modelGetHierarchicalEntityChild
  ## Gets information about the child's model contained in an hierarchical entity child model in a version of the application.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564995 = newJObject()
  add(path_564995, "hEntityId", newJString(hEntityId))
  add(path_564995, "appId", newJString(appId))
  add(path_564995, "hChildId", newJString(hChildId))
  add(path_564995, "versionId", newJString(versionId))
  result = call_564994.call(path_564995, nil, nil, nil, nil)

var modelGetHierarchicalEntityChild* = Call_ModelGetHierarchicalEntityChild_564986(
    name: "modelGetHierarchicalEntityChild", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelGetHierarchicalEntityChild_564987, base: "",
    url: url_ModelGetHierarchicalEntityChild_564988, schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntityChild_565008 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteHierarchicalEntityChild_565010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  assert "hChildId" in path, "`hChildId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/children/"),
               (kind: VariableSegment, value: "hChildId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteHierarchicalEntityChild_565009(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a hierarchical entity extractor child in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hChildId: JString (required)
  ##           : The hierarchical entity extractor child ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hEntityId` field"
  var valid_565011 = path.getOrDefault("hEntityId")
  valid_565011 = validateParameter(valid_565011, JString, required = true,
                                 default = nil)
  if valid_565011 != nil:
    section.add "hEntityId", valid_565011
  var valid_565012 = path.getOrDefault("appId")
  valid_565012 = validateParameter(valid_565012, JString, required = true,
                                 default = nil)
  if valid_565012 != nil:
    section.add "appId", valid_565012
  var valid_565013 = path.getOrDefault("hChildId")
  valid_565013 = validateParameter(valid_565013, JString, required = true,
                                 default = nil)
  if valid_565013 != nil:
    section.add "hChildId", valid_565013
  var valid_565014 = path.getOrDefault("versionId")
  valid_565014 = validateParameter(valid_565014, JString, required = true,
                                 default = nil)
  if valid_565014 != nil:
    section.add "versionId", valid_565014
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565015: Call_ModelDeleteHierarchicalEntityChild_565008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a hierarchical entity extractor child in a version of the application.
  ## 
  let valid = call_565015.validator(path, query, header, formData, body)
  let scheme = call_565015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565015.url(scheme.get, call_565015.host, call_565015.base,
                         call_565015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565015, url, valid)

proc call*(call_565016: Call_ModelDeleteHierarchicalEntityChild_565008;
          hEntityId: string; appId: string; hChildId: string; versionId: string): Recallable =
  ## modelDeleteHierarchicalEntityChild
  ## Deletes a hierarchical entity extractor child in a version of the application.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565017 = newJObject()
  add(path_565017, "hEntityId", newJString(hEntityId))
  add(path_565017, "appId", newJString(appId))
  add(path_565017, "hChildId", newJString(hChildId))
  add(path_565017, "versionId", newJString(versionId))
  result = call_565016.call(path_565017, nil, nil, nil, nil)

var modelDeleteHierarchicalEntityChild* = Call_ModelDeleteHierarchicalEntityChild_565008(
    name: "modelDeleteHierarchicalEntityChild", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelDeleteHierarchicalEntityChild_565009, base: "",
    url: url_ModelDeleteHierarchicalEntityChild_565010, schemes: {Scheme.Https})
type
  Call_ModelCreateHierarchicalEntityRole_565027 = ref object of OpenApiRestCall_563566
proc url_ModelCreateHierarchicalEntityRole_565029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateHierarchicalEntityRole_565028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hEntityId` field"
  var valid_565030 = path.getOrDefault("hEntityId")
  valid_565030 = validateParameter(valid_565030, JString, required = true,
                                 default = nil)
  if valid_565030 != nil:
    section.add "hEntityId", valid_565030
  var valid_565031 = path.getOrDefault("appId")
  valid_565031 = validateParameter(valid_565031, JString, required = true,
                                 default = nil)
  if valid_565031 != nil:
    section.add "appId", valid_565031
  var valid_565032 = path.getOrDefault("versionId")
  valid_565032 = validateParameter(valid_565032, JString, required = true,
                                 default = nil)
  if valid_565032 != nil:
    section.add "versionId", valid_565032
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565034: Call_ModelCreateHierarchicalEntityRole_565027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_565034.validator(path, query, header, formData, body)
  let scheme = call_565034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565034.url(scheme.get, call_565034.host, call_565034.base,
                         call_565034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565034, url, valid)

proc call*(call_565035: Call_ModelCreateHierarchicalEntityRole_565027;
          hEntityId: string; entityRoleCreateObject: JsonNode; appId: string;
          versionId: string): Recallable =
  ## modelCreateHierarchicalEntityRole
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565036 = newJObject()
  var body_565037 = newJObject()
  add(path_565036, "hEntityId", newJString(hEntityId))
  if entityRoleCreateObject != nil:
    body_565037 = entityRoleCreateObject
  add(path_565036, "appId", newJString(appId))
  add(path_565036, "versionId", newJString(versionId))
  result = call_565035.call(path_565036, nil, nil, nil, body_565037)

var modelCreateHierarchicalEntityRole* = Call_ModelCreateHierarchicalEntityRole_565027(
    name: "modelCreateHierarchicalEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles",
    validator: validate_ModelCreateHierarchicalEntityRole_565028, base: "",
    url: url_ModelCreateHierarchicalEntityRole_565029, schemes: {Scheme.Https})
type
  Call_ModelListHierarchicalEntityRoles_565018 = ref object of OpenApiRestCall_563566
proc url_ModelListHierarchicalEntityRoles_565020(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListHierarchicalEntityRoles_565019(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hEntityId` field"
  var valid_565021 = path.getOrDefault("hEntityId")
  valid_565021 = validateParameter(valid_565021, JString, required = true,
                                 default = nil)
  if valid_565021 != nil:
    section.add "hEntityId", valid_565021
  var valid_565022 = path.getOrDefault("appId")
  valid_565022 = validateParameter(valid_565022, JString, required = true,
                                 default = nil)
  if valid_565022 != nil:
    section.add "appId", valid_565022
  var valid_565023 = path.getOrDefault("versionId")
  valid_565023 = validateParameter(valid_565023, JString, required = true,
                                 default = nil)
  if valid_565023 != nil:
    section.add "versionId", valid_565023
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565024: Call_ModelListHierarchicalEntityRoles_565018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_565024.validator(path, query, header, formData, body)
  let scheme = call_565024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565024.url(scheme.get, call_565024.host, call_565024.base,
                         call_565024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565024, url, valid)

proc call*(call_565025: Call_ModelListHierarchicalEntityRoles_565018;
          hEntityId: string; appId: string; versionId: string): Recallable =
  ## modelListHierarchicalEntityRoles
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565026 = newJObject()
  add(path_565026, "hEntityId", newJString(hEntityId))
  add(path_565026, "appId", newJString(appId))
  add(path_565026, "versionId", newJString(versionId))
  result = call_565025.call(path_565026, nil, nil, nil, nil)

var modelListHierarchicalEntityRoles* = Call_ModelListHierarchicalEntityRoles_565018(
    name: "modelListHierarchicalEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles",
    validator: validate_ModelListHierarchicalEntityRoles_565019, base: "",
    url: url_ModelListHierarchicalEntityRoles_565020, schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntityRole_565048 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateHierarchicalEntityRole_565050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateHierarchicalEntityRole_565049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hEntityId` field"
  var valid_565051 = path.getOrDefault("hEntityId")
  valid_565051 = validateParameter(valid_565051, JString, required = true,
                                 default = nil)
  if valid_565051 != nil:
    section.add "hEntityId", valid_565051
  var valid_565052 = path.getOrDefault("appId")
  valid_565052 = validateParameter(valid_565052, JString, required = true,
                                 default = nil)
  if valid_565052 != nil:
    section.add "appId", valid_565052
  var valid_565053 = path.getOrDefault("versionId")
  valid_565053 = validateParameter(valid_565053, JString, required = true,
                                 default = nil)
  if valid_565053 != nil:
    section.add "versionId", valid_565053
  var valid_565054 = path.getOrDefault("roleId")
  valid_565054 = validateParameter(valid_565054, JString, required = true,
                                 default = nil)
  if valid_565054 != nil:
    section.add "roleId", valid_565054
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565056: Call_ModelUpdateHierarchicalEntityRole_565048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_565056.validator(path, query, header, formData, body)
  let scheme = call_565056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565056.url(scheme.get, call_565056.host, call_565056.base,
                         call_565056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565056, url, valid)

proc call*(call_565057: Call_ModelUpdateHierarchicalEntityRole_565048;
          hEntityId: string; entityRoleUpdateObject: JsonNode; appId: string;
          versionId: string; roleId: string): Recallable =
  ## modelUpdateHierarchicalEntityRole
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_565058 = newJObject()
  var body_565059 = newJObject()
  add(path_565058, "hEntityId", newJString(hEntityId))
  if entityRoleUpdateObject != nil:
    body_565059 = entityRoleUpdateObject
  add(path_565058, "appId", newJString(appId))
  add(path_565058, "versionId", newJString(versionId))
  add(path_565058, "roleId", newJString(roleId))
  result = call_565057.call(path_565058, nil, nil, nil, body_565059)

var modelUpdateHierarchicalEntityRole* = Call_ModelUpdateHierarchicalEntityRole_565048(
    name: "modelUpdateHierarchicalEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles/{roleId}",
    validator: validate_ModelUpdateHierarchicalEntityRole_565049, base: "",
    url: url_ModelUpdateHierarchicalEntityRole_565050, schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntityRole_565038 = ref object of OpenApiRestCall_563566
proc url_ModelGetHierarchicalEntityRole_565040(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetHierarchicalEntityRole_565039(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hEntityId` field"
  var valid_565041 = path.getOrDefault("hEntityId")
  valid_565041 = validateParameter(valid_565041, JString, required = true,
                                 default = nil)
  if valid_565041 != nil:
    section.add "hEntityId", valid_565041
  var valid_565042 = path.getOrDefault("appId")
  valid_565042 = validateParameter(valid_565042, JString, required = true,
                                 default = nil)
  if valid_565042 != nil:
    section.add "appId", valid_565042
  var valid_565043 = path.getOrDefault("versionId")
  valid_565043 = validateParameter(valid_565043, JString, required = true,
                                 default = nil)
  if valid_565043 != nil:
    section.add "versionId", valid_565043
  var valid_565044 = path.getOrDefault("roleId")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "roleId", valid_565044
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565045: Call_ModelGetHierarchicalEntityRole_565038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565045.validator(path, query, header, formData, body)
  let scheme = call_565045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565045.url(scheme.get, call_565045.host, call_565045.base,
                         call_565045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565045, url, valid)

proc call*(call_565046: Call_ModelGetHierarchicalEntityRole_565038;
          hEntityId: string; appId: string; versionId: string; roleId: string): Recallable =
  ## modelGetHierarchicalEntityRole
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_565047 = newJObject()
  add(path_565047, "hEntityId", newJString(hEntityId))
  add(path_565047, "appId", newJString(appId))
  add(path_565047, "versionId", newJString(versionId))
  add(path_565047, "roleId", newJString(roleId))
  result = call_565046.call(path_565047, nil, nil, nil, nil)

var modelGetHierarchicalEntityRole* = Call_ModelGetHierarchicalEntityRole_565038(
    name: "modelGetHierarchicalEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles/{roleId}",
    validator: validate_ModelGetHierarchicalEntityRole_565039, base: "",
    url: url_ModelGetHierarchicalEntityRole_565040, schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntityRole_565060 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteHierarchicalEntityRole_565062(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteHierarchicalEntityRole_565061(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hEntityId` field"
  var valid_565063 = path.getOrDefault("hEntityId")
  valid_565063 = validateParameter(valid_565063, JString, required = true,
                                 default = nil)
  if valid_565063 != nil:
    section.add "hEntityId", valid_565063
  var valid_565064 = path.getOrDefault("appId")
  valid_565064 = validateParameter(valid_565064, JString, required = true,
                                 default = nil)
  if valid_565064 != nil:
    section.add "appId", valid_565064
  var valid_565065 = path.getOrDefault("versionId")
  valid_565065 = validateParameter(valid_565065, JString, required = true,
                                 default = nil)
  if valid_565065 != nil:
    section.add "versionId", valid_565065
  var valid_565066 = path.getOrDefault("roleId")
  valid_565066 = validateParameter(valid_565066, JString, required = true,
                                 default = nil)
  if valid_565066 != nil:
    section.add "roleId", valid_565066
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565067: Call_ModelDeleteHierarchicalEntityRole_565060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_565067.validator(path, query, header, formData, body)
  let scheme = call_565067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565067.url(scheme.get, call_565067.host, call_565067.base,
                         call_565067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565067, url, valid)

proc call*(call_565068: Call_ModelDeleteHierarchicalEntityRole_565060;
          hEntityId: string; appId: string; versionId: string; roleId: string): Recallable =
  ## modelDeleteHierarchicalEntityRole
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_565069 = newJObject()
  add(path_565069, "hEntityId", newJString(hEntityId))
  add(path_565069, "appId", newJString(appId))
  add(path_565069, "versionId", newJString(versionId))
  add(path_565069, "roleId", newJString(roleId))
  result = call_565068.call(path_565069, nil, nil, nil, nil)

var modelDeleteHierarchicalEntityRole* = Call_ModelDeleteHierarchicalEntityRole_565060(
    name: "modelDeleteHierarchicalEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles/{roleId}",
    validator: validate_ModelDeleteHierarchicalEntityRole_565061, base: "",
    url: url_ModelDeleteHierarchicalEntityRole_565062, schemes: {Scheme.Https})
type
  Call_ModelAddIntent_565081 = ref object of OpenApiRestCall_563566
proc url_ModelAddIntent_565083(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddIntent_565082(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Adds an intent to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565084 = path.getOrDefault("appId")
  valid_565084 = validateParameter(valid_565084, JString, required = true,
                                 default = nil)
  if valid_565084 != nil:
    section.add "appId", valid_565084
  var valid_565085 = path.getOrDefault("versionId")
  valid_565085 = validateParameter(valid_565085, JString, required = true,
                                 default = nil)
  if valid_565085 != nil:
    section.add "versionId", valid_565085
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   intentCreateObject: JObject (required)
  ##                     : A model object containing the name of the new intent.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565087: Call_ModelAddIntent_565081; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an intent to a version of the application.
  ## 
  let valid = call_565087.validator(path, query, header, formData, body)
  let scheme = call_565087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565087.url(scheme.get, call_565087.host, call_565087.base,
                         call_565087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565087, url, valid)

proc call*(call_565088: Call_ModelAddIntent_565081; intentCreateObject: JsonNode;
          appId: string; versionId: string): Recallable =
  ## modelAddIntent
  ## Adds an intent to a version of the application.
  ##   intentCreateObject: JObject (required)
  ##                     : A model object containing the name of the new intent.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565089 = newJObject()
  var body_565090 = newJObject()
  if intentCreateObject != nil:
    body_565090 = intentCreateObject
  add(path_565089, "appId", newJString(appId))
  add(path_565089, "versionId", newJString(versionId))
  result = call_565088.call(path_565089, nil, nil, nil, body_565090)

var modelAddIntent* = Call_ModelAddIntent_565081(name: "modelAddIntent",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents",
    validator: validate_ModelAddIntent_565082, base: "", url: url_ModelAddIntent_565083,
    schemes: {Scheme.Https})
type
  Call_ModelListIntents_565070 = ref object of OpenApiRestCall_563566
proc url_ModelListIntents_565072(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListIntents_565071(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about the intent models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565073 = path.getOrDefault("appId")
  valid_565073 = validateParameter(valid_565073, JString, required = true,
                                 default = nil)
  if valid_565073 != nil:
    section.add "appId", valid_565073
  var valid_565074 = path.getOrDefault("versionId")
  valid_565074 = validateParameter(valid_565074, JString, required = true,
                                 default = nil)
  if valid_565074 != nil:
    section.add "versionId", valid_565074
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_565075 = query.getOrDefault("take")
  valid_565075 = validateParameter(valid_565075, JInt, required = false,
                                 default = newJInt(100))
  if valid_565075 != nil:
    section.add "take", valid_565075
  var valid_565076 = query.getOrDefault("skip")
  valid_565076 = validateParameter(valid_565076, JInt, required = false,
                                 default = newJInt(0))
  if valid_565076 != nil:
    section.add "skip", valid_565076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565077: Call_ModelListIntents_565070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the intent models in a version of the application.
  ## 
  let valid = call_565077.validator(path, query, header, formData, body)
  let scheme = call_565077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565077.url(scheme.get, call_565077.host, call_565077.base,
                         call_565077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565077, url, valid)

proc call*(call_565078: Call_ModelListIntents_565070; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListIntents
  ## Gets information about the intent models in a version of the application.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565079 = newJObject()
  var query_565080 = newJObject()
  add(query_565080, "take", newJInt(take))
  add(query_565080, "skip", newJInt(skip))
  add(path_565079, "appId", newJString(appId))
  add(path_565079, "versionId", newJString(versionId))
  result = call_565078.call(path_565079, query_565080, nil, nil, nil)

var modelListIntents* = Call_ModelListIntents_565070(name: "modelListIntents",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents",
    validator: validate_ModelListIntents_565071, base: "",
    url: url_ModelListIntents_565072, schemes: {Scheme.Https})
type
  Call_ModelUpdateIntent_565100 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateIntent_565102(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "intentId" in path, "`intentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents/"),
               (kind: VariableSegment, value: "intentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateIntent_565101(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the name of an intent in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `intentId` field"
  var valid_565103 = path.getOrDefault("intentId")
  valid_565103 = validateParameter(valid_565103, JString, required = true,
                                 default = nil)
  if valid_565103 != nil:
    section.add "intentId", valid_565103
  var valid_565104 = path.getOrDefault("appId")
  valid_565104 = validateParameter(valid_565104, JString, required = true,
                                 default = nil)
  if valid_565104 != nil:
    section.add "appId", valid_565104
  var valid_565105 = path.getOrDefault("versionId")
  valid_565105 = validateParameter(valid_565105, JString, required = true,
                                 default = nil)
  if valid_565105 != nil:
    section.add "versionId", valid_565105
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new intent name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565107: Call_ModelUpdateIntent_565100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name of an intent in a version of the application.
  ## 
  let valid = call_565107.validator(path, query, header, formData, body)
  let scheme = call_565107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565107.url(scheme.get, call_565107.host, call_565107.base,
                         call_565107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565107, url, valid)

proc call*(call_565108: Call_ModelUpdateIntent_565100; intentId: string;
          appId: string; modelUpdateObject: JsonNode; versionId: string): Recallable =
  ## modelUpdateIntent
  ## Updates the name of an intent in a version of the application.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new intent name.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565109 = newJObject()
  var body_565110 = newJObject()
  add(path_565109, "intentId", newJString(intentId))
  add(path_565109, "appId", newJString(appId))
  if modelUpdateObject != nil:
    body_565110 = modelUpdateObject
  add(path_565109, "versionId", newJString(versionId))
  result = call_565108.call(path_565109, nil, nil, nil, body_565110)

var modelUpdateIntent* = Call_ModelUpdateIntent_565100(name: "modelUpdateIntent",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelUpdateIntent_565101, base: "",
    url: url_ModelUpdateIntent_565102, schemes: {Scheme.Https})
type
  Call_ModelGetIntent_565091 = ref object of OpenApiRestCall_563566
proc url_ModelGetIntent_565093(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "intentId" in path, "`intentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents/"),
               (kind: VariableSegment, value: "intentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetIntent_565092(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the intent model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `intentId` field"
  var valid_565094 = path.getOrDefault("intentId")
  valid_565094 = validateParameter(valid_565094, JString, required = true,
                                 default = nil)
  if valid_565094 != nil:
    section.add "intentId", valid_565094
  var valid_565095 = path.getOrDefault("appId")
  valid_565095 = validateParameter(valid_565095, JString, required = true,
                                 default = nil)
  if valid_565095 != nil:
    section.add "appId", valid_565095
  var valid_565096 = path.getOrDefault("versionId")
  valid_565096 = validateParameter(valid_565096, JString, required = true,
                                 default = nil)
  if valid_565096 != nil:
    section.add "versionId", valid_565096
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565097: Call_ModelGetIntent_565091; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the intent model in a version of the application.
  ## 
  let valid = call_565097.validator(path, query, header, formData, body)
  let scheme = call_565097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565097.url(scheme.get, call_565097.host, call_565097.base,
                         call_565097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565097, url, valid)

proc call*(call_565098: Call_ModelGetIntent_565091; intentId: string; appId: string;
          versionId: string): Recallable =
  ## modelGetIntent
  ## Gets information about the intent model in a version of the application.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565099 = newJObject()
  add(path_565099, "intentId", newJString(intentId))
  add(path_565099, "appId", newJString(appId))
  add(path_565099, "versionId", newJString(versionId))
  result = call_565098.call(path_565099, nil, nil, nil, nil)

var modelGetIntent* = Call_ModelGetIntent_565091(name: "modelGetIntent",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelGetIntent_565092, base: "", url: url_ModelGetIntent_565093,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteIntent_565111 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteIntent_565113(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "intentId" in path, "`intentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents/"),
               (kind: VariableSegment, value: "intentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteIntent_565112(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an intent from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `intentId` field"
  var valid_565114 = path.getOrDefault("intentId")
  valid_565114 = validateParameter(valid_565114, JString, required = true,
                                 default = nil)
  if valid_565114 != nil:
    section.add "intentId", valid_565114
  var valid_565115 = path.getOrDefault("appId")
  valid_565115 = validateParameter(valid_565115, JString, required = true,
                                 default = nil)
  if valid_565115 != nil:
    section.add "appId", valid_565115
  var valid_565116 = path.getOrDefault("versionId")
  valid_565116 = validateParameter(valid_565116, JString, required = true,
                                 default = nil)
  if valid_565116 != nil:
    section.add "versionId", valid_565116
  result.add "path", section
  ## parameters in `query` object:
  ##   deleteUtterances: JBool
  ##                   : If true, deletes the intent's example utterances. If false, moves the example utterances to the None intent. The default value is false.
  section = newJObject()
  var valid_565117 = query.getOrDefault("deleteUtterances")
  valid_565117 = validateParameter(valid_565117, JBool, required = false,
                                 default = newJBool(false))
  if valid_565117 != nil:
    section.add "deleteUtterances", valid_565117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565118: Call_ModelDeleteIntent_565111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an intent from a version of the application.
  ## 
  let valid = call_565118.validator(path, query, header, formData, body)
  let scheme = call_565118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565118.url(scheme.get, call_565118.host, call_565118.base,
                         call_565118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565118, url, valid)

proc call*(call_565119: Call_ModelDeleteIntent_565111; intentId: string;
          appId: string; versionId: string; deleteUtterances: bool = false): Recallable =
  ## modelDeleteIntent
  ## Deletes an intent from a version of the application.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   deleteUtterances: bool
  ##                   : If true, deletes the intent's example utterances. If false, moves the example utterances to the None intent. The default value is false.
  var path_565120 = newJObject()
  var query_565121 = newJObject()
  add(path_565120, "intentId", newJString(intentId))
  add(path_565120, "appId", newJString(appId))
  add(path_565120, "versionId", newJString(versionId))
  add(query_565121, "deleteUtterances", newJBool(deleteUtterances))
  result = call_565119.call(path_565120, query_565121, nil, nil, nil)

var modelDeleteIntent* = Call_ModelDeleteIntent_565111(name: "modelDeleteIntent",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelDeleteIntent_565112, base: "",
    url: url_ModelDeleteIntent_565113, schemes: {Scheme.Https})
type
  Call_PatternListIntentPatterns_565122 = ref object of OpenApiRestCall_563566
proc url_PatternListIntentPatterns_565124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "intentId" in path, "`intentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents/"),
               (kind: VariableSegment, value: "intentId"),
               (kind: ConstantSegment, value: "/patternrules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternListIntentPatterns_565123(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `intentId` field"
  var valid_565125 = path.getOrDefault("intentId")
  valid_565125 = validateParameter(valid_565125, JString, required = true,
                                 default = nil)
  if valid_565125 != nil:
    section.add "intentId", valid_565125
  var valid_565126 = path.getOrDefault("appId")
  valid_565126 = validateParameter(valid_565126, JString, required = true,
                                 default = nil)
  if valid_565126 != nil:
    section.add "appId", valid_565126
  var valid_565127 = path.getOrDefault("versionId")
  valid_565127 = validateParameter(valid_565127, JString, required = true,
                                 default = nil)
  if valid_565127 != nil:
    section.add "versionId", valid_565127
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_565128 = query.getOrDefault("take")
  valid_565128 = validateParameter(valid_565128, JInt, required = false,
                                 default = newJInt(100))
  if valid_565128 != nil:
    section.add "take", valid_565128
  var valid_565129 = query.getOrDefault("skip")
  valid_565129 = validateParameter(valid_565129, JInt, required = false,
                                 default = newJInt(0))
  if valid_565129 != nil:
    section.add "skip", valid_565129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565130: Call_PatternListIntentPatterns_565122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565130.validator(path, query, header, formData, body)
  let scheme = call_565130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565130.url(scheme.get, call_565130.host, call_565130.base,
                         call_565130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565130, url, valid)

proc call*(call_565131: Call_PatternListIntentPatterns_565122; intentId: string;
          appId: string; versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## patternListIntentPatterns
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565132 = newJObject()
  var query_565133 = newJObject()
  add(query_565133, "take", newJInt(take))
  add(path_565132, "intentId", newJString(intentId))
  add(query_565133, "skip", newJInt(skip))
  add(path_565132, "appId", newJString(appId))
  add(path_565132, "versionId", newJString(versionId))
  result = call_565131.call(path_565132, query_565133, nil, nil, nil)

var patternListIntentPatterns* = Call_PatternListIntentPatterns_565122(
    name: "patternListIntentPatterns", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/intents/{intentId}/patternrules",
    validator: validate_PatternListIntentPatterns_565123, base: "",
    url: url_PatternListIntentPatterns_565124, schemes: {Scheme.Https})
type
  Call_ModelListIntentSuggestions_565134 = ref object of OpenApiRestCall_563566
proc url_ModelListIntentSuggestions_565136(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "intentId" in path, "`intentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents/"),
               (kind: VariableSegment, value: "intentId"),
               (kind: ConstantSegment, value: "/suggest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListIntentSuggestions_565135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Suggests example utterances that would improve the accuracy of the intent model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `intentId` field"
  var valid_565137 = path.getOrDefault("intentId")
  valid_565137 = validateParameter(valid_565137, JString, required = true,
                                 default = nil)
  if valid_565137 != nil:
    section.add "intentId", valid_565137
  var valid_565138 = path.getOrDefault("appId")
  valid_565138 = validateParameter(valid_565138, JString, required = true,
                                 default = nil)
  if valid_565138 != nil:
    section.add "appId", valid_565138
  var valid_565139 = path.getOrDefault("versionId")
  valid_565139 = validateParameter(valid_565139, JString, required = true,
                                 default = nil)
  if valid_565139 != nil:
    section.add "versionId", valid_565139
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_565140 = query.getOrDefault("take")
  valid_565140 = validateParameter(valid_565140, JInt, required = false,
                                 default = newJInt(100))
  if valid_565140 != nil:
    section.add "take", valid_565140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565141: Call_ModelListIntentSuggestions_565134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests example utterances that would improve the accuracy of the intent model in a version of the application.
  ## 
  let valid = call_565141.validator(path, query, header, formData, body)
  let scheme = call_565141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565141.url(scheme.get, call_565141.host, call_565141.base,
                         call_565141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565141, url, valid)

proc call*(call_565142: Call_ModelListIntentSuggestions_565134; intentId: string;
          appId: string; versionId: string; take: int = 100): Recallable =
  ## modelListIntentSuggestions
  ## Suggests example utterances that would improve the accuracy of the intent model in a version of the application.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565143 = newJObject()
  var query_565144 = newJObject()
  add(query_565144, "take", newJInt(take))
  add(path_565143, "intentId", newJString(intentId))
  add(path_565143, "appId", newJString(appId))
  add(path_565143, "versionId", newJString(versionId))
  result = call_565142.call(path_565143, query_565144, nil, nil, nil)

var modelListIntentSuggestions* = Call_ModelListIntentSuggestions_565134(
    name: "modelListIntentSuggestions", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}/suggest",
    validator: validate_ModelListIntentSuggestions_565135, base: "",
    url: url_ModelListIntentSuggestions_565136, schemes: {Scheme.Https})
type
  Call_ModelListPrebuiltEntities_565145 = ref object of OpenApiRestCall_563566
proc url_ModelListPrebuiltEntities_565147(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/listprebuilts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListPrebuiltEntities_565146(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the available prebuilt entities in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565148 = path.getOrDefault("appId")
  valid_565148 = validateParameter(valid_565148, JString, required = true,
                                 default = nil)
  if valid_565148 != nil:
    section.add "appId", valid_565148
  var valid_565149 = path.getOrDefault("versionId")
  valid_565149 = validateParameter(valid_565149, JString, required = true,
                                 default = nil)
  if valid_565149 != nil:
    section.add "versionId", valid_565149
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565150: Call_ModelListPrebuiltEntities_565145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the available prebuilt entities in a version of the application.
  ## 
  let valid = call_565150.validator(path, query, header, formData, body)
  let scheme = call_565150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565150.url(scheme.get, call_565150.host, call_565150.base,
                         call_565150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565150, url, valid)

proc call*(call_565151: Call_ModelListPrebuiltEntities_565145; appId: string;
          versionId: string): Recallable =
  ## modelListPrebuiltEntities
  ## Gets all the available prebuilt entities in a version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565152 = newJObject()
  add(path_565152, "appId", newJString(appId))
  add(path_565152, "versionId", newJString(versionId))
  result = call_565151.call(path_565152, nil, nil, nil, nil)

var modelListPrebuiltEntities* = Call_ModelListPrebuiltEntities_565145(
    name: "modelListPrebuiltEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/listprebuilts",
    validator: validate_ModelListPrebuiltEntities_565146, base: "",
    url: url_ModelListPrebuiltEntities_565147, schemes: {Scheme.Https})
type
  Call_ModelListModels_565153 = ref object of OpenApiRestCall_563566
proc url_ModelListModels_565155(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/models")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListModels_565154(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about all the intent and entity models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565156 = path.getOrDefault("appId")
  valid_565156 = validateParameter(valid_565156, JString, required = true,
                                 default = nil)
  if valid_565156 != nil:
    section.add "appId", valid_565156
  var valid_565157 = path.getOrDefault("versionId")
  valid_565157 = validateParameter(valid_565157, JString, required = true,
                                 default = nil)
  if valid_565157 != nil:
    section.add "versionId", valid_565157
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_565158 = query.getOrDefault("take")
  valid_565158 = validateParameter(valid_565158, JInt, required = false,
                                 default = newJInt(100))
  if valid_565158 != nil:
    section.add "take", valid_565158
  var valid_565159 = query.getOrDefault("skip")
  valid_565159 = validateParameter(valid_565159, JInt, required = false,
                                 default = newJInt(0))
  if valid_565159 != nil:
    section.add "skip", valid_565159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565160: Call_ModelListModels_565153; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the intent and entity models in a version of the application.
  ## 
  let valid = call_565160.validator(path, query, header, formData, body)
  let scheme = call_565160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565160.url(scheme.get, call_565160.host, call_565160.base,
                         call_565160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565160, url, valid)

proc call*(call_565161: Call_ModelListModels_565153; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListModels
  ## Gets information about all the intent and entity models in a version of the application.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565162 = newJObject()
  var query_565163 = newJObject()
  add(query_565163, "take", newJInt(take))
  add(query_565163, "skip", newJInt(skip))
  add(path_565162, "appId", newJString(appId))
  add(path_565162, "versionId", newJString(versionId))
  result = call_565161.call(path_565162, query_565163, nil, nil, nil)

var modelListModels* = Call_ModelListModels_565153(name: "modelListModels",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/models",
    validator: validate_ModelListModels_565154, base: "", url: url_ModelListModels_565155,
    schemes: {Scheme.Https})
type
  Call_ModelExamples_565164 = ref object of OpenApiRestCall_563566
proc url_ModelExamples_565166(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "modelId" in path, "`modelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "modelId"),
               (kind: ConstantSegment, value: "/examples")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelExamples_565165(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the example utterances for the given intent or entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   modelId: JString (required)
  ##          : The ID (GUID) of the model.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565167 = path.getOrDefault("appId")
  valid_565167 = validateParameter(valid_565167, JString, required = true,
                                 default = nil)
  if valid_565167 != nil:
    section.add "appId", valid_565167
  var valid_565168 = path.getOrDefault("modelId")
  valid_565168 = validateParameter(valid_565168, JString, required = true,
                                 default = nil)
  if valid_565168 != nil:
    section.add "modelId", valid_565168
  var valid_565169 = path.getOrDefault("versionId")
  valid_565169 = validateParameter(valid_565169, JString, required = true,
                                 default = nil)
  if valid_565169 != nil:
    section.add "versionId", valid_565169
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_565170 = query.getOrDefault("take")
  valid_565170 = validateParameter(valid_565170, JInt, required = false,
                                 default = newJInt(100))
  if valid_565170 != nil:
    section.add "take", valid_565170
  var valid_565171 = query.getOrDefault("skip")
  valid_565171 = validateParameter(valid_565171, JInt, required = false,
                                 default = newJInt(0))
  if valid_565171 != nil:
    section.add "skip", valid_565171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565172: Call_ModelExamples_565164; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the example utterances for the given intent or entity model in a version of the application.
  ## 
  let valid = call_565172.validator(path, query, header, formData, body)
  let scheme = call_565172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565172.url(scheme.get, call_565172.host, call_565172.base,
                         call_565172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565172, url, valid)

proc call*(call_565173: Call_ModelExamples_565164; appId: string; modelId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelExamples
  ## Gets the example utterances for the given intent or entity model in a version of the application.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   modelId: string (required)
  ##          : The ID (GUID) of the model.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565174 = newJObject()
  var query_565175 = newJObject()
  add(query_565175, "take", newJInt(take))
  add(query_565175, "skip", newJInt(skip))
  add(path_565174, "appId", newJString(appId))
  add(path_565174, "modelId", newJString(modelId))
  add(path_565174, "versionId", newJString(versionId))
  result = call_565173.call(path_565174, query_565175, nil, nil, nil)

var modelExamples* = Call_ModelExamples_565164(name: "modelExamples",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/models/{modelId}/examples",
    validator: validate_ModelExamples_565165, base: "", url: url_ModelExamples_565166,
    schemes: {Scheme.Https})
type
  Call_ModelCreatePatternAnyEntityModel_565187 = ref object of OpenApiRestCall_563566
proc url_ModelCreatePatternAnyEntityModel_565189(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreatePatternAnyEntityModel_565188(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565190 = path.getOrDefault("appId")
  valid_565190 = validateParameter(valid_565190, JString, required = true,
                                 default = nil)
  if valid_565190 != nil:
    section.add "appId", valid_565190
  var valid_565191 = path.getOrDefault("versionId")
  valid_565191 = validateParameter(valid_565191, JString, required = true,
                                 default = nil)
  if valid_565191 != nil:
    section.add "versionId", valid_565191
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   extractorCreateObject: JObject (required)
  ##                        : A model object containing the name and explicit list for the new Pattern.Any entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565193: Call_ModelCreatePatternAnyEntityModel_565187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_565193.validator(path, query, header, formData, body)
  let scheme = call_565193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565193.url(scheme.get, call_565193.host, call_565193.base,
                         call_565193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565193, url, valid)

proc call*(call_565194: Call_ModelCreatePatternAnyEntityModel_565187;
          appId: string; extractorCreateObject: JsonNode; versionId: string): Recallable =
  ## modelCreatePatternAnyEntityModel
  ##   appId: string (required)
  ##        : The application ID.
  ##   extractorCreateObject: JObject (required)
  ##                        : A model object containing the name and explicit list for the new Pattern.Any entity extractor.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565195 = newJObject()
  var body_565196 = newJObject()
  add(path_565195, "appId", newJString(appId))
  if extractorCreateObject != nil:
    body_565196 = extractorCreateObject
  add(path_565195, "versionId", newJString(versionId))
  result = call_565194.call(path_565195, nil, nil, nil, body_565196)

var modelCreatePatternAnyEntityModel* = Call_ModelCreatePatternAnyEntityModel_565187(
    name: "modelCreatePatternAnyEntityModel", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities",
    validator: validate_ModelCreatePatternAnyEntityModel_565188, base: "",
    url: url_ModelCreatePatternAnyEntityModel_565189, schemes: {Scheme.Https})
type
  Call_ModelListPatternAnyEntityInfos_565176 = ref object of OpenApiRestCall_563566
proc url_ModelListPatternAnyEntityInfos_565178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListPatternAnyEntityInfos_565177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565179 = path.getOrDefault("appId")
  valid_565179 = validateParameter(valid_565179, JString, required = true,
                                 default = nil)
  if valid_565179 != nil:
    section.add "appId", valid_565179
  var valid_565180 = path.getOrDefault("versionId")
  valid_565180 = validateParameter(valid_565180, JString, required = true,
                                 default = nil)
  if valid_565180 != nil:
    section.add "versionId", valid_565180
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_565181 = query.getOrDefault("take")
  valid_565181 = validateParameter(valid_565181, JInt, required = false,
                                 default = newJInt(100))
  if valid_565181 != nil:
    section.add "take", valid_565181
  var valid_565182 = query.getOrDefault("skip")
  valid_565182 = validateParameter(valid_565182, JInt, required = false,
                                 default = newJInt(0))
  if valid_565182 != nil:
    section.add "skip", valid_565182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565183: Call_ModelListPatternAnyEntityInfos_565176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565183.validator(path, query, header, formData, body)
  let scheme = call_565183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565183.url(scheme.get, call_565183.host, call_565183.base,
                         call_565183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565183, url, valid)

proc call*(call_565184: Call_ModelListPatternAnyEntityInfos_565176; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListPatternAnyEntityInfos
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565185 = newJObject()
  var query_565186 = newJObject()
  add(query_565186, "take", newJInt(take))
  add(query_565186, "skip", newJInt(skip))
  add(path_565185, "appId", newJString(appId))
  add(path_565185, "versionId", newJString(versionId))
  result = call_565184.call(path_565185, query_565186, nil, nil, nil)

var modelListPatternAnyEntityInfos* = Call_ModelListPatternAnyEntityInfos_565176(
    name: "modelListPatternAnyEntityInfos", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities",
    validator: validate_ModelListPatternAnyEntityInfos_565177, base: "",
    url: url_ModelListPatternAnyEntityInfos_565178, schemes: {Scheme.Https})
type
  Call_ModelUpdatePatternAnyEntityModel_565206 = ref object of OpenApiRestCall_563566
proc url_ModelUpdatePatternAnyEntityModel_565208(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdatePatternAnyEntityModel_565207(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565209 = path.getOrDefault("entityId")
  valid_565209 = validateParameter(valid_565209, JString, required = true,
                                 default = nil)
  if valid_565209 != nil:
    section.add "entityId", valid_565209
  var valid_565210 = path.getOrDefault("appId")
  valid_565210 = validateParameter(valid_565210, JString, required = true,
                                 default = nil)
  if valid_565210 != nil:
    section.add "appId", valid_565210
  var valid_565211 = path.getOrDefault("versionId")
  valid_565211 = validateParameter(valid_565211, JString, required = true,
                                 default = nil)
  if valid_565211 != nil:
    section.add "versionId", valid_565211
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patternAnyUpdateObject: JObject (required)
  ##                         : An object containing the explicit list of the Pattern.Any entity.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565213: Call_ModelUpdatePatternAnyEntityModel_565206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_565213.validator(path, query, header, formData, body)
  let scheme = call_565213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565213.url(scheme.get, call_565213.host, call_565213.base,
                         call_565213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565213, url, valid)

proc call*(call_565214: Call_ModelUpdatePatternAnyEntityModel_565206;
          entityId: string; patternAnyUpdateObject: JsonNode; appId: string;
          versionId: string): Recallable =
  ## modelUpdatePatternAnyEntityModel
  ##   entityId: string (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   patternAnyUpdateObject: JObject (required)
  ##                         : An object containing the explicit list of the Pattern.Any entity.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565215 = newJObject()
  var body_565216 = newJObject()
  add(path_565215, "entityId", newJString(entityId))
  if patternAnyUpdateObject != nil:
    body_565216 = patternAnyUpdateObject
  add(path_565215, "appId", newJString(appId))
  add(path_565215, "versionId", newJString(versionId))
  result = call_565214.call(path_565215, nil, nil, nil, body_565216)

var modelUpdatePatternAnyEntityModel* = Call_ModelUpdatePatternAnyEntityModel_565206(
    name: "modelUpdatePatternAnyEntityModel", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}",
    validator: validate_ModelUpdatePatternAnyEntityModel_565207, base: "",
    url: url_ModelUpdatePatternAnyEntityModel_565208, schemes: {Scheme.Https})
type
  Call_ModelGetPatternAnyEntityInfo_565197 = ref object of OpenApiRestCall_563566
proc url_ModelGetPatternAnyEntityInfo_565199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetPatternAnyEntityInfo_565198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565200 = path.getOrDefault("entityId")
  valid_565200 = validateParameter(valid_565200, JString, required = true,
                                 default = nil)
  if valid_565200 != nil:
    section.add "entityId", valid_565200
  var valid_565201 = path.getOrDefault("appId")
  valid_565201 = validateParameter(valid_565201, JString, required = true,
                                 default = nil)
  if valid_565201 != nil:
    section.add "appId", valid_565201
  var valid_565202 = path.getOrDefault("versionId")
  valid_565202 = validateParameter(valid_565202, JString, required = true,
                                 default = nil)
  if valid_565202 != nil:
    section.add "versionId", valid_565202
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565203: Call_ModelGetPatternAnyEntityInfo_565197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565203.validator(path, query, header, formData, body)
  let scheme = call_565203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565203.url(scheme.get, call_565203.host, call_565203.base,
                         call_565203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565203, url, valid)

proc call*(call_565204: Call_ModelGetPatternAnyEntityInfo_565197; entityId: string;
          appId: string; versionId: string): Recallable =
  ## modelGetPatternAnyEntityInfo
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565205 = newJObject()
  add(path_565205, "entityId", newJString(entityId))
  add(path_565205, "appId", newJString(appId))
  add(path_565205, "versionId", newJString(versionId))
  result = call_565204.call(path_565205, nil, nil, nil, nil)

var modelGetPatternAnyEntityInfo* = Call_ModelGetPatternAnyEntityInfo_565197(
    name: "modelGetPatternAnyEntityInfo", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}",
    validator: validate_ModelGetPatternAnyEntityInfo_565198, base: "",
    url: url_ModelGetPatternAnyEntityInfo_565199, schemes: {Scheme.Https})
type
  Call_ModelDeletePatternAnyEntityModel_565217 = ref object of OpenApiRestCall_563566
proc url_ModelDeletePatternAnyEntityModel_565219(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeletePatternAnyEntityModel_565218(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565220 = path.getOrDefault("entityId")
  valid_565220 = validateParameter(valid_565220, JString, required = true,
                                 default = nil)
  if valid_565220 != nil:
    section.add "entityId", valid_565220
  var valid_565221 = path.getOrDefault("appId")
  valid_565221 = validateParameter(valid_565221, JString, required = true,
                                 default = nil)
  if valid_565221 != nil:
    section.add "appId", valid_565221
  var valid_565222 = path.getOrDefault("versionId")
  valid_565222 = validateParameter(valid_565222, JString, required = true,
                                 default = nil)
  if valid_565222 != nil:
    section.add "versionId", valid_565222
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565223: Call_ModelDeletePatternAnyEntityModel_565217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_565223.validator(path, query, header, formData, body)
  let scheme = call_565223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565223.url(scheme.get, call_565223.host, call_565223.base,
                         call_565223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565223, url, valid)

proc call*(call_565224: Call_ModelDeletePatternAnyEntityModel_565217;
          entityId: string; appId: string; versionId: string): Recallable =
  ## modelDeletePatternAnyEntityModel
  ##   entityId: string (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565225 = newJObject()
  add(path_565225, "entityId", newJString(entityId))
  add(path_565225, "appId", newJString(appId))
  add(path_565225, "versionId", newJString(versionId))
  result = call_565224.call(path_565225, nil, nil, nil, nil)

var modelDeletePatternAnyEntityModel* = Call_ModelDeletePatternAnyEntityModel_565217(
    name: "modelDeletePatternAnyEntityModel", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}",
    validator: validate_ModelDeletePatternAnyEntityModel_565218, base: "",
    url: url_ModelDeletePatternAnyEntityModel_565219, schemes: {Scheme.Https})
type
  Call_ModelAddExplicitListItem_565235 = ref object of OpenApiRestCall_563566
proc url_ModelAddExplicitListItem_565237(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/explicitlist")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddExplicitListItem_565236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565238 = path.getOrDefault("entityId")
  valid_565238 = validateParameter(valid_565238, JString, required = true,
                                 default = nil)
  if valid_565238 != nil:
    section.add "entityId", valid_565238
  var valid_565239 = path.getOrDefault("appId")
  valid_565239 = validateParameter(valid_565239, JString, required = true,
                                 default = nil)
  if valid_565239 != nil:
    section.add "appId", valid_565239
  var valid_565240 = path.getOrDefault("versionId")
  valid_565240 = validateParameter(valid_565240, JString, required = true,
                                 default = nil)
  if valid_565240 != nil:
    section.add "versionId", valid_565240
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   item: JObject (required)
  ##       : The new explicit list item.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565242: Call_ModelAddExplicitListItem_565235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565242.validator(path, query, header, formData, body)
  let scheme = call_565242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565242.url(scheme.get, call_565242.host, call_565242.base,
                         call_565242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565242, url, valid)

proc call*(call_565243: Call_ModelAddExplicitListItem_565235; entityId: string;
          item: JsonNode; appId: string; versionId: string): Recallable =
  ## modelAddExplicitListItem
  ##   entityId: string (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   item: JObject (required)
  ##       : The new explicit list item.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565244 = newJObject()
  var body_565245 = newJObject()
  add(path_565244, "entityId", newJString(entityId))
  if item != nil:
    body_565245 = item
  add(path_565244, "appId", newJString(appId))
  add(path_565244, "versionId", newJString(versionId))
  result = call_565243.call(path_565244, nil, nil, nil, body_565245)

var modelAddExplicitListItem* = Call_ModelAddExplicitListItem_565235(
    name: "modelAddExplicitListItem", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist",
    validator: validate_ModelAddExplicitListItem_565236, base: "",
    url: url_ModelAddExplicitListItem_565237, schemes: {Scheme.Https})
type
  Call_ModelGetExplicitList_565226 = ref object of OpenApiRestCall_563566
proc url_ModelGetExplicitList_565228(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/explicitlist")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetExplicitList_565227(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The Pattern.Any entity id.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565229 = path.getOrDefault("entityId")
  valid_565229 = validateParameter(valid_565229, JString, required = true,
                                 default = nil)
  if valid_565229 != nil:
    section.add "entityId", valid_565229
  var valid_565230 = path.getOrDefault("appId")
  valid_565230 = validateParameter(valid_565230, JString, required = true,
                                 default = nil)
  if valid_565230 != nil:
    section.add "appId", valid_565230
  var valid_565231 = path.getOrDefault("versionId")
  valid_565231 = validateParameter(valid_565231, JString, required = true,
                                 default = nil)
  if valid_565231 != nil:
    section.add "versionId", valid_565231
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565232: Call_ModelGetExplicitList_565226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565232.validator(path, query, header, formData, body)
  let scheme = call_565232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565232.url(scheme.get, call_565232.host, call_565232.base,
                         call_565232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565232, url, valid)

proc call*(call_565233: Call_ModelGetExplicitList_565226; entityId: string;
          appId: string; versionId: string): Recallable =
  ## modelGetExplicitList
  ##   entityId: string (required)
  ##           : The Pattern.Any entity id.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565234 = newJObject()
  add(path_565234, "entityId", newJString(entityId))
  add(path_565234, "appId", newJString(appId))
  add(path_565234, "versionId", newJString(versionId))
  result = call_565233.call(path_565234, nil, nil, nil, nil)

var modelGetExplicitList* = Call_ModelGetExplicitList_565226(
    name: "modelGetExplicitList", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist",
    validator: validate_ModelGetExplicitList_565227, base: "",
    url: url_ModelGetExplicitList_565228, schemes: {Scheme.Https})
type
  Call_ModelUpdateExplicitListItem_565256 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateExplicitListItem_565258(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "itemId" in path, "`itemId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/explicitlist/"),
               (kind: VariableSegment, value: "itemId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateExplicitListItem_565257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   itemId: JInt (required)
  ##         : The explicit list item ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565259 = path.getOrDefault("entityId")
  valid_565259 = validateParameter(valid_565259, JString, required = true,
                                 default = nil)
  if valid_565259 != nil:
    section.add "entityId", valid_565259
  var valid_565260 = path.getOrDefault("appId")
  valid_565260 = validateParameter(valid_565260, JString, required = true,
                                 default = nil)
  if valid_565260 != nil:
    section.add "appId", valid_565260
  var valid_565261 = path.getOrDefault("itemId")
  valid_565261 = validateParameter(valid_565261, JInt, required = true, default = nil)
  if valid_565261 != nil:
    section.add "itemId", valid_565261
  var valid_565262 = path.getOrDefault("versionId")
  valid_565262 = validateParameter(valid_565262, JString, required = true,
                                 default = nil)
  if valid_565262 != nil:
    section.add "versionId", valid_565262
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   item: JObject (required)
  ##       : The new explicit list item.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565264: Call_ModelUpdateExplicitListItem_565256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565264.validator(path, query, header, formData, body)
  let scheme = call_565264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565264.url(scheme.get, call_565264.host, call_565264.base,
                         call_565264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565264, url, valid)

proc call*(call_565265: Call_ModelUpdateExplicitListItem_565256; entityId: string;
          item: JsonNode; appId: string; itemId: int; versionId: string): Recallable =
  ## modelUpdateExplicitListItem
  ##   entityId: string (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   item: JObject (required)
  ##       : The new explicit list item.
  ##   appId: string (required)
  ##        : The application ID.
  ##   itemId: int (required)
  ##         : The explicit list item ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565266 = newJObject()
  var body_565267 = newJObject()
  add(path_565266, "entityId", newJString(entityId))
  if item != nil:
    body_565267 = item
  add(path_565266, "appId", newJString(appId))
  add(path_565266, "itemId", newJInt(itemId))
  add(path_565266, "versionId", newJString(versionId))
  result = call_565265.call(path_565266, nil, nil, nil, body_565267)

var modelUpdateExplicitListItem* = Call_ModelUpdateExplicitListItem_565256(
    name: "modelUpdateExplicitListItem", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist/{itemId}",
    validator: validate_ModelUpdateExplicitListItem_565257, base: "",
    url: url_ModelUpdateExplicitListItem_565258, schemes: {Scheme.Https})
type
  Call_ModelGetExplicitListItem_565246 = ref object of OpenApiRestCall_563566
proc url_ModelGetExplicitListItem_565248(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "itemId" in path, "`itemId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/explicitlist/"),
               (kind: VariableSegment, value: "itemId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetExplicitListItem_565247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The Pattern.Any entity Id.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   itemId: JInt (required)
  ##         : The explicit list item Id.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565249 = path.getOrDefault("entityId")
  valid_565249 = validateParameter(valid_565249, JString, required = true,
                                 default = nil)
  if valid_565249 != nil:
    section.add "entityId", valid_565249
  var valid_565250 = path.getOrDefault("appId")
  valid_565250 = validateParameter(valid_565250, JString, required = true,
                                 default = nil)
  if valid_565250 != nil:
    section.add "appId", valid_565250
  var valid_565251 = path.getOrDefault("itemId")
  valid_565251 = validateParameter(valid_565251, JInt, required = true, default = nil)
  if valid_565251 != nil:
    section.add "itemId", valid_565251
  var valid_565252 = path.getOrDefault("versionId")
  valid_565252 = validateParameter(valid_565252, JString, required = true,
                                 default = nil)
  if valid_565252 != nil:
    section.add "versionId", valid_565252
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565253: Call_ModelGetExplicitListItem_565246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565253.validator(path, query, header, formData, body)
  let scheme = call_565253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565253.url(scheme.get, call_565253.host, call_565253.base,
                         call_565253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565253, url, valid)

proc call*(call_565254: Call_ModelGetExplicitListItem_565246; entityId: string;
          appId: string; itemId: int; versionId: string): Recallable =
  ## modelGetExplicitListItem
  ##   entityId: string (required)
  ##           : The Pattern.Any entity Id.
  ##   appId: string (required)
  ##        : The application ID.
  ##   itemId: int (required)
  ##         : The explicit list item Id.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565255 = newJObject()
  add(path_565255, "entityId", newJString(entityId))
  add(path_565255, "appId", newJString(appId))
  add(path_565255, "itemId", newJInt(itemId))
  add(path_565255, "versionId", newJString(versionId))
  result = call_565254.call(path_565255, nil, nil, nil, nil)

var modelGetExplicitListItem* = Call_ModelGetExplicitListItem_565246(
    name: "modelGetExplicitListItem", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist/{itemId}",
    validator: validate_ModelGetExplicitListItem_565247, base: "",
    url: url_ModelGetExplicitListItem_565248, schemes: {Scheme.Https})
type
  Call_ModelDeleteExplicitListItem_565268 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteExplicitListItem_565270(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "itemId" in path, "`itemId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/explicitlist/"),
               (kind: VariableSegment, value: "itemId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteExplicitListItem_565269(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The pattern.any entity id.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   itemId: JInt (required)
  ##         : The explicit list item which will be deleted.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565271 = path.getOrDefault("entityId")
  valid_565271 = validateParameter(valid_565271, JString, required = true,
                                 default = nil)
  if valid_565271 != nil:
    section.add "entityId", valid_565271
  var valid_565272 = path.getOrDefault("appId")
  valid_565272 = validateParameter(valid_565272, JString, required = true,
                                 default = nil)
  if valid_565272 != nil:
    section.add "appId", valid_565272
  var valid_565273 = path.getOrDefault("itemId")
  valid_565273 = validateParameter(valid_565273, JInt, required = true, default = nil)
  if valid_565273 != nil:
    section.add "itemId", valid_565273
  var valid_565274 = path.getOrDefault("versionId")
  valid_565274 = validateParameter(valid_565274, JString, required = true,
                                 default = nil)
  if valid_565274 != nil:
    section.add "versionId", valid_565274
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565275: Call_ModelDeleteExplicitListItem_565268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565275.validator(path, query, header, formData, body)
  let scheme = call_565275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565275.url(scheme.get, call_565275.host, call_565275.base,
                         call_565275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565275, url, valid)

proc call*(call_565276: Call_ModelDeleteExplicitListItem_565268; entityId: string;
          appId: string; itemId: int; versionId: string): Recallable =
  ## modelDeleteExplicitListItem
  ##   entityId: string (required)
  ##           : The pattern.any entity id.
  ##   appId: string (required)
  ##        : The application ID.
  ##   itemId: int (required)
  ##         : The explicit list item which will be deleted.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565277 = newJObject()
  add(path_565277, "entityId", newJString(entityId))
  add(path_565277, "appId", newJString(appId))
  add(path_565277, "itemId", newJInt(itemId))
  add(path_565277, "versionId", newJString(versionId))
  result = call_565276.call(path_565277, nil, nil, nil, nil)

var modelDeleteExplicitListItem* = Call_ModelDeleteExplicitListItem_565268(
    name: "modelDeleteExplicitListItem", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist/{itemId}",
    validator: validate_ModelDeleteExplicitListItem_565269, base: "",
    url: url_ModelDeleteExplicitListItem_565270, schemes: {Scheme.Https})
type
  Call_ModelCreatePatternAnyEntityRole_565287 = ref object of OpenApiRestCall_563566
proc url_ModelCreatePatternAnyEntityRole_565289(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreatePatternAnyEntityRole_565288(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565290 = path.getOrDefault("entityId")
  valid_565290 = validateParameter(valid_565290, JString, required = true,
                                 default = nil)
  if valid_565290 != nil:
    section.add "entityId", valid_565290
  var valid_565291 = path.getOrDefault("appId")
  valid_565291 = validateParameter(valid_565291, JString, required = true,
                                 default = nil)
  if valid_565291 != nil:
    section.add "appId", valid_565291
  var valid_565292 = path.getOrDefault("versionId")
  valid_565292 = validateParameter(valid_565292, JString, required = true,
                                 default = nil)
  if valid_565292 != nil:
    section.add "versionId", valid_565292
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565294: Call_ModelCreatePatternAnyEntityRole_565287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_565294.validator(path, query, header, formData, body)
  let scheme = call_565294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565294.url(scheme.get, call_565294.host, call_565294.base,
                         call_565294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565294, url, valid)

proc call*(call_565295: Call_ModelCreatePatternAnyEntityRole_565287;
          entityId: string; entityRoleCreateObject: JsonNode; appId: string;
          versionId: string): Recallable =
  ## modelCreatePatternAnyEntityRole
  ##   entityId: string (required)
  ##           : The entity model ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565296 = newJObject()
  var body_565297 = newJObject()
  add(path_565296, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_565297 = entityRoleCreateObject
  add(path_565296, "appId", newJString(appId))
  add(path_565296, "versionId", newJString(versionId))
  result = call_565295.call(path_565296, nil, nil, nil, body_565297)

var modelCreatePatternAnyEntityRole* = Call_ModelCreatePatternAnyEntityRole_565287(
    name: "modelCreatePatternAnyEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles",
    validator: validate_ModelCreatePatternAnyEntityRole_565288, base: "",
    url: url_ModelCreatePatternAnyEntityRole_565289, schemes: {Scheme.Https})
type
  Call_ModelListPatternAnyEntityRoles_565278 = ref object of OpenApiRestCall_563566
proc url_ModelListPatternAnyEntityRoles_565280(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListPatternAnyEntityRoles_565279(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity Id
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565281 = path.getOrDefault("entityId")
  valid_565281 = validateParameter(valid_565281, JString, required = true,
                                 default = nil)
  if valid_565281 != nil:
    section.add "entityId", valid_565281
  var valid_565282 = path.getOrDefault("appId")
  valid_565282 = validateParameter(valid_565282, JString, required = true,
                                 default = nil)
  if valid_565282 != nil:
    section.add "appId", valid_565282
  var valid_565283 = path.getOrDefault("versionId")
  valid_565283 = validateParameter(valid_565283, JString, required = true,
                                 default = nil)
  if valid_565283 != nil:
    section.add "versionId", valid_565283
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565284: Call_ModelListPatternAnyEntityRoles_565278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565284.validator(path, query, header, formData, body)
  let scheme = call_565284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565284.url(scheme.get, call_565284.host, call_565284.base,
                         call_565284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565284, url, valid)

proc call*(call_565285: Call_ModelListPatternAnyEntityRoles_565278;
          entityId: string; appId: string; versionId: string): Recallable =
  ## modelListPatternAnyEntityRoles
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565286 = newJObject()
  add(path_565286, "entityId", newJString(entityId))
  add(path_565286, "appId", newJString(appId))
  add(path_565286, "versionId", newJString(versionId))
  result = call_565285.call(path_565286, nil, nil, nil, nil)

var modelListPatternAnyEntityRoles* = Call_ModelListPatternAnyEntityRoles_565278(
    name: "modelListPatternAnyEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles",
    validator: validate_ModelListPatternAnyEntityRoles_565279, base: "",
    url: url_ModelListPatternAnyEntityRoles_565280, schemes: {Scheme.Https})
type
  Call_ModelUpdatePatternAnyEntityRole_565308 = ref object of OpenApiRestCall_563566
proc url_ModelUpdatePatternAnyEntityRole_565310(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdatePatternAnyEntityRole_565309(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565311 = path.getOrDefault("entityId")
  valid_565311 = validateParameter(valid_565311, JString, required = true,
                                 default = nil)
  if valid_565311 != nil:
    section.add "entityId", valid_565311
  var valid_565312 = path.getOrDefault("appId")
  valid_565312 = validateParameter(valid_565312, JString, required = true,
                                 default = nil)
  if valid_565312 != nil:
    section.add "appId", valid_565312
  var valid_565313 = path.getOrDefault("versionId")
  valid_565313 = validateParameter(valid_565313, JString, required = true,
                                 default = nil)
  if valid_565313 != nil:
    section.add "versionId", valid_565313
  var valid_565314 = path.getOrDefault("roleId")
  valid_565314 = validateParameter(valid_565314, JString, required = true,
                                 default = nil)
  if valid_565314 != nil:
    section.add "roleId", valid_565314
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565316: Call_ModelUpdatePatternAnyEntityRole_565308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_565316.validator(path, query, header, formData, body)
  let scheme = call_565316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565316.url(scheme.get, call_565316.host, call_565316.base,
                         call_565316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565316, url, valid)

proc call*(call_565317: Call_ModelUpdatePatternAnyEntityRole_565308;
          entityId: string; entityRoleUpdateObject: JsonNode; appId: string;
          versionId: string; roleId: string): Recallable =
  ## modelUpdatePatternAnyEntityRole
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_565318 = newJObject()
  var body_565319 = newJObject()
  add(path_565318, "entityId", newJString(entityId))
  if entityRoleUpdateObject != nil:
    body_565319 = entityRoleUpdateObject
  add(path_565318, "appId", newJString(appId))
  add(path_565318, "versionId", newJString(versionId))
  add(path_565318, "roleId", newJString(roleId))
  result = call_565317.call(path_565318, nil, nil, nil, body_565319)

var modelUpdatePatternAnyEntityRole* = Call_ModelUpdatePatternAnyEntityRole_565308(
    name: "modelUpdatePatternAnyEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdatePatternAnyEntityRole_565309, base: "",
    url: url_ModelUpdatePatternAnyEntityRole_565310, schemes: {Scheme.Https})
type
  Call_ModelGetPatternAnyEntityRole_565298 = ref object of OpenApiRestCall_563566
proc url_ModelGetPatternAnyEntityRole_565300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetPatternAnyEntityRole_565299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565301 = path.getOrDefault("entityId")
  valid_565301 = validateParameter(valid_565301, JString, required = true,
                                 default = nil)
  if valid_565301 != nil:
    section.add "entityId", valid_565301
  var valid_565302 = path.getOrDefault("appId")
  valid_565302 = validateParameter(valid_565302, JString, required = true,
                                 default = nil)
  if valid_565302 != nil:
    section.add "appId", valid_565302
  var valid_565303 = path.getOrDefault("versionId")
  valid_565303 = validateParameter(valid_565303, JString, required = true,
                                 default = nil)
  if valid_565303 != nil:
    section.add "versionId", valid_565303
  var valid_565304 = path.getOrDefault("roleId")
  valid_565304 = validateParameter(valid_565304, JString, required = true,
                                 default = nil)
  if valid_565304 != nil:
    section.add "roleId", valid_565304
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565305: Call_ModelGetPatternAnyEntityRole_565298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565305.validator(path, query, header, formData, body)
  let scheme = call_565305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565305.url(scheme.get, call_565305.host, call_565305.base,
                         call_565305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565305, url, valid)

proc call*(call_565306: Call_ModelGetPatternAnyEntityRole_565298; entityId: string;
          appId: string; versionId: string; roleId: string): Recallable =
  ## modelGetPatternAnyEntityRole
  ##   entityId: string (required)
  ##           : entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_565307 = newJObject()
  add(path_565307, "entityId", newJString(entityId))
  add(path_565307, "appId", newJString(appId))
  add(path_565307, "versionId", newJString(versionId))
  add(path_565307, "roleId", newJString(roleId))
  result = call_565306.call(path_565307, nil, nil, nil, nil)

var modelGetPatternAnyEntityRole* = Call_ModelGetPatternAnyEntityRole_565298(
    name: "modelGetPatternAnyEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles/{roleId}",
    validator: validate_ModelGetPatternAnyEntityRole_565299, base: "",
    url: url_ModelGetPatternAnyEntityRole_565300, schemes: {Scheme.Https})
type
  Call_ModelDeletePatternAnyEntityRole_565320 = ref object of OpenApiRestCall_563566
proc url_ModelDeletePatternAnyEntityRole_565322(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeletePatternAnyEntityRole_565321(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565323 = path.getOrDefault("entityId")
  valid_565323 = validateParameter(valid_565323, JString, required = true,
                                 default = nil)
  if valid_565323 != nil:
    section.add "entityId", valid_565323
  var valid_565324 = path.getOrDefault("appId")
  valid_565324 = validateParameter(valid_565324, JString, required = true,
                                 default = nil)
  if valid_565324 != nil:
    section.add "appId", valid_565324
  var valid_565325 = path.getOrDefault("versionId")
  valid_565325 = validateParameter(valid_565325, JString, required = true,
                                 default = nil)
  if valid_565325 != nil:
    section.add "versionId", valid_565325
  var valid_565326 = path.getOrDefault("roleId")
  valid_565326 = validateParameter(valid_565326, JString, required = true,
                                 default = nil)
  if valid_565326 != nil:
    section.add "roleId", valid_565326
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565327: Call_ModelDeletePatternAnyEntityRole_565320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_565327.validator(path, query, header, formData, body)
  let scheme = call_565327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565327.url(scheme.get, call_565327.host, call_565327.base,
                         call_565327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565327, url, valid)

proc call*(call_565328: Call_ModelDeletePatternAnyEntityRole_565320;
          entityId: string; appId: string; versionId: string; roleId: string): Recallable =
  ## modelDeletePatternAnyEntityRole
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_565329 = newJObject()
  add(path_565329, "entityId", newJString(entityId))
  add(path_565329, "appId", newJString(appId))
  add(path_565329, "versionId", newJString(versionId))
  add(path_565329, "roleId", newJString(roleId))
  result = call_565328.call(path_565329, nil, nil, nil, nil)

var modelDeletePatternAnyEntityRole* = Call_ModelDeletePatternAnyEntityRole_565320(
    name: "modelDeletePatternAnyEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles/{roleId}",
    validator: validate_ModelDeletePatternAnyEntityRole_565321, base: "",
    url: url_ModelDeletePatternAnyEntityRole_565322, schemes: {Scheme.Https})
type
  Call_PatternAddPattern_565330 = ref object of OpenApiRestCall_563566
proc url_PatternAddPattern_565332(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrule")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternAddPattern_565331(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565333 = path.getOrDefault("appId")
  valid_565333 = validateParameter(valid_565333, JString, required = true,
                                 default = nil)
  if valid_565333 != nil:
    section.add "appId", valid_565333
  var valid_565334 = path.getOrDefault("versionId")
  valid_565334 = validateParameter(valid_565334, JString, required = true,
                                 default = nil)
  if valid_565334 != nil:
    section.add "versionId", valid_565334
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pattern: JObject (required)
  ##          : The input pattern.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565336: Call_PatternAddPattern_565330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565336.validator(path, query, header, formData, body)
  let scheme = call_565336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565336.url(scheme.get, call_565336.host, call_565336.base,
                         call_565336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565336, url, valid)

proc call*(call_565337: Call_PatternAddPattern_565330; appId: string;
          pattern: JsonNode; versionId: string): Recallable =
  ## patternAddPattern
  ##   appId: string (required)
  ##        : The application ID.
  ##   pattern: JObject (required)
  ##          : The input pattern.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565338 = newJObject()
  var body_565339 = newJObject()
  add(path_565338, "appId", newJString(appId))
  if pattern != nil:
    body_565339 = pattern
  add(path_565338, "versionId", newJString(versionId))
  result = call_565337.call(path_565338, nil, nil, nil, body_565339)

var patternAddPattern* = Call_PatternAddPattern_565330(name: "patternAddPattern",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrule",
    validator: validate_PatternAddPattern_565331, base: "",
    url: url_PatternAddPattern_565332, schemes: {Scheme.Https})
type
  Call_PatternUpdatePatterns_565351 = ref object of OpenApiRestCall_563566
proc url_PatternUpdatePatterns_565353(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternUpdatePatterns_565352(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565354 = path.getOrDefault("appId")
  valid_565354 = validateParameter(valid_565354, JString, required = true,
                                 default = nil)
  if valid_565354 != nil:
    section.add "appId", valid_565354
  var valid_565355 = path.getOrDefault("versionId")
  valid_565355 = validateParameter(valid_565355, JString, required = true,
                                 default = nil)
  if valid_565355 != nil:
    section.add "versionId", valid_565355
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patterns: JArray (required)
  ##           : An array represents the patterns.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565357: Call_PatternUpdatePatterns_565351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565357.validator(path, query, header, formData, body)
  let scheme = call_565357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565357.url(scheme.get, call_565357.host, call_565357.base,
                         call_565357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565357, url, valid)

proc call*(call_565358: Call_PatternUpdatePatterns_565351; patterns: JsonNode;
          appId: string; versionId: string): Recallable =
  ## patternUpdatePatterns
  ##   patterns: JArray (required)
  ##           : An array represents the patterns.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565359 = newJObject()
  var body_565360 = newJObject()
  if patterns != nil:
    body_565360 = patterns
  add(path_565359, "appId", newJString(appId))
  add(path_565359, "versionId", newJString(versionId))
  result = call_565358.call(path_565359, nil, nil, nil, body_565360)

var patternUpdatePatterns* = Call_PatternUpdatePatterns_565351(
    name: "patternUpdatePatterns", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules",
    validator: validate_PatternUpdatePatterns_565352, base: "",
    url: url_PatternUpdatePatterns_565353, schemes: {Scheme.Https})
type
  Call_PatternBatchAddPatterns_565361 = ref object of OpenApiRestCall_563566
proc url_PatternBatchAddPatterns_565363(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternBatchAddPatterns_565362(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565364 = path.getOrDefault("appId")
  valid_565364 = validateParameter(valid_565364, JString, required = true,
                                 default = nil)
  if valid_565364 != nil:
    section.add "appId", valid_565364
  var valid_565365 = path.getOrDefault("versionId")
  valid_565365 = validateParameter(valid_565365, JString, required = true,
                                 default = nil)
  if valid_565365 != nil:
    section.add "versionId", valid_565365
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patterns: JArray (required)
  ##           : A JSON array containing patterns.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565367: Call_PatternBatchAddPatterns_565361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565367.validator(path, query, header, formData, body)
  let scheme = call_565367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565367.url(scheme.get, call_565367.host, call_565367.base,
                         call_565367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565367, url, valid)

proc call*(call_565368: Call_PatternBatchAddPatterns_565361; patterns: JsonNode;
          appId: string; versionId: string): Recallable =
  ## patternBatchAddPatterns
  ##   patterns: JArray (required)
  ##           : A JSON array containing patterns.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565369 = newJObject()
  var body_565370 = newJObject()
  if patterns != nil:
    body_565370 = patterns
  add(path_565369, "appId", newJString(appId))
  add(path_565369, "versionId", newJString(versionId))
  result = call_565368.call(path_565369, nil, nil, nil, body_565370)

var patternBatchAddPatterns* = Call_PatternBatchAddPatterns_565361(
    name: "patternBatchAddPatterns", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules",
    validator: validate_PatternBatchAddPatterns_565362, base: "",
    url: url_PatternBatchAddPatterns_565363, schemes: {Scheme.Https})
type
  Call_PatternListPatterns_565340 = ref object of OpenApiRestCall_563566
proc url_PatternListPatterns_565342(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternListPatterns_565341(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565343 = path.getOrDefault("appId")
  valid_565343 = validateParameter(valid_565343, JString, required = true,
                                 default = nil)
  if valid_565343 != nil:
    section.add "appId", valid_565343
  var valid_565344 = path.getOrDefault("versionId")
  valid_565344 = validateParameter(valid_565344, JString, required = true,
                                 default = nil)
  if valid_565344 != nil:
    section.add "versionId", valid_565344
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_565345 = query.getOrDefault("take")
  valid_565345 = validateParameter(valid_565345, JInt, required = false,
                                 default = newJInt(100))
  if valid_565345 != nil:
    section.add "take", valid_565345
  var valid_565346 = query.getOrDefault("skip")
  valid_565346 = validateParameter(valid_565346, JInt, required = false,
                                 default = newJInt(0))
  if valid_565346 != nil:
    section.add "skip", valid_565346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565347: Call_PatternListPatterns_565340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565347.validator(path, query, header, formData, body)
  let scheme = call_565347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565347.url(scheme.get, call_565347.host, call_565347.base,
                         call_565347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565347, url, valid)

proc call*(call_565348: Call_PatternListPatterns_565340; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## patternListPatterns
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565349 = newJObject()
  var query_565350 = newJObject()
  add(query_565350, "take", newJInt(take))
  add(query_565350, "skip", newJInt(skip))
  add(path_565349, "appId", newJString(appId))
  add(path_565349, "versionId", newJString(versionId))
  result = call_565348.call(path_565349, query_565350, nil, nil, nil)

var patternListPatterns* = Call_PatternListPatterns_565340(
    name: "patternListPatterns", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules",
    validator: validate_PatternListPatterns_565341, base: "",
    url: url_PatternListPatterns_565342, schemes: {Scheme.Https})
type
  Call_PatternDeletePatterns_565371 = ref object of OpenApiRestCall_563566
proc url_PatternDeletePatterns_565373(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternDeletePatterns_565372(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565374 = path.getOrDefault("appId")
  valid_565374 = validateParameter(valid_565374, JString, required = true,
                                 default = nil)
  if valid_565374 != nil:
    section.add "appId", valid_565374
  var valid_565375 = path.getOrDefault("versionId")
  valid_565375 = validateParameter(valid_565375, JString, required = true,
                                 default = nil)
  if valid_565375 != nil:
    section.add "versionId", valid_565375
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patternIds: JArray (required)
  ##             : The patterns IDs.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565377: Call_PatternDeletePatterns_565371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565377.validator(path, query, header, formData, body)
  let scheme = call_565377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565377.url(scheme.get, call_565377.host, call_565377.base,
                         call_565377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565377, url, valid)

proc call*(call_565378: Call_PatternDeletePatterns_565371; appId: string;
          patternIds: JsonNode; versionId: string): Recallable =
  ## patternDeletePatterns
  ##   appId: string (required)
  ##        : The application ID.
  ##   patternIds: JArray (required)
  ##             : The patterns IDs.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565379 = newJObject()
  var body_565380 = newJObject()
  add(path_565379, "appId", newJString(appId))
  if patternIds != nil:
    body_565380 = patternIds
  add(path_565379, "versionId", newJString(versionId))
  result = call_565378.call(path_565379, nil, nil, nil, body_565380)

var patternDeletePatterns* = Call_PatternDeletePatterns_565371(
    name: "patternDeletePatterns", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules",
    validator: validate_PatternDeletePatterns_565372, base: "",
    url: url_PatternDeletePatterns_565373, schemes: {Scheme.Https})
type
  Call_PatternUpdatePattern_565381 = ref object of OpenApiRestCall_563566
proc url_PatternUpdatePattern_565383(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "patternId" in path, "`patternId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrules/"),
               (kind: VariableSegment, value: "patternId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternUpdatePattern_565382(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JString (required)
  ##            : The pattern ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565384 = path.getOrDefault("appId")
  valid_565384 = validateParameter(valid_565384, JString, required = true,
                                 default = nil)
  if valid_565384 != nil:
    section.add "appId", valid_565384
  var valid_565385 = path.getOrDefault("versionId")
  valid_565385 = validateParameter(valid_565385, JString, required = true,
                                 default = nil)
  if valid_565385 != nil:
    section.add "versionId", valid_565385
  var valid_565386 = path.getOrDefault("patternId")
  valid_565386 = validateParameter(valid_565386, JString, required = true,
                                 default = nil)
  if valid_565386 != nil:
    section.add "patternId", valid_565386
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pattern: JObject (required)
  ##          : An object representing a pattern.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565388: Call_PatternUpdatePattern_565381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565388.validator(path, query, header, formData, body)
  let scheme = call_565388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565388.url(scheme.get, call_565388.host, call_565388.base,
                         call_565388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565388, url, valid)

proc call*(call_565389: Call_PatternUpdatePattern_565381; appId: string;
          pattern: JsonNode; versionId: string; patternId: string): Recallable =
  ## patternUpdatePattern
  ##   appId: string (required)
  ##        : The application ID.
  ##   pattern: JObject (required)
  ##          : An object representing a pattern.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: string (required)
  ##            : The pattern ID.
  var path_565390 = newJObject()
  var body_565391 = newJObject()
  add(path_565390, "appId", newJString(appId))
  if pattern != nil:
    body_565391 = pattern
  add(path_565390, "versionId", newJString(versionId))
  add(path_565390, "patternId", newJString(patternId))
  result = call_565389.call(path_565390, nil, nil, nil, body_565391)

var patternUpdatePattern* = Call_PatternUpdatePattern_565381(
    name: "patternUpdatePattern", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules/{patternId}",
    validator: validate_PatternUpdatePattern_565382, base: "",
    url: url_PatternUpdatePattern_565383, schemes: {Scheme.Https})
type
  Call_PatternDeletePattern_565392 = ref object of OpenApiRestCall_563566
proc url_PatternDeletePattern_565394(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "patternId" in path, "`patternId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrules/"),
               (kind: VariableSegment, value: "patternId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternDeletePattern_565393(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JString (required)
  ##            : The pattern ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565395 = path.getOrDefault("appId")
  valid_565395 = validateParameter(valid_565395, JString, required = true,
                                 default = nil)
  if valid_565395 != nil:
    section.add "appId", valid_565395
  var valid_565396 = path.getOrDefault("versionId")
  valid_565396 = validateParameter(valid_565396, JString, required = true,
                                 default = nil)
  if valid_565396 != nil:
    section.add "versionId", valid_565396
  var valid_565397 = path.getOrDefault("patternId")
  valid_565397 = validateParameter(valid_565397, JString, required = true,
                                 default = nil)
  if valid_565397 != nil:
    section.add "patternId", valid_565397
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565398: Call_PatternDeletePattern_565392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565398.validator(path, query, header, formData, body)
  let scheme = call_565398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565398.url(scheme.get, call_565398.host, call_565398.base,
                         call_565398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565398, url, valid)

proc call*(call_565399: Call_PatternDeletePattern_565392; appId: string;
          versionId: string; patternId: string): Recallable =
  ## patternDeletePattern
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: string (required)
  ##            : The pattern ID.
  var path_565400 = newJObject()
  add(path_565400, "appId", newJString(appId))
  add(path_565400, "versionId", newJString(versionId))
  add(path_565400, "patternId", newJString(patternId))
  result = call_565399.call(path_565400, nil, nil, nil, nil)

var patternDeletePattern* = Call_PatternDeletePattern_565392(
    name: "patternDeletePattern", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules/{patternId}",
    validator: validate_PatternDeletePattern_565393, base: "",
    url: url_PatternDeletePattern_565394, schemes: {Scheme.Https})
type
  Call_FeaturesCreatePatternFeature_565412 = ref object of OpenApiRestCall_563566
proc url_FeaturesCreatePatternFeature_565414(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patterns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesCreatePatternFeature_565413(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565415 = path.getOrDefault("appId")
  valid_565415 = validateParameter(valid_565415, JString, required = true,
                                 default = nil)
  if valid_565415 != nil:
    section.add "appId", valid_565415
  var valid_565416 = path.getOrDefault("versionId")
  valid_565416 = validateParameter(valid_565416, JString, required = true,
                                 default = nil)
  if valid_565416 != nil:
    section.add "versionId", valid_565416
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patternCreateObject: JObject (required)
  ##                      : The Name and Pattern of the feature.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565418: Call_FeaturesCreatePatternFeature_565412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature in a version of the application.
  ## 
  let valid = call_565418.validator(path, query, header, formData, body)
  let scheme = call_565418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565418.url(scheme.get, call_565418.host, call_565418.base,
                         call_565418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565418, url, valid)

proc call*(call_565419: Call_FeaturesCreatePatternFeature_565412; appId: string;
          versionId: string; patternCreateObject: JsonNode): Recallable =
  ## featuresCreatePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature in a version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternCreateObject: JObject (required)
  ##                      : The Name and Pattern of the feature.
  var path_565420 = newJObject()
  var body_565421 = newJObject()
  add(path_565420, "appId", newJString(appId))
  add(path_565420, "versionId", newJString(versionId))
  if patternCreateObject != nil:
    body_565421 = patternCreateObject
  result = call_565419.call(path_565420, nil, nil, nil, body_565421)

var featuresCreatePatternFeature* = Call_FeaturesCreatePatternFeature_565412(
    name: "featuresCreatePatternFeature", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patterns",
    validator: validate_FeaturesCreatePatternFeature_565413, base: "",
    url: url_FeaturesCreatePatternFeature_565414, schemes: {Scheme.Https})
type
  Call_FeaturesListApplicationVersionPatternFeatures_565401 = ref object of OpenApiRestCall_563566
proc url_FeaturesListApplicationVersionPatternFeatures_565403(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patterns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesListApplicationVersionPatternFeatures_565402(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565404 = path.getOrDefault("appId")
  valid_565404 = validateParameter(valid_565404, JString, required = true,
                                 default = nil)
  if valid_565404 != nil:
    section.add "appId", valid_565404
  var valid_565405 = path.getOrDefault("versionId")
  valid_565405 = validateParameter(valid_565405, JString, required = true,
                                 default = nil)
  if valid_565405 != nil:
    section.add "versionId", valid_565405
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_565406 = query.getOrDefault("take")
  valid_565406 = validateParameter(valid_565406, JInt, required = false,
                                 default = newJInt(100))
  if valid_565406 != nil:
    section.add "take", valid_565406
  var valid_565407 = query.getOrDefault("skip")
  valid_565407 = validateParameter(valid_565407, JInt, required = false,
                                 default = newJInt(0))
  if valid_565407 != nil:
    section.add "skip", valid_565407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565408: Call_FeaturesListApplicationVersionPatternFeatures_565401;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ## 
  let valid = call_565408.validator(path, query, header, formData, body)
  let scheme = call_565408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565408.url(scheme.get, call_565408.host, call_565408.base,
                         call_565408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565408, url, valid)

proc call*(call_565409: Call_FeaturesListApplicationVersionPatternFeatures_565401;
          appId: string; versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## featuresListApplicationVersionPatternFeatures
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565410 = newJObject()
  var query_565411 = newJObject()
  add(query_565411, "take", newJInt(take))
  add(query_565411, "skip", newJInt(skip))
  add(path_565410, "appId", newJString(appId))
  add(path_565410, "versionId", newJString(versionId))
  result = call_565409.call(path_565410, query_565411, nil, nil, nil)

var featuresListApplicationVersionPatternFeatures* = Call_FeaturesListApplicationVersionPatternFeatures_565401(
    name: "featuresListApplicationVersionPatternFeatures",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns",
    validator: validate_FeaturesListApplicationVersionPatternFeatures_565402,
    base: "", url: url_FeaturesListApplicationVersionPatternFeatures_565403,
    schemes: {Scheme.Https})
type
  Call_FeaturesUpdatePatternFeature_565431 = ref object of OpenApiRestCall_563566
proc url_FeaturesUpdatePatternFeature_565433(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "patternId" in path, "`patternId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patterns/"),
               (kind: VariableSegment, value: "patternId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesUpdatePatternFeature_565432(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JInt (required)
  ##            : The pattern feature ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565434 = path.getOrDefault("appId")
  valid_565434 = validateParameter(valid_565434, JString, required = true,
                                 default = nil)
  if valid_565434 != nil:
    section.add "appId", valid_565434
  var valid_565435 = path.getOrDefault("versionId")
  valid_565435 = validateParameter(valid_565435, JString, required = true,
                                 default = nil)
  if valid_565435 != nil:
    section.add "versionId", valid_565435
  var valid_565436 = path.getOrDefault("patternId")
  valid_565436 = validateParameter(valid_565436, JInt, required = true, default = nil)
  if valid_565436 != nil:
    section.add "patternId", valid_565436
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patternUpdateObject: JObject (required)
  ##                      : The new values for: - Just a boolean called IsActive, in which case the status of the feature will be changed. - Name, Pattern and a boolean called IsActive to update the feature.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565438: Call_FeaturesUpdatePatternFeature_565431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature in a version of the application.
  ## 
  let valid = call_565438.validator(path, query, header, formData, body)
  let scheme = call_565438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565438.url(scheme.get, call_565438.host, call_565438.base,
                         call_565438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565438, url, valid)

proc call*(call_565439: Call_FeaturesUpdatePatternFeature_565431;
          patternUpdateObject: JsonNode; appId: string; versionId: string;
          patternId: int): Recallable =
  ## featuresUpdatePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature in a version of the application.
  ##   patternUpdateObject: JObject (required)
  ##                      : The new values for: - Just a boolean called IsActive, in which case the status of the feature will be changed. - Name, Pattern and a boolean called IsActive to update the feature.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  var path_565440 = newJObject()
  var body_565441 = newJObject()
  if patternUpdateObject != nil:
    body_565441 = patternUpdateObject
  add(path_565440, "appId", newJString(appId))
  add(path_565440, "versionId", newJString(versionId))
  add(path_565440, "patternId", newJInt(patternId))
  result = call_565439.call(path_565440, nil, nil, nil, body_565441)

var featuresUpdatePatternFeature* = Call_FeaturesUpdatePatternFeature_565431(
    name: "featuresUpdatePatternFeature", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesUpdatePatternFeature_565432, base: "",
    url: url_FeaturesUpdatePatternFeature_565433, schemes: {Scheme.Https})
type
  Call_FeaturesGetPatternFeatureInfo_565422 = ref object of OpenApiRestCall_563566
proc url_FeaturesGetPatternFeatureInfo_565424(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "patternId" in path, "`patternId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patterns/"),
               (kind: VariableSegment, value: "patternId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesGetPatternFeatureInfo_565423(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JInt (required)
  ##            : The pattern feature ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565425 = path.getOrDefault("appId")
  valid_565425 = validateParameter(valid_565425, JString, required = true,
                                 default = nil)
  if valid_565425 != nil:
    section.add "appId", valid_565425
  var valid_565426 = path.getOrDefault("versionId")
  valid_565426 = validateParameter(valid_565426, JString, required = true,
                                 default = nil)
  if valid_565426 != nil:
    section.add "versionId", valid_565426
  var valid_565427 = path.getOrDefault("patternId")
  valid_565427 = validateParameter(valid_565427, JInt, required = true, default = nil)
  if valid_565427 != nil:
    section.add "patternId", valid_565427
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565428: Call_FeaturesGetPatternFeatureInfo_565422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info in a version of the application.
  ## 
  let valid = call_565428.validator(path, query, header, formData, body)
  let scheme = call_565428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565428.url(scheme.get, call_565428.host, call_565428.base,
                         call_565428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565428, url, valid)

proc call*(call_565429: Call_FeaturesGetPatternFeatureInfo_565422; appId: string;
          versionId: string; patternId: int): Recallable =
  ## featuresGetPatternFeatureInfo
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info in a version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  var path_565430 = newJObject()
  add(path_565430, "appId", newJString(appId))
  add(path_565430, "versionId", newJString(versionId))
  add(path_565430, "patternId", newJInt(patternId))
  result = call_565429.call(path_565430, nil, nil, nil, nil)

var featuresGetPatternFeatureInfo* = Call_FeaturesGetPatternFeatureInfo_565422(
    name: "featuresGetPatternFeatureInfo", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesGetPatternFeatureInfo_565423, base: "",
    url: url_FeaturesGetPatternFeatureInfo_565424, schemes: {Scheme.Https})
type
  Call_FeaturesDeletePatternFeature_565442 = ref object of OpenApiRestCall_563566
proc url_FeaturesDeletePatternFeature_565444(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "patternId" in path, "`patternId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patterns/"),
               (kind: VariableSegment, value: "patternId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesDeletePatternFeature_565443(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JInt (required)
  ##            : The pattern feature ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565445 = path.getOrDefault("appId")
  valid_565445 = validateParameter(valid_565445, JString, required = true,
                                 default = nil)
  if valid_565445 != nil:
    section.add "appId", valid_565445
  var valid_565446 = path.getOrDefault("versionId")
  valid_565446 = validateParameter(valid_565446, JString, required = true,
                                 default = nil)
  if valid_565446 != nil:
    section.add "versionId", valid_565446
  var valid_565447 = path.getOrDefault("patternId")
  valid_565447 = validateParameter(valid_565447, JInt, required = true, default = nil)
  if valid_565447 != nil:
    section.add "patternId", valid_565447
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565448: Call_FeaturesDeletePatternFeature_565442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature in a version of the application.
  ## 
  let valid = call_565448.validator(path, query, header, formData, body)
  let scheme = call_565448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565448.url(scheme.get, call_565448.host, call_565448.base,
                         call_565448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565448, url, valid)

proc call*(call_565449: Call_FeaturesDeletePatternFeature_565442; appId: string;
          versionId: string; patternId: int): Recallable =
  ## featuresDeletePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature in a version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  var path_565450 = newJObject()
  add(path_565450, "appId", newJString(appId))
  add(path_565450, "versionId", newJString(versionId))
  add(path_565450, "patternId", newJInt(patternId))
  result = call_565449.call(path_565450, nil, nil, nil, nil)

var featuresDeletePatternFeature* = Call_FeaturesDeletePatternFeature_565442(
    name: "featuresDeletePatternFeature", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesDeletePatternFeature_565443, base: "",
    url: url_FeaturesDeletePatternFeature_565444, schemes: {Scheme.Https})
type
  Call_FeaturesAddPhraseList_565462 = ref object of OpenApiRestCall_563566
proc url_FeaturesAddPhraseList_565464(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/phraselists")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesAddPhraseList_565463(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new phraselist feature in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565465 = path.getOrDefault("appId")
  valid_565465 = validateParameter(valid_565465, JString, required = true,
                                 default = nil)
  if valid_565465 != nil:
    section.add "appId", valid_565465
  var valid_565466 = path.getOrDefault("versionId")
  valid_565466 = validateParameter(valid_565466, JString, required = true,
                                 default = nil)
  if valid_565466 != nil:
    section.add "versionId", valid_565466
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   phraselistCreateObject: JObject (required)
  ##                         : A Phraselist object containing Name, comma-separated Phrases and the isExchangeable boolean. Default value for isExchangeable is true.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565468: Call_FeaturesAddPhraseList_565462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new phraselist feature in a version of the application.
  ## 
  let valid = call_565468.validator(path, query, header, formData, body)
  let scheme = call_565468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565468.url(scheme.get, call_565468.host, call_565468.base,
                         call_565468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565468, url, valid)

proc call*(call_565469: Call_FeaturesAddPhraseList_565462;
          phraselistCreateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## featuresAddPhraseList
  ## Creates a new phraselist feature in a version of the application.
  ##   phraselistCreateObject: JObject (required)
  ##                         : A Phraselist object containing Name, comma-separated Phrases and the isExchangeable boolean. Default value for isExchangeable is true.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565470 = newJObject()
  var body_565471 = newJObject()
  if phraselistCreateObject != nil:
    body_565471 = phraselistCreateObject
  add(path_565470, "appId", newJString(appId))
  add(path_565470, "versionId", newJString(versionId))
  result = call_565469.call(path_565470, nil, nil, nil, body_565471)

var featuresAddPhraseList* = Call_FeaturesAddPhraseList_565462(
    name: "featuresAddPhraseList", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists",
    validator: validate_FeaturesAddPhraseList_565463, base: "",
    url: url_FeaturesAddPhraseList_565464, schemes: {Scheme.Https})
type
  Call_FeaturesListPhraseLists_565451 = ref object of OpenApiRestCall_563566
proc url_FeaturesListPhraseLists_565453(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/phraselists")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesListPhraseLists_565452(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the phraselist features in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565454 = path.getOrDefault("appId")
  valid_565454 = validateParameter(valid_565454, JString, required = true,
                                 default = nil)
  if valid_565454 != nil:
    section.add "appId", valid_565454
  var valid_565455 = path.getOrDefault("versionId")
  valid_565455 = validateParameter(valid_565455, JString, required = true,
                                 default = nil)
  if valid_565455 != nil:
    section.add "versionId", valid_565455
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_565456 = query.getOrDefault("take")
  valid_565456 = validateParameter(valid_565456, JInt, required = false,
                                 default = newJInt(100))
  if valid_565456 != nil:
    section.add "take", valid_565456
  var valid_565457 = query.getOrDefault("skip")
  valid_565457 = validateParameter(valid_565457, JInt, required = false,
                                 default = newJInt(0))
  if valid_565457 != nil:
    section.add "skip", valid_565457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565458: Call_FeaturesListPhraseLists_565451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the phraselist features in a version of the application.
  ## 
  let valid = call_565458.validator(path, query, header, formData, body)
  let scheme = call_565458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565458.url(scheme.get, call_565458.host, call_565458.base,
                         call_565458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565458, url, valid)

proc call*(call_565459: Call_FeaturesListPhraseLists_565451; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## featuresListPhraseLists
  ## Gets all the phraselist features in a version of the application.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565460 = newJObject()
  var query_565461 = newJObject()
  add(query_565461, "take", newJInt(take))
  add(query_565461, "skip", newJInt(skip))
  add(path_565460, "appId", newJString(appId))
  add(path_565460, "versionId", newJString(versionId))
  result = call_565459.call(path_565460, query_565461, nil, nil, nil)

var featuresListPhraseLists* = Call_FeaturesListPhraseLists_565451(
    name: "featuresListPhraseLists", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists",
    validator: validate_FeaturesListPhraseLists_565452, base: "",
    url: url_FeaturesListPhraseLists_565453, schemes: {Scheme.Https})
type
  Call_FeaturesUpdatePhraseList_565481 = ref object of OpenApiRestCall_563566
proc url_FeaturesUpdatePhraseList_565483(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "phraselistId" in path, "`phraselistId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/phraselists/"),
               (kind: VariableSegment, value: "phraselistId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesUpdatePhraseList_565482(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the phrases, the state and the name of the phraselist feature in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   phraselistId: JInt (required)
  ##               : The ID of the feature to be updated.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `phraselistId` field"
  var valid_565484 = path.getOrDefault("phraselistId")
  valid_565484 = validateParameter(valid_565484, JInt, required = true, default = nil)
  if valid_565484 != nil:
    section.add "phraselistId", valid_565484
  var valid_565485 = path.getOrDefault("appId")
  valid_565485 = validateParameter(valid_565485, JString, required = true,
                                 default = nil)
  if valid_565485 != nil:
    section.add "appId", valid_565485
  var valid_565486 = path.getOrDefault("versionId")
  valid_565486 = validateParameter(valid_565486, JString, required = true,
                                 default = nil)
  if valid_565486 != nil:
    section.add "versionId", valid_565486
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   phraselistUpdateObject: JObject
  ##                         : The new values for: - Just a boolean called IsActive, in which case the status of the feature will be changed. - Name, Pattern, Mode, and a boolean called IsActive to update the feature.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565488: Call_FeaturesUpdatePhraseList_565481; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the phrases, the state and the name of the phraselist feature in a version of the application.
  ## 
  let valid = call_565488.validator(path, query, header, formData, body)
  let scheme = call_565488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565488.url(scheme.get, call_565488.host, call_565488.base,
                         call_565488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565488, url, valid)

proc call*(call_565489: Call_FeaturesUpdatePhraseList_565481; phraselistId: int;
          appId: string; versionId: string; phraselistUpdateObject: JsonNode = nil): Recallable =
  ## featuresUpdatePhraseList
  ## Updates the phrases, the state and the name of the phraselist feature in a version of the application.
  ##   phraselistUpdateObject: JObject
  ##                         : The new values for: - Just a boolean called IsActive, in which case the status of the feature will be changed. - Name, Pattern, Mode, and a boolean called IsActive to update the feature.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be updated.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565490 = newJObject()
  var body_565491 = newJObject()
  if phraselistUpdateObject != nil:
    body_565491 = phraselistUpdateObject
  add(path_565490, "phraselistId", newJInt(phraselistId))
  add(path_565490, "appId", newJString(appId))
  add(path_565490, "versionId", newJString(versionId))
  result = call_565489.call(path_565490, nil, nil, nil, body_565491)

var featuresUpdatePhraseList* = Call_FeaturesUpdatePhraseList_565481(
    name: "featuresUpdatePhraseList", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesUpdatePhraseList_565482, base: "",
    url: url_FeaturesUpdatePhraseList_565483, schemes: {Scheme.Https})
type
  Call_FeaturesGetPhraseList_565472 = ref object of OpenApiRestCall_563566
proc url_FeaturesGetPhraseList_565474(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "phraselistId" in path, "`phraselistId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/phraselists/"),
               (kind: VariableSegment, value: "phraselistId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesGetPhraseList_565473(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets phraselist feature info in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   phraselistId: JInt (required)
  ##               : The ID of the feature to be retrieved.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `phraselistId` field"
  var valid_565475 = path.getOrDefault("phraselistId")
  valid_565475 = validateParameter(valid_565475, JInt, required = true, default = nil)
  if valid_565475 != nil:
    section.add "phraselistId", valid_565475
  var valid_565476 = path.getOrDefault("appId")
  valid_565476 = validateParameter(valid_565476, JString, required = true,
                                 default = nil)
  if valid_565476 != nil:
    section.add "appId", valid_565476
  var valid_565477 = path.getOrDefault("versionId")
  valid_565477 = validateParameter(valid_565477, JString, required = true,
                                 default = nil)
  if valid_565477 != nil:
    section.add "versionId", valid_565477
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565478: Call_FeaturesGetPhraseList_565472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets phraselist feature info in a version of the application.
  ## 
  let valid = call_565478.validator(path, query, header, formData, body)
  let scheme = call_565478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565478.url(scheme.get, call_565478.host, call_565478.base,
                         call_565478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565478, url, valid)

proc call*(call_565479: Call_FeaturesGetPhraseList_565472; phraselistId: int;
          appId: string; versionId: string): Recallable =
  ## featuresGetPhraseList
  ## Gets phraselist feature info in a version of the application.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be retrieved.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565480 = newJObject()
  add(path_565480, "phraselistId", newJInt(phraselistId))
  add(path_565480, "appId", newJString(appId))
  add(path_565480, "versionId", newJString(versionId))
  result = call_565479.call(path_565480, nil, nil, nil, nil)

var featuresGetPhraseList* = Call_FeaturesGetPhraseList_565472(
    name: "featuresGetPhraseList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesGetPhraseList_565473, base: "",
    url: url_FeaturesGetPhraseList_565474, schemes: {Scheme.Https})
type
  Call_FeaturesDeletePhraseList_565492 = ref object of OpenApiRestCall_563566
proc url_FeaturesDeletePhraseList_565494(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "phraselistId" in path, "`phraselistId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/phraselists/"),
               (kind: VariableSegment, value: "phraselistId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesDeletePhraseList_565493(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a phraselist feature from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   phraselistId: JInt (required)
  ##               : The ID of the feature to be deleted.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `phraselistId` field"
  var valid_565495 = path.getOrDefault("phraselistId")
  valid_565495 = validateParameter(valid_565495, JInt, required = true, default = nil)
  if valid_565495 != nil:
    section.add "phraselistId", valid_565495
  var valid_565496 = path.getOrDefault("appId")
  valid_565496 = validateParameter(valid_565496, JString, required = true,
                                 default = nil)
  if valid_565496 != nil:
    section.add "appId", valid_565496
  var valid_565497 = path.getOrDefault("versionId")
  valid_565497 = validateParameter(valid_565497, JString, required = true,
                                 default = nil)
  if valid_565497 != nil:
    section.add "versionId", valid_565497
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565498: Call_FeaturesDeletePhraseList_565492; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a phraselist feature from a version of the application.
  ## 
  let valid = call_565498.validator(path, query, header, formData, body)
  let scheme = call_565498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565498.url(scheme.get, call_565498.host, call_565498.base,
                         call_565498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565498, url, valid)

proc call*(call_565499: Call_FeaturesDeletePhraseList_565492; phraselistId: int;
          appId: string; versionId: string): Recallable =
  ## featuresDeletePhraseList
  ## Deletes a phraselist feature from a version of the application.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be deleted.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565500 = newJObject()
  add(path_565500, "phraselistId", newJInt(phraselistId))
  add(path_565500, "appId", newJString(appId))
  add(path_565500, "versionId", newJString(versionId))
  result = call_565499.call(path_565500, nil, nil, nil, nil)

var featuresDeletePhraseList* = Call_FeaturesDeletePhraseList_565492(
    name: "featuresDeletePhraseList", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesDeletePhraseList_565493, base: "",
    url: url_FeaturesDeletePhraseList_565494, schemes: {Scheme.Https})
type
  Call_ModelAddPrebuilt_565512 = ref object of OpenApiRestCall_563566
proc url_ModelAddPrebuilt_565514(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddPrebuilt_565513(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Adds a list of prebuilt entities to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565515 = path.getOrDefault("appId")
  valid_565515 = validateParameter(valid_565515, JString, required = true,
                                 default = nil)
  if valid_565515 != nil:
    section.add "appId", valid_565515
  var valid_565516 = path.getOrDefault("versionId")
  valid_565516 = validateParameter(valid_565516, JString, required = true,
                                 default = nil)
  if valid_565516 != nil:
    section.add "versionId", valid_565516
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   prebuiltExtractorNames: JArray (required)
  ##                         : An array of prebuilt entity extractor names.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565518: Call_ModelAddPrebuilt_565512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a list of prebuilt entities to a version of the application.
  ## 
  let valid = call_565518.validator(path, query, header, formData, body)
  let scheme = call_565518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565518.url(scheme.get, call_565518.host, call_565518.base,
                         call_565518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565518, url, valid)

proc call*(call_565519: Call_ModelAddPrebuilt_565512;
          prebuiltExtractorNames: JsonNode; appId: string; versionId: string): Recallable =
  ## modelAddPrebuilt
  ## Adds a list of prebuilt entities to a version of the application.
  ##   prebuiltExtractorNames: JArray (required)
  ##                         : An array of prebuilt entity extractor names.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565520 = newJObject()
  var body_565521 = newJObject()
  if prebuiltExtractorNames != nil:
    body_565521 = prebuiltExtractorNames
  add(path_565520, "appId", newJString(appId))
  add(path_565520, "versionId", newJString(versionId))
  result = call_565519.call(path_565520, nil, nil, nil, body_565521)

var modelAddPrebuilt* = Call_ModelAddPrebuilt_565512(name: "modelAddPrebuilt",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts",
    validator: validate_ModelAddPrebuilt_565513, base: "",
    url: url_ModelAddPrebuilt_565514, schemes: {Scheme.Https})
type
  Call_ModelListPrebuilts_565501 = ref object of OpenApiRestCall_563566
proc url_ModelListPrebuilts_565503(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListPrebuilts_565502(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets information about all the prebuilt entities in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565504 = path.getOrDefault("appId")
  valid_565504 = validateParameter(valid_565504, JString, required = true,
                                 default = nil)
  if valid_565504 != nil:
    section.add "appId", valid_565504
  var valid_565505 = path.getOrDefault("versionId")
  valid_565505 = validateParameter(valid_565505, JString, required = true,
                                 default = nil)
  if valid_565505 != nil:
    section.add "versionId", valid_565505
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_565506 = query.getOrDefault("take")
  valid_565506 = validateParameter(valid_565506, JInt, required = false,
                                 default = newJInt(100))
  if valid_565506 != nil:
    section.add "take", valid_565506
  var valid_565507 = query.getOrDefault("skip")
  valid_565507 = validateParameter(valid_565507, JInt, required = false,
                                 default = newJInt(0))
  if valid_565507 != nil:
    section.add "skip", valid_565507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565508: Call_ModelListPrebuilts_565501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the prebuilt entities in a version of the application.
  ## 
  let valid = call_565508.validator(path, query, header, formData, body)
  let scheme = call_565508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565508.url(scheme.get, call_565508.host, call_565508.base,
                         call_565508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565508, url, valid)

proc call*(call_565509: Call_ModelListPrebuilts_565501; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListPrebuilts
  ## Gets information about all the prebuilt entities in a version of the application.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565510 = newJObject()
  var query_565511 = newJObject()
  add(query_565511, "take", newJInt(take))
  add(query_565511, "skip", newJInt(skip))
  add(path_565510, "appId", newJString(appId))
  add(path_565510, "versionId", newJString(versionId))
  result = call_565509.call(path_565510, query_565511, nil, nil, nil)

var modelListPrebuilts* = Call_ModelListPrebuilts_565501(
    name: "modelListPrebuilts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts",
    validator: validate_ModelListPrebuilts_565502, base: "",
    url: url_ModelListPrebuilts_565503, schemes: {Scheme.Https})
type
  Call_ModelCreatePrebuiltEntityRole_565531 = ref object of OpenApiRestCall_563566
proc url_ModelCreatePrebuiltEntityRole_565533(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreatePrebuiltEntityRole_565532(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565534 = path.getOrDefault("entityId")
  valid_565534 = validateParameter(valid_565534, JString, required = true,
                                 default = nil)
  if valid_565534 != nil:
    section.add "entityId", valid_565534
  var valid_565535 = path.getOrDefault("appId")
  valid_565535 = validateParameter(valid_565535, JString, required = true,
                                 default = nil)
  if valid_565535 != nil:
    section.add "appId", valid_565535
  var valid_565536 = path.getOrDefault("versionId")
  valid_565536 = validateParameter(valid_565536, JString, required = true,
                                 default = nil)
  if valid_565536 != nil:
    section.add "versionId", valid_565536
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565538: Call_ModelCreatePrebuiltEntityRole_565531; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565538.validator(path, query, header, formData, body)
  let scheme = call_565538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565538.url(scheme.get, call_565538.host, call_565538.base,
                         call_565538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565538, url, valid)

proc call*(call_565539: Call_ModelCreatePrebuiltEntityRole_565531;
          entityId: string; entityRoleCreateObject: JsonNode; appId: string;
          versionId: string): Recallable =
  ## modelCreatePrebuiltEntityRole
  ##   entityId: string (required)
  ##           : The entity model ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565540 = newJObject()
  var body_565541 = newJObject()
  add(path_565540, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_565541 = entityRoleCreateObject
  add(path_565540, "appId", newJString(appId))
  add(path_565540, "versionId", newJString(versionId))
  result = call_565539.call(path_565540, nil, nil, nil, body_565541)

var modelCreatePrebuiltEntityRole* = Call_ModelCreatePrebuiltEntityRole_565531(
    name: "modelCreatePrebuiltEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles",
    validator: validate_ModelCreatePrebuiltEntityRole_565532, base: "",
    url: url_ModelCreatePrebuiltEntityRole_565533, schemes: {Scheme.Https})
type
  Call_ModelListPrebuiltEntityRoles_565522 = ref object of OpenApiRestCall_563566
proc url_ModelListPrebuiltEntityRoles_565524(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListPrebuiltEntityRoles_565523(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity Id
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565525 = path.getOrDefault("entityId")
  valid_565525 = validateParameter(valid_565525, JString, required = true,
                                 default = nil)
  if valid_565525 != nil:
    section.add "entityId", valid_565525
  var valid_565526 = path.getOrDefault("appId")
  valid_565526 = validateParameter(valid_565526, JString, required = true,
                                 default = nil)
  if valid_565526 != nil:
    section.add "appId", valid_565526
  var valid_565527 = path.getOrDefault("versionId")
  valid_565527 = validateParameter(valid_565527, JString, required = true,
                                 default = nil)
  if valid_565527 != nil:
    section.add "versionId", valid_565527
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565528: Call_ModelListPrebuiltEntityRoles_565522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565528.validator(path, query, header, formData, body)
  let scheme = call_565528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565528.url(scheme.get, call_565528.host, call_565528.base,
                         call_565528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565528, url, valid)

proc call*(call_565529: Call_ModelListPrebuiltEntityRoles_565522; entityId: string;
          appId: string; versionId: string): Recallable =
  ## modelListPrebuiltEntityRoles
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565530 = newJObject()
  add(path_565530, "entityId", newJString(entityId))
  add(path_565530, "appId", newJString(appId))
  add(path_565530, "versionId", newJString(versionId))
  result = call_565529.call(path_565530, nil, nil, nil, nil)

var modelListPrebuiltEntityRoles* = Call_ModelListPrebuiltEntityRoles_565522(
    name: "modelListPrebuiltEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles",
    validator: validate_ModelListPrebuiltEntityRoles_565523, base: "",
    url: url_ModelListPrebuiltEntityRoles_565524, schemes: {Scheme.Https})
type
  Call_ModelUpdatePrebuiltEntityRole_565552 = ref object of OpenApiRestCall_563566
proc url_ModelUpdatePrebuiltEntityRole_565554(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdatePrebuiltEntityRole_565553(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565555 = path.getOrDefault("entityId")
  valid_565555 = validateParameter(valid_565555, JString, required = true,
                                 default = nil)
  if valid_565555 != nil:
    section.add "entityId", valid_565555
  var valid_565556 = path.getOrDefault("appId")
  valid_565556 = validateParameter(valid_565556, JString, required = true,
                                 default = nil)
  if valid_565556 != nil:
    section.add "appId", valid_565556
  var valid_565557 = path.getOrDefault("versionId")
  valid_565557 = validateParameter(valid_565557, JString, required = true,
                                 default = nil)
  if valid_565557 != nil:
    section.add "versionId", valid_565557
  var valid_565558 = path.getOrDefault("roleId")
  valid_565558 = validateParameter(valid_565558, JString, required = true,
                                 default = nil)
  if valid_565558 != nil:
    section.add "roleId", valid_565558
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565560: Call_ModelUpdatePrebuiltEntityRole_565552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565560.validator(path, query, header, formData, body)
  let scheme = call_565560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565560.url(scheme.get, call_565560.host, call_565560.base,
                         call_565560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565560, url, valid)

proc call*(call_565561: Call_ModelUpdatePrebuiltEntityRole_565552;
          entityId: string; entityRoleUpdateObject: JsonNode; appId: string;
          versionId: string; roleId: string): Recallable =
  ## modelUpdatePrebuiltEntityRole
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_565562 = newJObject()
  var body_565563 = newJObject()
  add(path_565562, "entityId", newJString(entityId))
  if entityRoleUpdateObject != nil:
    body_565563 = entityRoleUpdateObject
  add(path_565562, "appId", newJString(appId))
  add(path_565562, "versionId", newJString(versionId))
  add(path_565562, "roleId", newJString(roleId))
  result = call_565561.call(path_565562, nil, nil, nil, body_565563)

var modelUpdatePrebuiltEntityRole* = Call_ModelUpdatePrebuiltEntityRole_565552(
    name: "modelUpdatePrebuiltEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdatePrebuiltEntityRole_565553, base: "",
    url: url_ModelUpdatePrebuiltEntityRole_565554, schemes: {Scheme.Https})
type
  Call_ModelGetPrebuiltEntityRole_565542 = ref object of OpenApiRestCall_563566
proc url_ModelGetPrebuiltEntityRole_565544(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetPrebuiltEntityRole_565543(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565545 = path.getOrDefault("entityId")
  valid_565545 = validateParameter(valid_565545, JString, required = true,
                                 default = nil)
  if valid_565545 != nil:
    section.add "entityId", valid_565545
  var valid_565546 = path.getOrDefault("appId")
  valid_565546 = validateParameter(valid_565546, JString, required = true,
                                 default = nil)
  if valid_565546 != nil:
    section.add "appId", valid_565546
  var valid_565547 = path.getOrDefault("versionId")
  valid_565547 = validateParameter(valid_565547, JString, required = true,
                                 default = nil)
  if valid_565547 != nil:
    section.add "versionId", valid_565547
  var valid_565548 = path.getOrDefault("roleId")
  valid_565548 = validateParameter(valid_565548, JString, required = true,
                                 default = nil)
  if valid_565548 != nil:
    section.add "roleId", valid_565548
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565549: Call_ModelGetPrebuiltEntityRole_565542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565549.validator(path, query, header, formData, body)
  let scheme = call_565549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565549.url(scheme.get, call_565549.host, call_565549.base,
                         call_565549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565549, url, valid)

proc call*(call_565550: Call_ModelGetPrebuiltEntityRole_565542; entityId: string;
          appId: string; versionId: string; roleId: string): Recallable =
  ## modelGetPrebuiltEntityRole
  ##   entityId: string (required)
  ##           : entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_565551 = newJObject()
  add(path_565551, "entityId", newJString(entityId))
  add(path_565551, "appId", newJString(appId))
  add(path_565551, "versionId", newJString(versionId))
  add(path_565551, "roleId", newJString(roleId))
  result = call_565550.call(path_565551, nil, nil, nil, nil)

var modelGetPrebuiltEntityRole* = Call_ModelGetPrebuiltEntityRole_565542(
    name: "modelGetPrebuiltEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles/{roleId}",
    validator: validate_ModelGetPrebuiltEntityRole_565543, base: "",
    url: url_ModelGetPrebuiltEntityRole_565544, schemes: {Scheme.Https})
type
  Call_ModelDeletePrebuiltEntityRole_565564 = ref object of OpenApiRestCall_563566
proc url_ModelDeletePrebuiltEntityRole_565566(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeletePrebuiltEntityRole_565565(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565567 = path.getOrDefault("entityId")
  valid_565567 = validateParameter(valid_565567, JString, required = true,
                                 default = nil)
  if valid_565567 != nil:
    section.add "entityId", valid_565567
  var valid_565568 = path.getOrDefault("appId")
  valid_565568 = validateParameter(valid_565568, JString, required = true,
                                 default = nil)
  if valid_565568 != nil:
    section.add "appId", valid_565568
  var valid_565569 = path.getOrDefault("versionId")
  valid_565569 = validateParameter(valid_565569, JString, required = true,
                                 default = nil)
  if valid_565569 != nil:
    section.add "versionId", valid_565569
  var valid_565570 = path.getOrDefault("roleId")
  valid_565570 = validateParameter(valid_565570, JString, required = true,
                                 default = nil)
  if valid_565570 != nil:
    section.add "roleId", valid_565570
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565571: Call_ModelDeletePrebuiltEntityRole_565564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565571.validator(path, query, header, formData, body)
  let scheme = call_565571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565571.url(scheme.get, call_565571.host, call_565571.base,
                         call_565571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565571, url, valid)

proc call*(call_565572: Call_ModelDeletePrebuiltEntityRole_565564;
          entityId: string; appId: string; versionId: string; roleId: string): Recallable =
  ## modelDeletePrebuiltEntityRole
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_565573 = newJObject()
  add(path_565573, "entityId", newJString(entityId))
  add(path_565573, "appId", newJString(appId))
  add(path_565573, "versionId", newJString(versionId))
  add(path_565573, "roleId", newJString(roleId))
  result = call_565572.call(path_565573, nil, nil, nil, nil)

var modelDeletePrebuiltEntityRole* = Call_ModelDeletePrebuiltEntityRole_565564(
    name: "modelDeletePrebuiltEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles/{roleId}",
    validator: validate_ModelDeletePrebuiltEntityRole_565565, base: "",
    url: url_ModelDeletePrebuiltEntityRole_565566, schemes: {Scheme.Https})
type
  Call_ModelGetPrebuilt_565574 = ref object of OpenApiRestCall_563566
proc url_ModelGetPrebuilt_565576(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "prebuiltId" in path, "`prebuiltId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "prebuiltId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetPrebuilt_565575(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about a prebuilt entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   prebuiltId: JString (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `prebuiltId` field"
  var valid_565577 = path.getOrDefault("prebuiltId")
  valid_565577 = validateParameter(valid_565577, JString, required = true,
                                 default = nil)
  if valid_565577 != nil:
    section.add "prebuiltId", valid_565577
  var valid_565578 = path.getOrDefault("appId")
  valid_565578 = validateParameter(valid_565578, JString, required = true,
                                 default = nil)
  if valid_565578 != nil:
    section.add "appId", valid_565578
  var valid_565579 = path.getOrDefault("versionId")
  valid_565579 = validateParameter(valid_565579, JString, required = true,
                                 default = nil)
  if valid_565579 != nil:
    section.add "versionId", valid_565579
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565580: Call_ModelGetPrebuilt_565574; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a prebuilt entity model in a version of the application.
  ## 
  let valid = call_565580.validator(path, query, header, formData, body)
  let scheme = call_565580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565580.url(scheme.get, call_565580.host, call_565580.base,
                         call_565580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565580, url, valid)

proc call*(call_565581: Call_ModelGetPrebuilt_565574; prebuiltId: string;
          appId: string; versionId: string): Recallable =
  ## modelGetPrebuilt
  ## Gets information about a prebuilt entity model in a version of the application.
  ##   prebuiltId: string (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565582 = newJObject()
  add(path_565582, "prebuiltId", newJString(prebuiltId))
  add(path_565582, "appId", newJString(appId))
  add(path_565582, "versionId", newJString(versionId))
  result = call_565581.call(path_565582, nil, nil, nil, nil)

var modelGetPrebuilt* = Call_ModelGetPrebuilt_565574(name: "modelGetPrebuilt",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{prebuiltId}",
    validator: validate_ModelGetPrebuilt_565575, base: "",
    url: url_ModelGetPrebuilt_565576, schemes: {Scheme.Https})
type
  Call_ModelDeletePrebuilt_565583 = ref object of OpenApiRestCall_563566
proc url_ModelDeletePrebuilt_565585(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "prebuiltId" in path, "`prebuiltId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "prebuiltId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeletePrebuilt_565584(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a prebuilt entity extractor from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   prebuiltId: JString (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `prebuiltId` field"
  var valid_565586 = path.getOrDefault("prebuiltId")
  valid_565586 = validateParameter(valid_565586, JString, required = true,
                                 default = nil)
  if valid_565586 != nil:
    section.add "prebuiltId", valid_565586
  var valid_565587 = path.getOrDefault("appId")
  valid_565587 = validateParameter(valid_565587, JString, required = true,
                                 default = nil)
  if valid_565587 != nil:
    section.add "appId", valid_565587
  var valid_565588 = path.getOrDefault("versionId")
  valid_565588 = validateParameter(valid_565588, JString, required = true,
                                 default = nil)
  if valid_565588 != nil:
    section.add "versionId", valid_565588
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565589: Call_ModelDeletePrebuilt_565583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a prebuilt entity extractor from a version of the application.
  ## 
  let valid = call_565589.validator(path, query, header, formData, body)
  let scheme = call_565589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565589.url(scheme.get, call_565589.host, call_565589.base,
                         call_565589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565589, url, valid)

proc call*(call_565590: Call_ModelDeletePrebuilt_565583; prebuiltId: string;
          appId: string; versionId: string): Recallable =
  ## modelDeletePrebuilt
  ## Deletes a prebuilt entity extractor from a version of the application.
  ##   prebuiltId: string (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565591 = newJObject()
  add(path_565591, "prebuiltId", newJString(prebuiltId))
  add(path_565591, "appId", newJString(appId))
  add(path_565591, "versionId", newJString(versionId))
  result = call_565590.call(path_565591, nil, nil, nil, nil)

var modelDeletePrebuilt* = Call_ModelDeletePrebuilt_565583(
    name: "modelDeletePrebuilt", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{prebuiltId}",
    validator: validate_ModelDeletePrebuilt_565584, base: "",
    url: url_ModelDeletePrebuilt_565585, schemes: {Scheme.Https})
type
  Call_ModelCreateRegexEntityModel_565603 = ref object of OpenApiRestCall_563566
proc url_ModelCreateRegexEntityModel_565605(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateRegexEntityModel_565604(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565606 = path.getOrDefault("appId")
  valid_565606 = validateParameter(valid_565606, JString, required = true,
                                 default = nil)
  if valid_565606 != nil:
    section.add "appId", valid_565606
  var valid_565607 = path.getOrDefault("versionId")
  valid_565607 = validateParameter(valid_565607, JString, required = true,
                                 default = nil)
  if valid_565607 != nil:
    section.add "versionId", valid_565607
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regexEntityExtractorCreateObj: JObject (required)
  ##                                : A model object containing the name and regex pattern for the new regular expression entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565609: Call_ModelCreateRegexEntityModel_565603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565609.validator(path, query, header, formData, body)
  let scheme = call_565609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565609.url(scheme.get, call_565609.host, call_565609.base,
                         call_565609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565609, url, valid)

proc call*(call_565610: Call_ModelCreateRegexEntityModel_565603;
          regexEntityExtractorCreateObj: JsonNode; appId: string; versionId: string): Recallable =
  ## modelCreateRegexEntityModel
  ##   regexEntityExtractorCreateObj: JObject (required)
  ##                                : A model object containing the name and regex pattern for the new regular expression entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565611 = newJObject()
  var body_565612 = newJObject()
  if regexEntityExtractorCreateObj != nil:
    body_565612 = regexEntityExtractorCreateObj
  add(path_565611, "appId", newJString(appId))
  add(path_565611, "versionId", newJString(versionId))
  result = call_565610.call(path_565611, nil, nil, nil, body_565612)

var modelCreateRegexEntityModel* = Call_ModelCreateRegexEntityModel_565603(
    name: "modelCreateRegexEntityModel", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities",
    validator: validate_ModelCreateRegexEntityModel_565604, base: "",
    url: url_ModelCreateRegexEntityModel_565605, schemes: {Scheme.Https})
type
  Call_ModelListRegexEntityInfos_565592 = ref object of OpenApiRestCall_563566
proc url_ModelListRegexEntityInfos_565594(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListRegexEntityInfos_565593(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565595 = path.getOrDefault("appId")
  valid_565595 = validateParameter(valid_565595, JString, required = true,
                                 default = nil)
  if valid_565595 != nil:
    section.add "appId", valid_565595
  var valid_565596 = path.getOrDefault("versionId")
  valid_565596 = validateParameter(valid_565596, JString, required = true,
                                 default = nil)
  if valid_565596 != nil:
    section.add "versionId", valid_565596
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_565597 = query.getOrDefault("take")
  valid_565597 = validateParameter(valid_565597, JInt, required = false,
                                 default = newJInt(100))
  if valid_565597 != nil:
    section.add "take", valid_565597
  var valid_565598 = query.getOrDefault("skip")
  valid_565598 = validateParameter(valid_565598, JInt, required = false,
                                 default = newJInt(0))
  if valid_565598 != nil:
    section.add "skip", valid_565598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565599: Call_ModelListRegexEntityInfos_565592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565599.validator(path, query, header, formData, body)
  let scheme = call_565599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565599.url(scheme.get, call_565599.host, call_565599.base,
                         call_565599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565599, url, valid)

proc call*(call_565600: Call_ModelListRegexEntityInfos_565592; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListRegexEntityInfos
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565601 = newJObject()
  var query_565602 = newJObject()
  add(query_565602, "take", newJInt(take))
  add(query_565602, "skip", newJInt(skip))
  add(path_565601, "appId", newJString(appId))
  add(path_565601, "versionId", newJString(versionId))
  result = call_565600.call(path_565601, query_565602, nil, nil, nil)

var modelListRegexEntityInfos* = Call_ModelListRegexEntityInfos_565592(
    name: "modelListRegexEntityInfos", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities",
    validator: validate_ModelListRegexEntityInfos_565593, base: "",
    url: url_ModelListRegexEntityInfos_565594, schemes: {Scheme.Https})
type
  Call_ModelCreateRegexEntityRole_565622 = ref object of OpenApiRestCall_563566
proc url_ModelCreateRegexEntityRole_565624(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateRegexEntityRole_565623(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565625 = path.getOrDefault("entityId")
  valid_565625 = validateParameter(valid_565625, JString, required = true,
                                 default = nil)
  if valid_565625 != nil:
    section.add "entityId", valid_565625
  var valid_565626 = path.getOrDefault("appId")
  valid_565626 = validateParameter(valid_565626, JString, required = true,
                                 default = nil)
  if valid_565626 != nil:
    section.add "appId", valid_565626
  var valid_565627 = path.getOrDefault("versionId")
  valid_565627 = validateParameter(valid_565627, JString, required = true,
                                 default = nil)
  if valid_565627 != nil:
    section.add "versionId", valid_565627
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565629: Call_ModelCreateRegexEntityRole_565622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565629.validator(path, query, header, formData, body)
  let scheme = call_565629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565629.url(scheme.get, call_565629.host, call_565629.base,
                         call_565629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565629, url, valid)

proc call*(call_565630: Call_ModelCreateRegexEntityRole_565622; entityId: string;
          entityRoleCreateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelCreateRegexEntityRole
  ##   entityId: string (required)
  ##           : The entity model ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565631 = newJObject()
  var body_565632 = newJObject()
  add(path_565631, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_565632 = entityRoleCreateObject
  add(path_565631, "appId", newJString(appId))
  add(path_565631, "versionId", newJString(versionId))
  result = call_565630.call(path_565631, nil, nil, nil, body_565632)

var modelCreateRegexEntityRole* = Call_ModelCreateRegexEntityRole_565622(
    name: "modelCreateRegexEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles",
    validator: validate_ModelCreateRegexEntityRole_565623, base: "",
    url: url_ModelCreateRegexEntityRole_565624, schemes: {Scheme.Https})
type
  Call_ModelListRegexEntityRoles_565613 = ref object of OpenApiRestCall_563566
proc url_ModelListRegexEntityRoles_565615(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListRegexEntityRoles_565614(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity Id
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565616 = path.getOrDefault("entityId")
  valid_565616 = validateParameter(valid_565616, JString, required = true,
                                 default = nil)
  if valid_565616 != nil:
    section.add "entityId", valid_565616
  var valid_565617 = path.getOrDefault("appId")
  valid_565617 = validateParameter(valid_565617, JString, required = true,
                                 default = nil)
  if valid_565617 != nil:
    section.add "appId", valid_565617
  var valid_565618 = path.getOrDefault("versionId")
  valid_565618 = validateParameter(valid_565618, JString, required = true,
                                 default = nil)
  if valid_565618 != nil:
    section.add "versionId", valid_565618
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565619: Call_ModelListRegexEntityRoles_565613; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565619.validator(path, query, header, formData, body)
  let scheme = call_565619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565619.url(scheme.get, call_565619.host, call_565619.base,
                         call_565619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565619, url, valid)

proc call*(call_565620: Call_ModelListRegexEntityRoles_565613; entityId: string;
          appId: string; versionId: string): Recallable =
  ## modelListRegexEntityRoles
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565621 = newJObject()
  add(path_565621, "entityId", newJString(entityId))
  add(path_565621, "appId", newJString(appId))
  add(path_565621, "versionId", newJString(versionId))
  result = call_565620.call(path_565621, nil, nil, nil, nil)

var modelListRegexEntityRoles* = Call_ModelListRegexEntityRoles_565613(
    name: "modelListRegexEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles",
    validator: validate_ModelListRegexEntityRoles_565614, base: "",
    url: url_ModelListRegexEntityRoles_565615, schemes: {Scheme.Https})
type
  Call_ModelUpdateRegexEntityRole_565643 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateRegexEntityRole_565645(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateRegexEntityRole_565644(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565646 = path.getOrDefault("entityId")
  valid_565646 = validateParameter(valid_565646, JString, required = true,
                                 default = nil)
  if valid_565646 != nil:
    section.add "entityId", valid_565646
  var valid_565647 = path.getOrDefault("appId")
  valid_565647 = validateParameter(valid_565647, JString, required = true,
                                 default = nil)
  if valid_565647 != nil:
    section.add "appId", valid_565647
  var valid_565648 = path.getOrDefault("versionId")
  valid_565648 = validateParameter(valid_565648, JString, required = true,
                                 default = nil)
  if valid_565648 != nil:
    section.add "versionId", valid_565648
  var valid_565649 = path.getOrDefault("roleId")
  valid_565649 = validateParameter(valid_565649, JString, required = true,
                                 default = nil)
  if valid_565649 != nil:
    section.add "roleId", valid_565649
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565651: Call_ModelUpdateRegexEntityRole_565643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565651.validator(path, query, header, formData, body)
  let scheme = call_565651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565651.url(scheme.get, call_565651.host, call_565651.base,
                         call_565651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565651, url, valid)

proc call*(call_565652: Call_ModelUpdateRegexEntityRole_565643; entityId: string;
          entityRoleUpdateObject: JsonNode; appId: string; versionId: string;
          roleId: string): Recallable =
  ## modelUpdateRegexEntityRole
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_565653 = newJObject()
  var body_565654 = newJObject()
  add(path_565653, "entityId", newJString(entityId))
  if entityRoleUpdateObject != nil:
    body_565654 = entityRoleUpdateObject
  add(path_565653, "appId", newJString(appId))
  add(path_565653, "versionId", newJString(versionId))
  add(path_565653, "roleId", newJString(roleId))
  result = call_565652.call(path_565653, nil, nil, nil, body_565654)

var modelUpdateRegexEntityRole* = Call_ModelUpdateRegexEntityRole_565643(
    name: "modelUpdateRegexEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdateRegexEntityRole_565644, base: "",
    url: url_ModelUpdateRegexEntityRole_565645, schemes: {Scheme.Https})
type
  Call_ModelGetRegexEntityRole_565633 = ref object of OpenApiRestCall_563566
proc url_ModelGetRegexEntityRole_565635(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetRegexEntityRole_565634(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565636 = path.getOrDefault("entityId")
  valid_565636 = validateParameter(valid_565636, JString, required = true,
                                 default = nil)
  if valid_565636 != nil:
    section.add "entityId", valid_565636
  var valid_565637 = path.getOrDefault("appId")
  valid_565637 = validateParameter(valid_565637, JString, required = true,
                                 default = nil)
  if valid_565637 != nil:
    section.add "appId", valid_565637
  var valid_565638 = path.getOrDefault("versionId")
  valid_565638 = validateParameter(valid_565638, JString, required = true,
                                 default = nil)
  if valid_565638 != nil:
    section.add "versionId", valid_565638
  var valid_565639 = path.getOrDefault("roleId")
  valid_565639 = validateParameter(valid_565639, JString, required = true,
                                 default = nil)
  if valid_565639 != nil:
    section.add "roleId", valid_565639
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565640: Call_ModelGetRegexEntityRole_565633; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565640.validator(path, query, header, formData, body)
  let scheme = call_565640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565640.url(scheme.get, call_565640.host, call_565640.base,
                         call_565640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565640, url, valid)

proc call*(call_565641: Call_ModelGetRegexEntityRole_565633; entityId: string;
          appId: string; versionId: string; roleId: string): Recallable =
  ## modelGetRegexEntityRole
  ##   entityId: string (required)
  ##           : entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_565642 = newJObject()
  add(path_565642, "entityId", newJString(entityId))
  add(path_565642, "appId", newJString(appId))
  add(path_565642, "versionId", newJString(versionId))
  add(path_565642, "roleId", newJString(roleId))
  result = call_565641.call(path_565642, nil, nil, nil, nil)

var modelGetRegexEntityRole* = Call_ModelGetRegexEntityRole_565633(
    name: "modelGetRegexEntityRole", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles/{roleId}",
    validator: validate_ModelGetRegexEntityRole_565634, base: "",
    url: url_ModelGetRegexEntityRole_565635, schemes: {Scheme.Https})
type
  Call_ModelDeleteRegexEntityRole_565655 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteRegexEntityRole_565657(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteRegexEntityRole_565656(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_565658 = path.getOrDefault("entityId")
  valid_565658 = validateParameter(valid_565658, JString, required = true,
                                 default = nil)
  if valid_565658 != nil:
    section.add "entityId", valid_565658
  var valid_565659 = path.getOrDefault("appId")
  valid_565659 = validateParameter(valid_565659, JString, required = true,
                                 default = nil)
  if valid_565659 != nil:
    section.add "appId", valid_565659
  var valid_565660 = path.getOrDefault("versionId")
  valid_565660 = validateParameter(valid_565660, JString, required = true,
                                 default = nil)
  if valid_565660 != nil:
    section.add "versionId", valid_565660
  var valid_565661 = path.getOrDefault("roleId")
  valid_565661 = validateParameter(valid_565661, JString, required = true,
                                 default = nil)
  if valid_565661 != nil:
    section.add "roleId", valid_565661
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565662: Call_ModelDeleteRegexEntityRole_565655; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565662.validator(path, query, header, formData, body)
  let scheme = call_565662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565662.url(scheme.get, call_565662.host, call_565662.base,
                         call_565662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565662, url, valid)

proc call*(call_565663: Call_ModelDeleteRegexEntityRole_565655; entityId: string;
          appId: string; versionId: string; roleId: string): Recallable =
  ## modelDeleteRegexEntityRole
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_565664 = newJObject()
  add(path_565664, "entityId", newJString(entityId))
  add(path_565664, "appId", newJString(appId))
  add(path_565664, "versionId", newJString(versionId))
  add(path_565664, "roleId", newJString(roleId))
  result = call_565663.call(path_565664, nil, nil, nil, nil)

var modelDeleteRegexEntityRole* = Call_ModelDeleteRegexEntityRole_565655(
    name: "modelDeleteRegexEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles/{roleId}",
    validator: validate_ModelDeleteRegexEntityRole_565656, base: "",
    url: url_ModelDeleteRegexEntityRole_565657, schemes: {Scheme.Https})
type
  Call_ModelUpdateRegexEntityModel_565674 = ref object of OpenApiRestCall_563566
proc url_ModelUpdateRegexEntityModel_565676(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "regexEntityId" in path, "`regexEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "regexEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateRegexEntityModel_565675(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   regexEntityId: JString (required)
  ##                : The regular expression entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `regexEntityId` field"
  var valid_565677 = path.getOrDefault("regexEntityId")
  valid_565677 = validateParameter(valid_565677, JString, required = true,
                                 default = nil)
  if valid_565677 != nil:
    section.add "regexEntityId", valid_565677
  var valid_565678 = path.getOrDefault("appId")
  valid_565678 = validateParameter(valid_565678, JString, required = true,
                                 default = nil)
  if valid_565678 != nil:
    section.add "appId", valid_565678
  var valid_565679 = path.getOrDefault("versionId")
  valid_565679 = validateParameter(valid_565679, JString, required = true,
                                 default = nil)
  if valid_565679 != nil:
    section.add "versionId", valid_565679
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regexEntityUpdateObject: JObject (required)
  ##                          : An object containing the new entity name and regex pattern.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565681: Call_ModelUpdateRegexEntityModel_565674; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565681.validator(path, query, header, formData, body)
  let scheme = call_565681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565681.url(scheme.get, call_565681.host, call_565681.base,
                         call_565681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565681, url, valid)

proc call*(call_565682: Call_ModelUpdateRegexEntityModel_565674;
          regexEntityId: string; appId: string; versionId: string;
          regexEntityUpdateObject: JsonNode): Recallable =
  ## modelUpdateRegexEntityModel
  ##   regexEntityId: string (required)
  ##                : The regular expression entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   regexEntityUpdateObject: JObject (required)
  ##                          : An object containing the new entity name and regex pattern.
  var path_565683 = newJObject()
  var body_565684 = newJObject()
  add(path_565683, "regexEntityId", newJString(regexEntityId))
  add(path_565683, "appId", newJString(appId))
  add(path_565683, "versionId", newJString(versionId))
  if regexEntityUpdateObject != nil:
    body_565684 = regexEntityUpdateObject
  result = call_565682.call(path_565683, nil, nil, nil, body_565684)

var modelUpdateRegexEntityModel* = Call_ModelUpdateRegexEntityModel_565674(
    name: "modelUpdateRegexEntityModel", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{regexEntityId}",
    validator: validate_ModelUpdateRegexEntityModel_565675, base: "",
    url: url_ModelUpdateRegexEntityModel_565676, schemes: {Scheme.Https})
type
  Call_ModelGetRegexEntityEntityInfo_565665 = ref object of OpenApiRestCall_563566
proc url_ModelGetRegexEntityEntityInfo_565667(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "regexEntityId" in path, "`regexEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "regexEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetRegexEntityEntityInfo_565666(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   regexEntityId: JString (required)
  ##                : The regular expression entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `regexEntityId` field"
  var valid_565668 = path.getOrDefault("regexEntityId")
  valid_565668 = validateParameter(valid_565668, JString, required = true,
                                 default = nil)
  if valid_565668 != nil:
    section.add "regexEntityId", valid_565668
  var valid_565669 = path.getOrDefault("appId")
  valid_565669 = validateParameter(valid_565669, JString, required = true,
                                 default = nil)
  if valid_565669 != nil:
    section.add "appId", valid_565669
  var valid_565670 = path.getOrDefault("versionId")
  valid_565670 = validateParameter(valid_565670, JString, required = true,
                                 default = nil)
  if valid_565670 != nil:
    section.add "versionId", valid_565670
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565671: Call_ModelGetRegexEntityEntityInfo_565665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565671.validator(path, query, header, formData, body)
  let scheme = call_565671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565671.url(scheme.get, call_565671.host, call_565671.base,
                         call_565671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565671, url, valid)

proc call*(call_565672: Call_ModelGetRegexEntityEntityInfo_565665;
          regexEntityId: string; appId: string; versionId: string): Recallable =
  ## modelGetRegexEntityEntityInfo
  ##   regexEntityId: string (required)
  ##                : The regular expression entity model ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565673 = newJObject()
  add(path_565673, "regexEntityId", newJString(regexEntityId))
  add(path_565673, "appId", newJString(appId))
  add(path_565673, "versionId", newJString(versionId))
  result = call_565672.call(path_565673, nil, nil, nil, nil)

var modelGetRegexEntityEntityInfo* = Call_ModelGetRegexEntityEntityInfo_565665(
    name: "modelGetRegexEntityEntityInfo", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{regexEntityId}",
    validator: validate_ModelGetRegexEntityEntityInfo_565666, base: "",
    url: url_ModelGetRegexEntityEntityInfo_565667, schemes: {Scheme.Https})
type
  Call_ModelDeleteRegexEntityModel_565685 = ref object of OpenApiRestCall_563566
proc url_ModelDeleteRegexEntityModel_565687(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "regexEntityId" in path, "`regexEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "regexEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteRegexEntityModel_565686(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   regexEntityId: JString (required)
  ##                : The regular expression entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `regexEntityId` field"
  var valid_565688 = path.getOrDefault("regexEntityId")
  valid_565688 = validateParameter(valid_565688, JString, required = true,
                                 default = nil)
  if valid_565688 != nil:
    section.add "regexEntityId", valid_565688
  var valid_565689 = path.getOrDefault("appId")
  valid_565689 = validateParameter(valid_565689, JString, required = true,
                                 default = nil)
  if valid_565689 != nil:
    section.add "appId", valid_565689
  var valid_565690 = path.getOrDefault("versionId")
  valid_565690 = validateParameter(valid_565690, JString, required = true,
                                 default = nil)
  if valid_565690 != nil:
    section.add "versionId", valid_565690
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565691: Call_ModelDeleteRegexEntityModel_565685; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565691.validator(path, query, header, formData, body)
  let scheme = call_565691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565691.url(scheme.get, call_565691.host, call_565691.base,
                         call_565691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565691, url, valid)

proc call*(call_565692: Call_ModelDeleteRegexEntityModel_565685;
          regexEntityId: string; appId: string; versionId: string): Recallable =
  ## modelDeleteRegexEntityModel
  ##   regexEntityId: string (required)
  ##                : The regular expression entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565693 = newJObject()
  add(path_565693, "regexEntityId", newJString(regexEntityId))
  add(path_565693, "appId", newJString(appId))
  add(path_565693, "versionId", newJString(versionId))
  result = call_565692.call(path_565693, nil, nil, nil, nil)

var modelDeleteRegexEntityModel* = Call_ModelDeleteRegexEntityModel_565685(
    name: "modelDeleteRegexEntityModel", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{regexEntityId}",
    validator: validate_ModelDeleteRegexEntityModel_565686, base: "",
    url: url_ModelDeleteRegexEntityModel_565687, schemes: {Scheme.Https})
type
  Call_SettingsUpdate_565702 = ref object of OpenApiRestCall_563566
proc url_SettingsUpdate_565704(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/settings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SettingsUpdate_565703(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the settings in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565705 = path.getOrDefault("appId")
  valid_565705 = validateParameter(valid_565705, JString, required = true,
                                 default = nil)
  if valid_565705 != nil:
    section.add "appId", valid_565705
  var valid_565706 = path.getOrDefault("versionId")
  valid_565706 = validateParameter(valid_565706, JString, required = true,
                                 default = nil)
  if valid_565706 != nil:
    section.add "versionId", valid_565706
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   listOfAppVersionSettingObject: JArray (required)
  ##                                : A list of the updated application version settings.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565708: Call_SettingsUpdate_565702; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the settings in a version of the application.
  ## 
  let valid = call_565708.validator(path, query, header, formData, body)
  let scheme = call_565708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565708.url(scheme.get, call_565708.host, call_565708.base,
                         call_565708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565708, url, valid)

proc call*(call_565709: Call_SettingsUpdate_565702; appId: string;
          listOfAppVersionSettingObject: JsonNode; versionId: string): Recallable =
  ## settingsUpdate
  ## Updates the settings in a version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   listOfAppVersionSettingObject: JArray (required)
  ##                                : A list of the updated application version settings.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565710 = newJObject()
  var body_565711 = newJObject()
  add(path_565710, "appId", newJString(appId))
  if listOfAppVersionSettingObject != nil:
    body_565711 = listOfAppVersionSettingObject
  add(path_565710, "versionId", newJString(versionId))
  result = call_565709.call(path_565710, nil, nil, nil, body_565711)

var settingsUpdate* = Call_SettingsUpdate_565702(name: "settingsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/settings",
    validator: validate_SettingsUpdate_565703, base: "", url: url_SettingsUpdate_565704,
    schemes: {Scheme.Https})
type
  Call_SettingsList_565694 = ref object of OpenApiRestCall_563566
proc url_SettingsList_565696(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/settings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SettingsList_565695(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the settings in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565697 = path.getOrDefault("appId")
  valid_565697 = validateParameter(valid_565697, JString, required = true,
                                 default = nil)
  if valid_565697 != nil:
    section.add "appId", valid_565697
  var valid_565698 = path.getOrDefault("versionId")
  valid_565698 = validateParameter(valid_565698, JString, required = true,
                                 default = nil)
  if valid_565698 != nil:
    section.add "versionId", valid_565698
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565699: Call_SettingsList_565694; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the settings in a version of the application.
  ## 
  let valid = call_565699.validator(path, query, header, formData, body)
  let scheme = call_565699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565699.url(scheme.get, call_565699.host, call_565699.base,
                         call_565699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565699, url, valid)

proc call*(call_565700: Call_SettingsList_565694; appId: string; versionId: string): Recallable =
  ## settingsList
  ## Gets the settings in a version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565701 = newJObject()
  add(path_565701, "appId", newJString(appId))
  add(path_565701, "versionId", newJString(versionId))
  result = call_565700.call(path_565701, nil, nil, nil, nil)

var settingsList* = Call_SettingsList_565694(name: "settingsList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/settings",
    validator: validate_SettingsList_565695, base: "", url: url_SettingsList_565696,
    schemes: {Scheme.Https})
type
  Call_VersionsDeleteUnlabelledUtterance_565712 = ref object of OpenApiRestCall_563566
proc url_VersionsDeleteUnlabelledUtterance_565714(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/suggest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsDeleteUnlabelledUtterance_565713(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deleted an unlabelled utterance in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565715 = path.getOrDefault("appId")
  valid_565715 = validateParameter(valid_565715, JString, required = true,
                                 default = nil)
  if valid_565715 != nil:
    section.add "appId", valid_565715
  var valid_565716 = path.getOrDefault("versionId")
  valid_565716 = validateParameter(valid_565716, JString, required = true,
                                 default = nil)
  if valid_565716 != nil:
    section.add "versionId", valid_565716
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   utterance: JString (required)
  ##            : The utterance text to delete.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JString, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565718: Call_VersionsDeleteUnlabelledUtterance_565712;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deleted an unlabelled utterance in a version of the application.
  ## 
  let valid = call_565718.validator(path, query, header, formData, body)
  let scheme = call_565718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565718.url(scheme.get, call_565718.host, call_565718.base,
                         call_565718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565718, url, valid)

proc call*(call_565719: Call_VersionsDeleteUnlabelledUtterance_565712;
          utterance: JsonNode; appId: string; versionId: string): Recallable =
  ## versionsDeleteUnlabelledUtterance
  ## Deleted an unlabelled utterance in a version of the application.
  ##   utterance: JString (required)
  ##            : The utterance text to delete.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565720 = newJObject()
  var body_565721 = newJObject()
  if utterance != nil:
    body_565721 = utterance
  add(path_565720, "appId", newJString(appId))
  add(path_565720, "versionId", newJString(versionId))
  result = call_565719.call(path_565720, nil, nil, nil, body_565721)

var versionsDeleteUnlabelledUtterance* = Call_VersionsDeleteUnlabelledUtterance_565712(
    name: "versionsDeleteUnlabelledUtterance", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/suggest",
    validator: validate_VersionsDeleteUnlabelledUtterance_565713, base: "",
    url: url_VersionsDeleteUnlabelledUtterance_565714, schemes: {Scheme.Https})
type
  Call_TrainTrainVersion_565730 = ref object of OpenApiRestCall_563566
proc url_TrainTrainVersion_565732(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TrainTrainVersion_565731(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565733 = path.getOrDefault("appId")
  valid_565733 = validateParameter(valid_565733, JString, required = true,
                                 default = nil)
  if valid_565733 != nil:
    section.add "appId", valid_565733
  var valid_565734 = path.getOrDefault("versionId")
  valid_565734 = validateParameter(valid_565734, JString, required = true,
                                 default = nil)
  if valid_565734 != nil:
    section.add "versionId", valid_565734
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565735: Call_TrainTrainVersion_565730; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ## 
  let valid = call_565735.validator(path, query, header, formData, body)
  let scheme = call_565735.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565735.url(scheme.get, call_565735.host, call_565735.base,
                         call_565735.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565735, url, valid)

proc call*(call_565736: Call_TrainTrainVersion_565730; appId: string;
          versionId: string): Recallable =
  ## trainTrainVersion
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565737 = newJObject()
  add(path_565737, "appId", newJString(appId))
  add(path_565737, "versionId", newJString(versionId))
  result = call_565736.call(path_565737, nil, nil, nil, nil)

var trainTrainVersion* = Call_TrainTrainVersion_565730(name: "trainTrainVersion",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/train",
    validator: validate_TrainTrainVersion_565731, base: "",
    url: url_TrainTrainVersion_565732, schemes: {Scheme.Https})
type
  Call_TrainGetStatus_565722 = ref object of OpenApiRestCall_563566
proc url_TrainGetStatus_565724(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TrainGetStatus_565723(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565725 = path.getOrDefault("appId")
  valid_565725 = validateParameter(valid_565725, JString, required = true,
                                 default = nil)
  if valid_565725 != nil:
    section.add "appId", valid_565725
  var valid_565726 = path.getOrDefault("versionId")
  valid_565726 = validateParameter(valid_565726, JString, required = true,
                                 default = nil)
  if valid_565726 != nil:
    section.add "versionId", valid_565726
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565727: Call_TrainGetStatus_565722; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ## 
  let valid = call_565727.validator(path, query, header, formData, body)
  let scheme = call_565727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565727.url(scheme.get, call_565727.host, call_565727.base,
                         call_565727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565727, url, valid)

proc call*(call_565728: Call_TrainGetStatus_565722; appId: string; versionId: string): Recallable =
  ## trainGetStatus
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565729 = newJObject()
  add(path_565729, "appId", newJString(appId))
  add(path_565729, "versionId", newJString(versionId))
  result = call_565728.call(path_565729, nil, nil, nil, nil)

var trainGetStatus* = Call_TrainGetStatus_565722(name: "trainGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/train",
    validator: validate_TrainGetStatus_565723, base: "", url: url_TrainGetStatus_565724,
    schemes: {Scheme.Https})
type
  Call_AzureAccountsListUserLUISAccounts_565738 = ref object of OpenApiRestCall_563566
proc url_AzureAccountsListUserLUISAccounts_565740(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AzureAccountsListUserLUISAccounts_565739(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the LUIS Azure accounts for the user using his ARM token.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Authorization: JString (required)
  ##                : The bearer authorization header to use; containing the user's ARM token used to validate Azure accounts information.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Authorization` field"
  var valid_565741 = header.getOrDefault("Authorization")
  valid_565741 = validateParameter(valid_565741, JString, required = true,
                                 default = nil)
  if valid_565741 != nil:
    section.add "Authorization", valid_565741
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565742: Call_AzureAccountsListUserLUISAccounts_565738;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the LUIS Azure accounts for the user using his ARM token.
  ## 
  let valid = call_565742.validator(path, query, header, formData, body)
  let scheme = call_565742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565742.url(scheme.get, call_565742.host, call_565742.base,
                         call_565742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565742, url, valid)

proc call*(call_565743: Call_AzureAccountsListUserLUISAccounts_565738): Recallable =
  ## azureAccountsListUserLUISAccounts
  ## Gets the LUIS Azure accounts for the user using his ARM token.
  result = call_565743.call(nil, nil, nil, nil, nil)

var azureAccountsListUserLUISAccounts* = Call_AzureAccountsListUserLUISAccounts_565738(
    name: "azureAccountsListUserLUISAccounts", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/azureaccounts",
    validator: validate_AzureAccountsListUserLUISAccounts_565739, base: "",
    url: url_AzureAccountsListUserLUISAccounts_565740, schemes: {Scheme.Https})
type
  Call_AppsPackagePublishedApplicationAsGzip_565744 = ref object of OpenApiRestCall_563566
proc url_AppsPackagePublishedApplicationAsGzip_565746(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "slotName" in path, "`slotName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/package/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/slot/"),
               (kind: VariableSegment, value: "slotName"),
               (kind: ConstantSegment, value: "/gzip")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsPackagePublishedApplicationAsGzip_565745(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Packages a published LUIS application as a GZip file to be used in the LUIS container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   slotName: JString (required)
  ##           : The publishing slot name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565747 = path.getOrDefault("appId")
  valid_565747 = validateParameter(valid_565747, JString, required = true,
                                 default = nil)
  if valid_565747 != nil:
    section.add "appId", valid_565747
  var valid_565748 = path.getOrDefault("slotName")
  valid_565748 = validateParameter(valid_565748, JString, required = true,
                                 default = nil)
  if valid_565748 != nil:
    section.add "slotName", valid_565748
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565749: Call_AppsPackagePublishedApplicationAsGzip_565744;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Packages a published LUIS application as a GZip file to be used in the LUIS container.
  ## 
  let valid = call_565749.validator(path, query, header, formData, body)
  let scheme = call_565749.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565749.url(scheme.get, call_565749.host, call_565749.base,
                         call_565749.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565749, url, valid)

proc call*(call_565750: Call_AppsPackagePublishedApplicationAsGzip_565744;
          appId: string; slotName: string): Recallable =
  ## appsPackagePublishedApplicationAsGzip
  ## Packages a published LUIS application as a GZip file to be used in the LUIS container.
  ##   appId: string (required)
  ##        : The application ID.
  ##   slotName: string (required)
  ##           : The publishing slot name.
  var path_565751 = newJObject()
  add(path_565751, "appId", newJString(appId))
  add(path_565751, "slotName", newJString(slotName))
  result = call_565750.call(path_565751, nil, nil, nil, nil)

var appsPackagePublishedApplicationAsGzip* = Call_AppsPackagePublishedApplicationAsGzip_565744(
    name: "appsPackagePublishedApplicationAsGzip", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/package/{appId}/slot/{slotName}/gzip",
    validator: validate_AppsPackagePublishedApplicationAsGzip_565745, base: "",
    url: url_AppsPackagePublishedApplicationAsGzip_565746, schemes: {Scheme.Https})
type
  Call_AppsPackageTrainedApplicationAsGzip_565752 = ref object of OpenApiRestCall_563566
proc url_AppsPackageTrainedApplicationAsGzip_565754(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/package/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/gzip")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsPackageTrainedApplicationAsGzip_565753(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Packages trained LUIS application as GZip file to be used in the LUIS container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_565755 = path.getOrDefault("appId")
  valid_565755 = validateParameter(valid_565755, JString, required = true,
                                 default = nil)
  if valid_565755 != nil:
    section.add "appId", valid_565755
  var valid_565756 = path.getOrDefault("versionId")
  valid_565756 = validateParameter(valid_565756, JString, required = true,
                                 default = nil)
  if valid_565756 != nil:
    section.add "versionId", valid_565756
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565757: Call_AppsPackageTrainedApplicationAsGzip_565752;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Packages trained LUIS application as GZip file to be used in the LUIS container.
  ## 
  let valid = call_565757.validator(path, query, header, formData, body)
  let scheme = call_565757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565757.url(scheme.get, call_565757.host, call_565757.base,
                         call_565757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565757, url, valid)

proc call*(call_565758: Call_AppsPackageTrainedApplicationAsGzip_565752;
          appId: string; versionId: string): Recallable =
  ## appsPackageTrainedApplicationAsGzip
  ## Packages trained LUIS application as GZip file to be used in the LUIS container.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565759 = newJObject()
  add(path_565759, "appId", newJString(appId))
  add(path_565759, "versionId", newJString(versionId))
  result = call_565758.call(path_565759, nil, nil, nil, nil)

var appsPackageTrainedApplicationAsGzip* = Call_AppsPackageTrainedApplicationAsGzip_565752(
    name: "appsPackageTrainedApplicationAsGzip", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/package/{appId}/versions/{versionId}/gzip",
    validator: validate_AppsPackageTrainedApplicationAsGzip_565753, base: "",
    url: url_AppsPackageTrainedApplicationAsGzip_565754, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
