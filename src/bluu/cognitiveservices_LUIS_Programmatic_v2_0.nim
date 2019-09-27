
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "cognitiveservices-LUIS-Programmatic"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppsAdd_593971 = ref object of OpenApiRestCall_593438
proc url_AppsAdd_593973(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsAdd_593972(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_593975: Call_AppsAdd_593971; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new LUIS app.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_AppsAdd_593971; applicationCreateObject: JsonNode): Recallable =
  ## appsAdd
  ## Creates a new LUIS app.
  ##   applicationCreateObject: JObject (required)
  ##                          : A model containing Name, Description (optional), Culture, Usage Scenario (optional), Domain (optional) and initial version ID (optional) of the application. Default value for the version ID is 0.1. Note: the culture cannot be changed after the app is created.
  var body_593977 = newJObject()
  if applicationCreateObject != nil:
    body_593977 = applicationCreateObject
  result = call_593976.call(nil, nil, nil, nil, body_593977)

var appsAdd* = Call_AppsAdd_593971(name: "appsAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/apps/",
                                validator: validate_AppsAdd_593972,
                                base: "/luis/api/v2.0", url: url_AppsAdd_593973,
                                schemes: {Scheme.Https})
type
  Call_AppsList_593660 = ref object of OpenApiRestCall_593438
proc url_AppsList_593662(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsList_593661(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593835 = query.getOrDefault("skip")
  valid_593835 = validateParameter(valid_593835, JInt, required = false,
                                 default = newJInt(0))
  if valid_593835 != nil:
    section.add "skip", valid_593835
  var valid_593836 = query.getOrDefault("take")
  valid_593836 = validateParameter(valid_593836, JInt, required = false,
                                 default = newJInt(100))
  if valid_593836 != nil:
    section.add "take", valid_593836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593859: Call_AppsList_593660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the user applications.
  ## 
  let valid = call_593859.validator(path, query, header, formData, body)
  let scheme = call_593859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593859.url(scheme.get, call_593859.host, call_593859.base,
                         call_593859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593859, url, valid)

proc call*(call_593930: Call_AppsList_593660; skip: int = 0; take: int = 100): Recallable =
  ## appsList
  ## Lists all of the user applications.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  var query_593931 = newJObject()
  add(query_593931, "skip", newJInt(skip))
  add(query_593931, "take", newJInt(take))
  result = call_593930.call(nil, query_593931, nil, nil, nil)

var appsList* = Call_AppsList_593660(name: "appsList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/apps/",
                                  validator: validate_AppsList_593661,
                                  base: "/luis/api/v2.0", url: url_AppsList_593662,
                                  schemes: {Scheme.Https})
type
  Call_AppsListCortanaEndpoints_593978 = ref object of OpenApiRestCall_593438
proc url_AppsListCortanaEndpoints_593980(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListCortanaEndpoints_593979(path: JsonNode; query: JsonNode;
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

proc call*(call_593981: Call_AppsListCortanaEndpoints_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_AppsListCortanaEndpoints_593978): Recallable =
  ## appsListCortanaEndpoints
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  result = call_593982.call(nil, nil, nil, nil, nil)

var appsListCortanaEndpoints* = Call_AppsListCortanaEndpoints_593978(
    name: "appsListCortanaEndpoints", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/assistants", validator: validate_AppsListCortanaEndpoints_593979,
    base: "/luis/api/v2.0", url: url_AppsListCortanaEndpoints_593980,
    schemes: {Scheme.Https})
type
  Call_AppsListSupportedCultures_593983 = ref object of OpenApiRestCall_593438
proc url_AppsListSupportedCultures_593985(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListSupportedCultures_593984(path: JsonNode; query: JsonNode;
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

proc call*(call_593986: Call_AppsListSupportedCultures_593983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the supported application cultures.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_AppsListSupportedCultures_593983): Recallable =
  ## appsListSupportedCultures
  ## Gets the supported application cultures.
  result = call_593987.call(nil, nil, nil, nil, nil)

var appsListSupportedCultures* = Call_AppsListSupportedCultures_593983(
    name: "appsListSupportedCultures", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/cultures",
    validator: validate_AppsListSupportedCultures_593984, base: "/luis/api/v2.0",
    url: url_AppsListSupportedCultures_593985, schemes: {Scheme.Https})
type
  Call_AppsAddCustomPrebuiltDomain_593993 = ref object of OpenApiRestCall_593438
proc url_AppsAddCustomPrebuiltDomain_593995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsAddCustomPrebuiltDomain_593994(path: JsonNode; query: JsonNode;
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

proc call*(call_593997: Call_AppsAddCustomPrebuiltDomain_593993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a prebuilt domain along with its models as a new application.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_AppsAddCustomPrebuiltDomain_593993;
          prebuiltDomainCreateObject: JsonNode): Recallable =
  ## appsAddCustomPrebuiltDomain
  ## Adds a prebuilt domain along with its models as a new application.
  ##   prebuiltDomainCreateObject: JObject (required)
  ##                             : A prebuilt domain create object containing the name and culture of the domain.
  var body_593999 = newJObject()
  if prebuiltDomainCreateObject != nil:
    body_593999 = prebuiltDomainCreateObject
  result = call_593998.call(nil, nil, nil, nil, body_593999)

var appsAddCustomPrebuiltDomain* = Call_AppsAddCustomPrebuiltDomain_593993(
    name: "appsAddCustomPrebuiltDomain", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/customprebuiltdomains",
    validator: validate_AppsAddCustomPrebuiltDomain_593994,
    base: "/luis/api/v2.0", url: url_AppsAddCustomPrebuiltDomain_593995,
    schemes: {Scheme.Https})
type
  Call_AppsListAvailableCustomPrebuiltDomains_593988 = ref object of OpenApiRestCall_593438
proc url_AppsListAvailableCustomPrebuiltDomains_593990(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListAvailableCustomPrebuiltDomains_593989(path: JsonNode;
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

proc call*(call_593991: Call_AppsListAvailableCustomPrebuiltDomains_593988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available custom prebuilt domains for all cultures.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_AppsListAvailableCustomPrebuiltDomains_593988): Recallable =
  ## appsListAvailableCustomPrebuiltDomains
  ## Gets all the available custom prebuilt domains for all cultures.
  result = call_593992.call(nil, nil, nil, nil, nil)

var appsListAvailableCustomPrebuiltDomains* = Call_AppsListAvailableCustomPrebuiltDomains_593988(
    name: "appsListAvailableCustomPrebuiltDomains", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/customprebuiltdomains",
    validator: validate_AppsListAvailableCustomPrebuiltDomains_593989,
    base: "/luis/api/v2.0", url: url_AppsListAvailableCustomPrebuiltDomains_593990,
    schemes: {Scheme.Https})
type
  Call_AppsListAvailableCustomPrebuiltDomainsForCulture_594000 = ref object of OpenApiRestCall_593438
proc url_AppsListAvailableCustomPrebuiltDomainsForCulture_594002(
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

proc validate_AppsListAvailableCustomPrebuiltDomainsForCulture_594001(
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
  var valid_594017 = path.getOrDefault("culture")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "culture", valid_594017
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_AppsListAvailableCustomPrebuiltDomainsForCulture_594000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available custom prebuilt domains for a specific culture.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_AppsListAvailableCustomPrebuiltDomainsForCulture_594000;
          culture: string): Recallable =
  ## appsListAvailableCustomPrebuiltDomainsForCulture
  ## Gets all the available custom prebuilt domains for a specific culture.
  ##   culture: string (required)
  ##          : Culture.
  var path_594020 = newJObject()
  add(path_594020, "culture", newJString(culture))
  result = call_594019.call(path_594020, nil, nil, nil, nil)

var appsListAvailableCustomPrebuiltDomainsForCulture* = Call_AppsListAvailableCustomPrebuiltDomainsForCulture_594000(
    name: "appsListAvailableCustomPrebuiltDomainsForCulture",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/customprebuiltdomains/{culture}",
    validator: validate_AppsListAvailableCustomPrebuiltDomainsForCulture_594001,
    base: "/luis/api/v2.0",
    url: url_AppsListAvailableCustomPrebuiltDomainsForCulture_594002,
    schemes: {Scheme.Https})
type
  Call_AppsListDomains_594021 = ref object of OpenApiRestCall_593438
proc url_AppsListDomains_594023(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListDomains_594022(path: JsonNode; query: JsonNode;
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

proc call*(call_594024: Call_AppsListDomains_594021; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available application domains.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_AppsListDomains_594021): Recallable =
  ## appsListDomains
  ## Gets the available application domains.
  result = call_594025.call(nil, nil, nil, nil, nil)

var appsListDomains* = Call_AppsListDomains_594021(name: "appsListDomains",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/domains",
    validator: validate_AppsListDomains_594022, base: "/luis/api/v2.0",
    url: url_AppsListDomains_594023, schemes: {Scheme.Https})
type
  Call_AppsImport_594026 = ref object of OpenApiRestCall_593438
proc url_AppsImport_594028(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsImport_594027(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594029 = query.getOrDefault("appName")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "appName", valid_594029
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

proc call*(call_594031: Call_AppsImport_594026; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an application to LUIS, the application's structure should be included in in the request body.
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_AppsImport_594026; luisApp: JsonNode;
          appName: string = ""): Recallable =
  ## appsImport
  ## Imports an application to LUIS, the application's structure should be included in in the request body.
  ##   appName: string
  ##          : The application name to create. If not specified, the application name will be read from the imported object.
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  var query_594033 = newJObject()
  var body_594034 = newJObject()
  add(query_594033, "appName", newJString(appName))
  if luisApp != nil:
    body_594034 = luisApp
  result = call_594032.call(nil, query_594033, nil, nil, body_594034)

var appsImport* = Call_AppsImport_594026(name: "appsImport",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/apps/import",
                                      validator: validate_AppsImport_594027,
                                      base: "/luis/api/v2.0", url: url_AppsImport_594028,
                                      schemes: {Scheme.Https})
type
  Call_AppsListUsageScenarios_594035 = ref object of OpenApiRestCall_593438
proc url_AppsListUsageScenarios_594037(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListUsageScenarios_594036(path: JsonNode; query: JsonNode;
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

proc call*(call_594038: Call_AppsListUsageScenarios_594035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application available usage scenarios.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_AppsListUsageScenarios_594035): Recallable =
  ## appsListUsageScenarios
  ## Gets the application available usage scenarios.
  result = call_594039.call(nil, nil, nil, nil, nil)

var appsListUsageScenarios* = Call_AppsListUsageScenarios_594035(
    name: "appsListUsageScenarios", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/usagescenarios", validator: validate_AppsListUsageScenarios_594036,
    base: "/luis/api/v2.0", url: url_AppsListUsageScenarios_594037,
    schemes: {Scheme.Https})
type
  Call_AppsUpdate_594047 = ref object of OpenApiRestCall_593438
proc url_AppsUpdate_594049(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsUpdate_594048(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594050 = path.getOrDefault("appId")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "appId", valid_594050
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

proc call*(call_594052: Call_AppsUpdate_594047; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or description of the application.
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_AppsUpdate_594047; appId: string;
          applicationUpdateObject: JsonNode): Recallable =
  ## appsUpdate
  ## Updates the name or description of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   applicationUpdateObject: JObject (required)
  ##                          : A model containing Name and Description of the application.
  var path_594054 = newJObject()
  var body_594055 = newJObject()
  add(path_594054, "appId", newJString(appId))
  if applicationUpdateObject != nil:
    body_594055 = applicationUpdateObject
  result = call_594053.call(path_594054, nil, nil, nil, body_594055)

var appsUpdate* = Call_AppsUpdate_594047(name: "appsUpdate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local", route: "/apps/{appId}",
                                      validator: validate_AppsUpdate_594048,
                                      base: "/luis/api/v2.0", url: url_AppsUpdate_594049,
                                      schemes: {Scheme.Https})
type
  Call_AppsGet_594040 = ref object of OpenApiRestCall_593438
proc url_AppsGet_594042(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsGet_594041(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594043 = path.getOrDefault("appId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "appId", valid_594043
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594044: Call_AppsGet_594040; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application info.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_AppsGet_594040; appId: string): Recallable =
  ## appsGet
  ## Gets the application info.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594046 = newJObject()
  add(path_594046, "appId", newJString(appId))
  result = call_594045.call(path_594046, nil, nil, nil, nil)

var appsGet* = Call_AppsGet_594040(name: "appsGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/apps/{appId}",
                                validator: validate_AppsGet_594041,
                                base: "/luis/api/v2.0", url: url_AppsGet_594042,
                                schemes: {Scheme.Https})
type
  Call_AppsDelete_594056 = ref object of OpenApiRestCall_593438
proc url_AppsDelete_594058(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsDelete_594057(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594059 = path.getOrDefault("appId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "appId", valid_594059
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_AppsDelete_594056; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_AppsDelete_594056; appId: string): Recallable =
  ## appsDelete
  ## Deletes an application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594062 = newJObject()
  add(path_594062, "appId", newJString(appId))
  result = call_594061.call(path_594062, nil, nil, nil, nil)

var appsDelete* = Call_AppsDelete_594056(name: "appsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local", route: "/apps/{appId}",
                                      validator: validate_AppsDelete_594057,
                                      base: "/luis/api/v2.0", url: url_AppsDelete_594058,
                                      schemes: {Scheme.Https})
type
  Call_AppsListEndpoints_594063 = ref object of OpenApiRestCall_593438
proc url_AppsListEndpoints_594065(protocol: Scheme; host: string; base: string;
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

proc validate_AppsListEndpoints_594064(path: JsonNode; query: JsonNode;
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
  var valid_594066 = path.getOrDefault("appId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "appId", valid_594066
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_AppsListEndpoints_594063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the available endpoint deployment regions and URLs.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_AppsListEndpoints_594063; appId: string): Recallable =
  ## appsListEndpoints
  ## Returns the available endpoint deployment regions and URLs.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594069 = newJObject()
  add(path_594069, "appId", newJString(appId))
  result = call_594068.call(path_594069, nil, nil, nil, nil)

var appsListEndpoints* = Call_AppsListEndpoints_594063(name: "appsListEndpoints",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/endpoints",
    validator: validate_AppsListEndpoints_594064, base: "/luis/api/v2.0",
    url: url_AppsListEndpoints_594065, schemes: {Scheme.Https})
type
  Call_PermissionsUpdate_594077 = ref object of OpenApiRestCall_593438
proc url_PermissionsUpdate_594079(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsUpdate_594078(path: JsonNode; query: JsonNode;
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
  var valid_594080 = path.getOrDefault("appId")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "appId", valid_594080
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

proc call*(call_594082: Call_PermissionsUpdate_594077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces the current users access list with the one sent in the body. If an empty list is sent, all access to other users will be removed.
  ## 
  let valid = call_594082.validator(path, query, header, formData, body)
  let scheme = call_594082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594082.url(scheme.get, call_594082.host, call_594082.base,
                         call_594082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594082, url, valid)

proc call*(call_594083: Call_PermissionsUpdate_594077; collaborators: JsonNode;
          appId: string): Recallable =
  ## permissionsUpdate
  ## Replaces the current users access list with the one sent in the body. If an empty list is sent, all access to other users will be removed.
  ##   collaborators: JObject (required)
  ##                : A model containing a list of user's email addresses.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594084 = newJObject()
  var body_594085 = newJObject()
  if collaborators != nil:
    body_594085 = collaborators
  add(path_594084, "appId", newJString(appId))
  result = call_594083.call(path_594084, nil, nil, nil, body_594085)

var permissionsUpdate* = Call_PermissionsUpdate_594077(name: "permissionsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsUpdate_594078,
    base: "/luis/api/v2.0", url: url_PermissionsUpdate_594079,
    schemes: {Scheme.Https})
type
  Call_PermissionsAdd_594086 = ref object of OpenApiRestCall_593438
proc url_PermissionsAdd_594088(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsAdd_594087(path: JsonNode; query: JsonNode;
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
  var valid_594089 = path.getOrDefault("appId")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "appId", valid_594089
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

proc call*(call_594091: Call_PermissionsAdd_594086; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ## 
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_PermissionsAdd_594086; userToAdd: JsonNode;
          appId: string): Recallable =
  ## permissionsAdd
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ##   userToAdd: JObject (required)
  ##            : A model containing the user's email address.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594093 = newJObject()
  var body_594094 = newJObject()
  if userToAdd != nil:
    body_594094 = userToAdd
  add(path_594093, "appId", newJString(appId))
  result = call_594092.call(path_594093, nil, nil, nil, body_594094)

var permissionsAdd* = Call_PermissionsAdd_594086(name: "permissionsAdd",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsAdd_594087,
    base: "/luis/api/v2.0", url: url_PermissionsAdd_594088, schemes: {Scheme.Https})
type
  Call_PermissionsList_594070 = ref object of OpenApiRestCall_593438
proc url_PermissionsList_594072(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsList_594071(path: JsonNode; query: JsonNode;
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
  var valid_594073 = path.getOrDefault("appId")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "appId", valid_594073
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_PermissionsList_594070; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of user emails that have permissions to access your application.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_PermissionsList_594070; appId: string): Recallable =
  ## permissionsList
  ## Gets the list of user emails that have permissions to access your application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594076 = newJObject()
  add(path_594076, "appId", newJString(appId))
  result = call_594075.call(path_594076, nil, nil, nil, nil)

var permissionsList* = Call_PermissionsList_594070(name: "permissionsList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsList_594071,
    base: "/luis/api/v2.0", url: url_PermissionsList_594072, schemes: {Scheme.Https})
type
  Call_PermissionsDelete_594095 = ref object of OpenApiRestCall_593438
proc url_PermissionsDelete_594097(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsDelete_594096(path: JsonNode; query: JsonNode;
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
  var valid_594098 = path.getOrDefault("appId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "appId", valid_594098
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

proc call*(call_594100: Call_PermissionsDelete_594095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_PermissionsDelete_594095; appId: string;
          userToDelete: JsonNode): Recallable =
  ## permissionsDelete
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ##   appId: string (required)
  ##        : The application ID.
  ##   userToDelete: JObject (required)
  ##               : A model containing the user's email address.
  var path_594102 = newJObject()
  var body_594103 = newJObject()
  add(path_594102, "appId", newJString(appId))
  if userToDelete != nil:
    body_594103 = userToDelete
  result = call_594101.call(path_594102, nil, nil, nil, body_594103)

var permissionsDelete* = Call_PermissionsDelete_594095(name: "permissionsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsDelete_594096,
    base: "/luis/api/v2.0", url: url_PermissionsDelete_594097,
    schemes: {Scheme.Https})
type
  Call_AppsPublish_594104 = ref object of OpenApiRestCall_593438
proc url_AppsPublish_594106(protocol: Scheme; host: string; base: string;
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

proc validate_AppsPublish_594105(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594107 = path.getOrDefault("appId")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "appId", valid_594107
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

proc call*(call_594109: Call_AppsPublish_594104; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a specific version of the application.
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_AppsPublish_594104;
          applicationPublishObject: JsonNode; appId: string): Recallable =
  ## appsPublish
  ## Publishes a specific version of the application.
  ##   applicationPublishObject: JObject (required)
  ##                           : The application publish object. The region is the target region that the application is published to.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594111 = newJObject()
  var body_594112 = newJObject()
  if applicationPublishObject != nil:
    body_594112 = applicationPublishObject
  add(path_594111, "appId", newJString(appId))
  result = call_594110.call(path_594111, nil, nil, nil, body_594112)

var appsPublish* = Call_AppsPublish_594104(name: "appsPublish",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local",
                                        route: "/apps/{appId}/publish",
                                        validator: validate_AppsPublish_594105,
                                        base: "/luis/api/v2.0",
                                        url: url_AppsPublish_594106,
                                        schemes: {Scheme.Https})
type
  Call_AppsDownloadQueryLogs_594113 = ref object of OpenApiRestCall_593438
proc url_AppsDownloadQueryLogs_594115(protocol: Scheme; host: string; base: string;
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

proc validate_AppsDownloadQueryLogs_594114(path: JsonNode; query: JsonNode;
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
  var valid_594116 = path.getOrDefault("appId")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "appId", valid_594116
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594117: Call_AppsDownloadQueryLogs_594113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the query logs of the past month for the application.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_AppsDownloadQueryLogs_594113; appId: string): Recallable =
  ## appsDownloadQueryLogs
  ## Gets the query logs of the past month for the application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594119 = newJObject()
  add(path_594119, "appId", newJString(appId))
  result = call_594118.call(path_594119, nil, nil, nil, nil)

var appsDownloadQueryLogs* = Call_AppsDownloadQueryLogs_594113(
    name: "appsDownloadQueryLogs", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/querylogs", validator: validate_AppsDownloadQueryLogs_594114,
    base: "/luis/api/v2.0", url: url_AppsDownloadQueryLogs_594115,
    schemes: {Scheme.Https})
type
  Call_AppsUpdateSettings_594127 = ref object of OpenApiRestCall_593438
proc url_AppsUpdateSettings_594129(protocol: Scheme; host: string; base: string;
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

proc validate_AppsUpdateSettings_594128(path: JsonNode; query: JsonNode;
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
  var valid_594130 = path.getOrDefault("appId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "appId", valid_594130
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

proc call*(call_594132: Call_AppsUpdateSettings_594127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the application settings.
  ## 
  let valid = call_594132.validator(path, query, header, formData, body)
  let scheme = call_594132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594132.url(scheme.get, call_594132.host, call_594132.base,
                         call_594132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594132, url, valid)

proc call*(call_594133: Call_AppsUpdateSettings_594127; appId: string;
          applicationSettingUpdateObject: JsonNode): Recallable =
  ## appsUpdateSettings
  ## Updates the application settings.
  ##   appId: string (required)
  ##        : The application ID.
  ##   applicationSettingUpdateObject: JObject (required)
  ##                                 : An object containing the new application settings.
  var path_594134 = newJObject()
  var body_594135 = newJObject()
  add(path_594134, "appId", newJString(appId))
  if applicationSettingUpdateObject != nil:
    body_594135 = applicationSettingUpdateObject
  result = call_594133.call(path_594134, nil, nil, nil, body_594135)

var appsUpdateSettings* = Call_AppsUpdateSettings_594127(
    name: "appsUpdateSettings", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/settings", validator: validate_AppsUpdateSettings_594128,
    base: "/luis/api/v2.0", url: url_AppsUpdateSettings_594129,
    schemes: {Scheme.Https})
type
  Call_AppsGetSettings_594120 = ref object of OpenApiRestCall_593438
proc url_AppsGetSettings_594122(protocol: Scheme; host: string; base: string;
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

proc validate_AppsGetSettings_594121(path: JsonNode; query: JsonNode;
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
  var valid_594123 = path.getOrDefault("appId")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "appId", valid_594123
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594124: Call_AppsGetSettings_594120; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the application settings.
  ## 
  let valid = call_594124.validator(path, query, header, formData, body)
  let scheme = call_594124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594124.url(scheme.get, call_594124.host, call_594124.base,
                         call_594124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594124, url, valid)

proc call*(call_594125: Call_AppsGetSettings_594120; appId: string): Recallable =
  ## appsGetSettings
  ## Get the application settings.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594126 = newJObject()
  add(path_594126, "appId", newJString(appId))
  result = call_594125.call(path_594126, nil, nil, nil, nil)

var appsGetSettings* = Call_AppsGetSettings_594120(name: "appsGetSettings",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/settings",
    validator: validate_AppsGetSettings_594121, base: "/luis/api/v2.0",
    url: url_AppsGetSettings_594122, schemes: {Scheme.Https})
type
  Call_VersionsList_594136 = ref object of OpenApiRestCall_593438
proc url_VersionsList_594138(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsList_594137(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594139 = path.getOrDefault("appId")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "appId", valid_594139
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594140 = query.getOrDefault("skip")
  valid_594140 = validateParameter(valid_594140, JInt, required = false,
                                 default = newJInt(0))
  if valid_594140 != nil:
    section.add "skip", valid_594140
  var valid_594141 = query.getOrDefault("take")
  valid_594141 = validateParameter(valid_594141, JInt, required = false,
                                 default = newJInt(100))
  if valid_594141 != nil:
    section.add "take", valid_594141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594142: Call_VersionsList_594136; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application versions info.
  ## 
  let valid = call_594142.validator(path, query, header, formData, body)
  let scheme = call_594142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594142.url(scheme.get, call_594142.host, call_594142.base,
                         call_594142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594142, url, valid)

proc call*(call_594143: Call_VersionsList_594136; appId: string; skip: int = 0;
          take: int = 100): Recallable =
  ## versionsList
  ## Gets the application versions info.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594144 = newJObject()
  var query_594145 = newJObject()
  add(query_594145, "skip", newJInt(skip))
  add(query_594145, "take", newJInt(take))
  add(path_594144, "appId", newJString(appId))
  result = call_594143.call(path_594144, query_594145, nil, nil, nil)

var versionsList* = Call_VersionsList_594136(name: "versionsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions",
    validator: validate_VersionsList_594137, base: "/luis/api/v2.0",
    url: url_VersionsList_594138, schemes: {Scheme.Https})
type
  Call_VersionsImport_594146 = ref object of OpenApiRestCall_593438
proc url_VersionsImport_594148(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsImport_594147(path: JsonNode; query: JsonNode;
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
  var valid_594149 = path.getOrDefault("appId")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "appId", valid_594149
  result.add "path", section
  ## parameters in `query` object:
  ##   versionId: JString
  ##            : The new versionId to import. If not specified, the versionId will be read from the imported object.
  section = newJObject()
  var valid_594150 = query.getOrDefault("versionId")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "versionId", valid_594150
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

proc call*(call_594152: Call_VersionsImport_594146; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a new version into a LUIS application.
  ## 
  let valid = call_594152.validator(path, query, header, formData, body)
  let scheme = call_594152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594152.url(scheme.get, call_594152.host, call_594152.base,
                         call_594152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594152, url, valid)

proc call*(call_594153: Call_VersionsImport_594146; appId: string; luisApp: JsonNode;
          versionId: string = ""): Recallable =
  ## versionsImport
  ## Imports a new version into a LUIS application.
  ##   versionId: string
  ##            : The new versionId to import. If not specified, the versionId will be read from the imported object.
  ##   appId: string (required)
  ##        : The application ID.
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  var path_594154 = newJObject()
  var query_594155 = newJObject()
  var body_594156 = newJObject()
  add(query_594155, "versionId", newJString(versionId))
  add(path_594154, "appId", newJString(appId))
  if luisApp != nil:
    body_594156 = luisApp
  result = call_594153.call(path_594154, query_594155, nil, nil, body_594156)

var versionsImport* = Call_VersionsImport_594146(name: "versionsImport",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/import", validator: validate_VersionsImport_594147,
    base: "/luis/api/v2.0", url: url_VersionsImport_594148, schemes: {Scheme.Https})
type
  Call_VersionsUpdate_594165 = ref object of OpenApiRestCall_593438
proc url_VersionsUpdate_594167(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsUpdate_594166(path: JsonNode; query: JsonNode;
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
  var valid_594168 = path.getOrDefault("versionId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "versionId", valid_594168
  var valid_594169 = path.getOrDefault("appId")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "appId", valid_594169
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

proc call*(call_594171: Call_VersionsUpdate_594165; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or description of the application version.
  ## 
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_VersionsUpdate_594165; versionId: string; appId: string;
          versionUpdateObject: JsonNode): Recallable =
  ## versionsUpdate
  ## Updates the name or description of the application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionUpdateObject: JObject (required)
  ##                      : A model containing Name and Description of the application.
  var path_594173 = newJObject()
  var body_594174 = newJObject()
  add(path_594173, "versionId", newJString(versionId))
  add(path_594173, "appId", newJString(appId))
  if versionUpdateObject != nil:
    body_594174 = versionUpdateObject
  result = call_594172.call(path_594173, nil, nil, nil, body_594174)

var versionsUpdate* = Call_VersionsUpdate_594165(name: "versionsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/",
    validator: validate_VersionsUpdate_594166, base: "/luis/api/v2.0",
    url: url_VersionsUpdate_594167, schemes: {Scheme.Https})
type
  Call_VersionsGet_594157 = ref object of OpenApiRestCall_593438
proc url_VersionsGet_594159(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsGet_594158(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594160 = path.getOrDefault("versionId")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "versionId", valid_594160
  var valid_594161 = path.getOrDefault("appId")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "appId", valid_594161
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594162: Call_VersionsGet_594157; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the version info.
  ## 
  let valid = call_594162.validator(path, query, header, formData, body)
  let scheme = call_594162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594162.url(scheme.get, call_594162.host, call_594162.base,
                         call_594162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594162, url, valid)

proc call*(call_594163: Call_VersionsGet_594157; versionId: string; appId: string): Recallable =
  ## versionsGet
  ## Gets the version info.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594164 = newJObject()
  add(path_594164, "versionId", newJString(versionId))
  add(path_594164, "appId", newJString(appId))
  result = call_594163.call(path_594164, nil, nil, nil, nil)

var versionsGet* = Call_VersionsGet_594157(name: "versionsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/apps/{appId}/versions/{versionId}/",
                                        validator: validate_VersionsGet_594158,
                                        base: "/luis/api/v2.0",
                                        url: url_VersionsGet_594159,
                                        schemes: {Scheme.Https})
type
  Call_VersionsDelete_594175 = ref object of OpenApiRestCall_593438
proc url_VersionsDelete_594177(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsDelete_594176(path: JsonNode; query: JsonNode;
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
  var valid_594178 = path.getOrDefault("versionId")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "versionId", valid_594178
  var valid_594179 = path.getOrDefault("appId")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "appId", valid_594179
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594180: Call_VersionsDelete_594175; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application version.
  ## 
  let valid = call_594180.validator(path, query, header, formData, body)
  let scheme = call_594180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594180.url(scheme.get, call_594180.host, call_594180.base,
                         call_594180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594180, url, valid)

proc call*(call_594181: Call_VersionsDelete_594175; versionId: string; appId: string): Recallable =
  ## versionsDelete
  ## Deletes an application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594182 = newJObject()
  add(path_594182, "versionId", newJString(versionId))
  add(path_594182, "appId", newJString(appId))
  result = call_594181.call(path_594182, nil, nil, nil, nil)

var versionsDelete* = Call_VersionsDelete_594175(name: "versionsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/",
    validator: validate_VersionsDelete_594176, base: "/luis/api/v2.0",
    url: url_VersionsDelete_594177, schemes: {Scheme.Https})
type
  Call_VersionsClone_594183 = ref object of OpenApiRestCall_593438
proc url_VersionsClone_594185(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsClone_594184(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594186 = path.getOrDefault("versionId")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "versionId", valid_594186
  var valid_594187 = path.getOrDefault("appId")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "appId", valid_594187
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

proc call*(call_594189: Call_VersionsClone_594183; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new version using the current snapshot of the selected application version.
  ## 
  let valid = call_594189.validator(path, query, header, formData, body)
  let scheme = call_594189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594189.url(scheme.get, call_594189.host, call_594189.base,
                         call_594189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594189, url, valid)

proc call*(call_594190: Call_VersionsClone_594183; versionId: string; appId: string;
          versionCloneObject: JsonNode = nil): Recallable =
  ## versionsClone
  ## Creates a new version using the current snapshot of the selected application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionCloneObject: JObject
  ##                     : A model containing the new version ID.
  var path_594191 = newJObject()
  var body_594192 = newJObject()
  add(path_594191, "versionId", newJString(versionId))
  add(path_594191, "appId", newJString(appId))
  if versionCloneObject != nil:
    body_594192 = versionCloneObject
  result = call_594190.call(path_594191, nil, nil, nil, body_594192)

var versionsClone* = Call_VersionsClone_594183(name: "versionsClone",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/clone",
    validator: validate_VersionsClone_594184, base: "/luis/api/v2.0",
    url: url_VersionsClone_594185, schemes: {Scheme.Https})
type
  Call_ModelAddClosedList_594204 = ref object of OpenApiRestCall_593438
proc url_ModelAddClosedList_594206(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddClosedList_594205(path: JsonNode; query: JsonNode;
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
  var valid_594207 = path.getOrDefault("versionId")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "versionId", valid_594207
  var valid_594208 = path.getOrDefault("appId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "appId", valid_594208
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

proc call*(call_594210: Call_ModelAddClosedList_594204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a closed list model to the application.
  ## 
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_ModelAddClosedList_594204; versionId: string;
          appId: string; closedListModelCreateObject: JsonNode): Recallable =
  ## modelAddClosedList
  ## Adds a closed list model to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   closedListModelCreateObject: JObject (required)
  ##                              : A model containing the name and words for the new closed list entity extractor.
  var path_594212 = newJObject()
  var body_594213 = newJObject()
  add(path_594212, "versionId", newJString(versionId))
  add(path_594212, "appId", newJString(appId))
  if closedListModelCreateObject != nil:
    body_594213 = closedListModelCreateObject
  result = call_594211.call(path_594212, nil, nil, nil, body_594213)

var modelAddClosedList* = Call_ModelAddClosedList_594204(
    name: "modelAddClosedList", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists",
    validator: validate_ModelAddClosedList_594205, base: "/luis/api/v2.0",
    url: url_ModelAddClosedList_594206, schemes: {Scheme.Https})
type
  Call_ModelListClosedLists_594193 = ref object of OpenApiRestCall_593438
proc url_ModelListClosedLists_594195(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListClosedLists_594194(path: JsonNode; query: JsonNode;
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
  var valid_594196 = path.getOrDefault("versionId")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "versionId", valid_594196
  var valid_594197 = path.getOrDefault("appId")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "appId", valid_594197
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594198 = query.getOrDefault("skip")
  valid_594198 = validateParameter(valid_594198, JInt, required = false,
                                 default = newJInt(0))
  if valid_594198 != nil:
    section.add "skip", valid_594198
  var valid_594199 = query.getOrDefault("take")
  valid_594199 = validateParameter(valid_594199, JInt, required = false,
                                 default = newJInt(100))
  if valid_594199 != nil:
    section.add "take", valid_594199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594200: Call_ModelListClosedLists_594193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the closedlist models.
  ## 
  let valid = call_594200.validator(path, query, header, formData, body)
  let scheme = call_594200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594200.url(scheme.get, call_594200.host, call_594200.base,
                         call_594200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594200, url, valid)

proc call*(call_594201: Call_ModelListClosedLists_594193; versionId: string;
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
  var path_594202 = newJObject()
  var query_594203 = newJObject()
  add(path_594202, "versionId", newJString(versionId))
  add(query_594203, "skip", newJInt(skip))
  add(query_594203, "take", newJInt(take))
  add(path_594202, "appId", newJString(appId))
  result = call_594201.call(path_594202, query_594203, nil, nil, nil)

var modelListClosedLists* = Call_ModelListClosedLists_594193(
    name: "modelListClosedLists", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists",
    validator: validate_ModelListClosedLists_594194, base: "/luis/api/v2.0",
    url: url_ModelListClosedLists_594195, schemes: {Scheme.Https})
type
  Call_ModelUpdateClosedList_594223 = ref object of OpenApiRestCall_593438
proc url_ModelUpdateClosedList_594225(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateClosedList_594224(path: JsonNode; query: JsonNode;
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
  var valid_594226 = path.getOrDefault("versionId")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "versionId", valid_594226
  var valid_594227 = path.getOrDefault("appId")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "appId", valid_594227
  var valid_594228 = path.getOrDefault("clEntityId")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "clEntityId", valid_594228
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

proc call*(call_594230: Call_ModelUpdateClosedList_594223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the closed list model.
  ## 
  let valid = call_594230.validator(path, query, header, formData, body)
  let scheme = call_594230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594230.url(scheme.get, call_594230.host, call_594230.base,
                         call_594230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594230, url, valid)

proc call*(call_594231: Call_ModelUpdateClosedList_594223; versionId: string;
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
  var path_594232 = newJObject()
  var body_594233 = newJObject()
  add(path_594232, "versionId", newJString(versionId))
  if closedListModelUpdateObject != nil:
    body_594233 = closedListModelUpdateObject
  add(path_594232, "appId", newJString(appId))
  add(path_594232, "clEntityId", newJString(clEntityId))
  result = call_594231.call(path_594232, nil, nil, nil, body_594233)

var modelUpdateClosedList* = Call_ModelUpdateClosedList_594223(
    name: "modelUpdateClosedList", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelUpdateClosedList_594224, base: "/luis/api/v2.0",
    url: url_ModelUpdateClosedList_594225, schemes: {Scheme.Https})
type
  Call_ModelGetClosedList_594214 = ref object of OpenApiRestCall_593438
proc url_ModelGetClosedList_594216(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetClosedList_594215(path: JsonNode; query: JsonNode;
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
  var valid_594217 = path.getOrDefault("versionId")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "versionId", valid_594217
  var valid_594218 = path.getOrDefault("appId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "appId", valid_594218
  var valid_594219 = path.getOrDefault("clEntityId")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "clEntityId", valid_594219
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594220: Call_ModelGetClosedList_594214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information of a closed list model.
  ## 
  let valid = call_594220.validator(path, query, header, formData, body)
  let scheme = call_594220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594220.url(scheme.get, call_594220.host, call_594220.base,
                         call_594220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594220, url, valid)

proc call*(call_594221: Call_ModelGetClosedList_594214; versionId: string;
          appId: string; clEntityId: string): Recallable =
  ## modelGetClosedList
  ## Gets information of a closed list model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The closed list model ID.
  var path_594222 = newJObject()
  add(path_594222, "versionId", newJString(versionId))
  add(path_594222, "appId", newJString(appId))
  add(path_594222, "clEntityId", newJString(clEntityId))
  result = call_594221.call(path_594222, nil, nil, nil, nil)

var modelGetClosedList* = Call_ModelGetClosedList_594214(
    name: "modelGetClosedList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelGetClosedList_594215, base: "/luis/api/v2.0",
    url: url_ModelGetClosedList_594216, schemes: {Scheme.Https})
type
  Call_ModelPatchClosedList_594243 = ref object of OpenApiRestCall_593438
proc url_ModelPatchClosedList_594245(protocol: Scheme; host: string; base: string;
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

proc validate_ModelPatchClosedList_594244(path: JsonNode; query: JsonNode;
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
  var valid_594246 = path.getOrDefault("versionId")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "versionId", valid_594246
  var valid_594247 = path.getOrDefault("appId")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "appId", valid_594247
  var valid_594248 = path.getOrDefault("clEntityId")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "clEntityId", valid_594248
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

proc call*(call_594250: Call_ModelPatchClosedList_594243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a batch of sublists to an existing closedlist.
  ## 
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_ModelPatchClosedList_594243; versionId: string;
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
  var path_594252 = newJObject()
  var body_594253 = newJObject()
  add(path_594252, "versionId", newJString(versionId))
  add(path_594252, "appId", newJString(appId))
  add(path_594252, "clEntityId", newJString(clEntityId))
  if closedListModelPatchObject != nil:
    body_594253 = closedListModelPatchObject
  result = call_594251.call(path_594252, nil, nil, nil, body_594253)

var modelPatchClosedList* = Call_ModelPatchClosedList_594243(
    name: "modelPatchClosedList", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelPatchClosedList_594244, base: "/luis/api/v2.0",
    url: url_ModelPatchClosedList_594245, schemes: {Scheme.Https})
type
  Call_ModelDeleteClosedList_594234 = ref object of OpenApiRestCall_593438
proc url_ModelDeleteClosedList_594236(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteClosedList_594235(path: JsonNode; query: JsonNode;
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
  var valid_594237 = path.getOrDefault("versionId")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "versionId", valid_594237
  var valid_594238 = path.getOrDefault("appId")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "appId", valid_594238
  var valid_594239 = path.getOrDefault("clEntityId")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "clEntityId", valid_594239
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594240: Call_ModelDeleteClosedList_594234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a closed list model from the application.
  ## 
  let valid = call_594240.validator(path, query, header, formData, body)
  let scheme = call_594240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594240.url(scheme.get, call_594240.host, call_594240.base,
                         call_594240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594240, url, valid)

proc call*(call_594241: Call_ModelDeleteClosedList_594234; versionId: string;
          appId: string; clEntityId: string): Recallable =
  ## modelDeleteClosedList
  ## Deletes a closed list model from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The closed list model ID.
  var path_594242 = newJObject()
  add(path_594242, "versionId", newJString(versionId))
  add(path_594242, "appId", newJString(appId))
  add(path_594242, "clEntityId", newJString(clEntityId))
  result = call_594241.call(path_594242, nil, nil, nil, nil)

var modelDeleteClosedList* = Call_ModelDeleteClosedList_594234(
    name: "modelDeleteClosedList", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelDeleteClosedList_594235, base: "/luis/api/v2.0",
    url: url_ModelDeleteClosedList_594236, schemes: {Scheme.Https})
type
  Call_ModelAddSubList_594254 = ref object of OpenApiRestCall_593438
proc url_ModelAddSubList_594256(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddSubList_594255(path: JsonNode; query: JsonNode;
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
  var valid_594257 = path.getOrDefault("versionId")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "versionId", valid_594257
  var valid_594258 = path.getOrDefault("appId")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "appId", valid_594258
  var valid_594259 = path.getOrDefault("clEntityId")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "clEntityId", valid_594259
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

proc call*(call_594261: Call_ModelAddSubList_594254; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a list to an existing closed list.
  ## 
  let valid = call_594261.validator(path, query, header, formData, body)
  let scheme = call_594261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594261.url(scheme.get, call_594261.host, call_594261.base,
                         call_594261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594261, url, valid)

proc call*(call_594262: Call_ModelAddSubList_594254; versionId: string;
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
  var path_594263 = newJObject()
  var body_594264 = newJObject()
  add(path_594263, "versionId", newJString(versionId))
  if wordListCreateObject != nil:
    body_594264 = wordListCreateObject
  add(path_594263, "appId", newJString(appId))
  add(path_594263, "clEntityId", newJString(clEntityId))
  result = call_594262.call(path_594263, nil, nil, nil, body_594264)

var modelAddSubList* = Call_ModelAddSubList_594254(name: "modelAddSubList",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists",
    validator: validate_ModelAddSubList_594255, base: "/luis/api/v2.0",
    url: url_ModelAddSubList_594256, schemes: {Scheme.Https})
type
  Call_ModelUpdateSubList_594265 = ref object of OpenApiRestCall_593438
proc url_ModelUpdateSubList_594267(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateSubList_594266(path: JsonNode; query: JsonNode;
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
  var valid_594268 = path.getOrDefault("versionId")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "versionId", valid_594268
  var valid_594269 = path.getOrDefault("appId")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "appId", valid_594269
  var valid_594270 = path.getOrDefault("clEntityId")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "clEntityId", valid_594270
  var valid_594271 = path.getOrDefault("subListId")
  valid_594271 = validateParameter(valid_594271, JInt, required = true, default = nil)
  if valid_594271 != nil:
    section.add "subListId", valid_594271
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

proc call*(call_594273: Call_ModelUpdateSubList_594265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates one of the closed list's sublists.
  ## 
  let valid = call_594273.validator(path, query, header, formData, body)
  let scheme = call_594273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594273.url(scheme.get, call_594273.host, call_594273.base,
                         call_594273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594273, url, valid)

proc call*(call_594274: Call_ModelUpdateSubList_594265; versionId: string;
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
  var path_594275 = newJObject()
  var body_594276 = newJObject()
  add(path_594275, "versionId", newJString(versionId))
  if wordListBaseUpdateObject != nil:
    body_594276 = wordListBaseUpdateObject
  add(path_594275, "appId", newJString(appId))
  add(path_594275, "clEntityId", newJString(clEntityId))
  add(path_594275, "subListId", newJInt(subListId))
  result = call_594274.call(path_594275, nil, nil, nil, body_594276)

var modelUpdateSubList* = Call_ModelUpdateSubList_594265(
    name: "modelUpdateSubList", meth: HttpMethod.HttpPut, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists/{subListId}",
    validator: validate_ModelUpdateSubList_594266, base: "/luis/api/v2.0",
    url: url_ModelUpdateSubList_594267, schemes: {Scheme.Https})
type
  Call_ModelDeleteSubList_594277 = ref object of OpenApiRestCall_593438
proc url_ModelDeleteSubList_594279(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteSubList_594278(path: JsonNode; query: JsonNode;
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
  var valid_594280 = path.getOrDefault("versionId")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "versionId", valid_594280
  var valid_594281 = path.getOrDefault("appId")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "appId", valid_594281
  var valid_594282 = path.getOrDefault("clEntityId")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "clEntityId", valid_594282
  var valid_594283 = path.getOrDefault("subListId")
  valid_594283 = validateParameter(valid_594283, JInt, required = true, default = nil)
  if valid_594283 != nil:
    section.add "subListId", valid_594283
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594284: Call_ModelDeleteSubList_594277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a sublist of a specific closed list model.
  ## 
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_ModelDeleteSubList_594277; versionId: string;
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
  var path_594286 = newJObject()
  add(path_594286, "versionId", newJString(versionId))
  add(path_594286, "appId", newJString(appId))
  add(path_594286, "clEntityId", newJString(clEntityId))
  add(path_594286, "subListId", newJInt(subListId))
  result = call_594285.call(path_594286, nil, nil, nil, nil)

var modelDeleteSubList* = Call_ModelDeleteSubList_594277(
    name: "modelDeleteSubList", meth: HttpMethod.HttpDelete, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists/{subListId}",
    validator: validate_ModelDeleteSubList_594278, base: "/luis/api/v2.0",
    url: url_ModelDeleteSubList_594279, schemes: {Scheme.Https})
type
  Call_ModelAddCompositeEntity_594298 = ref object of OpenApiRestCall_593438
proc url_ModelAddCompositeEntity_594300(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddCompositeEntity_594299(path: JsonNode; query: JsonNode;
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
  var valid_594301 = path.getOrDefault("versionId")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "versionId", valid_594301
  var valid_594302 = path.getOrDefault("appId")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "appId", valid_594302
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

proc call*(call_594304: Call_ModelAddCompositeEntity_594298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a composite entity extractor to the application.
  ## 
  let valid = call_594304.validator(path, query, header, formData, body)
  let scheme = call_594304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594304.url(scheme.get, call_594304.host, call_594304.base,
                         call_594304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594304, url, valid)

proc call*(call_594305: Call_ModelAddCompositeEntity_594298; versionId: string;
          appId: string; compositeModelCreateObject: JsonNode): Recallable =
  ## modelAddCompositeEntity
  ## Adds a composite entity extractor to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   compositeModelCreateObject: JObject (required)
  ##                             : A model containing the name and children of the new entity extractor.
  var path_594306 = newJObject()
  var body_594307 = newJObject()
  add(path_594306, "versionId", newJString(versionId))
  add(path_594306, "appId", newJString(appId))
  if compositeModelCreateObject != nil:
    body_594307 = compositeModelCreateObject
  result = call_594305.call(path_594306, nil, nil, nil, body_594307)

var modelAddCompositeEntity* = Call_ModelAddCompositeEntity_594298(
    name: "modelAddCompositeEntity", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities",
    validator: validate_ModelAddCompositeEntity_594299, base: "/luis/api/v2.0",
    url: url_ModelAddCompositeEntity_594300, schemes: {Scheme.Https})
type
  Call_ModelListCompositeEntities_594287 = ref object of OpenApiRestCall_593438
proc url_ModelListCompositeEntities_594289(protocol: Scheme; host: string;
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

proc validate_ModelListCompositeEntities_594288(path: JsonNode; query: JsonNode;
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
  var valid_594290 = path.getOrDefault("versionId")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "versionId", valid_594290
  var valid_594291 = path.getOrDefault("appId")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "appId", valid_594291
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594292 = query.getOrDefault("skip")
  valid_594292 = validateParameter(valid_594292, JInt, required = false,
                                 default = newJInt(0))
  if valid_594292 != nil:
    section.add "skip", valid_594292
  var valid_594293 = query.getOrDefault("take")
  valid_594293 = validateParameter(valid_594293, JInt, required = false,
                                 default = newJInt(100))
  if valid_594293 != nil:
    section.add "take", valid_594293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594294: Call_ModelListCompositeEntities_594287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the composite entity models.
  ## 
  let valid = call_594294.validator(path, query, header, formData, body)
  let scheme = call_594294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594294.url(scheme.get, call_594294.host, call_594294.base,
                         call_594294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594294, url, valid)

proc call*(call_594295: Call_ModelListCompositeEntities_594287; versionId: string;
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
  var path_594296 = newJObject()
  var query_594297 = newJObject()
  add(path_594296, "versionId", newJString(versionId))
  add(query_594297, "skip", newJInt(skip))
  add(query_594297, "take", newJInt(take))
  add(path_594296, "appId", newJString(appId))
  result = call_594295.call(path_594296, query_594297, nil, nil, nil)

var modelListCompositeEntities* = Call_ModelListCompositeEntities_594287(
    name: "modelListCompositeEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities",
    validator: validate_ModelListCompositeEntities_594288, base: "/luis/api/v2.0",
    url: url_ModelListCompositeEntities_594289, schemes: {Scheme.Https})
type
  Call_ModelUpdateCompositeEntity_594317 = ref object of OpenApiRestCall_593438
proc url_ModelUpdateCompositeEntity_594319(protocol: Scheme; host: string;
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

proc validate_ModelUpdateCompositeEntity_594318(path: JsonNode; query: JsonNode;
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
  var valid_594320 = path.getOrDefault("versionId")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "versionId", valid_594320
  var valid_594321 = path.getOrDefault("appId")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "appId", valid_594321
  var valid_594322 = path.getOrDefault("cEntityId")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "cEntityId", valid_594322
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

proc call*(call_594324: Call_ModelUpdateCompositeEntity_594317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the composite entity extractor.
  ## 
  let valid = call_594324.validator(path, query, header, formData, body)
  let scheme = call_594324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594324.url(scheme.get, call_594324.host, call_594324.base,
                         call_594324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594324, url, valid)

proc call*(call_594325: Call_ModelUpdateCompositeEntity_594317; versionId: string;
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
  var path_594326 = newJObject()
  var body_594327 = newJObject()
  add(path_594326, "versionId", newJString(versionId))
  if compositeModelUpdateObject != nil:
    body_594327 = compositeModelUpdateObject
  add(path_594326, "appId", newJString(appId))
  add(path_594326, "cEntityId", newJString(cEntityId))
  result = call_594325.call(path_594326, nil, nil, nil, body_594327)

var modelUpdateCompositeEntity* = Call_ModelUpdateCompositeEntity_594317(
    name: "modelUpdateCompositeEntity", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelUpdateCompositeEntity_594318, base: "/luis/api/v2.0",
    url: url_ModelUpdateCompositeEntity_594319, schemes: {Scheme.Https})
type
  Call_ModelGetCompositeEntity_594308 = ref object of OpenApiRestCall_593438
proc url_ModelGetCompositeEntity_594310(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetCompositeEntity_594309(path: JsonNode; query: JsonNode;
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
  var valid_594311 = path.getOrDefault("versionId")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "versionId", valid_594311
  var valid_594312 = path.getOrDefault("appId")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "appId", valid_594312
  var valid_594313 = path.getOrDefault("cEntityId")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "cEntityId", valid_594313
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594314: Call_ModelGetCompositeEntity_594308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the composite entity model.
  ## 
  let valid = call_594314.validator(path, query, header, formData, body)
  let scheme = call_594314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594314.url(scheme.get, call_594314.host, call_594314.base,
                         call_594314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594314, url, valid)

proc call*(call_594315: Call_ModelGetCompositeEntity_594308; versionId: string;
          appId: string; cEntityId: string): Recallable =
  ## modelGetCompositeEntity
  ## Gets information about the composite entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_594316 = newJObject()
  add(path_594316, "versionId", newJString(versionId))
  add(path_594316, "appId", newJString(appId))
  add(path_594316, "cEntityId", newJString(cEntityId))
  result = call_594315.call(path_594316, nil, nil, nil, nil)

var modelGetCompositeEntity* = Call_ModelGetCompositeEntity_594308(
    name: "modelGetCompositeEntity", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelGetCompositeEntity_594309, base: "/luis/api/v2.0",
    url: url_ModelGetCompositeEntity_594310, schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntity_594328 = ref object of OpenApiRestCall_593438
proc url_ModelDeleteCompositeEntity_594330(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCompositeEntity_594329(path: JsonNode; query: JsonNode;
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
  var valid_594331 = path.getOrDefault("versionId")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "versionId", valid_594331
  var valid_594332 = path.getOrDefault("appId")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "appId", valid_594332
  var valid_594333 = path.getOrDefault("cEntityId")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "cEntityId", valid_594333
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594334: Call_ModelDeleteCompositeEntity_594328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a composite entity extractor from the application.
  ## 
  let valid = call_594334.validator(path, query, header, formData, body)
  let scheme = call_594334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594334.url(scheme.get, call_594334.host, call_594334.base,
                         call_594334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594334, url, valid)

proc call*(call_594335: Call_ModelDeleteCompositeEntity_594328; versionId: string;
          appId: string; cEntityId: string): Recallable =
  ## modelDeleteCompositeEntity
  ## Deletes a composite entity extractor from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_594336 = newJObject()
  add(path_594336, "versionId", newJString(versionId))
  add(path_594336, "appId", newJString(appId))
  add(path_594336, "cEntityId", newJString(cEntityId))
  result = call_594335.call(path_594336, nil, nil, nil, nil)

var modelDeleteCompositeEntity* = Call_ModelDeleteCompositeEntity_594328(
    name: "modelDeleteCompositeEntity", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelDeleteCompositeEntity_594329, base: "/luis/api/v2.0",
    url: url_ModelDeleteCompositeEntity_594330, schemes: {Scheme.Https})
type
  Call_ModelAddCompositeEntityChild_594337 = ref object of OpenApiRestCall_593438
proc url_ModelAddCompositeEntityChild_594339(protocol: Scheme; host: string;
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

proc validate_ModelAddCompositeEntityChild_594338(path: JsonNode; query: JsonNode;
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
  var valid_594340 = path.getOrDefault("versionId")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "versionId", valid_594340
  var valid_594341 = path.getOrDefault("appId")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "appId", valid_594341
  var valid_594342 = path.getOrDefault("cEntityId")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "cEntityId", valid_594342
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

proc call*(call_594344: Call_ModelAddCompositeEntityChild_594337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a single child in an existing composite entity model.
  ## 
  let valid = call_594344.validator(path, query, header, formData, body)
  let scheme = call_594344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594344.url(scheme.get, call_594344.host, call_594344.base,
                         call_594344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594344, url, valid)

proc call*(call_594345: Call_ModelAddCompositeEntityChild_594337;
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
  var path_594346 = newJObject()
  var body_594347 = newJObject()
  add(path_594346, "versionId", newJString(versionId))
  if compositeChildModelCreateObject != nil:
    body_594347 = compositeChildModelCreateObject
  add(path_594346, "appId", newJString(appId))
  add(path_594346, "cEntityId", newJString(cEntityId))
  result = call_594345.call(path_594346, nil, nil, nil, body_594347)

var modelAddCompositeEntityChild* = Call_ModelAddCompositeEntityChild_594337(
    name: "modelAddCompositeEntityChild", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/children",
    validator: validate_ModelAddCompositeEntityChild_594338,
    base: "/luis/api/v2.0", url: url_ModelAddCompositeEntityChild_594339,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntityChild_594348 = ref object of OpenApiRestCall_593438
proc url_ModelDeleteCompositeEntityChild_594350(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCompositeEntityChild_594349(path: JsonNode;
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
  var valid_594351 = path.getOrDefault("versionId")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "versionId", valid_594351
  var valid_594352 = path.getOrDefault("cChildId")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "cChildId", valid_594352
  var valid_594353 = path.getOrDefault("appId")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "appId", valid_594353
  var valid_594354 = path.getOrDefault("cEntityId")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "cEntityId", valid_594354
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594355: Call_ModelDeleteCompositeEntityChild_594348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a composite entity extractor child from the application.
  ## 
  let valid = call_594355.validator(path, query, header, formData, body)
  let scheme = call_594355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594355.url(scheme.get, call_594355.host, call_594355.base,
                         call_594355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594355, url, valid)

proc call*(call_594356: Call_ModelDeleteCompositeEntityChild_594348;
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
  var path_594357 = newJObject()
  add(path_594357, "versionId", newJString(versionId))
  add(path_594357, "cChildId", newJString(cChildId))
  add(path_594357, "appId", newJString(appId))
  add(path_594357, "cEntityId", newJString(cEntityId))
  result = call_594356.call(path_594357, nil, nil, nil, nil)

var modelDeleteCompositeEntityChild* = Call_ModelDeleteCompositeEntityChild_594348(
    name: "modelDeleteCompositeEntityChild", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/children/{cChildId}",
    validator: validate_ModelDeleteCompositeEntityChild_594349,
    base: "/luis/api/v2.0", url: url_ModelDeleteCompositeEntityChild_594350,
    schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltDomain_594358 = ref object of OpenApiRestCall_593438
proc url_ModelAddCustomPrebuiltDomain_594360(protocol: Scheme; host: string;
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

proc validate_ModelAddCustomPrebuiltDomain_594359(path: JsonNode; query: JsonNode;
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
  var valid_594361 = path.getOrDefault("versionId")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "versionId", valid_594361
  var valid_594362 = path.getOrDefault("appId")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "appId", valid_594362
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

proc call*(call_594364: Call_ModelAddCustomPrebuiltDomain_594358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a customizable prebuilt domain along with all of its models to this application.
  ## 
  let valid = call_594364.validator(path, query, header, formData, body)
  let scheme = call_594364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594364.url(scheme.get, call_594364.host, call_594364.base,
                         call_594364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594364, url, valid)

proc call*(call_594365: Call_ModelAddCustomPrebuiltDomain_594358;
          versionId: string; appId: string; prebuiltDomainObject: JsonNode): Recallable =
  ## modelAddCustomPrebuiltDomain
  ## Adds a customizable prebuilt domain along with all of its models to this application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   prebuiltDomainObject: JObject (required)
  ##                       : A prebuilt domain create object containing the name of the domain.
  var path_594366 = newJObject()
  var body_594367 = newJObject()
  add(path_594366, "versionId", newJString(versionId))
  add(path_594366, "appId", newJString(appId))
  if prebuiltDomainObject != nil:
    body_594367 = prebuiltDomainObject
  result = call_594365.call(path_594366, nil, nil, nil, body_594367)

var modelAddCustomPrebuiltDomain* = Call_ModelAddCustomPrebuiltDomain_594358(
    name: "modelAddCustomPrebuiltDomain", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltdomains",
    validator: validate_ModelAddCustomPrebuiltDomain_594359,
    base: "/luis/api/v2.0", url: url_ModelAddCustomPrebuiltDomain_594360,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteCustomPrebuiltDomain_594368 = ref object of OpenApiRestCall_593438
proc url_ModelDeleteCustomPrebuiltDomain_594370(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCustomPrebuiltDomain_594369(path: JsonNode;
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
  var valid_594371 = path.getOrDefault("versionId")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "versionId", valid_594371
  var valid_594372 = path.getOrDefault("appId")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "appId", valid_594372
  var valid_594373 = path.getOrDefault("domainName")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "domainName", valid_594373
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594374: Call_ModelDeleteCustomPrebuiltDomain_594368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a prebuilt domain's models from the application.
  ## 
  let valid = call_594374.validator(path, query, header, formData, body)
  let scheme = call_594374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594374.url(scheme.get, call_594374.host, call_594374.base,
                         call_594374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594374, url, valid)

proc call*(call_594375: Call_ModelDeleteCustomPrebuiltDomain_594368;
          versionId: string; appId: string; domainName: string): Recallable =
  ## modelDeleteCustomPrebuiltDomain
  ## Deletes a prebuilt domain's models from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   domainName: string (required)
  ##             : Domain name.
  var path_594376 = newJObject()
  add(path_594376, "versionId", newJString(versionId))
  add(path_594376, "appId", newJString(appId))
  add(path_594376, "domainName", newJString(domainName))
  result = call_594375.call(path_594376, nil, nil, nil, nil)

var modelDeleteCustomPrebuiltDomain* = Call_ModelDeleteCustomPrebuiltDomain_594368(
    name: "modelDeleteCustomPrebuiltDomain", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltdomains/{domainName}",
    validator: validate_ModelDeleteCustomPrebuiltDomain_594369,
    base: "/luis/api/v2.0", url: url_ModelDeleteCustomPrebuiltDomain_594370,
    schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltEntity_594385 = ref object of OpenApiRestCall_593438
proc url_ModelAddCustomPrebuiltEntity_594387(protocol: Scheme; host: string;
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

proc validate_ModelAddCustomPrebuiltEntity_594386(path: JsonNode; query: JsonNode;
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
  var valid_594388 = path.getOrDefault("versionId")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "versionId", valid_594388
  var valid_594389 = path.getOrDefault("appId")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "appId", valid_594389
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

proc call*(call_594391: Call_ModelAddCustomPrebuiltEntity_594385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a custom prebuilt entity model to the application.
  ## 
  let valid = call_594391.validator(path, query, header, formData, body)
  let scheme = call_594391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594391.url(scheme.get, call_594391.host, call_594391.base,
                         call_594391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594391, url, valid)

proc call*(call_594392: Call_ModelAddCustomPrebuiltEntity_594385;
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
  var path_594393 = newJObject()
  var body_594394 = newJObject()
  if prebuiltDomainModelCreateObject != nil:
    body_594394 = prebuiltDomainModelCreateObject
  add(path_594393, "versionId", newJString(versionId))
  add(path_594393, "appId", newJString(appId))
  result = call_594392.call(path_594393, nil, nil, nil, body_594394)

var modelAddCustomPrebuiltEntity* = Call_ModelAddCustomPrebuiltEntity_594385(
    name: "modelAddCustomPrebuiltEntity", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltentities",
    validator: validate_ModelAddCustomPrebuiltEntity_594386,
    base: "/luis/api/v2.0", url: url_ModelAddCustomPrebuiltEntity_594387,
    schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltEntities_594377 = ref object of OpenApiRestCall_593438
proc url_ModelListCustomPrebuiltEntities_594379(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltEntities_594378(path: JsonNode;
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
  var valid_594380 = path.getOrDefault("versionId")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "versionId", valid_594380
  var valid_594381 = path.getOrDefault("appId")
  valid_594381 = validateParameter(valid_594381, JString, required = true,
                                 default = nil)
  if valid_594381 != nil:
    section.add "appId", valid_594381
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594382: Call_ModelListCustomPrebuiltEntities_594377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all custom prebuilt entities information of this application.
  ## 
  let valid = call_594382.validator(path, query, header, formData, body)
  let scheme = call_594382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594382.url(scheme.get, call_594382.host, call_594382.base,
                         call_594382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594382, url, valid)

proc call*(call_594383: Call_ModelListCustomPrebuiltEntities_594377;
          versionId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltEntities
  ## Gets all custom prebuilt entities information of this application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594384 = newJObject()
  add(path_594384, "versionId", newJString(versionId))
  add(path_594384, "appId", newJString(appId))
  result = call_594383.call(path_594384, nil, nil, nil, nil)

var modelListCustomPrebuiltEntities* = Call_ModelListCustomPrebuiltEntities_594377(
    name: "modelListCustomPrebuiltEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltentities",
    validator: validate_ModelListCustomPrebuiltEntities_594378,
    base: "/luis/api/v2.0", url: url_ModelListCustomPrebuiltEntities_594379,
    schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltIntent_594403 = ref object of OpenApiRestCall_593438
proc url_ModelAddCustomPrebuiltIntent_594405(protocol: Scheme; host: string;
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

proc validate_ModelAddCustomPrebuiltIntent_594404(path: JsonNode; query: JsonNode;
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
  var valid_594406 = path.getOrDefault("versionId")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "versionId", valid_594406
  var valid_594407 = path.getOrDefault("appId")
  valid_594407 = validateParameter(valid_594407, JString, required = true,
                                 default = nil)
  if valid_594407 != nil:
    section.add "appId", valid_594407
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

proc call*(call_594409: Call_ModelAddCustomPrebuiltIntent_594403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a custom prebuilt intent model to the application.
  ## 
  let valid = call_594409.validator(path, query, header, formData, body)
  let scheme = call_594409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594409.url(scheme.get, call_594409.host, call_594409.base,
                         call_594409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594409, url, valid)

proc call*(call_594410: Call_ModelAddCustomPrebuiltIntent_594403;
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
  var path_594411 = newJObject()
  var body_594412 = newJObject()
  if prebuiltDomainModelCreateObject != nil:
    body_594412 = prebuiltDomainModelCreateObject
  add(path_594411, "versionId", newJString(versionId))
  add(path_594411, "appId", newJString(appId))
  result = call_594410.call(path_594411, nil, nil, nil, body_594412)

var modelAddCustomPrebuiltIntent* = Call_ModelAddCustomPrebuiltIntent_594403(
    name: "modelAddCustomPrebuiltIntent", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltintents",
    validator: validate_ModelAddCustomPrebuiltIntent_594404,
    base: "/luis/api/v2.0", url: url_ModelAddCustomPrebuiltIntent_594405,
    schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltIntents_594395 = ref object of OpenApiRestCall_593438
proc url_ModelListCustomPrebuiltIntents_594397(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltIntents_594396(path: JsonNode;
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
  var valid_594398 = path.getOrDefault("versionId")
  valid_594398 = validateParameter(valid_594398, JString, required = true,
                                 default = nil)
  if valid_594398 != nil:
    section.add "versionId", valid_594398
  var valid_594399 = path.getOrDefault("appId")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "appId", valid_594399
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594400: Call_ModelListCustomPrebuiltIntents_594395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets custom prebuilt intents information of this application.
  ## 
  let valid = call_594400.validator(path, query, header, formData, body)
  let scheme = call_594400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594400.url(scheme.get, call_594400.host, call_594400.base,
                         call_594400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594400, url, valid)

proc call*(call_594401: Call_ModelListCustomPrebuiltIntents_594395;
          versionId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltIntents
  ## Gets custom prebuilt intents information of this application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594402 = newJObject()
  add(path_594402, "versionId", newJString(versionId))
  add(path_594402, "appId", newJString(appId))
  result = call_594401.call(path_594402, nil, nil, nil, nil)

var modelListCustomPrebuiltIntents* = Call_ModelListCustomPrebuiltIntents_594395(
    name: "modelListCustomPrebuiltIntents", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltintents",
    validator: validate_ModelListCustomPrebuiltIntents_594396,
    base: "/luis/api/v2.0", url: url_ModelListCustomPrebuiltIntents_594397,
    schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltModels_594413 = ref object of OpenApiRestCall_593438
proc url_ModelListCustomPrebuiltModels_594415(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltModels_594414(path: JsonNode; query: JsonNode;
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
  var valid_594416 = path.getOrDefault("versionId")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "versionId", valid_594416
  var valid_594417 = path.getOrDefault("appId")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "appId", valid_594417
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594418: Call_ModelListCustomPrebuiltModels_594413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all custom prebuilt models information of this application.
  ## 
  let valid = call_594418.validator(path, query, header, formData, body)
  let scheme = call_594418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594418.url(scheme.get, call_594418.host, call_594418.base,
                         call_594418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594418, url, valid)

proc call*(call_594419: Call_ModelListCustomPrebuiltModels_594413;
          versionId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltModels
  ## Gets all custom prebuilt models information of this application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594420 = newJObject()
  add(path_594420, "versionId", newJString(versionId))
  add(path_594420, "appId", newJString(appId))
  result = call_594419.call(path_594420, nil, nil, nil, nil)

var modelListCustomPrebuiltModels* = Call_ModelListCustomPrebuiltModels_594413(
    name: "modelListCustomPrebuiltModels", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltmodels",
    validator: validate_ModelListCustomPrebuiltModels_594414,
    base: "/luis/api/v2.0", url: url_ModelListCustomPrebuiltModels_594415,
    schemes: {Scheme.Https})
type
  Call_ModelAddEntity_594432 = ref object of OpenApiRestCall_593438
proc url_ModelAddEntity_594434(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddEntity_594433(path: JsonNode; query: JsonNode;
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
  var valid_594435 = path.getOrDefault("versionId")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "versionId", valid_594435
  var valid_594436 = path.getOrDefault("appId")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "appId", valid_594436
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

proc call*(call_594438: Call_ModelAddEntity_594432; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an entity extractor to the application.
  ## 
  let valid = call_594438.validator(path, query, header, formData, body)
  let scheme = call_594438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594438.url(scheme.get, call_594438.host, call_594438.base,
                         call_594438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594438, url, valid)

proc call*(call_594439: Call_ModelAddEntity_594432; versionId: string; appId: string;
          modelCreateObject: JsonNode): Recallable =
  ## modelAddEntity
  ## Adds an entity extractor to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   modelCreateObject: JObject (required)
  ##                    : A model object containing the name for the new entity extractor.
  var path_594440 = newJObject()
  var body_594441 = newJObject()
  add(path_594440, "versionId", newJString(versionId))
  add(path_594440, "appId", newJString(appId))
  if modelCreateObject != nil:
    body_594441 = modelCreateObject
  result = call_594439.call(path_594440, nil, nil, nil, body_594441)

var modelAddEntity* = Call_ModelAddEntity_594432(name: "modelAddEntity",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities",
    validator: validate_ModelAddEntity_594433, base: "/luis/api/v2.0",
    url: url_ModelAddEntity_594434, schemes: {Scheme.Https})
type
  Call_ModelListEntities_594421 = ref object of OpenApiRestCall_593438
proc url_ModelListEntities_594423(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListEntities_594422(path: JsonNode; query: JsonNode;
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
  var valid_594424 = path.getOrDefault("versionId")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "versionId", valid_594424
  var valid_594425 = path.getOrDefault("appId")
  valid_594425 = validateParameter(valid_594425, JString, required = true,
                                 default = nil)
  if valid_594425 != nil:
    section.add "appId", valid_594425
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594426 = query.getOrDefault("skip")
  valid_594426 = validateParameter(valid_594426, JInt, required = false,
                                 default = newJInt(0))
  if valid_594426 != nil:
    section.add "skip", valid_594426
  var valid_594427 = query.getOrDefault("take")
  valid_594427 = validateParameter(valid_594427, JInt, required = false,
                                 default = newJInt(100))
  if valid_594427 != nil:
    section.add "take", valid_594427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594428: Call_ModelListEntities_594421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the entity models.
  ## 
  let valid = call_594428.validator(path, query, header, formData, body)
  let scheme = call_594428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594428.url(scheme.get, call_594428.host, call_594428.base,
                         call_594428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594428, url, valid)

proc call*(call_594429: Call_ModelListEntities_594421; versionId: string;
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
  var path_594430 = newJObject()
  var query_594431 = newJObject()
  add(path_594430, "versionId", newJString(versionId))
  add(query_594431, "skip", newJInt(skip))
  add(query_594431, "take", newJInt(take))
  add(path_594430, "appId", newJString(appId))
  result = call_594429.call(path_594430, query_594431, nil, nil, nil)

var modelListEntities* = Call_ModelListEntities_594421(name: "modelListEntities",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities",
    validator: validate_ModelListEntities_594422, base: "/luis/api/v2.0",
    url: url_ModelListEntities_594423, schemes: {Scheme.Https})
type
  Call_ModelUpdateEntity_594451 = ref object of OpenApiRestCall_593438
proc url_ModelUpdateEntity_594453(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateEntity_594452(path: JsonNode; query: JsonNode;
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
  var valid_594454 = path.getOrDefault("versionId")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "versionId", valid_594454
  var valid_594455 = path.getOrDefault("entityId")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "entityId", valid_594455
  var valid_594456 = path.getOrDefault("appId")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "appId", valid_594456
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

proc call*(call_594458: Call_ModelUpdateEntity_594451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name of an entity extractor.
  ## 
  let valid = call_594458.validator(path, query, header, formData, body)
  let scheme = call_594458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594458.url(scheme.get, call_594458.host, call_594458.base,
                         call_594458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594458, url, valid)

proc call*(call_594459: Call_ModelUpdateEntity_594451; versionId: string;
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
  var path_594460 = newJObject()
  var body_594461 = newJObject()
  add(path_594460, "versionId", newJString(versionId))
  add(path_594460, "entityId", newJString(entityId))
  if modelUpdateObject != nil:
    body_594461 = modelUpdateObject
  add(path_594460, "appId", newJString(appId))
  result = call_594459.call(path_594460, nil, nil, nil, body_594461)

var modelUpdateEntity* = Call_ModelUpdateEntity_594451(name: "modelUpdateEntity",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelUpdateEntity_594452, base: "/luis/api/v2.0",
    url: url_ModelUpdateEntity_594453, schemes: {Scheme.Https})
type
  Call_ModelGetEntity_594442 = ref object of OpenApiRestCall_593438
proc url_ModelGetEntity_594444(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetEntity_594443(path: JsonNode; query: JsonNode;
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
  var valid_594445 = path.getOrDefault("versionId")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "versionId", valid_594445
  var valid_594446 = path.getOrDefault("entityId")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "entityId", valid_594446
  var valid_594447 = path.getOrDefault("appId")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "appId", valid_594447
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594448: Call_ModelGetEntity_594442; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the entity model.
  ## 
  let valid = call_594448.validator(path, query, header, formData, body)
  let scheme = call_594448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594448.url(scheme.get, call_594448.host, call_594448.base,
                         call_594448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594448, url, valid)

proc call*(call_594449: Call_ModelGetEntity_594442; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelGetEntity
  ## Gets information about the entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594450 = newJObject()
  add(path_594450, "versionId", newJString(versionId))
  add(path_594450, "entityId", newJString(entityId))
  add(path_594450, "appId", newJString(appId))
  result = call_594449.call(path_594450, nil, nil, nil, nil)

var modelGetEntity* = Call_ModelGetEntity_594442(name: "modelGetEntity",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelGetEntity_594443, base: "/luis/api/v2.0",
    url: url_ModelGetEntity_594444, schemes: {Scheme.Https})
type
  Call_ModelDeleteEntity_594462 = ref object of OpenApiRestCall_593438
proc url_ModelDeleteEntity_594464(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteEntity_594463(path: JsonNode; query: JsonNode;
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
  var valid_594465 = path.getOrDefault("versionId")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "versionId", valid_594465
  var valid_594466 = path.getOrDefault("entityId")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "entityId", valid_594466
  var valid_594467 = path.getOrDefault("appId")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "appId", valid_594467
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594468: Call_ModelDeleteEntity_594462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an entity extractor from the application.
  ## 
  let valid = call_594468.validator(path, query, header, formData, body)
  let scheme = call_594468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594468.url(scheme.get, call_594468.host, call_594468.base,
                         call_594468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594468, url, valid)

proc call*(call_594469: Call_ModelDeleteEntity_594462; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelDeleteEntity
  ## Deletes an entity extractor from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594470 = newJObject()
  add(path_594470, "versionId", newJString(versionId))
  add(path_594470, "entityId", newJString(entityId))
  add(path_594470, "appId", newJString(appId))
  result = call_594469.call(path_594470, nil, nil, nil, nil)

var modelDeleteEntity* = Call_ModelDeleteEntity_594462(name: "modelDeleteEntity",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelDeleteEntity_594463, base: "/luis/api/v2.0",
    url: url_ModelDeleteEntity_594464, schemes: {Scheme.Https})
type
  Call_ModelGetEntitySuggestions_594471 = ref object of OpenApiRestCall_593438
proc url_ModelGetEntitySuggestions_594473(protocol: Scheme; host: string;
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

proc validate_ModelGetEntitySuggestions_594472(path: JsonNode; query: JsonNode;
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
  var valid_594474 = path.getOrDefault("versionId")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "versionId", valid_594474
  var valid_594475 = path.getOrDefault("entityId")
  valid_594475 = validateParameter(valid_594475, JString, required = true,
                                 default = nil)
  if valid_594475 != nil:
    section.add "entityId", valid_594475
  var valid_594476 = path.getOrDefault("appId")
  valid_594476 = validateParameter(valid_594476, JString, required = true,
                                 default = nil)
  if valid_594476 != nil:
    section.add "appId", valid_594476
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594477 = query.getOrDefault("take")
  valid_594477 = validateParameter(valid_594477, JInt, required = false,
                                 default = newJInt(100))
  if valid_594477 != nil:
    section.add "take", valid_594477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594478: Call_ModelGetEntitySuggestions_594471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get suggestion examples that would improve the accuracy of the entity model.
  ## 
  let valid = call_594478.validator(path, query, header, formData, body)
  let scheme = call_594478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594478.url(scheme.get, call_594478.host, call_594478.base,
                         call_594478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594478, url, valid)

proc call*(call_594479: Call_ModelGetEntitySuggestions_594471; versionId: string;
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
  var path_594480 = newJObject()
  var query_594481 = newJObject()
  add(path_594480, "versionId", newJString(versionId))
  add(path_594480, "entityId", newJString(entityId))
  add(query_594481, "take", newJInt(take))
  add(path_594480, "appId", newJString(appId))
  result = call_594479.call(path_594480, query_594481, nil, nil, nil)

var modelGetEntitySuggestions* = Call_ModelGetEntitySuggestions_594471(
    name: "modelGetEntitySuggestions", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/suggest",
    validator: validate_ModelGetEntitySuggestions_594472, base: "/luis/api/v2.0",
    url: url_ModelGetEntitySuggestions_594473, schemes: {Scheme.Https})
type
  Call_ExamplesAdd_594482 = ref object of OpenApiRestCall_593438
proc url_ExamplesAdd_594484(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesAdd_594483(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594485 = path.getOrDefault("versionId")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "versionId", valid_594485
  var valid_594486 = path.getOrDefault("appId")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "appId", valid_594486
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

proc call*(call_594488: Call_ExamplesAdd_594482; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a labeled example to the application.
  ## 
  let valid = call_594488.validator(path, query, header, formData, body)
  let scheme = call_594488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594488.url(scheme.get, call_594488.host, call_594488.base,
                         call_594488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594488, url, valid)

proc call*(call_594489: Call_ExamplesAdd_594482; versionId: string; appId: string;
          exampleLabelObject: JsonNode): Recallable =
  ## examplesAdd
  ## Adds a labeled example to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   exampleLabelObject: JObject (required)
  ##                     : An example label with the expected intent and entities.
  var path_594490 = newJObject()
  var body_594491 = newJObject()
  add(path_594490, "versionId", newJString(versionId))
  add(path_594490, "appId", newJString(appId))
  if exampleLabelObject != nil:
    body_594491 = exampleLabelObject
  result = call_594489.call(path_594490, nil, nil, nil, body_594491)

var examplesAdd* = Call_ExamplesAdd_594482(name: "examplesAdd",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/apps/{appId}/versions/{versionId}/example",
                                        validator: validate_ExamplesAdd_594483,
                                        base: "/luis/api/v2.0",
                                        url: url_ExamplesAdd_594484,
                                        schemes: {Scheme.Https})
type
  Call_ExamplesBatch_594503 = ref object of OpenApiRestCall_593438
proc url_ExamplesBatch_594505(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesBatch_594504(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594506 = path.getOrDefault("versionId")
  valid_594506 = validateParameter(valid_594506, JString, required = true,
                                 default = nil)
  if valid_594506 != nil:
    section.add "versionId", valid_594506
  var valid_594507 = path.getOrDefault("appId")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "appId", valid_594507
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

proc call*(call_594509: Call_ExamplesBatch_594503; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a batch of labeled examples to the application.
  ## 
  let valid = call_594509.validator(path, query, header, formData, body)
  let scheme = call_594509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594509.url(scheme.get, call_594509.host, call_594509.base,
                         call_594509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594509, url, valid)

proc call*(call_594510: Call_ExamplesBatch_594503; versionId: string; appId: string;
          exampleLabelObjectArray: JsonNode): Recallable =
  ## examplesBatch
  ## Adds a batch of labeled examples to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   exampleLabelObjectArray: JArray (required)
  ##                          : Array of examples.
  var path_594511 = newJObject()
  var body_594512 = newJObject()
  add(path_594511, "versionId", newJString(versionId))
  add(path_594511, "appId", newJString(appId))
  if exampleLabelObjectArray != nil:
    body_594512 = exampleLabelObjectArray
  result = call_594510.call(path_594511, nil, nil, nil, body_594512)

var examplesBatch* = Call_ExamplesBatch_594503(name: "examplesBatch",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples",
    validator: validate_ExamplesBatch_594504, base: "/luis/api/v2.0",
    url: url_ExamplesBatch_594505, schemes: {Scheme.Https})
type
  Call_ExamplesList_594492 = ref object of OpenApiRestCall_593438
proc url_ExamplesList_594494(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesList_594493(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594495 = path.getOrDefault("versionId")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "versionId", valid_594495
  var valid_594496 = path.getOrDefault("appId")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "appId", valid_594496
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594497 = query.getOrDefault("skip")
  valid_594497 = validateParameter(valid_594497, JInt, required = false,
                                 default = newJInt(0))
  if valid_594497 != nil:
    section.add "skip", valid_594497
  var valid_594498 = query.getOrDefault("take")
  valid_594498 = validateParameter(valid_594498, JInt, required = false,
                                 default = newJInt(100))
  if valid_594498 != nil:
    section.add "take", valid_594498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594499: Call_ExamplesList_594492; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns examples to be reviewed.
  ## 
  let valid = call_594499.validator(path, query, header, formData, body)
  let scheme = call_594499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594499.url(scheme.get, call_594499.host, call_594499.base,
                         call_594499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594499, url, valid)

proc call*(call_594500: Call_ExamplesList_594492; versionId: string; appId: string;
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
  var path_594501 = newJObject()
  var query_594502 = newJObject()
  add(path_594501, "versionId", newJString(versionId))
  add(query_594502, "skip", newJInt(skip))
  add(query_594502, "take", newJInt(take))
  add(path_594501, "appId", newJString(appId))
  result = call_594500.call(path_594501, query_594502, nil, nil, nil)

var examplesList* = Call_ExamplesList_594492(name: "examplesList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples",
    validator: validate_ExamplesList_594493, base: "/luis/api/v2.0",
    url: url_ExamplesList_594494, schemes: {Scheme.Https})
type
  Call_ExamplesDelete_594513 = ref object of OpenApiRestCall_593438
proc url_ExamplesDelete_594515(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesDelete_594514(path: JsonNode; query: JsonNode;
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
  var valid_594516 = path.getOrDefault("versionId")
  valid_594516 = validateParameter(valid_594516, JString, required = true,
                                 default = nil)
  if valid_594516 != nil:
    section.add "versionId", valid_594516
  var valid_594517 = path.getOrDefault("appId")
  valid_594517 = validateParameter(valid_594517, JString, required = true,
                                 default = nil)
  if valid_594517 != nil:
    section.add "appId", valid_594517
  var valid_594518 = path.getOrDefault("exampleId")
  valid_594518 = validateParameter(valid_594518, JInt, required = true, default = nil)
  if valid_594518 != nil:
    section.add "exampleId", valid_594518
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594519: Call_ExamplesDelete_594513; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the labeled example with the specified ID.
  ## 
  let valid = call_594519.validator(path, query, header, formData, body)
  let scheme = call_594519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594519.url(scheme.get, call_594519.host, call_594519.base,
                         call_594519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594519, url, valid)

proc call*(call_594520: Call_ExamplesDelete_594513; versionId: string; appId: string;
          exampleId: int): Recallable =
  ## examplesDelete
  ## Deletes the labeled example with the specified ID.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   exampleId: int (required)
  ##            : The example ID.
  var path_594521 = newJObject()
  add(path_594521, "versionId", newJString(versionId))
  add(path_594521, "appId", newJString(appId))
  add(path_594521, "exampleId", newJInt(exampleId))
  result = call_594520.call(path_594521, nil, nil, nil, nil)

var examplesDelete* = Call_ExamplesDelete_594513(name: "examplesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples/{exampleId}",
    validator: validate_ExamplesDelete_594514, base: "/luis/api/v2.0",
    url: url_ExamplesDelete_594515, schemes: {Scheme.Https})
type
  Call_VersionsExport_594522 = ref object of OpenApiRestCall_593438
proc url_VersionsExport_594524(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsExport_594523(path: JsonNode; query: JsonNode;
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
  var valid_594525 = path.getOrDefault("versionId")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "versionId", valid_594525
  var valid_594526 = path.getOrDefault("appId")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "appId", valid_594526
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594527: Call_VersionsExport_594522; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a LUIS application to JSON format.
  ## 
  let valid = call_594527.validator(path, query, header, formData, body)
  let scheme = call_594527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594527.url(scheme.get, call_594527.host, call_594527.base,
                         call_594527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594527, url, valid)

proc call*(call_594528: Call_VersionsExport_594522; versionId: string; appId: string): Recallable =
  ## versionsExport
  ## Exports a LUIS application to JSON format.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594529 = newJObject()
  add(path_594529, "versionId", newJString(versionId))
  add(path_594529, "appId", newJString(appId))
  result = call_594528.call(path_594529, nil, nil, nil, nil)

var versionsExport* = Call_VersionsExport_594522(name: "versionsExport",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/export",
    validator: validate_VersionsExport_594523, base: "/luis/api/v2.0",
    url: url_VersionsExport_594524, schemes: {Scheme.Https})
type
  Call_FeaturesList_594530 = ref object of OpenApiRestCall_593438
proc url_FeaturesList_594532(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesList_594531(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594533 = path.getOrDefault("versionId")
  valid_594533 = validateParameter(valid_594533, JString, required = true,
                                 default = nil)
  if valid_594533 != nil:
    section.add "versionId", valid_594533
  var valid_594534 = path.getOrDefault("appId")
  valid_594534 = validateParameter(valid_594534, JString, required = true,
                                 default = nil)
  if valid_594534 != nil:
    section.add "appId", valid_594534
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594535 = query.getOrDefault("skip")
  valid_594535 = validateParameter(valid_594535, JInt, required = false,
                                 default = newJInt(0))
  if valid_594535 != nil:
    section.add "skip", valid_594535
  var valid_594536 = query.getOrDefault("take")
  valid_594536 = validateParameter(valid_594536, JInt, required = false,
                                 default = newJInt(100))
  if valid_594536 != nil:
    section.add "take", valid_594536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594537: Call_FeaturesList_594530; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the extraction features for the specified application version.
  ## 
  let valid = call_594537.validator(path, query, header, formData, body)
  let scheme = call_594537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594537.url(scheme.get, call_594537.host, call_594537.base,
                         call_594537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594537, url, valid)

proc call*(call_594538: Call_FeaturesList_594530; versionId: string; appId: string;
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
  var path_594539 = newJObject()
  var query_594540 = newJObject()
  add(path_594539, "versionId", newJString(versionId))
  add(query_594540, "skip", newJInt(skip))
  add(query_594540, "take", newJInt(take))
  add(path_594539, "appId", newJString(appId))
  result = call_594538.call(path_594539, query_594540, nil, nil, nil)

var featuresList* = Call_FeaturesList_594530(name: "featuresList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/features",
    validator: validate_FeaturesList_594531, base: "/luis/api/v2.0",
    url: url_FeaturesList_594532, schemes: {Scheme.Https})
type
  Call_ModelAddHierarchicalEntity_594552 = ref object of OpenApiRestCall_593438
proc url_ModelAddHierarchicalEntity_594554(protocol: Scheme; host: string;
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

proc validate_ModelAddHierarchicalEntity_594553(path: JsonNode; query: JsonNode;
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
  var valid_594555 = path.getOrDefault("versionId")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = nil)
  if valid_594555 != nil:
    section.add "versionId", valid_594555
  var valid_594556 = path.getOrDefault("appId")
  valid_594556 = validateParameter(valid_594556, JString, required = true,
                                 default = nil)
  if valid_594556 != nil:
    section.add "appId", valid_594556
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

proc call*(call_594558: Call_ModelAddHierarchicalEntity_594552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a hierarchical entity extractor to the application version.
  ## 
  let valid = call_594558.validator(path, query, header, formData, body)
  let scheme = call_594558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594558.url(scheme.get, call_594558.host, call_594558.base,
                         call_594558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594558, url, valid)

proc call*(call_594559: Call_ModelAddHierarchicalEntity_594552; versionId: string;
          hierarchicalModelCreateObject: JsonNode; appId: string): Recallable =
  ## modelAddHierarchicalEntity
  ## Adds a hierarchical entity extractor to the application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   hierarchicalModelCreateObject: JObject (required)
  ##                                : A model containing the name and children of the new entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594560 = newJObject()
  var body_594561 = newJObject()
  add(path_594560, "versionId", newJString(versionId))
  if hierarchicalModelCreateObject != nil:
    body_594561 = hierarchicalModelCreateObject
  add(path_594560, "appId", newJString(appId))
  result = call_594559.call(path_594560, nil, nil, nil, body_594561)

var modelAddHierarchicalEntity* = Call_ModelAddHierarchicalEntity_594552(
    name: "modelAddHierarchicalEntity", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/hierarchicalentities",
    validator: validate_ModelAddHierarchicalEntity_594553, base: "/luis/api/v2.0",
    url: url_ModelAddHierarchicalEntity_594554, schemes: {Scheme.Https})
type
  Call_ModelListHierarchicalEntities_594541 = ref object of OpenApiRestCall_593438
proc url_ModelListHierarchicalEntities_594543(protocol: Scheme; host: string;
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

proc validate_ModelListHierarchicalEntities_594542(path: JsonNode; query: JsonNode;
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
  var valid_594544 = path.getOrDefault("versionId")
  valid_594544 = validateParameter(valid_594544, JString, required = true,
                                 default = nil)
  if valid_594544 != nil:
    section.add "versionId", valid_594544
  var valid_594545 = path.getOrDefault("appId")
  valid_594545 = validateParameter(valid_594545, JString, required = true,
                                 default = nil)
  if valid_594545 != nil:
    section.add "appId", valid_594545
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594546 = query.getOrDefault("skip")
  valid_594546 = validateParameter(valid_594546, JInt, required = false,
                                 default = newJInt(0))
  if valid_594546 != nil:
    section.add "skip", valid_594546
  var valid_594547 = query.getOrDefault("take")
  valid_594547 = validateParameter(valid_594547, JInt, required = false,
                                 default = newJInt(100))
  if valid_594547 != nil:
    section.add "take", valid_594547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594548: Call_ModelListHierarchicalEntities_594541; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the hierarchical entity models.
  ## 
  let valid = call_594548.validator(path, query, header, formData, body)
  let scheme = call_594548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594548.url(scheme.get, call_594548.host, call_594548.base,
                         call_594548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594548, url, valid)

proc call*(call_594549: Call_ModelListHierarchicalEntities_594541;
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
  var path_594550 = newJObject()
  var query_594551 = newJObject()
  add(path_594550, "versionId", newJString(versionId))
  add(query_594551, "skip", newJInt(skip))
  add(query_594551, "take", newJInt(take))
  add(path_594550, "appId", newJString(appId))
  result = call_594549.call(path_594550, query_594551, nil, nil, nil)

var modelListHierarchicalEntities* = Call_ModelListHierarchicalEntities_594541(
    name: "modelListHierarchicalEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/hierarchicalentities",
    validator: validate_ModelListHierarchicalEntities_594542,
    base: "/luis/api/v2.0", url: url_ModelListHierarchicalEntities_594543,
    schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntity_594571 = ref object of OpenApiRestCall_593438
proc url_ModelUpdateHierarchicalEntity_594573(protocol: Scheme; host: string;
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

proc validate_ModelUpdateHierarchicalEntity_594572(path: JsonNode; query: JsonNode;
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
  var valid_594574 = path.getOrDefault("versionId")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "versionId", valid_594574
  var valid_594575 = path.getOrDefault("appId")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "appId", valid_594575
  var valid_594576 = path.getOrDefault("hEntityId")
  valid_594576 = validateParameter(valid_594576, JString, required = true,
                                 default = nil)
  if valid_594576 != nil:
    section.add "hEntityId", valid_594576
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

proc call*(call_594578: Call_ModelUpdateHierarchicalEntity_594571; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name and children of a hierarchical entity model.
  ## 
  let valid = call_594578.validator(path, query, header, formData, body)
  let scheme = call_594578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594578.url(scheme.get, call_594578.host, call_594578.base,
                         call_594578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594578, url, valid)

proc call*(call_594579: Call_ModelUpdateHierarchicalEntity_594571;
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
  var path_594580 = newJObject()
  var body_594581 = newJObject()
  add(path_594580, "versionId", newJString(versionId))
  add(path_594580, "appId", newJString(appId))
  if hierarchicalModelUpdateObject != nil:
    body_594581 = hierarchicalModelUpdateObject
  add(path_594580, "hEntityId", newJString(hEntityId))
  result = call_594579.call(path_594580, nil, nil, nil, body_594581)

var modelUpdateHierarchicalEntity* = Call_ModelUpdateHierarchicalEntity_594571(
    name: "modelUpdateHierarchicalEntity", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelUpdateHierarchicalEntity_594572,
    base: "/luis/api/v2.0", url: url_ModelUpdateHierarchicalEntity_594573,
    schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntity_594562 = ref object of OpenApiRestCall_593438
proc url_ModelGetHierarchicalEntity_594564(protocol: Scheme; host: string;
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

proc validate_ModelGetHierarchicalEntity_594563(path: JsonNode; query: JsonNode;
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
  var valid_594565 = path.getOrDefault("versionId")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "versionId", valid_594565
  var valid_594566 = path.getOrDefault("appId")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "appId", valid_594566
  var valid_594567 = path.getOrDefault("hEntityId")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "hEntityId", valid_594567
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594568: Call_ModelGetHierarchicalEntity_594562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the hierarchical entity model.
  ## 
  let valid = call_594568.validator(path, query, header, formData, body)
  let scheme = call_594568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594568.url(scheme.get, call_594568.host, call_594568.base,
                         call_594568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594568, url, valid)

proc call*(call_594569: Call_ModelGetHierarchicalEntity_594562; versionId: string;
          appId: string; hEntityId: string): Recallable =
  ## modelGetHierarchicalEntity
  ## Gets information about the hierarchical entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_594570 = newJObject()
  add(path_594570, "versionId", newJString(versionId))
  add(path_594570, "appId", newJString(appId))
  add(path_594570, "hEntityId", newJString(hEntityId))
  result = call_594569.call(path_594570, nil, nil, nil, nil)

var modelGetHierarchicalEntity* = Call_ModelGetHierarchicalEntity_594562(
    name: "modelGetHierarchicalEntity", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelGetHierarchicalEntity_594563, base: "/luis/api/v2.0",
    url: url_ModelGetHierarchicalEntity_594564, schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntity_594582 = ref object of OpenApiRestCall_593438
proc url_ModelDeleteHierarchicalEntity_594584(protocol: Scheme; host: string;
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

proc validate_ModelDeleteHierarchicalEntity_594583(path: JsonNode; query: JsonNode;
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
  var valid_594585 = path.getOrDefault("versionId")
  valid_594585 = validateParameter(valid_594585, JString, required = true,
                                 default = nil)
  if valid_594585 != nil:
    section.add "versionId", valid_594585
  var valid_594586 = path.getOrDefault("appId")
  valid_594586 = validateParameter(valid_594586, JString, required = true,
                                 default = nil)
  if valid_594586 != nil:
    section.add "appId", valid_594586
  var valid_594587 = path.getOrDefault("hEntityId")
  valid_594587 = validateParameter(valid_594587, JString, required = true,
                                 default = nil)
  if valid_594587 != nil:
    section.add "hEntityId", valid_594587
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594588: Call_ModelDeleteHierarchicalEntity_594582; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a hierarchical entity extractor from the application version.
  ## 
  let valid = call_594588.validator(path, query, header, formData, body)
  let scheme = call_594588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594588.url(scheme.get, call_594588.host, call_594588.base,
                         call_594588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594588, url, valid)

proc call*(call_594589: Call_ModelDeleteHierarchicalEntity_594582;
          versionId: string; appId: string; hEntityId: string): Recallable =
  ## modelDeleteHierarchicalEntity
  ## Deletes a hierarchical entity extractor from the application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_594590 = newJObject()
  add(path_594590, "versionId", newJString(versionId))
  add(path_594590, "appId", newJString(appId))
  add(path_594590, "hEntityId", newJString(hEntityId))
  result = call_594589.call(path_594590, nil, nil, nil, nil)

var modelDeleteHierarchicalEntity* = Call_ModelDeleteHierarchicalEntity_594582(
    name: "modelDeleteHierarchicalEntity", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelDeleteHierarchicalEntity_594583,
    base: "/luis/api/v2.0", url: url_ModelDeleteHierarchicalEntity_594584,
    schemes: {Scheme.Https})
type
  Call_ModelAddHierarchicalEntityChild_594591 = ref object of OpenApiRestCall_593438
proc url_ModelAddHierarchicalEntityChild_594593(protocol: Scheme; host: string;
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

proc validate_ModelAddHierarchicalEntityChild_594592(path: JsonNode;
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
  var valid_594594 = path.getOrDefault("versionId")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "versionId", valid_594594
  var valid_594595 = path.getOrDefault("appId")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "appId", valid_594595
  var valid_594596 = path.getOrDefault("hEntityId")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "hEntityId", valid_594596
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

proc call*(call_594598: Call_ModelAddHierarchicalEntityChild_594591;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a single child in an existing hierarchical entity model.
  ## 
  let valid = call_594598.validator(path, query, header, formData, body)
  let scheme = call_594598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594598.url(scheme.get, call_594598.host, call_594598.base,
                         call_594598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594598, url, valid)

proc call*(call_594599: Call_ModelAddHierarchicalEntityChild_594591;
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
  var path_594600 = newJObject()
  var body_594601 = newJObject()
  add(path_594600, "versionId", newJString(versionId))
  if hierarchicalChildModelCreateObject != nil:
    body_594601 = hierarchicalChildModelCreateObject
  add(path_594600, "appId", newJString(appId))
  add(path_594600, "hEntityId", newJString(hEntityId))
  result = call_594599.call(path_594600, nil, nil, nil, body_594601)

var modelAddHierarchicalEntityChild* = Call_ModelAddHierarchicalEntityChild_594591(
    name: "modelAddHierarchicalEntityChild", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children",
    validator: validate_ModelAddHierarchicalEntityChild_594592,
    base: "/luis/api/v2.0", url: url_ModelAddHierarchicalEntityChild_594593,
    schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntityChild_594612 = ref object of OpenApiRestCall_593438
proc url_ModelUpdateHierarchicalEntityChild_594614(protocol: Scheme; host: string;
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

proc validate_ModelUpdateHierarchicalEntityChild_594613(path: JsonNode;
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
  var valid_594615 = path.getOrDefault("versionId")
  valid_594615 = validateParameter(valid_594615, JString, required = true,
                                 default = nil)
  if valid_594615 != nil:
    section.add "versionId", valid_594615
  var valid_594616 = path.getOrDefault("appId")
  valid_594616 = validateParameter(valid_594616, JString, required = true,
                                 default = nil)
  if valid_594616 != nil:
    section.add "appId", valid_594616
  var valid_594617 = path.getOrDefault("hChildId")
  valid_594617 = validateParameter(valid_594617, JString, required = true,
                                 default = nil)
  if valid_594617 != nil:
    section.add "hChildId", valid_594617
  var valid_594618 = path.getOrDefault("hEntityId")
  valid_594618 = validateParameter(valid_594618, JString, required = true,
                                 default = nil)
  if valid_594618 != nil:
    section.add "hEntityId", valid_594618
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

proc call*(call_594620: Call_ModelUpdateHierarchicalEntityChild_594612;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renames a single child in an existing hierarchical entity model.
  ## 
  let valid = call_594620.validator(path, query, header, formData, body)
  let scheme = call_594620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594620.url(scheme.get, call_594620.host, call_594620.base,
                         call_594620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594620, url, valid)

proc call*(call_594621: Call_ModelUpdateHierarchicalEntityChild_594612;
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
  var path_594622 = newJObject()
  var body_594623 = newJObject()
  add(path_594622, "versionId", newJString(versionId))
  if hierarchicalChildModelUpdateObject != nil:
    body_594623 = hierarchicalChildModelUpdateObject
  add(path_594622, "appId", newJString(appId))
  add(path_594622, "hChildId", newJString(hChildId))
  add(path_594622, "hEntityId", newJString(hEntityId))
  result = call_594621.call(path_594622, nil, nil, nil, body_594623)

var modelUpdateHierarchicalEntityChild* = Call_ModelUpdateHierarchicalEntityChild_594612(
    name: "modelUpdateHierarchicalEntityChild", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelUpdateHierarchicalEntityChild_594613,
    base: "/luis/api/v2.0", url: url_ModelUpdateHierarchicalEntityChild_594614,
    schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntityChild_594602 = ref object of OpenApiRestCall_593438
proc url_ModelGetHierarchicalEntityChild_594604(protocol: Scheme; host: string;
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

proc validate_ModelGetHierarchicalEntityChild_594603(path: JsonNode;
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
  var valid_594605 = path.getOrDefault("versionId")
  valid_594605 = validateParameter(valid_594605, JString, required = true,
                                 default = nil)
  if valid_594605 != nil:
    section.add "versionId", valid_594605
  var valid_594606 = path.getOrDefault("appId")
  valid_594606 = validateParameter(valid_594606, JString, required = true,
                                 default = nil)
  if valid_594606 != nil:
    section.add "appId", valid_594606
  var valid_594607 = path.getOrDefault("hChildId")
  valid_594607 = validateParameter(valid_594607, JString, required = true,
                                 default = nil)
  if valid_594607 != nil:
    section.add "hChildId", valid_594607
  var valid_594608 = path.getOrDefault("hEntityId")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = nil)
  if valid_594608 != nil:
    section.add "hEntityId", valid_594608
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594609: Call_ModelGetHierarchicalEntityChild_594602;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the hierarchical entity child model.
  ## 
  let valid = call_594609.validator(path, query, header, formData, body)
  let scheme = call_594609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594609.url(scheme.get, call_594609.host, call_594609.base,
                         call_594609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594609, url, valid)

proc call*(call_594610: Call_ModelGetHierarchicalEntityChild_594602;
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
  var path_594611 = newJObject()
  add(path_594611, "versionId", newJString(versionId))
  add(path_594611, "appId", newJString(appId))
  add(path_594611, "hChildId", newJString(hChildId))
  add(path_594611, "hEntityId", newJString(hEntityId))
  result = call_594610.call(path_594611, nil, nil, nil, nil)

var modelGetHierarchicalEntityChild* = Call_ModelGetHierarchicalEntityChild_594602(
    name: "modelGetHierarchicalEntityChild", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelGetHierarchicalEntityChild_594603,
    base: "/luis/api/v2.0", url: url_ModelGetHierarchicalEntityChild_594604,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntityChild_594624 = ref object of OpenApiRestCall_593438
proc url_ModelDeleteHierarchicalEntityChild_594626(protocol: Scheme; host: string;
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

proc validate_ModelDeleteHierarchicalEntityChild_594625(path: JsonNode;
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
  var valid_594627 = path.getOrDefault("versionId")
  valid_594627 = validateParameter(valid_594627, JString, required = true,
                                 default = nil)
  if valid_594627 != nil:
    section.add "versionId", valid_594627
  var valid_594628 = path.getOrDefault("appId")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "appId", valid_594628
  var valid_594629 = path.getOrDefault("hChildId")
  valid_594629 = validateParameter(valid_594629, JString, required = true,
                                 default = nil)
  if valid_594629 != nil:
    section.add "hChildId", valid_594629
  var valid_594630 = path.getOrDefault("hEntityId")
  valid_594630 = validateParameter(valid_594630, JString, required = true,
                                 default = nil)
  if valid_594630 != nil:
    section.add "hEntityId", valid_594630
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594631: Call_ModelDeleteHierarchicalEntityChild_594624;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a hierarchical entity extractor child from the application.
  ## 
  let valid = call_594631.validator(path, query, header, formData, body)
  let scheme = call_594631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594631.url(scheme.get, call_594631.host, call_594631.base,
                         call_594631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594631, url, valid)

proc call*(call_594632: Call_ModelDeleteHierarchicalEntityChild_594624;
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
  var path_594633 = newJObject()
  add(path_594633, "versionId", newJString(versionId))
  add(path_594633, "appId", newJString(appId))
  add(path_594633, "hChildId", newJString(hChildId))
  add(path_594633, "hEntityId", newJString(hEntityId))
  result = call_594632.call(path_594633, nil, nil, nil, nil)

var modelDeleteHierarchicalEntityChild* = Call_ModelDeleteHierarchicalEntityChild_594624(
    name: "modelDeleteHierarchicalEntityChild", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelDeleteHierarchicalEntityChild_594625,
    base: "/luis/api/v2.0", url: url_ModelDeleteHierarchicalEntityChild_594626,
    schemes: {Scheme.Https})
type
  Call_ModelAddIntent_594645 = ref object of OpenApiRestCall_593438
proc url_ModelAddIntent_594647(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddIntent_594646(path: JsonNode; query: JsonNode;
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
  var valid_594648 = path.getOrDefault("versionId")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "versionId", valid_594648
  var valid_594649 = path.getOrDefault("appId")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "appId", valid_594649
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

proc call*(call_594651: Call_ModelAddIntent_594645; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an intent classifier to the application.
  ## 
  let valid = call_594651.validator(path, query, header, formData, body)
  let scheme = call_594651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594651.url(scheme.get, call_594651.host, call_594651.base,
                         call_594651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594651, url, valid)

proc call*(call_594652: Call_ModelAddIntent_594645; versionId: string; appId: string;
          intentCreateObject: JsonNode): Recallable =
  ## modelAddIntent
  ## Adds an intent classifier to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentCreateObject: JObject (required)
  ##                     : A model object containing the name of the new intent classifier.
  var path_594653 = newJObject()
  var body_594654 = newJObject()
  add(path_594653, "versionId", newJString(versionId))
  add(path_594653, "appId", newJString(appId))
  if intentCreateObject != nil:
    body_594654 = intentCreateObject
  result = call_594652.call(path_594653, nil, nil, nil, body_594654)

var modelAddIntent* = Call_ModelAddIntent_594645(name: "modelAddIntent",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents",
    validator: validate_ModelAddIntent_594646, base: "/luis/api/v2.0",
    url: url_ModelAddIntent_594647, schemes: {Scheme.Https})
type
  Call_ModelListIntents_594634 = ref object of OpenApiRestCall_593438
proc url_ModelListIntents_594636(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListIntents_594635(path: JsonNode; query: JsonNode;
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
  var valid_594637 = path.getOrDefault("versionId")
  valid_594637 = validateParameter(valid_594637, JString, required = true,
                                 default = nil)
  if valid_594637 != nil:
    section.add "versionId", valid_594637
  var valid_594638 = path.getOrDefault("appId")
  valid_594638 = validateParameter(valid_594638, JString, required = true,
                                 default = nil)
  if valid_594638 != nil:
    section.add "appId", valid_594638
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594639 = query.getOrDefault("skip")
  valid_594639 = validateParameter(valid_594639, JInt, required = false,
                                 default = newJInt(0))
  if valid_594639 != nil:
    section.add "skip", valid_594639
  var valid_594640 = query.getOrDefault("take")
  valid_594640 = validateParameter(valid_594640, JInt, required = false,
                                 default = newJInt(100))
  if valid_594640 != nil:
    section.add "take", valid_594640
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594641: Call_ModelListIntents_594634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the intent models.
  ## 
  let valid = call_594641.validator(path, query, header, formData, body)
  let scheme = call_594641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594641.url(scheme.get, call_594641.host, call_594641.base,
                         call_594641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594641, url, valid)

proc call*(call_594642: Call_ModelListIntents_594634; versionId: string;
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
  var path_594643 = newJObject()
  var query_594644 = newJObject()
  add(path_594643, "versionId", newJString(versionId))
  add(query_594644, "skip", newJInt(skip))
  add(query_594644, "take", newJInt(take))
  add(path_594643, "appId", newJString(appId))
  result = call_594642.call(path_594643, query_594644, nil, nil, nil)

var modelListIntents* = Call_ModelListIntents_594634(name: "modelListIntents",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents",
    validator: validate_ModelListIntents_594635, base: "/luis/api/v2.0",
    url: url_ModelListIntents_594636, schemes: {Scheme.Https})
type
  Call_ModelUpdateIntent_594664 = ref object of OpenApiRestCall_593438
proc url_ModelUpdateIntent_594666(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateIntent_594665(path: JsonNode; query: JsonNode;
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
  var valid_594667 = path.getOrDefault("versionId")
  valid_594667 = validateParameter(valid_594667, JString, required = true,
                                 default = nil)
  if valid_594667 != nil:
    section.add "versionId", valid_594667
  var valid_594668 = path.getOrDefault("appId")
  valid_594668 = validateParameter(valid_594668, JString, required = true,
                                 default = nil)
  if valid_594668 != nil:
    section.add "appId", valid_594668
  var valid_594669 = path.getOrDefault("intentId")
  valid_594669 = validateParameter(valid_594669, JString, required = true,
                                 default = nil)
  if valid_594669 != nil:
    section.add "intentId", valid_594669
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

proc call*(call_594671: Call_ModelUpdateIntent_594664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name of an intent classifier.
  ## 
  let valid = call_594671.validator(path, query, header, formData, body)
  let scheme = call_594671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594671.url(scheme.get, call_594671.host, call_594671.base,
                         call_594671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594671, url, valid)

proc call*(call_594672: Call_ModelUpdateIntent_594664; versionId: string;
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
  var path_594673 = newJObject()
  var body_594674 = newJObject()
  add(path_594673, "versionId", newJString(versionId))
  if modelUpdateObject != nil:
    body_594674 = modelUpdateObject
  add(path_594673, "appId", newJString(appId))
  add(path_594673, "intentId", newJString(intentId))
  result = call_594672.call(path_594673, nil, nil, nil, body_594674)

var modelUpdateIntent* = Call_ModelUpdateIntent_594664(name: "modelUpdateIntent",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelUpdateIntent_594665, base: "/luis/api/v2.0",
    url: url_ModelUpdateIntent_594666, schemes: {Scheme.Https})
type
  Call_ModelGetIntent_594655 = ref object of OpenApiRestCall_593438
proc url_ModelGetIntent_594657(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetIntent_594656(path: JsonNode; query: JsonNode;
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
  var valid_594658 = path.getOrDefault("versionId")
  valid_594658 = validateParameter(valid_594658, JString, required = true,
                                 default = nil)
  if valid_594658 != nil:
    section.add "versionId", valid_594658
  var valid_594659 = path.getOrDefault("appId")
  valid_594659 = validateParameter(valid_594659, JString, required = true,
                                 default = nil)
  if valid_594659 != nil:
    section.add "appId", valid_594659
  var valid_594660 = path.getOrDefault("intentId")
  valid_594660 = validateParameter(valid_594660, JString, required = true,
                                 default = nil)
  if valid_594660 != nil:
    section.add "intentId", valid_594660
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594661: Call_ModelGetIntent_594655; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the intent model.
  ## 
  let valid = call_594661.validator(path, query, header, formData, body)
  let scheme = call_594661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594661.url(scheme.get, call_594661.host, call_594661.base,
                         call_594661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594661, url, valid)

proc call*(call_594662: Call_ModelGetIntent_594655; versionId: string; appId: string;
          intentId: string): Recallable =
  ## modelGetIntent
  ## Gets information about the intent model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  var path_594663 = newJObject()
  add(path_594663, "versionId", newJString(versionId))
  add(path_594663, "appId", newJString(appId))
  add(path_594663, "intentId", newJString(intentId))
  result = call_594662.call(path_594663, nil, nil, nil, nil)

var modelGetIntent* = Call_ModelGetIntent_594655(name: "modelGetIntent",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelGetIntent_594656, base: "/luis/api/v2.0",
    url: url_ModelGetIntent_594657, schemes: {Scheme.Https})
type
  Call_ModelDeleteIntent_594675 = ref object of OpenApiRestCall_593438
proc url_ModelDeleteIntent_594677(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteIntent_594676(path: JsonNode; query: JsonNode;
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
  var valid_594678 = path.getOrDefault("versionId")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "versionId", valid_594678
  var valid_594679 = path.getOrDefault("appId")
  valid_594679 = validateParameter(valid_594679, JString, required = true,
                                 default = nil)
  if valid_594679 != nil:
    section.add "appId", valid_594679
  var valid_594680 = path.getOrDefault("intentId")
  valid_594680 = validateParameter(valid_594680, JString, required = true,
                                 default = nil)
  if valid_594680 != nil:
    section.add "intentId", valid_594680
  result.add "path", section
  ## parameters in `query` object:
  ##   deleteUtterances: JBool
  ##                   : Also delete the intent's utterances (true). Or move the utterances to the None intent (false - the default value).
  section = newJObject()
  var valid_594681 = query.getOrDefault("deleteUtterances")
  valid_594681 = validateParameter(valid_594681, JBool, required = false,
                                 default = newJBool(false))
  if valid_594681 != nil:
    section.add "deleteUtterances", valid_594681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594682: Call_ModelDeleteIntent_594675; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an intent classifier from the application.
  ## 
  let valid = call_594682.validator(path, query, header, formData, body)
  let scheme = call_594682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594682.url(scheme.get, call_594682.host, call_594682.base,
                         call_594682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594682, url, valid)

proc call*(call_594683: Call_ModelDeleteIntent_594675; versionId: string;
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
  var path_594684 = newJObject()
  var query_594685 = newJObject()
  add(path_594684, "versionId", newJString(versionId))
  add(query_594685, "deleteUtterances", newJBool(deleteUtterances))
  add(path_594684, "appId", newJString(appId))
  add(path_594684, "intentId", newJString(intentId))
  result = call_594683.call(path_594684, query_594685, nil, nil, nil)

var modelDeleteIntent* = Call_ModelDeleteIntent_594675(name: "modelDeleteIntent",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelDeleteIntent_594676, base: "/luis/api/v2.0",
    url: url_ModelDeleteIntent_594677, schemes: {Scheme.Https})
type
  Call_ModelGetIntentSuggestions_594686 = ref object of OpenApiRestCall_593438
proc url_ModelGetIntentSuggestions_594688(protocol: Scheme; host: string;
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

proc validate_ModelGetIntentSuggestions_594687(path: JsonNode; query: JsonNode;
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
  var valid_594689 = path.getOrDefault("versionId")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = nil)
  if valid_594689 != nil:
    section.add "versionId", valid_594689
  var valid_594690 = path.getOrDefault("appId")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = nil)
  if valid_594690 != nil:
    section.add "appId", valid_594690
  var valid_594691 = path.getOrDefault("intentId")
  valid_594691 = validateParameter(valid_594691, JString, required = true,
                                 default = nil)
  if valid_594691 != nil:
    section.add "intentId", valid_594691
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594692 = query.getOrDefault("take")
  valid_594692 = validateParameter(valid_594692, JInt, required = false,
                                 default = newJInt(100))
  if valid_594692 != nil:
    section.add "take", valid_594692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594693: Call_ModelGetIntentSuggestions_594686; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests examples that would improve the accuracy of the intent model.
  ## 
  let valid = call_594693.validator(path, query, header, formData, body)
  let scheme = call_594693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594693.url(scheme.get, call_594693.host, call_594693.base,
                         call_594693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594693, url, valid)

proc call*(call_594694: Call_ModelGetIntentSuggestions_594686; versionId: string;
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
  var path_594695 = newJObject()
  var query_594696 = newJObject()
  add(path_594695, "versionId", newJString(versionId))
  add(query_594696, "take", newJInt(take))
  add(path_594695, "appId", newJString(appId))
  add(path_594695, "intentId", newJString(intentId))
  result = call_594694.call(path_594695, query_594696, nil, nil, nil)

var modelGetIntentSuggestions* = Call_ModelGetIntentSuggestions_594686(
    name: "modelGetIntentSuggestions", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}/suggest",
    validator: validate_ModelGetIntentSuggestions_594687, base: "/luis/api/v2.0",
    url: url_ModelGetIntentSuggestions_594688, schemes: {Scheme.Https})
type
  Call_ModelListPrebuiltEntities_594697 = ref object of OpenApiRestCall_593438
proc url_ModelListPrebuiltEntities_594699(protocol: Scheme; host: string;
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

proc validate_ModelListPrebuiltEntities_594698(path: JsonNode; query: JsonNode;
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
  var valid_594700 = path.getOrDefault("versionId")
  valid_594700 = validateParameter(valid_594700, JString, required = true,
                                 default = nil)
  if valid_594700 != nil:
    section.add "versionId", valid_594700
  var valid_594701 = path.getOrDefault("appId")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = nil)
  if valid_594701 != nil:
    section.add "appId", valid_594701
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594702: Call_ModelListPrebuiltEntities_594697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the available prebuilt entity extractors for the application.
  ## 
  let valid = call_594702.validator(path, query, header, formData, body)
  let scheme = call_594702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594702.url(scheme.get, call_594702.host, call_594702.base,
                         call_594702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594702, url, valid)

proc call*(call_594703: Call_ModelListPrebuiltEntities_594697; versionId: string;
          appId: string): Recallable =
  ## modelListPrebuiltEntities
  ## Gets all the available prebuilt entity extractors for the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594704 = newJObject()
  add(path_594704, "versionId", newJString(versionId))
  add(path_594704, "appId", newJString(appId))
  result = call_594703.call(path_594704, nil, nil, nil, nil)

var modelListPrebuiltEntities* = Call_ModelListPrebuiltEntities_594697(
    name: "modelListPrebuiltEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/listprebuilts",
    validator: validate_ModelListPrebuiltEntities_594698, base: "/luis/api/v2.0",
    url: url_ModelListPrebuiltEntities_594699, schemes: {Scheme.Https})
type
  Call_ModelListModels_594705 = ref object of OpenApiRestCall_593438
proc url_ModelListModels_594707(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListModels_594706(path: JsonNode; query: JsonNode;
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
  var valid_594708 = path.getOrDefault("versionId")
  valid_594708 = validateParameter(valid_594708, JString, required = true,
                                 default = nil)
  if valid_594708 != nil:
    section.add "versionId", valid_594708
  var valid_594709 = path.getOrDefault("appId")
  valid_594709 = validateParameter(valid_594709, JString, required = true,
                                 default = nil)
  if valid_594709 != nil:
    section.add "appId", valid_594709
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594710 = query.getOrDefault("skip")
  valid_594710 = validateParameter(valid_594710, JInt, required = false,
                                 default = newJInt(0))
  if valid_594710 != nil:
    section.add "skip", valid_594710
  var valid_594711 = query.getOrDefault("take")
  valid_594711 = validateParameter(valid_594711, JInt, required = false,
                                 default = newJInt(100))
  if valid_594711 != nil:
    section.add "take", valid_594711
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594712: Call_ModelListModels_594705; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the application version models.
  ## 
  let valid = call_594712.validator(path, query, header, formData, body)
  let scheme = call_594712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594712.url(scheme.get, call_594712.host, call_594712.base,
                         call_594712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594712, url, valid)

proc call*(call_594713: Call_ModelListModels_594705; versionId: string;
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
  var path_594714 = newJObject()
  var query_594715 = newJObject()
  add(path_594714, "versionId", newJString(versionId))
  add(query_594715, "skip", newJInt(skip))
  add(query_594715, "take", newJInt(take))
  add(path_594714, "appId", newJString(appId))
  result = call_594713.call(path_594714, query_594715, nil, nil, nil)

var modelListModels* = Call_ModelListModels_594705(name: "modelListModels",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/models",
    validator: validate_ModelListModels_594706, base: "/luis/api/v2.0",
    url: url_ModelListModels_594707, schemes: {Scheme.Https})
type
  Call_FeaturesCreatePatternFeature_594727 = ref object of OpenApiRestCall_593438
proc url_FeaturesCreatePatternFeature_594729(protocol: Scheme; host: string;
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

proc validate_FeaturesCreatePatternFeature_594728(path: JsonNode; query: JsonNode;
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
  var valid_594730 = path.getOrDefault("versionId")
  valid_594730 = validateParameter(valid_594730, JString, required = true,
                                 default = nil)
  if valid_594730 != nil:
    section.add "versionId", valid_594730
  var valid_594731 = path.getOrDefault("appId")
  valid_594731 = validateParameter(valid_594731, JString, required = true,
                                 default = nil)
  if valid_594731 != nil:
    section.add "appId", valid_594731
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

proc call*(call_594733: Call_FeaturesCreatePatternFeature_594727; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature.
  ## 
  let valid = call_594733.validator(path, query, header, formData, body)
  let scheme = call_594733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594733.url(scheme.get, call_594733.host, call_594733.base,
                         call_594733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594733, url, valid)

proc call*(call_594734: Call_FeaturesCreatePatternFeature_594727;
          patternCreateObject: JsonNode; versionId: string; appId: string): Recallable =
  ## featuresCreatePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature.
  ##   patternCreateObject: JObject (required)
  ##                      : The Name and Pattern of the feature.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594735 = newJObject()
  var body_594736 = newJObject()
  if patternCreateObject != nil:
    body_594736 = patternCreateObject
  add(path_594735, "versionId", newJString(versionId))
  add(path_594735, "appId", newJString(appId))
  result = call_594734.call(path_594735, nil, nil, nil, body_594736)

var featuresCreatePatternFeature* = Call_FeaturesCreatePatternFeature_594727(
    name: "featuresCreatePatternFeature", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patterns",
    validator: validate_FeaturesCreatePatternFeature_594728,
    base: "/luis/api/v2.0", url: url_FeaturesCreatePatternFeature_594729,
    schemes: {Scheme.Https})
type
  Call_FeaturesGetApplicationVersionPatternFeatures_594716 = ref object of OpenApiRestCall_593438
proc url_FeaturesGetApplicationVersionPatternFeatures_594718(protocol: Scheme;
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

proc validate_FeaturesGetApplicationVersionPatternFeatures_594717(path: JsonNode;
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
  var valid_594719 = path.getOrDefault("versionId")
  valid_594719 = validateParameter(valid_594719, JString, required = true,
                                 default = nil)
  if valid_594719 != nil:
    section.add "versionId", valid_594719
  var valid_594720 = path.getOrDefault("appId")
  valid_594720 = validateParameter(valid_594720, JString, required = true,
                                 default = nil)
  if valid_594720 != nil:
    section.add "appId", valid_594720
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594721 = query.getOrDefault("skip")
  valid_594721 = validateParameter(valid_594721, JInt, required = false,
                                 default = newJInt(0))
  if valid_594721 != nil:
    section.add "skip", valid_594721
  var valid_594722 = query.getOrDefault("take")
  valid_594722 = validateParameter(valid_594722, JInt, required = false,
                                 default = newJInt(100))
  if valid_594722 != nil:
    section.add "take", valid_594722
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594723: Call_FeaturesGetApplicationVersionPatternFeatures_594716;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ## 
  let valid = call_594723.validator(path, query, header, formData, body)
  let scheme = call_594723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594723.url(scheme.get, call_594723.host, call_594723.base,
                         call_594723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594723, url, valid)

proc call*(call_594724: Call_FeaturesGetApplicationVersionPatternFeatures_594716;
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
  var path_594725 = newJObject()
  var query_594726 = newJObject()
  add(path_594725, "versionId", newJString(versionId))
  add(query_594726, "skip", newJInt(skip))
  add(query_594726, "take", newJInt(take))
  add(path_594725, "appId", newJString(appId))
  result = call_594724.call(path_594725, query_594726, nil, nil, nil)

var featuresGetApplicationVersionPatternFeatures* = Call_FeaturesGetApplicationVersionPatternFeatures_594716(
    name: "featuresGetApplicationVersionPatternFeatures",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns",
    validator: validate_FeaturesGetApplicationVersionPatternFeatures_594717,
    base: "/luis/api/v2.0", url: url_FeaturesGetApplicationVersionPatternFeatures_594718,
    schemes: {Scheme.Https})
type
  Call_FeaturesUpdatePatternFeature_594746 = ref object of OpenApiRestCall_593438
proc url_FeaturesUpdatePatternFeature_594748(protocol: Scheme; host: string;
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

proc validate_FeaturesUpdatePatternFeature_594747(path: JsonNode; query: JsonNode;
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
  var valid_594749 = path.getOrDefault("versionId")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "versionId", valid_594749
  var valid_594750 = path.getOrDefault("patternId")
  valid_594750 = validateParameter(valid_594750, JInt, required = true, default = nil)
  if valid_594750 != nil:
    section.add "patternId", valid_594750
  var valid_594751 = path.getOrDefault("appId")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "appId", valid_594751
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

proc call*(call_594753: Call_FeaturesUpdatePatternFeature_594746; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature.
  ## 
  let valid = call_594753.validator(path, query, header, formData, body)
  let scheme = call_594753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594753.url(scheme.get, call_594753.host, call_594753.base,
                         call_594753.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594753, url, valid)

proc call*(call_594754: Call_FeaturesUpdatePatternFeature_594746;
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
  var path_594755 = newJObject()
  var body_594756 = newJObject()
  add(path_594755, "versionId", newJString(versionId))
  add(path_594755, "patternId", newJInt(patternId))
  add(path_594755, "appId", newJString(appId))
  if patternUpdateObject != nil:
    body_594756 = patternUpdateObject
  result = call_594754.call(path_594755, nil, nil, nil, body_594756)

var featuresUpdatePatternFeature* = Call_FeaturesUpdatePatternFeature_594746(
    name: "featuresUpdatePatternFeature", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesUpdatePatternFeature_594747,
    base: "/luis/api/v2.0", url: url_FeaturesUpdatePatternFeature_594748,
    schemes: {Scheme.Https})
type
  Call_FeaturesGetPatternFeatureInfo_594737 = ref object of OpenApiRestCall_593438
proc url_FeaturesGetPatternFeatureInfo_594739(protocol: Scheme; host: string;
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

proc validate_FeaturesGetPatternFeatureInfo_594738(path: JsonNode; query: JsonNode;
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
  var valid_594740 = path.getOrDefault("versionId")
  valid_594740 = validateParameter(valid_594740, JString, required = true,
                                 default = nil)
  if valid_594740 != nil:
    section.add "versionId", valid_594740
  var valid_594741 = path.getOrDefault("patternId")
  valid_594741 = validateParameter(valid_594741, JInt, required = true, default = nil)
  if valid_594741 != nil:
    section.add "patternId", valid_594741
  var valid_594742 = path.getOrDefault("appId")
  valid_594742 = validateParameter(valid_594742, JString, required = true,
                                 default = nil)
  if valid_594742 != nil:
    section.add "appId", valid_594742
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594743: Call_FeaturesGetPatternFeatureInfo_594737; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info.
  ## 
  let valid = call_594743.validator(path, query, header, formData, body)
  let scheme = call_594743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594743.url(scheme.get, call_594743.host, call_594743.base,
                         call_594743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594743, url, valid)

proc call*(call_594744: Call_FeaturesGetPatternFeatureInfo_594737;
          versionId: string; patternId: int; appId: string): Recallable =
  ## featuresGetPatternFeatureInfo
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594745 = newJObject()
  add(path_594745, "versionId", newJString(versionId))
  add(path_594745, "patternId", newJInt(patternId))
  add(path_594745, "appId", newJString(appId))
  result = call_594744.call(path_594745, nil, nil, nil, nil)

var featuresGetPatternFeatureInfo* = Call_FeaturesGetPatternFeatureInfo_594737(
    name: "featuresGetPatternFeatureInfo", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesGetPatternFeatureInfo_594738,
    base: "/luis/api/v2.0", url: url_FeaturesGetPatternFeatureInfo_594739,
    schemes: {Scheme.Https})
type
  Call_FeaturesDeletePatternFeature_594757 = ref object of OpenApiRestCall_593438
proc url_FeaturesDeletePatternFeature_594759(protocol: Scheme; host: string;
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

proc validate_FeaturesDeletePatternFeature_594758(path: JsonNode; query: JsonNode;
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
  var valid_594760 = path.getOrDefault("versionId")
  valid_594760 = validateParameter(valid_594760, JString, required = true,
                                 default = nil)
  if valid_594760 != nil:
    section.add "versionId", valid_594760
  var valid_594761 = path.getOrDefault("patternId")
  valid_594761 = validateParameter(valid_594761, JInt, required = true, default = nil)
  if valid_594761 != nil:
    section.add "patternId", valid_594761
  var valid_594762 = path.getOrDefault("appId")
  valid_594762 = validateParameter(valid_594762, JString, required = true,
                                 default = nil)
  if valid_594762 != nil:
    section.add "appId", valid_594762
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594763: Call_FeaturesDeletePatternFeature_594757; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature.
  ## 
  let valid = call_594763.validator(path, query, header, formData, body)
  let scheme = call_594763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594763.url(scheme.get, call_594763.host, call_594763.base,
                         call_594763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594763, url, valid)

proc call*(call_594764: Call_FeaturesDeletePatternFeature_594757;
          versionId: string; patternId: int; appId: string): Recallable =
  ## featuresDeletePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594765 = newJObject()
  add(path_594765, "versionId", newJString(versionId))
  add(path_594765, "patternId", newJInt(patternId))
  add(path_594765, "appId", newJString(appId))
  result = call_594764.call(path_594765, nil, nil, nil, nil)

var featuresDeletePatternFeature* = Call_FeaturesDeletePatternFeature_594757(
    name: "featuresDeletePatternFeature", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesDeletePatternFeature_594758,
    base: "/luis/api/v2.0", url: url_FeaturesDeletePatternFeature_594759,
    schemes: {Scheme.Https})
type
  Call_FeaturesAddPhraseList_594777 = ref object of OpenApiRestCall_593438
proc url_FeaturesAddPhraseList_594779(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesAddPhraseList_594778(path: JsonNode; query: JsonNode;
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
  var valid_594780 = path.getOrDefault("versionId")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "versionId", valid_594780
  var valid_594781 = path.getOrDefault("appId")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "appId", valid_594781
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

proc call*(call_594783: Call_FeaturesAddPhraseList_594777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new phraselist feature.
  ## 
  let valid = call_594783.validator(path, query, header, formData, body)
  let scheme = call_594783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594783.url(scheme.get, call_594783.host, call_594783.base,
                         call_594783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594783, url, valid)

proc call*(call_594784: Call_FeaturesAddPhraseList_594777; versionId: string;
          phraselistCreateObject: JsonNode; appId: string): Recallable =
  ## featuresAddPhraseList
  ## Creates a new phraselist feature.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistCreateObject: JObject (required)
  ##                         : A Phraselist object containing Name, comma-separated Phrases and the isExchangeable boolean. Default value for isExchangeable is true.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594785 = newJObject()
  var body_594786 = newJObject()
  add(path_594785, "versionId", newJString(versionId))
  if phraselistCreateObject != nil:
    body_594786 = phraselistCreateObject
  add(path_594785, "appId", newJString(appId))
  result = call_594784.call(path_594785, nil, nil, nil, body_594786)

var featuresAddPhraseList* = Call_FeaturesAddPhraseList_594777(
    name: "featuresAddPhraseList", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists",
    validator: validate_FeaturesAddPhraseList_594778, base: "/luis/api/v2.0",
    url: url_FeaturesAddPhraseList_594779, schemes: {Scheme.Https})
type
  Call_FeaturesListPhraseLists_594766 = ref object of OpenApiRestCall_593438
proc url_FeaturesListPhraseLists_594768(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesListPhraseLists_594767(path: JsonNode; query: JsonNode;
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
  var valid_594769 = path.getOrDefault("versionId")
  valid_594769 = validateParameter(valid_594769, JString, required = true,
                                 default = nil)
  if valid_594769 != nil:
    section.add "versionId", valid_594769
  var valid_594770 = path.getOrDefault("appId")
  valid_594770 = validateParameter(valid_594770, JString, required = true,
                                 default = nil)
  if valid_594770 != nil:
    section.add "appId", valid_594770
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594771 = query.getOrDefault("skip")
  valid_594771 = validateParameter(valid_594771, JInt, required = false,
                                 default = newJInt(0))
  if valid_594771 != nil:
    section.add "skip", valid_594771
  var valid_594772 = query.getOrDefault("take")
  valid_594772 = validateParameter(valid_594772, JInt, required = false,
                                 default = newJInt(100))
  if valid_594772 != nil:
    section.add "take", valid_594772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594773: Call_FeaturesListPhraseLists_594766; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the phraselist features.
  ## 
  let valid = call_594773.validator(path, query, header, formData, body)
  let scheme = call_594773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594773.url(scheme.get, call_594773.host, call_594773.base,
                         call_594773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594773, url, valid)

proc call*(call_594774: Call_FeaturesListPhraseLists_594766; versionId: string;
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
  var path_594775 = newJObject()
  var query_594776 = newJObject()
  add(path_594775, "versionId", newJString(versionId))
  add(query_594776, "skip", newJInt(skip))
  add(query_594776, "take", newJInt(take))
  add(path_594775, "appId", newJString(appId))
  result = call_594774.call(path_594775, query_594776, nil, nil, nil)

var featuresListPhraseLists* = Call_FeaturesListPhraseLists_594766(
    name: "featuresListPhraseLists", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists",
    validator: validate_FeaturesListPhraseLists_594767, base: "/luis/api/v2.0",
    url: url_FeaturesListPhraseLists_594768, schemes: {Scheme.Https})
type
  Call_FeaturesUpdatePhraseList_594796 = ref object of OpenApiRestCall_593438
proc url_FeaturesUpdatePhraseList_594798(protocol: Scheme; host: string;
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

proc validate_FeaturesUpdatePhraseList_594797(path: JsonNode; query: JsonNode;
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
  var valid_594799 = path.getOrDefault("versionId")
  valid_594799 = validateParameter(valid_594799, JString, required = true,
                                 default = nil)
  if valid_594799 != nil:
    section.add "versionId", valid_594799
  var valid_594800 = path.getOrDefault("phraselistId")
  valid_594800 = validateParameter(valid_594800, JInt, required = true, default = nil)
  if valid_594800 != nil:
    section.add "phraselistId", valid_594800
  var valid_594801 = path.getOrDefault("appId")
  valid_594801 = validateParameter(valid_594801, JString, required = true,
                                 default = nil)
  if valid_594801 != nil:
    section.add "appId", valid_594801
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

proc call*(call_594803: Call_FeaturesUpdatePhraseList_594796; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the phrases, the state and the name of the phraselist feature.
  ## 
  let valid = call_594803.validator(path, query, header, formData, body)
  let scheme = call_594803.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594803.url(scheme.get, call_594803.host, call_594803.base,
                         call_594803.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594803, url, valid)

proc call*(call_594804: Call_FeaturesUpdatePhraseList_594796; versionId: string;
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
  var path_594805 = newJObject()
  var body_594806 = newJObject()
  add(path_594805, "versionId", newJString(versionId))
  add(path_594805, "phraselistId", newJInt(phraselistId))
  add(path_594805, "appId", newJString(appId))
  if phraselistUpdateObject != nil:
    body_594806 = phraselistUpdateObject
  result = call_594804.call(path_594805, nil, nil, nil, body_594806)

var featuresUpdatePhraseList* = Call_FeaturesUpdatePhraseList_594796(
    name: "featuresUpdatePhraseList", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesUpdatePhraseList_594797, base: "/luis/api/v2.0",
    url: url_FeaturesUpdatePhraseList_594798, schemes: {Scheme.Https})
type
  Call_FeaturesGetPhraseList_594787 = ref object of OpenApiRestCall_593438
proc url_FeaturesGetPhraseList_594789(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesGetPhraseList_594788(path: JsonNode; query: JsonNode;
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
  var valid_594790 = path.getOrDefault("versionId")
  valid_594790 = validateParameter(valid_594790, JString, required = true,
                                 default = nil)
  if valid_594790 != nil:
    section.add "versionId", valid_594790
  var valid_594791 = path.getOrDefault("phraselistId")
  valid_594791 = validateParameter(valid_594791, JInt, required = true, default = nil)
  if valid_594791 != nil:
    section.add "phraselistId", valid_594791
  var valid_594792 = path.getOrDefault("appId")
  valid_594792 = validateParameter(valid_594792, JString, required = true,
                                 default = nil)
  if valid_594792 != nil:
    section.add "appId", valid_594792
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594793: Call_FeaturesGetPhraseList_594787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets phraselist feature info.
  ## 
  let valid = call_594793.validator(path, query, header, formData, body)
  let scheme = call_594793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594793.url(scheme.get, call_594793.host, call_594793.base,
                         call_594793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594793, url, valid)

proc call*(call_594794: Call_FeaturesGetPhraseList_594787; versionId: string;
          phraselistId: int; appId: string): Recallable =
  ## featuresGetPhraseList
  ## Gets phraselist feature info.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be retrieved.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594795 = newJObject()
  add(path_594795, "versionId", newJString(versionId))
  add(path_594795, "phraselistId", newJInt(phraselistId))
  add(path_594795, "appId", newJString(appId))
  result = call_594794.call(path_594795, nil, nil, nil, nil)

var featuresGetPhraseList* = Call_FeaturesGetPhraseList_594787(
    name: "featuresGetPhraseList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesGetPhraseList_594788, base: "/luis/api/v2.0",
    url: url_FeaturesGetPhraseList_594789, schemes: {Scheme.Https})
type
  Call_FeaturesDeletePhraseList_594807 = ref object of OpenApiRestCall_593438
proc url_FeaturesDeletePhraseList_594809(protocol: Scheme; host: string;
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

proc validate_FeaturesDeletePhraseList_594808(path: JsonNode; query: JsonNode;
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
  var valid_594810 = path.getOrDefault("versionId")
  valid_594810 = validateParameter(valid_594810, JString, required = true,
                                 default = nil)
  if valid_594810 != nil:
    section.add "versionId", valid_594810
  var valid_594811 = path.getOrDefault("phraselistId")
  valid_594811 = validateParameter(valid_594811, JInt, required = true, default = nil)
  if valid_594811 != nil:
    section.add "phraselistId", valid_594811
  var valid_594812 = path.getOrDefault("appId")
  valid_594812 = validateParameter(valid_594812, JString, required = true,
                                 default = nil)
  if valid_594812 != nil:
    section.add "appId", valid_594812
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594813: Call_FeaturesDeletePhraseList_594807; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a phraselist feature.
  ## 
  let valid = call_594813.validator(path, query, header, formData, body)
  let scheme = call_594813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594813.url(scheme.get, call_594813.host, call_594813.base,
                         call_594813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594813, url, valid)

proc call*(call_594814: Call_FeaturesDeletePhraseList_594807; versionId: string;
          phraselistId: int; appId: string): Recallable =
  ## featuresDeletePhraseList
  ## Deletes a phraselist feature.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be deleted.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594815 = newJObject()
  add(path_594815, "versionId", newJString(versionId))
  add(path_594815, "phraselistId", newJInt(phraselistId))
  add(path_594815, "appId", newJString(appId))
  result = call_594814.call(path_594815, nil, nil, nil, nil)

var featuresDeletePhraseList* = Call_FeaturesDeletePhraseList_594807(
    name: "featuresDeletePhraseList", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesDeletePhraseList_594808, base: "/luis/api/v2.0",
    url: url_FeaturesDeletePhraseList_594809, schemes: {Scheme.Https})
type
  Call_ModelAddPrebuilt_594827 = ref object of OpenApiRestCall_593438
proc url_ModelAddPrebuilt_594829(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddPrebuilt_594828(path: JsonNode; query: JsonNode;
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
  var valid_594830 = path.getOrDefault("versionId")
  valid_594830 = validateParameter(valid_594830, JString, required = true,
                                 default = nil)
  if valid_594830 != nil:
    section.add "versionId", valid_594830
  var valid_594831 = path.getOrDefault("appId")
  valid_594831 = validateParameter(valid_594831, JString, required = true,
                                 default = nil)
  if valid_594831 != nil:
    section.add "appId", valid_594831
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

proc call*(call_594833: Call_ModelAddPrebuilt_594827; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a list of prebuilt entity extractors to the application.
  ## 
  let valid = call_594833.validator(path, query, header, formData, body)
  let scheme = call_594833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594833.url(scheme.get, call_594833.host, call_594833.base,
                         call_594833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594833, url, valid)

proc call*(call_594834: Call_ModelAddPrebuilt_594827; versionId: string;
          appId: string; prebuiltExtractorNames: JsonNode): Recallable =
  ## modelAddPrebuilt
  ## Adds a list of prebuilt entity extractors to the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   prebuiltExtractorNames: JArray (required)
  ##                         : An array of prebuilt entity extractor names.
  var path_594835 = newJObject()
  var body_594836 = newJObject()
  add(path_594835, "versionId", newJString(versionId))
  add(path_594835, "appId", newJString(appId))
  if prebuiltExtractorNames != nil:
    body_594836 = prebuiltExtractorNames
  result = call_594834.call(path_594835, nil, nil, nil, body_594836)

var modelAddPrebuilt* = Call_ModelAddPrebuilt_594827(name: "modelAddPrebuilt",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts",
    validator: validate_ModelAddPrebuilt_594828, base: "/luis/api/v2.0",
    url: url_ModelAddPrebuilt_594829, schemes: {Scheme.Https})
type
  Call_ModelListPrebuilts_594816 = ref object of OpenApiRestCall_593438
proc url_ModelListPrebuilts_594818(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListPrebuilts_594817(path: JsonNode; query: JsonNode;
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
  var valid_594819 = path.getOrDefault("versionId")
  valid_594819 = validateParameter(valid_594819, JString, required = true,
                                 default = nil)
  if valid_594819 != nil:
    section.add "versionId", valid_594819
  var valid_594820 = path.getOrDefault("appId")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "appId", valid_594820
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594821 = query.getOrDefault("skip")
  valid_594821 = validateParameter(valid_594821, JInt, required = false,
                                 default = newJInt(0))
  if valid_594821 != nil:
    section.add "skip", valid_594821
  var valid_594822 = query.getOrDefault("take")
  valid_594822 = validateParameter(valid_594822, JInt, required = false,
                                 default = newJInt(100))
  if valid_594822 != nil:
    section.add "take", valid_594822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594823: Call_ModelListPrebuilts_594816; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the prebuilt entity models.
  ## 
  let valid = call_594823.validator(path, query, header, formData, body)
  let scheme = call_594823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594823.url(scheme.get, call_594823.host, call_594823.base,
                         call_594823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594823, url, valid)

proc call*(call_594824: Call_ModelListPrebuilts_594816; versionId: string;
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
  var path_594825 = newJObject()
  var query_594826 = newJObject()
  add(path_594825, "versionId", newJString(versionId))
  add(query_594826, "skip", newJInt(skip))
  add(query_594826, "take", newJInt(take))
  add(path_594825, "appId", newJString(appId))
  result = call_594824.call(path_594825, query_594826, nil, nil, nil)

var modelListPrebuilts* = Call_ModelListPrebuilts_594816(
    name: "modelListPrebuilts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts",
    validator: validate_ModelListPrebuilts_594817, base: "/luis/api/v2.0",
    url: url_ModelListPrebuilts_594818, schemes: {Scheme.Https})
type
  Call_ModelGetPrebuilt_594837 = ref object of OpenApiRestCall_593438
proc url_ModelGetPrebuilt_594839(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetPrebuilt_594838(path: JsonNode; query: JsonNode;
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
  var valid_594840 = path.getOrDefault("versionId")
  valid_594840 = validateParameter(valid_594840, JString, required = true,
                                 default = nil)
  if valid_594840 != nil:
    section.add "versionId", valid_594840
  var valid_594841 = path.getOrDefault("prebuiltId")
  valid_594841 = validateParameter(valid_594841, JString, required = true,
                                 default = nil)
  if valid_594841 != nil:
    section.add "prebuiltId", valid_594841
  var valid_594842 = path.getOrDefault("appId")
  valid_594842 = validateParameter(valid_594842, JString, required = true,
                                 default = nil)
  if valid_594842 != nil:
    section.add "appId", valid_594842
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594843: Call_ModelGetPrebuilt_594837; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the prebuilt entity model.
  ## 
  let valid = call_594843.validator(path, query, header, formData, body)
  let scheme = call_594843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594843.url(scheme.get, call_594843.host, call_594843.base,
                         call_594843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594843, url, valid)

proc call*(call_594844: Call_ModelGetPrebuilt_594837; versionId: string;
          prebuiltId: string; appId: string): Recallable =
  ## modelGetPrebuilt
  ## Gets information about the prebuilt entity model.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   prebuiltId: string (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594845 = newJObject()
  add(path_594845, "versionId", newJString(versionId))
  add(path_594845, "prebuiltId", newJString(prebuiltId))
  add(path_594845, "appId", newJString(appId))
  result = call_594844.call(path_594845, nil, nil, nil, nil)

var modelGetPrebuilt* = Call_ModelGetPrebuilt_594837(name: "modelGetPrebuilt",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{prebuiltId}",
    validator: validate_ModelGetPrebuilt_594838, base: "/luis/api/v2.0",
    url: url_ModelGetPrebuilt_594839, schemes: {Scheme.Https})
type
  Call_ModelDeletePrebuilt_594846 = ref object of OpenApiRestCall_593438
proc url_ModelDeletePrebuilt_594848(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeletePrebuilt_594847(path: JsonNode; query: JsonNode;
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
  var valid_594849 = path.getOrDefault("versionId")
  valid_594849 = validateParameter(valid_594849, JString, required = true,
                                 default = nil)
  if valid_594849 != nil:
    section.add "versionId", valid_594849
  var valid_594850 = path.getOrDefault("prebuiltId")
  valid_594850 = validateParameter(valid_594850, JString, required = true,
                                 default = nil)
  if valid_594850 != nil:
    section.add "prebuiltId", valid_594850
  var valid_594851 = path.getOrDefault("appId")
  valid_594851 = validateParameter(valid_594851, JString, required = true,
                                 default = nil)
  if valid_594851 != nil:
    section.add "appId", valid_594851
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594852: Call_ModelDeletePrebuilt_594846; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a prebuilt entity extractor from the application.
  ## 
  let valid = call_594852.validator(path, query, header, formData, body)
  let scheme = call_594852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594852.url(scheme.get, call_594852.host, call_594852.base,
                         call_594852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594852, url, valid)

proc call*(call_594853: Call_ModelDeletePrebuilt_594846; versionId: string;
          prebuiltId: string; appId: string): Recallable =
  ## modelDeletePrebuilt
  ## Deletes a prebuilt entity extractor from the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   prebuiltId: string (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594854 = newJObject()
  add(path_594854, "versionId", newJString(versionId))
  add(path_594854, "prebuiltId", newJString(prebuiltId))
  add(path_594854, "appId", newJString(appId))
  result = call_594853.call(path_594854, nil, nil, nil, nil)

var modelDeletePrebuilt* = Call_ModelDeletePrebuilt_594846(
    name: "modelDeletePrebuilt", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{prebuiltId}",
    validator: validate_ModelDeletePrebuilt_594847, base: "/luis/api/v2.0",
    url: url_ModelDeletePrebuilt_594848, schemes: {Scheme.Https})
type
  Call_VersionsDeleteUnlabelledUtterance_594855 = ref object of OpenApiRestCall_593438
proc url_VersionsDeleteUnlabelledUtterance_594857(protocol: Scheme; host: string;
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

proc validate_VersionsDeleteUnlabelledUtterance_594856(path: JsonNode;
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
  var valid_594858 = path.getOrDefault("versionId")
  valid_594858 = validateParameter(valid_594858, JString, required = true,
                                 default = nil)
  if valid_594858 != nil:
    section.add "versionId", valid_594858
  var valid_594859 = path.getOrDefault("appId")
  valid_594859 = validateParameter(valid_594859, JString, required = true,
                                 default = nil)
  if valid_594859 != nil:
    section.add "appId", valid_594859
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

proc call*(call_594861: Call_VersionsDeleteUnlabelledUtterance_594855;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deleted an unlabelled utterance.
  ## 
  let valid = call_594861.validator(path, query, header, formData, body)
  let scheme = call_594861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594861.url(scheme.get, call_594861.host, call_594861.base,
                         call_594861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594861, url, valid)

proc call*(call_594862: Call_VersionsDeleteUnlabelledUtterance_594855;
          versionId: string; appId: string; utterance: JsonNode): Recallable =
  ## versionsDeleteUnlabelledUtterance
  ## Deleted an unlabelled utterance.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   utterance: JString (required)
  ##            : The utterance text to delete.
  var path_594863 = newJObject()
  var body_594864 = newJObject()
  add(path_594863, "versionId", newJString(versionId))
  add(path_594863, "appId", newJString(appId))
  if utterance != nil:
    body_594864 = utterance
  result = call_594862.call(path_594863, nil, nil, nil, body_594864)

var versionsDeleteUnlabelledUtterance* = Call_VersionsDeleteUnlabelledUtterance_594855(
    name: "versionsDeleteUnlabelledUtterance", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/suggest",
    validator: validate_VersionsDeleteUnlabelledUtterance_594856,
    base: "/luis/api/v2.0", url: url_VersionsDeleteUnlabelledUtterance_594857,
    schemes: {Scheme.Https})
type
  Call_TrainTrainVersion_594873 = ref object of OpenApiRestCall_593438
proc url_TrainTrainVersion_594875(protocol: Scheme; host: string; base: string;
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

proc validate_TrainTrainVersion_594874(path: JsonNode; query: JsonNode;
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
  var valid_594876 = path.getOrDefault("versionId")
  valid_594876 = validateParameter(valid_594876, JString, required = true,
                                 default = nil)
  if valid_594876 != nil:
    section.add "versionId", valid_594876
  var valid_594877 = path.getOrDefault("appId")
  valid_594877 = validateParameter(valid_594877, JString, required = true,
                                 default = nil)
  if valid_594877 != nil:
    section.add "appId", valid_594877
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594878: Call_TrainTrainVersion_594873; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ## 
  let valid = call_594878.validator(path, query, header, formData, body)
  let scheme = call_594878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594878.url(scheme.get, call_594878.host, call_594878.base,
                         call_594878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594878, url, valid)

proc call*(call_594879: Call_TrainTrainVersion_594873; versionId: string;
          appId: string): Recallable =
  ## trainTrainVersion
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594880 = newJObject()
  add(path_594880, "versionId", newJString(versionId))
  add(path_594880, "appId", newJString(appId))
  result = call_594879.call(path_594880, nil, nil, nil, nil)

var trainTrainVersion* = Call_TrainTrainVersion_594873(name: "trainTrainVersion",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/train",
    validator: validate_TrainTrainVersion_594874, base: "/luis/api/v2.0",
    url: url_TrainTrainVersion_594875, schemes: {Scheme.Https})
type
  Call_TrainGetStatus_594865 = ref object of OpenApiRestCall_593438
proc url_TrainGetStatus_594867(protocol: Scheme; host: string; base: string;
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

proc validate_TrainGetStatus_594866(path: JsonNode; query: JsonNode;
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
  var valid_594868 = path.getOrDefault("versionId")
  valid_594868 = validateParameter(valid_594868, JString, required = true,
                                 default = nil)
  if valid_594868 != nil:
    section.add "versionId", valid_594868
  var valid_594869 = path.getOrDefault("appId")
  valid_594869 = validateParameter(valid_594869, JString, required = true,
                                 default = nil)
  if valid_594869 != nil:
    section.add "appId", valid_594869
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594870: Call_TrainGetStatus_594865; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ## 
  let valid = call_594870.validator(path, query, header, formData, body)
  let scheme = call_594870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594870.url(scheme.get, call_594870.host, call_594870.base,
                         call_594870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594870, url, valid)

proc call*(call_594871: Call_TrainGetStatus_594865; versionId: string; appId: string): Recallable =
  ## trainGetStatus
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594872 = newJObject()
  add(path_594872, "versionId", newJString(versionId))
  add(path_594872, "appId", newJString(appId))
  result = call_594871.call(path_594872, nil, nil, nil, nil)

var trainGetStatus* = Call_TrainGetStatus_594865(name: "trainGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/train",
    validator: validate_TrainGetStatus_594866, base: "/luis/api/v2.0",
    url: url_TrainGetStatus_594867, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
