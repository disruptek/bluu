
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ADHybridHealthService
## version: 2014-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## REST APIs for Azure Active Directory Connect Health
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
  macServiceName = "adhybridhealthservice-ADHybridHealthService"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AddsServicesAdd_593961 = ref object of OpenApiRestCall_593438
proc url_AddsServicesAdd_593963(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AddsServicesAdd_593962(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Onboards a service for a given tenant in Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593964 = query.getOrDefault("api-version")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "api-version", valid_593964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   service: JObject (required)
  ##          : The service object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_AddsServicesAdd_593961; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Onboards a service for a given tenant in Azure Active Directory Connect Health.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_AddsServicesAdd_593961; apiVersion: string;
          service: JsonNode): Recallable =
  ## addsServicesAdd
  ## Onboards a service for a given tenant in Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   service: JObject (required)
  ##          : The service object.
  var query_593968 = newJObject()
  var body_593969 = newJObject()
  add(query_593968, "api-version", newJString(apiVersion))
  if service != nil:
    body_593969 = service
  result = call_593967.call(nil, query_593968, nil, nil, body_593969)

var addsServicesAdd* = Call_AddsServicesAdd_593961(name: "addsServicesAdd",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/addsservices",
    validator: validate_AddsServicesAdd_593962, base: "", url: url_AddsServicesAdd_593963,
    schemes: {Scheme.Https})
type
  Call_AddsServicesList_593660 = ref object of OpenApiRestCall_593438
proc url_AddsServicesList_593662(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AddsServicesList_593661(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the details of Active Directory Domain Service, for a tenant, that are onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   serviceType: JString
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   skipCount: JInt
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   takeCount: JInt
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  ##   $filter: JString
  ##          : The service property filter to apply.
  section = newJObject()
  var valid_593822 = query.getOrDefault("serviceType")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "serviceType", valid_593822
  var valid_593823 = query.getOrDefault("skipCount")
  valid_593823 = validateParameter(valid_593823, JInt, required = false, default = nil)
  if valid_593823 != nil:
    section.add "skipCount", valid_593823
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "api-version", valid_593824
  var valid_593825 = query.getOrDefault("takeCount")
  valid_593825 = validateParameter(valid_593825, JInt, required = false, default = nil)
  if valid_593825 != nil:
    section.add "takeCount", valid_593825
  var valid_593826 = query.getOrDefault("$filter")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "$filter", valid_593826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593849: Call_AddsServicesList_593660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of Active Directory Domain Service, for a tenant, that are onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_593849.validator(path, query, header, formData, body)
  let scheme = call_593849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593849.url(scheme.get, call_593849.host, call_593849.base,
                         call_593849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593849, url, valid)

proc call*(call_593920: Call_AddsServicesList_593660; apiVersion: string;
          serviceType: string = ""; skipCount: int = 0; takeCount: int = 0;
          Filter: string = ""): Recallable =
  ## addsServicesList
  ## Gets the details of Active Directory Domain Service, for a tenant, that are onboarded to Azure Active Directory Connect Health.
  ##   serviceType: string
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   skipCount: int
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   takeCount: int
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  ##   Filter: string
  ##         : The service property filter to apply.
  var query_593921 = newJObject()
  add(query_593921, "serviceType", newJString(serviceType))
  add(query_593921, "skipCount", newJInt(skipCount))
  add(query_593921, "api-version", newJString(apiVersion))
  add(query_593921, "takeCount", newJInt(takeCount))
  add(query_593921, "$filter", newJString(Filter))
  result = call_593920.call(nil, query_593921, nil, nil, nil)

var addsServicesList* = Call_AddsServicesList_593660(name: "addsServicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/addsservices",
    validator: validate_AddsServicesList_593661, base: "",
    url: url_AddsServicesList_593662, schemes: {Scheme.Https})
type
  Call_AddsServicesListPremiumServices_593970 = ref object of OpenApiRestCall_593438
proc url_AddsServicesListPremiumServices_593972(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AddsServicesListPremiumServices_593971(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of Active Directory Domain Services for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   serviceType: JString
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   skipCount: JInt
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   takeCount: JInt
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  ##   $filter: JString
  ##          : The service property filter to apply.
  section = newJObject()
  var valid_593973 = query.getOrDefault("serviceType")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "serviceType", valid_593973
  var valid_593974 = query.getOrDefault("skipCount")
  valid_593974 = validateParameter(valid_593974, JInt, required = false, default = nil)
  if valid_593974 != nil:
    section.add "skipCount", valid_593974
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  var valid_593976 = query.getOrDefault("takeCount")
  valid_593976 = validateParameter(valid_593976, JInt, required = false, default = nil)
  if valid_593976 != nil:
    section.add "takeCount", valid_593976
  var valid_593977 = query.getOrDefault("$filter")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "$filter", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_AddsServicesListPremiumServices_593970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of Active Directory Domain Services for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_AddsServicesListPremiumServices_593970;
          apiVersion: string; serviceType: string = ""; skipCount: int = 0;
          takeCount: int = 0; Filter: string = ""): Recallable =
  ## addsServicesListPremiumServices
  ## Gets the details of Active Directory Domain Services for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ##   serviceType: string
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   skipCount: int
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   takeCount: int
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  ##   Filter: string
  ##         : The service property filter to apply.
  var query_593980 = newJObject()
  add(query_593980, "serviceType", newJString(serviceType))
  add(query_593980, "skipCount", newJInt(skipCount))
  add(query_593980, "api-version", newJString(apiVersion))
  add(query_593980, "takeCount", newJInt(takeCount))
  add(query_593980, "$filter", newJString(Filter))
  result = call_593979.call(nil, query_593980, nil, nil, nil)

var addsServicesListPremiumServices* = Call_AddsServicesListPremiumServices_593970(
    name: "addsServicesListPremiumServices", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/premiumCheck",
    validator: validate_AddsServicesListPremiumServices_593971, base: "",
    url: url_AddsServicesListPremiumServices_593972, schemes: {Scheme.Https})
type
  Call_AddsServicesGet_593981 = ref object of OpenApiRestCall_593438
proc url_AddsServicesGet_593983(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesGet_593982(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the details of an Active Directory Domain Service for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_593998 = path.getOrDefault("serviceName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "serviceName", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_AddsServicesGet_593981; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an Active Directory Domain Service for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_AddsServicesGet_593981; apiVersion: string;
          serviceName: string): Recallable =
  ## addsServicesGet
  ## Gets the details of an Active Directory Domain Service for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "serviceName", newJString(serviceName))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var addsServicesGet* = Call_AddsServicesGet_593981(name: "addsServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}",
    validator: validate_AddsServicesGet_593982, base: "", url: url_AddsServicesGet_593983,
    schemes: {Scheme.Https})
type
  Call_AddsServicesUpdate_594014 = ref object of OpenApiRestCall_593438
proc url_AddsServicesUpdate_594016(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesUpdate_594015(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates an Active Directory Domain Service properties of an onboarded service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service which needs to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594017 = path.getOrDefault("serviceName")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "serviceName", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594018 = query.getOrDefault("api-version")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "api-version", valid_594018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   service: JObject (required)
  ##          : The service object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_AddsServicesUpdate_594014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an Active Directory Domain Service properties of an onboarded service.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_AddsServicesUpdate_594014; apiVersion: string;
          service: JsonNode; serviceName: string): Recallable =
  ## addsServicesUpdate
  ## Updates an Active Directory Domain Service properties of an onboarded service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   service: JObject (required)
  ##          : The service object.
  ##   serviceName: string (required)
  ##              : The name of the service which needs to be deleted.
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  var body_594024 = newJObject()
  add(query_594023, "api-version", newJString(apiVersion))
  if service != nil:
    body_594024 = service
  add(path_594022, "serviceName", newJString(serviceName))
  result = call_594021.call(path_594022, query_594023, nil, nil, body_594024)

var addsServicesUpdate* = Call_AddsServicesUpdate_594014(
    name: "addsServicesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}",
    validator: validate_AddsServicesUpdate_594015, base: "",
    url: url_AddsServicesUpdate_594016, schemes: {Scheme.Https})
type
  Call_AddsServicesDelete_594004 = ref object of OpenApiRestCall_593438
proc url_AddsServicesDelete_594006(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesDelete_594005(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes an Active Directory Domain Service which is onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service which needs to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594007 = path.getOrDefault("serviceName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "serviceName", valid_594007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   confirm: JBool
  ##          : Indicates if the service will be permanently deleted or disabled. True indicates that the service will be permanently deleted and False indicates that the service will be marked disabled and then deleted after 30 days, if it is not re-registered.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594008 = query.getOrDefault("api-version")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "api-version", valid_594008
  var valid_594009 = query.getOrDefault("confirm")
  valid_594009 = validateParameter(valid_594009, JBool, required = false, default = nil)
  if valid_594009 != nil:
    section.add "confirm", valid_594009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594010: Call_AddsServicesDelete_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Active Directory Domain Service which is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_AddsServicesDelete_594004; apiVersion: string;
          serviceName: string; confirm: bool = false): Recallable =
  ## addsServicesDelete
  ## Deletes an Active Directory Domain Service which is onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   confirm: bool
  ##          : Indicates if the service will be permanently deleted or disabled. True indicates that the service will be permanently deleted and False indicates that the service will be marked disabled and then deleted after 30 days, if it is not re-registered.
  ##   serviceName: string (required)
  ##              : The name of the service which needs to be deleted.
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  add(query_594013, "api-version", newJString(apiVersion))
  add(query_594013, "confirm", newJBool(confirm))
  add(path_594012, "serviceName", newJString(serviceName))
  result = call_594011.call(path_594012, query_594013, nil, nil, nil)

var addsServicesDelete* = Call_AddsServicesDelete_594004(
    name: "addsServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}",
    validator: validate_AddsServicesDelete_594005, base: "",
    url: url_AddsServicesDelete_594006, schemes: {Scheme.Https})
type
  Call_AdDomainServiceMembersList_594025 = ref object of OpenApiRestCall_593438
proc url_AdDomainServiceMembersList_594027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/addomainservicemembers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdDomainServiceMembersList_594026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the servers, for a given Active Directory Domain Service, that are onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594028 = path.getOrDefault("serviceName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "serviceName", valid_594028
  result.add "path", section
  ## parameters in `query` object:
  ##   nextPartitionKey: JString (required)
  ##                   : The next partition key to query for.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   query: JString
  ##        : The custom query.
  ##   nextRowKey: JString (required)
  ##             : The next row key to query for.
  ##   takeCount: JInt
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  ##   isGroupbySite: JBool (required)
  ##                : Indicates if the result should be grouped by site or not.
  ##   $filter: JString
  ##          : The server property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `nextPartitionKey` field"
  var valid_594042 = query.getOrDefault("nextPartitionKey")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = newJString(" "))
  if valid_594042 != nil:
    section.add "nextPartitionKey", valid_594042
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  var valid_594044 = query.getOrDefault("query")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "query", valid_594044
  var valid_594045 = query.getOrDefault("nextRowKey")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = newJString(" "))
  if valid_594045 != nil:
    section.add "nextRowKey", valid_594045
  var valid_594046 = query.getOrDefault("takeCount")
  valid_594046 = validateParameter(valid_594046, JInt, required = false, default = nil)
  if valid_594046 != nil:
    section.add "takeCount", valid_594046
  var valid_594047 = query.getOrDefault("isGroupbySite")
  valid_594047 = validateParameter(valid_594047, JBool, required = true, default = nil)
  if valid_594047 != nil:
    section.add "isGroupbySite", valid_594047
  var valid_594048 = query.getOrDefault("$filter")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "$filter", valid_594048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_AdDomainServiceMembersList_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the servers, for a given Active Directory Domain Service, that are onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_AdDomainServiceMembersList_594025; apiVersion: string;
          isGroupbySite: bool; serviceName: string; nextPartitionKey: string = " ";
          query: string = ""; nextRowKey: string = " "; takeCount: int = 0;
          Filter: string = ""): Recallable =
  ## adDomainServiceMembersList
  ## Gets the details of the servers, for a given Active Directory Domain Service, that are onboarded to Azure Active Directory Connect Health.
  ##   nextPartitionKey: string (required)
  ##                   : The next partition key to query for.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   query: string
  ##        : The custom query.
  ##   nextRowKey: string (required)
  ##             : The next row key to query for.
  ##   takeCount: int
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  ##   isGroupbySite: bool (required)
  ##                : Indicates if the result should be grouped by site or not.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The server property filter to apply.
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  add(query_594052, "nextPartitionKey", newJString(nextPartitionKey))
  add(query_594052, "api-version", newJString(apiVersion))
  add(query_594052, "query", newJString(query))
  add(query_594052, "nextRowKey", newJString(nextRowKey))
  add(query_594052, "takeCount", newJInt(takeCount))
  add(query_594052, "isGroupbySite", newJBool(isGroupbySite))
  add(path_594051, "serviceName", newJString(serviceName))
  add(query_594052, "$filter", newJString(Filter))
  result = call_594050.call(path_594051, query_594052, nil, nil, nil)

var adDomainServiceMembersList* = Call_AdDomainServiceMembersList_594025(
    name: "adDomainServiceMembersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/addomainservicemembers",
    validator: validate_AdDomainServiceMembersList_594026, base: "",
    url: url_AdDomainServiceMembersList_594027, schemes: {Scheme.Https})
type
  Call_AddsServiceMembersList_594053 = ref object of OpenApiRestCall_593438
proc url_AddsServiceMembersList_594055(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/addsservicemembers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServiceMembersList_594054(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the Active Directory Domain servers, for a given Active Directory Domain Service, that are onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594056 = path.getOrDefault("serviceName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "serviceName", valid_594056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $filter: JString
  ##          : The server property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594057 = query.getOrDefault("api-version")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "api-version", valid_594057
  var valid_594058 = query.getOrDefault("$filter")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "$filter", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_AddsServiceMembersList_594053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Active Directory Domain servers, for a given Active Directory Domain Service, that are onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_AddsServiceMembersList_594053; apiVersion: string;
          serviceName: string; Filter: string = ""): Recallable =
  ## addsServiceMembersList
  ## Gets the details of the Active Directory Domain servers, for a given Active Directory Domain Service, that are onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The server property filter to apply.
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  add(query_594062, "api-version", newJString(apiVersion))
  add(path_594061, "serviceName", newJString(serviceName))
  add(query_594062, "$filter", newJString(Filter))
  result = call_594060.call(path_594061, query_594062, nil, nil, nil)

var addsServiceMembersList* = Call_AddsServiceMembersList_594053(
    name: "addsServiceMembersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/addsservicemembers",
    validator: validate_AddsServiceMembersList_594054, base: "",
    url: url_AddsServiceMembersList_594055, schemes: {Scheme.Https})
type
  Call_AlertsListAddsAlerts_594063 = ref object of OpenApiRestCall_593438
proc url_AlertsListAddsAlerts_594065(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListAddsAlerts_594064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alerts for a given Active Directory Domain Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594066 = path.getOrDefault("serviceName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "serviceName", valid_594066
  result.add "path", section
  ## parameters in `query` object:
  ##   to: JString
  ##     : The end date till when to query for.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   from: JString
  ##       : The start date to query for.
  ##   $filter: JString
  ##          : The alert property filter to apply.
  ##   state: JString
  ##        : The alert state to query for.
  section = newJObject()
  var valid_594067 = query.getOrDefault("to")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "to", valid_594067
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594068 = query.getOrDefault("api-version")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "api-version", valid_594068
  var valid_594069 = query.getOrDefault("from")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "from", valid_594069
  var valid_594070 = query.getOrDefault("$filter")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "$filter", valid_594070
  var valid_594071 = query.getOrDefault("state")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "state", valid_594071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594072: Call_AlertsListAddsAlerts_594063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alerts for a given Active Directory Domain Service.
  ## 
  let valid = call_594072.validator(path, query, header, formData, body)
  let scheme = call_594072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594072.url(scheme.get, call_594072.host, call_594072.base,
                         call_594072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594072, url, valid)

proc call*(call_594073: Call_AlertsListAddsAlerts_594063; apiVersion: string;
          serviceName: string; to: string = ""; `from`: string = ""; Filter: string = "";
          state: string = ""): Recallable =
  ## alertsListAddsAlerts
  ## Gets the alerts for a given Active Directory Domain Service.
  ##   to: string
  ##     : The end date till when to query for.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   from: string
  ##       : The start date to query for.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The alert property filter to apply.
  ##   state: string
  ##        : The alert state to query for.
  var path_594074 = newJObject()
  var query_594075 = newJObject()
  add(query_594075, "to", newJString(to))
  add(query_594075, "api-version", newJString(apiVersion))
  add(query_594075, "from", newJString(`from`))
  add(path_594074, "serviceName", newJString(serviceName))
  add(query_594075, "$filter", newJString(Filter))
  add(query_594075, "state", newJString(state))
  result = call_594073.call(path_594074, query_594075, nil, nil, nil)

var alertsListAddsAlerts* = Call_AlertsListAddsAlerts_594063(
    name: "alertsListAddsAlerts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/alerts",
    validator: validate_AlertsListAddsAlerts_594064, base: "",
    url: url_AlertsListAddsAlerts_594065, schemes: {Scheme.Https})
type
  Call_ConfigurationListAddsConfigurations_594076 = ref object of OpenApiRestCall_593438
proc url_ConfigurationListAddsConfigurations_594078(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/configuration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationListAddsConfigurations_594077(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594079 = path.getOrDefault("serviceName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "serviceName", valid_594079
  result.add "path", section
  ## parameters in `query` object:
  ##   grouping: JString
  ##           : The grouping for configurations.
  section = newJObject()
  var valid_594080 = query.getOrDefault("grouping")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "grouping", valid_594080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_ConfigurationListAddsConfigurations_594076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the service configurations.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_ConfigurationListAddsConfigurations_594076;
          serviceName: string; grouping: string = ""): Recallable =
  ## configurationListAddsConfigurations
  ## Gets the service configurations.
  ##   grouping: string
  ##           : The grouping for configurations.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  add(query_594084, "grouping", newJString(grouping))
  add(path_594083, "serviceName", newJString(serviceName))
  result = call_594082.call(path_594083, query_594084, nil, nil, nil)

var configurationListAddsConfigurations* = Call_ConfigurationListAddsConfigurations_594076(
    name: "configurationListAddsConfigurations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/configuration",
    validator: validate_ConfigurationListAddsConfigurations_594077, base: "",
    url: url_ConfigurationListAddsConfigurations_594078, schemes: {Scheme.Https})
type
  Call_DimensionsListAddsDimensions_594085 = ref object of OpenApiRestCall_593438
proc url_DimensionsListAddsDimensions_594087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "dimension" in path, "`dimension` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/dimensions/"),
               (kind: VariableSegment, value: "dimension")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DimensionsListAddsDimensions_594086(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the dimensions for a given dimension type in a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dimension: JString (required)
  ##            : The dimension type.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `dimension` field"
  var valid_594088 = path.getOrDefault("dimension")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "dimension", valid_594088
  var valid_594089 = path.getOrDefault("serviceName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "serviceName", valid_594089
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594090 = query.getOrDefault("api-version")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "api-version", valid_594090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594091: Call_DimensionsListAddsDimensions_594085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the dimensions for a given dimension type in a server.
  ## 
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_DimensionsListAddsDimensions_594085;
          apiVersion: string; dimension: string; serviceName: string): Recallable =
  ## dimensionsListAddsDimensions
  ## Gets the dimensions for a given dimension type in a server.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   dimension: string (required)
  ##            : The dimension type.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594093 = newJObject()
  var query_594094 = newJObject()
  add(query_594094, "api-version", newJString(apiVersion))
  add(path_594093, "dimension", newJString(dimension))
  add(path_594093, "serviceName", newJString(serviceName))
  result = call_594092.call(path_594093, query_594094, nil, nil, nil)

var dimensionsListAddsDimensions* = Call_DimensionsListAddsDimensions_594085(
    name: "dimensionsListAddsDimensions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/dimensions/{dimension}",
    validator: validate_DimensionsListAddsDimensions_594086, base: "",
    url: url_DimensionsListAddsDimensions_594087, schemes: {Scheme.Https})
type
  Call_AddsServicesUserPreferenceAdd_594105 = ref object of OpenApiRestCall_593438
proc url_AddsServicesUserPreferenceAdd_594107(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "featureName" in path, "`featureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/features/"),
               (kind: VariableSegment, value: "featureName"),
               (kind: ConstantSegment, value: "/userpreference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesUserPreferenceAdd_594106(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds the user preferences for a given feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   featureName: JString (required)
  ##              : The name of the feature.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `featureName` field"
  var valid_594108 = path.getOrDefault("featureName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "featureName", valid_594108
  var valid_594109 = path.getOrDefault("serviceName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "serviceName", valid_594109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594110 = query.getOrDefault("api-version")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "api-version", valid_594110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   setting: JObject (required)
  ##          : The user preference setting.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594112: Call_AddsServicesUserPreferenceAdd_594105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds the user preferences for a given feature.
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_AddsServicesUserPreferenceAdd_594105;
          apiVersion: string; setting: JsonNode; featureName: string;
          serviceName: string): Recallable =
  ## addsServicesUserPreferenceAdd
  ## Adds the user preferences for a given feature.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   setting: JObject (required)
  ##          : The user preference setting.
  ##   featureName: string (required)
  ##              : The name of the feature.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  var body_594116 = newJObject()
  add(query_594115, "api-version", newJString(apiVersion))
  if setting != nil:
    body_594116 = setting
  add(path_594114, "featureName", newJString(featureName))
  add(path_594114, "serviceName", newJString(serviceName))
  result = call_594113.call(path_594114, query_594115, nil, nil, body_594116)

var addsServicesUserPreferenceAdd* = Call_AddsServicesUserPreferenceAdd_594105(
    name: "addsServicesUserPreferenceAdd", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/features/{featureName}/userpreference",
    validator: validate_AddsServicesUserPreferenceAdd_594106, base: "",
    url: url_AddsServicesUserPreferenceAdd_594107, schemes: {Scheme.Https})
type
  Call_AddsServicesUserPreferenceGet_594095 = ref object of OpenApiRestCall_593438
proc url_AddsServicesUserPreferenceGet_594097(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "featureName" in path, "`featureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/features/"),
               (kind: VariableSegment, value: "featureName"),
               (kind: ConstantSegment, value: "/userpreference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesUserPreferenceGet_594096(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the user preferences for a given feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   featureName: JString (required)
  ##              : The name of the feature.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `featureName` field"
  var valid_594098 = path.getOrDefault("featureName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "featureName", valid_594098
  var valid_594099 = path.getOrDefault("serviceName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "serviceName", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_AddsServicesUserPreferenceGet_594095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the user preferences for a given feature.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_AddsServicesUserPreferenceGet_594095;
          apiVersion: string; featureName: string; serviceName: string): Recallable =
  ## addsServicesUserPreferenceGet
  ## Gets the user preferences for a given feature.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   featureName: string (required)
  ##              : The name of the feature.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "featureName", newJString(featureName))
  add(path_594103, "serviceName", newJString(serviceName))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var addsServicesUserPreferenceGet* = Call_AddsServicesUserPreferenceGet_594095(
    name: "addsServicesUserPreferenceGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/features/{featureName}/userpreference",
    validator: validate_AddsServicesUserPreferenceGet_594096, base: "",
    url: url_AddsServicesUserPreferenceGet_594097, schemes: {Scheme.Https})
type
  Call_AddsServicesUserPreferenceDelete_594117 = ref object of OpenApiRestCall_593438
proc url_AddsServicesUserPreferenceDelete_594119(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "featureName" in path, "`featureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/features/"),
               (kind: VariableSegment, value: "featureName"),
               (kind: ConstantSegment, value: "/userpreference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesUserPreferenceDelete_594118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the user preferences for a given feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   featureName: JString (required)
  ##              : The name of the feature.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `featureName` field"
  var valid_594120 = path.getOrDefault("featureName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "featureName", valid_594120
  var valid_594121 = path.getOrDefault("serviceName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "serviceName", valid_594121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594122 = query.getOrDefault("api-version")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "api-version", valid_594122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594123: Call_AddsServicesUserPreferenceDelete_594117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the user preferences for a given feature.
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_AddsServicesUserPreferenceDelete_594117;
          apiVersion: string; featureName: string; serviceName: string): Recallable =
  ## addsServicesUserPreferenceDelete
  ## Deletes the user preferences for a given feature.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   featureName: string (required)
  ##              : The name of the feature.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594125 = newJObject()
  var query_594126 = newJObject()
  add(query_594126, "api-version", newJString(apiVersion))
  add(path_594125, "featureName", newJString(featureName))
  add(path_594125, "serviceName", newJString(serviceName))
  result = call_594124.call(path_594125, query_594126, nil, nil, nil)

var addsServicesUserPreferenceDelete* = Call_AddsServicesUserPreferenceDelete_594117(
    name: "addsServicesUserPreferenceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/features/{featureName}/userpreference",
    validator: validate_AddsServicesUserPreferenceDelete_594118, base: "",
    url: url_AddsServicesUserPreferenceDelete_594119, schemes: {Scheme.Https})
type
  Call_AddsServicesGetForestSummary_594127 = ref object of OpenApiRestCall_593438
proc url_AddsServicesGetForestSummary_594129(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/forestsummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesGetForestSummary_594128(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the forest summary for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594130 = path.getOrDefault("serviceName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "serviceName", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594131 = query.getOrDefault("api-version")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "api-version", valid_594131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594132: Call_AddsServicesGetForestSummary_594127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the forest summary for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594132.validator(path, query, header, formData, body)
  let scheme = call_594132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594132.url(scheme.get, call_594132.host, call_594132.base,
                         call_594132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594132, url, valid)

proc call*(call_594133: Call_AddsServicesGetForestSummary_594127;
          apiVersion: string; serviceName: string): Recallable =
  ## addsServicesGetForestSummary
  ## Gets the forest summary for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594134 = newJObject()
  var query_594135 = newJObject()
  add(query_594135, "api-version", newJString(apiVersion))
  add(path_594134, "serviceName", newJString(serviceName))
  result = call_594133.call(path_594134, query_594135, nil, nil, nil)

var addsServicesGetForestSummary* = Call_AddsServicesGetForestSummary_594127(
    name: "addsServicesGetForestSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/forestsummary",
    validator: validate_AddsServicesGetForestSummary_594128, base: "",
    url: url_AddsServicesGetForestSummary_594129, schemes: {Scheme.Https})
type
  Call_AddsServicesListMetricMetadata_594136 = ref object of OpenApiRestCall_593438
proc url_AddsServicesListMetricMetadata_594138(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/metricmetadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesListMetricMetadata_594137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service related metrics information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594139 = path.getOrDefault("serviceName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "serviceName", valid_594139
  result.add "path", section
  ## parameters in `query` object:
  ##   perfCounter: JBool
  ##              : Indicates if only performance counter metrics are requested.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $filter: JString
  ##          : The metric metadata property filter to apply.
  section = newJObject()
  var valid_594140 = query.getOrDefault("perfCounter")
  valid_594140 = validateParameter(valid_594140, JBool, required = false, default = nil)
  if valid_594140 != nil:
    section.add "perfCounter", valid_594140
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594141 = query.getOrDefault("api-version")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "api-version", valid_594141
  var valid_594142 = query.getOrDefault("$filter")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "$filter", valid_594142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594143: Call_AddsServicesListMetricMetadata_594136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the service related metrics information.
  ## 
  let valid = call_594143.validator(path, query, header, formData, body)
  let scheme = call_594143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594143.url(scheme.get, call_594143.host, call_594143.base,
                         call_594143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594143, url, valid)

proc call*(call_594144: Call_AddsServicesListMetricMetadata_594136;
          apiVersion: string; serviceName: string; perfCounter: bool = false;
          Filter: string = ""): Recallable =
  ## addsServicesListMetricMetadata
  ## Gets the service related metrics information.
  ##   perfCounter: bool
  ##              : Indicates if only performance counter metrics are requested.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The metric metadata property filter to apply.
  var path_594145 = newJObject()
  var query_594146 = newJObject()
  add(query_594146, "perfCounter", newJBool(perfCounter))
  add(query_594146, "api-version", newJString(apiVersion))
  add(path_594145, "serviceName", newJString(serviceName))
  add(query_594146, "$filter", newJString(Filter))
  result = call_594144.call(path_594145, query_594146, nil, nil, nil)

var addsServicesListMetricMetadata* = Call_AddsServicesListMetricMetadata_594136(
    name: "addsServicesListMetricMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/metricmetadata",
    validator: validate_AddsServicesListMetricMetadata_594137, base: "",
    url: url_AddsServicesListMetricMetadata_594138, schemes: {Scheme.Https})
type
  Call_AddsServicesGetMetricMetadata_594147 = ref object of OpenApiRestCall_593438
proc url_AddsServicesGetMetricMetadata_594149(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/metricmetadata/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesGetMetricMetadata_594148(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service related metric information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metricName: JString (required)
  ##             : The metric name
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `metricName` field"
  var valid_594150 = path.getOrDefault("metricName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "metricName", valid_594150
  var valid_594151 = path.getOrDefault("serviceName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "serviceName", valid_594151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594152 = query.getOrDefault("api-version")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "api-version", valid_594152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594153: Call_AddsServicesGetMetricMetadata_594147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the service related metric information.
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_AddsServicesGetMetricMetadata_594147;
          apiVersion: string; metricName: string; serviceName: string): Recallable =
  ## addsServicesGetMetricMetadata
  ## Gets the service related metric information.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   metricName: string (required)
  ##             : The metric name
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  add(query_594156, "api-version", newJString(apiVersion))
  add(path_594155, "metricName", newJString(metricName))
  add(path_594155, "serviceName", newJString(serviceName))
  result = call_594154.call(path_594155, query_594156, nil, nil, nil)

var addsServicesGetMetricMetadata* = Call_AddsServicesGetMetricMetadata_594147(
    name: "addsServicesGetMetricMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/metricmetadata/{metricName}",
    validator: validate_AddsServicesGetMetricMetadata_594148, base: "",
    url: url_AddsServicesGetMetricMetadata_594149, schemes: {Scheme.Https})
type
  Call_AddsServicesGetMetricMetadataForGroup_594157 = ref object of OpenApiRestCall_593438
proc url_AddsServicesGetMetricMetadataForGroup_594159(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/metricmetadata/"),
               (kind: VariableSegment, value: "metricName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesGetMetricMetadataForGroup_594158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service related metrics for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : The group name
  ##   metricName: JString (required)
  ##             : The metric name
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_594160 = path.getOrDefault("groupName")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "groupName", valid_594160
  var valid_594161 = path.getOrDefault("metricName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "metricName", valid_594161
  var valid_594162 = path.getOrDefault("serviceName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "serviceName", valid_594162
  result.add "path", section
  ## parameters in `query` object:
  ##   groupKey: JString
  ##           : The group key
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   fromDate: JString
  ##           : The start date.
  ##   toDate: JString
  ##         : The end date.
  section = newJObject()
  var valid_594163 = query.getOrDefault("groupKey")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "groupKey", valid_594163
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594164 = query.getOrDefault("api-version")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "api-version", valid_594164
  var valid_594165 = query.getOrDefault("fromDate")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "fromDate", valid_594165
  var valid_594166 = query.getOrDefault("toDate")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "toDate", valid_594166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594167: Call_AddsServicesGetMetricMetadataForGroup_594157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the service related metrics for a given metric and group combination.
  ## 
  let valid = call_594167.validator(path, query, header, formData, body)
  let scheme = call_594167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594167.url(scheme.get, call_594167.host, call_594167.base,
                         call_594167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594167, url, valid)

proc call*(call_594168: Call_AddsServicesGetMetricMetadataForGroup_594157;
          apiVersion: string; groupName: string; metricName: string;
          serviceName: string; groupKey: string = ""; fromDate: string = "";
          toDate: string = ""): Recallable =
  ## addsServicesGetMetricMetadataForGroup
  ## Gets the service related metrics for a given metric and group combination.
  ##   groupKey: string
  ##           : The group key
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   fromDate: string
  ##           : The start date.
  ##   groupName: string (required)
  ##            : The group name
  ##   metricName: string (required)
  ##             : The metric name
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   toDate: string
  ##         : The end date.
  var path_594169 = newJObject()
  var query_594170 = newJObject()
  add(query_594170, "groupKey", newJString(groupKey))
  add(query_594170, "api-version", newJString(apiVersion))
  add(query_594170, "fromDate", newJString(fromDate))
  add(path_594169, "groupName", newJString(groupName))
  add(path_594169, "metricName", newJString(metricName))
  add(path_594169, "serviceName", newJString(serviceName))
  add(query_594170, "toDate", newJString(toDate))
  result = call_594168.call(path_594169, query_594170, nil, nil, nil)

var addsServicesGetMetricMetadataForGroup* = Call_AddsServicesGetMetricMetadataForGroup_594157(
    name: "addsServicesGetMetricMetadataForGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/metricmetadata/{metricName}/groups/{groupName}",
    validator: validate_AddsServicesGetMetricMetadataForGroup_594158, base: "",
    url: url_AddsServicesGetMetricMetadataForGroup_594159, schemes: {Scheme.Https})
type
  Call_AddsServiceGetMetrics_594171 = ref object of OpenApiRestCall_593438
proc url_AddsServiceGetMetrics_594173(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/metrics/"),
               (kind: VariableSegment, value: "metricName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServiceGetMetrics_594172(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the server related metrics for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : The group name
  ##   metricName: JString (required)
  ##             : The metric name
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_594174 = path.getOrDefault("groupName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "groupName", valid_594174
  var valid_594175 = path.getOrDefault("metricName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "metricName", valid_594175
  var valid_594176 = path.getOrDefault("serviceName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "serviceName", valid_594176
  result.add "path", section
  ## parameters in `query` object:
  ##   groupKey: JString
  ##           : The group key
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   fromDate: JString
  ##           : The start date.
  ##   toDate: JString
  ##         : The end date.
  section = newJObject()
  var valid_594177 = query.getOrDefault("groupKey")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "groupKey", valid_594177
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594178 = query.getOrDefault("api-version")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "api-version", valid_594178
  var valid_594179 = query.getOrDefault("fromDate")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "fromDate", valid_594179
  var valid_594180 = query.getOrDefault("toDate")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "toDate", valid_594180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594181: Call_AddsServiceGetMetrics_594171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the server related metrics for a given metric and group combination.
  ## 
  let valid = call_594181.validator(path, query, header, formData, body)
  let scheme = call_594181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594181.url(scheme.get, call_594181.host, call_594181.base,
                         call_594181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594181, url, valid)

proc call*(call_594182: Call_AddsServiceGetMetrics_594171; apiVersion: string;
          groupName: string; metricName: string; serviceName: string;
          groupKey: string = ""; fromDate: string = ""; toDate: string = ""): Recallable =
  ## addsServiceGetMetrics
  ## Gets the server related metrics for a given metric and group combination.
  ##   groupKey: string
  ##           : The group key
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   fromDate: string
  ##           : The start date.
  ##   groupName: string (required)
  ##            : The group name
  ##   metricName: string (required)
  ##             : The metric name
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   toDate: string
  ##         : The end date.
  var path_594183 = newJObject()
  var query_594184 = newJObject()
  add(query_594184, "groupKey", newJString(groupKey))
  add(query_594184, "api-version", newJString(apiVersion))
  add(query_594184, "fromDate", newJString(fromDate))
  add(path_594183, "groupName", newJString(groupName))
  add(path_594183, "metricName", newJString(metricName))
  add(path_594183, "serviceName", newJString(serviceName))
  add(query_594184, "toDate", newJString(toDate))
  result = call_594182.call(path_594183, query_594184, nil, nil, nil)

var addsServiceGetMetrics* = Call_AddsServiceGetMetrics_594171(
    name: "addsServiceGetMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/metrics/{metricName}/groups/{groupName}",
    validator: validate_AddsServiceGetMetrics_594172, base: "",
    url: url_AddsServiceGetMetrics_594173, schemes: {Scheme.Https})
type
  Call_AddsServicesListMetricsAverage_594185 = ref object of OpenApiRestCall_593438
proc url_AddsServicesListMetricsAverage_594187(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/metrics/"),
               (kind: VariableSegment, value: "metricName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/average")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesListMetricsAverage_594186(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the average of the metric values for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : The group name
  ##   metricName: JString (required)
  ##             : The metric name
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_594188 = path.getOrDefault("groupName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "groupName", valid_594188
  var valid_594189 = path.getOrDefault("metricName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "metricName", valid_594189
  var valid_594190 = path.getOrDefault("serviceName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "serviceName", valid_594190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594191 = query.getOrDefault("api-version")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "api-version", valid_594191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594192: Call_AddsServicesListMetricsAverage_594185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the average of the metric values for a given metric and group combination.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_AddsServicesListMetricsAverage_594185;
          apiVersion: string; groupName: string; metricName: string;
          serviceName: string): Recallable =
  ## addsServicesListMetricsAverage
  ## Gets the average of the metric values for a given metric and group combination.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   groupName: string (required)
  ##            : The group name
  ##   metricName: string (required)
  ##             : The metric name
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  add(query_594195, "api-version", newJString(apiVersion))
  add(path_594194, "groupName", newJString(groupName))
  add(path_594194, "metricName", newJString(metricName))
  add(path_594194, "serviceName", newJString(serviceName))
  result = call_594193.call(path_594194, query_594195, nil, nil, nil)

var addsServicesListMetricsAverage* = Call_AddsServicesListMetricsAverage_594185(
    name: "addsServicesListMetricsAverage", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/metrics/{metricName}/groups/{groupName}/average",
    validator: validate_AddsServicesListMetricsAverage_594186, base: "",
    url: url_AddsServicesListMetricsAverage_594187, schemes: {Scheme.Https})
type
  Call_AddsServicesListMetricsSum_594196 = ref object of OpenApiRestCall_593438
proc url_AddsServicesListMetricsSum_594198(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/metrics/"),
               (kind: VariableSegment, value: "metricName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/sum")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesListMetricsSum_594197(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the sum of the metric values for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : The group name
  ##   metricName: JString (required)
  ##             : The metric name
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_594199 = path.getOrDefault("groupName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "groupName", valid_594199
  var valid_594200 = path.getOrDefault("metricName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "metricName", valid_594200
  var valid_594201 = path.getOrDefault("serviceName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "serviceName", valid_594201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594202 = query.getOrDefault("api-version")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "api-version", valid_594202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594203: Call_AddsServicesListMetricsSum_594196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the sum of the metric values for a given metric and group combination.
  ## 
  let valid = call_594203.validator(path, query, header, formData, body)
  let scheme = call_594203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594203.url(scheme.get, call_594203.host, call_594203.base,
                         call_594203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594203, url, valid)

proc call*(call_594204: Call_AddsServicesListMetricsSum_594196; apiVersion: string;
          groupName: string; metricName: string; serviceName: string): Recallable =
  ## addsServicesListMetricsSum
  ## Gets the sum of the metric values for a given metric and group combination.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   groupName: string (required)
  ##            : The group name
  ##   metricName: string (required)
  ##             : The metric name
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594205 = newJObject()
  var query_594206 = newJObject()
  add(query_594206, "api-version", newJString(apiVersion))
  add(path_594205, "groupName", newJString(groupName))
  add(path_594205, "metricName", newJString(metricName))
  add(path_594205, "serviceName", newJString(serviceName))
  result = call_594204.call(path_594205, query_594206, nil, nil, nil)

var addsServicesListMetricsSum* = Call_AddsServicesListMetricsSum_594196(
    name: "addsServicesListMetricsSum", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/metrics/{metricName}/groups/{groupName}/sum",
    validator: validate_AddsServicesListMetricsSum_594197, base: "",
    url: url_AddsServicesListMetricsSum_594198, schemes: {Scheme.Https})
type
  Call_AddsServicesListReplicationDetails_594207 = ref object of OpenApiRestCall_593438
proc url_AddsServicesListReplicationDetails_594209(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/replicationdetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesListReplicationDetails_594208(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets complete domain controller list along with replication details for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594210 = path.getOrDefault("serviceName")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "serviceName", valid_594210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   withDetails: JBool
  ##              : Indicates if InboundReplicationNeighbor details are required or not.
  ##   $filter: JString
  ##          : The server property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594211 = query.getOrDefault("api-version")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "api-version", valid_594211
  var valid_594212 = query.getOrDefault("withDetails")
  valid_594212 = validateParameter(valid_594212, JBool, required = false, default = nil)
  if valid_594212 != nil:
    section.add "withDetails", valid_594212
  var valid_594213 = query.getOrDefault("$filter")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "$filter", valid_594213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594214: Call_AddsServicesListReplicationDetails_594207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets complete domain controller list along with replication details for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594214.validator(path, query, header, formData, body)
  let scheme = call_594214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594214.url(scheme.get, call_594214.host, call_594214.base,
                         call_594214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594214, url, valid)

proc call*(call_594215: Call_AddsServicesListReplicationDetails_594207;
          apiVersion: string; serviceName: string; withDetails: bool = false;
          Filter: string = ""): Recallable =
  ## addsServicesListReplicationDetails
  ## Gets complete domain controller list along with replication details for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   withDetails: bool
  ##              : Indicates if InboundReplicationNeighbor details are required or not.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The server property filter to apply.
  var path_594216 = newJObject()
  var query_594217 = newJObject()
  add(query_594217, "api-version", newJString(apiVersion))
  add(query_594217, "withDetails", newJBool(withDetails))
  add(path_594216, "serviceName", newJString(serviceName))
  add(query_594217, "$filter", newJString(Filter))
  result = call_594215.call(path_594216, query_594217, nil, nil, nil)

var addsServicesListReplicationDetails* = Call_AddsServicesListReplicationDetails_594207(
    name: "addsServicesListReplicationDetails", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/replicationdetails",
    validator: validate_AddsServicesListReplicationDetails_594208, base: "",
    url: url_AddsServicesListReplicationDetails_594209, schemes: {Scheme.Https})
type
  Call_AddsServicesReplicationStatusGet_594218 = ref object of OpenApiRestCall_593438
proc url_AddsServicesReplicationStatusGet_594220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/replicationstatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesReplicationStatusGet_594219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets Replication status for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594221 = path.getOrDefault("serviceName")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "serviceName", valid_594221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594222 = query.getOrDefault("api-version")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "api-version", valid_594222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594223: Call_AddsServicesReplicationStatusGet_594218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets Replication status for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594223.validator(path, query, header, formData, body)
  let scheme = call_594223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594223.url(scheme.get, call_594223.host, call_594223.base,
                         call_594223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594223, url, valid)

proc call*(call_594224: Call_AddsServicesReplicationStatusGet_594218;
          apiVersion: string; serviceName: string): Recallable =
  ## addsServicesReplicationStatusGet
  ## Gets Replication status for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594225 = newJObject()
  var query_594226 = newJObject()
  add(query_594226, "api-version", newJString(apiVersion))
  add(path_594225, "serviceName", newJString(serviceName))
  result = call_594224.call(path_594225, query_594226, nil, nil, nil)

var addsServicesReplicationStatusGet* = Call_AddsServicesReplicationStatusGet_594218(
    name: "addsServicesReplicationStatusGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/replicationstatus",
    validator: validate_AddsServicesReplicationStatusGet_594219, base: "",
    url: url_AddsServicesReplicationStatusGet_594220, schemes: {Scheme.Https})
type
  Call_AddsServicesListReplicationSummary_594227 = ref object of OpenApiRestCall_593438
proc url_AddsServicesListReplicationSummary_594229(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/replicationsummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesListReplicationSummary_594228(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets complete domain controller list along with replication details for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594230 = path.getOrDefault("serviceName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "serviceName", valid_594230
  result.add "path", section
  ## parameters in `query` object:
  ##   nextPartitionKey: JString (required)
  ##                   : The next partition key to query for.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   query: JString (required)
  ##        : The custom query.
  ##   nextRowKey: JString (required)
  ##             : The next row key to query for.
  ##   takeCount: JInt
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  ##   isGroupbySite: JBool (required)
  ##                : Indicates if the result should be grouped by site or not.
  ##   $filter: JString
  ##          : The server property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `nextPartitionKey` field"
  var valid_594231 = query.getOrDefault("nextPartitionKey")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = newJString(" "))
  if valid_594231 != nil:
    section.add "nextPartitionKey", valid_594231
  var valid_594232 = query.getOrDefault("api-version")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "api-version", valid_594232
  var valid_594233 = query.getOrDefault("query")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "query", valid_594233
  var valid_594234 = query.getOrDefault("nextRowKey")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = newJString(" "))
  if valid_594234 != nil:
    section.add "nextRowKey", valid_594234
  var valid_594235 = query.getOrDefault("takeCount")
  valid_594235 = validateParameter(valid_594235, JInt, required = false, default = nil)
  if valid_594235 != nil:
    section.add "takeCount", valid_594235
  var valid_594236 = query.getOrDefault("isGroupbySite")
  valid_594236 = validateParameter(valid_594236, JBool, required = true, default = nil)
  if valid_594236 != nil:
    section.add "isGroupbySite", valid_594236
  var valid_594237 = query.getOrDefault("$filter")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "$filter", valid_594237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594238: Call_AddsServicesListReplicationSummary_594227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets complete domain controller list along with replication details for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594238.validator(path, query, header, formData, body)
  let scheme = call_594238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594238.url(scheme.get, call_594238.host, call_594238.base,
                         call_594238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594238, url, valid)

proc call*(call_594239: Call_AddsServicesListReplicationSummary_594227;
          apiVersion: string; query: string; isGroupbySite: bool; serviceName: string;
          nextPartitionKey: string = " "; nextRowKey: string = " "; takeCount: int = 0;
          Filter: string = ""): Recallable =
  ## addsServicesListReplicationSummary
  ## Gets complete domain controller list along with replication details for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ##   nextPartitionKey: string (required)
  ##                   : The next partition key to query for.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   query: string (required)
  ##        : The custom query.
  ##   nextRowKey: string (required)
  ##             : The next row key to query for.
  ##   takeCount: int
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  ##   isGroupbySite: bool (required)
  ##                : Indicates if the result should be grouped by site or not.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The server property filter to apply.
  var path_594240 = newJObject()
  var query_594241 = newJObject()
  add(query_594241, "nextPartitionKey", newJString(nextPartitionKey))
  add(query_594241, "api-version", newJString(apiVersion))
  add(query_594241, "query", newJString(query))
  add(query_594241, "nextRowKey", newJString(nextRowKey))
  add(query_594241, "takeCount", newJInt(takeCount))
  add(query_594241, "isGroupbySite", newJBool(isGroupbySite))
  add(path_594240, "serviceName", newJString(serviceName))
  add(query_594241, "$filter", newJString(Filter))
  result = call_594239.call(path_594240, query_594241, nil, nil, nil)

var addsServicesListReplicationSummary* = Call_AddsServicesListReplicationSummary_594227(
    name: "addsServicesListReplicationSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/replicationsummary",
    validator: validate_AddsServicesListReplicationSummary_594228, base: "",
    url: url_AddsServicesListReplicationSummary_594229, schemes: {Scheme.Https})
type
  Call_AddsServicesServiceMembersAdd_594254 = ref object of OpenApiRestCall_593438
proc url_AddsServicesServiceMembersAdd_594256(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesServiceMembersAdd_594255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Onboards  a server, for a given Active Directory Domain Controller service, to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service under which the server is to be onboarded.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594257 = path.getOrDefault("serviceName")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "serviceName", valid_594257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594258 = query.getOrDefault("api-version")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "api-version", valid_594258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceMember: JObject (required)
  ##                : The server object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594260: Call_AddsServicesServiceMembersAdd_594254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Onboards  a server, for a given Active Directory Domain Controller service, to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_594260.validator(path, query, header, formData, body)
  let scheme = call_594260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594260.url(scheme.get, call_594260.host, call_594260.base,
                         call_594260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594260, url, valid)

proc call*(call_594261: Call_AddsServicesServiceMembersAdd_594254;
          apiVersion: string; serviceMember: JsonNode; serviceName: string): Recallable =
  ## addsServicesServiceMembersAdd
  ## Onboards  a server, for a given Active Directory Domain Controller service, to Azure Active Directory Connect Health Service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMember: JObject (required)
  ##                : The server object.
  ##   serviceName: string (required)
  ##              : The name of the service under which the server is to be onboarded.
  var path_594262 = newJObject()
  var query_594263 = newJObject()
  var body_594264 = newJObject()
  add(query_594263, "api-version", newJString(apiVersion))
  if serviceMember != nil:
    body_594264 = serviceMember
  add(path_594262, "serviceName", newJString(serviceName))
  result = call_594261.call(path_594262, query_594263, nil, nil, body_594264)

var addsServicesServiceMembersAdd* = Call_AddsServicesServiceMembersAdd_594254(
    name: "addsServicesServiceMembersAdd", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/servicemembers",
    validator: validate_AddsServicesServiceMembersAdd_594255, base: "",
    url: url_AddsServicesServiceMembersAdd_594256, schemes: {Scheme.Https})
type
  Call_AddsServicesServiceMembersList_594242 = ref object of OpenApiRestCall_593438
proc url_AddsServicesServiceMembersList_594244(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesServiceMembersList_594243(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the servers, for a given Active Directory Domain Controller service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594245 = path.getOrDefault("serviceName")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "serviceName", valid_594245
  result.add "path", section
  ## parameters in `query` object:
  ##   dimensionType: JString
  ##                : The server specific dimension.
  ##   dimensionSignature: JString
  ##                     : The value of the dimension.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $filter: JString
  ##          : The server property filter to apply.
  section = newJObject()
  var valid_594246 = query.getOrDefault("dimensionType")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "dimensionType", valid_594246
  var valid_594247 = query.getOrDefault("dimensionSignature")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "dimensionSignature", valid_594247
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594248 = query.getOrDefault("api-version")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "api-version", valid_594248
  var valid_594249 = query.getOrDefault("$filter")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "$filter", valid_594249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594250: Call_AddsServicesServiceMembersList_594242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the servers, for a given Active Directory Domain Controller service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_AddsServicesServiceMembersList_594242;
          apiVersion: string; serviceName: string; dimensionType: string = "";
          dimensionSignature: string = ""; Filter: string = ""): Recallable =
  ## addsServicesServiceMembersList
  ## Gets the details of the servers, for a given Active Directory Domain Controller service, that are onboarded to Azure Active Directory Connect Health Service.
  ##   dimensionType: string
  ##                : The server specific dimension.
  ##   dimensionSignature: string
  ##                     : The value of the dimension.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The server property filter to apply.
  var path_594252 = newJObject()
  var query_594253 = newJObject()
  add(query_594253, "dimensionType", newJString(dimensionType))
  add(query_594253, "dimensionSignature", newJString(dimensionSignature))
  add(query_594253, "api-version", newJString(apiVersion))
  add(path_594252, "serviceName", newJString(serviceName))
  add(query_594253, "$filter", newJString(Filter))
  result = call_594251.call(path_594252, query_594253, nil, nil, nil)

var addsServicesServiceMembersList* = Call_AddsServicesServiceMembersList_594242(
    name: "addsServicesServiceMembersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/servicemembers",
    validator: validate_AddsServicesServiceMembersList_594243, base: "",
    url: url_AddsServicesServiceMembersList_594244, schemes: {Scheme.Https})
type
  Call_AddsServiceMembersGet_594265 = ref object of OpenApiRestCall_593438
proc url_AddsServiceMembersGet_594267(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServiceMembersGet_594266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a server, for a given Active Directory Domain Controller service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594268 = path.getOrDefault("serviceMemberId")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "serviceMemberId", valid_594268
  var valid_594269 = path.getOrDefault("serviceName")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "serviceName", valid_594269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594270 = query.getOrDefault("api-version")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "api-version", valid_594270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594271: Call_AddsServiceMembersGet_594265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a server, for a given Active Directory Domain Controller service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_594271.validator(path, query, header, formData, body)
  let scheme = call_594271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594271.url(scheme.get, call_594271.host, call_594271.base,
                         call_594271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594271, url, valid)

proc call*(call_594272: Call_AddsServiceMembersGet_594265; apiVersion: string;
          serviceMemberId: string; serviceName: string): Recallable =
  ## addsServiceMembersGet
  ## Gets the details of a server, for a given Active Directory Domain Controller service, that are onboarded to Azure Active Directory Connect Health Service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594273 = newJObject()
  var query_594274 = newJObject()
  add(query_594274, "api-version", newJString(apiVersion))
  add(path_594273, "serviceMemberId", newJString(serviceMemberId))
  add(path_594273, "serviceName", newJString(serviceName))
  result = call_594272.call(path_594273, query_594274, nil, nil, nil)

var addsServiceMembersGet* = Call_AddsServiceMembersGet_594265(
    name: "addsServiceMembersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/servicemembers/{serviceMemberId}",
    validator: validate_AddsServiceMembersGet_594266, base: "",
    url: url_AddsServiceMembersGet_594267, schemes: {Scheme.Https})
type
  Call_AddsServiceMembersDelete_594275 = ref object of OpenApiRestCall_593438
proc url_AddsServiceMembersDelete_594277(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServiceMembersDelete_594276(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Active Directory Domain Controller server that has been onboarded to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594278 = path.getOrDefault("serviceMemberId")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "serviceMemberId", valid_594278
  var valid_594279 = path.getOrDefault("serviceName")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "serviceName", valid_594279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   confirm: JBool
  ##          : Indicates if the server will be permanently deleted or disabled. True indicates that the server will be permanently deleted and False indicates that the server will be marked disabled and then deleted after 30 days, if it is not re-registered.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594280 = query.getOrDefault("api-version")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "api-version", valid_594280
  var valid_594281 = query.getOrDefault("confirm")
  valid_594281 = validateParameter(valid_594281, JBool, required = false, default = nil)
  if valid_594281 != nil:
    section.add "confirm", valid_594281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594282: Call_AddsServiceMembersDelete_594275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Active Directory Domain Controller server that has been onboarded to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_594282.validator(path, query, header, formData, body)
  let scheme = call_594282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594282.url(scheme.get, call_594282.host, call_594282.base,
                         call_594282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594282, url, valid)

proc call*(call_594283: Call_AddsServiceMembersDelete_594275; apiVersion: string;
          serviceMemberId: string; serviceName: string; confirm: bool = false): Recallable =
  ## addsServiceMembersDelete
  ## Deletes a Active Directory Domain Controller server that has been onboarded to Azure Active Directory Connect Health Service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  ##   confirm: bool
  ##          : Indicates if the server will be permanently deleted or disabled. True indicates that the server will be permanently deleted and False indicates that the server will be marked disabled and then deleted after 30 days, if it is not re-registered.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594284 = newJObject()
  var query_594285 = newJObject()
  add(query_594285, "api-version", newJString(apiVersion))
  add(path_594284, "serviceMemberId", newJString(serviceMemberId))
  add(query_594285, "confirm", newJBool(confirm))
  add(path_594284, "serviceName", newJString(serviceName))
  result = call_594283.call(path_594284, query_594285, nil, nil, nil)

var addsServiceMembersDelete* = Call_AddsServiceMembersDelete_594275(
    name: "addsServiceMembersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/servicemembers/{serviceMemberId}",
    validator: validate_AddsServiceMembersDelete_594276, base: "",
    url: url_AddsServiceMembersDelete_594277, schemes: {Scheme.Https})
type
  Call_AddsServicesListServerAlerts_594286 = ref object of OpenApiRestCall_593438
proc url_AddsServicesListServerAlerts_594288(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServicesListServerAlerts_594287(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an alert for a given Active Directory Domain Controller service and server combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id for which the alert details needs to be queried.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594289 = path.getOrDefault("serviceMemberId")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "serviceMemberId", valid_594289
  var valid_594290 = path.getOrDefault("serviceName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "serviceName", valid_594290
  result.add "path", section
  ## parameters in `query` object:
  ##   to: JString
  ##     : The end date till when to query for.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   from: JString
  ##       : The start date to query for.
  ##   $filter: JString
  ##          : The alert property filter to apply.
  ##   state: JString
  ##        : The alert state to query for.
  section = newJObject()
  var valid_594291 = query.getOrDefault("to")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "to", valid_594291
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594292 = query.getOrDefault("api-version")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "api-version", valid_594292
  var valid_594293 = query.getOrDefault("from")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "from", valid_594293
  var valid_594294 = query.getOrDefault("$filter")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "$filter", valid_594294
  var valid_594295 = query.getOrDefault("state")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "state", valid_594295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594296: Call_AddsServicesListServerAlerts_594286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an alert for a given Active Directory Domain Controller service and server combination.
  ## 
  let valid = call_594296.validator(path, query, header, formData, body)
  let scheme = call_594296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594296.url(scheme.get, call_594296.host, call_594296.base,
                         call_594296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594296, url, valid)

proc call*(call_594297: Call_AddsServicesListServerAlerts_594286;
          apiVersion: string; serviceMemberId: string; serviceName: string;
          to: string = ""; `from`: string = ""; Filter: string = ""; state: string = ""): Recallable =
  ## addsServicesListServerAlerts
  ## Gets the details of an alert for a given Active Directory Domain Controller service and server combination.
  ##   to: string
  ##     : The end date till when to query for.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   from: string
  ##       : The start date to query for.
  ##   serviceMemberId: string (required)
  ##                  : The server Id for which the alert details needs to be queried.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The alert property filter to apply.
  ##   state: string
  ##        : The alert state to query for.
  var path_594298 = newJObject()
  var query_594299 = newJObject()
  add(query_594299, "to", newJString(to))
  add(query_594299, "api-version", newJString(apiVersion))
  add(query_594299, "from", newJString(`from`))
  add(path_594298, "serviceMemberId", newJString(serviceMemberId))
  add(path_594298, "serviceName", newJString(serviceName))
  add(query_594299, "$filter", newJString(Filter))
  add(query_594299, "state", newJString(state))
  result = call_594297.call(path_594298, query_594299, nil, nil, nil)

var addsServicesListServerAlerts* = Call_AddsServicesListServerAlerts_594286(
    name: "addsServicesListServerAlerts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/servicemembers/{serviceMemberId}/alerts",
    validator: validate_AddsServicesListServerAlerts_594287, base: "",
    url: url_AddsServicesListServerAlerts_594288, schemes: {Scheme.Https})
type
  Call_AddsServiceMembersListCredentials_594300 = ref object of OpenApiRestCall_593438
proc url_AddsServiceMembersListCredentials_594302(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.ADHybridHealthService/addsservices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId"),
               (kind: ConstantSegment, value: "/credentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AddsServiceMembersListCredentials_594301(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the credentials of the server which is needed by the agent to connect to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594303 = path.getOrDefault("serviceMemberId")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "serviceMemberId", valid_594303
  var valid_594304 = path.getOrDefault("serviceName")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "serviceName", valid_594304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $filter: JString
  ##          : The property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594305 = query.getOrDefault("api-version")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "api-version", valid_594305
  var valid_594306 = query.getOrDefault("$filter")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "$filter", valid_594306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594307: Call_AddsServiceMembersListCredentials_594300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the credentials of the server which is needed by the agent to connect to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_594307.validator(path, query, header, formData, body)
  let scheme = call_594307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594307.url(scheme.get, call_594307.host, call_594307.base,
                         call_594307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594307, url, valid)

proc call*(call_594308: Call_AddsServiceMembersListCredentials_594300;
          apiVersion: string; serviceMemberId: string; serviceName: string;
          Filter: string = ""): Recallable =
  ## addsServiceMembersListCredentials
  ## Gets the credentials of the server which is needed by the agent to connect to Azure Active Directory Connect Health Service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The property filter to apply.
  var path_594309 = newJObject()
  var query_594310 = newJObject()
  add(query_594310, "api-version", newJString(apiVersion))
  add(path_594309, "serviceMemberId", newJString(serviceMemberId))
  add(path_594309, "serviceName", newJString(serviceName))
  add(query_594310, "$filter", newJString(Filter))
  result = call_594308.call(path_594309, query_594310, nil, nil, nil)

var addsServiceMembersListCredentials* = Call_AddsServiceMembersListCredentials_594300(
    name: "addsServiceMembersListCredentials", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/servicemembers/{serviceMemberId}/credentials",
    validator: validate_AddsServiceMembersListCredentials_594301, base: "",
    url: url_AddsServiceMembersListCredentials_594302, schemes: {Scheme.Https})
type
  Call_ConfigurationAdd_594318 = ref object of OpenApiRestCall_593438
proc url_ConfigurationAdd_594320(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ConfigurationAdd_594319(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Onboards a tenant in Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594321 = query.getOrDefault("api-version")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "api-version", valid_594321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594322: Call_ConfigurationAdd_594318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Onboards a tenant in Azure Active Directory Connect Health.
  ## 
  let valid = call_594322.validator(path, query, header, formData, body)
  let scheme = call_594322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594322.url(scheme.get, call_594322.host, call_594322.base,
                         call_594322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594322, url, valid)

proc call*(call_594323: Call_ConfigurationAdd_594318; apiVersion: string): Recallable =
  ## configurationAdd
  ## Onboards a tenant in Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_594324 = newJObject()
  add(query_594324, "api-version", newJString(apiVersion))
  result = call_594323.call(nil, query_594324, nil, nil, nil)

var configurationAdd* = Call_ConfigurationAdd_594318(name: "configurationAdd",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/configuration",
    validator: validate_ConfigurationAdd_594319, base: "",
    url: url_ConfigurationAdd_594320, schemes: {Scheme.Https})
type
  Call_ConfigurationGet_594311 = ref object of OpenApiRestCall_593438
proc url_ConfigurationGet_594313(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ConfigurationGet_594312(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the details of a tenant onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594314 = query.getOrDefault("api-version")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "api-version", valid_594314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594315: Call_ConfigurationGet_594311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a tenant onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594315.validator(path, query, header, formData, body)
  let scheme = call_594315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594315.url(scheme.get, call_594315.host, call_594315.base,
                         call_594315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594315, url, valid)

proc call*(call_594316: Call_ConfigurationGet_594311; apiVersion: string): Recallable =
  ## configurationGet
  ## Gets the details of a tenant onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_594317 = newJObject()
  add(query_594317, "api-version", newJString(apiVersion))
  result = call_594316.call(nil, query_594317, nil, nil, nil)

var configurationGet* = Call_ConfigurationGet_594311(name: "configurationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/configuration",
    validator: validate_ConfigurationGet_594312, base: "",
    url: url_ConfigurationGet_594313, schemes: {Scheme.Https})
type
  Call_ConfigurationUpdate_594325 = ref object of OpenApiRestCall_593438
proc url_ConfigurationUpdate_594327(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ConfigurationUpdate_594326(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates tenant properties for tenants onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594328 = query.getOrDefault("api-version")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "api-version", valid_594328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   tenant: JObject (required)
  ##         : The tenant object with the properties set to the updated value.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594330: Call_ConfigurationUpdate_594325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates tenant properties for tenants onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_ConfigurationUpdate_594325; apiVersion: string;
          tenant: JsonNode): Recallable =
  ## configurationUpdate
  ## Updates tenant properties for tenants onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   tenant: JObject (required)
  ##         : The tenant object with the properties set to the updated value.
  var query_594332 = newJObject()
  var body_594333 = newJObject()
  add(query_594332, "api-version", newJString(apiVersion))
  if tenant != nil:
    body_594333 = tenant
  result = call_594331.call(nil, query_594332, nil, nil, body_594333)

var configurationUpdate* = Call_ConfigurationUpdate_594325(
    name: "configurationUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/configuration",
    validator: validate_ConfigurationUpdate_594326, base: "",
    url: url_ConfigurationUpdate_594327, schemes: {Scheme.Https})
type
  Call_OperationsList_594334 = ref object of OpenApiRestCall_593438
proc url_OperationsList_594336(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_594335(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the available Azure Data Factory API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594337 = query.getOrDefault("api-version")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "api-version", valid_594337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594338: Call_OperationsList_594334; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available Azure Data Factory API operations.
  ## 
  let valid = call_594338.validator(path, query, header, formData, body)
  let scheme = call_594338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594338.url(scheme.get, call_594338.host, call_594338.base,
                         call_594338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594338, url, valid)

proc call*(call_594339: Call_OperationsList_594334; apiVersion: string): Recallable =
  ## operationsList
  ## Lists the available Azure Data Factory API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_594340 = newJObject()
  add(query_594340, "api-version", newJString(apiVersion))
  result = call_594339.call(nil, query_594340, nil, nil, nil)

var operationsList* = Call_OperationsList_594334(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/operations",
    validator: validate_OperationsList_594335, base: "", url: url_OperationsList_594336,
    schemes: {Scheme.Https})
type
  Call_ReportsGetDevOps_594341 = ref object of OpenApiRestCall_593438
proc url_ReportsGetDevOps_594343(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsGetDevOps_594342(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Checks if the user is enabled for Dev Ops access.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594344 = query.getOrDefault("api-version")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "api-version", valid_594344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594345: Call_ReportsGetDevOps_594341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the user is enabled for Dev Ops access.
  ## 
  let valid = call_594345.validator(path, query, header, formData, body)
  let scheme = call_594345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594345.url(scheme.get, call_594345.host, call_594345.base,
                         call_594345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594345, url, valid)

proc call*(call_594346: Call_ReportsGetDevOps_594341; apiVersion: string): Recallable =
  ## reportsGetDevOps
  ## Checks if the user is enabled for Dev Ops access.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_594347 = newJObject()
  add(query_594347, "api-version", newJString(apiVersion))
  result = call_594346.call(nil, query_594347, nil, nil, nil)

var reportsGetDevOps* = Call_ReportsGetDevOps_594341(name: "reportsGetDevOps",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/reports/DevOps/IsDevOps",
    validator: validate_ReportsGetDevOps_594342, base: "",
    url: url_ReportsGetDevOps_594343, schemes: {Scheme.Https})
type
  Call_ServiceMembersListConnectors_594348 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersListConnectors_594350(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId"),
               (kind: ConstantSegment, value: "/connectors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersListConnectors_594349(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the connector details for a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594351 = path.getOrDefault("serviceMemberId")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "serviceMemberId", valid_594351
  var valid_594352 = path.getOrDefault("serviceName")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "serviceName", valid_594352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594353 = query.getOrDefault("api-version")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "api-version", valid_594353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594354: Call_ServiceMembersListConnectors_594348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the connector details for a service.
  ## 
  let valid = call_594354.validator(path, query, header, formData, body)
  let scheme = call_594354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594354.url(scheme.get, call_594354.host, call_594354.base,
                         call_594354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594354, url, valid)

proc call*(call_594355: Call_ServiceMembersListConnectors_594348;
          apiVersion: string; serviceMemberId: string; serviceName: string): Recallable =
  ## serviceMembersListConnectors
  ## Gets the connector details for a service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594356 = newJObject()
  var query_594357 = newJObject()
  add(query_594357, "api-version", newJString(apiVersion))
  add(path_594356, "serviceMemberId", newJString(serviceMemberId))
  add(path_594356, "serviceName", newJString(serviceName))
  result = call_594355.call(path_594356, query_594357, nil, nil, nil)

var serviceMembersListConnectors* = Call_ServiceMembersListConnectors_594348(
    name: "serviceMembersListConnectors", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/service/{serviceName}/servicemembers/{serviceMemberId}/connectors",
    validator: validate_ServiceMembersListConnectors_594349, base: "",
    url: url_ServiceMembersListConnectors_594350, schemes: {Scheme.Https})
type
  Call_ServicesAdd_594369 = ref object of OpenApiRestCall_593438
proc url_ServicesAdd_594371(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ServicesAdd_594370(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Onboards a service for a given tenant in Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594372 = query.getOrDefault("api-version")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "api-version", valid_594372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   service: JObject (required)
  ##          : The service object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594374: Call_ServicesAdd_594369; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Onboards a service for a given tenant in Azure Active Directory Connect Health.
  ## 
  let valid = call_594374.validator(path, query, header, formData, body)
  let scheme = call_594374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594374.url(scheme.get, call_594374.host, call_594374.base,
                         call_594374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594374, url, valid)

proc call*(call_594375: Call_ServicesAdd_594369; apiVersion: string;
          service: JsonNode): Recallable =
  ## servicesAdd
  ## Onboards a service for a given tenant in Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   service: JObject (required)
  ##          : The service object.
  var query_594376 = newJObject()
  var body_594377 = newJObject()
  add(query_594376, "api-version", newJString(apiVersion))
  if service != nil:
    body_594377 = service
  result = call_594375.call(nil, query_594376, nil, nil, body_594377)

var servicesAdd* = Call_ServicesAdd_594369(name: "servicesAdd",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services",
                                        validator: validate_ServicesAdd_594370,
                                        base: "", url: url_ServicesAdd_594371,
                                        schemes: {Scheme.Https})
type
  Call_ServicesList_594358 = ref object of OpenApiRestCall_593438
proc url_ServicesList_594360(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ServicesList_594359(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of services, for a tenant, that are onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   serviceType: JString
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   skipCount: JInt
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   takeCount: JInt
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  ##   $filter: JString
  ##          : The service property filter to apply.
  section = newJObject()
  var valid_594361 = query.getOrDefault("serviceType")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "serviceType", valid_594361
  var valid_594362 = query.getOrDefault("skipCount")
  valid_594362 = validateParameter(valid_594362, JInt, required = false, default = nil)
  if valid_594362 != nil:
    section.add "skipCount", valid_594362
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594363 = query.getOrDefault("api-version")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "api-version", valid_594363
  var valid_594364 = query.getOrDefault("takeCount")
  valid_594364 = validateParameter(valid_594364, JInt, required = false, default = nil)
  if valid_594364 != nil:
    section.add "takeCount", valid_594364
  var valid_594365 = query.getOrDefault("$filter")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "$filter", valid_594365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594366: Call_ServicesList_594358; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of services, for a tenant, that are onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594366.validator(path, query, header, formData, body)
  let scheme = call_594366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594366.url(scheme.get, call_594366.host, call_594366.base,
                         call_594366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594366, url, valid)

proc call*(call_594367: Call_ServicesList_594358; apiVersion: string;
          serviceType: string = ""; skipCount: int = 0; takeCount: int = 0;
          Filter: string = ""): Recallable =
  ## servicesList
  ## Gets the details of services, for a tenant, that are onboarded to Azure Active Directory Connect Health.
  ##   serviceType: string
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   skipCount: int
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   takeCount: int
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  ##   Filter: string
  ##         : The service property filter to apply.
  var query_594368 = newJObject()
  add(query_594368, "serviceType", newJString(serviceType))
  add(query_594368, "skipCount", newJInt(skipCount))
  add(query_594368, "api-version", newJString(apiVersion))
  add(query_594368, "takeCount", newJInt(takeCount))
  add(query_594368, "$filter", newJString(Filter))
  result = call_594367.call(nil, query_594368, nil, nil, nil)

var servicesList* = Call_ServicesList_594358(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/services",
    validator: validate_ServicesList_594359, base: "", url: url_ServicesList_594360,
    schemes: {Scheme.Https})
type
  Call_ServicesListPremium_594378 = ref object of OpenApiRestCall_593438
proc url_ServicesListPremium_594380(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ServicesListPremium_594379(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the details of services for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   serviceType: JString
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   skipCount: JInt
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   takeCount: JInt
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  ##   $filter: JString
  ##          : The service property filter to apply.
  section = newJObject()
  var valid_594381 = query.getOrDefault("serviceType")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "serviceType", valid_594381
  var valid_594382 = query.getOrDefault("skipCount")
  valid_594382 = validateParameter(valid_594382, JInt, required = false, default = nil)
  if valid_594382 != nil:
    section.add "skipCount", valid_594382
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594383 = query.getOrDefault("api-version")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "api-version", valid_594383
  var valid_594384 = query.getOrDefault("takeCount")
  valid_594384 = validateParameter(valid_594384, JInt, required = false, default = nil)
  if valid_594384 != nil:
    section.add "takeCount", valid_594384
  var valid_594385 = query.getOrDefault("$filter")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = nil)
  if valid_594385 != nil:
    section.add "$filter", valid_594385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594386: Call_ServicesListPremium_594378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of services for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594386.validator(path, query, header, formData, body)
  let scheme = call_594386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594386.url(scheme.get, call_594386.host, call_594386.base,
                         call_594386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594386, url, valid)

proc call*(call_594387: Call_ServicesListPremium_594378; apiVersion: string;
          serviceType: string = ""; skipCount: int = 0; takeCount: int = 0;
          Filter: string = ""): Recallable =
  ## servicesListPremium
  ## Gets the details of services for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ##   serviceType: string
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   skipCount: int
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   takeCount: int
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  ##   Filter: string
  ##         : The service property filter to apply.
  var query_594388 = newJObject()
  add(query_594388, "serviceType", newJString(serviceType))
  add(query_594388, "skipCount", newJInt(skipCount))
  add(query_594388, "api-version", newJString(apiVersion))
  add(query_594388, "takeCount", newJInt(takeCount))
  add(query_594388, "$filter", newJString(Filter))
  result = call_594387.call(nil, query_594388, nil, nil, nil)

var servicesListPremium* = Call_ServicesListPremium_594378(
    name: "servicesListPremium", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/services/premiumCheck",
    validator: validate_ServicesListPremium_594379, base: "",
    url: url_ServicesListPremium_594380, schemes: {Scheme.Https})
type
  Call_ServicesGet_594389 = ref object of OpenApiRestCall_593438
proc url_ServicesGet_594391(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGet_594390(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a service for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594392 = path.getOrDefault("serviceName")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "serviceName", valid_594392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594393 = query.getOrDefault("api-version")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "api-version", valid_594393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594394: Call_ServicesGet_594389; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a service for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594394.validator(path, query, header, formData, body)
  let scheme = call_594394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594394.url(scheme.get, call_594394.host, call_594394.base,
                         call_594394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594394, url, valid)

proc call*(call_594395: Call_ServicesGet_594389; apiVersion: string;
          serviceName: string): Recallable =
  ## servicesGet
  ## Gets the details of a service for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594396 = newJObject()
  var query_594397 = newJObject()
  add(query_594397, "api-version", newJString(apiVersion))
  add(path_594396, "serviceName", newJString(serviceName))
  result = call_594395.call(path_594396, query_594397, nil, nil, nil)

var servicesGet* = Call_ServicesGet_594389(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}",
                                        validator: validate_ServicesGet_594390,
                                        base: "", url: url_ServicesGet_594391,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_594408 = ref object of OpenApiRestCall_593438
proc url_ServicesUpdate_594410(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesUpdate_594409(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the service properties of an onboarded service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service which needs to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594411 = path.getOrDefault("serviceName")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "serviceName", valid_594411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594412 = query.getOrDefault("api-version")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "api-version", valid_594412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   service: JObject (required)
  ##          : The service object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594414: Call_ServicesUpdate_594408; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the service properties of an onboarded service.
  ## 
  let valid = call_594414.validator(path, query, header, formData, body)
  let scheme = call_594414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594414.url(scheme.get, call_594414.host, call_594414.base,
                         call_594414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594414, url, valid)

proc call*(call_594415: Call_ServicesUpdate_594408; apiVersion: string;
          service: JsonNode; serviceName: string): Recallable =
  ## servicesUpdate
  ## Updates the service properties of an onboarded service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   service: JObject (required)
  ##          : The service object.
  ##   serviceName: string (required)
  ##              : The name of the service which needs to be deleted.
  var path_594416 = newJObject()
  var query_594417 = newJObject()
  var body_594418 = newJObject()
  add(query_594417, "api-version", newJString(apiVersion))
  if service != nil:
    body_594418 = service
  add(path_594416, "serviceName", newJString(serviceName))
  result = call_594415.call(path_594416, query_594417, nil, nil, body_594418)

var servicesUpdate* = Call_ServicesUpdate_594408(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}",
    validator: validate_ServicesUpdate_594409, base: "", url: url_ServicesUpdate_594410,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_594398 = ref object of OpenApiRestCall_593438
proc url_ServicesDelete_594400(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesDelete_594399(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a service which is onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service which needs to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594401 = path.getOrDefault("serviceName")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "serviceName", valid_594401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   confirm: JBool
  ##          : Indicates if the service will be permanently deleted or disabled. True indicates that the service will be permanently deleted and False indicates that the service will be marked disabled and then deleted after 30 days, if it is not re-registered.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594402 = query.getOrDefault("api-version")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "api-version", valid_594402
  var valid_594403 = query.getOrDefault("confirm")
  valid_594403 = validateParameter(valid_594403, JBool, required = false, default = nil)
  if valid_594403 != nil:
    section.add "confirm", valid_594403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594404: Call_ServicesDelete_594398; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a service which is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_594404.validator(path, query, header, formData, body)
  let scheme = call_594404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594404.url(scheme.get, call_594404.host, call_594404.base,
                         call_594404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594404, url, valid)

proc call*(call_594405: Call_ServicesDelete_594398; apiVersion: string;
          serviceName: string; confirm: bool = false): Recallable =
  ## servicesDelete
  ## Deletes a service which is onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   confirm: bool
  ##          : Indicates if the service will be permanently deleted or disabled. True indicates that the service will be permanently deleted and False indicates that the service will be marked disabled and then deleted after 30 days, if it is not re-registered.
  ##   serviceName: string (required)
  ##              : The name of the service which needs to be deleted.
  var path_594406 = newJObject()
  var query_594407 = newJObject()
  add(query_594407, "api-version", newJString(apiVersion))
  add(query_594407, "confirm", newJBool(confirm))
  add(path_594406, "serviceName", newJString(serviceName))
  result = call_594405.call(path_594406, query_594407, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_594398(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}",
    validator: validate_ServicesDelete_594399, base: "", url: url_ServicesDelete_594400,
    schemes: {Scheme.Https})
type
  Call_ServicesGetTenantWhitelisting_594419 = ref object of OpenApiRestCall_593438
proc url_ServicesGetTenantWhitelisting_594421(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "featureName" in path, "`featureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/TenantWhitelisting/"),
               (kind: VariableSegment, value: "featureName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGetTenantWhitelisting_594420(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks if the tenant, to which a service is registered, is whitelisted to use a feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   featureName: JString (required)
  ##              : The name of the feature.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `featureName` field"
  var valid_594422 = path.getOrDefault("featureName")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "featureName", valid_594422
  var valid_594423 = path.getOrDefault("serviceName")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "serviceName", valid_594423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594424 = query.getOrDefault("api-version")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "api-version", valid_594424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594425: Call_ServicesGetTenantWhitelisting_594419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the tenant, to which a service is registered, is whitelisted to use a feature.
  ## 
  let valid = call_594425.validator(path, query, header, formData, body)
  let scheme = call_594425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594425.url(scheme.get, call_594425.host, call_594425.base,
                         call_594425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594425, url, valid)

proc call*(call_594426: Call_ServicesGetTenantWhitelisting_594419;
          apiVersion: string; featureName: string; serviceName: string): Recallable =
  ## servicesGetTenantWhitelisting
  ## Checks if the tenant, to which a service is registered, is whitelisted to use a feature.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   featureName: string (required)
  ##              : The name of the feature.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594427 = newJObject()
  var query_594428 = newJObject()
  add(query_594428, "api-version", newJString(apiVersion))
  add(path_594427, "featureName", newJString(featureName))
  add(path_594427, "serviceName", newJString(serviceName))
  result = call_594426.call(path_594427, query_594428, nil, nil, nil)

var servicesGetTenantWhitelisting* = Call_ServicesGetTenantWhitelisting_594419(
    name: "servicesGetTenantWhitelisting", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/TenantWhitelisting/{featureName}",
    validator: validate_ServicesGetTenantWhitelisting_594420, base: "",
    url: url_ServicesGetTenantWhitelisting_594421, schemes: {Scheme.Https})
type
  Call_ServicesListAlerts_594429 = ref object of OpenApiRestCall_593438
proc url_ServicesListAlerts_594431(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListAlerts_594430(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the alerts for a given service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594432 = path.getOrDefault("serviceName")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "serviceName", valid_594432
  result.add "path", section
  ## parameters in `query` object:
  ##   to: JString
  ##     : The end date till when to query for.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   from: JString
  ##       : The start date to query for.
  ##   $filter: JString
  ##          : The alert property filter to apply.
  ##   state: JString
  ##        : The alert state to query for.
  section = newJObject()
  var valid_594433 = query.getOrDefault("to")
  valid_594433 = validateParameter(valid_594433, JString, required = false,
                                 default = nil)
  if valid_594433 != nil:
    section.add "to", valid_594433
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594434 = query.getOrDefault("api-version")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "api-version", valid_594434
  var valid_594435 = query.getOrDefault("from")
  valid_594435 = validateParameter(valid_594435, JString, required = false,
                                 default = nil)
  if valid_594435 != nil:
    section.add "from", valid_594435
  var valid_594436 = query.getOrDefault("$filter")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "$filter", valid_594436
  var valid_594437 = query.getOrDefault("state")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = nil)
  if valid_594437 != nil:
    section.add "state", valid_594437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594438: Call_ServicesListAlerts_594429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alerts for a given service.
  ## 
  let valid = call_594438.validator(path, query, header, formData, body)
  let scheme = call_594438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594438.url(scheme.get, call_594438.host, call_594438.base,
                         call_594438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594438, url, valid)

proc call*(call_594439: Call_ServicesListAlerts_594429; apiVersion: string;
          serviceName: string; to: string = ""; `from`: string = ""; Filter: string = "";
          state: string = ""): Recallable =
  ## servicesListAlerts
  ## Gets the alerts for a given service.
  ##   to: string
  ##     : The end date till when to query for.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   from: string
  ##       : The start date to query for.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The alert property filter to apply.
  ##   state: string
  ##        : The alert state to query for.
  var path_594440 = newJObject()
  var query_594441 = newJObject()
  add(query_594441, "to", newJString(to))
  add(query_594441, "api-version", newJString(apiVersion))
  add(query_594441, "from", newJString(`from`))
  add(path_594440, "serviceName", newJString(serviceName))
  add(query_594441, "$filter", newJString(Filter))
  add(query_594441, "state", newJString(state))
  result = call_594439.call(path_594440, query_594441, nil, nil, nil)

var servicesListAlerts* = Call_ServicesListAlerts_594429(
    name: "servicesListAlerts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/alerts",
    validator: validate_ServicesListAlerts_594430, base: "",
    url: url_ServicesListAlerts_594431, schemes: {Scheme.Https})
type
  Call_ServicesGetFeatureAvailibility_594442 = ref object of OpenApiRestCall_593438
proc url_ServicesGetFeatureAvailibility_594444(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "featureName" in path, "`featureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/checkServiceFeatureAvailibility/"),
               (kind: VariableSegment, value: "featureName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGetFeatureAvailibility_594443(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks if the service has all the pre-requisites met to use a feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   featureName: JString (required)
  ##              : The name of the feature.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `featureName` field"
  var valid_594445 = path.getOrDefault("featureName")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "featureName", valid_594445
  var valid_594446 = path.getOrDefault("serviceName")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "serviceName", valid_594446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594447 = query.getOrDefault("api-version")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "api-version", valid_594447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594448: Call_ServicesGetFeatureAvailibility_594442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the service has all the pre-requisites met to use a feature.
  ## 
  let valid = call_594448.validator(path, query, header, formData, body)
  let scheme = call_594448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594448.url(scheme.get, call_594448.host, call_594448.base,
                         call_594448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594448, url, valid)

proc call*(call_594449: Call_ServicesGetFeatureAvailibility_594442;
          apiVersion: string; featureName: string; serviceName: string): Recallable =
  ## servicesGetFeatureAvailibility
  ## Checks if the service has all the pre-requisites met to use a feature.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   featureName: string (required)
  ##              : The name of the feature.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594450 = newJObject()
  var query_594451 = newJObject()
  add(query_594451, "api-version", newJString(apiVersion))
  add(path_594450, "featureName", newJString(featureName))
  add(path_594450, "serviceName", newJString(serviceName))
  result = call_594449.call(path_594450, query_594451, nil, nil, nil)

var servicesGetFeatureAvailibility* = Call_ServicesGetFeatureAvailibility_594442(
    name: "servicesGetFeatureAvailibility", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/checkServiceFeatureAvailibility/{featureName}",
    validator: validate_ServicesGetFeatureAvailibility_594443, base: "",
    url: url_ServicesGetFeatureAvailibility_594444, schemes: {Scheme.Https})
type
  Call_ServicesListExportErrors_594452 = ref object of OpenApiRestCall_593438
proc url_ServicesListExportErrors_594454(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/exporterrors/counts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListExportErrors_594453(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the count of latest AAD export errors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594455 = path.getOrDefault("serviceName")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "serviceName", valid_594455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594456 = query.getOrDefault("api-version")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "api-version", valid_594456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594457: Call_ServicesListExportErrors_594452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the count of latest AAD export errors.
  ## 
  let valid = call_594457.validator(path, query, header, formData, body)
  let scheme = call_594457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594457.url(scheme.get, call_594457.host, call_594457.base,
                         call_594457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594457, url, valid)

proc call*(call_594458: Call_ServicesListExportErrors_594452; apiVersion: string;
          serviceName: string): Recallable =
  ## servicesListExportErrors
  ## Gets the count of latest AAD export errors.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594459 = newJObject()
  var query_594460 = newJObject()
  add(query_594460, "api-version", newJString(apiVersion))
  add(path_594459, "serviceName", newJString(serviceName))
  result = call_594458.call(path_594459, query_594460, nil, nil, nil)

var servicesListExportErrors* = Call_ServicesListExportErrors_594452(
    name: "servicesListExportErrors", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/exporterrors/counts",
    validator: validate_ServicesListExportErrors_594453, base: "",
    url: url_ServicesListExportErrors_594454, schemes: {Scheme.Https})
type
  Call_ServicesListExportErrorsV2_594461 = ref object of OpenApiRestCall_593438
proc url_ServicesListExportErrorsV2_594463(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/exporterrors/listV2")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListExportErrorsV2_594462(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ##  Gets the categorized export errors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594464 = path.getOrDefault("serviceName")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "serviceName", valid_594464
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   errorBucket: JString (required)
  ##              : The error category to query for.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594465 = query.getOrDefault("api-version")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "api-version", valid_594465
  var valid_594466 = query.getOrDefault("errorBucket")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "errorBucket", valid_594466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594467: Call_ServicesListExportErrorsV2_594461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ##  Gets the categorized export errors.
  ## 
  let valid = call_594467.validator(path, query, header, formData, body)
  let scheme = call_594467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594467.url(scheme.get, call_594467.host, call_594467.base,
                         call_594467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594467, url, valid)

proc call*(call_594468: Call_ServicesListExportErrorsV2_594461; apiVersion: string;
          errorBucket: string; serviceName: string): Recallable =
  ## servicesListExportErrorsV2
  ##  Gets the categorized export errors.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   errorBucket: string (required)
  ##              : The error category to query for.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594469 = newJObject()
  var query_594470 = newJObject()
  add(query_594470, "api-version", newJString(apiVersion))
  add(query_594470, "errorBucket", newJString(errorBucket))
  add(path_594469, "serviceName", newJString(serviceName))
  result = call_594468.call(path_594469, query_594470, nil, nil, nil)

var servicesListExportErrorsV2* = Call_ServicesListExportErrorsV2_594461(
    name: "servicesListExportErrorsV2", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/exporterrors/listV2",
    validator: validate_ServicesListExportErrorsV2_594462, base: "",
    url: url_ServicesListExportErrorsV2_594463, schemes: {Scheme.Https})
type
  Call_ServicesListExportStatus_594471 = ref object of OpenApiRestCall_593438
proc url_ServicesListExportStatus_594473(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/exportstatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListExportStatus_594472(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the export status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594474 = path.getOrDefault("serviceName")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "serviceName", valid_594474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594475 = query.getOrDefault("api-version")
  valid_594475 = validateParameter(valid_594475, JString, required = true,
                                 default = nil)
  if valid_594475 != nil:
    section.add "api-version", valid_594475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594476: Call_ServicesListExportStatus_594471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the export status.
  ## 
  let valid = call_594476.validator(path, query, header, formData, body)
  let scheme = call_594476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594476.url(scheme.get, call_594476.host, call_594476.base,
                         call_594476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594476, url, valid)

proc call*(call_594477: Call_ServicesListExportStatus_594471; apiVersion: string;
          serviceName: string): Recallable =
  ## servicesListExportStatus
  ## Gets the export status.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594478 = newJObject()
  var query_594479 = newJObject()
  add(query_594479, "api-version", newJString(apiVersion))
  add(path_594478, "serviceName", newJString(serviceName))
  result = call_594477.call(path_594478, query_594479, nil, nil, nil)

var servicesListExportStatus* = Call_ServicesListExportStatus_594471(
    name: "servicesListExportStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/exportstatus",
    validator: validate_ServicesListExportStatus_594472, base: "",
    url: url_ServicesListExportStatus_594473, schemes: {Scheme.Https})
type
  Call_ServicesAddAlertFeedback_594480 = ref object of OpenApiRestCall_593438
proc url_ServicesAddAlertFeedback_594482(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/feedbacktype/alerts/feedback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesAddAlertFeedback_594481(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds an alert feedback submitted by customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594483 = path.getOrDefault("serviceName")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "serviceName", valid_594483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594484 = query.getOrDefault("api-version")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = nil)
  if valid_594484 != nil:
    section.add "api-version", valid_594484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   alertFeedback: JObject (required)
  ##                : The alert feedback.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594486: Call_ServicesAddAlertFeedback_594480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an alert feedback submitted by customer.
  ## 
  let valid = call_594486.validator(path, query, header, formData, body)
  let scheme = call_594486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594486.url(scheme.get, call_594486.host, call_594486.base,
                         call_594486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594486, url, valid)

proc call*(call_594487: Call_ServicesAddAlertFeedback_594480;
          alertFeedback: JsonNode; apiVersion: string; serviceName: string): Recallable =
  ## servicesAddAlertFeedback
  ## Adds an alert feedback submitted by customer.
  ##   alertFeedback: JObject (required)
  ##                : The alert feedback.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594488 = newJObject()
  var query_594489 = newJObject()
  var body_594490 = newJObject()
  if alertFeedback != nil:
    body_594490 = alertFeedback
  add(query_594489, "api-version", newJString(apiVersion))
  add(path_594488, "serviceName", newJString(serviceName))
  result = call_594487.call(path_594488, query_594489, nil, nil, body_594490)

var servicesAddAlertFeedback* = Call_ServicesAddAlertFeedback_594480(
    name: "servicesAddAlertFeedback", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/feedbacktype/alerts/feedback",
    validator: validate_ServicesAddAlertFeedback_594481, base: "",
    url: url_ServicesAddAlertFeedback_594482, schemes: {Scheme.Https})
type
  Call_ServicesListAlertFeedback_594491 = ref object of OpenApiRestCall_593438
proc url_ServicesListAlertFeedback_594493(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "shortName" in path, "`shortName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/feedbacktype/alerts/"),
               (kind: VariableSegment, value: "shortName"),
               (kind: ConstantSegment, value: "/alertfeedback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListAlertFeedback_594492(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all alert feedback for a given tenant and alert type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shortName: JString (required)
  ##            : The name of the alert.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shortName` field"
  var valid_594494 = path.getOrDefault("shortName")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "shortName", valid_594494
  var valid_594495 = path.getOrDefault("serviceName")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "serviceName", valid_594495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594496 = query.getOrDefault("api-version")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "api-version", valid_594496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594497: Call_ServicesListAlertFeedback_594491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all alert feedback for a given tenant and alert type.
  ## 
  let valid = call_594497.validator(path, query, header, formData, body)
  let scheme = call_594497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594497.url(scheme.get, call_594497.host, call_594497.base,
                         call_594497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594497, url, valid)

proc call*(call_594498: Call_ServicesListAlertFeedback_594491; apiVersion: string;
          shortName: string; serviceName: string): Recallable =
  ## servicesListAlertFeedback
  ## Gets a list of all alert feedback for a given tenant and alert type.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   shortName: string (required)
  ##            : The name of the alert.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594499 = newJObject()
  var query_594500 = newJObject()
  add(query_594500, "api-version", newJString(apiVersion))
  add(path_594499, "shortName", newJString(shortName))
  add(path_594499, "serviceName", newJString(serviceName))
  result = call_594498.call(path_594499, query_594500, nil, nil, nil)

var servicesListAlertFeedback* = Call_ServicesListAlertFeedback_594491(
    name: "servicesListAlertFeedback", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/feedbacktype/alerts/{shortName}/alertfeedback",
    validator: validate_ServicesListAlertFeedback_594492, base: "",
    url: url_ServicesListAlertFeedback_594493, schemes: {Scheme.Https})
type
  Call_ServicesListMetricMetadata_594501 = ref object of OpenApiRestCall_593438
proc url_ServicesListMetricMetadata_594503(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/metricmetadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListMetricMetadata_594502(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service related metrics information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594504 = path.getOrDefault("serviceName")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "serviceName", valid_594504
  result.add "path", section
  ## parameters in `query` object:
  ##   perfCounter: JBool
  ##              : Indicates if only performance counter metrics are requested.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $filter: JString
  ##          : The metric metadata property filter to apply.
  section = newJObject()
  var valid_594505 = query.getOrDefault("perfCounter")
  valid_594505 = validateParameter(valid_594505, JBool, required = false, default = nil)
  if valid_594505 != nil:
    section.add "perfCounter", valid_594505
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594506 = query.getOrDefault("api-version")
  valid_594506 = validateParameter(valid_594506, JString, required = true,
                                 default = nil)
  if valid_594506 != nil:
    section.add "api-version", valid_594506
  var valid_594507 = query.getOrDefault("$filter")
  valid_594507 = validateParameter(valid_594507, JString, required = false,
                                 default = nil)
  if valid_594507 != nil:
    section.add "$filter", valid_594507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594508: Call_ServicesListMetricMetadata_594501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the service related metrics information.
  ## 
  let valid = call_594508.validator(path, query, header, formData, body)
  let scheme = call_594508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594508.url(scheme.get, call_594508.host, call_594508.base,
                         call_594508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594508, url, valid)

proc call*(call_594509: Call_ServicesListMetricMetadata_594501; apiVersion: string;
          serviceName: string; perfCounter: bool = false; Filter: string = ""): Recallable =
  ## servicesListMetricMetadata
  ## Gets the service related metrics information.
  ##   perfCounter: bool
  ##              : Indicates if only performance counter metrics are requested.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The metric metadata property filter to apply.
  var path_594510 = newJObject()
  var query_594511 = newJObject()
  add(query_594511, "perfCounter", newJBool(perfCounter))
  add(query_594511, "api-version", newJString(apiVersion))
  add(path_594510, "serviceName", newJString(serviceName))
  add(query_594511, "$filter", newJString(Filter))
  result = call_594509.call(path_594510, query_594511, nil, nil, nil)

var servicesListMetricMetadata* = Call_ServicesListMetricMetadata_594501(
    name: "servicesListMetricMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/metricmetadata",
    validator: validate_ServicesListMetricMetadata_594502, base: "",
    url: url_ServicesListMetricMetadata_594503, schemes: {Scheme.Https})
type
  Call_ServicesGetMetricMetadata_594512 = ref object of OpenApiRestCall_593438
proc url_ServicesGetMetricMetadata_594514(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/metricmetadata/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGetMetricMetadata_594513(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service related metrics information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metricName: JString (required)
  ##             : The metric name
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `metricName` field"
  var valid_594515 = path.getOrDefault("metricName")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = nil)
  if valid_594515 != nil:
    section.add "metricName", valid_594515
  var valid_594516 = path.getOrDefault("serviceName")
  valid_594516 = validateParameter(valid_594516, JString, required = true,
                                 default = nil)
  if valid_594516 != nil:
    section.add "serviceName", valid_594516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594517 = query.getOrDefault("api-version")
  valid_594517 = validateParameter(valid_594517, JString, required = true,
                                 default = nil)
  if valid_594517 != nil:
    section.add "api-version", valid_594517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594518: Call_ServicesGetMetricMetadata_594512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the service related metrics information.
  ## 
  let valid = call_594518.validator(path, query, header, formData, body)
  let scheme = call_594518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594518.url(scheme.get, call_594518.host, call_594518.base,
                         call_594518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594518, url, valid)

proc call*(call_594519: Call_ServicesGetMetricMetadata_594512; apiVersion: string;
          metricName: string; serviceName: string): Recallable =
  ## servicesGetMetricMetadata
  ## Gets the service related metrics information.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   metricName: string (required)
  ##             : The metric name
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594520 = newJObject()
  var query_594521 = newJObject()
  add(query_594521, "api-version", newJString(apiVersion))
  add(path_594520, "metricName", newJString(metricName))
  add(path_594520, "serviceName", newJString(serviceName))
  result = call_594519.call(path_594520, query_594521, nil, nil, nil)

var servicesGetMetricMetadata* = Call_ServicesGetMetricMetadata_594512(
    name: "servicesGetMetricMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/metricmetadata/{metricName}",
    validator: validate_ServicesGetMetricMetadata_594513, base: "",
    url: url_ServicesGetMetricMetadata_594514, schemes: {Scheme.Https})
type
  Call_ServicesGetMetricMetadataForGroup_594522 = ref object of OpenApiRestCall_593438
proc url_ServicesGetMetricMetadataForGroup_594524(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/metricmetadata/"),
               (kind: VariableSegment, value: "metricName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGetMetricMetadataForGroup_594523(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service related metrics for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : The group name
  ##   metricName: JString (required)
  ##             : The metric name
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_594525 = path.getOrDefault("groupName")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "groupName", valid_594525
  var valid_594526 = path.getOrDefault("metricName")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "metricName", valid_594526
  var valid_594527 = path.getOrDefault("serviceName")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "serviceName", valid_594527
  result.add "path", section
  ## parameters in `query` object:
  ##   groupKey: JString
  ##           : The group key
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   fromDate: JString
  ##           : The start date.
  ##   toDate: JString
  ##         : The end date.
  section = newJObject()
  var valid_594528 = query.getOrDefault("groupKey")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = nil)
  if valid_594528 != nil:
    section.add "groupKey", valid_594528
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594529 = query.getOrDefault("api-version")
  valid_594529 = validateParameter(valid_594529, JString, required = true,
                                 default = nil)
  if valid_594529 != nil:
    section.add "api-version", valid_594529
  var valid_594530 = query.getOrDefault("fromDate")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = nil)
  if valid_594530 != nil:
    section.add "fromDate", valid_594530
  var valid_594531 = query.getOrDefault("toDate")
  valid_594531 = validateParameter(valid_594531, JString, required = false,
                                 default = nil)
  if valid_594531 != nil:
    section.add "toDate", valid_594531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594532: Call_ServicesGetMetricMetadataForGroup_594522;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the service related metrics for a given metric and group combination.
  ## 
  let valid = call_594532.validator(path, query, header, formData, body)
  let scheme = call_594532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594532.url(scheme.get, call_594532.host, call_594532.base,
                         call_594532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594532, url, valid)

proc call*(call_594533: Call_ServicesGetMetricMetadataForGroup_594522;
          apiVersion: string; groupName: string; metricName: string;
          serviceName: string; groupKey: string = ""; fromDate: string = "";
          toDate: string = ""): Recallable =
  ## servicesGetMetricMetadataForGroup
  ## Gets the service related metrics for a given metric and group combination.
  ##   groupKey: string
  ##           : The group key
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   fromDate: string
  ##           : The start date.
  ##   groupName: string (required)
  ##            : The group name
  ##   metricName: string (required)
  ##             : The metric name
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   toDate: string
  ##         : The end date.
  var path_594534 = newJObject()
  var query_594535 = newJObject()
  add(query_594535, "groupKey", newJString(groupKey))
  add(query_594535, "api-version", newJString(apiVersion))
  add(query_594535, "fromDate", newJString(fromDate))
  add(path_594534, "groupName", newJString(groupName))
  add(path_594534, "metricName", newJString(metricName))
  add(path_594534, "serviceName", newJString(serviceName))
  add(query_594535, "toDate", newJString(toDate))
  result = call_594533.call(path_594534, query_594535, nil, nil, nil)

var servicesGetMetricMetadataForGroup* = Call_ServicesGetMetricMetadataForGroup_594522(
    name: "servicesGetMetricMetadataForGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/metricmetadata/{metricName}/groups/{groupName}",
    validator: validate_ServicesGetMetricMetadataForGroup_594523, base: "",
    url: url_ServicesGetMetricMetadataForGroup_594524, schemes: {Scheme.Https})
type
  Call_ServiceGetMetrics_594536 = ref object of OpenApiRestCall_593438
proc url_ServiceGetMetrics_594538(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/metrics/"),
               (kind: VariableSegment, value: "metricName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceGetMetrics_594537(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the server related metrics for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : The group name
  ##   metricName: JString (required)
  ##             : The metric name
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_594539 = path.getOrDefault("groupName")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "groupName", valid_594539
  var valid_594540 = path.getOrDefault("metricName")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "metricName", valid_594540
  var valid_594541 = path.getOrDefault("serviceName")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "serviceName", valid_594541
  result.add "path", section
  ## parameters in `query` object:
  ##   groupKey: JString
  ##           : The group key
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   fromDate: JString
  ##           : The start date.
  ##   toDate: JString
  ##         : The end date.
  section = newJObject()
  var valid_594542 = query.getOrDefault("groupKey")
  valid_594542 = validateParameter(valid_594542, JString, required = false,
                                 default = nil)
  if valid_594542 != nil:
    section.add "groupKey", valid_594542
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594543 = query.getOrDefault("api-version")
  valid_594543 = validateParameter(valid_594543, JString, required = true,
                                 default = nil)
  if valid_594543 != nil:
    section.add "api-version", valid_594543
  var valid_594544 = query.getOrDefault("fromDate")
  valid_594544 = validateParameter(valid_594544, JString, required = false,
                                 default = nil)
  if valid_594544 != nil:
    section.add "fromDate", valid_594544
  var valid_594545 = query.getOrDefault("toDate")
  valid_594545 = validateParameter(valid_594545, JString, required = false,
                                 default = nil)
  if valid_594545 != nil:
    section.add "toDate", valid_594545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594546: Call_ServiceGetMetrics_594536; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the server related metrics for a given metric and group combination.
  ## 
  let valid = call_594546.validator(path, query, header, formData, body)
  let scheme = call_594546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594546.url(scheme.get, call_594546.host, call_594546.base,
                         call_594546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594546, url, valid)

proc call*(call_594547: Call_ServiceGetMetrics_594536; apiVersion: string;
          groupName: string; metricName: string; serviceName: string;
          groupKey: string = ""; fromDate: string = ""; toDate: string = ""): Recallable =
  ## serviceGetMetrics
  ## Gets the server related metrics for a given metric and group combination.
  ##   groupKey: string
  ##           : The group key
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   fromDate: string
  ##           : The start date.
  ##   groupName: string (required)
  ##            : The group name
  ##   metricName: string (required)
  ##             : The metric name
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   toDate: string
  ##         : The end date.
  var path_594548 = newJObject()
  var query_594549 = newJObject()
  add(query_594549, "groupKey", newJString(groupKey))
  add(query_594549, "api-version", newJString(apiVersion))
  add(query_594549, "fromDate", newJString(fromDate))
  add(path_594548, "groupName", newJString(groupName))
  add(path_594548, "metricName", newJString(metricName))
  add(path_594548, "serviceName", newJString(serviceName))
  add(query_594549, "toDate", newJString(toDate))
  result = call_594547.call(path_594548, query_594549, nil, nil, nil)

var serviceGetMetrics* = Call_ServiceGetMetrics_594536(name: "serviceGetMetrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/metrics/{metricName}/groups/{groupName}",
    validator: validate_ServiceGetMetrics_594537, base: "",
    url: url_ServiceGetMetrics_594538, schemes: {Scheme.Https})
type
  Call_ServicesListMetricsAverage_594550 = ref object of OpenApiRestCall_593438
proc url_ServicesListMetricsAverage_594552(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/metrics/"),
               (kind: VariableSegment, value: "metricName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/average")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListMetricsAverage_594551(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the average of the metric values for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : The group name
  ##   metricName: JString (required)
  ##             : The metric name
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_594553 = path.getOrDefault("groupName")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "groupName", valid_594553
  var valid_594554 = path.getOrDefault("metricName")
  valid_594554 = validateParameter(valid_594554, JString, required = true,
                                 default = nil)
  if valid_594554 != nil:
    section.add "metricName", valid_594554
  var valid_594555 = path.getOrDefault("serviceName")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = nil)
  if valid_594555 != nil:
    section.add "serviceName", valid_594555
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594556 = query.getOrDefault("api-version")
  valid_594556 = validateParameter(valid_594556, JString, required = true,
                                 default = nil)
  if valid_594556 != nil:
    section.add "api-version", valid_594556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594557: Call_ServicesListMetricsAverage_594550; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the average of the metric values for a given metric and group combination.
  ## 
  let valid = call_594557.validator(path, query, header, formData, body)
  let scheme = call_594557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594557.url(scheme.get, call_594557.host, call_594557.base,
                         call_594557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594557, url, valid)

proc call*(call_594558: Call_ServicesListMetricsAverage_594550; apiVersion: string;
          groupName: string; metricName: string; serviceName: string): Recallable =
  ## servicesListMetricsAverage
  ## Gets the average of the metric values for a given metric and group combination.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   groupName: string (required)
  ##            : The group name
  ##   metricName: string (required)
  ##             : The metric name
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594559 = newJObject()
  var query_594560 = newJObject()
  add(query_594560, "api-version", newJString(apiVersion))
  add(path_594559, "groupName", newJString(groupName))
  add(path_594559, "metricName", newJString(metricName))
  add(path_594559, "serviceName", newJString(serviceName))
  result = call_594558.call(path_594559, query_594560, nil, nil, nil)

var servicesListMetricsAverage* = Call_ServicesListMetricsAverage_594550(
    name: "servicesListMetricsAverage", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/metrics/{metricName}/groups/{groupName}/average",
    validator: validate_ServicesListMetricsAverage_594551, base: "",
    url: url_ServicesListMetricsAverage_594552, schemes: {Scheme.Https})
type
  Call_ServicesListMetricsSum_594561 = ref object of OpenApiRestCall_593438
proc url_ServicesListMetricsSum_594563(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/metrics/"),
               (kind: VariableSegment, value: "metricName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/sum")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListMetricsSum_594562(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the sum of the metric values for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : The group name
  ##   metricName: JString (required)
  ##             : The metric name
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_594564 = path.getOrDefault("groupName")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "groupName", valid_594564
  var valid_594565 = path.getOrDefault("metricName")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "metricName", valid_594565
  var valid_594566 = path.getOrDefault("serviceName")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "serviceName", valid_594566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594567 = query.getOrDefault("api-version")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "api-version", valid_594567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594568: Call_ServicesListMetricsSum_594561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the sum of the metric values for a given metric and group combination.
  ## 
  let valid = call_594568.validator(path, query, header, formData, body)
  let scheme = call_594568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594568.url(scheme.get, call_594568.host, call_594568.base,
                         call_594568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594568, url, valid)

proc call*(call_594569: Call_ServicesListMetricsSum_594561; apiVersion: string;
          groupName: string; metricName: string; serviceName: string): Recallable =
  ## servicesListMetricsSum
  ## Gets the sum of the metric values for a given metric and group combination.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   groupName: string (required)
  ##            : The group name
  ##   metricName: string (required)
  ##             : The metric name
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594570 = newJObject()
  var query_594571 = newJObject()
  add(query_594571, "api-version", newJString(apiVersion))
  add(path_594570, "groupName", newJString(groupName))
  add(path_594570, "metricName", newJString(metricName))
  add(path_594570, "serviceName", newJString(serviceName))
  result = call_594569.call(path_594570, query_594571, nil, nil, nil)

var servicesListMetricsSum* = Call_ServicesListMetricsSum_594561(
    name: "servicesListMetricsSum", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/metrics/{metricName}/groups/{groupName}/sum",
    validator: validate_ServicesListMetricsSum_594562, base: "",
    url: url_ServicesListMetricsSum_594563, schemes: {Scheme.Https})
type
  Call_ServicesUpdateMonitoringConfiguration_594572 = ref object of OpenApiRestCall_593438
proc url_ServicesUpdateMonitoringConfiguration_594574(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/monitoringconfiguration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesUpdateMonitoringConfiguration_594573(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the service level monitoring configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594575 = path.getOrDefault("serviceName")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "serviceName", valid_594575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594576 = query.getOrDefault("api-version")
  valid_594576 = validateParameter(valid_594576, JString, required = true,
                                 default = nil)
  if valid_594576 != nil:
    section.add "api-version", valid_594576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   configurationSetting: JObject (required)
  ##                       : The monitoring configuration to update
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594578: Call_ServicesUpdateMonitoringConfiguration_594572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the service level monitoring configuration.
  ## 
  let valid = call_594578.validator(path, query, header, formData, body)
  let scheme = call_594578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594578.url(scheme.get, call_594578.host, call_594578.base,
                         call_594578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594578, url, valid)

proc call*(call_594579: Call_ServicesUpdateMonitoringConfiguration_594572;
          apiVersion: string; configurationSetting: JsonNode; serviceName: string): Recallable =
  ## servicesUpdateMonitoringConfiguration
  ## Updates the service level monitoring configuration.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   configurationSetting: JObject (required)
  ##                       : The monitoring configuration to update
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594580 = newJObject()
  var query_594581 = newJObject()
  var body_594582 = newJObject()
  add(query_594581, "api-version", newJString(apiVersion))
  if configurationSetting != nil:
    body_594582 = configurationSetting
  add(path_594580, "serviceName", newJString(serviceName))
  result = call_594579.call(path_594580, query_594581, nil, nil, body_594582)

var servicesUpdateMonitoringConfiguration* = Call_ServicesUpdateMonitoringConfiguration_594572(
    name: "servicesUpdateMonitoringConfiguration", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/monitoringconfiguration",
    validator: validate_ServicesUpdateMonitoringConfiguration_594573, base: "",
    url: url_ServicesUpdateMonitoringConfiguration_594574, schemes: {Scheme.Https})
type
  Call_ServicesListMonitoringConfigurations_594583 = ref object of OpenApiRestCall_593438
proc url_ServicesListMonitoringConfigurations_594585(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/monitoringconfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListMonitoringConfigurations_594584(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service level monitoring configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594586 = path.getOrDefault("serviceName")
  valid_594586 = validateParameter(valid_594586, JString, required = true,
                                 default = nil)
  if valid_594586 != nil:
    section.add "serviceName", valid_594586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594587 = query.getOrDefault("api-version")
  valid_594587 = validateParameter(valid_594587, JString, required = true,
                                 default = nil)
  if valid_594587 != nil:
    section.add "api-version", valid_594587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594588: Call_ServicesListMonitoringConfigurations_594583;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the service level monitoring configurations.
  ## 
  let valid = call_594588.validator(path, query, header, formData, body)
  let scheme = call_594588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594588.url(scheme.get, call_594588.host, call_594588.base,
                         call_594588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594588, url, valid)

proc call*(call_594589: Call_ServicesListMonitoringConfigurations_594583;
          apiVersion: string; serviceName: string): Recallable =
  ## servicesListMonitoringConfigurations
  ## Gets the service level monitoring configurations.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594590 = newJObject()
  var query_594591 = newJObject()
  add(query_594591, "api-version", newJString(apiVersion))
  add(path_594590, "serviceName", newJString(serviceName))
  result = call_594589.call(path_594590, query_594591, nil, nil, nil)

var servicesListMonitoringConfigurations* = Call_ServicesListMonitoringConfigurations_594583(
    name: "servicesListMonitoringConfigurations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/monitoringconfigurations",
    validator: validate_ServicesListMonitoringConfigurations_594584, base: "",
    url: url_ServicesListMonitoringConfigurations_594585, schemes: {Scheme.Https})
type
  Call_ServicesListUserBadPasswordReport_594592 = ref object of OpenApiRestCall_593438
proc url_ServicesListUserBadPasswordReport_594594(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/reports/badpassword/details/user")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListUserBadPasswordReport_594593(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the bad password login attempt report for an user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594595 = path.getOrDefault("serviceName")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "serviceName", valid_594595
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   dataSource: JString
  ##             : The source of data, if its test data or customer data.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594596 = query.getOrDefault("api-version")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "api-version", valid_594596
  var valid_594597 = query.getOrDefault("dataSource")
  valid_594597 = validateParameter(valid_594597, JString, required = false,
                                 default = nil)
  if valid_594597 != nil:
    section.add "dataSource", valid_594597
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594598: Call_ServicesListUserBadPasswordReport_594592;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the bad password login attempt report for an user
  ## 
  let valid = call_594598.validator(path, query, header, formData, body)
  let scheme = call_594598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594598.url(scheme.get, call_594598.host, call_594598.base,
                         call_594598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594598, url, valid)

proc call*(call_594599: Call_ServicesListUserBadPasswordReport_594592;
          apiVersion: string; serviceName: string; dataSource: string = ""): Recallable =
  ## servicesListUserBadPasswordReport
  ## Gets the bad password login attempt report for an user
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   dataSource: string
  ##             : The source of data, if its test data or customer data.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594600 = newJObject()
  var query_594601 = newJObject()
  add(query_594601, "api-version", newJString(apiVersion))
  add(query_594601, "dataSource", newJString(dataSource))
  add(path_594600, "serviceName", newJString(serviceName))
  result = call_594599.call(path_594600, query_594601, nil, nil, nil)

var servicesListUserBadPasswordReport* = Call_ServicesListUserBadPasswordReport_594592(
    name: "servicesListUserBadPasswordReport", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/reports/badpassword/details/user",
    validator: validate_ServicesListUserBadPasswordReport_594593, base: "",
    url: url_ServicesListUserBadPasswordReport_594594, schemes: {Scheme.Https})
type
  Call_ServicesListAllRiskyIpDownloadReport_594602 = ref object of OpenApiRestCall_593438
proc url_ServicesListAllRiskyIpDownloadReport_594604(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/reports/riskyIp/blobUris")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListAllRiskyIpDownloadReport_594603(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Risky IP report URIs for the last 7 days.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594605 = path.getOrDefault("serviceName")
  valid_594605 = validateParameter(valid_594605, JString, required = true,
                                 default = nil)
  if valid_594605 != nil:
    section.add "serviceName", valid_594605
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594606 = query.getOrDefault("api-version")
  valid_594606 = validateParameter(valid_594606, JString, required = true,
                                 default = nil)
  if valid_594606 != nil:
    section.add "api-version", valid_594606
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594607: Call_ServicesListAllRiskyIpDownloadReport_594602;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all Risky IP report URIs for the last 7 days.
  ## 
  let valid = call_594607.validator(path, query, header, formData, body)
  let scheme = call_594607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594607.url(scheme.get, call_594607.host, call_594607.base,
                         call_594607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594607, url, valid)

proc call*(call_594608: Call_ServicesListAllRiskyIpDownloadReport_594602;
          apiVersion: string; serviceName: string): Recallable =
  ## servicesListAllRiskyIpDownloadReport
  ## Gets all Risky IP report URIs for the last 7 days.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594609 = newJObject()
  var query_594610 = newJObject()
  add(query_594610, "api-version", newJString(apiVersion))
  add(path_594609, "serviceName", newJString(serviceName))
  result = call_594608.call(path_594609, query_594610, nil, nil, nil)

var servicesListAllRiskyIpDownloadReport* = Call_ServicesListAllRiskyIpDownloadReport_594602(
    name: "servicesListAllRiskyIpDownloadReport", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/reports/riskyIp/blobUris",
    validator: validate_ServicesListAllRiskyIpDownloadReport_594603, base: "",
    url: url_ServicesListAllRiskyIpDownloadReport_594604, schemes: {Scheme.Https})
type
  Call_ServicesListCurrentRiskyIpDownloadReport_594611 = ref object of OpenApiRestCall_593438
proc url_ServicesListCurrentRiskyIpDownloadReport_594613(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/reports/riskyIp/generateBlobUri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListCurrentRiskyIpDownloadReport_594612(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiate the generation of a new Risky IP report. Returns the URI for the new one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594614 = path.getOrDefault("serviceName")
  valid_594614 = validateParameter(valid_594614, JString, required = true,
                                 default = nil)
  if valid_594614 != nil:
    section.add "serviceName", valid_594614
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594615 = query.getOrDefault("api-version")
  valid_594615 = validateParameter(valid_594615, JString, required = true,
                                 default = nil)
  if valid_594615 != nil:
    section.add "api-version", valid_594615
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594616: Call_ServicesListCurrentRiskyIpDownloadReport_594611;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Initiate the generation of a new Risky IP report. Returns the URI for the new one.
  ## 
  let valid = call_594616.validator(path, query, header, formData, body)
  let scheme = call_594616.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594616.url(scheme.get, call_594616.host, call_594616.base,
                         call_594616.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594616, url, valid)

proc call*(call_594617: Call_ServicesListCurrentRiskyIpDownloadReport_594611;
          apiVersion: string; serviceName: string): Recallable =
  ## servicesListCurrentRiskyIpDownloadReport
  ## Initiate the generation of a new Risky IP report. Returns the URI for the new one.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594618 = newJObject()
  var query_594619 = newJObject()
  add(query_594619, "api-version", newJString(apiVersion))
  add(path_594618, "serviceName", newJString(serviceName))
  result = call_594617.call(path_594618, query_594619, nil, nil, nil)

var servicesListCurrentRiskyIpDownloadReport* = Call_ServicesListCurrentRiskyIpDownloadReport_594611(
    name: "servicesListCurrentRiskyIpDownloadReport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/reports/riskyIp/generateBlobUri",
    validator: validate_ServicesListCurrentRiskyIpDownloadReport_594612, base: "",
    url: url_ServicesListCurrentRiskyIpDownloadReport_594613,
    schemes: {Scheme.Https})
type
  Call_ServiceMembersAdd_594632 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersAdd_594634(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersAdd_594633(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Onboards  a server, for a given service, to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service under which the server is to be onboarded.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594635 = path.getOrDefault("serviceName")
  valid_594635 = validateParameter(valid_594635, JString, required = true,
                                 default = nil)
  if valid_594635 != nil:
    section.add "serviceName", valid_594635
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594636 = query.getOrDefault("api-version")
  valid_594636 = validateParameter(valid_594636, JString, required = true,
                                 default = nil)
  if valid_594636 != nil:
    section.add "api-version", valid_594636
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceMember: JObject (required)
  ##                : The server object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594638: Call_ServiceMembersAdd_594632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Onboards  a server, for a given service, to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_594638.validator(path, query, header, formData, body)
  let scheme = call_594638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594638.url(scheme.get, call_594638.host, call_594638.base,
                         call_594638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594638, url, valid)

proc call*(call_594639: Call_ServiceMembersAdd_594632; apiVersion: string;
          serviceMember: JsonNode; serviceName: string): Recallable =
  ## serviceMembersAdd
  ## Onboards  a server, for a given service, to Azure Active Directory Connect Health Service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMember: JObject (required)
  ##                : The server object.
  ##   serviceName: string (required)
  ##              : The name of the service under which the server is to be onboarded.
  var path_594640 = newJObject()
  var query_594641 = newJObject()
  var body_594642 = newJObject()
  add(query_594641, "api-version", newJString(apiVersion))
  if serviceMember != nil:
    body_594642 = serviceMember
  add(path_594640, "serviceName", newJString(serviceName))
  result = call_594639.call(path_594640, query_594641, nil, nil, body_594642)

var serviceMembersAdd* = Call_ServiceMembersAdd_594632(name: "serviceMembersAdd",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers",
    validator: validate_ServiceMembersAdd_594633, base: "",
    url: url_ServiceMembersAdd_594634, schemes: {Scheme.Https})
type
  Call_ServiceMembersList_594620 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersList_594622(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersList_594621(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the details of the servers, for a given service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594623 = path.getOrDefault("serviceName")
  valid_594623 = validateParameter(valid_594623, JString, required = true,
                                 default = nil)
  if valid_594623 != nil:
    section.add "serviceName", valid_594623
  result.add "path", section
  ## parameters in `query` object:
  ##   dimensionType: JString
  ##                : The server specific dimension.
  ##   dimensionSignature: JString
  ##                     : The value of the dimension.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $filter: JString
  ##          : The server property filter to apply.
  section = newJObject()
  var valid_594624 = query.getOrDefault("dimensionType")
  valid_594624 = validateParameter(valid_594624, JString, required = false,
                                 default = nil)
  if valid_594624 != nil:
    section.add "dimensionType", valid_594624
  var valid_594625 = query.getOrDefault("dimensionSignature")
  valid_594625 = validateParameter(valid_594625, JString, required = false,
                                 default = nil)
  if valid_594625 != nil:
    section.add "dimensionSignature", valid_594625
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594626 = query.getOrDefault("api-version")
  valid_594626 = validateParameter(valid_594626, JString, required = true,
                                 default = nil)
  if valid_594626 != nil:
    section.add "api-version", valid_594626
  var valid_594627 = query.getOrDefault("$filter")
  valid_594627 = validateParameter(valid_594627, JString, required = false,
                                 default = nil)
  if valid_594627 != nil:
    section.add "$filter", valid_594627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594628: Call_ServiceMembersList_594620; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the servers, for a given service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_594628.validator(path, query, header, formData, body)
  let scheme = call_594628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594628.url(scheme.get, call_594628.host, call_594628.base,
                         call_594628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594628, url, valid)

proc call*(call_594629: Call_ServiceMembersList_594620; apiVersion: string;
          serviceName: string; dimensionType: string = "";
          dimensionSignature: string = ""; Filter: string = ""): Recallable =
  ## serviceMembersList
  ## Gets the details of the servers, for a given service, that are onboarded to Azure Active Directory Connect Health Service.
  ##   dimensionType: string
  ##                : The server specific dimension.
  ##   dimensionSignature: string
  ##                     : The value of the dimension.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The server property filter to apply.
  var path_594630 = newJObject()
  var query_594631 = newJObject()
  add(query_594631, "dimensionType", newJString(dimensionType))
  add(query_594631, "dimensionSignature", newJString(dimensionSignature))
  add(query_594631, "api-version", newJString(apiVersion))
  add(path_594630, "serviceName", newJString(serviceName))
  add(query_594631, "$filter", newJString(Filter))
  result = call_594629.call(path_594630, query_594631, nil, nil, nil)

var serviceMembersList* = Call_ServiceMembersList_594620(
    name: "serviceMembersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers",
    validator: validate_ServiceMembersList_594621, base: "",
    url: url_ServiceMembersList_594622, schemes: {Scheme.Https})
type
  Call_ServiceMembersGet_594643 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersGet_594645(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersGet_594644(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the details of a server, for a given service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594646 = path.getOrDefault("serviceMemberId")
  valid_594646 = validateParameter(valid_594646, JString, required = true,
                                 default = nil)
  if valid_594646 != nil:
    section.add "serviceMemberId", valid_594646
  var valid_594647 = path.getOrDefault("serviceName")
  valid_594647 = validateParameter(valid_594647, JString, required = true,
                                 default = nil)
  if valid_594647 != nil:
    section.add "serviceName", valid_594647
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594648 = query.getOrDefault("api-version")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "api-version", valid_594648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594649: Call_ServiceMembersGet_594643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a server, for a given service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_594649.validator(path, query, header, formData, body)
  let scheme = call_594649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594649.url(scheme.get, call_594649.host, call_594649.base,
                         call_594649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594649, url, valid)

proc call*(call_594650: Call_ServiceMembersGet_594643; apiVersion: string;
          serviceMemberId: string; serviceName: string): Recallable =
  ## serviceMembersGet
  ## Gets the details of a server, for a given service, that are onboarded to Azure Active Directory Connect Health Service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594651 = newJObject()
  var query_594652 = newJObject()
  add(query_594652, "api-version", newJString(apiVersion))
  add(path_594651, "serviceMemberId", newJString(serviceMemberId))
  add(path_594651, "serviceName", newJString(serviceName))
  result = call_594650.call(path_594651, query_594652, nil, nil, nil)

var serviceMembersGet* = Call_ServiceMembersGet_594643(name: "serviceMembersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}",
    validator: validate_ServiceMembersGet_594644, base: "",
    url: url_ServiceMembersGet_594645, schemes: {Scheme.Https})
type
  Call_ServiceMembersDelete_594653 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersDelete_594655(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersDelete_594654(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a server that has been onboarded to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594656 = path.getOrDefault("serviceMemberId")
  valid_594656 = validateParameter(valid_594656, JString, required = true,
                                 default = nil)
  if valid_594656 != nil:
    section.add "serviceMemberId", valid_594656
  var valid_594657 = path.getOrDefault("serviceName")
  valid_594657 = validateParameter(valid_594657, JString, required = true,
                                 default = nil)
  if valid_594657 != nil:
    section.add "serviceName", valid_594657
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   confirm: JBool
  ##          : Indicates if the server will be permanently deleted or disabled. True indicates that the server will be permanently deleted and False indicates that the server will be marked disabled and then deleted after 30 days, if it is not re-registered.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594658 = query.getOrDefault("api-version")
  valid_594658 = validateParameter(valid_594658, JString, required = true,
                                 default = nil)
  if valid_594658 != nil:
    section.add "api-version", valid_594658
  var valid_594659 = query.getOrDefault("confirm")
  valid_594659 = validateParameter(valid_594659, JBool, required = false, default = nil)
  if valid_594659 != nil:
    section.add "confirm", valid_594659
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594660: Call_ServiceMembersDelete_594653; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a server that has been onboarded to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_594660.validator(path, query, header, formData, body)
  let scheme = call_594660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594660.url(scheme.get, call_594660.host, call_594660.base,
                         call_594660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594660, url, valid)

proc call*(call_594661: Call_ServiceMembersDelete_594653; apiVersion: string;
          serviceMemberId: string; serviceName: string; confirm: bool = false): Recallable =
  ## serviceMembersDelete
  ## Deletes a server that has been onboarded to Azure Active Directory Connect Health Service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  ##   confirm: bool
  ##          : Indicates if the server will be permanently deleted or disabled. True indicates that the server will be permanently deleted and False indicates that the server will be marked disabled and then deleted after 30 days, if it is not re-registered.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594662 = newJObject()
  var query_594663 = newJObject()
  add(query_594663, "api-version", newJString(apiVersion))
  add(path_594662, "serviceMemberId", newJString(serviceMemberId))
  add(query_594663, "confirm", newJBool(confirm))
  add(path_594662, "serviceName", newJString(serviceName))
  result = call_594661.call(path_594662, query_594663, nil, nil, nil)

var serviceMembersDelete* = Call_ServiceMembersDelete_594653(
    name: "serviceMembersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}",
    validator: validate_ServiceMembersDelete_594654, base: "",
    url: url_ServiceMembersDelete_594655, schemes: {Scheme.Https})
type
  Call_ServiceMembersListAlerts_594664 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersListAlerts_594666(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersListAlerts_594665(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an alert for a given service and server combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id for which the alert details needs to be queried.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594667 = path.getOrDefault("serviceMemberId")
  valid_594667 = validateParameter(valid_594667, JString, required = true,
                                 default = nil)
  if valid_594667 != nil:
    section.add "serviceMemberId", valid_594667
  var valid_594668 = path.getOrDefault("serviceName")
  valid_594668 = validateParameter(valid_594668, JString, required = true,
                                 default = nil)
  if valid_594668 != nil:
    section.add "serviceName", valid_594668
  result.add "path", section
  ## parameters in `query` object:
  ##   to: JString
  ##     : The end date till when to query for.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   from: JString
  ##       : The start date to query for.
  ##   $filter: JString
  ##          : The alert property filter to apply.
  ##   state: JString
  ##        : The alert state to query for.
  section = newJObject()
  var valid_594669 = query.getOrDefault("to")
  valid_594669 = validateParameter(valid_594669, JString, required = false,
                                 default = nil)
  if valid_594669 != nil:
    section.add "to", valid_594669
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594670 = query.getOrDefault("api-version")
  valid_594670 = validateParameter(valid_594670, JString, required = true,
                                 default = nil)
  if valid_594670 != nil:
    section.add "api-version", valid_594670
  var valid_594671 = query.getOrDefault("from")
  valid_594671 = validateParameter(valid_594671, JString, required = false,
                                 default = nil)
  if valid_594671 != nil:
    section.add "from", valid_594671
  var valid_594672 = query.getOrDefault("$filter")
  valid_594672 = validateParameter(valid_594672, JString, required = false,
                                 default = nil)
  if valid_594672 != nil:
    section.add "$filter", valid_594672
  var valid_594673 = query.getOrDefault("state")
  valid_594673 = validateParameter(valid_594673, JString, required = false,
                                 default = nil)
  if valid_594673 != nil:
    section.add "state", valid_594673
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594674: Call_ServiceMembersListAlerts_594664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an alert for a given service and server combination.
  ## 
  let valid = call_594674.validator(path, query, header, formData, body)
  let scheme = call_594674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594674.url(scheme.get, call_594674.host, call_594674.base,
                         call_594674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594674, url, valid)

proc call*(call_594675: Call_ServiceMembersListAlerts_594664; apiVersion: string;
          serviceMemberId: string; serviceName: string; to: string = "";
          `from`: string = ""; Filter: string = ""; state: string = ""): Recallable =
  ## serviceMembersListAlerts
  ## Gets the details of an alert for a given service and server combination.
  ##   to: string
  ##     : The end date till when to query for.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   from: string
  ##       : The start date to query for.
  ##   serviceMemberId: string (required)
  ##                  : The server Id for which the alert details needs to be queried.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The alert property filter to apply.
  ##   state: string
  ##        : The alert state to query for.
  var path_594676 = newJObject()
  var query_594677 = newJObject()
  add(query_594677, "to", newJString(to))
  add(query_594677, "api-version", newJString(apiVersion))
  add(query_594677, "from", newJString(`from`))
  add(path_594676, "serviceMemberId", newJString(serviceMemberId))
  add(path_594676, "serviceName", newJString(serviceName))
  add(query_594677, "$filter", newJString(Filter))
  add(query_594677, "state", newJString(state))
  result = call_594675.call(path_594676, query_594677, nil, nil, nil)

var serviceMembersListAlerts* = Call_ServiceMembersListAlerts_594664(
    name: "serviceMembersListAlerts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/alerts",
    validator: validate_ServiceMembersListAlerts_594665, base: "",
    url: url_ServiceMembersListAlerts_594666, schemes: {Scheme.Https})
type
  Call_ServiceMembersListCredentials_594678 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersListCredentials_594680(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId"),
               (kind: ConstantSegment, value: "/credentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersListCredentials_594679(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the credentials of the server which is needed by the agent to connect to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594681 = path.getOrDefault("serviceMemberId")
  valid_594681 = validateParameter(valid_594681, JString, required = true,
                                 default = nil)
  if valid_594681 != nil:
    section.add "serviceMemberId", valid_594681
  var valid_594682 = path.getOrDefault("serviceName")
  valid_594682 = validateParameter(valid_594682, JString, required = true,
                                 default = nil)
  if valid_594682 != nil:
    section.add "serviceName", valid_594682
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $filter: JString
  ##          : The property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594683 = query.getOrDefault("api-version")
  valid_594683 = validateParameter(valid_594683, JString, required = true,
                                 default = nil)
  if valid_594683 != nil:
    section.add "api-version", valid_594683
  var valid_594684 = query.getOrDefault("$filter")
  valid_594684 = validateParameter(valid_594684, JString, required = false,
                                 default = nil)
  if valid_594684 != nil:
    section.add "$filter", valid_594684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594685: Call_ServiceMembersListCredentials_594678; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the credentials of the server which is needed by the agent to connect to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_594685.validator(path, query, header, formData, body)
  let scheme = call_594685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594685.url(scheme.get, call_594685.host, call_594685.base,
                         call_594685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594685, url, valid)

proc call*(call_594686: Call_ServiceMembersListCredentials_594678;
          apiVersion: string; serviceMemberId: string; serviceName: string;
          Filter: string = ""): Recallable =
  ## serviceMembersListCredentials
  ## Gets the credentials of the server which is needed by the agent to connect to Azure Active Directory Connect Health Service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   Filter: string
  ##         : The property filter to apply.
  var path_594687 = newJObject()
  var query_594688 = newJObject()
  add(query_594688, "api-version", newJString(apiVersion))
  add(path_594687, "serviceMemberId", newJString(serviceMemberId))
  add(path_594687, "serviceName", newJString(serviceName))
  add(query_594688, "$filter", newJString(Filter))
  result = call_594686.call(path_594687, query_594688, nil, nil, nil)

var serviceMembersListCredentials* = Call_ServiceMembersListCredentials_594678(
    name: "serviceMembersListCredentials", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/credentials",
    validator: validate_ServiceMembersListCredentials_594679, base: "",
    url: url_ServiceMembersListCredentials_594680, schemes: {Scheme.Https})
type
  Call_ServiceMembersDeleteData_594689 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersDeleteData_594691(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId"),
               (kind: ConstantSegment, value: "/data")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersDeleteData_594690(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the data uploaded by the server to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594692 = path.getOrDefault("serviceMemberId")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = nil)
  if valid_594692 != nil:
    section.add "serviceMemberId", valid_594692
  var valid_594693 = path.getOrDefault("serviceName")
  valid_594693 = validateParameter(valid_594693, JString, required = true,
                                 default = nil)
  if valid_594693 != nil:
    section.add "serviceName", valid_594693
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594694 = query.getOrDefault("api-version")
  valid_594694 = validateParameter(valid_594694, JString, required = true,
                                 default = nil)
  if valid_594694 != nil:
    section.add "api-version", valid_594694
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594695: Call_ServiceMembersDeleteData_594689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the data uploaded by the server to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_594695.validator(path, query, header, formData, body)
  let scheme = call_594695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594695.url(scheme.get, call_594695.host, call_594695.base,
                         call_594695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594695, url, valid)

proc call*(call_594696: Call_ServiceMembersDeleteData_594689; apiVersion: string;
          serviceMemberId: string; serviceName: string): Recallable =
  ## serviceMembersDeleteData
  ## Deletes the data uploaded by the server to Azure Active Directory Connect Health Service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594697 = newJObject()
  var query_594698 = newJObject()
  add(query_594698, "api-version", newJString(apiVersion))
  add(path_594697, "serviceMemberId", newJString(serviceMemberId))
  add(path_594697, "serviceName", newJString(serviceName))
  result = call_594696.call(path_594697, query_594698, nil, nil, nil)

var serviceMembersDeleteData* = Call_ServiceMembersDeleteData_594689(
    name: "serviceMembersDeleteData", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/data",
    validator: validate_ServiceMembersDeleteData_594690, base: "",
    url: url_ServiceMembersDeleteData_594691, schemes: {Scheme.Https})
type
  Call_ServiceMembersListDataFreshness_594699 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersListDataFreshness_594701(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId"),
               (kind: ConstantSegment, value: "/datafreshness")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersListDataFreshness_594700(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the last time when the server uploaded data to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594702 = path.getOrDefault("serviceMemberId")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "serviceMemberId", valid_594702
  var valid_594703 = path.getOrDefault("serviceName")
  valid_594703 = validateParameter(valid_594703, JString, required = true,
                                 default = nil)
  if valid_594703 != nil:
    section.add "serviceName", valid_594703
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594704 = query.getOrDefault("api-version")
  valid_594704 = validateParameter(valid_594704, JString, required = true,
                                 default = nil)
  if valid_594704 != nil:
    section.add "api-version", valid_594704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594705: Call_ServiceMembersListDataFreshness_594699;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the last time when the server uploaded data to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_594705.validator(path, query, header, formData, body)
  let scheme = call_594705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594705.url(scheme.get, call_594705.host, call_594705.base,
                         call_594705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594705, url, valid)

proc call*(call_594706: Call_ServiceMembersListDataFreshness_594699;
          apiVersion: string; serviceMemberId: string; serviceName: string): Recallable =
  ## serviceMembersListDataFreshness
  ## Gets the last time when the server uploaded data to Azure Active Directory Connect Health Service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594707 = newJObject()
  var query_594708 = newJObject()
  add(query_594708, "api-version", newJString(apiVersion))
  add(path_594707, "serviceMemberId", newJString(serviceMemberId))
  add(path_594707, "serviceName", newJString(serviceName))
  result = call_594706.call(path_594707, query_594708, nil, nil, nil)

var serviceMembersListDataFreshness* = Call_ServiceMembersListDataFreshness_594699(
    name: "serviceMembersListDataFreshness", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/datafreshness",
    validator: validate_ServiceMembersListDataFreshness_594700, base: "",
    url: url_ServiceMembersListDataFreshness_594701, schemes: {Scheme.Https})
type
  Call_ServiceMembersListExportStatus_594709 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersListExportStatus_594711(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId"),
               (kind: ConstantSegment, value: "/exportstatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersListExportStatus_594710(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the export status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594712 = path.getOrDefault("serviceMemberId")
  valid_594712 = validateParameter(valid_594712, JString, required = true,
                                 default = nil)
  if valid_594712 != nil:
    section.add "serviceMemberId", valid_594712
  var valid_594713 = path.getOrDefault("serviceName")
  valid_594713 = validateParameter(valid_594713, JString, required = true,
                                 default = nil)
  if valid_594713 != nil:
    section.add "serviceName", valid_594713
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594714 = query.getOrDefault("api-version")
  valid_594714 = validateParameter(valid_594714, JString, required = true,
                                 default = nil)
  if valid_594714 != nil:
    section.add "api-version", valid_594714
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594715: Call_ServiceMembersListExportStatus_594709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the export status.
  ## 
  let valid = call_594715.validator(path, query, header, formData, body)
  let scheme = call_594715.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594715.url(scheme.get, call_594715.host, call_594715.base,
                         call_594715.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594715, url, valid)

proc call*(call_594716: Call_ServiceMembersListExportStatus_594709;
          apiVersion: string; serviceMemberId: string; serviceName: string): Recallable =
  ## serviceMembersListExportStatus
  ## Gets the export status.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594717 = newJObject()
  var query_594718 = newJObject()
  add(query_594718, "api-version", newJString(apiVersion))
  add(path_594717, "serviceMemberId", newJString(serviceMemberId))
  add(path_594717, "serviceName", newJString(serviceName))
  result = call_594716.call(path_594717, query_594718, nil, nil, nil)

var serviceMembersListExportStatus* = Call_ServiceMembersListExportStatus_594709(
    name: "serviceMembersListExportStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/exportstatus",
    validator: validate_ServiceMembersListExportStatus_594710, base: "",
    url: url_ServiceMembersListExportStatus_594711, schemes: {Scheme.Https})
type
  Call_ServiceMembersListGlobalConfiguration_594719 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersListGlobalConfiguration_594721(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId"),
               (kind: ConstantSegment, value: "/globalconfiguration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersListGlobalConfiguration_594720(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the global configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594722 = path.getOrDefault("serviceMemberId")
  valid_594722 = validateParameter(valid_594722, JString, required = true,
                                 default = nil)
  if valid_594722 != nil:
    section.add "serviceMemberId", valid_594722
  var valid_594723 = path.getOrDefault("serviceName")
  valid_594723 = validateParameter(valid_594723, JString, required = true,
                                 default = nil)
  if valid_594723 != nil:
    section.add "serviceName", valid_594723
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594724 = query.getOrDefault("api-version")
  valid_594724 = validateParameter(valid_594724, JString, required = true,
                                 default = nil)
  if valid_594724 != nil:
    section.add "api-version", valid_594724
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594725: Call_ServiceMembersListGlobalConfiguration_594719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the global configuration.
  ## 
  let valid = call_594725.validator(path, query, header, formData, body)
  let scheme = call_594725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594725.url(scheme.get, call_594725.host, call_594725.base,
                         call_594725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594725, url, valid)

proc call*(call_594726: Call_ServiceMembersListGlobalConfiguration_594719;
          apiVersion: string; serviceMemberId: string; serviceName: string): Recallable =
  ## serviceMembersListGlobalConfiguration
  ## Gets the global configuration.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594727 = newJObject()
  var query_594728 = newJObject()
  add(query_594728, "api-version", newJString(apiVersion))
  add(path_594727, "serviceMemberId", newJString(serviceMemberId))
  add(path_594727, "serviceName", newJString(serviceName))
  result = call_594726.call(path_594727, query_594728, nil, nil, nil)

var serviceMembersListGlobalConfiguration* = Call_ServiceMembersListGlobalConfiguration_594719(
    name: "serviceMembersListGlobalConfiguration", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/globalconfiguration",
    validator: validate_ServiceMembersListGlobalConfiguration_594720, base: "",
    url: url_ServiceMembersListGlobalConfiguration_594721, schemes: {Scheme.Https})
type
  Call_ServiceMembersGetConnectorMetadata_594729 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersGetConnectorMetadata_594731(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId"),
               (kind: ConstantSegment, value: "/metrics/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersGetConnectorMetadata_594730(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of connectors and run profile names.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metricName: JString (required)
  ##             : The name of the metric.
  ##   serviceMemberId: JString (required)
  ##                  : The service member id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `metricName` field"
  var valid_594732 = path.getOrDefault("metricName")
  valid_594732 = validateParameter(valid_594732, JString, required = true,
                                 default = nil)
  if valid_594732 != nil:
    section.add "metricName", valid_594732
  var valid_594733 = path.getOrDefault("serviceMemberId")
  valid_594733 = validateParameter(valid_594733, JString, required = true,
                                 default = nil)
  if valid_594733 != nil:
    section.add "serviceMemberId", valid_594733
  var valid_594734 = path.getOrDefault("serviceName")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "serviceName", valid_594734
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594735 = query.getOrDefault("api-version")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "api-version", valid_594735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594736: Call_ServiceMembersGetConnectorMetadata_594729;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of connectors and run profile names.
  ## 
  let valid = call_594736.validator(path, query, header, formData, body)
  let scheme = call_594736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594736.url(scheme.get, call_594736.host, call_594736.base,
                         call_594736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594736, url, valid)

proc call*(call_594737: Call_ServiceMembersGetConnectorMetadata_594729;
          apiVersion: string; metricName: string; serviceMemberId: string;
          serviceName: string): Recallable =
  ## serviceMembersGetConnectorMetadata
  ## Gets the list of connectors and run profile names.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   metricName: string (required)
  ##             : The name of the metric.
  ##   serviceMemberId: string (required)
  ##                  : The service member id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594738 = newJObject()
  var query_594739 = newJObject()
  add(query_594739, "api-version", newJString(apiVersion))
  add(path_594738, "metricName", newJString(metricName))
  add(path_594738, "serviceMemberId", newJString(serviceMemberId))
  add(path_594738, "serviceName", newJString(serviceName))
  result = call_594737.call(path_594738, query_594739, nil, nil, nil)

var serviceMembersGetConnectorMetadata* = Call_ServiceMembersGetConnectorMetadata_594729(
    name: "serviceMembersGetConnectorMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/metrics/{metricName}",
    validator: validate_ServiceMembersGetConnectorMetadata_594730, base: "",
    url: url_ServiceMembersGetConnectorMetadata_594731, schemes: {Scheme.Https})
type
  Call_ServiceMembersGetMetrics_594740 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersGetMetrics_594742(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId"),
               (kind: ConstantSegment, value: "/metrics/"),
               (kind: VariableSegment, value: "metricName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersGetMetrics_594741(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the server related metrics for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : The group name
  ##   metricName: JString (required)
  ##             : The metric name
  ##   serviceMemberId: JString (required)
  ##                  : The server id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_594743 = path.getOrDefault("groupName")
  valid_594743 = validateParameter(valid_594743, JString, required = true,
                                 default = nil)
  if valid_594743 != nil:
    section.add "groupName", valid_594743
  var valid_594744 = path.getOrDefault("metricName")
  valid_594744 = validateParameter(valid_594744, JString, required = true,
                                 default = nil)
  if valid_594744 != nil:
    section.add "metricName", valid_594744
  var valid_594745 = path.getOrDefault("serviceMemberId")
  valid_594745 = validateParameter(valid_594745, JString, required = true,
                                 default = nil)
  if valid_594745 != nil:
    section.add "serviceMemberId", valid_594745
  var valid_594746 = path.getOrDefault("serviceName")
  valid_594746 = validateParameter(valid_594746, JString, required = true,
                                 default = nil)
  if valid_594746 != nil:
    section.add "serviceName", valid_594746
  result.add "path", section
  ## parameters in `query` object:
  ##   groupKey: JString
  ##           : The group key
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   fromDate: JString
  ##           : The start date.
  ##   toDate: JString
  ##         : The end date.
  section = newJObject()
  var valid_594747 = query.getOrDefault("groupKey")
  valid_594747 = validateParameter(valid_594747, JString, required = false,
                                 default = nil)
  if valid_594747 != nil:
    section.add "groupKey", valid_594747
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594748 = query.getOrDefault("api-version")
  valid_594748 = validateParameter(valid_594748, JString, required = true,
                                 default = nil)
  if valid_594748 != nil:
    section.add "api-version", valid_594748
  var valid_594749 = query.getOrDefault("fromDate")
  valid_594749 = validateParameter(valid_594749, JString, required = false,
                                 default = nil)
  if valid_594749 != nil:
    section.add "fromDate", valid_594749
  var valid_594750 = query.getOrDefault("toDate")
  valid_594750 = validateParameter(valid_594750, JString, required = false,
                                 default = nil)
  if valid_594750 != nil:
    section.add "toDate", valid_594750
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594751: Call_ServiceMembersGetMetrics_594740; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the server related metrics for a given metric and group combination.
  ## 
  let valid = call_594751.validator(path, query, header, formData, body)
  let scheme = call_594751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594751.url(scheme.get, call_594751.host, call_594751.base,
                         call_594751.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594751, url, valid)

proc call*(call_594752: Call_ServiceMembersGetMetrics_594740; apiVersion: string;
          groupName: string; metricName: string; serviceMemberId: string;
          serviceName: string; groupKey: string = ""; fromDate: string = "";
          toDate: string = ""): Recallable =
  ## serviceMembersGetMetrics
  ## Gets the server related metrics for a given metric and group combination.
  ##   groupKey: string
  ##           : The group key
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   fromDate: string
  ##           : The start date.
  ##   groupName: string (required)
  ##            : The group name
  ##   metricName: string (required)
  ##             : The metric name
  ##   serviceMemberId: string (required)
  ##                  : The server id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   toDate: string
  ##         : The end date.
  var path_594753 = newJObject()
  var query_594754 = newJObject()
  add(query_594754, "groupKey", newJString(groupKey))
  add(query_594754, "api-version", newJString(apiVersion))
  add(query_594754, "fromDate", newJString(fromDate))
  add(path_594753, "groupName", newJString(groupName))
  add(path_594753, "metricName", newJString(metricName))
  add(path_594753, "serviceMemberId", newJString(serviceMemberId))
  add(path_594753, "serviceName", newJString(serviceName))
  add(query_594754, "toDate", newJString(toDate))
  result = call_594752.call(path_594753, query_594754, nil, nil, nil)

var serviceMembersGetMetrics* = Call_ServiceMembersGetMetrics_594740(
    name: "serviceMembersGetMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/metrics/{metricName}/groups/{groupName}",
    validator: validate_ServiceMembersGetMetrics_594741, base: "",
    url: url_ServiceMembersGetMetrics_594742, schemes: {Scheme.Https})
type
  Call_ServiceMembersGetServiceConfiguration_594755 = ref object of OpenApiRestCall_593438
proc url_ServiceMembersGetServiceConfiguration_594757(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "serviceMemberId" in path, "`serviceMemberId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ADHybridHealthService/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/servicemembers/"),
               (kind: VariableSegment, value: "serviceMemberId"),
               (kind: ConstantSegment, value: "/serviceconfiguration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceMembersGetServiceConfiguration_594756(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_594758 = path.getOrDefault("serviceMemberId")
  valid_594758 = validateParameter(valid_594758, JString, required = true,
                                 default = nil)
  if valid_594758 != nil:
    section.add "serviceMemberId", valid_594758
  var valid_594759 = path.getOrDefault("serviceName")
  valid_594759 = validateParameter(valid_594759, JString, required = true,
                                 default = nil)
  if valid_594759 != nil:
    section.add "serviceName", valid_594759
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594760 = query.getOrDefault("api-version")
  valid_594760 = validateParameter(valid_594760, JString, required = true,
                                 default = nil)
  if valid_594760 != nil:
    section.add "api-version", valid_594760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594761: Call_ServiceMembersGetServiceConfiguration_594755;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the service configuration.
  ## 
  let valid = call_594761.validator(path, query, header, formData, body)
  let scheme = call_594761.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594761.url(scheme.get, call_594761.host, call_594761.base,
                         call_594761.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594761, url, valid)

proc call*(call_594762: Call_ServiceMembersGetServiceConfiguration_594755;
          apiVersion: string; serviceMemberId: string; serviceName: string): Recallable =
  ## serviceMembersGetServiceConfiguration
  ## Gets the service configuration.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  var path_594763 = newJObject()
  var query_594764 = newJObject()
  add(query_594764, "api-version", newJString(apiVersion))
  add(path_594763, "serviceMemberId", newJString(serviceMemberId))
  add(path_594763, "serviceName", newJString(serviceName))
  result = call_594762.call(path_594763, query_594764, nil, nil, nil)

var serviceMembersGetServiceConfiguration* = Call_ServiceMembersGetServiceConfiguration_594755(
    name: "serviceMembersGetServiceConfiguration", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/serviceconfiguration",
    validator: validate_ServiceMembersGetServiceConfiguration_594756, base: "",
    url: url_ServiceMembersGetServiceConfiguration_594757, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
