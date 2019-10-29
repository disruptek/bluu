
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: LUIS Programmatic
## version: v2.0
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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
  macServiceName = "cognitiveservices-LUIS-Programmatic"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppsAdd_564100 = ref object of OpenApiRestCall_563565
proc url_AppsAdd_564102(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsAdd_564101(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##                          : A model containing Name, Description (optional), Culture, Usage Scenario (optional), Domain (optional) and initial version ID (optional) of the application. Default value for the version ID is 0.1. Note: the culture cannot be changed after the app is created.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564104: Call_AppsAdd_564100; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new LUIS app.
  ## 
  let valid = call_564104.validator(path, query, header, formData, body)
  let scheme = call_564104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564104.url(scheme.get, call_564104.host, call_564104.base,
                         call_564104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564104, url, valid)

proc call*(call_564105: Call_AppsAdd_564100; applicationCreateObject: JsonNode): Recallable =
  ## appsAdd
  ## Creates a new LUIS app.
  ##   applicationCreateObject: JObject (required)
  ##                          : A model containing Name, Description (optional), Culture, Usage Scenario (optional), Domain (optional) and initial version ID (optional) of the application. Default value for the version ID is 0.1. Note: the culture cannot be changed after the app is created.
  var body_564106 = newJObject()
  if applicationCreateObject != nil:
    body_564106 = applicationCreateObject
  result = call_564105.call(nil, nil, nil, nil, body_564106)

var appsAdd* = Call_AppsAdd_564100(name: "appsAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/apps/",
                                validator: validate_AppsAdd_564101,
                                base: "/luis/api/v2.0", url: url_AppsAdd_564102,
                                schemes: {Scheme.Https})
type
  Call_AppsList_563787 = ref object of OpenApiRestCall_563565
proc url_AppsList_563789(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsList_563788(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the user applications.
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
  var valid_563964 = query.getOrDefault("take")
  valid_563964 = validateParameter(valid_563964, JInt, required = false,
                                 default = newJInt(100))
  if valid_563964 != nil:
    section.add "take", valid_563964
  var valid_563965 = query.getOrDefault("skip")
  valid_563965 = validateParameter(valid_563965, JInt, required = false,
                                 default = newJInt(0))
  if valid_563965 != nil:
    section.add "skip", valid_563965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563988: Call_AppsList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the user applications.
  ## 
  let valid = call_563988.validator(path, query, header, formData, body)
  let scheme = call_563988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563988.url(scheme.get, call_563988.host, call_563988.base,
                         call_563988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563988, url, valid)

proc call*(call_564059: Call_AppsList_563787; take: int = 100; skip: int = 0): Recallable =
  ## appsList
  ## Lists all of the user applications.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  var query_564060 = newJObject()
  add(query_564060, "take", newJInt(take))
  add(query_564060, "skip", newJInt(skip))
  result = call_564059.call(nil, query_564060, nil, nil, nil)

var appsList* = Call_AppsList_563787(name: "appsList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/apps/",
                                  validator: validate_AppsList_563788,
                                  base: "/luis/api/v2.0", url: url_AppsList_563789,
                                  schemes: {Scheme.Https})
type
  Call_AppsListCortanaEndpoints_564107 = ref object of OpenApiRestCall_563565
proc url_AppsListCortanaEndpoints_564109(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListCortanaEndpoints_564108(path: JsonNode; query: JsonNode;
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

proc call*(call_564110: Call_AppsListCortanaEndpoints_564107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  ## 
  let valid = call_564110.validator(path, query, header, formData, body)
  let scheme = call_564110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564110.url(scheme.get, call_564110.host, call_564110.base,
                         call_564110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564110, url, valid)

proc call*(call_564111: Call_AppsListCortanaEndpoints_564107): Recallable =
  ## appsListCortanaEndpoints
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  result = call_564111.call(nil, nil, nil, nil, nil)

var appsListCortanaEndpoints* = Call_AppsListCortanaEndpoints_564107(
    name: "appsListCortanaEndpoints", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/assistants", validator: validate_AppsListCortanaEndpoints_564108,
    base: "/luis/api/v2.0", url: url_AppsListCortanaEndpoints_564109,
    schemes: {Scheme.Https})
type
  Call_AppsListSupportedCultures_564112 = ref object of OpenApiRestCall_563565
proc url_AppsListSupportedCultures_564114(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListSupportedCultures_564113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the supported application cultures.
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

proc call*(call_564115: Call_AppsListSupportedCultures_564112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the supported application cultures.
  ## 
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_AppsListSupportedCultures_564112): Recallable =
  ## appsListSupportedCultures
  ## Gets the supported application cultures.
  result = call_564116.call(nil, nil, nil, nil, nil)

var appsListSupportedCultures* = Call_AppsListSupportedCultures_564112(
    name: "appsListSupportedCultures", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/cultures",
    validator: validate_AppsListSupportedCultures_564113, base: "/luis/api/v2.0",
    url: url_AppsListSupportedCultures_564114, schemes: {Scheme.Https})
type
  Call_AppsAddCustomPrebuiltDomain_564122 = ref object of OpenApiRestCall_563565
proc url_AppsAddCustomPrebuiltDomain_564124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsAddCustomPrebuiltDomain_564123(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a prebuilt domain along with its models as a new application.
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

proc call*(call_564126: Call_AppsAddCustomPrebuiltDomain_564122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a prebuilt domain along with its models as a new application.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_AppsAddCustomPrebuiltDomain_564122;
          prebuiltDomainCreateObject: JsonNode): Recallable =
  ## appsAddCustomPrebuiltDomain
  ## Adds a prebuilt domain along with its models as a new application.
  ##   prebuiltDomainCreateObject: JObject (required)
  ##                             : A prebuilt domain create object containing the name and culture of the domain.
  var body_564128 = newJObject()
  if prebuiltDomainCreateObject != nil:
    body_564128 = prebuiltDomainCreateObject
  result = call_564127.call(nil, nil, nil, nil, body_564128)

var appsAddCustomPrebuiltDomain* = Call_AppsAddCustomPrebuiltDomain_564122(
    name: "appsAddCustomPrebuiltDomain", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/customprebuiltdomains",
    validator: validate_AppsAddCustomPrebuiltDomain_564123,
    base: "/luis/api/v2.0", url: url_AppsAddCustomPrebuiltDomain_564124,
    schemes: {Scheme.Https})
type
  Call_AppsListAvailableCustomPrebuiltDomains_564117 = ref object of OpenApiRestCall_563565
proc url_AppsListAvailableCustomPrebuiltDomains_564119(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListAvailableCustomPrebuiltDomains_564118(path: JsonNode;
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

proc call*(call_564120: Call_AppsListAvailableCustomPrebuiltDomains_564117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available custom prebuilt domains for all cultures.
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_AppsListAvailableCustomPrebuiltDomains_564117): Recallable =
  ## appsListAvailableCustomPrebuiltDomains
  ## Gets all the available custom prebuilt domains for all cultures.
  result = call_564121.call(nil, nil, nil, nil, nil)

var appsListAvailableCustomPrebuiltDomains* = Call_AppsListAvailableCustomPrebuiltDomains_564117(
    name: "appsListAvailableCustomPrebuiltDomains", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/customprebuiltdomains",
    validator: validate_AppsListAvailableCustomPrebuiltDomains_564118,
    base: "/luis/api/v2.0", url: url_AppsListAvailableCustomPrebuiltDomains_564119,
    schemes: {Scheme.Https})
type
  Call_AppsListAvailableCustomPrebuiltDomainsForCulture_564129 = ref object of OpenApiRestCall_563565
proc url_AppsListAvailableCustomPrebuiltDomainsForCulture_564131(
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

proc validate_AppsListAvailableCustomPrebuiltDomainsForCulture_564130(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets all the available custom prebuilt domains for a specific culture.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   culture: JString (required)
  ##          : Culture.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `culture` field"
  var valid_564146 = path.getOrDefault("culture")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "culture", valid_564146
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564147: Call_AppsListAvailableCustomPrebuiltDomainsForCulture_564129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available custom prebuilt domains for a specific culture.
  ## 
  let valid = call_564147.validator(path, query, header, formData, body)
  let scheme = call_564147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564147.url(scheme.get, call_564147.host, call_564147.base,
                         call_564147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564147, url, valid)

proc call*(call_564148: Call_AppsListAvailableCustomPrebuiltDomainsForCulture_564129;
          culture: string): Recallable =
  ## appsListAvailableCustomPrebuiltDomainsForCulture
  ## Gets all the available custom prebuilt domains for a specific culture.
  ##   culture: string (required)
  ##          : Culture.
  var path_564149 = newJObject()
  add(path_564149, "culture", newJString(culture))
  result = call_564148.call(path_564149, nil, nil, nil, nil)

var appsListAvailableCustomPrebuiltDomainsForCulture* = Call_AppsListAvailableCustomPrebuiltDomainsForCulture_564129(
    name: "appsListAvailableCustomPrebuiltDomainsForCulture",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/customprebuiltdomains/{culture}",
    validator: validate_AppsListAvailableCustomPrebuiltDomainsForCulture_564130,
    base: "/luis/api/v2.0",
    url: url_AppsListAvailableCustomPrebuiltDomainsForCulture_564131,
    schemes: {Scheme.Https})
type
  Call_AppsListDomains_564150 = ref object of OpenApiRestCall_563565
proc url_AppsListDomains_564152(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListDomains_564151(path: JsonNode; query: JsonNode;
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

proc call*(call_564153: Call_AppsListDomains_564150; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available application domains.
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_AppsListDomains_564150): Recallable =
  ## appsListDomains
  ## Gets the available application domains.
  result = call_564154.call(nil, nil, nil, nil, nil)

var appsListDomains* = Call_AppsListDomains_564150(name: "appsListDomains",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/domains",
    validator: validate_AppsListDomains_564151, base: "/luis/api/v2.0",
    url: url_AppsListDomains_564152, schemes: {Scheme.Https})
type
  Call_AppsImport_564155 = ref object of OpenApiRestCall_563565
proc url_AppsImport_564157(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsImport_564156(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports an application to LUIS, the application's structure should be included in in the request body.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   appName: JString
  ##          : The application name to create. If not specified, the application name will be read from the imported object.
  section = newJObject()
  var valid_564158 = query.getOrDefault("appName")
  valid_564158 = validateParameter(valid_564158, JString, required = false,
                                 default = nil)
  if valid_564158 != nil:
    section.add "appName", valid_564158
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

proc call*(call_564160: Call_AppsImport_564155; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an application to LUIS, the application's structure should be included in in the request body.
  ## 
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_AppsImport_564155; luisApp: JsonNode;
          appName: string = ""): Recallable =
  ## appsImport
  ## Imports an application to LUIS, the application's structure should be included in in the request body.
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  ##   appName: string
  ##          : The application name to create. If not specified, the application name will be read from the imported object.
  var query_564162 = newJObject()
  var body_564163 = newJObject()
  if luisApp != nil:
    body_564163 = luisApp
  add(query_564162, "appName", newJString(appName))
  result = call_564161.call(nil, query_564162, nil, nil, body_564163)

var appsImport* = Call_AppsImport_564155(name: "appsImport",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/apps/import",
                                      validator: validate_AppsImport_564156,
                                      base: "/luis/api/v2.0", url: url_AppsImport_564157,
                                      schemes: {Scheme.Https})
type
  Call_AppsListUsageScenarios_564164 = ref object of OpenApiRestCall_563565
proc url_AppsListUsageScenarios_564166(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListUsageScenarios_564165(path: JsonNode; query: JsonNode;
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

proc call*(call_564167: Call_AppsListUsageScenarios_564164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application available usage scenarios.
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_AppsListUsageScenarios_564164): Recallable =
  ## appsListUsageScenarios
  ## Gets the application available usage scenarios.
  result = call_564168.call(nil, nil, nil, nil, nil)

var appsListUsageScenarios* = Call_AppsListUsageScenarios_564164(
    name: "appsListUsageScenarios", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/usagescenarios", validator: validate_AppsListUsageScenarios_564165,
    base: "/luis/api/v2.0", url: url_AppsListUsageScenarios_564166,
    schemes: {Scheme.Https})
type
  Call_AppsUpdate_564176 = ref object of OpenApiRestCall_563565
proc url_AppsUpdate_564178(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsUpdate_564177(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564179 = path.getOrDefault("appId")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "appId", valid_564179
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

proc call*(call_564181: Call_AppsUpdate_564176; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or description of the application.
  ## 
  let valid = call_564181.validator(path, query, header, formData, body)
  let scheme = call_564181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564181.url(scheme.get, call_564181.host, call_564181.base,
                         call_564181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564181, url, valid)

proc call*(call_564182: Call_AppsUpdate_564176; appId: string;
          applicationUpdateObject: JsonNode): Recallable =
  ## appsUpdate
  ## Updates the name or description of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   applicationUpdateObject: JObject (required)
  ##                          : A model containing Name and Description of the application.
  var path_564183 = newJObject()
  var body_564184 = newJObject()
  add(path_564183, "appId", newJString(appId))
  if applicationUpdateObject != nil:
    body_564184 = applicationUpdateObject
  result = call_564182.call(path_564183, nil, nil, nil, body_564184)

var appsUpdate* = Call_AppsUpdate_564176(name: "appsUpdate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local", route: "/apps/{appId}",
                                      validator: validate_AppsUpdate_564177,
                                      base: "/luis/api/v2.0", url: url_AppsUpdate_564178,
                                      schemes: {Scheme.Https})
type
  Call_AppsGet_564169 = ref object of OpenApiRestCall_563565
proc url_AppsGet_564171(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsGet_564170(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564172 = path.getOrDefault("appId")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "appId", valid_564172
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564173: Call_AppsGet_564169; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application info.
  ## 
  let valid = call_564173.validator(path, query, header, formData, body)
  let scheme = call_564173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564173.url(scheme.get, call_564173.host, call_564173.base,
                         call_564173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564173, url, valid)

proc call*(call_564174: Call_AppsGet_564169; appId: string): Recallable =
  ## appsGet
  ## Gets the application info.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564175 = newJObject()
  add(path_564175, "appId", newJString(appId))
  result = call_564174.call(path_564175, nil, nil, nil, nil)

var appsGet* = Call_AppsGet_564169(name: "appsGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/apps/{appId}",
                                validator: validate_AppsGet_564170,
                                base: "/luis/api/v2.0", url: url_AppsGet_564171,
                                schemes: {Scheme.Https})
type
  Call_AppsDelete_564185 = ref object of OpenApiRestCall_563565
proc url_AppsDelete_564187(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsDelete_564186(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564188 = path.getOrDefault("appId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "appId", valid_564188
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564189: Call_AppsDelete_564185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application.
  ## 
  let valid = call_564189.validator(path, query, header, formData, body)
  let scheme = call_564189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564189.url(scheme.get, call_564189.host, call_564189.base,
                         call_564189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564189, url, valid)

proc call*(call_564190: Call_AppsDelete_564185; appId: string): Recallable =
  ## appsDelete
  ## Deletes an application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564191 = newJObject()
  add(path_564191, "appId", newJString(appId))
  result = call_564190.call(path_564191, nil, nil, nil, nil)

var appsDelete* = Call_AppsDelete_564185(name: "appsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local", route: "/apps/{appId}",
                                      validator: validate_AppsDelete_564186,
                                      base: "/luis/api/v2.0", url: url_AppsDelete_564187,
                                      schemes: {Scheme.Https})
type
  Call_AppsListEndpoints_564192 = ref object of OpenApiRestCall_563565
proc url_AppsListEndpoints_564194(protocol: Scheme; host: string; base: string;
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

proc validate_AppsListEndpoints_564193(path: JsonNode; query: JsonNode;
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
  var valid_564195 = path.getOrDefault("appId")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "appId", valid_564195
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564196: Call_AppsListEndpoints_564192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the available endpoint deployment regions and URLs.
  ## 
  let valid = call_564196.validator(path, query, header, formData, body)
  let scheme = call_564196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564196.url(scheme.get, call_564196.host, call_564196.base,
                         call_564196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564196, url, valid)

proc call*(call_564197: Call_AppsListEndpoints_564192; appId: string): Recallable =
  ## appsListEndpoints
  ## Returns the available endpoint deployment regions and URLs.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564198 = newJObject()
  add(path_564198, "appId", newJString(appId))
  result = call_564197.call(path_564198, nil, nil, nil, nil)

var appsListEndpoints* = Call_AppsListEndpoints_564192(name: "appsListEndpoints",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/endpoints",
    validator: validate_AppsListEndpoints_564193, base: "/luis/api/v2.0",
    url: url_AppsListEndpoints_564194, schemes: {Scheme.Https})
type
  Call_PermissionsUpdate_564206 = ref object of OpenApiRestCall_563565
proc url_PermissionsUpdate_564208(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsUpdate_564207(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Replaces the current users access list with the one sent in the body. If an empty list is sent, all access to other users will be removed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564209 = path.getOrDefault("appId")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "appId", valid_564209
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   collaborators: JObject (required)
  ##                : A model containing a list of user's email addresses.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564211: Call_PermissionsUpdate_564206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces the current users access list with the one sent in the body. If an empty list is sent, all access to other users will be removed.
  ## 
  let valid = call_564211.validator(path, query, header, formData, body)
  let scheme = call_564211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564211.url(scheme.get, call_564211.host, call_564211.base,
                         call_564211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564211, url, valid)

proc call*(call_564212: Call_PermissionsUpdate_564206; collaborators: JsonNode;
          appId: string): Recallable =
  ## permissionsUpdate
  ## Replaces the current users access list with the one sent in the body. If an empty list is sent, all access to other users will be removed.
  ##   collaborators: JObject (required)
  ##                : A model containing a list of user's email addresses.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564213 = newJObject()
  var body_564214 = newJObject()
  if collaborators != nil:
    body_564214 = collaborators
  add(path_564213, "appId", newJString(appId))
  result = call_564212.call(path_564213, nil, nil, nil, body_564214)

var permissionsUpdate* = Call_PermissionsUpdate_564206(name: "permissionsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsUpdate_564207,
    base: "/luis/api/v2.0", url: url_PermissionsUpdate_564208,
    schemes: {Scheme.Https})
type
  Call_PermissionsAdd_564215 = ref object of OpenApiRestCall_563565
proc url_PermissionsAdd_564217(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsAdd_564216(path: JsonNode; query: JsonNode;
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
  var valid_564218 = path.getOrDefault("appId")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "appId", valid_564218
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

proc call*(call_564220: Call_PermissionsAdd_564215; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ## 
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_PermissionsAdd_564215; userToAdd: JsonNode;
          appId: string): Recallable =
  ## permissionsAdd
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ##   userToAdd: JObject (required)
  ##            : A model containing the user's email address.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564222 = newJObject()
  var body_564223 = newJObject()
  if userToAdd != nil:
    body_564223 = userToAdd
  add(path_564222, "appId", newJString(appId))
  result = call_564221.call(path_564222, nil, nil, nil, body_564223)

var permissionsAdd* = Call_PermissionsAdd_564215(name: "permissionsAdd",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsAdd_564216,
    base: "/luis/api/v2.0", url: url_PermissionsAdd_564217, schemes: {Scheme.Https})
type
  Call_PermissionsList_564199 = ref object of OpenApiRestCall_563565
proc url_PermissionsList_564201(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsList_564200(path: JsonNode; query: JsonNode;
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
  var valid_564202 = path.getOrDefault("appId")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "appId", valid_564202
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564203: Call_PermissionsList_564199; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of user emails that have permissions to access your application.
  ## 
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_PermissionsList_564199; appId: string): Recallable =
  ## permissionsList
  ## Gets the list of user emails that have permissions to access your application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564205 = newJObject()
  add(path_564205, "appId", newJString(appId))
  result = call_564204.call(path_564205, nil, nil, nil, nil)

var permissionsList* = Call_PermissionsList_564199(name: "permissionsList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsList_564200,
    base: "/luis/api/v2.0", url: url_PermissionsList_564201, schemes: {Scheme.Https})
type
  Call_PermissionsDelete_564224 = ref object of OpenApiRestCall_563565
proc url_PermissionsDelete_564226(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsDelete_564225(path: JsonNode; query: JsonNode;
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
  var valid_564227 = path.getOrDefault("appId")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "appId", valid_564227
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

proc call*(call_564229: Call_PermissionsDelete_564224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ## 
  let valid = call_564229.validator(path, query, header, formData, body)
  let scheme = call_564229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564229.url(scheme.get, call_564229.host, call_564229.base,
                         call_564229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564229, url, valid)

proc call*(call_564230: Call_PermissionsDelete_564224; userToDelete: JsonNode;
          appId: string): Recallable =
  ## permissionsDelete
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ##   userToDelete: JObject (required)
  ##               : A model containing the user's email address.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564231 = newJObject()
  var body_564232 = newJObject()
  if userToDelete != nil:
    body_564232 = userToDelete
  add(path_564231, "appId", newJString(appId))
  result = call_564230.call(path_564231, nil, nil, nil, body_564232)

var permissionsDelete* = Call_PermissionsDelete_564224(name: "permissionsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsDelete_564225,
    base: "/luis/api/v2.0", url: url_PermissionsDelete_564226,
    schemes: {Scheme.Https})
type
  Call_AppsPublish_564233 = ref object of OpenApiRestCall_563565
proc url_AppsPublish_564235(protocol: Scheme; host: string; base: string;
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

proc validate_AppsPublish_564234(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564236 = path.getOrDefault("appId")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "appId", valid_564236
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

proc call*(call_564238: Call_AppsPublish_564233; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a specific version of the application.
  ## 
  let valid = call_564238.validator(path, query, header, formData, body)
  let scheme = call_564238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564238.url(scheme.get, call_564238.host, call_564238.base,
                         call_564238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564238, url, valid)

proc call*(call_564239: Call_AppsPublish_564233; appId: string;
          applicationPublishObject: JsonNode): Recallable =
  ## appsPublish
  ## Publishes a specific version of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   applicationPublishObject: JObject (required)
  ##                           : The application publish object. The region is the target region that the application is published to.
  var path_564240 = newJObject()
  var body_564241 = newJObject()
  add(path_564240, "appId", newJString(appId))
  if applicationPublishObject != nil:
    body_564241 = applicationPublishObject
  result = call_564239.call(path_564240, nil, nil, nil, body_564241)

var appsPublish* = Call_AppsPublish_564233(name: "appsPublish",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local",
                                        route: "/apps/{appId}/publish",
                                        validator: validate_AppsPublish_564234,
                                        base: "/luis/api/v2.0",
                                        url: url_AppsPublish_564235,
                                        schemes: {Scheme.Https})
type
  Call_AppsDownloadQueryLogs_564242 = ref object of OpenApiRestCall_563565
proc url_AppsDownloadQueryLogs_564244(protocol: Scheme; host: string; base: string;
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

proc validate_AppsDownloadQueryLogs_564243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the query logs of the past month for the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564245 = path.getOrDefault("appId")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "appId", valid_564245
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564246: Call_AppsDownloadQueryLogs_564242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the query logs of the past month for the application.
  ## 
  let valid = call_564246.validator(path, query, header, formData, body)
  let scheme = call_564246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564246.url(scheme.get, call_564246.host, call_564246.base,
                         call_564246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564246, url, valid)

proc call*(call_564247: Call_AppsDownloadQueryLogs_564242; appId: string): Recallable =
  ## appsDownloadQueryLogs
  ## Gets the query logs of the past month for the application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564248 = newJObject()
  add(path_564248, "appId", newJString(appId))
  result = call_564247.call(path_564248, nil, nil, nil, nil)

var appsDownloadQueryLogs* = Call_AppsDownloadQueryLogs_564242(
    name: "appsDownloadQueryLogs", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/querylogs", validator: validate_AppsDownloadQueryLogs_564243,
    base: "/luis/api/v2.0", url: url_AppsDownloadQueryLogs_564244,
    schemes: {Scheme.Https})
type
  Call_AppsUpdateSettings_564256 = ref object of OpenApiRestCall_563565
proc url_AppsUpdateSettings_564258(protocol: Scheme; host: string; base: string;
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

proc validate_AppsUpdateSettings_564257(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the application settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564259 = path.getOrDefault("appId")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "appId", valid_564259
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

proc call*(call_564261: Call_AppsUpdateSettings_564256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the application settings.
  ## 
  let valid = call_564261.validator(path, query, header, formData, body)
  let scheme = call_564261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564261.url(scheme.get, call_564261.host, call_564261.base,
                         call_564261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564261, url, valid)

proc call*(call_564262: Call_AppsUpdateSettings_564256;
          applicationSettingUpdateObject: JsonNode; appId: string): Recallable =
  ## appsUpdateSettings
  ## Updates the application settings.
  ##   applicationSettingUpdateObject: JObject (required)
  ##                                 : An object containing the new application settings.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564263 = newJObject()
  var body_564264 = newJObject()
  if applicationSettingUpdateObject != nil:
    body_564264 = applicationSettingUpdateObject
  add(path_564263, "appId", newJString(appId))
  result = call_564262.call(path_564263, nil, nil, nil, body_564264)

var appsUpdateSettings* = Call_AppsUpdateSettings_564256(
    name: "appsUpdateSettings", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/settings", validator: validate_AppsUpdateSettings_564257,
    base: "/luis/api/v2.0", url: url_AppsUpdateSettings_564258,
    schemes: {Scheme.Https})
type
  Call_AppsGetSettings_564249 = ref object of OpenApiRestCall_563565
proc url_AppsGetSettings_564251(protocol: Scheme; host: string; base: string;
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

proc validate_AppsGetSettings_564250(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the application settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564252 = path.getOrDefault("appId")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "appId", valid_564252
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564253: Call_AppsGetSettings_564249; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the application settings.
  ## 
  let valid = call_564253.validator(path, query, header, formData, body)
  let scheme = call_564253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564253.url(scheme.get, call_564253.host, call_564253.base,
                         call_564253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564253, url, valid)

proc call*(call_564254: Call_AppsGetSettings_564249; appId: string): Recallable =
  ## appsGetSettings
  ## Get the application settings.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564255 = newJObject()
  add(path_564255, "appId", newJString(appId))
  result = call_564254.call(path_564255, nil, nil, nil, nil)

var appsGetSettings* = Call_AppsGetSettings_564249(name: "appsGetSettings",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/settings",
    validator: validate_AppsGetSettings_564250, base: "/luis/api/v2.0",
    url: url_AppsGetSettings_564251, schemes: {Scheme.Https})
type
  Call_VersionsList_564265 = ref object of OpenApiRestCall_563565
proc url_VersionsList_564267(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsList_564266(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the application versions info.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564268 = path.getOrDefault("appId")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "appId", valid_564268
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564269 = query.getOrDefault("take")
  valid_564269 = validateParameter(valid_564269, JInt, required = false,
                                 default = newJInt(100))
  if valid_564269 != nil:
    section.add "take", valid_564269
  var valid_564270 = query.getOrDefault("skip")
  valid_564270 = validateParameter(valid_564270, JInt, required = false,
                                 default = newJInt(0))
  if valid_564270 != nil:
    section.add "skip", valid_564270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564271: Call_VersionsList_564265; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application versions info.
  ## 
  let valid = call_564271.validator(path, query, header, formData, body)
  let scheme = call_564271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564271.url(scheme.get, call_564271.host, call_564271.base,
                         call_564271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564271, url, valid)

proc call*(call_564272: Call_VersionsList_564265; appId: string; take: int = 100;
          skip: int = 0): Recallable =
  ## versionsList
  ## Gets the application versions info.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564273 = newJObject()
  var query_564274 = newJObject()
  add(query_564274, "take", newJInt(take))
  add(query_564274, "skip", newJInt(skip))
  add(path_564273, "appId", newJString(appId))
  result = call_564272.call(path_564273, query_564274, nil, nil, nil)

var versionsList* = Call_VersionsList_564265(name: "versionsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions",
    validator: validate_VersionsList_564266, base: "/luis/api/v2.0",
    url: url_VersionsList_564267, schemes: {Scheme.Https})
type
  Call_VersionsImport_564275 = ref object of OpenApiRestCall_563565
proc url_VersionsImport_564277(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsImport_564276(path: JsonNode; query: JsonNode;
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
  var valid_564278 = path.getOrDefault("appId")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "appId", valid_564278
  result.add "path", section
  ## parameters in `query` object:
  ##   versionId: JString
  ##            : The new versionId to import. If not specified, the versionId will be read from the imported object.
  section = newJObject()
  var valid_564279 = query.getOrDefault("versionId")
  valid_564279 = validateParameter(valid_564279, JString, required = false,
                                 default = nil)
  if valid_564279 != nil:
    section.add "versionId", valid_564279
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

proc call*(call_564281: Call_VersionsImport_564275; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a new version into a LUIS application.
  ## 
  let valid = call_564281.validator(path, query, header, formData, body)
  let scheme = call_564281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564281.url(scheme.get, call_564281.host, call_564281.base,
                         call_564281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564281, url, valid)

proc call*(call_564282: Call_VersionsImport_564275; luisApp: JsonNode; appId: string;
          versionId: string = ""): Recallable =
  ## versionsImport
  ## Imports a new version into a LUIS application.
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  ##   versionId: string
  ##            : The new versionId to import. If not specified, the versionId will be read from the imported object.
  ##   appId: string (required)
  ##        : The application ID.
  var path_564283 = newJObject()
  var query_564284 = newJObject()
  var body_564285 = newJObject()
  if luisApp != nil:
    body_564285 = luisApp
  add(query_564284, "versionId", newJString(versionId))
  add(path_564283, "appId", newJString(appId))
  result = call_564282.call(path_564283, query_564284, nil, nil, body_564285)

var versionsImport* = Call_VersionsImport_564275(name: "versionsImport",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/import", validator: validate_VersionsImport_564276,
    base: "/luis/api/v2.0", url: url_VersionsImport_564277, schemes: {Scheme.Https})
type
  Call_VersionsUpdate_564294 = ref object of OpenApiRestCall_563565
proc url_VersionsUpdate_564296(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsUpdate_564295(path: JsonNode; query: JsonNode;
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
  var valid_564297 = path.getOrDefault("appId")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "appId", valid_564297
  var valid_564298 = path.getOrDefault("versionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "versionId", valid_564298
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

proc call*(call_564300: Call_VersionsUpdate_564294; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or description of the application version.
  ## 
  let valid = call_564300.validator(path, query, header, formData, body)
  let scheme = call_564300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564300.url(scheme.get, call_564300.host, call_564300.base,
                         call_564300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564300, url, valid)

proc call*(call_564301: Call_VersionsUpdate_564294; versionUpdateObject: JsonNode;
          appId: string; versionId: string): Recallable =
  ## versionsUpdate
  ## Updates the name or description of the application version.
  ##   versionUpdateObject: JObject (required)
  ##                      : A model containing Name and Description of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564302 = newJObject()
  var body_564303 = newJObject()
  if versionUpdateObject != nil:
    body_564303 = versionUpdateObject
  add(path_564302, "appId", newJString(appId))
  add(path_564302, "versionId", newJString(versionId))
  result = call_564301.call(path_564302, nil, nil, nil, body_564303)

var versionsUpdate* = Call_VersionsUpdate_564294(name: "versionsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/",
    validator: validate_VersionsUpdate_564295, base: "/luis/api/v2.0",
    url: url_VersionsUpdate_564296, schemes: {Scheme.Https})
type
  Call_VersionsGet_564286 = ref object of OpenApiRestCall_563565
proc url_VersionsGet_564288(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsGet_564287(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the version info.
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
  var valid_564289 = path.getOrDefault("appId")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "appId", valid_564289
  var valid_564290 = path.getOrDefault("versionId")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "versionId", valid_564290
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564291: Call_VersionsGet_564286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the version info.
  ## 
  let valid = call_564291.validator(path, query, header, formData, body)
  let scheme = call_564291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564291.url(scheme.get, call_564291.host, call_564291.base,
                         call_564291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564291, url, valid)

proc call*(call_564292: Call_VersionsGet_564286; appId: string; versionId: string): Recallable =
  ## versionsGet
  ## Gets the version info.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564293 = newJObject()
  add(path_564293, "appId", newJString(appId))
  add(path_564293, "versionId", newJString(versionId))
  result = call_564292.call(path_564293, nil, nil, nil, nil)

var versionsGet* = Call_VersionsGet_564286(name: "versionsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/apps/{appId}/versions/{versionId}/",
                                        validator: validate_VersionsGet_564287,
                                        base: "/luis/api/v2.0",
                                        url: url_VersionsGet_564288,
                                        schemes: {Scheme.Https})
type
  Call_VersionsDelete_564304 = ref object of OpenApiRestCall_563565
proc url_VersionsDelete_564306(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsDelete_564305(path: JsonNode; query: JsonNode;
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
  var valid_564307 = path.getOrDefault("appId")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "appId", valid_564307
  var valid_564308 = path.getOrDefault("versionId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "versionId", valid_564308
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564309: Call_VersionsDelete_564304; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application version.
  ## 
  let valid = call_564309.validator(path, query, header, formData, body)
  let scheme = call_564309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564309.url(scheme.get, call_564309.host, call_564309.base,
                         call_564309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564309, url, valid)

proc call*(call_564310: Call_VersionsDelete_564304; appId: string; versionId: string): Recallable =
  ## versionsDelete
  ## Deletes an application version.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564311 = newJObject()
  add(path_564311, "appId", newJString(appId))
  add(path_564311, "versionId", newJString(versionId))
  result = call_564310.call(path_564311, nil, nil, nil, nil)

var versionsDelete* = Call_VersionsDelete_564304(name: "versionsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/",
    validator: validate_VersionsDelete_564305, base: "/luis/api/v2.0",
    url: url_VersionsDelete_564306, schemes: {Scheme.Https})
type
  Call_VersionsClone_564312 = ref object of OpenApiRestCall_563565
proc url_VersionsClone_564314(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsClone_564313(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new version using the current snapshot of the selected application version.
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
  var valid_564315 = path.getOrDefault("appId")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "appId", valid_564315
  var valid_564316 = path.getOrDefault("versionId")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "versionId", valid_564316
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   versionCloneObject: JObject
  ##                     : A model containing the new version ID.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564318: Call_VersionsClone_564312; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new version using the current snapshot of the selected application version.
  ## 
  let valid = call_564318.validator(path, query, header, formData, body)
  let scheme = call_564318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564318.url(scheme.get, call_564318.host, call_564318.base,
                         call_564318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564318, url, valid)

proc call*(call_564319: Call_VersionsClone_564312; appId: string; versionId: string;
          versionCloneObject: JsonNode = nil): Recallable =
  ## versionsClone
  ## Creates a new version using the current snapshot of the selected application version.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionCloneObject: JObject
  ##                     : A model containing the new version ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564320 = newJObject()
  var body_564321 = newJObject()
  add(path_564320, "appId", newJString(appId))
  if versionCloneObject != nil:
    body_564321 = versionCloneObject
  add(path_564320, "versionId", newJString(versionId))
  result = call_564319.call(path_564320, nil, nil, nil, body_564321)

var versionsClone* = Call_VersionsClone_564312(name: "versionsClone",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/clone",
    validator: validate_VersionsClone_564313, base: "/luis/api/v2.0",
    url: url_VersionsClone_564314, schemes: {Scheme.Https})
type
  Call_ModelAddClosedList_564333 = ref object of OpenApiRestCall_563565
proc url_ModelAddClosedList_564335(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddClosedList_564334(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Adds a closed list model to the application.
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
  ## parameters in `body` object:
  ##   closedListModelCreateObject: JObject (required)
  ##                              : A model containing the name and words for the new closed list entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564339: Call_ModelAddClosedList_564333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a closed list model to the application.
  ## 
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_ModelAddClosedList_564333;
          closedListModelCreateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelAddClosedList
  ## Adds a closed list model to the application.
  ##   closedListModelCreateObject: JObject (required)
  ##                              : A model containing the name and words for the new closed list entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564341 = newJObject()
  var body_564342 = newJObject()
  if closedListModelCreateObject != nil:
    body_564342 = closedListModelCreateObject
  add(path_564341, "appId", newJString(appId))
  add(path_564341, "versionId", newJString(versionId))
  result = call_564340.call(path_564341, nil, nil, nil, body_564342)

var modelAddClosedList* = Call_ModelAddClosedList_564333(
    name: "modelAddClosedList", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists",
    validator: validate_ModelAddClosedList_564334, base: "/luis/api/v2.0",
    url: url_ModelAddClosedList_564335, schemes: {Scheme.Https})
type
  Call_ModelListClosedLists_564322 = ref object of OpenApiRestCall_563565
proc url_ModelListClosedLists_564324(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListClosedLists_564323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the closedlist models.
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
  var valid_564325 = path.getOrDefault("appId")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "appId", valid_564325
  var valid_564326 = path.getOrDefault("versionId")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "versionId", valid_564326
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564327 = query.getOrDefault("take")
  valid_564327 = validateParameter(valid_564327, JInt, required = false,
                                 default = newJInt(100))
  if valid_564327 != nil:
    section.add "take", valid_564327
  var valid_564328 = query.getOrDefault("skip")
  valid_564328 = validateParameter(valid_564328, JInt, required = false,
                                 default = newJInt(0))
  if valid_564328 != nil:
    section.add "skip", valid_564328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564329: Call_ModelListClosedLists_564322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the closedlist models.
  ## 
  let valid = call_564329.validator(path, query, header, formData, body)
  let scheme = call_564329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564329.url(scheme.get, call_564329.host, call_564329.base,
                         call_564329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564329, url, valid)

proc call*(call_564330: Call_ModelListClosedLists_564322; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListClosedLists
  ## Gets information about the closedlist models.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564331 = newJObject()
  var query_564332 = newJObject()
  add(query_564332, "take", newJInt(take))
  add(query_564332, "skip", newJInt(skip))
  add(path_564331, "appId", newJString(appId))
  add(path_564331, "versionId", newJString(versionId))
  result = call_564330.call(path_564331, query_564332, nil, nil, nil)

var modelListClosedLists* = Call_ModelListClosedLists_564322(
    name: "modelListClosedLists", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists",
    validator: validate_ModelListClosedLists_564323, base: "/luis/api/v2.0",
    url: url_ModelListClosedLists_564324, schemes: {Scheme.Https})
type
  Call_ModelUpdateClosedList_564352 = ref object of OpenApiRestCall_563565
proc url_ModelUpdateClosedList_564354(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateClosedList_564353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the closed list model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The closed list model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564355 = path.getOrDefault("clEntityId")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "clEntityId", valid_564355
  var valid_564356 = path.getOrDefault("appId")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "appId", valid_564356
  var valid_564357 = path.getOrDefault("versionId")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "versionId", valid_564357
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   closedListModelUpdateObject: JObject (required)
  ##                              : The new entity name and words list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564359: Call_ModelUpdateClosedList_564352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the closed list model.
  ## 
  let valid = call_564359.validator(path, query, header, formData, body)
  let scheme = call_564359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564359.url(scheme.get, call_564359.host, call_564359.base,
                         call_564359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564359, url, valid)

proc call*(call_564360: Call_ModelUpdateClosedList_564352; clEntityId: string;
          closedListModelUpdateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelUpdateClosedList
  ## Updates the closed list model.
  ##   clEntityId: string (required)
  ##             : The closed list model ID.
  ##   closedListModelUpdateObject: JObject (required)
  ##                              : The new entity name and words list.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564361 = newJObject()
  var body_564362 = newJObject()
  add(path_564361, "clEntityId", newJString(clEntityId))
  if closedListModelUpdateObject != nil:
    body_564362 = closedListModelUpdateObject
  add(path_564361, "appId", newJString(appId))
  add(path_564361, "versionId", newJString(versionId))
  result = call_564360.call(path_564361, nil, nil, nil, body_564362)

var modelUpdateClosedList* = Call_ModelUpdateClosedList_564352(
    name: "modelUpdateClosedList", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelUpdateClosedList_564353, base: "/luis/api/v2.0",
    url: url_ModelUpdateClosedList_564354, schemes: {Scheme.Https})
type
  Call_ModelGetClosedList_564343 = ref object of OpenApiRestCall_563565
proc url_ModelGetClosedList_564345(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetClosedList_564344(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets information of a closed list model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The closed list model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564346 = path.getOrDefault("clEntityId")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "clEntityId", valid_564346
  var valid_564347 = path.getOrDefault("appId")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "appId", valid_564347
  var valid_564348 = path.getOrDefault("versionId")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "versionId", valid_564348
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564349: Call_ModelGetClosedList_564343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information of a closed list model.
  ## 
  let valid = call_564349.validator(path, query, header, formData, body)
  let scheme = call_564349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564349.url(scheme.get, call_564349.host, call_564349.base,
                         call_564349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564349, url, valid)

proc call*(call_564350: Call_ModelGetClosedList_564343; clEntityId: string;
          appId: string; versionId: string): Recallable =
  ## modelGetClosedList
  ## Gets information of a closed list model.
  ##   clEntityId: string (required)
  ##             : The closed list model ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564351 = newJObject()
  add(path_564351, "clEntityId", newJString(clEntityId))
  add(path_564351, "appId", newJString(appId))
  add(path_564351, "versionId", newJString(versionId))
  result = call_564350.call(path_564351, nil, nil, nil, nil)

var modelGetClosedList* = Call_ModelGetClosedList_564343(
    name: "modelGetClosedList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelGetClosedList_564344, base: "/luis/api/v2.0",
    url: url_ModelGetClosedList_564345, schemes: {Scheme.Https})
type
  Call_ModelPatchClosedList_564372 = ref object of OpenApiRestCall_563565
proc url_ModelPatchClosedList_564374(protocol: Scheme; host: string; base: string;
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

proc validate_ModelPatchClosedList_564373(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a batch of sublists to an existing closedlist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The closed list model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564375 = path.getOrDefault("clEntityId")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "clEntityId", valid_564375
  var valid_564376 = path.getOrDefault("appId")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "appId", valid_564376
  var valid_564377 = path.getOrDefault("versionId")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "versionId", valid_564377
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

proc call*(call_564379: Call_ModelPatchClosedList_564372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a batch of sublists to an existing closedlist.
  ## 
  let valid = call_564379.validator(path, query, header, formData, body)
  let scheme = call_564379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564379.url(scheme.get, call_564379.host, call_564379.base,
                         call_564379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564379, url, valid)

proc call*(call_564380: Call_ModelPatchClosedList_564372; clEntityId: string;
          closedListModelPatchObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelPatchClosedList
  ## Adds a batch of sublists to an existing closedlist.
  ##   clEntityId: string (required)
  ##             : The closed list model ID.
  ##   closedListModelPatchObject: JObject (required)
  ##                             : A words list batch.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564381 = newJObject()
  var body_564382 = newJObject()
  add(path_564381, "clEntityId", newJString(clEntityId))
  if closedListModelPatchObject != nil:
    body_564382 = closedListModelPatchObject
  add(path_564381, "appId", newJString(appId))
  add(path_564381, "versionId", newJString(versionId))
  result = call_564380.call(path_564381, nil, nil, nil, body_564382)

var modelPatchClosedList* = Call_ModelPatchClosedList_564372(
    name: "modelPatchClosedList", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelPatchClosedList_564373, base: "/luis/api/v2.0",
    url: url_ModelPatchClosedList_564374, schemes: {Scheme.Https})
type
  Call_ModelDeleteClosedList_564363 = ref object of OpenApiRestCall_563565
proc url_ModelDeleteClosedList_564365(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteClosedList_564364(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a closed list model from the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The closed list model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564366 = path.getOrDefault("clEntityId")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "clEntityId", valid_564366
  var valid_564367 = path.getOrDefault("appId")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "appId", valid_564367
  var valid_564368 = path.getOrDefault("versionId")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "versionId", valid_564368
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564369: Call_ModelDeleteClosedList_564363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a closed list model from the application.
  ## 
  let valid = call_564369.validator(path, query, header, formData, body)
  let scheme = call_564369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564369.url(scheme.get, call_564369.host, call_564369.base,
                         call_564369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564369, url, valid)

proc call*(call_564370: Call_ModelDeleteClosedList_564363; clEntityId: string;
          appId: string; versionId: string): Recallable =
  ## modelDeleteClosedList
  ## Deletes a closed list model from the application.
  ##   clEntityId: string (required)
  ##             : The closed list model ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564371 = newJObject()
  add(path_564371, "clEntityId", newJString(clEntityId))
  add(path_564371, "appId", newJString(appId))
  add(path_564371, "versionId", newJString(versionId))
  result = call_564370.call(path_564371, nil, nil, nil, nil)

var modelDeleteClosedList* = Call_ModelDeleteClosedList_564363(
    name: "modelDeleteClosedList", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelDeleteClosedList_564364, base: "/luis/api/v2.0",
    url: url_ModelDeleteClosedList_564365, schemes: {Scheme.Https})
type
  Call_ModelAddSubList_564383 = ref object of OpenApiRestCall_563565
proc url_ModelAddSubList_564385(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddSubList_564384(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Adds a list to an existing closed list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The closed list entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564386 = path.getOrDefault("clEntityId")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "clEntityId", valid_564386
  var valid_564387 = path.getOrDefault("appId")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "appId", valid_564387
  var valid_564388 = path.getOrDefault("versionId")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "versionId", valid_564388
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

proc call*(call_564390: Call_ModelAddSubList_564383; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a list to an existing closed list.
  ## 
  let valid = call_564390.validator(path, query, header, formData, body)
  let scheme = call_564390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564390.url(scheme.get, call_564390.host, call_564390.base,
                         call_564390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564390, url, valid)

proc call*(call_564391: Call_ModelAddSubList_564383; clEntityId: string;
          wordListCreateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelAddSubList
  ## Adds a list to an existing closed list.
  ##   clEntityId: string (required)
  ##             : The closed list entity extractor ID.
  ##   wordListCreateObject: JObject (required)
  ##                       : Words list.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564392 = newJObject()
  var body_564393 = newJObject()
  add(path_564392, "clEntityId", newJString(clEntityId))
  if wordListCreateObject != nil:
    body_564393 = wordListCreateObject
  add(path_564392, "appId", newJString(appId))
  add(path_564392, "versionId", newJString(versionId))
  result = call_564391.call(path_564392, nil, nil, nil, body_564393)

var modelAddSubList* = Call_ModelAddSubList_564383(name: "modelAddSubList",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists",
    validator: validate_ModelAddSubList_564384, base: "/luis/api/v2.0",
    url: url_ModelAddSubList_564385, schemes: {Scheme.Https})
type
  Call_ModelUpdateSubList_564394 = ref object of OpenApiRestCall_563565
proc url_ModelUpdateSubList_564396(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateSubList_564395(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates one of the closed list's sublists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The closed list entity extractor ID.
  ##   subListId: JInt (required)
  ##            : The sublist ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564397 = path.getOrDefault("clEntityId")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "clEntityId", valid_564397
  var valid_564398 = path.getOrDefault("subListId")
  valid_564398 = validateParameter(valid_564398, JInt, required = true, default = nil)
  if valid_564398 != nil:
    section.add "subListId", valid_564398
  var valid_564399 = path.getOrDefault("appId")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "appId", valid_564399
  var valid_564400 = path.getOrDefault("versionId")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "versionId", valid_564400
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

proc call*(call_564402: Call_ModelUpdateSubList_564394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates one of the closed list's sublists.
  ## 
  let valid = call_564402.validator(path, query, header, formData, body)
  let scheme = call_564402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564402.url(scheme.get, call_564402.host, call_564402.base,
                         call_564402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564402, url, valid)

proc call*(call_564403: Call_ModelUpdateSubList_564394; clEntityId: string;
          subListId: int; appId: string; versionId: string;
          wordListBaseUpdateObject: JsonNode): Recallable =
  ## modelUpdateSubList
  ## Updates one of the closed list's sublists.
  ##   clEntityId: string (required)
  ##             : The closed list entity extractor ID.
  ##   subListId: int (required)
  ##            : The sublist ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   wordListBaseUpdateObject: JObject (required)
  ##                           : A sublist update object containing the new canonical form and the list of words.
  var path_564404 = newJObject()
  var body_564405 = newJObject()
  add(path_564404, "clEntityId", newJString(clEntityId))
  add(path_564404, "subListId", newJInt(subListId))
  add(path_564404, "appId", newJString(appId))
  add(path_564404, "versionId", newJString(versionId))
  if wordListBaseUpdateObject != nil:
    body_564405 = wordListBaseUpdateObject
  result = call_564403.call(path_564404, nil, nil, nil, body_564405)

var modelUpdateSubList* = Call_ModelUpdateSubList_564394(
    name: "modelUpdateSubList", meth: HttpMethod.HttpPut, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists/{subListId}",
    validator: validate_ModelUpdateSubList_564395, base: "/luis/api/v2.0",
    url: url_ModelUpdateSubList_564396, schemes: {Scheme.Https})
type
  Call_ModelDeleteSubList_564406 = ref object of OpenApiRestCall_563565
proc url_ModelDeleteSubList_564408(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteSubList_564407(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a sublist of a specific closed list model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clEntityId: JString (required)
  ##             : The closed list entity extractor ID.
  ##   subListId: JInt (required)
  ##            : The sublist ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The version ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clEntityId` field"
  var valid_564409 = path.getOrDefault("clEntityId")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "clEntityId", valid_564409
  var valid_564410 = path.getOrDefault("subListId")
  valid_564410 = validateParameter(valid_564410, JInt, required = true, default = nil)
  if valid_564410 != nil:
    section.add "subListId", valid_564410
  var valid_564411 = path.getOrDefault("appId")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "appId", valid_564411
  var valid_564412 = path.getOrDefault("versionId")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "versionId", valid_564412
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564413: Call_ModelDeleteSubList_564406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a sublist of a specific closed list model.
  ## 
  let valid = call_564413.validator(path, query, header, formData, body)
  let scheme = call_564413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564413.url(scheme.get, call_564413.host, call_564413.base,
                         call_564413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564413, url, valid)

proc call*(call_564414: Call_ModelDeleteSubList_564406; clEntityId: string;
          subListId: int; appId: string; versionId: string): Recallable =
  ## modelDeleteSubList
  ## Deletes a sublist of a specific closed list model.
  ##   clEntityId: string (required)
  ##             : The closed list entity extractor ID.
  ##   subListId: int (required)
  ##            : The sublist ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564415 = newJObject()
  add(path_564415, "clEntityId", newJString(clEntityId))
  add(path_564415, "subListId", newJInt(subListId))
  add(path_564415, "appId", newJString(appId))
  add(path_564415, "versionId", newJString(versionId))
  result = call_564414.call(path_564415, nil, nil, nil, nil)

var modelDeleteSubList* = Call_ModelDeleteSubList_564406(
    name: "modelDeleteSubList", meth: HttpMethod.HttpDelete, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists/{subListId}",
    validator: validate_ModelDeleteSubList_564407, base: "/luis/api/v2.0",
    url: url_ModelDeleteSubList_564408, schemes: {Scheme.Https})
type
  Call_ModelAddCompositeEntity_564427 = ref object of OpenApiRestCall_563565
proc url_ModelAddCompositeEntity_564429(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddCompositeEntity_564428(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a composite entity extractor to the application.
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
  var valid_564430 = path.getOrDefault("appId")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "appId", valid_564430
  var valid_564431 = path.getOrDefault("versionId")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "versionId", valid_564431
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

proc call*(call_564433: Call_ModelAddCompositeEntity_564427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a composite entity extractor to the application.
  ## 
  let valid = call_564433.validator(path, query, header, formData, body)
  let scheme = call_564433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564433.url(scheme.get, call_564433.host, call_564433.base,
                         call_564433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564433, url, valid)

proc call*(call_564434: Call_ModelAddCompositeEntity_564427;
          compositeModelCreateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelAddCompositeEntity
  ## Adds a composite entity extractor to the application.
  ##   compositeModelCreateObject: JObject (required)
  ##                             : A model containing the name and children of the new entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564435 = newJObject()
  var body_564436 = newJObject()
  if compositeModelCreateObject != nil:
    body_564436 = compositeModelCreateObject
  add(path_564435, "appId", newJString(appId))
  add(path_564435, "versionId", newJString(versionId))
  result = call_564434.call(path_564435, nil, nil, nil, body_564436)

var modelAddCompositeEntity* = Call_ModelAddCompositeEntity_564427(
    name: "modelAddCompositeEntity", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities",
    validator: validate_ModelAddCompositeEntity_564428, base: "/luis/api/v2.0",
    url: url_ModelAddCompositeEntity_564429, schemes: {Scheme.Https})
type
  Call_ModelListCompositeEntities_564416 = ref object of OpenApiRestCall_563565
proc url_ModelListCompositeEntities_564418(protocol: Scheme; host: string;
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

proc validate_ModelListCompositeEntities_564417(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the composite entity models.
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
  var valid_564419 = path.getOrDefault("appId")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "appId", valid_564419
  var valid_564420 = path.getOrDefault("versionId")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "versionId", valid_564420
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564421 = query.getOrDefault("take")
  valid_564421 = validateParameter(valid_564421, JInt, required = false,
                                 default = newJInt(100))
  if valid_564421 != nil:
    section.add "take", valid_564421
  var valid_564422 = query.getOrDefault("skip")
  valid_564422 = validateParameter(valid_564422, JInt, required = false,
                                 default = newJInt(0))
  if valid_564422 != nil:
    section.add "skip", valid_564422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564423: Call_ModelListCompositeEntities_564416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the composite entity models.
  ## 
  let valid = call_564423.validator(path, query, header, formData, body)
  let scheme = call_564423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564423.url(scheme.get, call_564423.host, call_564423.base,
                         call_564423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564423, url, valid)

proc call*(call_564424: Call_ModelListCompositeEntities_564416; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListCompositeEntities
  ## Gets information about the composite entity models.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564425 = newJObject()
  var query_564426 = newJObject()
  add(query_564426, "take", newJInt(take))
  add(query_564426, "skip", newJInt(skip))
  add(path_564425, "appId", newJString(appId))
  add(path_564425, "versionId", newJString(versionId))
  result = call_564424.call(path_564425, query_564426, nil, nil, nil)

var modelListCompositeEntities* = Call_ModelListCompositeEntities_564416(
    name: "modelListCompositeEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities",
    validator: validate_ModelListCompositeEntities_564417, base: "/luis/api/v2.0",
    url: url_ModelListCompositeEntities_564418, schemes: {Scheme.Https})
type
  Call_ModelUpdateCompositeEntity_564446 = ref object of OpenApiRestCall_563565
proc url_ModelUpdateCompositeEntity_564448(protocol: Scheme; host: string;
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

proc validate_ModelUpdateCompositeEntity_564447(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the composite entity extractor.
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
  var valid_564449 = path.getOrDefault("cEntityId")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "cEntityId", valid_564449
  var valid_564450 = path.getOrDefault("appId")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "appId", valid_564450
  var valid_564451 = path.getOrDefault("versionId")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "versionId", valid_564451
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

proc call*(call_564453: Call_ModelUpdateCompositeEntity_564446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the composite entity extractor.
  ## 
  let valid = call_564453.validator(path, query, header, formData, body)
  let scheme = call_564453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564453.url(scheme.get, call_564453.host, call_564453.base,
                         call_564453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564453, url, valid)

proc call*(call_564454: Call_ModelUpdateCompositeEntity_564446; cEntityId: string;
          compositeModelUpdateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelUpdateCompositeEntity
  ## Updates the composite entity extractor.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   compositeModelUpdateObject: JObject (required)
  ##                             : A model object containing the new entity extractor name and children.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564455 = newJObject()
  var body_564456 = newJObject()
  add(path_564455, "cEntityId", newJString(cEntityId))
  if compositeModelUpdateObject != nil:
    body_564456 = compositeModelUpdateObject
  add(path_564455, "appId", newJString(appId))
  add(path_564455, "versionId", newJString(versionId))
  result = call_564454.call(path_564455, nil, nil, nil, body_564456)

var modelUpdateCompositeEntity* = Call_ModelUpdateCompositeEntity_564446(
    name: "modelUpdateCompositeEntity", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelUpdateCompositeEntity_564447, base: "/luis/api/v2.0",
    url: url_ModelUpdateCompositeEntity_564448, schemes: {Scheme.Https})
type
  Call_ModelGetCompositeEntity_564437 = ref object of OpenApiRestCall_563565
proc url_ModelGetCompositeEntity_564439(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetCompositeEntity_564438(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the composite entity model.
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
  var valid_564440 = path.getOrDefault("cEntityId")
  valid_564440 = validateParameter(valid_564440, JString, required = true,
                                 default = nil)
  if valid_564440 != nil:
    section.add "cEntityId", valid_564440
  var valid_564441 = path.getOrDefault("appId")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "appId", valid_564441
  var valid_564442 = path.getOrDefault("versionId")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "versionId", valid_564442
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564443: Call_ModelGetCompositeEntity_564437; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the composite entity model.
  ## 
  let valid = call_564443.validator(path, query, header, formData, body)
  let scheme = call_564443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564443.url(scheme.get, call_564443.host, call_564443.base,
                         call_564443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564443, url, valid)

proc call*(call_564444: Call_ModelGetCompositeEntity_564437; cEntityId: string;
          appId: string; versionId: string): Recallable =
  ## modelGetCompositeEntity
  ## Gets information about the composite entity model.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564445 = newJObject()
  add(path_564445, "cEntityId", newJString(cEntityId))
  add(path_564445, "appId", newJString(appId))
  add(path_564445, "versionId", newJString(versionId))
  result = call_564444.call(path_564445, nil, nil, nil, nil)

var modelGetCompositeEntity* = Call_ModelGetCompositeEntity_564437(
    name: "modelGetCompositeEntity", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelGetCompositeEntity_564438, base: "/luis/api/v2.0",
    url: url_ModelGetCompositeEntity_564439, schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntity_564457 = ref object of OpenApiRestCall_563565
proc url_ModelDeleteCompositeEntity_564459(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCompositeEntity_564458(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a composite entity extractor from the application.
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
  var valid_564460 = path.getOrDefault("cEntityId")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "cEntityId", valid_564460
  var valid_564461 = path.getOrDefault("appId")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "appId", valid_564461
  var valid_564462 = path.getOrDefault("versionId")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "versionId", valid_564462
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564463: Call_ModelDeleteCompositeEntity_564457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a composite entity extractor from the application.
  ## 
  let valid = call_564463.validator(path, query, header, formData, body)
  let scheme = call_564463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564463.url(scheme.get, call_564463.host, call_564463.base,
                         call_564463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564463, url, valid)

proc call*(call_564464: Call_ModelDeleteCompositeEntity_564457; cEntityId: string;
          appId: string; versionId: string): Recallable =
  ## modelDeleteCompositeEntity
  ## Deletes a composite entity extractor from the application.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564465 = newJObject()
  add(path_564465, "cEntityId", newJString(cEntityId))
  add(path_564465, "appId", newJString(appId))
  add(path_564465, "versionId", newJString(versionId))
  result = call_564464.call(path_564465, nil, nil, nil, nil)

var modelDeleteCompositeEntity* = Call_ModelDeleteCompositeEntity_564457(
    name: "modelDeleteCompositeEntity", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelDeleteCompositeEntity_564458, base: "/luis/api/v2.0",
    url: url_ModelDeleteCompositeEntity_564459, schemes: {Scheme.Https})
type
  Call_ModelAddCompositeEntityChild_564466 = ref object of OpenApiRestCall_563565
proc url_ModelAddCompositeEntityChild_564468(protocol: Scheme; host: string;
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

proc validate_ModelAddCompositeEntityChild_564467(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a single child in an existing composite entity model.
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
  var valid_564469 = path.getOrDefault("cEntityId")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "cEntityId", valid_564469
  var valid_564470 = path.getOrDefault("appId")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "appId", valid_564470
  var valid_564471 = path.getOrDefault("versionId")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "versionId", valid_564471
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

proc call*(call_564473: Call_ModelAddCompositeEntityChild_564466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a single child in an existing composite entity model.
  ## 
  let valid = call_564473.validator(path, query, header, formData, body)
  let scheme = call_564473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564473.url(scheme.get, call_564473.host, call_564473.base,
                         call_564473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564473, url, valid)

proc call*(call_564474: Call_ModelAddCompositeEntityChild_564466;
          cEntityId: string; appId: string;
          compositeChildModelCreateObject: JsonNode; versionId: string): Recallable =
  ## modelAddCompositeEntityChild
  ## Creates a single child in an existing composite entity model.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   compositeChildModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the new composite child model.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564475 = newJObject()
  var body_564476 = newJObject()
  add(path_564475, "cEntityId", newJString(cEntityId))
  add(path_564475, "appId", newJString(appId))
  if compositeChildModelCreateObject != nil:
    body_564476 = compositeChildModelCreateObject
  add(path_564475, "versionId", newJString(versionId))
  result = call_564474.call(path_564475, nil, nil, nil, body_564476)

var modelAddCompositeEntityChild* = Call_ModelAddCompositeEntityChild_564466(
    name: "modelAddCompositeEntityChild", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/children",
    validator: validate_ModelAddCompositeEntityChild_564467,
    base: "/luis/api/v2.0", url: url_ModelAddCompositeEntityChild_564468,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntityChild_564477 = ref object of OpenApiRestCall_563565
proc url_ModelDeleteCompositeEntityChild_564479(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCompositeEntityChild_564478(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a composite entity extractor child from the application.
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
  var valid_564480 = path.getOrDefault("cEntityId")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "cEntityId", valid_564480
  var valid_564481 = path.getOrDefault("cChildId")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "cChildId", valid_564481
  var valid_564482 = path.getOrDefault("appId")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "appId", valid_564482
  var valid_564483 = path.getOrDefault("versionId")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "versionId", valid_564483
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564484: Call_ModelDeleteCompositeEntityChild_564477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a composite entity extractor child from the application.
  ## 
  let valid = call_564484.validator(path, query, header, formData, body)
  let scheme = call_564484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564484.url(scheme.get, call_564484.host, call_564484.base,
                         call_564484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564484, url, valid)

proc call*(call_564485: Call_ModelDeleteCompositeEntityChild_564477;
          cEntityId: string; cChildId: string; appId: string; versionId: string): Recallable =
  ## modelDeleteCompositeEntityChild
  ## Deletes a composite entity extractor child from the application.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  ##   cChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564486 = newJObject()
  add(path_564486, "cEntityId", newJString(cEntityId))
  add(path_564486, "cChildId", newJString(cChildId))
  add(path_564486, "appId", newJString(appId))
  add(path_564486, "versionId", newJString(versionId))
  result = call_564485.call(path_564486, nil, nil, nil, nil)

var modelDeleteCompositeEntityChild* = Call_ModelDeleteCompositeEntityChild_564477(
    name: "modelDeleteCompositeEntityChild", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/children/{cChildId}",
    validator: validate_ModelDeleteCompositeEntityChild_564478,
    base: "/luis/api/v2.0", url: url_ModelDeleteCompositeEntityChild_564479,
    schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltDomain_564487 = ref object of OpenApiRestCall_563565
proc url_ModelAddCustomPrebuiltDomain_564489(protocol: Scheme; host: string;
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

proc validate_ModelAddCustomPrebuiltDomain_564488(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a customizable prebuilt domain along with all of its models to this application.
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
  var valid_564490 = path.getOrDefault("appId")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "appId", valid_564490
  var valid_564491 = path.getOrDefault("versionId")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "versionId", valid_564491
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

proc call*(call_564493: Call_ModelAddCustomPrebuiltDomain_564487; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a customizable prebuilt domain along with all of its models to this application.
  ## 
  let valid = call_564493.validator(path, query, header, formData, body)
  let scheme = call_564493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564493.url(scheme.get, call_564493.host, call_564493.base,
                         call_564493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564493, url, valid)

proc call*(call_564494: Call_ModelAddCustomPrebuiltDomain_564487; appId: string;
          prebuiltDomainObject: JsonNode; versionId: string): Recallable =
  ## modelAddCustomPrebuiltDomain
  ## Adds a customizable prebuilt domain along with all of its models to this application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   prebuiltDomainObject: JObject (required)
  ##                       : A prebuilt domain create object containing the name of the domain.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564495 = newJObject()
  var body_564496 = newJObject()
  add(path_564495, "appId", newJString(appId))
  if prebuiltDomainObject != nil:
    body_564496 = prebuiltDomainObject
  add(path_564495, "versionId", newJString(versionId))
  result = call_564494.call(path_564495, nil, nil, nil, body_564496)

var modelAddCustomPrebuiltDomain* = Call_ModelAddCustomPrebuiltDomain_564487(
    name: "modelAddCustomPrebuiltDomain", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltdomains",
    validator: validate_ModelAddCustomPrebuiltDomain_564488,
    base: "/luis/api/v2.0", url: url_ModelAddCustomPrebuiltDomain_564489,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteCustomPrebuiltDomain_564497 = ref object of OpenApiRestCall_563565
proc url_ModelDeleteCustomPrebuiltDomain_564499(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCustomPrebuiltDomain_564498(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a prebuilt domain's models from the application.
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
  var valid_564500 = path.getOrDefault("appId")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "appId", valid_564500
  var valid_564501 = path.getOrDefault("domainName")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "domainName", valid_564501
  var valid_564502 = path.getOrDefault("versionId")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "versionId", valid_564502
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564503: Call_ModelDeleteCustomPrebuiltDomain_564497;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a prebuilt domain's models from the application.
  ## 
  let valid = call_564503.validator(path, query, header, formData, body)
  let scheme = call_564503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564503.url(scheme.get, call_564503.host, call_564503.base,
                         call_564503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564503, url, valid)

proc call*(call_564504: Call_ModelDeleteCustomPrebuiltDomain_564497; appId: string;
          domainName: string; versionId: string): Recallable =
  ## modelDeleteCustomPrebuiltDomain
  ## Deletes a prebuilt domain's models from the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   domainName: string (required)
  ##             : Domain name.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564505 = newJObject()
  add(path_564505, "appId", newJString(appId))
  add(path_564505, "domainName", newJString(domainName))
  add(path_564505, "versionId", newJString(versionId))
  result = call_564504.call(path_564505, nil, nil, nil, nil)

var modelDeleteCustomPrebuiltDomain* = Call_ModelDeleteCustomPrebuiltDomain_564497(
    name: "modelDeleteCustomPrebuiltDomain", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltdomains/{domainName}",
    validator: validate_ModelDeleteCustomPrebuiltDomain_564498,
    base: "/luis/api/v2.0", url: url_ModelDeleteCustomPrebuiltDomain_564499,
    schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltEntity_564514 = ref object of OpenApiRestCall_563565
proc url_ModelAddCustomPrebuiltEntity_564516(protocol: Scheme; host: string;
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

proc validate_ModelAddCustomPrebuiltEntity_564515(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a custom prebuilt entity model to the application.
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
  var valid_564517 = path.getOrDefault("appId")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "appId", valid_564517
  var valid_564518 = path.getOrDefault("versionId")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "versionId", valid_564518
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the custom prebuilt entity and the name of the domain to which this model belongs.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564520: Call_ModelAddCustomPrebuiltEntity_564514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a custom prebuilt entity model to the application.
  ## 
  let valid = call_564520.validator(path, query, header, formData, body)
  let scheme = call_564520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564520.url(scheme.get, call_564520.host, call_564520.base,
                         call_564520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564520, url, valid)

proc call*(call_564521: Call_ModelAddCustomPrebuiltEntity_564514;
          prebuiltDomainModelCreateObject: JsonNode; appId: string;
          versionId: string): Recallable =
  ## modelAddCustomPrebuiltEntity
  ## Adds a custom prebuilt entity model to the application.
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the custom prebuilt entity and the name of the domain to which this model belongs.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564522 = newJObject()
  var body_564523 = newJObject()
  if prebuiltDomainModelCreateObject != nil:
    body_564523 = prebuiltDomainModelCreateObject
  add(path_564522, "appId", newJString(appId))
  add(path_564522, "versionId", newJString(versionId))
  result = call_564521.call(path_564522, nil, nil, nil, body_564523)

var modelAddCustomPrebuiltEntity* = Call_ModelAddCustomPrebuiltEntity_564514(
    name: "modelAddCustomPrebuiltEntity", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltentities",
    validator: validate_ModelAddCustomPrebuiltEntity_564515,
    base: "/luis/api/v2.0", url: url_ModelAddCustomPrebuiltEntity_564516,
    schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltEntities_564506 = ref object of OpenApiRestCall_563565
proc url_ModelListCustomPrebuiltEntities_564508(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltEntities_564507(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all custom prebuilt entities information of this application.
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
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564511: Call_ModelListCustomPrebuiltEntities_564506;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all custom prebuilt entities information of this application.
  ## 
  let valid = call_564511.validator(path, query, header, formData, body)
  let scheme = call_564511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564511.url(scheme.get, call_564511.host, call_564511.base,
                         call_564511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564511, url, valid)

proc call*(call_564512: Call_ModelListCustomPrebuiltEntities_564506; appId: string;
          versionId: string): Recallable =
  ## modelListCustomPrebuiltEntities
  ## Gets all custom prebuilt entities information of this application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564513 = newJObject()
  add(path_564513, "appId", newJString(appId))
  add(path_564513, "versionId", newJString(versionId))
  result = call_564512.call(path_564513, nil, nil, nil, nil)

var modelListCustomPrebuiltEntities* = Call_ModelListCustomPrebuiltEntities_564506(
    name: "modelListCustomPrebuiltEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltentities",
    validator: validate_ModelListCustomPrebuiltEntities_564507,
    base: "/luis/api/v2.0", url: url_ModelListCustomPrebuiltEntities_564508,
    schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltIntent_564532 = ref object of OpenApiRestCall_563565
proc url_ModelAddCustomPrebuiltIntent_564534(protocol: Scheme; host: string;
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

proc validate_ModelAddCustomPrebuiltIntent_564533(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a custom prebuilt intent model to the application.
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
  var valid_564535 = path.getOrDefault("appId")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "appId", valid_564535
  var valid_564536 = path.getOrDefault("versionId")
  valid_564536 = validateParameter(valid_564536, JString, required = true,
                                 default = nil)
  if valid_564536 != nil:
    section.add "versionId", valid_564536
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the custom prebuilt intent and the name of the domain to which this model belongs.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564538: Call_ModelAddCustomPrebuiltIntent_564532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a custom prebuilt intent model to the application.
  ## 
  let valid = call_564538.validator(path, query, header, formData, body)
  let scheme = call_564538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564538.url(scheme.get, call_564538.host, call_564538.base,
                         call_564538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564538, url, valid)

proc call*(call_564539: Call_ModelAddCustomPrebuiltIntent_564532;
          prebuiltDomainModelCreateObject: JsonNode; appId: string;
          versionId: string): Recallable =
  ## modelAddCustomPrebuiltIntent
  ## Adds a custom prebuilt intent model to the application.
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the custom prebuilt intent and the name of the domain to which this model belongs.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564540 = newJObject()
  var body_564541 = newJObject()
  if prebuiltDomainModelCreateObject != nil:
    body_564541 = prebuiltDomainModelCreateObject
  add(path_564540, "appId", newJString(appId))
  add(path_564540, "versionId", newJString(versionId))
  result = call_564539.call(path_564540, nil, nil, nil, body_564541)

var modelAddCustomPrebuiltIntent* = Call_ModelAddCustomPrebuiltIntent_564532(
    name: "modelAddCustomPrebuiltIntent", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltintents",
    validator: validate_ModelAddCustomPrebuiltIntent_564533,
    base: "/luis/api/v2.0", url: url_ModelAddCustomPrebuiltIntent_564534,
    schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltIntents_564524 = ref object of OpenApiRestCall_563565
proc url_ModelListCustomPrebuiltIntents_564526(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltIntents_564525(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets custom prebuilt intents information of this application.
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
  var valid_564527 = path.getOrDefault("appId")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "appId", valid_564527
  var valid_564528 = path.getOrDefault("versionId")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "versionId", valid_564528
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564529: Call_ModelListCustomPrebuiltIntents_564524; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets custom prebuilt intents information of this application.
  ## 
  let valid = call_564529.validator(path, query, header, formData, body)
  let scheme = call_564529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564529.url(scheme.get, call_564529.host, call_564529.base,
                         call_564529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564529, url, valid)

proc call*(call_564530: Call_ModelListCustomPrebuiltIntents_564524; appId: string;
          versionId: string): Recallable =
  ## modelListCustomPrebuiltIntents
  ## Gets custom prebuilt intents information of this application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564531 = newJObject()
  add(path_564531, "appId", newJString(appId))
  add(path_564531, "versionId", newJString(versionId))
  result = call_564530.call(path_564531, nil, nil, nil, nil)

var modelListCustomPrebuiltIntents* = Call_ModelListCustomPrebuiltIntents_564524(
    name: "modelListCustomPrebuiltIntents", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltintents",
    validator: validate_ModelListCustomPrebuiltIntents_564525,
    base: "/luis/api/v2.0", url: url_ModelListCustomPrebuiltIntents_564526,
    schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltModels_564542 = ref object of OpenApiRestCall_563565
proc url_ModelListCustomPrebuiltModels_564544(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltModels_564543(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all custom prebuilt models information of this application.
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
  var valid_564545 = path.getOrDefault("appId")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "appId", valid_564545
  var valid_564546 = path.getOrDefault("versionId")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "versionId", valid_564546
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564547: Call_ModelListCustomPrebuiltModels_564542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all custom prebuilt models information of this application.
  ## 
  let valid = call_564547.validator(path, query, header, formData, body)
  let scheme = call_564547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564547.url(scheme.get, call_564547.host, call_564547.base,
                         call_564547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564547, url, valid)

proc call*(call_564548: Call_ModelListCustomPrebuiltModels_564542; appId: string;
          versionId: string): Recallable =
  ## modelListCustomPrebuiltModels
  ## Gets all custom prebuilt models information of this application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564549 = newJObject()
  add(path_564549, "appId", newJString(appId))
  add(path_564549, "versionId", newJString(versionId))
  result = call_564548.call(path_564549, nil, nil, nil, nil)

var modelListCustomPrebuiltModels* = Call_ModelListCustomPrebuiltModels_564542(
    name: "modelListCustomPrebuiltModels", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltmodels",
    validator: validate_ModelListCustomPrebuiltModels_564543,
    base: "/luis/api/v2.0", url: url_ModelListCustomPrebuiltModels_564544,
    schemes: {Scheme.Https})
type
  Call_ModelAddEntity_564561 = ref object of OpenApiRestCall_563565
proc url_ModelAddEntity_564563(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddEntity_564562(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Adds an entity extractor to the application.
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
  var valid_564564 = path.getOrDefault("appId")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "appId", valid_564564
  var valid_564565 = path.getOrDefault("versionId")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "versionId", valid_564565
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   modelCreateObject: JObject (required)
  ##                    : A model object containing the name for the new entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564567: Call_ModelAddEntity_564561; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an entity extractor to the application.
  ## 
  let valid = call_564567.validator(path, query, header, formData, body)
  let scheme = call_564567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564567.url(scheme.get, call_564567.host, call_564567.base,
                         call_564567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564567, url, valid)

proc call*(call_564568: Call_ModelAddEntity_564561; modelCreateObject: JsonNode;
          appId: string; versionId: string): Recallable =
  ## modelAddEntity
  ## Adds an entity extractor to the application.
  ##   modelCreateObject: JObject (required)
  ##                    : A model object containing the name for the new entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564569 = newJObject()
  var body_564570 = newJObject()
  if modelCreateObject != nil:
    body_564570 = modelCreateObject
  add(path_564569, "appId", newJString(appId))
  add(path_564569, "versionId", newJString(versionId))
  result = call_564568.call(path_564569, nil, nil, nil, body_564570)

var modelAddEntity* = Call_ModelAddEntity_564561(name: "modelAddEntity",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities",
    validator: validate_ModelAddEntity_564562, base: "/luis/api/v2.0",
    url: url_ModelAddEntity_564563, schemes: {Scheme.Https})
type
  Call_ModelListEntities_564550 = ref object of OpenApiRestCall_563565
proc url_ModelListEntities_564552(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListEntities_564551(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets information about the entity models.
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
  var valid_564553 = path.getOrDefault("appId")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "appId", valid_564553
  var valid_564554 = path.getOrDefault("versionId")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "versionId", valid_564554
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564555 = query.getOrDefault("take")
  valid_564555 = validateParameter(valid_564555, JInt, required = false,
                                 default = newJInt(100))
  if valid_564555 != nil:
    section.add "take", valid_564555
  var valid_564556 = query.getOrDefault("skip")
  valid_564556 = validateParameter(valid_564556, JInt, required = false,
                                 default = newJInt(0))
  if valid_564556 != nil:
    section.add "skip", valid_564556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564557: Call_ModelListEntities_564550; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the entity models.
  ## 
  let valid = call_564557.validator(path, query, header, formData, body)
  let scheme = call_564557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564557.url(scheme.get, call_564557.host, call_564557.base,
                         call_564557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564557, url, valid)

proc call*(call_564558: Call_ModelListEntities_564550; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListEntities
  ## Gets information about the entity models.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564559 = newJObject()
  var query_564560 = newJObject()
  add(query_564560, "take", newJInt(take))
  add(query_564560, "skip", newJInt(skip))
  add(path_564559, "appId", newJString(appId))
  add(path_564559, "versionId", newJString(versionId))
  result = call_564558.call(path_564559, query_564560, nil, nil, nil)

var modelListEntities* = Call_ModelListEntities_564550(name: "modelListEntities",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities",
    validator: validate_ModelListEntities_564551, base: "/luis/api/v2.0",
    url: url_ModelListEntities_564552, schemes: {Scheme.Https})
type
  Call_ModelUpdateEntity_564580 = ref object of OpenApiRestCall_563565
proc url_ModelUpdateEntity_564582(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateEntity_564581(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the name of an entity extractor.
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
  var valid_564583 = path.getOrDefault("entityId")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "entityId", valid_564583
  var valid_564584 = path.getOrDefault("appId")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "appId", valid_564584
  var valid_564585 = path.getOrDefault("versionId")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "versionId", valid_564585
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

proc call*(call_564587: Call_ModelUpdateEntity_564580; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name of an entity extractor.
  ## 
  let valid = call_564587.validator(path, query, header, formData, body)
  let scheme = call_564587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564587.url(scheme.get, call_564587.host, call_564587.base,
                         call_564587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564587, url, valid)

proc call*(call_564588: Call_ModelUpdateEntity_564580; entityId: string;
          appId: string; modelUpdateObject: JsonNode; versionId: string): Recallable =
  ## modelUpdateEntity
  ## Updates the name of an entity extractor.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new entity extractor name.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564589 = newJObject()
  var body_564590 = newJObject()
  add(path_564589, "entityId", newJString(entityId))
  add(path_564589, "appId", newJString(appId))
  if modelUpdateObject != nil:
    body_564590 = modelUpdateObject
  add(path_564589, "versionId", newJString(versionId))
  result = call_564588.call(path_564589, nil, nil, nil, body_564590)

var modelUpdateEntity* = Call_ModelUpdateEntity_564580(name: "modelUpdateEntity",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelUpdateEntity_564581, base: "/luis/api/v2.0",
    url: url_ModelUpdateEntity_564582, schemes: {Scheme.Https})
type
  Call_ModelGetEntity_564571 = ref object of OpenApiRestCall_563565
proc url_ModelGetEntity_564573(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetEntity_564572(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the entity model.
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
  var valid_564574 = path.getOrDefault("entityId")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "entityId", valid_564574
  var valid_564575 = path.getOrDefault("appId")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "appId", valid_564575
  var valid_564576 = path.getOrDefault("versionId")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "versionId", valid_564576
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564577: Call_ModelGetEntity_564571; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the entity model.
  ## 
  let valid = call_564577.validator(path, query, header, formData, body)
  let scheme = call_564577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564577.url(scheme.get, call_564577.host, call_564577.base,
                         call_564577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564577, url, valid)

proc call*(call_564578: Call_ModelGetEntity_564571; entityId: string; appId: string;
          versionId: string): Recallable =
  ## modelGetEntity
  ## Gets information about the entity model.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564579 = newJObject()
  add(path_564579, "entityId", newJString(entityId))
  add(path_564579, "appId", newJString(appId))
  add(path_564579, "versionId", newJString(versionId))
  result = call_564578.call(path_564579, nil, nil, nil, nil)

var modelGetEntity* = Call_ModelGetEntity_564571(name: "modelGetEntity",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelGetEntity_564572, base: "/luis/api/v2.0",
    url: url_ModelGetEntity_564573, schemes: {Scheme.Https})
type
  Call_ModelDeleteEntity_564591 = ref object of OpenApiRestCall_563565
proc url_ModelDeleteEntity_564593(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteEntity_564592(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an entity extractor from the application.
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
  var valid_564594 = path.getOrDefault("entityId")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = nil)
  if valid_564594 != nil:
    section.add "entityId", valid_564594
  var valid_564595 = path.getOrDefault("appId")
  valid_564595 = validateParameter(valid_564595, JString, required = true,
                                 default = nil)
  if valid_564595 != nil:
    section.add "appId", valid_564595
  var valid_564596 = path.getOrDefault("versionId")
  valid_564596 = validateParameter(valid_564596, JString, required = true,
                                 default = nil)
  if valid_564596 != nil:
    section.add "versionId", valid_564596
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564597: Call_ModelDeleteEntity_564591; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an entity extractor from the application.
  ## 
  let valid = call_564597.validator(path, query, header, formData, body)
  let scheme = call_564597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564597.url(scheme.get, call_564597.host, call_564597.base,
                         call_564597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564597, url, valid)

proc call*(call_564598: Call_ModelDeleteEntity_564591; entityId: string;
          appId: string; versionId: string): Recallable =
  ## modelDeleteEntity
  ## Deletes an entity extractor from the application.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564599 = newJObject()
  add(path_564599, "entityId", newJString(entityId))
  add(path_564599, "appId", newJString(appId))
  add(path_564599, "versionId", newJString(versionId))
  result = call_564598.call(path_564599, nil, nil, nil, nil)

var modelDeleteEntity* = Call_ModelDeleteEntity_564591(name: "modelDeleteEntity",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelDeleteEntity_564592, base: "/luis/api/v2.0",
    url: url_ModelDeleteEntity_564593, schemes: {Scheme.Https})
type
  Call_ModelGetEntitySuggestions_564600 = ref object of OpenApiRestCall_563565
proc url_ModelGetEntitySuggestions_564602(protocol: Scheme; host: string;
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

proc validate_ModelGetEntitySuggestions_564601(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get suggestion examples that would improve the accuracy of the entity model.
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
  var valid_564603 = path.getOrDefault("entityId")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "entityId", valid_564603
  var valid_564604 = path.getOrDefault("appId")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = nil)
  if valid_564604 != nil:
    section.add "appId", valid_564604
  var valid_564605 = path.getOrDefault("versionId")
  valid_564605 = validateParameter(valid_564605, JString, required = true,
                                 default = nil)
  if valid_564605 != nil:
    section.add "versionId", valid_564605
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_564606 = query.getOrDefault("take")
  valid_564606 = validateParameter(valid_564606, JInt, required = false,
                                 default = newJInt(100))
  if valid_564606 != nil:
    section.add "take", valid_564606
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564607: Call_ModelGetEntitySuggestions_564600; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get suggestion examples that would improve the accuracy of the entity model.
  ## 
  let valid = call_564607.validator(path, query, header, formData, body)
  let scheme = call_564607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564607.url(scheme.get, call_564607.host, call_564607.base,
                         call_564607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564607, url, valid)

proc call*(call_564608: Call_ModelGetEntitySuggestions_564600; entityId: string;
          appId: string; versionId: string; take: int = 100): Recallable =
  ## modelGetEntitySuggestions
  ## Get suggestion examples that would improve the accuracy of the entity model.
  ##   entityId: string (required)
  ##           : The target entity extractor model to enhance.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564609 = newJObject()
  var query_564610 = newJObject()
  add(path_564609, "entityId", newJString(entityId))
  add(query_564610, "take", newJInt(take))
  add(path_564609, "appId", newJString(appId))
  add(path_564609, "versionId", newJString(versionId))
  result = call_564608.call(path_564609, query_564610, nil, nil, nil)

var modelGetEntitySuggestions* = Call_ModelGetEntitySuggestions_564600(
    name: "modelGetEntitySuggestions", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/suggest",
    validator: validate_ModelGetEntitySuggestions_564601, base: "/luis/api/v2.0",
    url: url_ModelGetEntitySuggestions_564602, schemes: {Scheme.Https})
type
  Call_ExamplesAdd_564611 = ref object of OpenApiRestCall_563565
proc url_ExamplesAdd_564613(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesAdd_564612(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a labeled example to the application.
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
  var valid_564614 = path.getOrDefault("appId")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "appId", valid_564614
  var valid_564615 = path.getOrDefault("versionId")
  valid_564615 = validateParameter(valid_564615, JString, required = true,
                                 default = nil)
  if valid_564615 != nil:
    section.add "versionId", valid_564615
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   exampleLabelObject: JObject (required)
  ##                     : An example label with the expected intent and entities.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564617: Call_ExamplesAdd_564611; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a labeled example to the application.
  ## 
  let valid = call_564617.validator(path, query, header, formData, body)
  let scheme = call_564617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564617.url(scheme.get, call_564617.host, call_564617.base,
                         call_564617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564617, url, valid)

proc call*(call_564618: Call_ExamplesAdd_564611; appId: string; versionId: string;
          exampleLabelObject: JsonNode): Recallable =
  ## examplesAdd
  ## Adds a labeled example to the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   exampleLabelObject: JObject (required)
  ##                     : An example label with the expected intent and entities.
  var path_564619 = newJObject()
  var body_564620 = newJObject()
  add(path_564619, "appId", newJString(appId))
  add(path_564619, "versionId", newJString(versionId))
  if exampleLabelObject != nil:
    body_564620 = exampleLabelObject
  result = call_564618.call(path_564619, nil, nil, nil, body_564620)

var examplesAdd* = Call_ExamplesAdd_564611(name: "examplesAdd",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/apps/{appId}/versions/{versionId}/example",
                                        validator: validate_ExamplesAdd_564612,
                                        base: "/luis/api/v2.0",
                                        url: url_ExamplesAdd_564613,
                                        schemes: {Scheme.Https})
type
  Call_ExamplesBatch_564632 = ref object of OpenApiRestCall_563565
proc url_ExamplesBatch_564634(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesBatch_564633(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a batch of labeled examples to the application.
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
  var valid_564635 = path.getOrDefault("appId")
  valid_564635 = validateParameter(valid_564635, JString, required = true,
                                 default = nil)
  if valid_564635 != nil:
    section.add "appId", valid_564635
  var valid_564636 = path.getOrDefault("versionId")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "versionId", valid_564636
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   exampleLabelObjectArray: JArray (required)
  ##                          : Array of examples.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564638: Call_ExamplesBatch_564632; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a batch of labeled examples to the application.
  ## 
  let valid = call_564638.validator(path, query, header, formData, body)
  let scheme = call_564638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564638.url(scheme.get, call_564638.host, call_564638.base,
                         call_564638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564638, url, valid)

proc call*(call_564639: Call_ExamplesBatch_564632; appId: string; versionId: string;
          exampleLabelObjectArray: JsonNode): Recallable =
  ## examplesBatch
  ## Adds a batch of labeled examples to the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   exampleLabelObjectArray: JArray (required)
  ##                          : Array of examples.
  var path_564640 = newJObject()
  var body_564641 = newJObject()
  add(path_564640, "appId", newJString(appId))
  add(path_564640, "versionId", newJString(versionId))
  if exampleLabelObjectArray != nil:
    body_564641 = exampleLabelObjectArray
  result = call_564639.call(path_564640, nil, nil, nil, body_564641)

var examplesBatch* = Call_ExamplesBatch_564632(name: "examplesBatch",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples",
    validator: validate_ExamplesBatch_564633, base: "/luis/api/v2.0",
    url: url_ExamplesBatch_564634, schemes: {Scheme.Https})
type
  Call_ExamplesList_564621 = ref object of OpenApiRestCall_563565
proc url_ExamplesList_564623(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesList_564622(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns examples to be reviewed.
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
  var valid_564624 = path.getOrDefault("appId")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "appId", valid_564624
  var valid_564625 = path.getOrDefault("versionId")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "versionId", valid_564625
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564626 = query.getOrDefault("take")
  valid_564626 = validateParameter(valid_564626, JInt, required = false,
                                 default = newJInt(100))
  if valid_564626 != nil:
    section.add "take", valid_564626
  var valid_564627 = query.getOrDefault("skip")
  valid_564627 = validateParameter(valid_564627, JInt, required = false,
                                 default = newJInt(0))
  if valid_564627 != nil:
    section.add "skip", valid_564627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564628: Call_ExamplesList_564621; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns examples to be reviewed.
  ## 
  let valid = call_564628.validator(path, query, header, formData, body)
  let scheme = call_564628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564628.url(scheme.get, call_564628.host, call_564628.base,
                         call_564628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564628, url, valid)

proc call*(call_564629: Call_ExamplesList_564621; appId: string; versionId: string;
          take: int = 100; skip: int = 0): Recallable =
  ## examplesList
  ## Returns examples to be reviewed.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564630 = newJObject()
  var query_564631 = newJObject()
  add(query_564631, "take", newJInt(take))
  add(query_564631, "skip", newJInt(skip))
  add(path_564630, "appId", newJString(appId))
  add(path_564630, "versionId", newJString(versionId))
  result = call_564629.call(path_564630, query_564631, nil, nil, nil)

var examplesList* = Call_ExamplesList_564621(name: "examplesList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples",
    validator: validate_ExamplesList_564622, base: "/luis/api/v2.0",
    url: url_ExamplesList_564623, schemes: {Scheme.Https})
type
  Call_ExamplesDelete_564642 = ref object of OpenApiRestCall_563565
proc url_ExamplesDelete_564644(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesDelete_564643(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the labeled example with the specified ID.
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
  var valid_564645 = path.getOrDefault("exampleId")
  valid_564645 = validateParameter(valid_564645, JInt, required = true, default = nil)
  if valid_564645 != nil:
    section.add "exampleId", valid_564645
  var valid_564646 = path.getOrDefault("appId")
  valid_564646 = validateParameter(valid_564646, JString, required = true,
                                 default = nil)
  if valid_564646 != nil:
    section.add "appId", valid_564646
  var valid_564647 = path.getOrDefault("versionId")
  valid_564647 = validateParameter(valid_564647, JString, required = true,
                                 default = nil)
  if valid_564647 != nil:
    section.add "versionId", valid_564647
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564648: Call_ExamplesDelete_564642; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the labeled example with the specified ID.
  ## 
  let valid = call_564648.validator(path, query, header, formData, body)
  let scheme = call_564648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564648.url(scheme.get, call_564648.host, call_564648.base,
                         call_564648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564648, url, valid)

proc call*(call_564649: Call_ExamplesDelete_564642; exampleId: int; appId: string;
          versionId: string): Recallable =
  ## examplesDelete
  ## Deletes the labeled example with the specified ID.
  ##   exampleId: int (required)
  ##            : The example ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564650 = newJObject()
  add(path_564650, "exampleId", newJInt(exampleId))
  add(path_564650, "appId", newJString(appId))
  add(path_564650, "versionId", newJString(versionId))
  result = call_564649.call(path_564650, nil, nil, nil, nil)

var examplesDelete* = Call_ExamplesDelete_564642(name: "examplesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples/{exampleId}",
    validator: validate_ExamplesDelete_564643, base: "/luis/api/v2.0",
    url: url_ExamplesDelete_564644, schemes: {Scheme.Https})
type
  Call_VersionsExport_564651 = ref object of OpenApiRestCall_563565
proc url_VersionsExport_564653(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsExport_564652(path: JsonNode; query: JsonNode;
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
  var valid_564654 = path.getOrDefault("appId")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "appId", valid_564654
  var valid_564655 = path.getOrDefault("versionId")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "versionId", valid_564655
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564656: Call_VersionsExport_564651; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a LUIS application to JSON format.
  ## 
  let valid = call_564656.validator(path, query, header, formData, body)
  let scheme = call_564656.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564656.url(scheme.get, call_564656.host, call_564656.base,
                         call_564656.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564656, url, valid)

proc call*(call_564657: Call_VersionsExport_564651; appId: string; versionId: string): Recallable =
  ## versionsExport
  ## Exports a LUIS application to JSON format.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564658 = newJObject()
  add(path_564658, "appId", newJString(appId))
  add(path_564658, "versionId", newJString(versionId))
  result = call_564657.call(path_564658, nil, nil, nil, nil)

var versionsExport* = Call_VersionsExport_564651(name: "versionsExport",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/export",
    validator: validate_VersionsExport_564652, base: "/luis/api/v2.0",
    url: url_VersionsExport_564653, schemes: {Scheme.Https})
type
  Call_FeaturesList_564659 = ref object of OpenApiRestCall_563565
proc url_FeaturesList_564661(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesList_564660(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the extraction features for the specified application version.
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
  var valid_564662 = path.getOrDefault("appId")
  valid_564662 = validateParameter(valid_564662, JString, required = true,
                                 default = nil)
  if valid_564662 != nil:
    section.add "appId", valid_564662
  var valid_564663 = path.getOrDefault("versionId")
  valid_564663 = validateParameter(valid_564663, JString, required = true,
                                 default = nil)
  if valid_564663 != nil:
    section.add "versionId", valid_564663
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564664 = query.getOrDefault("take")
  valid_564664 = validateParameter(valid_564664, JInt, required = false,
                                 default = newJInt(100))
  if valid_564664 != nil:
    section.add "take", valid_564664
  var valid_564665 = query.getOrDefault("skip")
  valid_564665 = validateParameter(valid_564665, JInt, required = false,
                                 default = newJInt(0))
  if valid_564665 != nil:
    section.add "skip", valid_564665
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564666: Call_FeaturesList_564659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the extraction features for the specified application version.
  ## 
  let valid = call_564666.validator(path, query, header, formData, body)
  let scheme = call_564666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564666.url(scheme.get, call_564666.host, call_564666.base,
                         call_564666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564666, url, valid)

proc call*(call_564667: Call_FeaturesList_564659; appId: string; versionId: string;
          take: int = 100; skip: int = 0): Recallable =
  ## featuresList
  ## Gets all the extraction features for the specified application version.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564668 = newJObject()
  var query_564669 = newJObject()
  add(query_564669, "take", newJInt(take))
  add(query_564669, "skip", newJInt(skip))
  add(path_564668, "appId", newJString(appId))
  add(path_564668, "versionId", newJString(versionId))
  result = call_564667.call(path_564668, query_564669, nil, nil, nil)

var featuresList* = Call_FeaturesList_564659(name: "featuresList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/features",
    validator: validate_FeaturesList_564660, base: "/luis/api/v2.0",
    url: url_FeaturesList_564661, schemes: {Scheme.Https})
type
  Call_ModelAddHierarchicalEntity_564681 = ref object of OpenApiRestCall_563565
proc url_ModelAddHierarchicalEntity_564683(protocol: Scheme; host: string;
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

proc validate_ModelAddHierarchicalEntity_564682(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a hierarchical entity extractor to the application version.
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
  var valid_564684 = path.getOrDefault("appId")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = nil)
  if valid_564684 != nil:
    section.add "appId", valid_564684
  var valid_564685 = path.getOrDefault("versionId")
  valid_564685 = validateParameter(valid_564685, JString, required = true,
                                 default = nil)
  if valid_564685 != nil:
    section.add "versionId", valid_564685
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

proc call*(call_564687: Call_ModelAddHierarchicalEntity_564681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a hierarchical entity extractor to the application version.
  ## 
  let valid = call_564687.validator(path, query, header, formData, body)
  let scheme = call_564687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564687.url(scheme.get, call_564687.host, call_564687.base,
                         call_564687.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564687, url, valid)

proc call*(call_564688: Call_ModelAddHierarchicalEntity_564681;
          hierarchicalModelCreateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## modelAddHierarchicalEntity
  ## Adds a hierarchical entity extractor to the application version.
  ##   hierarchicalModelCreateObject: JObject (required)
  ##                                : A model containing the name and children of the new entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564689 = newJObject()
  var body_564690 = newJObject()
  if hierarchicalModelCreateObject != nil:
    body_564690 = hierarchicalModelCreateObject
  add(path_564689, "appId", newJString(appId))
  add(path_564689, "versionId", newJString(versionId))
  result = call_564688.call(path_564689, nil, nil, nil, body_564690)

var modelAddHierarchicalEntity* = Call_ModelAddHierarchicalEntity_564681(
    name: "modelAddHierarchicalEntity", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/hierarchicalentities",
    validator: validate_ModelAddHierarchicalEntity_564682, base: "/luis/api/v2.0",
    url: url_ModelAddHierarchicalEntity_564683, schemes: {Scheme.Https})
type
  Call_ModelListHierarchicalEntities_564670 = ref object of OpenApiRestCall_563565
proc url_ModelListHierarchicalEntities_564672(protocol: Scheme; host: string;
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

proc validate_ModelListHierarchicalEntities_564671(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the hierarchical entity models.
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
  var valid_564673 = path.getOrDefault("appId")
  valid_564673 = validateParameter(valid_564673, JString, required = true,
                                 default = nil)
  if valid_564673 != nil:
    section.add "appId", valid_564673
  var valid_564674 = path.getOrDefault("versionId")
  valid_564674 = validateParameter(valid_564674, JString, required = true,
                                 default = nil)
  if valid_564674 != nil:
    section.add "versionId", valid_564674
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564675 = query.getOrDefault("take")
  valid_564675 = validateParameter(valid_564675, JInt, required = false,
                                 default = newJInt(100))
  if valid_564675 != nil:
    section.add "take", valid_564675
  var valid_564676 = query.getOrDefault("skip")
  valid_564676 = validateParameter(valid_564676, JInt, required = false,
                                 default = newJInt(0))
  if valid_564676 != nil:
    section.add "skip", valid_564676
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564677: Call_ModelListHierarchicalEntities_564670; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the hierarchical entity models.
  ## 
  let valid = call_564677.validator(path, query, header, formData, body)
  let scheme = call_564677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564677.url(scheme.get, call_564677.host, call_564677.base,
                         call_564677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564677, url, valid)

proc call*(call_564678: Call_ModelListHierarchicalEntities_564670; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListHierarchicalEntities
  ## Gets information about the hierarchical entity models.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564679 = newJObject()
  var query_564680 = newJObject()
  add(query_564680, "take", newJInt(take))
  add(query_564680, "skip", newJInt(skip))
  add(path_564679, "appId", newJString(appId))
  add(path_564679, "versionId", newJString(versionId))
  result = call_564678.call(path_564679, query_564680, nil, nil, nil)

var modelListHierarchicalEntities* = Call_ModelListHierarchicalEntities_564670(
    name: "modelListHierarchicalEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/hierarchicalentities",
    validator: validate_ModelListHierarchicalEntities_564671,
    base: "/luis/api/v2.0", url: url_ModelListHierarchicalEntities_564672,
    schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntity_564700 = ref object of OpenApiRestCall_563565
proc url_ModelUpdateHierarchicalEntity_564702(protocol: Scheme; host: string;
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

proc validate_ModelUpdateHierarchicalEntity_564701(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the name and children of a hierarchical entity model.
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
  var valid_564703 = path.getOrDefault("hEntityId")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "hEntityId", valid_564703
  var valid_564704 = path.getOrDefault("appId")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "appId", valid_564704
  var valid_564705 = path.getOrDefault("versionId")
  valid_564705 = validateParameter(valid_564705, JString, required = true,
                                 default = nil)
  if valid_564705 != nil:
    section.add "versionId", valid_564705
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

proc call*(call_564707: Call_ModelUpdateHierarchicalEntity_564700; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name and children of a hierarchical entity model.
  ## 
  let valid = call_564707.validator(path, query, header, formData, body)
  let scheme = call_564707.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564707.url(scheme.get, call_564707.host, call_564707.base,
                         call_564707.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564707, url, valid)

proc call*(call_564708: Call_ModelUpdateHierarchicalEntity_564700;
          hierarchicalModelUpdateObject: JsonNode; hEntityId: string; appId: string;
          versionId: string): Recallable =
  ## modelUpdateHierarchicalEntity
  ## Updates the name and children of a hierarchical entity model.
  ##   hierarchicalModelUpdateObject: JObject (required)
  ##                                : Model containing names of the children of the hierarchical entity.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564709 = newJObject()
  var body_564710 = newJObject()
  if hierarchicalModelUpdateObject != nil:
    body_564710 = hierarchicalModelUpdateObject
  add(path_564709, "hEntityId", newJString(hEntityId))
  add(path_564709, "appId", newJString(appId))
  add(path_564709, "versionId", newJString(versionId))
  result = call_564708.call(path_564709, nil, nil, nil, body_564710)

var modelUpdateHierarchicalEntity* = Call_ModelUpdateHierarchicalEntity_564700(
    name: "modelUpdateHierarchicalEntity", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelUpdateHierarchicalEntity_564701,
    base: "/luis/api/v2.0", url: url_ModelUpdateHierarchicalEntity_564702,
    schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntity_564691 = ref object of OpenApiRestCall_563565
proc url_ModelGetHierarchicalEntity_564693(protocol: Scheme; host: string;
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

proc validate_ModelGetHierarchicalEntity_564692(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the hierarchical entity model.
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
  var valid_564694 = path.getOrDefault("hEntityId")
  valid_564694 = validateParameter(valid_564694, JString, required = true,
                                 default = nil)
  if valid_564694 != nil:
    section.add "hEntityId", valid_564694
  var valid_564695 = path.getOrDefault("appId")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "appId", valid_564695
  var valid_564696 = path.getOrDefault("versionId")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "versionId", valid_564696
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564697: Call_ModelGetHierarchicalEntity_564691; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the hierarchical entity model.
  ## 
  let valid = call_564697.validator(path, query, header, formData, body)
  let scheme = call_564697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564697.url(scheme.get, call_564697.host, call_564697.base,
                         call_564697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564697, url, valid)

proc call*(call_564698: Call_ModelGetHierarchicalEntity_564691; hEntityId: string;
          appId: string; versionId: string): Recallable =
  ## modelGetHierarchicalEntity
  ## Gets information about the hierarchical entity model.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564699 = newJObject()
  add(path_564699, "hEntityId", newJString(hEntityId))
  add(path_564699, "appId", newJString(appId))
  add(path_564699, "versionId", newJString(versionId))
  result = call_564698.call(path_564699, nil, nil, nil, nil)

var modelGetHierarchicalEntity* = Call_ModelGetHierarchicalEntity_564691(
    name: "modelGetHierarchicalEntity", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelGetHierarchicalEntity_564692, base: "/luis/api/v2.0",
    url: url_ModelGetHierarchicalEntity_564693, schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntity_564711 = ref object of OpenApiRestCall_563565
proc url_ModelDeleteHierarchicalEntity_564713(protocol: Scheme; host: string;
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

proc validate_ModelDeleteHierarchicalEntity_564712(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a hierarchical entity extractor from the application version.
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
  var valid_564714 = path.getOrDefault("hEntityId")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = nil)
  if valid_564714 != nil:
    section.add "hEntityId", valid_564714
  var valid_564715 = path.getOrDefault("appId")
  valid_564715 = validateParameter(valid_564715, JString, required = true,
                                 default = nil)
  if valid_564715 != nil:
    section.add "appId", valid_564715
  var valid_564716 = path.getOrDefault("versionId")
  valid_564716 = validateParameter(valid_564716, JString, required = true,
                                 default = nil)
  if valid_564716 != nil:
    section.add "versionId", valid_564716
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564717: Call_ModelDeleteHierarchicalEntity_564711; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a hierarchical entity extractor from the application version.
  ## 
  let valid = call_564717.validator(path, query, header, formData, body)
  let scheme = call_564717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564717.url(scheme.get, call_564717.host, call_564717.base,
                         call_564717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564717, url, valid)

proc call*(call_564718: Call_ModelDeleteHierarchicalEntity_564711;
          hEntityId: string; appId: string; versionId: string): Recallable =
  ## modelDeleteHierarchicalEntity
  ## Deletes a hierarchical entity extractor from the application version.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564719 = newJObject()
  add(path_564719, "hEntityId", newJString(hEntityId))
  add(path_564719, "appId", newJString(appId))
  add(path_564719, "versionId", newJString(versionId))
  result = call_564718.call(path_564719, nil, nil, nil, nil)

var modelDeleteHierarchicalEntity* = Call_ModelDeleteHierarchicalEntity_564711(
    name: "modelDeleteHierarchicalEntity", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelDeleteHierarchicalEntity_564712,
    base: "/luis/api/v2.0", url: url_ModelDeleteHierarchicalEntity_564713,
    schemes: {Scheme.Https})
type
  Call_ModelAddHierarchicalEntityChild_564720 = ref object of OpenApiRestCall_563565
proc url_ModelAddHierarchicalEntityChild_564722(protocol: Scheme; host: string;
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

proc validate_ModelAddHierarchicalEntityChild_564721(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a single child in an existing hierarchical entity model.
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
  var valid_564723 = path.getOrDefault("hEntityId")
  valid_564723 = validateParameter(valid_564723, JString, required = true,
                                 default = nil)
  if valid_564723 != nil:
    section.add "hEntityId", valid_564723
  var valid_564724 = path.getOrDefault("appId")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "appId", valid_564724
  var valid_564725 = path.getOrDefault("versionId")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "versionId", valid_564725
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

proc call*(call_564727: Call_ModelAddHierarchicalEntityChild_564720;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a single child in an existing hierarchical entity model.
  ## 
  let valid = call_564727.validator(path, query, header, formData, body)
  let scheme = call_564727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564727.url(scheme.get, call_564727.host, call_564727.base,
                         call_564727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564727, url, valid)

proc call*(call_564728: Call_ModelAddHierarchicalEntityChild_564720;
          hierarchicalChildModelCreateObject: JsonNode; hEntityId: string;
          appId: string; versionId: string): Recallable =
  ## modelAddHierarchicalEntityChild
  ## Creates a single child in an existing hierarchical entity model.
  ##   hierarchicalChildModelCreateObject: JObject (required)
  ##                                     : A model object containing the name of the new hierarchical child model.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564729 = newJObject()
  var body_564730 = newJObject()
  if hierarchicalChildModelCreateObject != nil:
    body_564730 = hierarchicalChildModelCreateObject
  add(path_564729, "hEntityId", newJString(hEntityId))
  add(path_564729, "appId", newJString(appId))
  add(path_564729, "versionId", newJString(versionId))
  result = call_564728.call(path_564729, nil, nil, nil, body_564730)

var modelAddHierarchicalEntityChild* = Call_ModelAddHierarchicalEntityChild_564720(
    name: "modelAddHierarchicalEntityChild", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children",
    validator: validate_ModelAddHierarchicalEntityChild_564721,
    base: "/luis/api/v2.0", url: url_ModelAddHierarchicalEntityChild_564722,
    schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntityChild_564741 = ref object of OpenApiRestCall_563565
proc url_ModelUpdateHierarchicalEntityChild_564743(protocol: Scheme; host: string;
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

proc validate_ModelUpdateHierarchicalEntityChild_564742(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Renames a single child in an existing hierarchical entity model.
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
  var valid_564744 = path.getOrDefault("hEntityId")
  valid_564744 = validateParameter(valid_564744, JString, required = true,
                                 default = nil)
  if valid_564744 != nil:
    section.add "hEntityId", valid_564744
  var valid_564745 = path.getOrDefault("appId")
  valid_564745 = validateParameter(valid_564745, JString, required = true,
                                 default = nil)
  if valid_564745 != nil:
    section.add "appId", valid_564745
  var valid_564746 = path.getOrDefault("hChildId")
  valid_564746 = validateParameter(valid_564746, JString, required = true,
                                 default = nil)
  if valid_564746 != nil:
    section.add "hChildId", valid_564746
  var valid_564747 = path.getOrDefault("versionId")
  valid_564747 = validateParameter(valid_564747, JString, required = true,
                                 default = nil)
  if valid_564747 != nil:
    section.add "versionId", valid_564747
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

proc call*(call_564749: Call_ModelUpdateHierarchicalEntityChild_564741;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renames a single child in an existing hierarchical entity model.
  ## 
  let valid = call_564749.validator(path, query, header, formData, body)
  let scheme = call_564749.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564749.url(scheme.get, call_564749.host, call_564749.base,
                         call_564749.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564749, url, valid)

proc call*(call_564750: Call_ModelUpdateHierarchicalEntityChild_564741;
          hEntityId: string; hierarchicalChildModelUpdateObject: JsonNode;
          appId: string; hChildId: string; versionId: string): Recallable =
  ## modelUpdateHierarchicalEntityChild
  ## Renames a single child in an existing hierarchical entity model.
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
  var path_564751 = newJObject()
  var body_564752 = newJObject()
  add(path_564751, "hEntityId", newJString(hEntityId))
  if hierarchicalChildModelUpdateObject != nil:
    body_564752 = hierarchicalChildModelUpdateObject
  add(path_564751, "appId", newJString(appId))
  add(path_564751, "hChildId", newJString(hChildId))
  add(path_564751, "versionId", newJString(versionId))
  result = call_564750.call(path_564751, nil, nil, nil, body_564752)

var modelUpdateHierarchicalEntityChild* = Call_ModelUpdateHierarchicalEntityChild_564741(
    name: "modelUpdateHierarchicalEntityChild", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelUpdateHierarchicalEntityChild_564742,
    base: "/luis/api/v2.0", url: url_ModelUpdateHierarchicalEntityChild_564743,
    schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntityChild_564731 = ref object of OpenApiRestCall_563565
proc url_ModelGetHierarchicalEntityChild_564733(protocol: Scheme; host: string;
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

proc validate_ModelGetHierarchicalEntityChild_564732(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the hierarchical entity child model.
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
  var valid_564734 = path.getOrDefault("hEntityId")
  valid_564734 = validateParameter(valid_564734, JString, required = true,
                                 default = nil)
  if valid_564734 != nil:
    section.add "hEntityId", valid_564734
  var valid_564735 = path.getOrDefault("appId")
  valid_564735 = validateParameter(valid_564735, JString, required = true,
                                 default = nil)
  if valid_564735 != nil:
    section.add "appId", valid_564735
  var valid_564736 = path.getOrDefault("hChildId")
  valid_564736 = validateParameter(valid_564736, JString, required = true,
                                 default = nil)
  if valid_564736 != nil:
    section.add "hChildId", valid_564736
  var valid_564737 = path.getOrDefault("versionId")
  valid_564737 = validateParameter(valid_564737, JString, required = true,
                                 default = nil)
  if valid_564737 != nil:
    section.add "versionId", valid_564737
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564738: Call_ModelGetHierarchicalEntityChild_564731;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the hierarchical entity child model.
  ## 
  let valid = call_564738.validator(path, query, header, formData, body)
  let scheme = call_564738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564738.url(scheme.get, call_564738.host, call_564738.base,
                         call_564738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564738, url, valid)

proc call*(call_564739: Call_ModelGetHierarchicalEntityChild_564731;
          hEntityId: string; appId: string; hChildId: string; versionId: string): Recallable =
  ## modelGetHierarchicalEntityChild
  ## Gets information about the hierarchical entity child model.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564740 = newJObject()
  add(path_564740, "hEntityId", newJString(hEntityId))
  add(path_564740, "appId", newJString(appId))
  add(path_564740, "hChildId", newJString(hChildId))
  add(path_564740, "versionId", newJString(versionId))
  result = call_564739.call(path_564740, nil, nil, nil, nil)

var modelGetHierarchicalEntityChild* = Call_ModelGetHierarchicalEntityChild_564731(
    name: "modelGetHierarchicalEntityChild", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelGetHierarchicalEntityChild_564732,
    base: "/luis/api/v2.0", url: url_ModelGetHierarchicalEntityChild_564733,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntityChild_564753 = ref object of OpenApiRestCall_563565
proc url_ModelDeleteHierarchicalEntityChild_564755(protocol: Scheme; host: string;
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

proc validate_ModelDeleteHierarchicalEntityChild_564754(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a hierarchical entity extractor child from the application.
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
  var valid_564756 = path.getOrDefault("hEntityId")
  valid_564756 = validateParameter(valid_564756, JString, required = true,
                                 default = nil)
  if valid_564756 != nil:
    section.add "hEntityId", valid_564756
  var valid_564757 = path.getOrDefault("appId")
  valid_564757 = validateParameter(valid_564757, JString, required = true,
                                 default = nil)
  if valid_564757 != nil:
    section.add "appId", valid_564757
  var valid_564758 = path.getOrDefault("hChildId")
  valid_564758 = validateParameter(valid_564758, JString, required = true,
                                 default = nil)
  if valid_564758 != nil:
    section.add "hChildId", valid_564758
  var valid_564759 = path.getOrDefault("versionId")
  valid_564759 = validateParameter(valid_564759, JString, required = true,
                                 default = nil)
  if valid_564759 != nil:
    section.add "versionId", valid_564759
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564760: Call_ModelDeleteHierarchicalEntityChild_564753;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a hierarchical entity extractor child from the application.
  ## 
  let valid = call_564760.validator(path, query, header, formData, body)
  let scheme = call_564760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564760.url(scheme.get, call_564760.host, call_564760.base,
                         call_564760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564760, url, valid)

proc call*(call_564761: Call_ModelDeleteHierarchicalEntityChild_564753;
          hEntityId: string; appId: string; hChildId: string; versionId: string): Recallable =
  ## modelDeleteHierarchicalEntityChild
  ## Deletes a hierarchical entity extractor child from the application.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564762 = newJObject()
  add(path_564762, "hEntityId", newJString(hEntityId))
  add(path_564762, "appId", newJString(appId))
  add(path_564762, "hChildId", newJString(hChildId))
  add(path_564762, "versionId", newJString(versionId))
  result = call_564761.call(path_564762, nil, nil, nil, nil)

var modelDeleteHierarchicalEntityChild* = Call_ModelDeleteHierarchicalEntityChild_564753(
    name: "modelDeleteHierarchicalEntityChild", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelDeleteHierarchicalEntityChild_564754,
    base: "/luis/api/v2.0", url: url_ModelDeleteHierarchicalEntityChild_564755,
    schemes: {Scheme.Https})
type
  Call_ModelAddIntent_564774 = ref object of OpenApiRestCall_563565
proc url_ModelAddIntent_564776(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddIntent_564775(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Adds an intent classifier to the application.
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
  var valid_564777 = path.getOrDefault("appId")
  valid_564777 = validateParameter(valid_564777, JString, required = true,
                                 default = nil)
  if valid_564777 != nil:
    section.add "appId", valid_564777
  var valid_564778 = path.getOrDefault("versionId")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "versionId", valid_564778
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   intentCreateObject: JObject (required)
  ##                     : A model object containing the name of the new intent classifier.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564780: Call_ModelAddIntent_564774; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an intent classifier to the application.
  ## 
  let valid = call_564780.validator(path, query, header, formData, body)
  let scheme = call_564780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564780.url(scheme.get, call_564780.host, call_564780.base,
                         call_564780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564780, url, valid)

proc call*(call_564781: Call_ModelAddIntent_564774; intentCreateObject: JsonNode;
          appId: string; versionId: string): Recallable =
  ## modelAddIntent
  ## Adds an intent classifier to the application.
  ##   intentCreateObject: JObject (required)
  ##                     : A model object containing the name of the new intent classifier.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564782 = newJObject()
  var body_564783 = newJObject()
  if intentCreateObject != nil:
    body_564783 = intentCreateObject
  add(path_564782, "appId", newJString(appId))
  add(path_564782, "versionId", newJString(versionId))
  result = call_564781.call(path_564782, nil, nil, nil, body_564783)

var modelAddIntent* = Call_ModelAddIntent_564774(name: "modelAddIntent",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents",
    validator: validate_ModelAddIntent_564775, base: "/luis/api/v2.0",
    url: url_ModelAddIntent_564776, schemes: {Scheme.Https})
type
  Call_ModelListIntents_564763 = ref object of OpenApiRestCall_563565
proc url_ModelListIntents_564765(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListIntents_564764(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about the intent models.
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
  var valid_564766 = path.getOrDefault("appId")
  valid_564766 = validateParameter(valid_564766, JString, required = true,
                                 default = nil)
  if valid_564766 != nil:
    section.add "appId", valid_564766
  var valid_564767 = path.getOrDefault("versionId")
  valid_564767 = validateParameter(valid_564767, JString, required = true,
                                 default = nil)
  if valid_564767 != nil:
    section.add "versionId", valid_564767
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564768 = query.getOrDefault("take")
  valid_564768 = validateParameter(valid_564768, JInt, required = false,
                                 default = newJInt(100))
  if valid_564768 != nil:
    section.add "take", valid_564768
  var valid_564769 = query.getOrDefault("skip")
  valid_564769 = validateParameter(valid_564769, JInt, required = false,
                                 default = newJInt(0))
  if valid_564769 != nil:
    section.add "skip", valid_564769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564770: Call_ModelListIntents_564763; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the intent models.
  ## 
  let valid = call_564770.validator(path, query, header, formData, body)
  let scheme = call_564770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564770.url(scheme.get, call_564770.host, call_564770.base,
                         call_564770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564770, url, valid)

proc call*(call_564771: Call_ModelListIntents_564763; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListIntents
  ## Gets information about the intent models.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564772 = newJObject()
  var query_564773 = newJObject()
  add(query_564773, "take", newJInt(take))
  add(query_564773, "skip", newJInt(skip))
  add(path_564772, "appId", newJString(appId))
  add(path_564772, "versionId", newJString(versionId))
  result = call_564771.call(path_564772, query_564773, nil, nil, nil)

var modelListIntents* = Call_ModelListIntents_564763(name: "modelListIntents",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents",
    validator: validate_ModelListIntents_564764, base: "/luis/api/v2.0",
    url: url_ModelListIntents_564765, schemes: {Scheme.Https})
type
  Call_ModelUpdateIntent_564793 = ref object of OpenApiRestCall_563565
proc url_ModelUpdateIntent_564795(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateIntent_564794(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the name of an intent classifier.
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
  var valid_564796 = path.getOrDefault("intentId")
  valid_564796 = validateParameter(valid_564796, JString, required = true,
                                 default = nil)
  if valid_564796 != nil:
    section.add "intentId", valid_564796
  var valid_564797 = path.getOrDefault("appId")
  valid_564797 = validateParameter(valid_564797, JString, required = true,
                                 default = nil)
  if valid_564797 != nil:
    section.add "appId", valid_564797
  var valid_564798 = path.getOrDefault("versionId")
  valid_564798 = validateParameter(valid_564798, JString, required = true,
                                 default = nil)
  if valid_564798 != nil:
    section.add "versionId", valid_564798
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new intent classifier name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564800: Call_ModelUpdateIntent_564793; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name of an intent classifier.
  ## 
  let valid = call_564800.validator(path, query, header, formData, body)
  let scheme = call_564800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564800.url(scheme.get, call_564800.host, call_564800.base,
                         call_564800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564800, url, valid)

proc call*(call_564801: Call_ModelUpdateIntent_564793; intentId: string;
          appId: string; modelUpdateObject: JsonNode; versionId: string): Recallable =
  ## modelUpdateIntent
  ## Updates the name of an intent classifier.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new intent classifier name.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564802 = newJObject()
  var body_564803 = newJObject()
  add(path_564802, "intentId", newJString(intentId))
  add(path_564802, "appId", newJString(appId))
  if modelUpdateObject != nil:
    body_564803 = modelUpdateObject
  add(path_564802, "versionId", newJString(versionId))
  result = call_564801.call(path_564802, nil, nil, nil, body_564803)

var modelUpdateIntent* = Call_ModelUpdateIntent_564793(name: "modelUpdateIntent",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelUpdateIntent_564794, base: "/luis/api/v2.0",
    url: url_ModelUpdateIntent_564795, schemes: {Scheme.Https})
type
  Call_ModelGetIntent_564784 = ref object of OpenApiRestCall_563565
proc url_ModelGetIntent_564786(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetIntent_564785(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the intent model.
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
  var valid_564787 = path.getOrDefault("intentId")
  valid_564787 = validateParameter(valid_564787, JString, required = true,
                                 default = nil)
  if valid_564787 != nil:
    section.add "intentId", valid_564787
  var valid_564788 = path.getOrDefault("appId")
  valid_564788 = validateParameter(valid_564788, JString, required = true,
                                 default = nil)
  if valid_564788 != nil:
    section.add "appId", valid_564788
  var valid_564789 = path.getOrDefault("versionId")
  valid_564789 = validateParameter(valid_564789, JString, required = true,
                                 default = nil)
  if valid_564789 != nil:
    section.add "versionId", valid_564789
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564790: Call_ModelGetIntent_564784; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the intent model.
  ## 
  let valid = call_564790.validator(path, query, header, formData, body)
  let scheme = call_564790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564790.url(scheme.get, call_564790.host, call_564790.base,
                         call_564790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564790, url, valid)

proc call*(call_564791: Call_ModelGetIntent_564784; intentId: string; appId: string;
          versionId: string): Recallable =
  ## modelGetIntent
  ## Gets information about the intent model.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564792 = newJObject()
  add(path_564792, "intentId", newJString(intentId))
  add(path_564792, "appId", newJString(appId))
  add(path_564792, "versionId", newJString(versionId))
  result = call_564791.call(path_564792, nil, nil, nil, nil)

var modelGetIntent* = Call_ModelGetIntent_564784(name: "modelGetIntent",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelGetIntent_564785, base: "/luis/api/v2.0",
    url: url_ModelGetIntent_564786, schemes: {Scheme.Https})
type
  Call_ModelDeleteIntent_564804 = ref object of OpenApiRestCall_563565
proc url_ModelDeleteIntent_564806(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteIntent_564805(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an intent classifier from the application.
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
  var valid_564807 = path.getOrDefault("intentId")
  valid_564807 = validateParameter(valid_564807, JString, required = true,
                                 default = nil)
  if valid_564807 != nil:
    section.add "intentId", valid_564807
  var valid_564808 = path.getOrDefault("appId")
  valid_564808 = validateParameter(valid_564808, JString, required = true,
                                 default = nil)
  if valid_564808 != nil:
    section.add "appId", valid_564808
  var valid_564809 = path.getOrDefault("versionId")
  valid_564809 = validateParameter(valid_564809, JString, required = true,
                                 default = nil)
  if valid_564809 != nil:
    section.add "versionId", valid_564809
  result.add "path", section
  ## parameters in `query` object:
  ##   deleteUtterances: JBool
  ##                   : Also delete the intent's utterances (true). Or move the utterances to the None intent (false - the default value).
  section = newJObject()
  var valid_564810 = query.getOrDefault("deleteUtterances")
  valid_564810 = validateParameter(valid_564810, JBool, required = false,
                                 default = newJBool(false))
  if valid_564810 != nil:
    section.add "deleteUtterances", valid_564810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564811: Call_ModelDeleteIntent_564804; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an intent classifier from the application.
  ## 
  let valid = call_564811.validator(path, query, header, formData, body)
  let scheme = call_564811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564811.url(scheme.get, call_564811.host, call_564811.base,
                         call_564811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564811, url, valid)

proc call*(call_564812: Call_ModelDeleteIntent_564804; intentId: string;
          appId: string; versionId: string; deleteUtterances: bool = false): Recallable =
  ## modelDeleteIntent
  ## Deletes an intent classifier from the application.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   deleteUtterances: bool
  ##                   : Also delete the intent's utterances (true). Or move the utterances to the None intent (false - the default value).
  var path_564813 = newJObject()
  var query_564814 = newJObject()
  add(path_564813, "intentId", newJString(intentId))
  add(path_564813, "appId", newJString(appId))
  add(path_564813, "versionId", newJString(versionId))
  add(query_564814, "deleteUtterances", newJBool(deleteUtterances))
  result = call_564812.call(path_564813, query_564814, nil, nil, nil)

var modelDeleteIntent* = Call_ModelDeleteIntent_564804(name: "modelDeleteIntent",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelDeleteIntent_564805, base: "/luis/api/v2.0",
    url: url_ModelDeleteIntent_564806, schemes: {Scheme.Https})
type
  Call_ModelGetIntentSuggestions_564815 = ref object of OpenApiRestCall_563565
proc url_ModelGetIntentSuggestions_564817(protocol: Scheme; host: string;
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

proc validate_ModelGetIntentSuggestions_564816(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Suggests examples that would improve the accuracy of the intent model.
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
  var valid_564818 = path.getOrDefault("intentId")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = nil)
  if valid_564818 != nil:
    section.add "intentId", valid_564818
  var valid_564819 = path.getOrDefault("appId")
  valid_564819 = validateParameter(valid_564819, JString, required = true,
                                 default = nil)
  if valid_564819 != nil:
    section.add "appId", valid_564819
  var valid_564820 = path.getOrDefault("versionId")
  valid_564820 = validateParameter(valid_564820, JString, required = true,
                                 default = nil)
  if valid_564820 != nil:
    section.add "versionId", valid_564820
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_564821 = query.getOrDefault("take")
  valid_564821 = validateParameter(valid_564821, JInt, required = false,
                                 default = newJInt(100))
  if valid_564821 != nil:
    section.add "take", valid_564821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564822: Call_ModelGetIntentSuggestions_564815; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests examples that would improve the accuracy of the intent model.
  ## 
  let valid = call_564822.validator(path, query, header, formData, body)
  let scheme = call_564822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564822.url(scheme.get, call_564822.host, call_564822.base,
                         call_564822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564822, url, valid)

proc call*(call_564823: Call_ModelGetIntentSuggestions_564815; intentId: string;
          appId: string; versionId: string; take: int = 100): Recallable =
  ## modelGetIntentSuggestions
  ## Suggests examples that would improve the accuracy of the intent model.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564824 = newJObject()
  var query_564825 = newJObject()
  add(query_564825, "take", newJInt(take))
  add(path_564824, "intentId", newJString(intentId))
  add(path_564824, "appId", newJString(appId))
  add(path_564824, "versionId", newJString(versionId))
  result = call_564823.call(path_564824, query_564825, nil, nil, nil)

var modelGetIntentSuggestions* = Call_ModelGetIntentSuggestions_564815(
    name: "modelGetIntentSuggestions", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}/suggest",
    validator: validate_ModelGetIntentSuggestions_564816, base: "/luis/api/v2.0",
    url: url_ModelGetIntentSuggestions_564817, schemes: {Scheme.Https})
type
  Call_ModelListPrebuiltEntities_564826 = ref object of OpenApiRestCall_563565
proc url_ModelListPrebuiltEntities_564828(protocol: Scheme; host: string;
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

proc validate_ModelListPrebuiltEntities_564827(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the available prebuilt entity extractors for the application.
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
  var valid_564829 = path.getOrDefault("appId")
  valid_564829 = validateParameter(valid_564829, JString, required = true,
                                 default = nil)
  if valid_564829 != nil:
    section.add "appId", valid_564829
  var valid_564830 = path.getOrDefault("versionId")
  valid_564830 = validateParameter(valid_564830, JString, required = true,
                                 default = nil)
  if valid_564830 != nil:
    section.add "versionId", valid_564830
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564831: Call_ModelListPrebuiltEntities_564826; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the available prebuilt entity extractors for the application.
  ## 
  let valid = call_564831.validator(path, query, header, formData, body)
  let scheme = call_564831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564831.url(scheme.get, call_564831.host, call_564831.base,
                         call_564831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564831, url, valid)

proc call*(call_564832: Call_ModelListPrebuiltEntities_564826; appId: string;
          versionId: string): Recallable =
  ## modelListPrebuiltEntities
  ## Gets all the available prebuilt entity extractors for the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564833 = newJObject()
  add(path_564833, "appId", newJString(appId))
  add(path_564833, "versionId", newJString(versionId))
  result = call_564832.call(path_564833, nil, nil, nil, nil)

var modelListPrebuiltEntities* = Call_ModelListPrebuiltEntities_564826(
    name: "modelListPrebuiltEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/listprebuilts",
    validator: validate_ModelListPrebuiltEntities_564827, base: "/luis/api/v2.0",
    url: url_ModelListPrebuiltEntities_564828, schemes: {Scheme.Https})
type
  Call_ModelListModels_564834 = ref object of OpenApiRestCall_563565
proc url_ModelListModels_564836(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListModels_564835(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about the application version models.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564839 = query.getOrDefault("take")
  valid_564839 = validateParameter(valid_564839, JInt, required = false,
                                 default = newJInt(100))
  if valid_564839 != nil:
    section.add "take", valid_564839
  var valid_564840 = query.getOrDefault("skip")
  valid_564840 = validateParameter(valid_564840, JInt, required = false,
                                 default = newJInt(0))
  if valid_564840 != nil:
    section.add "skip", valid_564840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564841: Call_ModelListModels_564834; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the application version models.
  ## 
  let valid = call_564841.validator(path, query, header, formData, body)
  let scheme = call_564841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564841.url(scheme.get, call_564841.host, call_564841.base,
                         call_564841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564841, url, valid)

proc call*(call_564842: Call_ModelListModels_564834; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListModels
  ## Gets information about the application version models.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564843 = newJObject()
  var query_564844 = newJObject()
  add(query_564844, "take", newJInt(take))
  add(query_564844, "skip", newJInt(skip))
  add(path_564843, "appId", newJString(appId))
  add(path_564843, "versionId", newJString(versionId))
  result = call_564842.call(path_564843, query_564844, nil, nil, nil)

var modelListModels* = Call_ModelListModels_564834(name: "modelListModels",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/models",
    validator: validate_ModelListModels_564835, base: "/luis/api/v2.0",
    url: url_ModelListModels_564836, schemes: {Scheme.Https})
type
  Call_FeaturesCreatePatternFeature_564856 = ref object of OpenApiRestCall_563565
proc url_FeaturesCreatePatternFeature_564858(protocol: Scheme; host: string;
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

proc validate_FeaturesCreatePatternFeature_564857(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature.
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

proc call*(call_564862: Call_FeaturesCreatePatternFeature_564856; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature.
  ## 
  let valid = call_564862.validator(path, query, header, formData, body)
  let scheme = call_564862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564862.url(scheme.get, call_564862.host, call_564862.base,
                         call_564862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564862, url, valid)

proc call*(call_564863: Call_FeaturesCreatePatternFeature_564856; appId: string;
          versionId: string; patternCreateObject: JsonNode): Recallable =
  ## featuresCreatePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternCreateObject: JObject (required)
  ##                      : The Name and Pattern of the feature.
  var path_564864 = newJObject()
  var body_564865 = newJObject()
  add(path_564864, "appId", newJString(appId))
  add(path_564864, "versionId", newJString(versionId))
  if patternCreateObject != nil:
    body_564865 = patternCreateObject
  result = call_564863.call(path_564864, nil, nil, nil, body_564865)

var featuresCreatePatternFeature* = Call_FeaturesCreatePatternFeature_564856(
    name: "featuresCreatePatternFeature", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patterns",
    validator: validate_FeaturesCreatePatternFeature_564857,
    base: "/luis/api/v2.0", url: url_FeaturesCreatePatternFeature_564858,
    schemes: {Scheme.Https})
type
  Call_FeaturesGetApplicationVersionPatternFeatures_564845 = ref object of OpenApiRestCall_563565
proc url_FeaturesGetApplicationVersionPatternFeatures_564847(protocol: Scheme;
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

proc validate_FeaturesGetApplicationVersionPatternFeatures_564846(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564848 = path.getOrDefault("appId")
  valid_564848 = validateParameter(valid_564848, JString, required = true,
                                 default = nil)
  if valid_564848 != nil:
    section.add "appId", valid_564848
  var valid_564849 = path.getOrDefault("versionId")
  valid_564849 = validateParameter(valid_564849, JString, required = true,
                                 default = nil)
  if valid_564849 != nil:
    section.add "versionId", valid_564849
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564850 = query.getOrDefault("take")
  valid_564850 = validateParameter(valid_564850, JInt, required = false,
                                 default = newJInt(100))
  if valid_564850 != nil:
    section.add "take", valid_564850
  var valid_564851 = query.getOrDefault("skip")
  valid_564851 = validateParameter(valid_564851, JInt, required = false,
                                 default = newJInt(0))
  if valid_564851 != nil:
    section.add "skip", valid_564851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564852: Call_FeaturesGetApplicationVersionPatternFeatures_564845;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ## 
  let valid = call_564852.validator(path, query, header, formData, body)
  let scheme = call_564852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564852.url(scheme.get, call_564852.host, call_564852.base,
                         call_564852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564852, url, valid)

proc call*(call_564853: Call_FeaturesGetApplicationVersionPatternFeatures_564845;
          appId: string; versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## featuresGetApplicationVersionPatternFeatures
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564854 = newJObject()
  var query_564855 = newJObject()
  add(query_564855, "take", newJInt(take))
  add(query_564855, "skip", newJInt(skip))
  add(path_564854, "appId", newJString(appId))
  add(path_564854, "versionId", newJString(versionId))
  result = call_564853.call(path_564854, query_564855, nil, nil, nil)

var featuresGetApplicationVersionPatternFeatures* = Call_FeaturesGetApplicationVersionPatternFeatures_564845(
    name: "featuresGetApplicationVersionPatternFeatures",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns",
    validator: validate_FeaturesGetApplicationVersionPatternFeatures_564846,
    base: "/luis/api/v2.0", url: url_FeaturesGetApplicationVersionPatternFeatures_564847,
    schemes: {Scheme.Https})
type
  Call_FeaturesUpdatePatternFeature_564875 = ref object of OpenApiRestCall_563565
proc url_FeaturesUpdatePatternFeature_564877(protocol: Scheme; host: string;
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

proc validate_FeaturesUpdatePatternFeature_564876(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature.
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
  var valid_564878 = path.getOrDefault("appId")
  valid_564878 = validateParameter(valid_564878, JString, required = true,
                                 default = nil)
  if valid_564878 != nil:
    section.add "appId", valid_564878
  var valid_564879 = path.getOrDefault("versionId")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "versionId", valid_564879
  var valid_564880 = path.getOrDefault("patternId")
  valid_564880 = validateParameter(valid_564880, JInt, required = true, default = nil)
  if valid_564880 != nil:
    section.add "patternId", valid_564880
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

proc call*(call_564882: Call_FeaturesUpdatePatternFeature_564875; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature.
  ## 
  let valid = call_564882.validator(path, query, header, formData, body)
  let scheme = call_564882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564882.url(scheme.get, call_564882.host, call_564882.base,
                         call_564882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564882, url, valid)

proc call*(call_564883: Call_FeaturesUpdatePatternFeature_564875;
          patternUpdateObject: JsonNode; appId: string; versionId: string;
          patternId: int): Recallable =
  ## featuresUpdatePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature.
  ##   patternUpdateObject: JObject (required)
  ##                      : The new values for: - Just a boolean called IsActive, in which case the status of the feature will be changed. - Name, Pattern and a boolean called IsActive to update the feature.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  var path_564884 = newJObject()
  var body_564885 = newJObject()
  if patternUpdateObject != nil:
    body_564885 = patternUpdateObject
  add(path_564884, "appId", newJString(appId))
  add(path_564884, "versionId", newJString(versionId))
  add(path_564884, "patternId", newJInt(patternId))
  result = call_564883.call(path_564884, nil, nil, nil, body_564885)

var featuresUpdatePatternFeature* = Call_FeaturesUpdatePatternFeature_564875(
    name: "featuresUpdatePatternFeature", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesUpdatePatternFeature_564876,
    base: "/luis/api/v2.0", url: url_FeaturesUpdatePatternFeature_564877,
    schemes: {Scheme.Https})
type
  Call_FeaturesGetPatternFeatureInfo_564866 = ref object of OpenApiRestCall_563565
proc url_FeaturesGetPatternFeatureInfo_564868(protocol: Scheme; host: string;
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

proc validate_FeaturesGetPatternFeatureInfo_564867(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info.
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
  var valid_564871 = path.getOrDefault("patternId")
  valid_564871 = validateParameter(valid_564871, JInt, required = true, default = nil)
  if valid_564871 != nil:
    section.add "patternId", valid_564871
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564872: Call_FeaturesGetPatternFeatureInfo_564866; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info.
  ## 
  let valid = call_564872.validator(path, query, header, formData, body)
  let scheme = call_564872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564872.url(scheme.get, call_564872.host, call_564872.base,
                         call_564872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564872, url, valid)

proc call*(call_564873: Call_FeaturesGetPatternFeatureInfo_564866; appId: string;
          versionId: string; patternId: int): Recallable =
  ## featuresGetPatternFeatureInfo
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  var path_564874 = newJObject()
  add(path_564874, "appId", newJString(appId))
  add(path_564874, "versionId", newJString(versionId))
  add(path_564874, "patternId", newJInt(patternId))
  result = call_564873.call(path_564874, nil, nil, nil, nil)

var featuresGetPatternFeatureInfo* = Call_FeaturesGetPatternFeatureInfo_564866(
    name: "featuresGetPatternFeatureInfo", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesGetPatternFeatureInfo_564867,
    base: "/luis/api/v2.0", url: url_FeaturesGetPatternFeatureInfo_564868,
    schemes: {Scheme.Https})
type
  Call_FeaturesDeletePatternFeature_564886 = ref object of OpenApiRestCall_563565
proc url_FeaturesDeletePatternFeature_564888(protocol: Scheme; host: string;
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

proc validate_FeaturesDeletePatternFeature_564887(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature.
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
  var valid_564889 = path.getOrDefault("appId")
  valid_564889 = validateParameter(valid_564889, JString, required = true,
                                 default = nil)
  if valid_564889 != nil:
    section.add "appId", valid_564889
  var valid_564890 = path.getOrDefault("versionId")
  valid_564890 = validateParameter(valid_564890, JString, required = true,
                                 default = nil)
  if valid_564890 != nil:
    section.add "versionId", valid_564890
  var valid_564891 = path.getOrDefault("patternId")
  valid_564891 = validateParameter(valid_564891, JInt, required = true, default = nil)
  if valid_564891 != nil:
    section.add "patternId", valid_564891
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564892: Call_FeaturesDeletePatternFeature_564886; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature.
  ## 
  let valid = call_564892.validator(path, query, header, formData, body)
  let scheme = call_564892.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564892.url(scheme.get, call_564892.host, call_564892.base,
                         call_564892.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564892, url, valid)

proc call*(call_564893: Call_FeaturesDeletePatternFeature_564886; appId: string;
          versionId: string; patternId: int): Recallable =
  ## featuresDeletePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  var path_564894 = newJObject()
  add(path_564894, "appId", newJString(appId))
  add(path_564894, "versionId", newJString(versionId))
  add(path_564894, "patternId", newJInt(patternId))
  result = call_564893.call(path_564894, nil, nil, nil, nil)

var featuresDeletePatternFeature* = Call_FeaturesDeletePatternFeature_564886(
    name: "featuresDeletePatternFeature", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesDeletePatternFeature_564887,
    base: "/luis/api/v2.0", url: url_FeaturesDeletePatternFeature_564888,
    schemes: {Scheme.Https})
type
  Call_FeaturesAddPhraseList_564906 = ref object of OpenApiRestCall_563565
proc url_FeaturesAddPhraseList_564908(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesAddPhraseList_564907(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new phraselist feature.
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
  ## parameters in `body` object:
  ##   phraselistCreateObject: JObject (required)
  ##                         : A Phraselist object containing Name, comma-separated Phrases and the isExchangeable boolean. Default value for isExchangeable is true.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564912: Call_FeaturesAddPhraseList_564906; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new phraselist feature.
  ## 
  let valid = call_564912.validator(path, query, header, formData, body)
  let scheme = call_564912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564912.url(scheme.get, call_564912.host, call_564912.base,
                         call_564912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564912, url, valid)

proc call*(call_564913: Call_FeaturesAddPhraseList_564906;
          phraselistCreateObject: JsonNode; appId: string; versionId: string): Recallable =
  ## featuresAddPhraseList
  ## Creates a new phraselist feature.
  ##   phraselistCreateObject: JObject (required)
  ##                         : A Phraselist object containing Name, comma-separated Phrases and the isExchangeable boolean. Default value for isExchangeable is true.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564914 = newJObject()
  var body_564915 = newJObject()
  if phraselistCreateObject != nil:
    body_564915 = phraselistCreateObject
  add(path_564914, "appId", newJString(appId))
  add(path_564914, "versionId", newJString(versionId))
  result = call_564913.call(path_564914, nil, nil, nil, body_564915)

var featuresAddPhraseList* = Call_FeaturesAddPhraseList_564906(
    name: "featuresAddPhraseList", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists",
    validator: validate_FeaturesAddPhraseList_564907, base: "/luis/api/v2.0",
    url: url_FeaturesAddPhraseList_564908, schemes: {Scheme.Https})
type
  Call_FeaturesListPhraseLists_564895 = ref object of OpenApiRestCall_563565
proc url_FeaturesListPhraseLists_564897(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesListPhraseLists_564896(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the phraselist features.
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
  var valid_564898 = path.getOrDefault("appId")
  valid_564898 = validateParameter(valid_564898, JString, required = true,
                                 default = nil)
  if valid_564898 != nil:
    section.add "appId", valid_564898
  var valid_564899 = path.getOrDefault("versionId")
  valid_564899 = validateParameter(valid_564899, JString, required = true,
                                 default = nil)
  if valid_564899 != nil:
    section.add "versionId", valid_564899
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564900 = query.getOrDefault("take")
  valid_564900 = validateParameter(valid_564900, JInt, required = false,
                                 default = newJInt(100))
  if valid_564900 != nil:
    section.add "take", valid_564900
  var valid_564901 = query.getOrDefault("skip")
  valid_564901 = validateParameter(valid_564901, JInt, required = false,
                                 default = newJInt(0))
  if valid_564901 != nil:
    section.add "skip", valid_564901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564902: Call_FeaturesListPhraseLists_564895; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the phraselist features.
  ## 
  let valid = call_564902.validator(path, query, header, formData, body)
  let scheme = call_564902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564902.url(scheme.get, call_564902.host, call_564902.base,
                         call_564902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564902, url, valid)

proc call*(call_564903: Call_FeaturesListPhraseLists_564895; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## featuresListPhraseLists
  ## Gets all the phraselist features.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564904 = newJObject()
  var query_564905 = newJObject()
  add(query_564905, "take", newJInt(take))
  add(query_564905, "skip", newJInt(skip))
  add(path_564904, "appId", newJString(appId))
  add(path_564904, "versionId", newJString(versionId))
  result = call_564903.call(path_564904, query_564905, nil, nil, nil)

var featuresListPhraseLists* = Call_FeaturesListPhraseLists_564895(
    name: "featuresListPhraseLists", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists",
    validator: validate_FeaturesListPhraseLists_564896, base: "/luis/api/v2.0",
    url: url_FeaturesListPhraseLists_564897, schemes: {Scheme.Https})
type
  Call_FeaturesUpdatePhraseList_564925 = ref object of OpenApiRestCall_563565
proc url_FeaturesUpdatePhraseList_564927(protocol: Scheme; host: string;
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

proc validate_FeaturesUpdatePhraseList_564926(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the phrases, the state and the name of the phraselist feature.
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
  var valid_564928 = path.getOrDefault("phraselistId")
  valid_564928 = validateParameter(valid_564928, JInt, required = true, default = nil)
  if valid_564928 != nil:
    section.add "phraselistId", valid_564928
  var valid_564929 = path.getOrDefault("appId")
  valid_564929 = validateParameter(valid_564929, JString, required = true,
                                 default = nil)
  if valid_564929 != nil:
    section.add "appId", valid_564929
  var valid_564930 = path.getOrDefault("versionId")
  valid_564930 = validateParameter(valid_564930, JString, required = true,
                                 default = nil)
  if valid_564930 != nil:
    section.add "versionId", valid_564930
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

proc call*(call_564932: Call_FeaturesUpdatePhraseList_564925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the phrases, the state and the name of the phraselist feature.
  ## 
  let valid = call_564932.validator(path, query, header, formData, body)
  let scheme = call_564932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564932.url(scheme.get, call_564932.host, call_564932.base,
                         call_564932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564932, url, valid)

proc call*(call_564933: Call_FeaturesUpdatePhraseList_564925; phraselistId: int;
          appId: string; versionId: string; phraselistUpdateObject: JsonNode = nil): Recallable =
  ## featuresUpdatePhraseList
  ## Updates the phrases, the state and the name of the phraselist feature.
  ##   phraselistUpdateObject: JObject
  ##                         : The new values for: - Just a boolean called IsActive, in which case the status of the feature will be changed. - Name, Pattern, Mode, and a boolean called IsActive to update the feature.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be updated.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564934 = newJObject()
  var body_564935 = newJObject()
  if phraselistUpdateObject != nil:
    body_564935 = phraselistUpdateObject
  add(path_564934, "phraselistId", newJInt(phraselistId))
  add(path_564934, "appId", newJString(appId))
  add(path_564934, "versionId", newJString(versionId))
  result = call_564933.call(path_564934, nil, nil, nil, body_564935)

var featuresUpdatePhraseList* = Call_FeaturesUpdatePhraseList_564925(
    name: "featuresUpdatePhraseList", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesUpdatePhraseList_564926, base: "/luis/api/v2.0",
    url: url_FeaturesUpdatePhraseList_564927, schemes: {Scheme.Https})
type
  Call_FeaturesGetPhraseList_564916 = ref object of OpenApiRestCall_563565
proc url_FeaturesGetPhraseList_564918(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesGetPhraseList_564917(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets phraselist feature info.
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
  var valid_564919 = path.getOrDefault("phraselistId")
  valid_564919 = validateParameter(valid_564919, JInt, required = true, default = nil)
  if valid_564919 != nil:
    section.add "phraselistId", valid_564919
  var valid_564920 = path.getOrDefault("appId")
  valid_564920 = validateParameter(valid_564920, JString, required = true,
                                 default = nil)
  if valid_564920 != nil:
    section.add "appId", valid_564920
  var valid_564921 = path.getOrDefault("versionId")
  valid_564921 = validateParameter(valid_564921, JString, required = true,
                                 default = nil)
  if valid_564921 != nil:
    section.add "versionId", valid_564921
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564922: Call_FeaturesGetPhraseList_564916; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets phraselist feature info.
  ## 
  let valid = call_564922.validator(path, query, header, formData, body)
  let scheme = call_564922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564922.url(scheme.get, call_564922.host, call_564922.base,
                         call_564922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564922, url, valid)

proc call*(call_564923: Call_FeaturesGetPhraseList_564916; phraselistId: int;
          appId: string; versionId: string): Recallable =
  ## featuresGetPhraseList
  ## Gets phraselist feature info.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be retrieved.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564924 = newJObject()
  add(path_564924, "phraselistId", newJInt(phraselistId))
  add(path_564924, "appId", newJString(appId))
  add(path_564924, "versionId", newJString(versionId))
  result = call_564923.call(path_564924, nil, nil, nil, nil)

var featuresGetPhraseList* = Call_FeaturesGetPhraseList_564916(
    name: "featuresGetPhraseList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesGetPhraseList_564917, base: "/luis/api/v2.0",
    url: url_FeaturesGetPhraseList_564918, schemes: {Scheme.Https})
type
  Call_FeaturesDeletePhraseList_564936 = ref object of OpenApiRestCall_563565
proc url_FeaturesDeletePhraseList_564938(protocol: Scheme; host: string;
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

proc validate_FeaturesDeletePhraseList_564937(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a phraselist feature.
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
  var valid_564939 = path.getOrDefault("phraselistId")
  valid_564939 = validateParameter(valid_564939, JInt, required = true, default = nil)
  if valid_564939 != nil:
    section.add "phraselistId", valid_564939
  var valid_564940 = path.getOrDefault("appId")
  valid_564940 = validateParameter(valid_564940, JString, required = true,
                                 default = nil)
  if valid_564940 != nil:
    section.add "appId", valid_564940
  var valid_564941 = path.getOrDefault("versionId")
  valid_564941 = validateParameter(valid_564941, JString, required = true,
                                 default = nil)
  if valid_564941 != nil:
    section.add "versionId", valid_564941
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564942: Call_FeaturesDeletePhraseList_564936; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a phraselist feature.
  ## 
  let valid = call_564942.validator(path, query, header, formData, body)
  let scheme = call_564942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564942.url(scheme.get, call_564942.host, call_564942.base,
                         call_564942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564942, url, valid)

proc call*(call_564943: Call_FeaturesDeletePhraseList_564936; phraselistId: int;
          appId: string; versionId: string): Recallable =
  ## featuresDeletePhraseList
  ## Deletes a phraselist feature.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be deleted.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564944 = newJObject()
  add(path_564944, "phraselistId", newJInt(phraselistId))
  add(path_564944, "appId", newJString(appId))
  add(path_564944, "versionId", newJString(versionId))
  result = call_564943.call(path_564944, nil, nil, nil, nil)

var featuresDeletePhraseList* = Call_FeaturesDeletePhraseList_564936(
    name: "featuresDeletePhraseList", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesDeletePhraseList_564937, base: "/luis/api/v2.0",
    url: url_FeaturesDeletePhraseList_564938, schemes: {Scheme.Https})
type
  Call_ModelAddPrebuilt_564956 = ref object of OpenApiRestCall_563565
proc url_ModelAddPrebuilt_564958(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddPrebuilt_564957(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Adds a list of prebuilt entity extractors to the application.
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
  ##   prebuiltExtractorNames: JArray (required)
  ##                         : An array of prebuilt entity extractor names.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564962: Call_ModelAddPrebuilt_564956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a list of prebuilt entity extractors to the application.
  ## 
  let valid = call_564962.validator(path, query, header, formData, body)
  let scheme = call_564962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564962.url(scheme.get, call_564962.host, call_564962.base,
                         call_564962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564962, url, valid)

proc call*(call_564963: Call_ModelAddPrebuilt_564956;
          prebuiltExtractorNames: JsonNode; appId: string; versionId: string): Recallable =
  ## modelAddPrebuilt
  ## Adds a list of prebuilt entity extractors to the application.
  ##   prebuiltExtractorNames: JArray (required)
  ##                         : An array of prebuilt entity extractor names.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564964 = newJObject()
  var body_564965 = newJObject()
  if prebuiltExtractorNames != nil:
    body_564965 = prebuiltExtractorNames
  add(path_564964, "appId", newJString(appId))
  add(path_564964, "versionId", newJString(versionId))
  result = call_564963.call(path_564964, nil, nil, nil, body_564965)

var modelAddPrebuilt* = Call_ModelAddPrebuilt_564956(name: "modelAddPrebuilt",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts",
    validator: validate_ModelAddPrebuilt_564957, base: "/luis/api/v2.0",
    url: url_ModelAddPrebuilt_564958, schemes: {Scheme.Https})
type
  Call_ModelListPrebuilts_564945 = ref object of OpenApiRestCall_563565
proc url_ModelListPrebuilts_564947(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListPrebuilts_564946(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets information about the prebuilt entity models.
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
  var valid_564948 = path.getOrDefault("appId")
  valid_564948 = validateParameter(valid_564948, JString, required = true,
                                 default = nil)
  if valid_564948 != nil:
    section.add "appId", valid_564948
  var valid_564949 = path.getOrDefault("versionId")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "versionId", valid_564949
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  section = newJObject()
  var valid_564950 = query.getOrDefault("take")
  valid_564950 = validateParameter(valid_564950, JInt, required = false,
                                 default = newJInt(100))
  if valid_564950 != nil:
    section.add "take", valid_564950
  var valid_564951 = query.getOrDefault("skip")
  valid_564951 = validateParameter(valid_564951, JInt, required = false,
                                 default = newJInt(0))
  if valid_564951 != nil:
    section.add "skip", valid_564951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564952: Call_ModelListPrebuilts_564945; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the prebuilt entity models.
  ## 
  let valid = call_564952.validator(path, query, header, formData, body)
  let scheme = call_564952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564952.url(scheme.get, call_564952.host, call_564952.base,
                         call_564952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564952, url, valid)

proc call*(call_564953: Call_ModelListPrebuilts_564945; appId: string;
          versionId: string; take: int = 100; skip: int = 0): Recallable =
  ## modelListPrebuilts
  ## Gets information about the prebuilt entity models.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564954 = newJObject()
  var query_564955 = newJObject()
  add(query_564955, "take", newJInt(take))
  add(query_564955, "skip", newJInt(skip))
  add(path_564954, "appId", newJString(appId))
  add(path_564954, "versionId", newJString(versionId))
  result = call_564953.call(path_564954, query_564955, nil, nil, nil)

var modelListPrebuilts* = Call_ModelListPrebuilts_564945(
    name: "modelListPrebuilts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts",
    validator: validate_ModelListPrebuilts_564946, base: "/luis/api/v2.0",
    url: url_ModelListPrebuilts_564947, schemes: {Scheme.Https})
type
  Call_ModelGetPrebuilt_564966 = ref object of OpenApiRestCall_563565
proc url_ModelGetPrebuilt_564968(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetPrebuilt_564967(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about the prebuilt entity model.
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
  var valid_564969 = path.getOrDefault("prebuiltId")
  valid_564969 = validateParameter(valid_564969, JString, required = true,
                                 default = nil)
  if valid_564969 != nil:
    section.add "prebuiltId", valid_564969
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

proc call*(call_564972: Call_ModelGetPrebuilt_564966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the prebuilt entity model.
  ## 
  let valid = call_564972.validator(path, query, header, formData, body)
  let scheme = call_564972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564972.url(scheme.get, call_564972.host, call_564972.base,
                         call_564972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564972, url, valid)

proc call*(call_564973: Call_ModelGetPrebuilt_564966; prebuiltId: string;
          appId: string; versionId: string): Recallable =
  ## modelGetPrebuilt
  ## Gets information about the prebuilt entity model.
  ##   prebuiltId: string (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564974 = newJObject()
  add(path_564974, "prebuiltId", newJString(prebuiltId))
  add(path_564974, "appId", newJString(appId))
  add(path_564974, "versionId", newJString(versionId))
  result = call_564973.call(path_564974, nil, nil, nil, nil)

var modelGetPrebuilt* = Call_ModelGetPrebuilt_564966(name: "modelGetPrebuilt",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{prebuiltId}",
    validator: validate_ModelGetPrebuilt_564967, base: "/luis/api/v2.0",
    url: url_ModelGetPrebuilt_564968, schemes: {Scheme.Https})
type
  Call_ModelDeletePrebuilt_564975 = ref object of OpenApiRestCall_563565
proc url_ModelDeletePrebuilt_564977(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeletePrebuilt_564976(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a prebuilt entity extractor from the application.
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
  var valid_564978 = path.getOrDefault("prebuiltId")
  valid_564978 = validateParameter(valid_564978, JString, required = true,
                                 default = nil)
  if valid_564978 != nil:
    section.add "prebuiltId", valid_564978
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
  if body != nil:
    result.add "body", body

proc call*(call_564981: Call_ModelDeletePrebuilt_564975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a prebuilt entity extractor from the application.
  ## 
  let valid = call_564981.validator(path, query, header, formData, body)
  let scheme = call_564981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564981.url(scheme.get, call_564981.host, call_564981.base,
                         call_564981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564981, url, valid)

proc call*(call_564982: Call_ModelDeletePrebuilt_564975; prebuiltId: string;
          appId: string; versionId: string): Recallable =
  ## modelDeletePrebuilt
  ## Deletes a prebuilt entity extractor from the application.
  ##   prebuiltId: string (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564983 = newJObject()
  add(path_564983, "prebuiltId", newJString(prebuiltId))
  add(path_564983, "appId", newJString(appId))
  add(path_564983, "versionId", newJString(versionId))
  result = call_564982.call(path_564983, nil, nil, nil, nil)

var modelDeletePrebuilt* = Call_ModelDeletePrebuilt_564975(
    name: "modelDeletePrebuilt", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{prebuiltId}",
    validator: validate_ModelDeletePrebuilt_564976, base: "/luis/api/v2.0",
    url: url_ModelDeletePrebuilt_564977, schemes: {Scheme.Https})
type
  Call_VersionsDeleteUnlabelledUtterance_564984 = ref object of OpenApiRestCall_563565
proc url_VersionsDeleteUnlabelledUtterance_564986(protocol: Scheme; host: string;
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

proc validate_VersionsDeleteUnlabelledUtterance_564985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deleted an unlabelled utterance.
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
  var valid_564987 = path.getOrDefault("appId")
  valid_564987 = validateParameter(valid_564987, JString, required = true,
                                 default = nil)
  if valid_564987 != nil:
    section.add "appId", valid_564987
  var valid_564988 = path.getOrDefault("versionId")
  valid_564988 = validateParameter(valid_564988, JString, required = true,
                                 default = nil)
  if valid_564988 != nil:
    section.add "versionId", valid_564988
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

proc call*(call_564990: Call_VersionsDeleteUnlabelledUtterance_564984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deleted an unlabelled utterance.
  ## 
  let valid = call_564990.validator(path, query, header, formData, body)
  let scheme = call_564990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564990.url(scheme.get, call_564990.host, call_564990.base,
                         call_564990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564990, url, valid)

proc call*(call_564991: Call_VersionsDeleteUnlabelledUtterance_564984;
          utterance: JsonNode; appId: string; versionId: string): Recallable =
  ## versionsDeleteUnlabelledUtterance
  ## Deleted an unlabelled utterance.
  ##   utterance: JString (required)
  ##            : The utterance text to delete.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_564992 = newJObject()
  var body_564993 = newJObject()
  if utterance != nil:
    body_564993 = utterance
  add(path_564992, "appId", newJString(appId))
  add(path_564992, "versionId", newJString(versionId))
  result = call_564991.call(path_564992, nil, nil, nil, body_564993)

var versionsDeleteUnlabelledUtterance* = Call_VersionsDeleteUnlabelledUtterance_564984(
    name: "versionsDeleteUnlabelledUtterance", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/suggest",
    validator: validate_VersionsDeleteUnlabelledUtterance_564985,
    base: "/luis/api/v2.0", url: url_VersionsDeleteUnlabelledUtterance_564986,
    schemes: {Scheme.Https})
type
  Call_TrainTrainVersion_565002 = ref object of OpenApiRestCall_563565
proc url_TrainTrainVersion_565004(protocol: Scheme; host: string; base: string;
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

proc validate_TrainTrainVersion_565003(path: JsonNode; query: JsonNode;
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
  var valid_565005 = path.getOrDefault("appId")
  valid_565005 = validateParameter(valid_565005, JString, required = true,
                                 default = nil)
  if valid_565005 != nil:
    section.add "appId", valid_565005
  var valid_565006 = path.getOrDefault("versionId")
  valid_565006 = validateParameter(valid_565006, JString, required = true,
                                 default = nil)
  if valid_565006 != nil:
    section.add "versionId", valid_565006
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565007: Call_TrainTrainVersion_565002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ## 
  let valid = call_565007.validator(path, query, header, formData, body)
  let scheme = call_565007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565007.url(scheme.get, call_565007.host, call_565007.base,
                         call_565007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565007, url, valid)

proc call*(call_565008: Call_TrainTrainVersion_565002; appId: string;
          versionId: string): Recallable =
  ## trainTrainVersion
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565009 = newJObject()
  add(path_565009, "appId", newJString(appId))
  add(path_565009, "versionId", newJString(versionId))
  result = call_565008.call(path_565009, nil, nil, nil, nil)

var trainTrainVersion* = Call_TrainTrainVersion_565002(name: "trainTrainVersion",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/train",
    validator: validate_TrainTrainVersion_565003, base: "/luis/api/v2.0",
    url: url_TrainTrainVersion_565004, schemes: {Scheme.Https})
type
  Call_TrainGetStatus_564994 = ref object of OpenApiRestCall_563565
proc url_TrainGetStatus_564996(protocol: Scheme; host: string; base: string;
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

proc validate_TrainGetStatus_564995(path: JsonNode; query: JsonNode;
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
  var valid_564997 = path.getOrDefault("appId")
  valid_564997 = validateParameter(valid_564997, JString, required = true,
                                 default = nil)
  if valid_564997 != nil:
    section.add "appId", valid_564997
  var valid_564998 = path.getOrDefault("versionId")
  valid_564998 = validateParameter(valid_564998, JString, required = true,
                                 default = nil)
  if valid_564998 != nil:
    section.add "versionId", valid_564998
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564999: Call_TrainGetStatus_564994; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ## 
  let valid = call_564999.validator(path, query, header, formData, body)
  let scheme = call_564999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564999.url(scheme.get, call_564999.host, call_564999.base,
                         call_564999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564999, url, valid)

proc call*(call_565000: Call_TrainGetStatus_564994; appId: string; versionId: string): Recallable =
  ## trainGetStatus
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The version ID.
  var path_565001 = newJObject()
  add(path_565001, "appId", newJString(appId))
  add(path_565001, "versionId", newJString(versionId))
  result = call_565000.call(path_565001, nil, nil, nil, nil)

var trainGetStatus* = Call_TrainGetStatus_564994(name: "trainGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/train",
    validator: validate_TrainGetStatus_564995, base: "/luis/api/v2.0",
    url: url_TrainGetStatus_564996, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
