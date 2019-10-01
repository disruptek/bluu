
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  macServiceName = "cognitiveservices-LUIS-Programmatic"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppsAdd_568200 = ref object of OpenApiRestCall_567667
proc url_AppsAdd_568202(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsAdd_568201(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_568204: Call_AppsAdd_568200; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new LUIS app.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_AppsAdd_568200; applicationCreateObject: JsonNode): Recallable =
  ## appsAdd
  ## Creates a new LUIS app.
  ##   applicationCreateObject: JObject (required)
  ##                          : A model containing Name, Description (optional), Culture, Usage Scenario (optional), Domain (optional) and initial version ID (optional) of the application. Default value for the version ID is 0.1. Note: the culture cannot be changed after the app is created.
  var body_568206 = newJObject()
  if applicationCreateObject != nil:
    body_568206 = applicationCreateObject
  result = call_568205.call(nil, nil, nil, nil, body_568206)

var appsAdd* = Call_AppsAdd_568200(name: "appsAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/apps/",
                                validator: validate_AppsAdd_568201,
                                base: "/luis/api/v2.0", url: url_AppsAdd_568202,
                                schemes: {Scheme.Https})
type
  Call_AppsList_567889 = ref object of OpenApiRestCall_567667
proc url_AppsList_567891(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsList_567890(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the user applications.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568064 = query.getOrDefault("skip")
  valid_568064 = validateParameter(valid_568064, JInt, required = false,
                                 default = newJInt(0))
  if valid_568064 != nil:
    section.add "skip", valid_568064
  var valid_568065 = query.getOrDefault("take")
  valid_568065 = validateParameter(valid_568065, JInt, required = false,
                                 default = newJInt(100))
  if valid_568065 != nil:
    section.add "take", valid_568065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568088: Call_AppsList_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the user applications.
  ## 
  let valid = call_568088.validator(path, query, header, formData, body)
  let scheme = call_568088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568088.url(scheme.get, call_568088.host, call_568088.base,
                         call_568088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568088, url, valid)

proc call*(call_568159: Call_AppsList_567889; skip: int = 0; take: int = 100): Recallable =
  ## appsList
  ## Lists all of the user applications.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  var query_568160 = newJObject()
  add(query_568160, "skip", newJInt(skip))
  add(query_568160, "take", newJInt(take))
  result = call_568159.call(nil, query_568160, nil, nil, nil)

var appsList* = Call_AppsList_567889(name: "appsList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/apps/",
                                  validator: validate_AppsList_567890,
                                  base: "/luis/api/v2.0", url: url_AppsList_567891,
                                  schemes: {Scheme.Https})
type
  Call_AppsListCortanaEndpoints_568207 = ref object of OpenApiRestCall_567667
proc url_AppsListCortanaEndpoints_568209(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListCortanaEndpoints_568208(path: JsonNode; query: JsonNode;
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

proc call*(call_568210: Call_AppsListCortanaEndpoints_568207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_AppsListCortanaEndpoints_568207): Recallable =
  ## appsListCortanaEndpoints
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  result = call_568211.call(nil, nil, nil, nil, nil)

var appsListCortanaEndpoints* = Call_AppsListCortanaEndpoints_568207(
    name: "appsListCortanaEndpoints", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/assistants", validator: validate_AppsListCortanaEndpoints_568208,
    base: "/luis/api/v2.0", url: url_AppsListCortanaEndpoints_568209,
    schemes: {Scheme.Https})
type
  Call_AppsListSupportedCultures_568212 = ref object of OpenApiRestCall_567667
proc url_AppsListSupportedCultures_568214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListSupportedCultures_568213(path: JsonNode; query: JsonNode;
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

proc call*(call_568215: Call_AppsListSupportedCultures_568212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the supported application cultures.
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_AppsListSupportedCultures_568212): Recallable =
  ## appsListSupportedCultures
  ## Gets the supported application cultures.
  result = call_568216.call(nil, nil, nil, nil, nil)

var appsListSupportedCultures* = Call_AppsListSupportedCultures_568212(
    name: "appsListSupportedCultures", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/cultures",
    validator: validate_AppsListSupportedCultures_568213, base: "/luis/api/v2.0",
    url: url_AppsListSupportedCultures_568214, schemes: {Scheme.Https})
type
  Call_AppsAddCustomPrebuiltDomain_568222 = ref object of OpenApiRestCall_567667
proc url_AppsAddCustomPrebuiltDomain_568224(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsAddCustomPrebuiltDomain_568223(path: JsonNode; query: JsonNode;
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

proc call*(call_568226: Call_AppsAddCustomPrebuiltDomain_568222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a prebuilt domain along with its models as a new application.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_AppsAddCustomPrebuiltDomain_568222;
          prebuiltDomainCreateObject: JsonNode): Recallable =
  ## appsAddCustomPrebuiltDomain
  ## Adds a prebuilt domain along with its models as a new application.
  ##   prebuiltDomainCreateObject: JObject (required)
  ##                             : A prebuilt domain create object containing the name and culture of the domain.
  var body_568228 = newJObject()
  if prebuiltDomainCreateObject != nil:
    body_568228 = prebuiltDomainCreateObject
  result = call_568227.call(nil, nil, nil, nil, body_568228)

var appsAddCustomPrebuiltDomain* = Call_AppsAddCustomPrebuiltDomain_568222(
    name: "appsAddCustomPrebuiltDomain", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/customprebuiltdomains",
    validator: validate_AppsAddCustomPrebuiltDomain_568223,
    base: "/luis/api/v2.0", url: url_AppsAddCustomPrebuiltDomain_568224,
    schemes: {Scheme.Https})
type
  Call_AppsListAvailableCustomPrebuiltDomains_568217 = ref object of OpenApiRestCall_567667
proc url_AppsListAvailableCustomPrebuiltDomains_568219(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListAvailableCustomPrebuiltDomains_568218(path: JsonNode;
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

proc call*(call_568220: Call_AppsListAvailableCustomPrebuiltDomains_568217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available custom prebuilt domains for all cultures.
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_AppsListAvailableCustomPrebuiltDomains_568217): Recallable =
  ## appsListAvailableCustomPrebuiltDomains
  ## Gets all the available custom prebuilt domains for all cultures.
  result = call_568221.call(nil, nil, nil, nil, nil)

var appsListAvailableCustomPrebuiltDomains* = Call_AppsListAvailableCustomPrebuiltDomains_568217(
    name: "appsListAvailableCustomPrebuiltDomains", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/customprebuiltdomains",
    validator: validate_AppsListAvailableCustomPrebuiltDomains_568218,
    base: "/luis/api/v2.0", url: url_AppsListAvailableCustomPrebuiltDomains_568219,
    schemes: {Scheme.Https})
type
  Call_AppsListAvailableCustomPrebuiltDomainsForCulture_568229 = ref object of OpenApiRestCall_567667
proc url_AppsListAvailableCustomPrebuiltDomainsForCulture_568231(
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

proc validate_AppsListAvailableCustomPrebuiltDomainsForCulture_568230(
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
  var valid_568246 = path.getOrDefault("culture")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "culture", valid_568246
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568247: Call_AppsListAvailableCustomPrebuiltDomainsForCulture_568229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available custom prebuilt domains for a specific culture.
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_AppsListAvailableCustomPrebuiltDomainsForCulture_568229;
          culture: string): Recallable =
  ## appsListAvailableCustomPrebuiltDomainsForCulture
  ## Gets all the available custom prebuilt domains for a specific culture.
  ##   culture: string (required)
  ##          : Culture.
  var path_568249 = newJObject()
  add(path_568249, "culture", newJString(culture))
  result = call_568248.call(path_568249, nil, nil, nil, nil)

var appsListAvailableCustomPrebuiltDomainsForCulture* = Call_AppsListAvailableCustomPrebuiltDomainsForCulture_568229(
    name: "appsListAvailableCustomPrebuiltDomainsForCulture",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/customprebuiltdomains/{culture}",
    validator: validate_AppsListAvailableCustomPrebuiltDomainsForCulture_568230,
    base: "/luis/api/v2.0",
    url: url_AppsListAvailableCustomPrebuiltDomainsForCulture_568231,
    schemes: {Scheme.Https})
type
  Call_AppsListDomains_568250 = ref object of OpenApiRestCall_567667
proc url_AppsListDomains_568252(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListDomains_568251(path: JsonNode; query: JsonNode;
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

proc call*(call_568253: Call_AppsListDomains_568250; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available application domains.
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_AppsListDomains_568250): Recallable =
  ## appsListDomains
  ## Gets the available application domains.
  result = call_568254.call(nil, nil, nil, nil, nil)

var appsListDomains* = Call_AppsListDomains_568250(name: "appsListDomains",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/domains",
    validator: validate_AppsListDomains_568251, base: "/luis/api/v2.0",
    url: url_AppsListDomains_568252, schemes: {Scheme.Https})
type
  Call_AppsImport_568255 = ref object of OpenApiRestCall_567667
proc url_AppsImport_568257(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsImport_568256(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568258 = query.getOrDefault("appName")
  valid_568258 = validateParameter(valid_568258, JString, required = false,
                                 default = nil)
  if valid_568258 != nil:
    section.add "appName", valid_568258
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

proc call*(call_568260: Call_AppsImport_568255; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an application to LUIS, the application's structure should be included in in the request body.
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_AppsImport_568255; luisApp: JsonNode;
          appName: string = ""): Recallable =
  ## appsImport
  ## Imports an application to LUIS, the application's structure should be included in in the request body.
  ##   appName: string
  ##          : The application name to create. If not specified, the application name will be read from the imported object.
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  var query_568262 = newJObject()
  var body_568263 = newJObject()
  add(query_568262, "appName", newJString(appName))
  if luisApp != nil:
    body_568263 = luisApp
  result = call_568261.call(nil, query_568262, nil, nil, body_568263)

var appsImport* = Call_AppsImport_568255(name: "appsImport",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/apps/import",
                                      validator: validate_AppsImport_568256,
                                      base: "/luis/api/v2.0", url: url_AppsImport_568257,
                                      schemes: {Scheme.Https})
type
  Call_AppsListUsageScenarios_568264 = ref object of OpenApiRestCall_567667
proc url_AppsListUsageScenarios_568266(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListUsageScenarios_568265(path: JsonNode; query: JsonNode;
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

proc call*(call_568267: Call_AppsListUsageScenarios_568264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application available usage scenarios.
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_AppsListUsageScenarios_568264): Recallable =
  ## appsListUsageScenarios
  ## Gets the application available usage scenarios.
  result = call_568268.call(nil, nil, nil, nil, nil)

var appsListUsageScenarios* = Call_AppsListUsageScenarios_568264(
    name: "appsListUsageScenarios", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/usagescenarios", validator: validate_AppsListUsageScenarios_568265,
    base: "/luis/api/v2.0", url: url_AppsListUsageScenarios_568266,
    schemes: {Scheme.Https})
type
  Call_AppsUpdate_568276 = ref object of OpenApiRestCall_567667
proc url_AppsUpdate_568278(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsUpdate_568277(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568279 = path.getOrDefault("appId")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "appId", valid_568279
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

proc call*(call_568281: Call_AppsUpdate_568276; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or description of the application.
  ## 
  let valid = call_568281.validator(path, query, header, formData, body)
  let scheme = call_568281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568281.url(scheme.get, call_568281.host, call_568281.base,
                         call_568281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568281, url, valid)

proc call*(call_568282: Call_AppsUpdate_568276; appId: string;
          applicationUpdateObject: JsonNode): Recallable =
  ## appsUpdate
  ## Updates the name or description of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   applicationUpdateObject: JObject (required)
  ##                          : A model containing Name and Description of the application.
  var path_568283 = newJObject()
  var body_568284 = newJObject()
  add(path_568283, "appId", newJString(appId))
  if applicationUpdateObject != nil:
    body_568284 = applicationUpdateObject
  result = call_568282.call(path_568283, nil, nil, nil, body_568284)

var appsUpdate* = Call_AppsUpdate_568276(name: "appsUpdate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local", route: "/apps/{appId}",
                                      validator: validate_AppsUpdate_568277,
                                      base: "/luis/api/v2.0", url: url_AppsUpdate_568278,
                                      schemes: {Scheme.Https})
type
  Call_AppsGet_568269 = ref object of OpenApiRestCall_567667
proc url_AppsGet_568271(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsGet_568270(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568272 = path.getOrDefault("appId")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "appId", valid_568272
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_AppsGet_568269; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application info.
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_AppsGet_568269; appId: string): Recallable =
  ## appsGet
  ## Gets the application info.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568275 = newJObject()
  add(path_568275, "appId", newJString(appId))
  result = call_568274.call(path_568275, nil, nil, nil, nil)

var appsGet* = Call_AppsGet_568269(name: "appsGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/apps/{appId}",
                                validator: validate_AppsGet_568270,
                                base: "/luis/api/v2.0", url: url_AppsGet_568271,
                                schemes: {Scheme.Https})
type
  Call_AppsDelete_568285 = ref object of OpenApiRestCall_567667
proc url_AppsDelete_568287(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsDelete_568286(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568288 = path.getOrDefault("appId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "appId", valid_568288
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568289: Call_AppsDelete_568285; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application.
  ## 
  let valid = call_568289.validator(path, query, header, formData, body)
  let scheme = call_568289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568289.url(scheme.get, call_568289.host, call_568289.base,
                         call_568289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568289, url, valid)

proc call*(call_568290: Call_AppsDelete_568285; appId: string): Recallable =
  ## appsDelete
  ## Deletes an application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568291 = newJObject()
  add(path_568291, "appId", newJString(appId))
  result = call_568290.call(path_568291, nil, nil, nil, nil)

var appsDelete* = Call_AppsDelete_568285(name: "appsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local", route: "/apps/{appId}",
                                      validator: validate_AppsDelete_568286,
                                      base: "/luis/api/v2.0", url: url_AppsDelete_568287,
                                      schemes: {Scheme.Https})
type
  Call_AppsListEndpoints_568292 = ref object of OpenApiRestCall_567667
proc url_AppsListEndpoints_568294(protocol: Scheme; host: string; base: string;
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

proc validate_AppsListEndpoints_568293(path: JsonNode; query: JsonNode;
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
  var valid_568295 = path.getOrDefault("appId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "appId", valid_568295
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568296: Call_AppsListEndpoints_568292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the available endpoint deployment regions and URLs.
  ## 
  let valid = call_568296.validator(path, query, header, formData, body)
  let scheme = call_568296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568296.url(scheme.get, call_568296.host, call_568296.base,
                         call_568296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568296, url, valid)

proc call*(call_568297: Call_AppsListEndpoints_568292; appId: string): Recallable =
  ## appsListEndpoints
  ## Returns the available endpoint deployment regions and URLs.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568298 = newJObject()
  add(path_568298, "appId", newJString(appId))
  result = call_568297.call(path_568298, nil, nil, nil, nil)

var appsListEndpoints* = Call_AppsListEndpoints_568292(name: "appsListEndpoints",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/endpoints",
    validator: validate_AppsListEndpoints_568293, base: "/luis/api/v2.0",
    url: url_AppsListEndpoints_568294, schemes: {Scheme.Https})
type
  Call_PermissionsUpdate_568306 = ref object of OpenApiRestCall_567667
proc url_PermissionsUpdate_568308(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsUpdate_568307(path: JsonNode; query: JsonNode;
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
  var valid_568309 = path.getOrDefault("appId")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "appId", valid_568309
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

proc call*(call_568311: Call_PermissionsUpdate_568306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces the current users access list with the one sent in the body. If an empty list is sent, all access to other users will be removed.
  ## 
  let valid = call_568311.validator(path, query, header, formData, body)
  let scheme = call_568311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568311.url(scheme.get, call_568311.host, call_568311.base,
                         call_568311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568311, url, valid)

proc call*(call_568312: Call_PermissionsUpdate_568306; collaborators: JsonNode;
          appId: string): Recallable =
  ## permissionsUpdate
  ## Replaces the current users access list with the one sent in the body. If an empty list is sent, all access to other users will be removed.
  ##   collaborators: JObject (required)
  ##                : A model containing a list of user's email addresses.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568313 = newJObject()
  var body_568314 = newJObject()
  if collaborators != nil:
    body_568314 = collaborators
  add(path_568313, "appId", newJString(appId))
  result = call_568312.call(path_568313, nil, nil, nil, body_568314)

var permissionsUpdate* = Call_PermissionsUpdate_568306(name: "permissionsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsUpdate_568307,
    base: "/luis/api/v2.0", url: url_PermissionsUpdate_568308,
    schemes: {Scheme.Https})
type
  Call_PermissionsAdd_568315 = ref object of OpenApiRestCall_567667
proc url_PermissionsAdd_568317(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsAdd_568316(path: JsonNode; query: JsonNode;
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
  var valid_568318 = path.getOrDefault("appId")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "appId", valid_568318
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

proc call*(call_568320: Call_PermissionsAdd_568315; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ## 
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_PermissionsAdd_568315; userToAdd: JsonNode;
          appId: string): Recallable =
  ## permissionsAdd
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ##   userToAdd: JObject (required)
  ##            : A model containing the user's email address.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568322 = newJObject()
  var body_568323 = newJObject()
  if userToAdd != nil:
    body_568323 = userToAdd
  add(path_568322, "appId", newJString(appId))
  result = call_568321.call(path_568322, nil, nil, nil, body_568323)

var permissionsAdd* = Call_PermissionsAdd_568315(name: "permissionsAdd",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsAdd_568316,
    base: "/luis/api/v2.0", url: url_PermissionsAdd_568317, schemes: {Scheme.Https})
type
  Call_PermissionsList_568299 = ref object of OpenApiRestCall_567667
proc url_PermissionsList_568301(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsList_568300(path: JsonNode; query: JsonNode;
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
  var valid_568302 = path.getOrDefault("appId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "appId", valid_568302
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568303: Call_PermissionsList_568299; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of user emails that have permissions to access your application.
  ## 
  let valid = call_568303.validator(path, query, header, formData, body)
  let scheme = call_568303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568303.url(scheme.get, call_568303.host, call_568303.base,
                         call_568303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568303, url, valid)

proc call*(call_568304: Call_PermissionsList_568299; appId: string): Recallable =
  ## permissionsList
  ## Gets the list of user emails that have permissions to access your application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568305 = newJObject()
  add(path_568305, "appId", newJString(appId))
  result = call_568304.call(path_568305, nil, nil, nil, nil)

var permissionsList* = Call_PermissionsList_568299(name: "permissionsList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsList_568300,
    base: "/luis/api/v2.0", url: url_PermissionsList_568301, schemes: {Scheme.Https})
type
  Call_PermissionsDelete_568324 = ref object of OpenApiRestCall_567667
proc url_PermissionsDelete_568326(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsDelete_568325(path: JsonNode; query: JsonNode;
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
  var valid_568327 = path.getOrDefault("appId")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "appId", valid_568327
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

proc call*(call_568329: Call_PermissionsDelete_568324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ## 
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_PermissionsDelete_568324; appId: string;
          userToDelete: JsonNode): Recallable =
  ## permissionsDelete
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ##   appId: string (required)
  ##        : The application ID.
  ##   userToDelete: JObject (required)
  ##               : A model containing the user's email address.
  var path_568331 = newJObject()
  var body_568332 = newJObject()
  add(path_568331, "appId", newJString(appId))
  if userToDelete != nil:
    body_568332 = userToDelete
  result = call_568330.call(path_568331, nil, nil, nil, body_568332)

var permissionsDelete* = Call_PermissionsDelete_568324(name: "permissionsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsDelete_568325,
    base: "/luis/api/v2.0", url: url_PermissionsDelete_568326,
    schemes: {Scheme.Https})
type
  Call_AppsPublish_568333 = ref object of OpenApiRestCall_567667
proc url_AppsPublish_568335(protocol: Scheme; host: string; base: string;
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

proc validate_AppsPublish_568334(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568336 = path.getOrDefault("appId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "appId", valid_568336
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

proc call*(call_568338: Call_AppsPublish_568333; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a specific version of the application.
  ## 
  let valid = call_568338.validator(path, query, header, formData, body)
  let scheme = call_568338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568338.url(scheme.get, call_568338.host, call_568338.base,
                         call_568338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568338, url, valid)

proc call*(call_568339: Call_AppsPublish_568333;
          applicationPublishObject: JsonNode; appId: string): Recallable =
  ## appsPublish
  ## Publishes a specific version of the application.
  ##   applicationPublishObject: JObject (required)
  ##                           : The application publish object. The region is the target region that the application is published to.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568340 = newJObject()
  var body_568341 = newJObject()
  if applicationPublishObject != nil:
    body_568341 = applicationPublishObject
  add(path_568340, "appId", newJString(appId))
  result = call_568339.call(path_568340, nil, nil, nil, body_568341)

var appsPublish* = Call_AppsPublish_568333(name: "appsPublish",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local",
                                        route: "/apps/{appId}/publish",
                                        validator: validate_AppsPublish_568334,
                                        base: "/luis/api/v2.0",
                                        url: url_AppsPublish_568335,
                                        schemes: {Scheme.Https})
type
  Call_AppsDownloadQueryLogs_568342 = ref object of OpenApiRestCall_567667
proc url_AppsDownloadQueryLogs_568344(protocol: Scheme; host: string; base: string;
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

proc validate_AppsDownloadQueryLogs_568343(path: JsonNode; query: JsonNode;
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
  var valid_568345 = path.getOrDefault("appId")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "appId", valid_568345
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568346: Call_AppsDownloadQueryLogs_568342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the query logs of the past month for the application.
  ## 
  let valid = call_568346.validator(path, query, header, formData, body)
  let scheme = call_568346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568346.url(scheme.get, call_568346.host, call_568346.base,
                         call_568346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568346, url, valid)

proc call*(call_568347: Call_AppsDownloadQueryLogs_568342; appId: string): Recallable =
  ## appsDownloadQueryLogs
  ## Gets the query logs of the past month for the application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568348 = newJObject()
  add(path_568348, "appId", newJString(appId))
  result = call_568347.call(path_568348, nil, nil, nil, nil)

var appsDownloadQueryLogs* = Call_AppsDownloadQueryLogs_568342(
    name: "appsDownloadQueryLogs", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/querylogs", validator: validate_AppsDownloadQueryLogs_568343,
    base: "/luis/api/v2.0", url: url_AppsDownloadQueryLogs_568344,
    schemes: {Scheme.Https})
type
  Call_AppsUpdateSettings_568356 = ref object of OpenApiRestCall_567667
proc url_AppsUpdateSettings_568358(protocol: Scheme; host: string; base: string;
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

proc validate_AppsUpdateSettings_568357(path: JsonNode; query: JsonNode;
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
  var valid_568359 = path.getOrDefault("appId")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "appId", valid_568359
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

proc call*(call_568361: Call_AppsUpdateSettings_568356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the application settings.
  ## 
  let valid = call_568361.validator(path, query, header, formData, body)
  let scheme = call_568361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568361.url(scheme.get, call_568361.host, call_568361.base,
                         call_568361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568361, url, valid)

proc call*(call_568362: Call_AppsUpdateSettings_568356; appId: string;
          applicationSettingUpdateObject: JsonNode): Recallable =
  ## appsUpdateSettings
  ## Updates the application settings.
  ##   appId: string (required)
  ##        : The application ID.
  ##   applicationSettingUpdateObject: JObject (required)
  ##                                 : An object containing the new application settings.
  var path_568363 = newJObject()
  var body_568364 = newJObject()
  add(path_568363, "appId", newJString(appId))
  if applicationSettingUpdateObject != nil:
    body_568364 = applicationSettingUpdateObject
  result = call_568362.call(path_568363, nil, nil, nil, body_568364)

var appsUpdateSettings* = Call_AppsUpdateSettings_568356(
    name: "appsUpdateSettings", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/settings", validator: validate_AppsUpdateSettings_568357,
    base: "/luis/api/v2.0", url: url_AppsUpdateSettings_568358,
    schemes: {Scheme.Https})
type
  Call_AppsGetSettings_568349 = ref object of OpenApiRestCall_567667
proc url_AppsGetSettings_568351(protocol: Scheme; host: string; base: string;
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

proc validate_AppsGetSettings_568350(path: JsonNode; query: JsonNode;
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
  var valid_568352 = path.getOrDefault("appId")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "appId", valid_568352
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_AppsGetSettings_568349; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the application settings.
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_AppsGetSettings_568349; appId: string): Recallable =
  ## appsGetSettings
  ## Get the application settings.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568355 = newJObject()
  add(path_568355, "appId", newJString(appId))
  result = call_568354.call(path_568355, nil, nil, nil, nil)

var appsGetSettings* = Call_AppsGetSettings_568349(name: "appsGetSettings",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/settings",
    validator: validate_AppsGetSettings_568350, base: "/luis/api/v2.0",
    url: url_AppsGetSettings_568351, schemes: {Scheme.Https})
type
  Call_VersionsList_568365 = ref object of OpenApiRestCall_567667
proc url_VersionsList_568367(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsList_568366(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568368 = path.getOrDefault("appId")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "appId", valid_568368
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568369 = query.getOrDefault("skip")
  valid_568369 = validateParameter(valid_568369, JInt, required = false,
                                 default = newJInt(0))
  if valid_568369 != nil:
    section.add "skip", valid_568369
  var valid_568370 = query.getOrDefault("take")
  valid_568370 = validateParameter(valid_568370, JInt, required = false,
                                 default = newJInt(100))
  if valid_568370 != nil:
    section.add "take", valid_568370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568371: Call_VersionsList_568365; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application versions info.
  ## 
  let valid = call_568371.validator(path, query, header, formData, body)
  let scheme = call_568371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568371.url(scheme.get, call_568371.host, call_568371.base,
                         call_568371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568371, url, valid)

proc call*(call_568372: Call_VersionsList_568365; appId: string; skip: int = 0;
          take: int = 100): Recallable =
  ## versionsList
  ## Gets the application versions info.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568373 = newJObject()
  var query_568374 = newJObject()
  add(query_568374, "skip", newJInt(skip))
  add(query_568374, "take", newJInt(take))
  add(path_568373, "appId", newJString(appId))
  result = call_568372.call(path_568373, query_568374, nil, nil, nil)

var versionsList* = Call_VersionsList_568365(name: "versionsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions",
    validator: validate_VersionsList_568366, base: "/luis/api/v2.0",
    url: url_VersionsList_568367, schemes: {Scheme.Https})
type
  Call_VersionsImport_568375 = ref object of OpenApiRestCall_567667
proc url_VersionsImport_568377(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsImport_568376(path: JsonNode; query: JsonNode;
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
  var valid_568378 = path.getOrDefault("appId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "appId", valid_568378
  result.add "path", section
  ## parameters in `query` object:
  ##   versionId: JString
  ##            : The new versionId to import. If not specified, the versionId will be read from the imported object.
  section = newJObject()
  var valid_568379 = query.getOrDefault("versionId")
  valid_568379 = validateParameter(valid_568379, JString, required = false,
                                 default = nil)
  if valid_568379 != nil:
    section.add "versionId", valid_568379
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

proc call*(call_568381: Call_VersionsImport_568375; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a new version into a LUIS application.
  ## 
  let valid = call_568381.validator(path, query, header, formData, body)
  let scheme = call_568381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568381.url(scheme.get, call_568381.host, call_568381.base,
                         call_568381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568381, url, valid)

proc call*(call_568382: Call_VersionsImport_568375; appId: string; luisApp: JsonNode;
          versionId: string = ""): Recallable =
  ## versionsImport
  ## Imports a new version into a LUIS application.
  ##   versionId: string
  ##            : The new versionId to import. If not specified, the versionId will be read from the imported object.
  ##   appId: string (required)
  ##        : The application ID.
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  var path_568383 = newJObject()
  var query_568384 = newJObject()
  var body_568385 = newJObject()
  add(query_568384, "versionId", newJString(versionId))
  add(path_568383, "appId", newJString(appId))
  if luisApp != nil:
    body_568385 = luisApp
  result = call_568382.call(path_568383, query_568384, nil, nil, body_568385)

var versionsImport* = Call_VersionsImport_568375(name: "versionsImport",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/import", validator: validate_VersionsImport_568376,
    base: "/luis/api/v2.0", url: url_VersionsImport_568377, schemes: {Scheme.Https})
type
  Call_VersionsUpdate_568394 = ref object of OpenApiRestCall_567667
proc url_VersionsUpdate_568396(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsUpdate_568395(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the name or description of the application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568397 = path.getOrDefault("versionId")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "versionId", valid_568397
  var valid_568398 = path.getOrDefault("appId")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "appId", valid_568398
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

proc call*(call_568400: Call_VersionsUpdate_568394; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or description of the application version.
  ## 
  let valid = call_568400.validator(path, query, header, formData, body)
  let scheme = call_568400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568400.url(scheme.get, call_568400.host, call_568400.base,
                         call_568400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568400, url, valid)

proc call*(call_568401: Call_VersionsUpdate_568394; versionId: string; appId: string;
          versionUpdateObject: JsonNode): Recallable =
  ## versionsUpdate
  ## Updates the name or description of the application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionUpdateObject: JObject (required)
  ##                      : A model containing Name and Description of the application.
  var path_568402 = newJObject()
  var body_568403 = newJObject()
  add(path_568402, "versionId", newJString(versionId))
  add(path_568402, "appId", newJString(appId))
  if versionUpdateObject != nil:
    body_568403 = versionUpdateObject
  result = call_568401.call(path_568402, nil, nil, nil, body_568403)

var versionsUpdate* = Call_VersionsUpdate_568394(name: "versionsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/",
    validator: validate_VersionsUpdate_568395, base: "/luis/api/v2.0",
    url: url_VersionsUpdate_568396, schemes: {Scheme.Https})
type
  Call_VersionsGet_568386 = ref object of OpenApiRestCall_567667
proc url_VersionsGet_568388(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsGet_568387(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the version info.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568389 = path.getOrDefault("versionId")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "versionId", valid_568389
  var valid_568390 = path.getOrDefault("appId")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "appId", valid_568390
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568391: Call_VersionsGet_568386; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the version info.
  ## 
  let valid = call_568391.validator(path, query, header, formData, body)
  let scheme = call_568391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568391.url(scheme.get, call_568391.host, call_568391.base,
                         call_568391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568391, url, valid)

proc call*(call_568392: Call_VersionsGet_568386; versionId: string; appId: string): Recallable =
  ## versionsGet
  ## Gets the version info.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568393 = newJObject()
  add(path_568393, "versionId", newJString(versionId))
  add(path_568393, "appId", newJString(appId))
  result = call_568392.call(path_568393, nil, nil, nil, nil)

var versionsGet* = Call_VersionsGet_568386(name: "versionsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/apps/{appId}/versions/{versionId}/",
                                        validator: validate_VersionsGet_568387,
                                        base: "/luis/api/v2.0",
                                        url: url_VersionsGet_568388,
                                        schemes: {Scheme.Https})
type
  Call_VersionsDelete_568404 = ref object of OpenApiRestCall_567667
proc url_VersionsDelete_568406(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsDelete_568405(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568407 = path.getOrDefault("versionId")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "versionId", valid_568407
  var valid_568408 = path.getOrDefault("appId")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "appId", valid_568408
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568409: Call_VersionsDelete_568404; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application version.
  ## 
  let valid = call_568409.validator(path, query, header, formData, body)
  let scheme = call_568409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568409.url(scheme.get, call_568409.host, call_568409.base,
                         call_568409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568409, url, valid)

proc call*(call_568410: Call_VersionsDelete_568404; versionId: string; appId: string): Recallable =
  ## versionsDelete
  ## Deletes an application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568411 = newJObject()
  add(path_568411, "versionId", newJString(versionId))
  add(path_568411, "appId", newJString(appId))
  result = call_568410.call(path_568411, nil, nil, nil, nil)

var versionsDelete* = Call_VersionsDelete_568404(name: "versionsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/",
    validator: validate_VersionsDelete_568405, base: "/luis/api/v2.0",
    url: url_VersionsDelete_568406, schemes: {Scheme.Https})
type
  Call_VersionsClone_568412 = ref object of OpenApiRestCall_567667
proc url_VersionsClone_568414(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsClone_568413(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new version using the current snapshot of the selected application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568415 = path.getOrDefault("versionId")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "versionId", valid_568415
  var valid_568416 = path.getOrDefault("appId")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "appId", valid_568416
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

proc call*(call_568418: Call_VersionsClone_568412; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new version using the current snapshot of the selected application version.
  ## 
  let valid = call_568418.validator(path, query, header, formData, body)
  let scheme = call_568418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568418.url(scheme.get, call_568418.host, call_568418.base,
                         call_568418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568418, url, valid)

proc call*(call_568419: Call_VersionsClone_568412; versionId: string; appId: string;
          versionCloneObject: JsonNode = nil): Recallable =
  ## versionsClone
  ## Creates a new version using the current snapshot of the selected application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionCloneObject: JObject
  ##                     : A model containing the new version ID.
  var path_568420 = newJObject()
  var body_568421 = newJObject()
  add(path_568420, "versionId", newJString(versionId))
  add(path_568420, "appId", newJString(appId))
  if versionCloneObject != nil:
    body_568421 = versionCloneObject
  result = call_568419.call(path_568420, nil, nil, nil, body_568421)

var versionsClone* = Call_VersionsClone_568412(name: "versionsClone",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/clone",
    validator: validate_VersionsClone_568413, base: "/luis/api/v2.0",
    url: url_VersionsClone_568414, schemes: {Scheme.Https})
type
  Call_ModelAddClosedList_568433 = ref object of OpenApiRestCall_567667
proc url_ModelAddClosedList_568435(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddClosedList_568434(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Adds a closed list model to the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568436 = path.getOrDefault("versionId")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "versionId", valid_568436
  var valid_568437 = path.getOrDefault("appId")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "appId", valid_568437
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

proc call*(call_568439: Call_ModelAddClosedList_568433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a closed list model to the application.
  ## 
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_ModelAddClosedList_568433; versionId: string;
          appId: string; closedListModelCreateObject: JsonNode): Recallable =
  ## modelAddClosedList
  ## Adds a closed list model to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   closedListModelCreateObject: JObject (required)
  ##                              : A model containing the name and words for the new closed list entity extractor.
  var path_568441 = newJObject()
  var body_568442 = newJObject()
  add(path_568441, "versionId", newJString(versionId))
  add(path_568441, "appId", newJString(appId))
  if closedListModelCreateObject != nil:
    body_568442 = closedListModelCreateObject
  result = call_568440.call(path_568441, nil, nil, nil, body_568442)

var modelAddClosedList* = Call_ModelAddClosedList_568433(
    name: "modelAddClosedList", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists",
    validator: validate_ModelAddClosedList_568434, base: "/luis/api/v2.0",
    url: url_ModelAddClosedList_568435, schemes: {Scheme.Https})
type
  Call_ModelListClosedLists_568422 = ref object of OpenApiRestCall_567667
proc url_ModelListClosedLists_568424(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListClosedLists_568423(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the closedlist models.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568425 = path.getOrDefault("versionId")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "versionId", valid_568425
  var valid_568426 = path.getOrDefault("appId")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "appId", valid_568426
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568427 = query.getOrDefault("skip")
  valid_568427 = validateParameter(valid_568427, JInt, required = false,
                                 default = newJInt(0))
  if valid_568427 != nil:
    section.add "skip", valid_568427
  var valid_568428 = query.getOrDefault("take")
  valid_568428 = validateParameter(valid_568428, JInt, required = false,
                                 default = newJInt(100))
  if valid_568428 != nil:
    section.add "take", valid_568428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568429: Call_ModelListClosedLists_568422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the closedlist models.
  ## 
  let valid = call_568429.validator(path, query, header, formData, body)
  let scheme = call_568429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568429.url(scheme.get, call_568429.host, call_568429.base,
                         call_568429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568429, url, valid)

proc call*(call_568430: Call_ModelListClosedLists_568422; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListClosedLists
  ## Gets information about the closedlist models.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568431 = newJObject()
  var query_568432 = newJObject()
  add(path_568431, "versionId", newJString(versionId))
  add(query_568432, "skip", newJInt(skip))
  add(query_568432, "take", newJInt(take))
  add(path_568431, "appId", newJString(appId))
  result = call_568430.call(path_568431, query_568432, nil, nil, nil)

var modelListClosedLists* = Call_ModelListClosedLists_568422(
    name: "modelListClosedLists", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists",
    validator: validate_ModelListClosedLists_568423, base: "/luis/api/v2.0",
    url: url_ModelListClosedLists_568424, schemes: {Scheme.Https})
type
  Call_ModelUpdateClosedList_568452 = ref object of OpenApiRestCall_567667
proc url_ModelUpdateClosedList_568454(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateClosedList_568453(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the closed list model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The closed list model ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568455 = path.getOrDefault("versionId")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "versionId", valid_568455
  var valid_568456 = path.getOrDefault("appId")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "appId", valid_568456
  var valid_568457 = path.getOrDefault("clEntityId")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "clEntityId", valid_568457
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

proc call*(call_568459: Call_ModelUpdateClosedList_568452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the closed list model.
  ## 
  let valid = call_568459.validator(path, query, header, formData, body)
  let scheme = call_568459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568459.url(scheme.get, call_568459.host, call_568459.base,
                         call_568459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568459, url, valid)

proc call*(call_568460: Call_ModelUpdateClosedList_568452; versionId: string;
          closedListModelUpdateObject: JsonNode; appId: string; clEntityId: string): Recallable =
  ## modelUpdateClosedList
  ## Updates the closed list model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   closedListModelUpdateObject: JObject (required)
  ##                              : The new entity name and words list.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The closed list model ID.
  var path_568461 = newJObject()
  var body_568462 = newJObject()
  add(path_568461, "versionId", newJString(versionId))
  if closedListModelUpdateObject != nil:
    body_568462 = closedListModelUpdateObject
  add(path_568461, "appId", newJString(appId))
  add(path_568461, "clEntityId", newJString(clEntityId))
  result = call_568460.call(path_568461, nil, nil, nil, body_568462)

var modelUpdateClosedList* = Call_ModelUpdateClosedList_568452(
    name: "modelUpdateClosedList", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelUpdateClosedList_568453, base: "/luis/api/v2.0",
    url: url_ModelUpdateClosedList_568454, schemes: {Scheme.Https})
type
  Call_ModelGetClosedList_568443 = ref object of OpenApiRestCall_567667
proc url_ModelGetClosedList_568445(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetClosedList_568444(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets information of a closed list model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The closed list model ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568446 = path.getOrDefault("versionId")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "versionId", valid_568446
  var valid_568447 = path.getOrDefault("appId")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "appId", valid_568447
  var valid_568448 = path.getOrDefault("clEntityId")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "clEntityId", valid_568448
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568449: Call_ModelGetClosedList_568443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information of a closed list model.
  ## 
  let valid = call_568449.validator(path, query, header, formData, body)
  let scheme = call_568449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568449.url(scheme.get, call_568449.host, call_568449.base,
                         call_568449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568449, url, valid)

proc call*(call_568450: Call_ModelGetClosedList_568443; versionId: string;
          appId: string; clEntityId: string): Recallable =
  ## modelGetClosedList
  ## Gets information of a closed list model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The closed list model ID.
  var path_568451 = newJObject()
  add(path_568451, "versionId", newJString(versionId))
  add(path_568451, "appId", newJString(appId))
  add(path_568451, "clEntityId", newJString(clEntityId))
  result = call_568450.call(path_568451, nil, nil, nil, nil)

var modelGetClosedList* = Call_ModelGetClosedList_568443(
    name: "modelGetClosedList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelGetClosedList_568444, base: "/luis/api/v2.0",
    url: url_ModelGetClosedList_568445, schemes: {Scheme.Https})
type
  Call_ModelPatchClosedList_568472 = ref object of OpenApiRestCall_567667
proc url_ModelPatchClosedList_568474(protocol: Scheme; host: string; base: string;
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

proc validate_ModelPatchClosedList_568473(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a batch of sublists to an existing closedlist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The closed list model ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568475 = path.getOrDefault("versionId")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "versionId", valid_568475
  var valid_568476 = path.getOrDefault("appId")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "appId", valid_568476
  var valid_568477 = path.getOrDefault("clEntityId")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "clEntityId", valid_568477
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

proc call*(call_568479: Call_ModelPatchClosedList_568472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a batch of sublists to an existing closedlist.
  ## 
  let valid = call_568479.validator(path, query, header, formData, body)
  let scheme = call_568479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568479.url(scheme.get, call_568479.host, call_568479.base,
                         call_568479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568479, url, valid)

proc call*(call_568480: Call_ModelPatchClosedList_568472; versionId: string;
          appId: string; clEntityId: string; closedListModelPatchObject: JsonNode): Recallable =
  ## modelPatchClosedList
  ## Adds a batch of sublists to an existing closedlist.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The closed list model ID.
  ##   closedListModelPatchObject: JObject (required)
  ##                             : A words list batch.
  var path_568481 = newJObject()
  var body_568482 = newJObject()
  add(path_568481, "versionId", newJString(versionId))
  add(path_568481, "appId", newJString(appId))
  add(path_568481, "clEntityId", newJString(clEntityId))
  if closedListModelPatchObject != nil:
    body_568482 = closedListModelPatchObject
  result = call_568480.call(path_568481, nil, nil, nil, body_568482)

var modelPatchClosedList* = Call_ModelPatchClosedList_568472(
    name: "modelPatchClosedList", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelPatchClosedList_568473, base: "/luis/api/v2.0",
    url: url_ModelPatchClosedList_568474, schemes: {Scheme.Https})
type
  Call_ModelDeleteClosedList_568463 = ref object of OpenApiRestCall_567667
proc url_ModelDeleteClosedList_568465(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteClosedList_568464(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a closed list model from the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The closed list model ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568466 = path.getOrDefault("versionId")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "versionId", valid_568466
  var valid_568467 = path.getOrDefault("appId")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "appId", valid_568467
  var valid_568468 = path.getOrDefault("clEntityId")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "clEntityId", valid_568468
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568469: Call_ModelDeleteClosedList_568463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a closed list model from the application.
  ## 
  let valid = call_568469.validator(path, query, header, formData, body)
  let scheme = call_568469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568469.url(scheme.get, call_568469.host, call_568469.base,
                         call_568469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568469, url, valid)

proc call*(call_568470: Call_ModelDeleteClosedList_568463; versionId: string;
          appId: string; clEntityId: string): Recallable =
  ## modelDeleteClosedList
  ## Deletes a closed list model from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The closed list model ID.
  var path_568471 = newJObject()
  add(path_568471, "versionId", newJString(versionId))
  add(path_568471, "appId", newJString(appId))
  add(path_568471, "clEntityId", newJString(clEntityId))
  result = call_568470.call(path_568471, nil, nil, nil, nil)

var modelDeleteClosedList* = Call_ModelDeleteClosedList_568463(
    name: "modelDeleteClosedList", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelDeleteClosedList_568464, base: "/luis/api/v2.0",
    url: url_ModelDeleteClosedList_568465, schemes: {Scheme.Https})
type
  Call_ModelAddSubList_568483 = ref object of OpenApiRestCall_567667
proc url_ModelAddSubList_568485(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddSubList_568484(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Adds a list to an existing closed list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The closed list entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568486 = path.getOrDefault("versionId")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "versionId", valid_568486
  var valid_568487 = path.getOrDefault("appId")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "appId", valid_568487
  var valid_568488 = path.getOrDefault("clEntityId")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "clEntityId", valid_568488
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

proc call*(call_568490: Call_ModelAddSubList_568483; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a list to an existing closed list.
  ## 
  let valid = call_568490.validator(path, query, header, formData, body)
  let scheme = call_568490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568490.url(scheme.get, call_568490.host, call_568490.base,
                         call_568490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568490, url, valid)

proc call*(call_568491: Call_ModelAddSubList_568483; versionId: string;
          wordListCreateObject: JsonNode; appId: string; clEntityId: string): Recallable =
  ## modelAddSubList
  ## Adds a list to an existing closed list.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   wordListCreateObject: JObject (required)
  ##                       : Words list.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The closed list entity extractor ID.
  var path_568492 = newJObject()
  var body_568493 = newJObject()
  add(path_568492, "versionId", newJString(versionId))
  if wordListCreateObject != nil:
    body_568493 = wordListCreateObject
  add(path_568492, "appId", newJString(appId))
  add(path_568492, "clEntityId", newJString(clEntityId))
  result = call_568491.call(path_568492, nil, nil, nil, body_568493)

var modelAddSubList* = Call_ModelAddSubList_568483(name: "modelAddSubList",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists",
    validator: validate_ModelAddSubList_568484, base: "/luis/api/v2.0",
    url: url_ModelAddSubList_568485, schemes: {Scheme.Https})
type
  Call_ModelUpdateSubList_568494 = ref object of OpenApiRestCall_567667
proc url_ModelUpdateSubList_568496(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateSubList_568495(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates one of the closed list's sublists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The closed list entity extractor ID.
  ##   subListId: JInt (required)
  ##            : The sublist ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568497 = path.getOrDefault("versionId")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "versionId", valid_568497
  var valid_568498 = path.getOrDefault("appId")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "appId", valid_568498
  var valid_568499 = path.getOrDefault("clEntityId")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "clEntityId", valid_568499
  var valid_568500 = path.getOrDefault("subListId")
  valid_568500 = validateParameter(valid_568500, JInt, required = true, default = nil)
  if valid_568500 != nil:
    section.add "subListId", valid_568500
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

proc call*(call_568502: Call_ModelUpdateSubList_568494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates one of the closed list's sublists.
  ## 
  let valid = call_568502.validator(path, query, header, formData, body)
  let scheme = call_568502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568502.url(scheme.get, call_568502.host, call_568502.base,
                         call_568502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568502, url, valid)

proc call*(call_568503: Call_ModelUpdateSubList_568494; versionId: string;
          wordListBaseUpdateObject: JsonNode; appId: string; clEntityId: string;
          subListId: int): Recallable =
  ## modelUpdateSubList
  ## Updates one of the closed list's sublists.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   wordListBaseUpdateObject: JObject (required)
  ##                           : A sublist update object containing the new canonical form and the list of words.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The closed list entity extractor ID.
  ##   subListId: int (required)
  ##            : The sublist ID.
  var path_568504 = newJObject()
  var body_568505 = newJObject()
  add(path_568504, "versionId", newJString(versionId))
  if wordListBaseUpdateObject != nil:
    body_568505 = wordListBaseUpdateObject
  add(path_568504, "appId", newJString(appId))
  add(path_568504, "clEntityId", newJString(clEntityId))
  add(path_568504, "subListId", newJInt(subListId))
  result = call_568503.call(path_568504, nil, nil, nil, body_568505)

var modelUpdateSubList* = Call_ModelUpdateSubList_568494(
    name: "modelUpdateSubList", meth: HttpMethod.HttpPut, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists/{subListId}",
    validator: validate_ModelUpdateSubList_568495, base: "/luis/api/v2.0",
    url: url_ModelUpdateSubList_568496, schemes: {Scheme.Https})
type
  Call_ModelDeleteSubList_568506 = ref object of OpenApiRestCall_567667
proc url_ModelDeleteSubList_568508(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteSubList_568507(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a sublist of a specific closed list model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The closed list entity extractor ID.
  ##   subListId: JInt (required)
  ##            : The sublist ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568509 = path.getOrDefault("versionId")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "versionId", valid_568509
  var valid_568510 = path.getOrDefault("appId")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "appId", valid_568510
  var valid_568511 = path.getOrDefault("clEntityId")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "clEntityId", valid_568511
  var valid_568512 = path.getOrDefault("subListId")
  valid_568512 = validateParameter(valid_568512, JInt, required = true, default = nil)
  if valid_568512 != nil:
    section.add "subListId", valid_568512
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568513: Call_ModelDeleteSubList_568506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a sublist of a specific closed list model.
  ## 
  let valid = call_568513.validator(path, query, header, formData, body)
  let scheme = call_568513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568513.url(scheme.get, call_568513.host, call_568513.base,
                         call_568513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568513, url, valid)

proc call*(call_568514: Call_ModelDeleteSubList_568506; versionId: string;
          appId: string; clEntityId: string; subListId: int): Recallable =
  ## modelDeleteSubList
  ## Deletes a sublist of a specific closed list model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The closed list entity extractor ID.
  ##   subListId: int (required)
  ##            : The sublist ID.
  var path_568515 = newJObject()
  add(path_568515, "versionId", newJString(versionId))
  add(path_568515, "appId", newJString(appId))
  add(path_568515, "clEntityId", newJString(clEntityId))
  add(path_568515, "subListId", newJInt(subListId))
  result = call_568514.call(path_568515, nil, nil, nil, nil)

var modelDeleteSubList* = Call_ModelDeleteSubList_568506(
    name: "modelDeleteSubList", meth: HttpMethod.HttpDelete, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists/{subListId}",
    validator: validate_ModelDeleteSubList_568507, base: "/luis/api/v2.0",
    url: url_ModelDeleteSubList_568508, schemes: {Scheme.Https})
type
  Call_ModelAddCompositeEntity_568527 = ref object of OpenApiRestCall_567667
proc url_ModelAddCompositeEntity_568529(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddCompositeEntity_568528(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a composite entity extractor to the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568530 = path.getOrDefault("versionId")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "versionId", valid_568530
  var valid_568531 = path.getOrDefault("appId")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "appId", valid_568531
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

proc call*(call_568533: Call_ModelAddCompositeEntity_568527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a composite entity extractor to the application.
  ## 
  let valid = call_568533.validator(path, query, header, formData, body)
  let scheme = call_568533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568533.url(scheme.get, call_568533.host, call_568533.base,
                         call_568533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568533, url, valid)

proc call*(call_568534: Call_ModelAddCompositeEntity_568527; versionId: string;
          appId: string; compositeModelCreateObject: JsonNode): Recallable =
  ## modelAddCompositeEntity
  ## Adds a composite entity extractor to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   compositeModelCreateObject: JObject (required)
  ##                             : A model containing the name and children of the new entity extractor.
  var path_568535 = newJObject()
  var body_568536 = newJObject()
  add(path_568535, "versionId", newJString(versionId))
  add(path_568535, "appId", newJString(appId))
  if compositeModelCreateObject != nil:
    body_568536 = compositeModelCreateObject
  result = call_568534.call(path_568535, nil, nil, nil, body_568536)

var modelAddCompositeEntity* = Call_ModelAddCompositeEntity_568527(
    name: "modelAddCompositeEntity", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities",
    validator: validate_ModelAddCompositeEntity_568528, base: "/luis/api/v2.0",
    url: url_ModelAddCompositeEntity_568529, schemes: {Scheme.Https})
type
  Call_ModelListCompositeEntities_568516 = ref object of OpenApiRestCall_567667
proc url_ModelListCompositeEntities_568518(protocol: Scheme; host: string;
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

proc validate_ModelListCompositeEntities_568517(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the composite entity models.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568519 = path.getOrDefault("versionId")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "versionId", valid_568519
  var valid_568520 = path.getOrDefault("appId")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "appId", valid_568520
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568521 = query.getOrDefault("skip")
  valid_568521 = validateParameter(valid_568521, JInt, required = false,
                                 default = newJInt(0))
  if valid_568521 != nil:
    section.add "skip", valid_568521
  var valid_568522 = query.getOrDefault("take")
  valid_568522 = validateParameter(valid_568522, JInt, required = false,
                                 default = newJInt(100))
  if valid_568522 != nil:
    section.add "take", valid_568522
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568523: Call_ModelListCompositeEntities_568516; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the composite entity models.
  ## 
  let valid = call_568523.validator(path, query, header, formData, body)
  let scheme = call_568523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568523.url(scheme.get, call_568523.host, call_568523.base,
                         call_568523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568523, url, valid)

proc call*(call_568524: Call_ModelListCompositeEntities_568516; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListCompositeEntities
  ## Gets information about the composite entity models.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568525 = newJObject()
  var query_568526 = newJObject()
  add(path_568525, "versionId", newJString(versionId))
  add(query_568526, "skip", newJInt(skip))
  add(query_568526, "take", newJInt(take))
  add(path_568525, "appId", newJString(appId))
  result = call_568524.call(path_568525, query_568526, nil, nil, nil)

var modelListCompositeEntities* = Call_ModelListCompositeEntities_568516(
    name: "modelListCompositeEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities",
    validator: validate_ModelListCompositeEntities_568517, base: "/luis/api/v2.0",
    url: url_ModelListCompositeEntities_568518, schemes: {Scheme.Https})
type
  Call_ModelUpdateCompositeEntity_568546 = ref object of OpenApiRestCall_567667
proc url_ModelUpdateCompositeEntity_568548(protocol: Scheme; host: string;
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

proc validate_ModelUpdateCompositeEntity_568547(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the composite entity extractor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568549 = path.getOrDefault("versionId")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "versionId", valid_568549
  var valid_568550 = path.getOrDefault("appId")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "appId", valid_568550
  var valid_568551 = path.getOrDefault("cEntityId")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "cEntityId", valid_568551
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

proc call*(call_568553: Call_ModelUpdateCompositeEntity_568546; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the composite entity extractor.
  ## 
  let valid = call_568553.validator(path, query, header, formData, body)
  let scheme = call_568553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568553.url(scheme.get, call_568553.host, call_568553.base,
                         call_568553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568553, url, valid)

proc call*(call_568554: Call_ModelUpdateCompositeEntity_568546; versionId: string;
          compositeModelUpdateObject: JsonNode; appId: string; cEntityId: string): Recallable =
  ## modelUpdateCompositeEntity
  ## Updates the composite entity extractor.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   compositeModelUpdateObject: JObject (required)
  ##                             : A model object containing the new entity extractor name and children.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568555 = newJObject()
  var body_568556 = newJObject()
  add(path_568555, "versionId", newJString(versionId))
  if compositeModelUpdateObject != nil:
    body_568556 = compositeModelUpdateObject
  add(path_568555, "appId", newJString(appId))
  add(path_568555, "cEntityId", newJString(cEntityId))
  result = call_568554.call(path_568555, nil, nil, nil, body_568556)

var modelUpdateCompositeEntity* = Call_ModelUpdateCompositeEntity_568546(
    name: "modelUpdateCompositeEntity", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelUpdateCompositeEntity_568547, base: "/luis/api/v2.0",
    url: url_ModelUpdateCompositeEntity_568548, schemes: {Scheme.Https})
type
  Call_ModelGetCompositeEntity_568537 = ref object of OpenApiRestCall_567667
proc url_ModelGetCompositeEntity_568539(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetCompositeEntity_568538(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the composite entity model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568540 = path.getOrDefault("versionId")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "versionId", valid_568540
  var valid_568541 = path.getOrDefault("appId")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "appId", valid_568541
  var valid_568542 = path.getOrDefault("cEntityId")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "cEntityId", valid_568542
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568543: Call_ModelGetCompositeEntity_568537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the composite entity model.
  ## 
  let valid = call_568543.validator(path, query, header, formData, body)
  let scheme = call_568543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568543.url(scheme.get, call_568543.host, call_568543.base,
                         call_568543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568543, url, valid)

proc call*(call_568544: Call_ModelGetCompositeEntity_568537; versionId: string;
          appId: string; cEntityId: string): Recallable =
  ## modelGetCompositeEntity
  ## Gets information about the composite entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568545 = newJObject()
  add(path_568545, "versionId", newJString(versionId))
  add(path_568545, "appId", newJString(appId))
  add(path_568545, "cEntityId", newJString(cEntityId))
  result = call_568544.call(path_568545, nil, nil, nil, nil)

var modelGetCompositeEntity* = Call_ModelGetCompositeEntity_568537(
    name: "modelGetCompositeEntity", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelGetCompositeEntity_568538, base: "/luis/api/v2.0",
    url: url_ModelGetCompositeEntity_568539, schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntity_568557 = ref object of OpenApiRestCall_567667
proc url_ModelDeleteCompositeEntity_568559(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCompositeEntity_568558(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a composite entity extractor from the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568560 = path.getOrDefault("versionId")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "versionId", valid_568560
  var valid_568561 = path.getOrDefault("appId")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "appId", valid_568561
  var valid_568562 = path.getOrDefault("cEntityId")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "cEntityId", valid_568562
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568563: Call_ModelDeleteCompositeEntity_568557; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a composite entity extractor from the application.
  ## 
  let valid = call_568563.validator(path, query, header, formData, body)
  let scheme = call_568563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568563.url(scheme.get, call_568563.host, call_568563.base,
                         call_568563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568563, url, valid)

proc call*(call_568564: Call_ModelDeleteCompositeEntity_568557; versionId: string;
          appId: string; cEntityId: string): Recallable =
  ## modelDeleteCompositeEntity
  ## Deletes a composite entity extractor from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568565 = newJObject()
  add(path_568565, "versionId", newJString(versionId))
  add(path_568565, "appId", newJString(appId))
  add(path_568565, "cEntityId", newJString(cEntityId))
  result = call_568564.call(path_568565, nil, nil, nil, nil)

var modelDeleteCompositeEntity* = Call_ModelDeleteCompositeEntity_568557(
    name: "modelDeleteCompositeEntity", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelDeleteCompositeEntity_568558, base: "/luis/api/v2.0",
    url: url_ModelDeleteCompositeEntity_568559, schemes: {Scheme.Https})
type
  Call_ModelAddCompositeEntityChild_568566 = ref object of OpenApiRestCall_567667
proc url_ModelAddCompositeEntityChild_568568(protocol: Scheme; host: string;
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

proc validate_ModelAddCompositeEntityChild_568567(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a single child in an existing composite entity model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568569 = path.getOrDefault("versionId")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "versionId", valid_568569
  var valid_568570 = path.getOrDefault("appId")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "appId", valid_568570
  var valid_568571 = path.getOrDefault("cEntityId")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "cEntityId", valid_568571
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

proc call*(call_568573: Call_ModelAddCompositeEntityChild_568566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a single child in an existing composite entity model.
  ## 
  let valid = call_568573.validator(path, query, header, formData, body)
  let scheme = call_568573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568573.url(scheme.get, call_568573.host, call_568573.base,
                         call_568573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568573, url, valid)

proc call*(call_568574: Call_ModelAddCompositeEntityChild_568566;
          versionId: string; compositeChildModelCreateObject: JsonNode;
          appId: string; cEntityId: string): Recallable =
  ## modelAddCompositeEntityChild
  ## Creates a single child in an existing composite entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   compositeChildModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the new composite child model.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568575 = newJObject()
  var body_568576 = newJObject()
  add(path_568575, "versionId", newJString(versionId))
  if compositeChildModelCreateObject != nil:
    body_568576 = compositeChildModelCreateObject
  add(path_568575, "appId", newJString(appId))
  add(path_568575, "cEntityId", newJString(cEntityId))
  result = call_568574.call(path_568575, nil, nil, nil, body_568576)

var modelAddCompositeEntityChild* = Call_ModelAddCompositeEntityChild_568566(
    name: "modelAddCompositeEntityChild", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/children",
    validator: validate_ModelAddCompositeEntityChild_568567,
    base: "/luis/api/v2.0", url: url_ModelAddCompositeEntityChild_568568,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntityChild_568577 = ref object of OpenApiRestCall_567667
proc url_ModelDeleteCompositeEntityChild_568579(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCompositeEntityChild_568578(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a composite entity extractor child from the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   cChildId: JString (required)
  ##           : The hierarchical entity extractor child ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568580 = path.getOrDefault("versionId")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "versionId", valid_568580
  var valid_568581 = path.getOrDefault("cChildId")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "cChildId", valid_568581
  var valid_568582 = path.getOrDefault("appId")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "appId", valid_568582
  var valid_568583 = path.getOrDefault("cEntityId")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "cEntityId", valid_568583
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568584: Call_ModelDeleteCompositeEntityChild_568577;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a composite entity extractor child from the application.
  ## 
  let valid = call_568584.validator(path, query, header, formData, body)
  let scheme = call_568584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568584.url(scheme.get, call_568584.host, call_568584.base,
                         call_568584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568584, url, valid)

proc call*(call_568585: Call_ModelDeleteCompositeEntityChild_568577;
          versionId: string; cChildId: string; appId: string; cEntityId: string): Recallable =
  ## modelDeleteCompositeEntityChild
  ## Deletes a composite entity extractor child from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   cChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568586 = newJObject()
  add(path_568586, "versionId", newJString(versionId))
  add(path_568586, "cChildId", newJString(cChildId))
  add(path_568586, "appId", newJString(appId))
  add(path_568586, "cEntityId", newJString(cEntityId))
  result = call_568585.call(path_568586, nil, nil, nil, nil)

var modelDeleteCompositeEntityChild* = Call_ModelDeleteCompositeEntityChild_568577(
    name: "modelDeleteCompositeEntityChild", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/children/{cChildId}",
    validator: validate_ModelDeleteCompositeEntityChild_568578,
    base: "/luis/api/v2.0", url: url_ModelDeleteCompositeEntityChild_568579,
    schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltDomain_568587 = ref object of OpenApiRestCall_567667
proc url_ModelAddCustomPrebuiltDomain_568589(protocol: Scheme; host: string;
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

proc validate_ModelAddCustomPrebuiltDomain_568588(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a customizable prebuilt domain along with all of its models to this application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568590 = path.getOrDefault("versionId")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "versionId", valid_568590
  var valid_568591 = path.getOrDefault("appId")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "appId", valid_568591
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

proc call*(call_568593: Call_ModelAddCustomPrebuiltDomain_568587; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a customizable prebuilt domain along with all of its models to this application.
  ## 
  let valid = call_568593.validator(path, query, header, formData, body)
  let scheme = call_568593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568593.url(scheme.get, call_568593.host, call_568593.base,
                         call_568593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568593, url, valid)

proc call*(call_568594: Call_ModelAddCustomPrebuiltDomain_568587;
          versionId: string; appId: string; prebuiltDomainObject: JsonNode): Recallable =
  ## modelAddCustomPrebuiltDomain
  ## Adds a customizable prebuilt domain along with all of its models to this application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   prebuiltDomainObject: JObject (required)
  ##                       : A prebuilt domain create object containing the name of the domain.
  var path_568595 = newJObject()
  var body_568596 = newJObject()
  add(path_568595, "versionId", newJString(versionId))
  add(path_568595, "appId", newJString(appId))
  if prebuiltDomainObject != nil:
    body_568596 = prebuiltDomainObject
  result = call_568594.call(path_568595, nil, nil, nil, body_568596)

var modelAddCustomPrebuiltDomain* = Call_ModelAddCustomPrebuiltDomain_568587(
    name: "modelAddCustomPrebuiltDomain", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltdomains",
    validator: validate_ModelAddCustomPrebuiltDomain_568588,
    base: "/luis/api/v2.0", url: url_ModelAddCustomPrebuiltDomain_568589,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteCustomPrebuiltDomain_568597 = ref object of OpenApiRestCall_567667
proc url_ModelDeleteCustomPrebuiltDomain_568599(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCustomPrebuiltDomain_568598(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a prebuilt domain's models from the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   domainName: JString (required)
  ##             : Domain name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568600 = path.getOrDefault("versionId")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "versionId", valid_568600
  var valid_568601 = path.getOrDefault("appId")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "appId", valid_568601
  var valid_568602 = path.getOrDefault("domainName")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "domainName", valid_568602
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568603: Call_ModelDeleteCustomPrebuiltDomain_568597;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a prebuilt domain's models from the application.
  ## 
  let valid = call_568603.validator(path, query, header, formData, body)
  let scheme = call_568603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568603.url(scheme.get, call_568603.host, call_568603.base,
                         call_568603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568603, url, valid)

proc call*(call_568604: Call_ModelDeleteCustomPrebuiltDomain_568597;
          versionId: string; appId: string; domainName: string): Recallable =
  ## modelDeleteCustomPrebuiltDomain
  ## Deletes a prebuilt domain's models from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   domainName: string (required)
  ##             : Domain name.
  var path_568605 = newJObject()
  add(path_568605, "versionId", newJString(versionId))
  add(path_568605, "appId", newJString(appId))
  add(path_568605, "domainName", newJString(domainName))
  result = call_568604.call(path_568605, nil, nil, nil, nil)

var modelDeleteCustomPrebuiltDomain* = Call_ModelDeleteCustomPrebuiltDomain_568597(
    name: "modelDeleteCustomPrebuiltDomain", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltdomains/{domainName}",
    validator: validate_ModelDeleteCustomPrebuiltDomain_568598,
    base: "/luis/api/v2.0", url: url_ModelDeleteCustomPrebuiltDomain_568599,
    schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltEntity_568614 = ref object of OpenApiRestCall_567667
proc url_ModelAddCustomPrebuiltEntity_568616(protocol: Scheme; host: string;
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

proc validate_ModelAddCustomPrebuiltEntity_568615(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a custom prebuilt entity model to the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568617 = path.getOrDefault("versionId")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "versionId", valid_568617
  var valid_568618 = path.getOrDefault("appId")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "appId", valid_568618
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

proc call*(call_568620: Call_ModelAddCustomPrebuiltEntity_568614; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a custom prebuilt entity model to the application.
  ## 
  let valid = call_568620.validator(path, query, header, formData, body)
  let scheme = call_568620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568620.url(scheme.get, call_568620.host, call_568620.base,
                         call_568620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568620, url, valid)

proc call*(call_568621: Call_ModelAddCustomPrebuiltEntity_568614;
          prebuiltDomainModelCreateObject: JsonNode; versionId: string;
          appId: string): Recallable =
  ## modelAddCustomPrebuiltEntity
  ## Adds a custom prebuilt entity model to the application.
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the custom prebuilt entity and the name of the domain to which this model belongs.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568622 = newJObject()
  var body_568623 = newJObject()
  if prebuiltDomainModelCreateObject != nil:
    body_568623 = prebuiltDomainModelCreateObject
  add(path_568622, "versionId", newJString(versionId))
  add(path_568622, "appId", newJString(appId))
  result = call_568621.call(path_568622, nil, nil, nil, body_568623)

var modelAddCustomPrebuiltEntity* = Call_ModelAddCustomPrebuiltEntity_568614(
    name: "modelAddCustomPrebuiltEntity", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltentities",
    validator: validate_ModelAddCustomPrebuiltEntity_568615,
    base: "/luis/api/v2.0", url: url_ModelAddCustomPrebuiltEntity_568616,
    schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltEntities_568606 = ref object of OpenApiRestCall_567667
proc url_ModelListCustomPrebuiltEntities_568608(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltEntities_568607(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all custom prebuilt entities information of this application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568609 = path.getOrDefault("versionId")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "versionId", valid_568609
  var valid_568610 = path.getOrDefault("appId")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "appId", valid_568610
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568611: Call_ModelListCustomPrebuiltEntities_568606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all custom prebuilt entities information of this application.
  ## 
  let valid = call_568611.validator(path, query, header, formData, body)
  let scheme = call_568611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568611.url(scheme.get, call_568611.host, call_568611.base,
                         call_568611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568611, url, valid)

proc call*(call_568612: Call_ModelListCustomPrebuiltEntities_568606;
          versionId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltEntities
  ## Gets all custom prebuilt entities information of this application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568613 = newJObject()
  add(path_568613, "versionId", newJString(versionId))
  add(path_568613, "appId", newJString(appId))
  result = call_568612.call(path_568613, nil, nil, nil, nil)

var modelListCustomPrebuiltEntities* = Call_ModelListCustomPrebuiltEntities_568606(
    name: "modelListCustomPrebuiltEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltentities",
    validator: validate_ModelListCustomPrebuiltEntities_568607,
    base: "/luis/api/v2.0", url: url_ModelListCustomPrebuiltEntities_568608,
    schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltIntent_568632 = ref object of OpenApiRestCall_567667
proc url_ModelAddCustomPrebuiltIntent_568634(protocol: Scheme; host: string;
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

proc validate_ModelAddCustomPrebuiltIntent_568633(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a custom prebuilt intent model to the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568635 = path.getOrDefault("versionId")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "versionId", valid_568635
  var valid_568636 = path.getOrDefault("appId")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "appId", valid_568636
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

proc call*(call_568638: Call_ModelAddCustomPrebuiltIntent_568632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a custom prebuilt intent model to the application.
  ## 
  let valid = call_568638.validator(path, query, header, formData, body)
  let scheme = call_568638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568638.url(scheme.get, call_568638.host, call_568638.base,
                         call_568638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568638, url, valid)

proc call*(call_568639: Call_ModelAddCustomPrebuiltIntent_568632;
          prebuiltDomainModelCreateObject: JsonNode; versionId: string;
          appId: string): Recallable =
  ## modelAddCustomPrebuiltIntent
  ## Adds a custom prebuilt intent model to the application.
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the custom prebuilt intent and the name of the domain to which this model belongs.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568640 = newJObject()
  var body_568641 = newJObject()
  if prebuiltDomainModelCreateObject != nil:
    body_568641 = prebuiltDomainModelCreateObject
  add(path_568640, "versionId", newJString(versionId))
  add(path_568640, "appId", newJString(appId))
  result = call_568639.call(path_568640, nil, nil, nil, body_568641)

var modelAddCustomPrebuiltIntent* = Call_ModelAddCustomPrebuiltIntent_568632(
    name: "modelAddCustomPrebuiltIntent", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltintents",
    validator: validate_ModelAddCustomPrebuiltIntent_568633,
    base: "/luis/api/v2.0", url: url_ModelAddCustomPrebuiltIntent_568634,
    schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltIntents_568624 = ref object of OpenApiRestCall_567667
proc url_ModelListCustomPrebuiltIntents_568626(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltIntents_568625(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets custom prebuilt intents information of this application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568627 = path.getOrDefault("versionId")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "versionId", valid_568627
  var valid_568628 = path.getOrDefault("appId")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "appId", valid_568628
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568629: Call_ModelListCustomPrebuiltIntents_568624; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets custom prebuilt intents information of this application.
  ## 
  let valid = call_568629.validator(path, query, header, formData, body)
  let scheme = call_568629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568629.url(scheme.get, call_568629.host, call_568629.base,
                         call_568629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568629, url, valid)

proc call*(call_568630: Call_ModelListCustomPrebuiltIntents_568624;
          versionId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltIntents
  ## Gets custom prebuilt intents information of this application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568631 = newJObject()
  add(path_568631, "versionId", newJString(versionId))
  add(path_568631, "appId", newJString(appId))
  result = call_568630.call(path_568631, nil, nil, nil, nil)

var modelListCustomPrebuiltIntents* = Call_ModelListCustomPrebuiltIntents_568624(
    name: "modelListCustomPrebuiltIntents", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltintents",
    validator: validate_ModelListCustomPrebuiltIntents_568625,
    base: "/luis/api/v2.0", url: url_ModelListCustomPrebuiltIntents_568626,
    schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltModels_568642 = ref object of OpenApiRestCall_567667
proc url_ModelListCustomPrebuiltModels_568644(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltModels_568643(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all custom prebuilt models information of this application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568645 = path.getOrDefault("versionId")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "versionId", valid_568645
  var valid_568646 = path.getOrDefault("appId")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "appId", valid_568646
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568647: Call_ModelListCustomPrebuiltModels_568642; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all custom prebuilt models information of this application.
  ## 
  let valid = call_568647.validator(path, query, header, formData, body)
  let scheme = call_568647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568647.url(scheme.get, call_568647.host, call_568647.base,
                         call_568647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568647, url, valid)

proc call*(call_568648: Call_ModelListCustomPrebuiltModels_568642;
          versionId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltModels
  ## Gets all custom prebuilt models information of this application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568649 = newJObject()
  add(path_568649, "versionId", newJString(versionId))
  add(path_568649, "appId", newJString(appId))
  result = call_568648.call(path_568649, nil, nil, nil, nil)

var modelListCustomPrebuiltModels* = Call_ModelListCustomPrebuiltModels_568642(
    name: "modelListCustomPrebuiltModels", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltmodels",
    validator: validate_ModelListCustomPrebuiltModels_568643,
    base: "/luis/api/v2.0", url: url_ModelListCustomPrebuiltModels_568644,
    schemes: {Scheme.Https})
type
  Call_ModelAddEntity_568661 = ref object of OpenApiRestCall_567667
proc url_ModelAddEntity_568663(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddEntity_568662(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Adds an entity extractor to the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568664 = path.getOrDefault("versionId")
  valid_568664 = validateParameter(valid_568664, JString, required = true,
                                 default = nil)
  if valid_568664 != nil:
    section.add "versionId", valid_568664
  var valid_568665 = path.getOrDefault("appId")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "appId", valid_568665
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

proc call*(call_568667: Call_ModelAddEntity_568661; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an entity extractor to the application.
  ## 
  let valid = call_568667.validator(path, query, header, formData, body)
  let scheme = call_568667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568667.url(scheme.get, call_568667.host, call_568667.base,
                         call_568667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568667, url, valid)

proc call*(call_568668: Call_ModelAddEntity_568661; versionId: string; appId: string;
          modelCreateObject: JsonNode): Recallable =
  ## modelAddEntity
  ## Adds an entity extractor to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   modelCreateObject: JObject (required)
  ##                    : A model object containing the name for the new entity extractor.
  var path_568669 = newJObject()
  var body_568670 = newJObject()
  add(path_568669, "versionId", newJString(versionId))
  add(path_568669, "appId", newJString(appId))
  if modelCreateObject != nil:
    body_568670 = modelCreateObject
  result = call_568668.call(path_568669, nil, nil, nil, body_568670)

var modelAddEntity* = Call_ModelAddEntity_568661(name: "modelAddEntity",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities",
    validator: validate_ModelAddEntity_568662, base: "/luis/api/v2.0",
    url: url_ModelAddEntity_568663, schemes: {Scheme.Https})
type
  Call_ModelListEntities_568650 = ref object of OpenApiRestCall_567667
proc url_ModelListEntities_568652(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListEntities_568651(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets information about the entity models.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568653 = path.getOrDefault("versionId")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "versionId", valid_568653
  var valid_568654 = path.getOrDefault("appId")
  valid_568654 = validateParameter(valid_568654, JString, required = true,
                                 default = nil)
  if valid_568654 != nil:
    section.add "appId", valid_568654
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568655 = query.getOrDefault("skip")
  valid_568655 = validateParameter(valid_568655, JInt, required = false,
                                 default = newJInt(0))
  if valid_568655 != nil:
    section.add "skip", valid_568655
  var valid_568656 = query.getOrDefault("take")
  valid_568656 = validateParameter(valid_568656, JInt, required = false,
                                 default = newJInt(100))
  if valid_568656 != nil:
    section.add "take", valid_568656
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568657: Call_ModelListEntities_568650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the entity models.
  ## 
  let valid = call_568657.validator(path, query, header, formData, body)
  let scheme = call_568657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568657.url(scheme.get, call_568657.host, call_568657.base,
                         call_568657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568657, url, valid)

proc call*(call_568658: Call_ModelListEntities_568650; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListEntities
  ## Gets information about the entity models.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568659 = newJObject()
  var query_568660 = newJObject()
  add(path_568659, "versionId", newJString(versionId))
  add(query_568660, "skip", newJInt(skip))
  add(query_568660, "take", newJInt(take))
  add(path_568659, "appId", newJString(appId))
  result = call_568658.call(path_568659, query_568660, nil, nil, nil)

var modelListEntities* = Call_ModelListEntities_568650(name: "modelListEntities",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities",
    validator: validate_ModelListEntities_568651, base: "/luis/api/v2.0",
    url: url_ModelListEntities_568652, schemes: {Scheme.Https})
type
  Call_ModelUpdateEntity_568680 = ref object of OpenApiRestCall_567667
proc url_ModelUpdateEntity_568682(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateEntity_568681(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the name of an entity extractor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568683 = path.getOrDefault("versionId")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "versionId", valid_568683
  var valid_568684 = path.getOrDefault("entityId")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "entityId", valid_568684
  var valid_568685 = path.getOrDefault("appId")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "appId", valid_568685
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

proc call*(call_568687: Call_ModelUpdateEntity_568680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name of an entity extractor.
  ## 
  let valid = call_568687.validator(path, query, header, formData, body)
  let scheme = call_568687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568687.url(scheme.get, call_568687.host, call_568687.base,
                         call_568687.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568687, url, valid)

proc call*(call_568688: Call_ModelUpdateEntity_568680; versionId: string;
          entityId: string; modelUpdateObject: JsonNode; appId: string): Recallable =
  ## modelUpdateEntity
  ## Updates the name of an entity extractor.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new entity extractor name.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568689 = newJObject()
  var body_568690 = newJObject()
  add(path_568689, "versionId", newJString(versionId))
  add(path_568689, "entityId", newJString(entityId))
  if modelUpdateObject != nil:
    body_568690 = modelUpdateObject
  add(path_568689, "appId", newJString(appId))
  result = call_568688.call(path_568689, nil, nil, nil, body_568690)

var modelUpdateEntity* = Call_ModelUpdateEntity_568680(name: "modelUpdateEntity",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelUpdateEntity_568681, base: "/luis/api/v2.0",
    url: url_ModelUpdateEntity_568682, schemes: {Scheme.Https})
type
  Call_ModelGetEntity_568671 = ref object of OpenApiRestCall_567667
proc url_ModelGetEntity_568673(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetEntity_568672(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the entity model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568674 = path.getOrDefault("versionId")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "versionId", valid_568674
  var valid_568675 = path.getOrDefault("entityId")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "entityId", valid_568675
  var valid_568676 = path.getOrDefault("appId")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "appId", valid_568676
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568677: Call_ModelGetEntity_568671; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the entity model.
  ## 
  let valid = call_568677.validator(path, query, header, formData, body)
  let scheme = call_568677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568677.url(scheme.get, call_568677.host, call_568677.base,
                         call_568677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568677, url, valid)

proc call*(call_568678: Call_ModelGetEntity_568671; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelGetEntity
  ## Gets information about the entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568679 = newJObject()
  add(path_568679, "versionId", newJString(versionId))
  add(path_568679, "entityId", newJString(entityId))
  add(path_568679, "appId", newJString(appId))
  result = call_568678.call(path_568679, nil, nil, nil, nil)

var modelGetEntity* = Call_ModelGetEntity_568671(name: "modelGetEntity",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelGetEntity_568672, base: "/luis/api/v2.0",
    url: url_ModelGetEntity_568673, schemes: {Scheme.Https})
type
  Call_ModelDeleteEntity_568691 = ref object of OpenApiRestCall_567667
proc url_ModelDeleteEntity_568693(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteEntity_568692(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an entity extractor from the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568694 = path.getOrDefault("versionId")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = nil)
  if valid_568694 != nil:
    section.add "versionId", valid_568694
  var valid_568695 = path.getOrDefault("entityId")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = nil)
  if valid_568695 != nil:
    section.add "entityId", valid_568695
  var valid_568696 = path.getOrDefault("appId")
  valid_568696 = validateParameter(valid_568696, JString, required = true,
                                 default = nil)
  if valid_568696 != nil:
    section.add "appId", valid_568696
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568697: Call_ModelDeleteEntity_568691; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an entity extractor from the application.
  ## 
  let valid = call_568697.validator(path, query, header, formData, body)
  let scheme = call_568697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568697.url(scheme.get, call_568697.host, call_568697.base,
                         call_568697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568697, url, valid)

proc call*(call_568698: Call_ModelDeleteEntity_568691; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelDeleteEntity
  ## Deletes an entity extractor from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568699 = newJObject()
  add(path_568699, "versionId", newJString(versionId))
  add(path_568699, "entityId", newJString(entityId))
  add(path_568699, "appId", newJString(appId))
  result = call_568698.call(path_568699, nil, nil, nil, nil)

var modelDeleteEntity* = Call_ModelDeleteEntity_568691(name: "modelDeleteEntity",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelDeleteEntity_568692, base: "/luis/api/v2.0",
    url: url_ModelDeleteEntity_568693, schemes: {Scheme.Https})
type
  Call_ModelGetEntitySuggestions_568700 = ref object of OpenApiRestCall_567667
proc url_ModelGetEntitySuggestions_568702(protocol: Scheme; host: string;
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

proc validate_ModelGetEntitySuggestions_568701(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get suggestion examples that would improve the accuracy of the entity model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The target entity extractor model to enhance.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568703 = path.getOrDefault("versionId")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "versionId", valid_568703
  var valid_568704 = path.getOrDefault("entityId")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "entityId", valid_568704
  var valid_568705 = path.getOrDefault("appId")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "appId", valid_568705
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568706 = query.getOrDefault("take")
  valid_568706 = validateParameter(valid_568706, JInt, required = false,
                                 default = newJInt(100))
  if valid_568706 != nil:
    section.add "take", valid_568706
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568707: Call_ModelGetEntitySuggestions_568700; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get suggestion examples that would improve the accuracy of the entity model.
  ## 
  let valid = call_568707.validator(path, query, header, formData, body)
  let scheme = call_568707.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568707.url(scheme.get, call_568707.host, call_568707.base,
                         call_568707.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568707, url, valid)

proc call*(call_568708: Call_ModelGetEntitySuggestions_568700; versionId: string;
          entityId: string; appId: string; take: int = 100): Recallable =
  ## modelGetEntitySuggestions
  ## Get suggestion examples that would improve the accuracy of the entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The target entity extractor model to enhance.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568709 = newJObject()
  var query_568710 = newJObject()
  add(path_568709, "versionId", newJString(versionId))
  add(path_568709, "entityId", newJString(entityId))
  add(query_568710, "take", newJInt(take))
  add(path_568709, "appId", newJString(appId))
  result = call_568708.call(path_568709, query_568710, nil, nil, nil)

var modelGetEntitySuggestions* = Call_ModelGetEntitySuggestions_568700(
    name: "modelGetEntitySuggestions", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/suggest",
    validator: validate_ModelGetEntitySuggestions_568701, base: "/luis/api/v2.0",
    url: url_ModelGetEntitySuggestions_568702, schemes: {Scheme.Https})
type
  Call_ExamplesAdd_568711 = ref object of OpenApiRestCall_567667
proc url_ExamplesAdd_568713(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesAdd_568712(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a labeled example to the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568714 = path.getOrDefault("versionId")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "versionId", valid_568714
  var valid_568715 = path.getOrDefault("appId")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "appId", valid_568715
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

proc call*(call_568717: Call_ExamplesAdd_568711; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a labeled example to the application.
  ## 
  let valid = call_568717.validator(path, query, header, formData, body)
  let scheme = call_568717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568717.url(scheme.get, call_568717.host, call_568717.base,
                         call_568717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568717, url, valid)

proc call*(call_568718: Call_ExamplesAdd_568711; versionId: string; appId: string;
          exampleLabelObject: JsonNode): Recallable =
  ## examplesAdd
  ## Adds a labeled example to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   exampleLabelObject: JObject (required)
  ##                     : An example label with the expected intent and entities.
  var path_568719 = newJObject()
  var body_568720 = newJObject()
  add(path_568719, "versionId", newJString(versionId))
  add(path_568719, "appId", newJString(appId))
  if exampleLabelObject != nil:
    body_568720 = exampleLabelObject
  result = call_568718.call(path_568719, nil, nil, nil, body_568720)

var examplesAdd* = Call_ExamplesAdd_568711(name: "examplesAdd",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/apps/{appId}/versions/{versionId}/example",
                                        validator: validate_ExamplesAdd_568712,
                                        base: "/luis/api/v2.0",
                                        url: url_ExamplesAdd_568713,
                                        schemes: {Scheme.Https})
type
  Call_ExamplesBatch_568732 = ref object of OpenApiRestCall_567667
proc url_ExamplesBatch_568734(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesBatch_568733(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a batch of labeled examples to the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568735 = path.getOrDefault("versionId")
  valid_568735 = validateParameter(valid_568735, JString, required = true,
                                 default = nil)
  if valid_568735 != nil:
    section.add "versionId", valid_568735
  var valid_568736 = path.getOrDefault("appId")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "appId", valid_568736
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

proc call*(call_568738: Call_ExamplesBatch_568732; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a batch of labeled examples to the application.
  ## 
  let valid = call_568738.validator(path, query, header, formData, body)
  let scheme = call_568738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568738.url(scheme.get, call_568738.host, call_568738.base,
                         call_568738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568738, url, valid)

proc call*(call_568739: Call_ExamplesBatch_568732; versionId: string; appId: string;
          exampleLabelObjectArray: JsonNode): Recallable =
  ## examplesBatch
  ## Adds a batch of labeled examples to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   exampleLabelObjectArray: JArray (required)
  ##                          : Array of examples.
  var path_568740 = newJObject()
  var body_568741 = newJObject()
  add(path_568740, "versionId", newJString(versionId))
  add(path_568740, "appId", newJString(appId))
  if exampleLabelObjectArray != nil:
    body_568741 = exampleLabelObjectArray
  result = call_568739.call(path_568740, nil, nil, nil, body_568741)

var examplesBatch* = Call_ExamplesBatch_568732(name: "examplesBatch",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples",
    validator: validate_ExamplesBatch_568733, base: "/luis/api/v2.0",
    url: url_ExamplesBatch_568734, schemes: {Scheme.Https})
type
  Call_ExamplesList_568721 = ref object of OpenApiRestCall_567667
proc url_ExamplesList_568723(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesList_568722(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns examples to be reviewed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568724 = path.getOrDefault("versionId")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "versionId", valid_568724
  var valid_568725 = path.getOrDefault("appId")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "appId", valid_568725
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568726 = query.getOrDefault("skip")
  valid_568726 = validateParameter(valid_568726, JInt, required = false,
                                 default = newJInt(0))
  if valid_568726 != nil:
    section.add "skip", valid_568726
  var valid_568727 = query.getOrDefault("take")
  valid_568727 = validateParameter(valid_568727, JInt, required = false,
                                 default = newJInt(100))
  if valid_568727 != nil:
    section.add "take", valid_568727
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568728: Call_ExamplesList_568721; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns examples to be reviewed.
  ## 
  let valid = call_568728.validator(path, query, header, formData, body)
  let scheme = call_568728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568728.url(scheme.get, call_568728.host, call_568728.base,
                         call_568728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568728, url, valid)

proc call*(call_568729: Call_ExamplesList_568721; versionId: string; appId: string;
          skip: int = 0; take: int = 100): Recallable =
  ## examplesList
  ## Returns examples to be reviewed.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568730 = newJObject()
  var query_568731 = newJObject()
  add(path_568730, "versionId", newJString(versionId))
  add(query_568731, "skip", newJInt(skip))
  add(query_568731, "take", newJInt(take))
  add(path_568730, "appId", newJString(appId))
  result = call_568729.call(path_568730, query_568731, nil, nil, nil)

var examplesList* = Call_ExamplesList_568721(name: "examplesList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples",
    validator: validate_ExamplesList_568722, base: "/luis/api/v2.0",
    url: url_ExamplesList_568723, schemes: {Scheme.Https})
type
  Call_ExamplesDelete_568742 = ref object of OpenApiRestCall_567667
proc url_ExamplesDelete_568744(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesDelete_568743(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the labeled example with the specified ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   exampleId: JInt (required)
  ##            : The example ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568745 = path.getOrDefault("versionId")
  valid_568745 = validateParameter(valid_568745, JString, required = true,
                                 default = nil)
  if valid_568745 != nil:
    section.add "versionId", valid_568745
  var valid_568746 = path.getOrDefault("appId")
  valid_568746 = validateParameter(valid_568746, JString, required = true,
                                 default = nil)
  if valid_568746 != nil:
    section.add "appId", valid_568746
  var valid_568747 = path.getOrDefault("exampleId")
  valid_568747 = validateParameter(valid_568747, JInt, required = true, default = nil)
  if valid_568747 != nil:
    section.add "exampleId", valid_568747
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568748: Call_ExamplesDelete_568742; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the labeled example with the specified ID.
  ## 
  let valid = call_568748.validator(path, query, header, formData, body)
  let scheme = call_568748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568748.url(scheme.get, call_568748.host, call_568748.base,
                         call_568748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568748, url, valid)

proc call*(call_568749: Call_ExamplesDelete_568742; versionId: string; appId: string;
          exampleId: int): Recallable =
  ## examplesDelete
  ## Deletes the labeled example with the specified ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   exampleId: int (required)
  ##            : The example ID.
  var path_568750 = newJObject()
  add(path_568750, "versionId", newJString(versionId))
  add(path_568750, "appId", newJString(appId))
  add(path_568750, "exampleId", newJInt(exampleId))
  result = call_568749.call(path_568750, nil, nil, nil, nil)

var examplesDelete* = Call_ExamplesDelete_568742(name: "examplesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples/{exampleId}",
    validator: validate_ExamplesDelete_568743, base: "/luis/api/v2.0",
    url: url_ExamplesDelete_568744, schemes: {Scheme.Https})
type
  Call_VersionsExport_568751 = ref object of OpenApiRestCall_567667
proc url_VersionsExport_568753(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsExport_568752(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Exports a LUIS application to JSON format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568754 = path.getOrDefault("versionId")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "versionId", valid_568754
  var valid_568755 = path.getOrDefault("appId")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "appId", valid_568755
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568756: Call_VersionsExport_568751; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a LUIS application to JSON format.
  ## 
  let valid = call_568756.validator(path, query, header, formData, body)
  let scheme = call_568756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568756.url(scheme.get, call_568756.host, call_568756.base,
                         call_568756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568756, url, valid)

proc call*(call_568757: Call_VersionsExport_568751; versionId: string; appId: string): Recallable =
  ## versionsExport
  ## Exports a LUIS application to JSON format.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568758 = newJObject()
  add(path_568758, "versionId", newJString(versionId))
  add(path_568758, "appId", newJString(appId))
  result = call_568757.call(path_568758, nil, nil, nil, nil)

var versionsExport* = Call_VersionsExport_568751(name: "versionsExport",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/export",
    validator: validate_VersionsExport_568752, base: "/luis/api/v2.0",
    url: url_VersionsExport_568753, schemes: {Scheme.Https})
type
  Call_FeaturesList_568759 = ref object of OpenApiRestCall_567667
proc url_FeaturesList_568761(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesList_568760(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the extraction features for the specified application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568762 = path.getOrDefault("versionId")
  valid_568762 = validateParameter(valid_568762, JString, required = true,
                                 default = nil)
  if valid_568762 != nil:
    section.add "versionId", valid_568762
  var valid_568763 = path.getOrDefault("appId")
  valid_568763 = validateParameter(valid_568763, JString, required = true,
                                 default = nil)
  if valid_568763 != nil:
    section.add "appId", valid_568763
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568764 = query.getOrDefault("skip")
  valid_568764 = validateParameter(valid_568764, JInt, required = false,
                                 default = newJInt(0))
  if valid_568764 != nil:
    section.add "skip", valid_568764
  var valid_568765 = query.getOrDefault("take")
  valid_568765 = validateParameter(valid_568765, JInt, required = false,
                                 default = newJInt(100))
  if valid_568765 != nil:
    section.add "take", valid_568765
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568766: Call_FeaturesList_568759; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the extraction features for the specified application version.
  ## 
  let valid = call_568766.validator(path, query, header, formData, body)
  let scheme = call_568766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568766.url(scheme.get, call_568766.host, call_568766.base,
                         call_568766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568766, url, valid)

proc call*(call_568767: Call_FeaturesList_568759; versionId: string; appId: string;
          skip: int = 0; take: int = 100): Recallable =
  ## featuresList
  ## Gets all the extraction features for the specified application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568768 = newJObject()
  var query_568769 = newJObject()
  add(path_568768, "versionId", newJString(versionId))
  add(query_568769, "skip", newJInt(skip))
  add(query_568769, "take", newJInt(take))
  add(path_568768, "appId", newJString(appId))
  result = call_568767.call(path_568768, query_568769, nil, nil, nil)

var featuresList* = Call_FeaturesList_568759(name: "featuresList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/features",
    validator: validate_FeaturesList_568760, base: "/luis/api/v2.0",
    url: url_FeaturesList_568761, schemes: {Scheme.Https})
type
  Call_ModelAddHierarchicalEntity_568781 = ref object of OpenApiRestCall_567667
proc url_ModelAddHierarchicalEntity_568783(protocol: Scheme; host: string;
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

proc validate_ModelAddHierarchicalEntity_568782(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a hierarchical entity extractor to the application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568784 = path.getOrDefault("versionId")
  valid_568784 = validateParameter(valid_568784, JString, required = true,
                                 default = nil)
  if valid_568784 != nil:
    section.add "versionId", valid_568784
  var valid_568785 = path.getOrDefault("appId")
  valid_568785 = validateParameter(valid_568785, JString, required = true,
                                 default = nil)
  if valid_568785 != nil:
    section.add "appId", valid_568785
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

proc call*(call_568787: Call_ModelAddHierarchicalEntity_568781; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a hierarchical entity extractor to the application version.
  ## 
  let valid = call_568787.validator(path, query, header, formData, body)
  let scheme = call_568787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568787.url(scheme.get, call_568787.host, call_568787.base,
                         call_568787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568787, url, valid)

proc call*(call_568788: Call_ModelAddHierarchicalEntity_568781; versionId: string;
          hierarchicalModelCreateObject: JsonNode; appId: string): Recallable =
  ## modelAddHierarchicalEntity
  ## Adds a hierarchical entity extractor to the application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   hierarchicalModelCreateObject: JObject (required)
  ##                                : A model containing the name and children of the new entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568789 = newJObject()
  var body_568790 = newJObject()
  add(path_568789, "versionId", newJString(versionId))
  if hierarchicalModelCreateObject != nil:
    body_568790 = hierarchicalModelCreateObject
  add(path_568789, "appId", newJString(appId))
  result = call_568788.call(path_568789, nil, nil, nil, body_568790)

var modelAddHierarchicalEntity* = Call_ModelAddHierarchicalEntity_568781(
    name: "modelAddHierarchicalEntity", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/hierarchicalentities",
    validator: validate_ModelAddHierarchicalEntity_568782, base: "/luis/api/v2.0",
    url: url_ModelAddHierarchicalEntity_568783, schemes: {Scheme.Https})
type
  Call_ModelListHierarchicalEntities_568770 = ref object of OpenApiRestCall_567667
proc url_ModelListHierarchicalEntities_568772(protocol: Scheme; host: string;
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

proc validate_ModelListHierarchicalEntities_568771(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the hierarchical entity models.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568773 = path.getOrDefault("versionId")
  valid_568773 = validateParameter(valid_568773, JString, required = true,
                                 default = nil)
  if valid_568773 != nil:
    section.add "versionId", valid_568773
  var valid_568774 = path.getOrDefault("appId")
  valid_568774 = validateParameter(valid_568774, JString, required = true,
                                 default = nil)
  if valid_568774 != nil:
    section.add "appId", valid_568774
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568775 = query.getOrDefault("skip")
  valid_568775 = validateParameter(valid_568775, JInt, required = false,
                                 default = newJInt(0))
  if valid_568775 != nil:
    section.add "skip", valid_568775
  var valid_568776 = query.getOrDefault("take")
  valid_568776 = validateParameter(valid_568776, JInt, required = false,
                                 default = newJInt(100))
  if valid_568776 != nil:
    section.add "take", valid_568776
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568777: Call_ModelListHierarchicalEntities_568770; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the hierarchical entity models.
  ## 
  let valid = call_568777.validator(path, query, header, formData, body)
  let scheme = call_568777.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568777.url(scheme.get, call_568777.host, call_568777.base,
                         call_568777.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568777, url, valid)

proc call*(call_568778: Call_ModelListHierarchicalEntities_568770;
          versionId: string; appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListHierarchicalEntities
  ## Gets information about the hierarchical entity models.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568779 = newJObject()
  var query_568780 = newJObject()
  add(path_568779, "versionId", newJString(versionId))
  add(query_568780, "skip", newJInt(skip))
  add(query_568780, "take", newJInt(take))
  add(path_568779, "appId", newJString(appId))
  result = call_568778.call(path_568779, query_568780, nil, nil, nil)

var modelListHierarchicalEntities* = Call_ModelListHierarchicalEntities_568770(
    name: "modelListHierarchicalEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/hierarchicalentities",
    validator: validate_ModelListHierarchicalEntities_568771,
    base: "/luis/api/v2.0", url: url_ModelListHierarchicalEntities_568772,
    schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntity_568800 = ref object of OpenApiRestCall_567667
proc url_ModelUpdateHierarchicalEntity_568802(protocol: Scheme; host: string;
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

proc validate_ModelUpdateHierarchicalEntity_568801(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the name and children of a hierarchical entity model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568803 = path.getOrDefault("versionId")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "versionId", valid_568803
  var valid_568804 = path.getOrDefault("appId")
  valid_568804 = validateParameter(valid_568804, JString, required = true,
                                 default = nil)
  if valid_568804 != nil:
    section.add "appId", valid_568804
  var valid_568805 = path.getOrDefault("hEntityId")
  valid_568805 = validateParameter(valid_568805, JString, required = true,
                                 default = nil)
  if valid_568805 != nil:
    section.add "hEntityId", valid_568805
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

proc call*(call_568807: Call_ModelUpdateHierarchicalEntity_568800; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name and children of a hierarchical entity model.
  ## 
  let valid = call_568807.validator(path, query, header, formData, body)
  let scheme = call_568807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568807.url(scheme.get, call_568807.host, call_568807.base,
                         call_568807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568807, url, valid)

proc call*(call_568808: Call_ModelUpdateHierarchicalEntity_568800;
          versionId: string; appId: string; hierarchicalModelUpdateObject: JsonNode;
          hEntityId: string): Recallable =
  ## modelUpdateHierarchicalEntity
  ## Updates the name and children of a hierarchical entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hierarchicalModelUpdateObject: JObject (required)
  ##                                : Model containing names of the children of the hierarchical entity.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_568809 = newJObject()
  var body_568810 = newJObject()
  add(path_568809, "versionId", newJString(versionId))
  add(path_568809, "appId", newJString(appId))
  if hierarchicalModelUpdateObject != nil:
    body_568810 = hierarchicalModelUpdateObject
  add(path_568809, "hEntityId", newJString(hEntityId))
  result = call_568808.call(path_568809, nil, nil, nil, body_568810)

var modelUpdateHierarchicalEntity* = Call_ModelUpdateHierarchicalEntity_568800(
    name: "modelUpdateHierarchicalEntity", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelUpdateHierarchicalEntity_568801,
    base: "/luis/api/v2.0", url: url_ModelUpdateHierarchicalEntity_568802,
    schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntity_568791 = ref object of OpenApiRestCall_567667
proc url_ModelGetHierarchicalEntity_568793(protocol: Scheme; host: string;
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

proc validate_ModelGetHierarchicalEntity_568792(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the hierarchical entity model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568794 = path.getOrDefault("versionId")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "versionId", valid_568794
  var valid_568795 = path.getOrDefault("appId")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = nil)
  if valid_568795 != nil:
    section.add "appId", valid_568795
  var valid_568796 = path.getOrDefault("hEntityId")
  valid_568796 = validateParameter(valid_568796, JString, required = true,
                                 default = nil)
  if valid_568796 != nil:
    section.add "hEntityId", valid_568796
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568797: Call_ModelGetHierarchicalEntity_568791; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the hierarchical entity model.
  ## 
  let valid = call_568797.validator(path, query, header, formData, body)
  let scheme = call_568797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568797.url(scheme.get, call_568797.host, call_568797.base,
                         call_568797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568797, url, valid)

proc call*(call_568798: Call_ModelGetHierarchicalEntity_568791; versionId: string;
          appId: string; hEntityId: string): Recallable =
  ## modelGetHierarchicalEntity
  ## Gets information about the hierarchical entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_568799 = newJObject()
  add(path_568799, "versionId", newJString(versionId))
  add(path_568799, "appId", newJString(appId))
  add(path_568799, "hEntityId", newJString(hEntityId))
  result = call_568798.call(path_568799, nil, nil, nil, nil)

var modelGetHierarchicalEntity* = Call_ModelGetHierarchicalEntity_568791(
    name: "modelGetHierarchicalEntity", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelGetHierarchicalEntity_568792, base: "/luis/api/v2.0",
    url: url_ModelGetHierarchicalEntity_568793, schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntity_568811 = ref object of OpenApiRestCall_567667
proc url_ModelDeleteHierarchicalEntity_568813(protocol: Scheme; host: string;
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

proc validate_ModelDeleteHierarchicalEntity_568812(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a hierarchical entity extractor from the application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568814 = path.getOrDefault("versionId")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "versionId", valid_568814
  var valid_568815 = path.getOrDefault("appId")
  valid_568815 = validateParameter(valid_568815, JString, required = true,
                                 default = nil)
  if valid_568815 != nil:
    section.add "appId", valid_568815
  var valid_568816 = path.getOrDefault("hEntityId")
  valid_568816 = validateParameter(valid_568816, JString, required = true,
                                 default = nil)
  if valid_568816 != nil:
    section.add "hEntityId", valid_568816
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568817: Call_ModelDeleteHierarchicalEntity_568811; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a hierarchical entity extractor from the application version.
  ## 
  let valid = call_568817.validator(path, query, header, formData, body)
  let scheme = call_568817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568817.url(scheme.get, call_568817.host, call_568817.base,
                         call_568817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568817, url, valid)

proc call*(call_568818: Call_ModelDeleteHierarchicalEntity_568811;
          versionId: string; appId: string; hEntityId: string): Recallable =
  ## modelDeleteHierarchicalEntity
  ## Deletes a hierarchical entity extractor from the application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_568819 = newJObject()
  add(path_568819, "versionId", newJString(versionId))
  add(path_568819, "appId", newJString(appId))
  add(path_568819, "hEntityId", newJString(hEntityId))
  result = call_568818.call(path_568819, nil, nil, nil, nil)

var modelDeleteHierarchicalEntity* = Call_ModelDeleteHierarchicalEntity_568811(
    name: "modelDeleteHierarchicalEntity", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelDeleteHierarchicalEntity_568812,
    base: "/luis/api/v2.0", url: url_ModelDeleteHierarchicalEntity_568813,
    schemes: {Scheme.Https})
type
  Call_ModelAddHierarchicalEntityChild_568820 = ref object of OpenApiRestCall_567667
proc url_ModelAddHierarchicalEntityChild_568822(protocol: Scheme; host: string;
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

proc validate_ModelAddHierarchicalEntityChild_568821(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a single child in an existing hierarchical entity model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568823 = path.getOrDefault("versionId")
  valid_568823 = validateParameter(valid_568823, JString, required = true,
                                 default = nil)
  if valid_568823 != nil:
    section.add "versionId", valid_568823
  var valid_568824 = path.getOrDefault("appId")
  valid_568824 = validateParameter(valid_568824, JString, required = true,
                                 default = nil)
  if valid_568824 != nil:
    section.add "appId", valid_568824
  var valid_568825 = path.getOrDefault("hEntityId")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "hEntityId", valid_568825
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

proc call*(call_568827: Call_ModelAddHierarchicalEntityChild_568820;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a single child in an existing hierarchical entity model.
  ## 
  let valid = call_568827.validator(path, query, header, formData, body)
  let scheme = call_568827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568827.url(scheme.get, call_568827.host, call_568827.base,
                         call_568827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568827, url, valid)

proc call*(call_568828: Call_ModelAddHierarchicalEntityChild_568820;
          versionId: string; hierarchicalChildModelCreateObject: JsonNode;
          appId: string; hEntityId: string): Recallable =
  ## modelAddHierarchicalEntityChild
  ## Creates a single child in an existing hierarchical entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   hierarchicalChildModelCreateObject: JObject (required)
  ##                                     : A model object containing the name of the new hierarchical child model.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_568829 = newJObject()
  var body_568830 = newJObject()
  add(path_568829, "versionId", newJString(versionId))
  if hierarchicalChildModelCreateObject != nil:
    body_568830 = hierarchicalChildModelCreateObject
  add(path_568829, "appId", newJString(appId))
  add(path_568829, "hEntityId", newJString(hEntityId))
  result = call_568828.call(path_568829, nil, nil, nil, body_568830)

var modelAddHierarchicalEntityChild* = Call_ModelAddHierarchicalEntityChild_568820(
    name: "modelAddHierarchicalEntityChild", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children",
    validator: validate_ModelAddHierarchicalEntityChild_568821,
    base: "/luis/api/v2.0", url: url_ModelAddHierarchicalEntityChild_568822,
    schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntityChild_568841 = ref object of OpenApiRestCall_567667
proc url_ModelUpdateHierarchicalEntityChild_568843(protocol: Scheme; host: string;
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

proc validate_ModelUpdateHierarchicalEntityChild_568842(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Renames a single child in an existing hierarchical entity model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hChildId: JString (required)
  ##           : The hierarchical entity extractor child ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568844 = path.getOrDefault("versionId")
  valid_568844 = validateParameter(valid_568844, JString, required = true,
                                 default = nil)
  if valid_568844 != nil:
    section.add "versionId", valid_568844
  var valid_568845 = path.getOrDefault("appId")
  valid_568845 = validateParameter(valid_568845, JString, required = true,
                                 default = nil)
  if valid_568845 != nil:
    section.add "appId", valid_568845
  var valid_568846 = path.getOrDefault("hChildId")
  valid_568846 = validateParameter(valid_568846, JString, required = true,
                                 default = nil)
  if valid_568846 != nil:
    section.add "hChildId", valid_568846
  var valid_568847 = path.getOrDefault("hEntityId")
  valid_568847 = validateParameter(valid_568847, JString, required = true,
                                 default = nil)
  if valid_568847 != nil:
    section.add "hEntityId", valid_568847
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

proc call*(call_568849: Call_ModelUpdateHierarchicalEntityChild_568841;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renames a single child in an existing hierarchical entity model.
  ## 
  let valid = call_568849.validator(path, query, header, formData, body)
  let scheme = call_568849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568849.url(scheme.get, call_568849.host, call_568849.base,
                         call_568849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568849, url, valid)

proc call*(call_568850: Call_ModelUpdateHierarchicalEntityChild_568841;
          versionId: string; hierarchicalChildModelUpdateObject: JsonNode;
          appId: string; hChildId: string; hEntityId: string): Recallable =
  ## modelUpdateHierarchicalEntityChild
  ## Renames a single child in an existing hierarchical entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   hierarchicalChildModelUpdateObject: JObject (required)
  ##                                     : Model object containing new name of the hierarchical entity child.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_568851 = newJObject()
  var body_568852 = newJObject()
  add(path_568851, "versionId", newJString(versionId))
  if hierarchicalChildModelUpdateObject != nil:
    body_568852 = hierarchicalChildModelUpdateObject
  add(path_568851, "appId", newJString(appId))
  add(path_568851, "hChildId", newJString(hChildId))
  add(path_568851, "hEntityId", newJString(hEntityId))
  result = call_568850.call(path_568851, nil, nil, nil, body_568852)

var modelUpdateHierarchicalEntityChild* = Call_ModelUpdateHierarchicalEntityChild_568841(
    name: "modelUpdateHierarchicalEntityChild", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelUpdateHierarchicalEntityChild_568842,
    base: "/luis/api/v2.0", url: url_ModelUpdateHierarchicalEntityChild_568843,
    schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntityChild_568831 = ref object of OpenApiRestCall_567667
proc url_ModelGetHierarchicalEntityChild_568833(protocol: Scheme; host: string;
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

proc validate_ModelGetHierarchicalEntityChild_568832(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the hierarchical entity child model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hChildId: JString (required)
  ##           : The hierarchical entity extractor child ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568834 = path.getOrDefault("versionId")
  valid_568834 = validateParameter(valid_568834, JString, required = true,
                                 default = nil)
  if valid_568834 != nil:
    section.add "versionId", valid_568834
  var valid_568835 = path.getOrDefault("appId")
  valid_568835 = validateParameter(valid_568835, JString, required = true,
                                 default = nil)
  if valid_568835 != nil:
    section.add "appId", valid_568835
  var valid_568836 = path.getOrDefault("hChildId")
  valid_568836 = validateParameter(valid_568836, JString, required = true,
                                 default = nil)
  if valid_568836 != nil:
    section.add "hChildId", valid_568836
  var valid_568837 = path.getOrDefault("hEntityId")
  valid_568837 = validateParameter(valid_568837, JString, required = true,
                                 default = nil)
  if valid_568837 != nil:
    section.add "hEntityId", valid_568837
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568838: Call_ModelGetHierarchicalEntityChild_568831;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the hierarchical entity child model.
  ## 
  let valid = call_568838.validator(path, query, header, formData, body)
  let scheme = call_568838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568838.url(scheme.get, call_568838.host, call_568838.base,
                         call_568838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568838, url, valid)

proc call*(call_568839: Call_ModelGetHierarchicalEntityChild_568831;
          versionId: string; appId: string; hChildId: string; hEntityId: string): Recallable =
  ## modelGetHierarchicalEntityChild
  ## Gets information about the hierarchical entity child model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_568840 = newJObject()
  add(path_568840, "versionId", newJString(versionId))
  add(path_568840, "appId", newJString(appId))
  add(path_568840, "hChildId", newJString(hChildId))
  add(path_568840, "hEntityId", newJString(hEntityId))
  result = call_568839.call(path_568840, nil, nil, nil, nil)

var modelGetHierarchicalEntityChild* = Call_ModelGetHierarchicalEntityChild_568831(
    name: "modelGetHierarchicalEntityChild", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelGetHierarchicalEntityChild_568832,
    base: "/luis/api/v2.0", url: url_ModelGetHierarchicalEntityChild_568833,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntityChild_568853 = ref object of OpenApiRestCall_567667
proc url_ModelDeleteHierarchicalEntityChild_568855(protocol: Scheme; host: string;
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

proc validate_ModelDeleteHierarchicalEntityChild_568854(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a hierarchical entity extractor child from the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hChildId: JString (required)
  ##           : The hierarchical entity extractor child ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568856 = path.getOrDefault("versionId")
  valid_568856 = validateParameter(valid_568856, JString, required = true,
                                 default = nil)
  if valid_568856 != nil:
    section.add "versionId", valid_568856
  var valid_568857 = path.getOrDefault("appId")
  valid_568857 = validateParameter(valid_568857, JString, required = true,
                                 default = nil)
  if valid_568857 != nil:
    section.add "appId", valid_568857
  var valid_568858 = path.getOrDefault("hChildId")
  valid_568858 = validateParameter(valid_568858, JString, required = true,
                                 default = nil)
  if valid_568858 != nil:
    section.add "hChildId", valid_568858
  var valid_568859 = path.getOrDefault("hEntityId")
  valid_568859 = validateParameter(valid_568859, JString, required = true,
                                 default = nil)
  if valid_568859 != nil:
    section.add "hEntityId", valid_568859
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568860: Call_ModelDeleteHierarchicalEntityChild_568853;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a hierarchical entity extractor child from the application.
  ## 
  let valid = call_568860.validator(path, query, header, formData, body)
  let scheme = call_568860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568860.url(scheme.get, call_568860.host, call_568860.base,
                         call_568860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568860, url, valid)

proc call*(call_568861: Call_ModelDeleteHierarchicalEntityChild_568853;
          versionId: string; appId: string; hChildId: string; hEntityId: string): Recallable =
  ## modelDeleteHierarchicalEntityChild
  ## Deletes a hierarchical entity extractor child from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_568862 = newJObject()
  add(path_568862, "versionId", newJString(versionId))
  add(path_568862, "appId", newJString(appId))
  add(path_568862, "hChildId", newJString(hChildId))
  add(path_568862, "hEntityId", newJString(hEntityId))
  result = call_568861.call(path_568862, nil, nil, nil, nil)

var modelDeleteHierarchicalEntityChild* = Call_ModelDeleteHierarchicalEntityChild_568853(
    name: "modelDeleteHierarchicalEntityChild", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelDeleteHierarchicalEntityChild_568854,
    base: "/luis/api/v2.0", url: url_ModelDeleteHierarchicalEntityChild_568855,
    schemes: {Scheme.Https})
type
  Call_ModelAddIntent_568874 = ref object of OpenApiRestCall_567667
proc url_ModelAddIntent_568876(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddIntent_568875(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Adds an intent classifier to the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568877 = path.getOrDefault("versionId")
  valid_568877 = validateParameter(valid_568877, JString, required = true,
                                 default = nil)
  if valid_568877 != nil:
    section.add "versionId", valid_568877
  var valid_568878 = path.getOrDefault("appId")
  valid_568878 = validateParameter(valid_568878, JString, required = true,
                                 default = nil)
  if valid_568878 != nil:
    section.add "appId", valid_568878
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

proc call*(call_568880: Call_ModelAddIntent_568874; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an intent classifier to the application.
  ## 
  let valid = call_568880.validator(path, query, header, formData, body)
  let scheme = call_568880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568880.url(scheme.get, call_568880.host, call_568880.base,
                         call_568880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568880, url, valid)

proc call*(call_568881: Call_ModelAddIntent_568874; versionId: string; appId: string;
          intentCreateObject: JsonNode): Recallable =
  ## modelAddIntent
  ## Adds an intent classifier to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentCreateObject: JObject (required)
  ##                     : A model object containing the name of the new intent classifier.
  var path_568882 = newJObject()
  var body_568883 = newJObject()
  add(path_568882, "versionId", newJString(versionId))
  add(path_568882, "appId", newJString(appId))
  if intentCreateObject != nil:
    body_568883 = intentCreateObject
  result = call_568881.call(path_568882, nil, nil, nil, body_568883)

var modelAddIntent* = Call_ModelAddIntent_568874(name: "modelAddIntent",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents",
    validator: validate_ModelAddIntent_568875, base: "/luis/api/v2.0",
    url: url_ModelAddIntent_568876, schemes: {Scheme.Https})
type
  Call_ModelListIntents_568863 = ref object of OpenApiRestCall_567667
proc url_ModelListIntents_568865(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListIntents_568864(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about the intent models.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568866 = path.getOrDefault("versionId")
  valid_568866 = validateParameter(valid_568866, JString, required = true,
                                 default = nil)
  if valid_568866 != nil:
    section.add "versionId", valid_568866
  var valid_568867 = path.getOrDefault("appId")
  valid_568867 = validateParameter(valid_568867, JString, required = true,
                                 default = nil)
  if valid_568867 != nil:
    section.add "appId", valid_568867
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568868 = query.getOrDefault("skip")
  valid_568868 = validateParameter(valid_568868, JInt, required = false,
                                 default = newJInt(0))
  if valid_568868 != nil:
    section.add "skip", valid_568868
  var valid_568869 = query.getOrDefault("take")
  valid_568869 = validateParameter(valid_568869, JInt, required = false,
                                 default = newJInt(100))
  if valid_568869 != nil:
    section.add "take", valid_568869
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568870: Call_ModelListIntents_568863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the intent models.
  ## 
  let valid = call_568870.validator(path, query, header, formData, body)
  let scheme = call_568870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568870.url(scheme.get, call_568870.host, call_568870.base,
                         call_568870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568870, url, valid)

proc call*(call_568871: Call_ModelListIntents_568863; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListIntents
  ## Gets information about the intent models.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568872 = newJObject()
  var query_568873 = newJObject()
  add(path_568872, "versionId", newJString(versionId))
  add(query_568873, "skip", newJInt(skip))
  add(query_568873, "take", newJInt(take))
  add(path_568872, "appId", newJString(appId))
  result = call_568871.call(path_568872, query_568873, nil, nil, nil)

var modelListIntents* = Call_ModelListIntents_568863(name: "modelListIntents",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents",
    validator: validate_ModelListIntents_568864, base: "/luis/api/v2.0",
    url: url_ModelListIntents_568865, schemes: {Scheme.Https})
type
  Call_ModelUpdateIntent_568893 = ref object of OpenApiRestCall_567667
proc url_ModelUpdateIntent_568895(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateIntent_568894(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the name of an intent classifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568896 = path.getOrDefault("versionId")
  valid_568896 = validateParameter(valid_568896, JString, required = true,
                                 default = nil)
  if valid_568896 != nil:
    section.add "versionId", valid_568896
  var valid_568897 = path.getOrDefault("appId")
  valid_568897 = validateParameter(valid_568897, JString, required = true,
                                 default = nil)
  if valid_568897 != nil:
    section.add "appId", valid_568897
  var valid_568898 = path.getOrDefault("intentId")
  valid_568898 = validateParameter(valid_568898, JString, required = true,
                                 default = nil)
  if valid_568898 != nil:
    section.add "intentId", valid_568898
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

proc call*(call_568900: Call_ModelUpdateIntent_568893; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name of an intent classifier.
  ## 
  let valid = call_568900.validator(path, query, header, formData, body)
  let scheme = call_568900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568900.url(scheme.get, call_568900.host, call_568900.base,
                         call_568900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568900, url, valid)

proc call*(call_568901: Call_ModelUpdateIntent_568893; versionId: string;
          modelUpdateObject: JsonNode; appId: string; intentId: string): Recallable =
  ## modelUpdateIntent
  ## Updates the name of an intent classifier.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new intent classifier name.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  var path_568902 = newJObject()
  var body_568903 = newJObject()
  add(path_568902, "versionId", newJString(versionId))
  if modelUpdateObject != nil:
    body_568903 = modelUpdateObject
  add(path_568902, "appId", newJString(appId))
  add(path_568902, "intentId", newJString(intentId))
  result = call_568901.call(path_568902, nil, nil, nil, body_568903)

var modelUpdateIntent* = Call_ModelUpdateIntent_568893(name: "modelUpdateIntent",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelUpdateIntent_568894, base: "/luis/api/v2.0",
    url: url_ModelUpdateIntent_568895, schemes: {Scheme.Https})
type
  Call_ModelGetIntent_568884 = ref object of OpenApiRestCall_567667
proc url_ModelGetIntent_568886(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetIntent_568885(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the intent model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568887 = path.getOrDefault("versionId")
  valid_568887 = validateParameter(valid_568887, JString, required = true,
                                 default = nil)
  if valid_568887 != nil:
    section.add "versionId", valid_568887
  var valid_568888 = path.getOrDefault("appId")
  valid_568888 = validateParameter(valid_568888, JString, required = true,
                                 default = nil)
  if valid_568888 != nil:
    section.add "appId", valid_568888
  var valid_568889 = path.getOrDefault("intentId")
  valid_568889 = validateParameter(valid_568889, JString, required = true,
                                 default = nil)
  if valid_568889 != nil:
    section.add "intentId", valid_568889
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568890: Call_ModelGetIntent_568884; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the intent model.
  ## 
  let valid = call_568890.validator(path, query, header, formData, body)
  let scheme = call_568890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568890.url(scheme.get, call_568890.host, call_568890.base,
                         call_568890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568890, url, valid)

proc call*(call_568891: Call_ModelGetIntent_568884; versionId: string; appId: string;
          intentId: string): Recallable =
  ## modelGetIntent
  ## Gets information about the intent model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  var path_568892 = newJObject()
  add(path_568892, "versionId", newJString(versionId))
  add(path_568892, "appId", newJString(appId))
  add(path_568892, "intentId", newJString(intentId))
  result = call_568891.call(path_568892, nil, nil, nil, nil)

var modelGetIntent* = Call_ModelGetIntent_568884(name: "modelGetIntent",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelGetIntent_568885, base: "/luis/api/v2.0",
    url: url_ModelGetIntent_568886, schemes: {Scheme.Https})
type
  Call_ModelDeleteIntent_568904 = ref object of OpenApiRestCall_567667
proc url_ModelDeleteIntent_568906(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteIntent_568905(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an intent classifier from the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568907 = path.getOrDefault("versionId")
  valid_568907 = validateParameter(valid_568907, JString, required = true,
                                 default = nil)
  if valid_568907 != nil:
    section.add "versionId", valid_568907
  var valid_568908 = path.getOrDefault("appId")
  valid_568908 = validateParameter(valid_568908, JString, required = true,
                                 default = nil)
  if valid_568908 != nil:
    section.add "appId", valid_568908
  var valid_568909 = path.getOrDefault("intentId")
  valid_568909 = validateParameter(valid_568909, JString, required = true,
                                 default = nil)
  if valid_568909 != nil:
    section.add "intentId", valid_568909
  result.add "path", section
  ## parameters in `query` object:
  ##   deleteUtterances: JBool
  ##                   : Also delete the intent's utterances (true). Or move the utterances to the None intent (false - the default value).
  section = newJObject()
  var valid_568910 = query.getOrDefault("deleteUtterances")
  valid_568910 = validateParameter(valid_568910, JBool, required = false,
                                 default = newJBool(false))
  if valid_568910 != nil:
    section.add "deleteUtterances", valid_568910
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568911: Call_ModelDeleteIntent_568904; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an intent classifier from the application.
  ## 
  let valid = call_568911.validator(path, query, header, formData, body)
  let scheme = call_568911.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568911.url(scheme.get, call_568911.host, call_568911.base,
                         call_568911.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568911, url, valid)

proc call*(call_568912: Call_ModelDeleteIntent_568904; versionId: string;
          appId: string; intentId: string; deleteUtterances: bool = false): Recallable =
  ## modelDeleteIntent
  ## Deletes an intent classifier from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   deleteUtterances: bool
  ##                   : Also delete the intent's utterances (true). Or move the utterances to the None intent (false - the default value).
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  var path_568913 = newJObject()
  var query_568914 = newJObject()
  add(path_568913, "versionId", newJString(versionId))
  add(query_568914, "deleteUtterances", newJBool(deleteUtterances))
  add(path_568913, "appId", newJString(appId))
  add(path_568913, "intentId", newJString(intentId))
  result = call_568912.call(path_568913, query_568914, nil, nil, nil)

var modelDeleteIntent* = Call_ModelDeleteIntent_568904(name: "modelDeleteIntent",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelDeleteIntent_568905, base: "/luis/api/v2.0",
    url: url_ModelDeleteIntent_568906, schemes: {Scheme.Https})
type
  Call_ModelGetIntentSuggestions_568915 = ref object of OpenApiRestCall_567667
proc url_ModelGetIntentSuggestions_568917(protocol: Scheme; host: string;
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

proc validate_ModelGetIntentSuggestions_568916(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Suggests examples that would improve the accuracy of the intent model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568918 = path.getOrDefault("versionId")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "versionId", valid_568918
  var valid_568919 = path.getOrDefault("appId")
  valid_568919 = validateParameter(valid_568919, JString, required = true,
                                 default = nil)
  if valid_568919 != nil:
    section.add "appId", valid_568919
  var valid_568920 = path.getOrDefault("intentId")
  valid_568920 = validateParameter(valid_568920, JString, required = true,
                                 default = nil)
  if valid_568920 != nil:
    section.add "intentId", valid_568920
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568921 = query.getOrDefault("take")
  valid_568921 = validateParameter(valid_568921, JInt, required = false,
                                 default = newJInt(100))
  if valid_568921 != nil:
    section.add "take", valid_568921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568922: Call_ModelGetIntentSuggestions_568915; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests examples that would improve the accuracy of the intent model.
  ## 
  let valid = call_568922.validator(path, query, header, formData, body)
  let scheme = call_568922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568922.url(scheme.get, call_568922.host, call_568922.base,
                         call_568922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568922, url, valid)

proc call*(call_568923: Call_ModelGetIntentSuggestions_568915; versionId: string;
          appId: string; intentId: string; take: int = 100): Recallable =
  ## modelGetIntentSuggestions
  ## Suggests examples that would improve the accuracy of the intent model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  var path_568924 = newJObject()
  var query_568925 = newJObject()
  add(path_568924, "versionId", newJString(versionId))
  add(query_568925, "take", newJInt(take))
  add(path_568924, "appId", newJString(appId))
  add(path_568924, "intentId", newJString(intentId))
  result = call_568923.call(path_568924, query_568925, nil, nil, nil)

var modelGetIntentSuggestions* = Call_ModelGetIntentSuggestions_568915(
    name: "modelGetIntentSuggestions", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}/suggest",
    validator: validate_ModelGetIntentSuggestions_568916, base: "/luis/api/v2.0",
    url: url_ModelGetIntentSuggestions_568917, schemes: {Scheme.Https})
type
  Call_ModelListPrebuiltEntities_568926 = ref object of OpenApiRestCall_567667
proc url_ModelListPrebuiltEntities_568928(protocol: Scheme; host: string;
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

proc validate_ModelListPrebuiltEntities_568927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the available prebuilt entity extractors for the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568929 = path.getOrDefault("versionId")
  valid_568929 = validateParameter(valid_568929, JString, required = true,
                                 default = nil)
  if valid_568929 != nil:
    section.add "versionId", valid_568929
  var valid_568930 = path.getOrDefault("appId")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = nil)
  if valid_568930 != nil:
    section.add "appId", valid_568930
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568931: Call_ModelListPrebuiltEntities_568926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the available prebuilt entity extractors for the application.
  ## 
  let valid = call_568931.validator(path, query, header, formData, body)
  let scheme = call_568931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568931.url(scheme.get, call_568931.host, call_568931.base,
                         call_568931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568931, url, valid)

proc call*(call_568932: Call_ModelListPrebuiltEntities_568926; versionId: string;
          appId: string): Recallable =
  ## modelListPrebuiltEntities
  ## Gets all the available prebuilt entity extractors for the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568933 = newJObject()
  add(path_568933, "versionId", newJString(versionId))
  add(path_568933, "appId", newJString(appId))
  result = call_568932.call(path_568933, nil, nil, nil, nil)

var modelListPrebuiltEntities* = Call_ModelListPrebuiltEntities_568926(
    name: "modelListPrebuiltEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/listprebuilts",
    validator: validate_ModelListPrebuiltEntities_568927, base: "/luis/api/v2.0",
    url: url_ModelListPrebuiltEntities_568928, schemes: {Scheme.Https})
type
  Call_ModelListModels_568934 = ref object of OpenApiRestCall_567667
proc url_ModelListModels_568936(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListModels_568935(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about the application version models.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568937 = path.getOrDefault("versionId")
  valid_568937 = validateParameter(valid_568937, JString, required = true,
                                 default = nil)
  if valid_568937 != nil:
    section.add "versionId", valid_568937
  var valid_568938 = path.getOrDefault("appId")
  valid_568938 = validateParameter(valid_568938, JString, required = true,
                                 default = nil)
  if valid_568938 != nil:
    section.add "appId", valid_568938
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568939 = query.getOrDefault("skip")
  valid_568939 = validateParameter(valid_568939, JInt, required = false,
                                 default = newJInt(0))
  if valid_568939 != nil:
    section.add "skip", valid_568939
  var valid_568940 = query.getOrDefault("take")
  valid_568940 = validateParameter(valid_568940, JInt, required = false,
                                 default = newJInt(100))
  if valid_568940 != nil:
    section.add "take", valid_568940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568941: Call_ModelListModels_568934; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the application version models.
  ## 
  let valid = call_568941.validator(path, query, header, formData, body)
  let scheme = call_568941.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568941.url(scheme.get, call_568941.host, call_568941.base,
                         call_568941.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568941, url, valid)

proc call*(call_568942: Call_ModelListModels_568934; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListModels
  ## Gets information about the application version models.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568943 = newJObject()
  var query_568944 = newJObject()
  add(path_568943, "versionId", newJString(versionId))
  add(query_568944, "skip", newJInt(skip))
  add(query_568944, "take", newJInt(take))
  add(path_568943, "appId", newJString(appId))
  result = call_568942.call(path_568943, query_568944, nil, nil, nil)

var modelListModels* = Call_ModelListModels_568934(name: "modelListModels",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/models",
    validator: validate_ModelListModels_568935, base: "/luis/api/v2.0",
    url: url_ModelListModels_568936, schemes: {Scheme.Https})
type
  Call_FeaturesCreatePatternFeature_568956 = ref object of OpenApiRestCall_567667
proc url_FeaturesCreatePatternFeature_568958(protocol: Scheme; host: string;
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

proc validate_FeaturesCreatePatternFeature_568957(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568959 = path.getOrDefault("versionId")
  valid_568959 = validateParameter(valid_568959, JString, required = true,
                                 default = nil)
  if valid_568959 != nil:
    section.add "versionId", valid_568959
  var valid_568960 = path.getOrDefault("appId")
  valid_568960 = validateParameter(valid_568960, JString, required = true,
                                 default = nil)
  if valid_568960 != nil:
    section.add "appId", valid_568960
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

proc call*(call_568962: Call_FeaturesCreatePatternFeature_568956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature.
  ## 
  let valid = call_568962.validator(path, query, header, formData, body)
  let scheme = call_568962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568962.url(scheme.get, call_568962.host, call_568962.base,
                         call_568962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568962, url, valid)

proc call*(call_568963: Call_FeaturesCreatePatternFeature_568956;
          patternCreateObject: JsonNode; versionId: string; appId: string): Recallable =
  ## featuresCreatePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature.
  ##   patternCreateObject: JObject (required)
  ##                      : The Name and Pattern of the feature.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568964 = newJObject()
  var body_568965 = newJObject()
  if patternCreateObject != nil:
    body_568965 = patternCreateObject
  add(path_568964, "versionId", newJString(versionId))
  add(path_568964, "appId", newJString(appId))
  result = call_568963.call(path_568964, nil, nil, nil, body_568965)

var featuresCreatePatternFeature* = Call_FeaturesCreatePatternFeature_568956(
    name: "featuresCreatePatternFeature", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patterns",
    validator: validate_FeaturesCreatePatternFeature_568957,
    base: "/luis/api/v2.0", url: url_FeaturesCreatePatternFeature_568958,
    schemes: {Scheme.Https})
type
  Call_FeaturesGetApplicationVersionPatternFeatures_568945 = ref object of OpenApiRestCall_567667
proc url_FeaturesGetApplicationVersionPatternFeatures_568947(protocol: Scheme;
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

proc validate_FeaturesGetApplicationVersionPatternFeatures_568946(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568948 = path.getOrDefault("versionId")
  valid_568948 = validateParameter(valid_568948, JString, required = true,
                                 default = nil)
  if valid_568948 != nil:
    section.add "versionId", valid_568948
  var valid_568949 = path.getOrDefault("appId")
  valid_568949 = validateParameter(valid_568949, JString, required = true,
                                 default = nil)
  if valid_568949 != nil:
    section.add "appId", valid_568949
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568950 = query.getOrDefault("skip")
  valid_568950 = validateParameter(valid_568950, JInt, required = false,
                                 default = newJInt(0))
  if valid_568950 != nil:
    section.add "skip", valid_568950
  var valid_568951 = query.getOrDefault("take")
  valid_568951 = validateParameter(valid_568951, JInt, required = false,
                                 default = newJInt(100))
  if valid_568951 != nil:
    section.add "take", valid_568951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568952: Call_FeaturesGetApplicationVersionPatternFeatures_568945;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ## 
  let valid = call_568952.validator(path, query, header, formData, body)
  let scheme = call_568952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568952.url(scheme.get, call_568952.host, call_568952.base,
                         call_568952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568952, url, valid)

proc call*(call_568953: Call_FeaturesGetApplicationVersionPatternFeatures_568945;
          versionId: string; appId: string; skip: int = 0; take: int = 100): Recallable =
  ## featuresGetApplicationVersionPatternFeatures
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568954 = newJObject()
  var query_568955 = newJObject()
  add(path_568954, "versionId", newJString(versionId))
  add(query_568955, "skip", newJInt(skip))
  add(query_568955, "take", newJInt(take))
  add(path_568954, "appId", newJString(appId))
  result = call_568953.call(path_568954, query_568955, nil, nil, nil)

var featuresGetApplicationVersionPatternFeatures* = Call_FeaturesGetApplicationVersionPatternFeatures_568945(
    name: "featuresGetApplicationVersionPatternFeatures",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns",
    validator: validate_FeaturesGetApplicationVersionPatternFeatures_568946,
    base: "/luis/api/v2.0", url: url_FeaturesGetApplicationVersionPatternFeatures_568947,
    schemes: {Scheme.Https})
type
  Call_FeaturesUpdatePatternFeature_568975 = ref object of OpenApiRestCall_567667
proc url_FeaturesUpdatePatternFeature_568977(protocol: Scheme; host: string;
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

proc validate_FeaturesUpdatePatternFeature_568976(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JInt (required)
  ##            : The pattern feature ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568978 = path.getOrDefault("versionId")
  valid_568978 = validateParameter(valid_568978, JString, required = true,
                                 default = nil)
  if valid_568978 != nil:
    section.add "versionId", valid_568978
  var valid_568979 = path.getOrDefault("patternId")
  valid_568979 = validateParameter(valid_568979, JInt, required = true, default = nil)
  if valid_568979 != nil:
    section.add "patternId", valid_568979
  var valid_568980 = path.getOrDefault("appId")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "appId", valid_568980
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

proc call*(call_568982: Call_FeaturesUpdatePatternFeature_568975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature.
  ## 
  let valid = call_568982.validator(path, query, header, formData, body)
  let scheme = call_568982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568982.url(scheme.get, call_568982.host, call_568982.base,
                         call_568982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568982, url, valid)

proc call*(call_568983: Call_FeaturesUpdatePatternFeature_568975;
          versionId: string; patternId: int; appId: string;
          patternUpdateObject: JsonNode): Recallable =
  ## featuresUpdatePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   patternUpdateObject: JObject (required)
  ##                      : The new values for: - Just a boolean called IsActive, in which case the status of the feature will be changed. - Name, Pattern and a boolean called IsActive to update the feature.
  var path_568984 = newJObject()
  var body_568985 = newJObject()
  add(path_568984, "versionId", newJString(versionId))
  add(path_568984, "patternId", newJInt(patternId))
  add(path_568984, "appId", newJString(appId))
  if patternUpdateObject != nil:
    body_568985 = patternUpdateObject
  result = call_568983.call(path_568984, nil, nil, nil, body_568985)

var featuresUpdatePatternFeature* = Call_FeaturesUpdatePatternFeature_568975(
    name: "featuresUpdatePatternFeature", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesUpdatePatternFeature_568976,
    base: "/luis/api/v2.0", url: url_FeaturesUpdatePatternFeature_568977,
    schemes: {Scheme.Https})
type
  Call_FeaturesGetPatternFeatureInfo_568966 = ref object of OpenApiRestCall_567667
proc url_FeaturesGetPatternFeatureInfo_568968(protocol: Scheme; host: string;
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

proc validate_FeaturesGetPatternFeatureInfo_568967(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JInt (required)
  ##            : The pattern feature ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568969 = path.getOrDefault("versionId")
  valid_568969 = validateParameter(valid_568969, JString, required = true,
                                 default = nil)
  if valid_568969 != nil:
    section.add "versionId", valid_568969
  var valid_568970 = path.getOrDefault("patternId")
  valid_568970 = validateParameter(valid_568970, JInt, required = true, default = nil)
  if valid_568970 != nil:
    section.add "patternId", valid_568970
  var valid_568971 = path.getOrDefault("appId")
  valid_568971 = validateParameter(valid_568971, JString, required = true,
                                 default = nil)
  if valid_568971 != nil:
    section.add "appId", valid_568971
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568972: Call_FeaturesGetPatternFeatureInfo_568966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info.
  ## 
  let valid = call_568972.validator(path, query, header, formData, body)
  let scheme = call_568972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568972.url(scheme.get, call_568972.host, call_568972.base,
                         call_568972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568972, url, valid)

proc call*(call_568973: Call_FeaturesGetPatternFeatureInfo_568966;
          versionId: string; patternId: int; appId: string): Recallable =
  ## featuresGetPatternFeatureInfo
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568974 = newJObject()
  add(path_568974, "versionId", newJString(versionId))
  add(path_568974, "patternId", newJInt(patternId))
  add(path_568974, "appId", newJString(appId))
  result = call_568973.call(path_568974, nil, nil, nil, nil)

var featuresGetPatternFeatureInfo* = Call_FeaturesGetPatternFeatureInfo_568966(
    name: "featuresGetPatternFeatureInfo", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesGetPatternFeatureInfo_568967,
    base: "/luis/api/v2.0", url: url_FeaturesGetPatternFeatureInfo_568968,
    schemes: {Scheme.Https})
type
  Call_FeaturesDeletePatternFeature_568986 = ref object of OpenApiRestCall_567667
proc url_FeaturesDeletePatternFeature_568988(protocol: Scheme; host: string;
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

proc validate_FeaturesDeletePatternFeature_568987(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JInt (required)
  ##            : The pattern feature ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568989 = path.getOrDefault("versionId")
  valid_568989 = validateParameter(valid_568989, JString, required = true,
                                 default = nil)
  if valid_568989 != nil:
    section.add "versionId", valid_568989
  var valid_568990 = path.getOrDefault("patternId")
  valid_568990 = validateParameter(valid_568990, JInt, required = true, default = nil)
  if valid_568990 != nil:
    section.add "patternId", valid_568990
  var valid_568991 = path.getOrDefault("appId")
  valid_568991 = validateParameter(valid_568991, JString, required = true,
                                 default = nil)
  if valid_568991 != nil:
    section.add "appId", valid_568991
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568992: Call_FeaturesDeletePatternFeature_568986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature.
  ## 
  let valid = call_568992.validator(path, query, header, formData, body)
  let scheme = call_568992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568992.url(scheme.get, call_568992.host, call_568992.base,
                         call_568992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568992, url, valid)

proc call*(call_568993: Call_FeaturesDeletePatternFeature_568986;
          versionId: string; patternId: int; appId: string): Recallable =
  ## featuresDeletePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568994 = newJObject()
  add(path_568994, "versionId", newJString(versionId))
  add(path_568994, "patternId", newJInt(patternId))
  add(path_568994, "appId", newJString(appId))
  result = call_568993.call(path_568994, nil, nil, nil, nil)

var featuresDeletePatternFeature* = Call_FeaturesDeletePatternFeature_568986(
    name: "featuresDeletePatternFeature", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesDeletePatternFeature_568987,
    base: "/luis/api/v2.0", url: url_FeaturesDeletePatternFeature_568988,
    schemes: {Scheme.Https})
type
  Call_FeaturesAddPhraseList_569006 = ref object of OpenApiRestCall_567667
proc url_FeaturesAddPhraseList_569008(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesAddPhraseList_569007(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new phraselist feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569009 = path.getOrDefault("versionId")
  valid_569009 = validateParameter(valid_569009, JString, required = true,
                                 default = nil)
  if valid_569009 != nil:
    section.add "versionId", valid_569009
  var valid_569010 = path.getOrDefault("appId")
  valid_569010 = validateParameter(valid_569010, JString, required = true,
                                 default = nil)
  if valid_569010 != nil:
    section.add "appId", valid_569010
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

proc call*(call_569012: Call_FeaturesAddPhraseList_569006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new phraselist feature.
  ## 
  let valid = call_569012.validator(path, query, header, formData, body)
  let scheme = call_569012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569012.url(scheme.get, call_569012.host, call_569012.base,
                         call_569012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569012, url, valid)

proc call*(call_569013: Call_FeaturesAddPhraseList_569006; versionId: string;
          phraselistCreateObject: JsonNode; appId: string): Recallable =
  ## featuresAddPhraseList
  ## Creates a new phraselist feature.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistCreateObject: JObject (required)
  ##                         : A Phraselist object containing Name, comma-separated Phrases and the isExchangeable boolean. Default value for isExchangeable is true.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569014 = newJObject()
  var body_569015 = newJObject()
  add(path_569014, "versionId", newJString(versionId))
  if phraselistCreateObject != nil:
    body_569015 = phraselistCreateObject
  add(path_569014, "appId", newJString(appId))
  result = call_569013.call(path_569014, nil, nil, nil, body_569015)

var featuresAddPhraseList* = Call_FeaturesAddPhraseList_569006(
    name: "featuresAddPhraseList", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists",
    validator: validate_FeaturesAddPhraseList_569007, base: "/luis/api/v2.0",
    url: url_FeaturesAddPhraseList_569008, schemes: {Scheme.Https})
type
  Call_FeaturesListPhraseLists_568995 = ref object of OpenApiRestCall_567667
proc url_FeaturesListPhraseLists_568997(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesListPhraseLists_568996(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the phraselist features.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568998 = path.getOrDefault("versionId")
  valid_568998 = validateParameter(valid_568998, JString, required = true,
                                 default = nil)
  if valid_568998 != nil:
    section.add "versionId", valid_568998
  var valid_568999 = path.getOrDefault("appId")
  valid_568999 = validateParameter(valid_568999, JString, required = true,
                                 default = nil)
  if valid_568999 != nil:
    section.add "appId", valid_568999
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569000 = query.getOrDefault("skip")
  valid_569000 = validateParameter(valid_569000, JInt, required = false,
                                 default = newJInt(0))
  if valid_569000 != nil:
    section.add "skip", valid_569000
  var valid_569001 = query.getOrDefault("take")
  valid_569001 = validateParameter(valid_569001, JInt, required = false,
                                 default = newJInt(100))
  if valid_569001 != nil:
    section.add "take", valid_569001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569002: Call_FeaturesListPhraseLists_568995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the phraselist features.
  ## 
  let valid = call_569002.validator(path, query, header, formData, body)
  let scheme = call_569002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569002.url(scheme.get, call_569002.host, call_569002.base,
                         call_569002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569002, url, valid)

proc call*(call_569003: Call_FeaturesListPhraseLists_568995; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## featuresListPhraseLists
  ## Gets all the phraselist features.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569004 = newJObject()
  var query_569005 = newJObject()
  add(path_569004, "versionId", newJString(versionId))
  add(query_569005, "skip", newJInt(skip))
  add(query_569005, "take", newJInt(take))
  add(path_569004, "appId", newJString(appId))
  result = call_569003.call(path_569004, query_569005, nil, nil, nil)

var featuresListPhraseLists* = Call_FeaturesListPhraseLists_568995(
    name: "featuresListPhraseLists", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists",
    validator: validate_FeaturesListPhraseLists_568996, base: "/luis/api/v2.0",
    url: url_FeaturesListPhraseLists_568997, schemes: {Scheme.Https})
type
  Call_FeaturesUpdatePhraseList_569025 = ref object of OpenApiRestCall_567667
proc url_FeaturesUpdatePhraseList_569027(protocol: Scheme; host: string;
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

proc validate_FeaturesUpdatePhraseList_569026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the phrases, the state and the name of the phraselist feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   phraselistId: JInt (required)
  ##               : The ID of the feature to be updated.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569028 = path.getOrDefault("versionId")
  valid_569028 = validateParameter(valid_569028, JString, required = true,
                                 default = nil)
  if valid_569028 != nil:
    section.add "versionId", valid_569028
  var valid_569029 = path.getOrDefault("phraselistId")
  valid_569029 = validateParameter(valid_569029, JInt, required = true, default = nil)
  if valid_569029 != nil:
    section.add "phraselistId", valid_569029
  var valid_569030 = path.getOrDefault("appId")
  valid_569030 = validateParameter(valid_569030, JString, required = true,
                                 default = nil)
  if valid_569030 != nil:
    section.add "appId", valid_569030
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

proc call*(call_569032: Call_FeaturesUpdatePhraseList_569025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the phrases, the state and the name of the phraselist feature.
  ## 
  let valid = call_569032.validator(path, query, header, formData, body)
  let scheme = call_569032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569032.url(scheme.get, call_569032.host, call_569032.base,
                         call_569032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569032, url, valid)

proc call*(call_569033: Call_FeaturesUpdatePhraseList_569025; versionId: string;
          phraselistId: int; appId: string; phraselistUpdateObject: JsonNode = nil): Recallable =
  ## featuresUpdatePhraseList
  ## Updates the phrases, the state and the name of the phraselist feature.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be updated.
  ##   appId: string (required)
  ##        : The application ID.
  ##   phraselistUpdateObject: JObject
  ##                         : The new values for: - Just a boolean called IsActive, in which case the status of the feature will be changed. - Name, Pattern, Mode, and a boolean called IsActive to update the feature.
  var path_569034 = newJObject()
  var body_569035 = newJObject()
  add(path_569034, "versionId", newJString(versionId))
  add(path_569034, "phraselistId", newJInt(phraselistId))
  add(path_569034, "appId", newJString(appId))
  if phraselistUpdateObject != nil:
    body_569035 = phraselistUpdateObject
  result = call_569033.call(path_569034, nil, nil, nil, body_569035)

var featuresUpdatePhraseList* = Call_FeaturesUpdatePhraseList_569025(
    name: "featuresUpdatePhraseList", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesUpdatePhraseList_569026, base: "/luis/api/v2.0",
    url: url_FeaturesUpdatePhraseList_569027, schemes: {Scheme.Https})
type
  Call_FeaturesGetPhraseList_569016 = ref object of OpenApiRestCall_567667
proc url_FeaturesGetPhraseList_569018(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesGetPhraseList_569017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets phraselist feature info.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   phraselistId: JInt (required)
  ##               : The ID of the feature to be retrieved.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569019 = path.getOrDefault("versionId")
  valid_569019 = validateParameter(valid_569019, JString, required = true,
                                 default = nil)
  if valid_569019 != nil:
    section.add "versionId", valid_569019
  var valid_569020 = path.getOrDefault("phraselistId")
  valid_569020 = validateParameter(valid_569020, JInt, required = true, default = nil)
  if valid_569020 != nil:
    section.add "phraselistId", valid_569020
  var valid_569021 = path.getOrDefault("appId")
  valid_569021 = validateParameter(valid_569021, JString, required = true,
                                 default = nil)
  if valid_569021 != nil:
    section.add "appId", valid_569021
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569022: Call_FeaturesGetPhraseList_569016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets phraselist feature info.
  ## 
  let valid = call_569022.validator(path, query, header, formData, body)
  let scheme = call_569022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569022.url(scheme.get, call_569022.host, call_569022.base,
                         call_569022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569022, url, valid)

proc call*(call_569023: Call_FeaturesGetPhraseList_569016; versionId: string;
          phraselistId: int; appId: string): Recallable =
  ## featuresGetPhraseList
  ## Gets phraselist feature info.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be retrieved.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569024 = newJObject()
  add(path_569024, "versionId", newJString(versionId))
  add(path_569024, "phraselistId", newJInt(phraselistId))
  add(path_569024, "appId", newJString(appId))
  result = call_569023.call(path_569024, nil, nil, nil, nil)

var featuresGetPhraseList* = Call_FeaturesGetPhraseList_569016(
    name: "featuresGetPhraseList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesGetPhraseList_569017, base: "/luis/api/v2.0",
    url: url_FeaturesGetPhraseList_569018, schemes: {Scheme.Https})
type
  Call_FeaturesDeletePhraseList_569036 = ref object of OpenApiRestCall_567667
proc url_FeaturesDeletePhraseList_569038(protocol: Scheme; host: string;
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

proc validate_FeaturesDeletePhraseList_569037(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a phraselist feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   phraselistId: JInt (required)
  ##               : The ID of the feature to be deleted.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569039 = path.getOrDefault("versionId")
  valid_569039 = validateParameter(valid_569039, JString, required = true,
                                 default = nil)
  if valid_569039 != nil:
    section.add "versionId", valid_569039
  var valid_569040 = path.getOrDefault("phraselistId")
  valid_569040 = validateParameter(valid_569040, JInt, required = true, default = nil)
  if valid_569040 != nil:
    section.add "phraselistId", valid_569040
  var valid_569041 = path.getOrDefault("appId")
  valid_569041 = validateParameter(valid_569041, JString, required = true,
                                 default = nil)
  if valid_569041 != nil:
    section.add "appId", valid_569041
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569042: Call_FeaturesDeletePhraseList_569036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a phraselist feature.
  ## 
  let valid = call_569042.validator(path, query, header, formData, body)
  let scheme = call_569042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569042.url(scheme.get, call_569042.host, call_569042.base,
                         call_569042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569042, url, valid)

proc call*(call_569043: Call_FeaturesDeletePhraseList_569036; versionId: string;
          phraselistId: int; appId: string): Recallable =
  ## featuresDeletePhraseList
  ## Deletes a phraselist feature.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be deleted.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569044 = newJObject()
  add(path_569044, "versionId", newJString(versionId))
  add(path_569044, "phraselistId", newJInt(phraselistId))
  add(path_569044, "appId", newJString(appId))
  result = call_569043.call(path_569044, nil, nil, nil, nil)

var featuresDeletePhraseList* = Call_FeaturesDeletePhraseList_569036(
    name: "featuresDeletePhraseList", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesDeletePhraseList_569037, base: "/luis/api/v2.0",
    url: url_FeaturesDeletePhraseList_569038, schemes: {Scheme.Https})
type
  Call_ModelAddPrebuilt_569056 = ref object of OpenApiRestCall_567667
proc url_ModelAddPrebuilt_569058(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddPrebuilt_569057(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Adds a list of prebuilt entity extractors to the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569059 = path.getOrDefault("versionId")
  valid_569059 = validateParameter(valid_569059, JString, required = true,
                                 default = nil)
  if valid_569059 != nil:
    section.add "versionId", valid_569059
  var valid_569060 = path.getOrDefault("appId")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "appId", valid_569060
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

proc call*(call_569062: Call_ModelAddPrebuilt_569056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a list of prebuilt entity extractors to the application.
  ## 
  let valid = call_569062.validator(path, query, header, formData, body)
  let scheme = call_569062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569062.url(scheme.get, call_569062.host, call_569062.base,
                         call_569062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569062, url, valid)

proc call*(call_569063: Call_ModelAddPrebuilt_569056; versionId: string;
          appId: string; prebuiltExtractorNames: JsonNode): Recallable =
  ## modelAddPrebuilt
  ## Adds a list of prebuilt entity extractors to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   prebuiltExtractorNames: JArray (required)
  ##                         : An array of prebuilt entity extractor names.
  var path_569064 = newJObject()
  var body_569065 = newJObject()
  add(path_569064, "versionId", newJString(versionId))
  add(path_569064, "appId", newJString(appId))
  if prebuiltExtractorNames != nil:
    body_569065 = prebuiltExtractorNames
  result = call_569063.call(path_569064, nil, nil, nil, body_569065)

var modelAddPrebuilt* = Call_ModelAddPrebuilt_569056(name: "modelAddPrebuilt",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts",
    validator: validate_ModelAddPrebuilt_569057, base: "/luis/api/v2.0",
    url: url_ModelAddPrebuilt_569058, schemes: {Scheme.Https})
type
  Call_ModelListPrebuilts_569045 = ref object of OpenApiRestCall_567667
proc url_ModelListPrebuilts_569047(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListPrebuilts_569046(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets information about the prebuilt entity models.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569048 = path.getOrDefault("versionId")
  valid_569048 = validateParameter(valid_569048, JString, required = true,
                                 default = nil)
  if valid_569048 != nil:
    section.add "versionId", valid_569048
  var valid_569049 = path.getOrDefault("appId")
  valid_569049 = validateParameter(valid_569049, JString, required = true,
                                 default = nil)
  if valid_569049 != nil:
    section.add "appId", valid_569049
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569050 = query.getOrDefault("skip")
  valid_569050 = validateParameter(valid_569050, JInt, required = false,
                                 default = newJInt(0))
  if valid_569050 != nil:
    section.add "skip", valid_569050
  var valid_569051 = query.getOrDefault("take")
  valid_569051 = validateParameter(valid_569051, JInt, required = false,
                                 default = newJInt(100))
  if valid_569051 != nil:
    section.add "take", valid_569051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569052: Call_ModelListPrebuilts_569045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the prebuilt entity models.
  ## 
  let valid = call_569052.validator(path, query, header, formData, body)
  let scheme = call_569052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569052.url(scheme.get, call_569052.host, call_569052.base,
                         call_569052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569052, url, valid)

proc call*(call_569053: Call_ModelListPrebuilts_569045; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListPrebuilts
  ## Gets information about the prebuilt entity models.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569054 = newJObject()
  var query_569055 = newJObject()
  add(path_569054, "versionId", newJString(versionId))
  add(query_569055, "skip", newJInt(skip))
  add(query_569055, "take", newJInt(take))
  add(path_569054, "appId", newJString(appId))
  result = call_569053.call(path_569054, query_569055, nil, nil, nil)

var modelListPrebuilts* = Call_ModelListPrebuilts_569045(
    name: "modelListPrebuilts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts",
    validator: validate_ModelListPrebuilts_569046, base: "/luis/api/v2.0",
    url: url_ModelListPrebuilts_569047, schemes: {Scheme.Https})
type
  Call_ModelGetPrebuilt_569066 = ref object of OpenApiRestCall_567667
proc url_ModelGetPrebuilt_569068(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetPrebuilt_569067(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about the prebuilt entity model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   prebuiltId: JString (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569069 = path.getOrDefault("versionId")
  valid_569069 = validateParameter(valid_569069, JString, required = true,
                                 default = nil)
  if valid_569069 != nil:
    section.add "versionId", valid_569069
  var valid_569070 = path.getOrDefault("prebuiltId")
  valid_569070 = validateParameter(valid_569070, JString, required = true,
                                 default = nil)
  if valid_569070 != nil:
    section.add "prebuiltId", valid_569070
  var valid_569071 = path.getOrDefault("appId")
  valid_569071 = validateParameter(valid_569071, JString, required = true,
                                 default = nil)
  if valid_569071 != nil:
    section.add "appId", valid_569071
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569072: Call_ModelGetPrebuilt_569066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the prebuilt entity model.
  ## 
  let valid = call_569072.validator(path, query, header, formData, body)
  let scheme = call_569072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569072.url(scheme.get, call_569072.host, call_569072.base,
                         call_569072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569072, url, valid)

proc call*(call_569073: Call_ModelGetPrebuilt_569066; versionId: string;
          prebuiltId: string; appId: string): Recallable =
  ## modelGetPrebuilt
  ## Gets information about the prebuilt entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   prebuiltId: string (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569074 = newJObject()
  add(path_569074, "versionId", newJString(versionId))
  add(path_569074, "prebuiltId", newJString(prebuiltId))
  add(path_569074, "appId", newJString(appId))
  result = call_569073.call(path_569074, nil, nil, nil, nil)

var modelGetPrebuilt* = Call_ModelGetPrebuilt_569066(name: "modelGetPrebuilt",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{prebuiltId}",
    validator: validate_ModelGetPrebuilt_569067, base: "/luis/api/v2.0",
    url: url_ModelGetPrebuilt_569068, schemes: {Scheme.Https})
type
  Call_ModelDeletePrebuilt_569075 = ref object of OpenApiRestCall_567667
proc url_ModelDeletePrebuilt_569077(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeletePrebuilt_569076(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a prebuilt entity extractor from the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   prebuiltId: JString (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569078 = path.getOrDefault("versionId")
  valid_569078 = validateParameter(valid_569078, JString, required = true,
                                 default = nil)
  if valid_569078 != nil:
    section.add "versionId", valid_569078
  var valid_569079 = path.getOrDefault("prebuiltId")
  valid_569079 = validateParameter(valid_569079, JString, required = true,
                                 default = nil)
  if valid_569079 != nil:
    section.add "prebuiltId", valid_569079
  var valid_569080 = path.getOrDefault("appId")
  valid_569080 = validateParameter(valid_569080, JString, required = true,
                                 default = nil)
  if valid_569080 != nil:
    section.add "appId", valid_569080
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569081: Call_ModelDeletePrebuilt_569075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a prebuilt entity extractor from the application.
  ## 
  let valid = call_569081.validator(path, query, header, formData, body)
  let scheme = call_569081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569081.url(scheme.get, call_569081.host, call_569081.base,
                         call_569081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569081, url, valid)

proc call*(call_569082: Call_ModelDeletePrebuilt_569075; versionId: string;
          prebuiltId: string; appId: string): Recallable =
  ## modelDeletePrebuilt
  ## Deletes a prebuilt entity extractor from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   prebuiltId: string (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569083 = newJObject()
  add(path_569083, "versionId", newJString(versionId))
  add(path_569083, "prebuiltId", newJString(prebuiltId))
  add(path_569083, "appId", newJString(appId))
  result = call_569082.call(path_569083, nil, nil, nil, nil)

var modelDeletePrebuilt* = Call_ModelDeletePrebuilt_569075(
    name: "modelDeletePrebuilt", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{prebuiltId}",
    validator: validate_ModelDeletePrebuilt_569076, base: "/luis/api/v2.0",
    url: url_ModelDeletePrebuilt_569077, schemes: {Scheme.Https})
type
  Call_VersionsDeleteUnlabelledUtterance_569084 = ref object of OpenApiRestCall_567667
proc url_VersionsDeleteUnlabelledUtterance_569086(protocol: Scheme; host: string;
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

proc validate_VersionsDeleteUnlabelledUtterance_569085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deleted an unlabelled utterance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569087 = path.getOrDefault("versionId")
  valid_569087 = validateParameter(valid_569087, JString, required = true,
                                 default = nil)
  if valid_569087 != nil:
    section.add "versionId", valid_569087
  var valid_569088 = path.getOrDefault("appId")
  valid_569088 = validateParameter(valid_569088, JString, required = true,
                                 default = nil)
  if valid_569088 != nil:
    section.add "appId", valid_569088
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

proc call*(call_569090: Call_VersionsDeleteUnlabelledUtterance_569084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deleted an unlabelled utterance.
  ## 
  let valid = call_569090.validator(path, query, header, formData, body)
  let scheme = call_569090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569090.url(scheme.get, call_569090.host, call_569090.base,
                         call_569090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569090, url, valid)

proc call*(call_569091: Call_VersionsDeleteUnlabelledUtterance_569084;
          versionId: string; appId: string; utterance: JsonNode): Recallable =
  ## versionsDeleteUnlabelledUtterance
  ## Deleted an unlabelled utterance.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   utterance: JString (required)
  ##            : The utterance text to delete.
  var path_569092 = newJObject()
  var body_569093 = newJObject()
  add(path_569092, "versionId", newJString(versionId))
  add(path_569092, "appId", newJString(appId))
  if utterance != nil:
    body_569093 = utterance
  result = call_569091.call(path_569092, nil, nil, nil, body_569093)

var versionsDeleteUnlabelledUtterance* = Call_VersionsDeleteUnlabelledUtterance_569084(
    name: "versionsDeleteUnlabelledUtterance", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/suggest",
    validator: validate_VersionsDeleteUnlabelledUtterance_569085,
    base: "/luis/api/v2.0", url: url_VersionsDeleteUnlabelledUtterance_569086,
    schemes: {Scheme.Https})
type
  Call_TrainTrainVersion_569102 = ref object of OpenApiRestCall_567667
proc url_TrainTrainVersion_569104(protocol: Scheme; host: string; base: string;
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

proc validate_TrainTrainVersion_569103(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569105 = path.getOrDefault("versionId")
  valid_569105 = validateParameter(valid_569105, JString, required = true,
                                 default = nil)
  if valid_569105 != nil:
    section.add "versionId", valid_569105
  var valid_569106 = path.getOrDefault("appId")
  valid_569106 = validateParameter(valid_569106, JString, required = true,
                                 default = nil)
  if valid_569106 != nil:
    section.add "appId", valid_569106
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569107: Call_TrainTrainVersion_569102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ## 
  let valid = call_569107.validator(path, query, header, formData, body)
  let scheme = call_569107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569107.url(scheme.get, call_569107.host, call_569107.base,
                         call_569107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569107, url, valid)

proc call*(call_569108: Call_TrainTrainVersion_569102; versionId: string;
          appId: string): Recallable =
  ## trainTrainVersion
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569109 = newJObject()
  add(path_569109, "versionId", newJString(versionId))
  add(path_569109, "appId", newJString(appId))
  result = call_569108.call(path_569109, nil, nil, nil, nil)

var trainTrainVersion* = Call_TrainTrainVersion_569102(name: "trainTrainVersion",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/train",
    validator: validate_TrainTrainVersion_569103, base: "/luis/api/v2.0",
    url: url_TrainTrainVersion_569104, schemes: {Scheme.Https})
type
  Call_TrainGetStatus_569094 = ref object of OpenApiRestCall_567667
proc url_TrainGetStatus_569096(protocol: Scheme; host: string; base: string;
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

proc validate_TrainGetStatus_569095(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569097 = path.getOrDefault("versionId")
  valid_569097 = validateParameter(valid_569097, JString, required = true,
                                 default = nil)
  if valid_569097 != nil:
    section.add "versionId", valid_569097
  var valid_569098 = path.getOrDefault("appId")
  valid_569098 = validateParameter(valid_569098, JString, required = true,
                                 default = nil)
  if valid_569098 != nil:
    section.add "appId", valid_569098
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569099: Call_TrainGetStatus_569094; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ## 
  let valid = call_569099.validator(path, query, header, formData, body)
  let scheme = call_569099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569099.url(scheme.get, call_569099.host, call_569099.base,
                         call_569099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569099, url, valid)

proc call*(call_569100: Call_TrainGetStatus_569094; versionId: string; appId: string): Recallable =
  ## trainGetStatus
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569101 = newJObject()
  add(path_569101, "versionId", newJString(versionId))
  add(path_569101, "appId", newJString(appId))
  result = call_569100.call(path_569101, nil, nil, nil, nil)

var trainGetStatus* = Call_TrainGetStatus_569094(name: "trainGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/train",
    validator: validate_TrainGetStatus_569095, base: "/luis/api/v2.0",
    url: url_TrainGetStatus_569096, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
