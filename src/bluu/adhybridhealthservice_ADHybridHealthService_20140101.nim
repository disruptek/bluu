
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  macServiceName = "adhybridhealthservice-ADHybridHealthService"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AddsServicesAdd_564090 = ref object of OpenApiRestCall_563565
proc url_AddsServicesAdd_564092(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AddsServicesAdd_564091(path: JsonNode; query: JsonNode;
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
  var valid_564093 = query.getOrDefault("api-version")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "api-version", valid_564093
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

proc call*(call_564095: Call_AddsServicesAdd_564090; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Onboards a service for a given tenant in Azure Active Directory Connect Health.
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_AddsServicesAdd_564090; apiVersion: string;
          service: JsonNode): Recallable =
  ## addsServicesAdd
  ## Onboards a service for a given tenant in Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   service: JObject (required)
  ##          : The service object.
  var query_564097 = newJObject()
  var body_564098 = newJObject()
  add(query_564097, "api-version", newJString(apiVersion))
  if service != nil:
    body_564098 = service
  result = call_564096.call(nil, query_564097, nil, nil, body_564098)

var addsServicesAdd* = Call_AddsServicesAdd_564090(name: "addsServicesAdd",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/addsservices",
    validator: validate_AddsServicesAdd_564091, base: "", url: url_AddsServicesAdd_564092,
    schemes: {Scheme.Https})
type
  Call_AddsServicesList_563787 = ref object of OpenApiRestCall_563565
proc url_AddsServicesList_563789(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AddsServicesList_563788(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the details of Active Directory Domain Service, for a tenant, that are onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   skipCount: JInt
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   serviceType: JString
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   $filter: JString
  ##          : The service property filter to apply.
  ##   takeCount: JInt
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563951 = query.getOrDefault("api-version")
  valid_563951 = validateParameter(valid_563951, JString, required = true,
                                 default = nil)
  if valid_563951 != nil:
    section.add "api-version", valid_563951
  var valid_563952 = query.getOrDefault("skipCount")
  valid_563952 = validateParameter(valid_563952, JInt, required = false, default = nil)
  if valid_563952 != nil:
    section.add "skipCount", valid_563952
  var valid_563953 = query.getOrDefault("serviceType")
  valid_563953 = validateParameter(valid_563953, JString, required = false,
                                 default = nil)
  if valid_563953 != nil:
    section.add "serviceType", valid_563953
  var valid_563954 = query.getOrDefault("$filter")
  valid_563954 = validateParameter(valid_563954, JString, required = false,
                                 default = nil)
  if valid_563954 != nil:
    section.add "$filter", valid_563954
  var valid_563955 = query.getOrDefault("takeCount")
  valid_563955 = validateParameter(valid_563955, JInt, required = false, default = nil)
  if valid_563955 != nil:
    section.add "takeCount", valid_563955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563978: Call_AddsServicesList_563787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of Active Directory Domain Service, for a tenant, that are onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_563978.validator(path, query, header, formData, body)
  let scheme = call_563978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563978.url(scheme.get, call_563978.host, call_563978.base,
                         call_563978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563978, url, valid)

proc call*(call_564049: Call_AddsServicesList_563787; apiVersion: string;
          skipCount: int = 0; serviceType: string = ""; Filter: string = "";
          takeCount: int = 0): Recallable =
  ## addsServicesList
  ## Gets the details of Active Directory Domain Service, for a tenant, that are onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   skipCount: int
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   serviceType: string
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   Filter: string
  ##         : The service property filter to apply.
  ##   takeCount: int
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  var query_564050 = newJObject()
  add(query_564050, "api-version", newJString(apiVersion))
  add(query_564050, "skipCount", newJInt(skipCount))
  add(query_564050, "serviceType", newJString(serviceType))
  add(query_564050, "$filter", newJString(Filter))
  add(query_564050, "takeCount", newJInt(takeCount))
  result = call_564049.call(nil, query_564050, nil, nil, nil)

var addsServicesList* = Call_AddsServicesList_563787(name: "addsServicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/addsservices",
    validator: validate_AddsServicesList_563788, base: "",
    url: url_AddsServicesList_563789, schemes: {Scheme.Https})
type
  Call_AddsServicesListPremiumServices_564099 = ref object of OpenApiRestCall_563565
proc url_AddsServicesListPremiumServices_564101(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AddsServicesListPremiumServices_564100(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of Active Directory Domain Services for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   skipCount: JInt
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   serviceType: JString
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   $filter: JString
  ##          : The service property filter to apply.
  ##   takeCount: JInt
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  var valid_564103 = query.getOrDefault("skipCount")
  valid_564103 = validateParameter(valid_564103, JInt, required = false, default = nil)
  if valid_564103 != nil:
    section.add "skipCount", valid_564103
  var valid_564104 = query.getOrDefault("serviceType")
  valid_564104 = validateParameter(valid_564104, JString, required = false,
                                 default = nil)
  if valid_564104 != nil:
    section.add "serviceType", valid_564104
  var valid_564105 = query.getOrDefault("$filter")
  valid_564105 = validateParameter(valid_564105, JString, required = false,
                                 default = nil)
  if valid_564105 != nil:
    section.add "$filter", valid_564105
  var valid_564106 = query.getOrDefault("takeCount")
  valid_564106 = validateParameter(valid_564106, JInt, required = false, default = nil)
  if valid_564106 != nil:
    section.add "takeCount", valid_564106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564107: Call_AddsServicesListPremiumServices_564099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of Active Directory Domain Services for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564107.validator(path, query, header, formData, body)
  let scheme = call_564107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564107.url(scheme.get, call_564107.host, call_564107.base,
                         call_564107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564107, url, valid)

proc call*(call_564108: Call_AddsServicesListPremiumServices_564099;
          apiVersion: string; skipCount: int = 0; serviceType: string = "";
          Filter: string = ""; takeCount: int = 0): Recallable =
  ## addsServicesListPremiumServices
  ## Gets the details of Active Directory Domain Services for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   skipCount: int
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   serviceType: string
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   Filter: string
  ##         : The service property filter to apply.
  ##   takeCount: int
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  var query_564109 = newJObject()
  add(query_564109, "api-version", newJString(apiVersion))
  add(query_564109, "skipCount", newJInt(skipCount))
  add(query_564109, "serviceType", newJString(serviceType))
  add(query_564109, "$filter", newJString(Filter))
  add(query_564109, "takeCount", newJInt(takeCount))
  result = call_564108.call(nil, query_564109, nil, nil, nil)

var addsServicesListPremiumServices* = Call_AddsServicesListPremiumServices_564099(
    name: "addsServicesListPremiumServices", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/premiumCheck",
    validator: validate_AddsServicesListPremiumServices_564100, base: "",
    url: url_AddsServicesListPremiumServices_564101, schemes: {Scheme.Https})
type
  Call_AddsServicesGet_564110 = ref object of OpenApiRestCall_563565
proc url_AddsServicesGet_564112(protocol: Scheme; host: string; base: string;
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

proc validate_AddsServicesGet_564111(path: JsonNode; query: JsonNode;
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
  var valid_564127 = path.getOrDefault("serviceName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "serviceName", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564129: Call_AddsServicesGet_564110; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an Active Directory Domain Service for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_AddsServicesGet_564110; serviceName: string;
          apiVersion: string): Recallable =
  ## addsServicesGet
  ## Gets the details of an Active Directory Domain Service for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  add(path_564131, "serviceName", newJString(serviceName))
  add(query_564132, "api-version", newJString(apiVersion))
  result = call_564130.call(path_564131, query_564132, nil, nil, nil)

var addsServicesGet* = Call_AddsServicesGet_564110(name: "addsServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}",
    validator: validate_AddsServicesGet_564111, base: "", url: url_AddsServicesGet_564112,
    schemes: {Scheme.Https})
type
  Call_AddsServicesUpdate_564143 = ref object of OpenApiRestCall_563565
proc url_AddsServicesUpdate_564145(protocol: Scheme; host: string; base: string;
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

proc validate_AddsServicesUpdate_564144(path: JsonNode; query: JsonNode;
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
  var valid_564146 = path.getOrDefault("serviceName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "serviceName", valid_564146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564147 = query.getOrDefault("api-version")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "api-version", valid_564147
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

proc call*(call_564149: Call_AddsServicesUpdate_564143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an Active Directory Domain Service properties of an onboarded service.
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_AddsServicesUpdate_564143; serviceName: string;
          apiVersion: string; service: JsonNode): Recallable =
  ## addsServicesUpdate
  ## Updates an Active Directory Domain Service properties of an onboarded service.
  ##   serviceName: string (required)
  ##              : The name of the service which needs to be deleted.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   service: JObject (required)
  ##          : The service object.
  var path_564151 = newJObject()
  var query_564152 = newJObject()
  var body_564153 = newJObject()
  add(path_564151, "serviceName", newJString(serviceName))
  add(query_564152, "api-version", newJString(apiVersion))
  if service != nil:
    body_564153 = service
  result = call_564150.call(path_564151, query_564152, nil, nil, body_564153)

var addsServicesUpdate* = Call_AddsServicesUpdate_564143(
    name: "addsServicesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}",
    validator: validate_AddsServicesUpdate_564144, base: "",
    url: url_AddsServicesUpdate_564145, schemes: {Scheme.Https})
type
  Call_AddsServicesDelete_564133 = ref object of OpenApiRestCall_563565
proc url_AddsServicesDelete_564135(protocol: Scheme; host: string; base: string;
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

proc validate_AddsServicesDelete_564134(path: JsonNode; query: JsonNode;
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
  var valid_564136 = path.getOrDefault("serviceName")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "serviceName", valid_564136
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   confirm: JBool
  ##          : Indicates if the service will be permanently deleted or disabled. True indicates that the service will be permanently deleted and False indicates that the service will be marked disabled and then deleted after 30 days, if it is not re-registered.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564137 = query.getOrDefault("api-version")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "api-version", valid_564137
  var valid_564138 = query.getOrDefault("confirm")
  valid_564138 = validateParameter(valid_564138, JBool, required = false, default = nil)
  if valid_564138 != nil:
    section.add "confirm", valid_564138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564139: Call_AddsServicesDelete_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Active Directory Domain Service which is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564139.validator(path, query, header, formData, body)
  let scheme = call_564139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564139.url(scheme.get, call_564139.host, call_564139.base,
                         call_564139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564139, url, valid)

proc call*(call_564140: Call_AddsServicesDelete_564133; serviceName: string;
          apiVersion: string; confirm: bool = false): Recallable =
  ## addsServicesDelete
  ## Deletes an Active Directory Domain Service which is onboarded to Azure Active Directory Connect Health.
  ##   serviceName: string (required)
  ##              : The name of the service which needs to be deleted.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   confirm: bool
  ##          : Indicates if the service will be permanently deleted or disabled. True indicates that the service will be permanently deleted and False indicates that the service will be marked disabled and then deleted after 30 days, if it is not re-registered.
  var path_564141 = newJObject()
  var query_564142 = newJObject()
  add(path_564141, "serviceName", newJString(serviceName))
  add(query_564142, "api-version", newJString(apiVersion))
  add(query_564142, "confirm", newJBool(confirm))
  result = call_564140.call(path_564141, query_564142, nil, nil, nil)

var addsServicesDelete* = Call_AddsServicesDelete_564133(
    name: "addsServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}",
    validator: validate_AddsServicesDelete_564134, base: "",
    url: url_AddsServicesDelete_564135, schemes: {Scheme.Https})
type
  Call_AdDomainServiceMembersList_564154 = ref object of OpenApiRestCall_563565
proc url_AdDomainServiceMembersList_564156(protocol: Scheme; host: string;
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

proc validate_AdDomainServiceMembersList_564155(path: JsonNode; query: JsonNode;
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
  var valid_564157 = path.getOrDefault("serviceName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "serviceName", valid_564157
  result.add "path", section
  ## parameters in `query` object:
  ##   nextPartitionKey: JString (required)
  ##                   : The next partition key to query for.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   isGroupbySite: JBool (required)
  ##                : Indicates if the result should be grouped by site or not.
  ##   nextRowKey: JString (required)
  ##             : The next row key to query for.
  ##   query: JString
  ##        : The custom query.
  ##   $filter: JString
  ##          : The server property filter to apply.
  ##   takeCount: JInt
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `nextPartitionKey` field"
  var valid_564171 = query.getOrDefault("nextPartitionKey")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = newJString(" "))
  if valid_564171 != nil:
    section.add "nextPartitionKey", valid_564171
  var valid_564172 = query.getOrDefault("api-version")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "api-version", valid_564172
  var valid_564173 = query.getOrDefault("isGroupbySite")
  valid_564173 = validateParameter(valid_564173, JBool, required = true, default = nil)
  if valid_564173 != nil:
    section.add "isGroupbySite", valid_564173
  var valid_564174 = query.getOrDefault("nextRowKey")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = newJString(" "))
  if valid_564174 != nil:
    section.add "nextRowKey", valid_564174
  var valid_564175 = query.getOrDefault("query")
  valid_564175 = validateParameter(valid_564175, JString, required = false,
                                 default = nil)
  if valid_564175 != nil:
    section.add "query", valid_564175
  var valid_564176 = query.getOrDefault("$filter")
  valid_564176 = validateParameter(valid_564176, JString, required = false,
                                 default = nil)
  if valid_564176 != nil:
    section.add "$filter", valid_564176
  var valid_564177 = query.getOrDefault("takeCount")
  valid_564177 = validateParameter(valid_564177, JInt, required = false, default = nil)
  if valid_564177 != nil:
    section.add "takeCount", valid_564177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564178: Call_AdDomainServiceMembersList_564154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the servers, for a given Active Directory Domain Service, that are onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564178.validator(path, query, header, formData, body)
  let scheme = call_564178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564178.url(scheme.get, call_564178.host, call_564178.base,
                         call_564178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564178, url, valid)

proc call*(call_564179: Call_AdDomainServiceMembersList_564154;
          serviceName: string; apiVersion: string; isGroupbySite: bool;
          nextPartitionKey: string = " "; nextRowKey: string = " "; query: string = "";
          Filter: string = ""; takeCount: int = 0): Recallable =
  ## adDomainServiceMembersList
  ## Gets the details of the servers, for a given Active Directory Domain Service, that are onboarded to Azure Active Directory Connect Health.
  ##   nextPartitionKey: string (required)
  ##                   : The next partition key to query for.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   isGroupbySite: bool (required)
  ##                : Indicates if the result should be grouped by site or not.
  ##   nextRowKey: string (required)
  ##             : The next row key to query for.
  ##   query: string
  ##        : The custom query.
  ##   Filter: string
  ##         : The server property filter to apply.
  ##   takeCount: int
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  var path_564180 = newJObject()
  var query_564181 = newJObject()
  add(query_564181, "nextPartitionKey", newJString(nextPartitionKey))
  add(path_564180, "serviceName", newJString(serviceName))
  add(query_564181, "api-version", newJString(apiVersion))
  add(query_564181, "isGroupbySite", newJBool(isGroupbySite))
  add(query_564181, "nextRowKey", newJString(nextRowKey))
  add(query_564181, "query", newJString(query))
  add(query_564181, "$filter", newJString(Filter))
  add(query_564181, "takeCount", newJInt(takeCount))
  result = call_564179.call(path_564180, query_564181, nil, nil, nil)

var adDomainServiceMembersList* = Call_AdDomainServiceMembersList_564154(
    name: "adDomainServiceMembersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/addomainservicemembers",
    validator: validate_AdDomainServiceMembersList_564155, base: "",
    url: url_AdDomainServiceMembersList_564156, schemes: {Scheme.Https})
type
  Call_AddsServiceMembersList_564182 = ref object of OpenApiRestCall_563565
proc url_AddsServiceMembersList_564184(protocol: Scheme; host: string; base: string;
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

proc validate_AddsServiceMembersList_564183(path: JsonNode; query: JsonNode;
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
  var valid_564185 = path.getOrDefault("serviceName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "serviceName", valid_564185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $filter: JString
  ##          : The server property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "api-version", valid_564186
  var valid_564187 = query.getOrDefault("$filter")
  valid_564187 = validateParameter(valid_564187, JString, required = false,
                                 default = nil)
  if valid_564187 != nil:
    section.add "$filter", valid_564187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564188: Call_AddsServiceMembersList_564182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Active Directory Domain servers, for a given Active Directory Domain Service, that are onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_AddsServiceMembersList_564182; serviceName: string;
          apiVersion: string; Filter: string = ""): Recallable =
  ## addsServiceMembersList
  ## Gets the details of the Active Directory Domain servers, for a given Active Directory Domain Service, that are onboarded to Azure Active Directory Connect Health.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   Filter: string
  ##         : The server property filter to apply.
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  add(path_564190, "serviceName", newJString(serviceName))
  add(query_564191, "api-version", newJString(apiVersion))
  add(query_564191, "$filter", newJString(Filter))
  result = call_564189.call(path_564190, query_564191, nil, nil, nil)

var addsServiceMembersList* = Call_AddsServiceMembersList_564182(
    name: "addsServiceMembersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/addsservicemembers",
    validator: validate_AddsServiceMembersList_564183, base: "",
    url: url_AddsServiceMembersList_564184, schemes: {Scheme.Https})
type
  Call_AlertsListAddsAlerts_564192 = ref object of OpenApiRestCall_563565
proc url_AlertsListAddsAlerts_564194(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsListAddsAlerts_564193(path: JsonNode; query: JsonNode;
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
  var valid_564195 = path.getOrDefault("serviceName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "serviceName", valid_564195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   state: JString
  ##        : The alert state to query for.
  ##   to: JString
  ##     : The end date till when to query for.
  ##   from: JString
  ##       : The start date to query for.
  ##   $filter: JString
  ##          : The alert property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564196 = query.getOrDefault("api-version")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "api-version", valid_564196
  var valid_564197 = query.getOrDefault("state")
  valid_564197 = validateParameter(valid_564197, JString, required = false,
                                 default = nil)
  if valid_564197 != nil:
    section.add "state", valid_564197
  var valid_564198 = query.getOrDefault("to")
  valid_564198 = validateParameter(valid_564198, JString, required = false,
                                 default = nil)
  if valid_564198 != nil:
    section.add "to", valid_564198
  var valid_564199 = query.getOrDefault("from")
  valid_564199 = validateParameter(valid_564199, JString, required = false,
                                 default = nil)
  if valid_564199 != nil:
    section.add "from", valid_564199
  var valid_564200 = query.getOrDefault("$filter")
  valid_564200 = validateParameter(valid_564200, JString, required = false,
                                 default = nil)
  if valid_564200 != nil:
    section.add "$filter", valid_564200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564201: Call_AlertsListAddsAlerts_564192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alerts for a given Active Directory Domain Service.
  ## 
  let valid = call_564201.validator(path, query, header, formData, body)
  let scheme = call_564201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564201.url(scheme.get, call_564201.host, call_564201.base,
                         call_564201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564201, url, valid)

proc call*(call_564202: Call_AlertsListAddsAlerts_564192; serviceName: string;
          apiVersion: string; state: string = ""; to: string = ""; `from`: string = "";
          Filter: string = ""): Recallable =
  ## alertsListAddsAlerts
  ## Gets the alerts for a given Active Directory Domain Service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   state: string
  ##        : The alert state to query for.
  ##   to: string
  ##     : The end date till when to query for.
  ##   from: string
  ##       : The start date to query for.
  ##   Filter: string
  ##         : The alert property filter to apply.
  var path_564203 = newJObject()
  var query_564204 = newJObject()
  add(path_564203, "serviceName", newJString(serviceName))
  add(query_564204, "api-version", newJString(apiVersion))
  add(query_564204, "state", newJString(state))
  add(query_564204, "to", newJString(to))
  add(query_564204, "from", newJString(`from`))
  add(query_564204, "$filter", newJString(Filter))
  result = call_564202.call(path_564203, query_564204, nil, nil, nil)

var alertsListAddsAlerts* = Call_AlertsListAddsAlerts_564192(
    name: "alertsListAddsAlerts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/alerts",
    validator: validate_AlertsListAddsAlerts_564193, base: "",
    url: url_AlertsListAddsAlerts_564194, schemes: {Scheme.Https})
type
  Call_ConfigurationListAddsConfigurations_564205 = ref object of OpenApiRestCall_563565
proc url_ConfigurationListAddsConfigurations_564207(protocol: Scheme; host: string;
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

proc validate_ConfigurationListAddsConfigurations_564206(path: JsonNode;
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
  var valid_564208 = path.getOrDefault("serviceName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "serviceName", valid_564208
  result.add "path", section
  ## parameters in `query` object:
  ##   grouping: JString
  ##           : The grouping for configurations.
  section = newJObject()
  var valid_564209 = query.getOrDefault("grouping")
  valid_564209 = validateParameter(valid_564209, JString, required = false,
                                 default = nil)
  if valid_564209 != nil:
    section.add "grouping", valid_564209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564210: Call_ConfigurationListAddsConfigurations_564205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the service configurations.
  ## 
  let valid = call_564210.validator(path, query, header, formData, body)
  let scheme = call_564210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564210.url(scheme.get, call_564210.host, call_564210.base,
                         call_564210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564210, url, valid)

proc call*(call_564211: Call_ConfigurationListAddsConfigurations_564205;
          serviceName: string; grouping: string = ""): Recallable =
  ## configurationListAddsConfigurations
  ## Gets the service configurations.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   grouping: string
  ##           : The grouping for configurations.
  var path_564212 = newJObject()
  var query_564213 = newJObject()
  add(path_564212, "serviceName", newJString(serviceName))
  add(query_564213, "grouping", newJString(grouping))
  result = call_564211.call(path_564212, query_564213, nil, nil, nil)

var configurationListAddsConfigurations* = Call_ConfigurationListAddsConfigurations_564205(
    name: "configurationListAddsConfigurations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/configuration",
    validator: validate_ConfigurationListAddsConfigurations_564206, base: "",
    url: url_ConfigurationListAddsConfigurations_564207, schemes: {Scheme.Https})
type
  Call_DimensionsListAddsDimensions_564214 = ref object of OpenApiRestCall_563565
proc url_DimensionsListAddsDimensions_564216(protocol: Scheme; host: string;
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

proc validate_DimensionsListAddsDimensions_564215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the dimensions for a given dimension type in a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   dimension: JString (required)
  ##            : The dimension type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564217 = path.getOrDefault("serviceName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "serviceName", valid_564217
  var valid_564218 = path.getOrDefault("dimension")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "dimension", valid_564218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564219 = query.getOrDefault("api-version")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "api-version", valid_564219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564220: Call_DimensionsListAddsDimensions_564214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the dimensions for a given dimension type in a server.
  ## 
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_DimensionsListAddsDimensions_564214;
          serviceName: string; apiVersion: string; dimension: string): Recallable =
  ## dimensionsListAddsDimensions
  ## Gets the dimensions for a given dimension type in a server.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   dimension: string (required)
  ##            : The dimension type.
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  add(path_564222, "serviceName", newJString(serviceName))
  add(query_564223, "api-version", newJString(apiVersion))
  add(path_564222, "dimension", newJString(dimension))
  result = call_564221.call(path_564222, query_564223, nil, nil, nil)

var dimensionsListAddsDimensions* = Call_DimensionsListAddsDimensions_564214(
    name: "dimensionsListAddsDimensions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/dimensions/{dimension}",
    validator: validate_DimensionsListAddsDimensions_564215, base: "",
    url: url_DimensionsListAddsDimensions_564216, schemes: {Scheme.Https})
type
  Call_AddsServicesUserPreferenceAdd_564234 = ref object of OpenApiRestCall_563565
proc url_AddsServicesUserPreferenceAdd_564236(protocol: Scheme; host: string;
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

proc validate_AddsServicesUserPreferenceAdd_564235(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds the user preferences for a given feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   featureName: JString (required)
  ##              : The name of the feature.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564237 = path.getOrDefault("serviceName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "serviceName", valid_564237
  var valid_564238 = path.getOrDefault("featureName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "featureName", valid_564238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564239 = query.getOrDefault("api-version")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "api-version", valid_564239
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

proc call*(call_564241: Call_AddsServicesUserPreferenceAdd_564234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds the user preferences for a given feature.
  ## 
  let valid = call_564241.validator(path, query, header, formData, body)
  let scheme = call_564241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564241.url(scheme.get, call_564241.host, call_564241.base,
                         call_564241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564241, url, valid)

proc call*(call_564242: Call_AddsServicesUserPreferenceAdd_564234;
          serviceName: string; apiVersion: string; setting: JsonNode;
          featureName: string): Recallable =
  ## addsServicesUserPreferenceAdd
  ## Adds the user preferences for a given feature.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   setting: JObject (required)
  ##          : The user preference setting.
  ##   featureName: string (required)
  ##              : The name of the feature.
  var path_564243 = newJObject()
  var query_564244 = newJObject()
  var body_564245 = newJObject()
  add(path_564243, "serviceName", newJString(serviceName))
  add(query_564244, "api-version", newJString(apiVersion))
  if setting != nil:
    body_564245 = setting
  add(path_564243, "featureName", newJString(featureName))
  result = call_564242.call(path_564243, query_564244, nil, nil, body_564245)

var addsServicesUserPreferenceAdd* = Call_AddsServicesUserPreferenceAdd_564234(
    name: "addsServicesUserPreferenceAdd", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/features/{featureName}/userpreference",
    validator: validate_AddsServicesUserPreferenceAdd_564235, base: "",
    url: url_AddsServicesUserPreferenceAdd_564236, schemes: {Scheme.Https})
type
  Call_AddsServicesUserPreferenceGet_564224 = ref object of OpenApiRestCall_563565
proc url_AddsServicesUserPreferenceGet_564226(protocol: Scheme; host: string;
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

proc validate_AddsServicesUserPreferenceGet_564225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the user preferences for a given feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   featureName: JString (required)
  ##              : The name of the feature.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564227 = path.getOrDefault("serviceName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "serviceName", valid_564227
  var valid_564228 = path.getOrDefault("featureName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "featureName", valid_564228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564229 = query.getOrDefault("api-version")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "api-version", valid_564229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564230: Call_AddsServicesUserPreferenceGet_564224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the user preferences for a given feature.
  ## 
  let valid = call_564230.validator(path, query, header, formData, body)
  let scheme = call_564230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564230.url(scheme.get, call_564230.host, call_564230.base,
                         call_564230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564230, url, valid)

proc call*(call_564231: Call_AddsServicesUserPreferenceGet_564224;
          serviceName: string; apiVersion: string; featureName: string): Recallable =
  ## addsServicesUserPreferenceGet
  ## Gets the user preferences for a given feature.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   featureName: string (required)
  ##              : The name of the feature.
  var path_564232 = newJObject()
  var query_564233 = newJObject()
  add(path_564232, "serviceName", newJString(serviceName))
  add(query_564233, "api-version", newJString(apiVersion))
  add(path_564232, "featureName", newJString(featureName))
  result = call_564231.call(path_564232, query_564233, nil, nil, nil)

var addsServicesUserPreferenceGet* = Call_AddsServicesUserPreferenceGet_564224(
    name: "addsServicesUserPreferenceGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/features/{featureName}/userpreference",
    validator: validate_AddsServicesUserPreferenceGet_564225, base: "",
    url: url_AddsServicesUserPreferenceGet_564226, schemes: {Scheme.Https})
type
  Call_AddsServicesUserPreferenceDelete_564246 = ref object of OpenApiRestCall_563565
proc url_AddsServicesUserPreferenceDelete_564248(protocol: Scheme; host: string;
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

proc validate_AddsServicesUserPreferenceDelete_564247(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the user preferences for a given feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   featureName: JString (required)
  ##              : The name of the feature.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564249 = path.getOrDefault("serviceName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "serviceName", valid_564249
  var valid_564250 = path.getOrDefault("featureName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "featureName", valid_564250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564251 = query.getOrDefault("api-version")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "api-version", valid_564251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564252: Call_AddsServicesUserPreferenceDelete_564246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the user preferences for a given feature.
  ## 
  let valid = call_564252.validator(path, query, header, formData, body)
  let scheme = call_564252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564252.url(scheme.get, call_564252.host, call_564252.base,
                         call_564252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564252, url, valid)

proc call*(call_564253: Call_AddsServicesUserPreferenceDelete_564246;
          serviceName: string; apiVersion: string; featureName: string): Recallable =
  ## addsServicesUserPreferenceDelete
  ## Deletes the user preferences for a given feature.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   featureName: string (required)
  ##              : The name of the feature.
  var path_564254 = newJObject()
  var query_564255 = newJObject()
  add(path_564254, "serviceName", newJString(serviceName))
  add(query_564255, "api-version", newJString(apiVersion))
  add(path_564254, "featureName", newJString(featureName))
  result = call_564253.call(path_564254, query_564255, nil, nil, nil)

var addsServicesUserPreferenceDelete* = Call_AddsServicesUserPreferenceDelete_564246(
    name: "addsServicesUserPreferenceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/features/{featureName}/userpreference",
    validator: validate_AddsServicesUserPreferenceDelete_564247, base: "",
    url: url_AddsServicesUserPreferenceDelete_564248, schemes: {Scheme.Https})
type
  Call_AddsServicesGetForestSummary_564256 = ref object of OpenApiRestCall_563565
proc url_AddsServicesGetForestSummary_564258(protocol: Scheme; host: string;
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

proc validate_AddsServicesGetForestSummary_564257(path: JsonNode; query: JsonNode;
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
  var valid_564259 = path.getOrDefault("serviceName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "serviceName", valid_564259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564260 = query.getOrDefault("api-version")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "api-version", valid_564260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564261: Call_AddsServicesGetForestSummary_564256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the forest summary for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564261.validator(path, query, header, formData, body)
  let scheme = call_564261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564261.url(scheme.get, call_564261.host, call_564261.base,
                         call_564261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564261, url, valid)

proc call*(call_564262: Call_AddsServicesGetForestSummary_564256;
          serviceName: string; apiVersion: string): Recallable =
  ## addsServicesGetForestSummary
  ## Gets the forest summary for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564263 = newJObject()
  var query_564264 = newJObject()
  add(path_564263, "serviceName", newJString(serviceName))
  add(query_564264, "api-version", newJString(apiVersion))
  result = call_564262.call(path_564263, query_564264, nil, nil, nil)

var addsServicesGetForestSummary* = Call_AddsServicesGetForestSummary_564256(
    name: "addsServicesGetForestSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/forestsummary",
    validator: validate_AddsServicesGetForestSummary_564257, base: "",
    url: url_AddsServicesGetForestSummary_564258, schemes: {Scheme.Https})
type
  Call_AddsServicesListMetricMetadata_564265 = ref object of OpenApiRestCall_563565
proc url_AddsServicesListMetricMetadata_564267(protocol: Scheme; host: string;
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

proc validate_AddsServicesListMetricMetadata_564266(path: JsonNode;
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
  var valid_564268 = path.getOrDefault("serviceName")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "serviceName", valid_564268
  result.add "path", section
  ## parameters in `query` object:
  ##   perfCounter: JBool
  ##              : Indicates if only performance counter metrics are requested.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $filter: JString
  ##          : The metric metadata property filter to apply.
  section = newJObject()
  var valid_564269 = query.getOrDefault("perfCounter")
  valid_564269 = validateParameter(valid_564269, JBool, required = false, default = nil)
  if valid_564269 != nil:
    section.add "perfCounter", valid_564269
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564270 = query.getOrDefault("api-version")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "api-version", valid_564270
  var valid_564271 = query.getOrDefault("$filter")
  valid_564271 = validateParameter(valid_564271, JString, required = false,
                                 default = nil)
  if valid_564271 != nil:
    section.add "$filter", valid_564271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564272: Call_AddsServicesListMetricMetadata_564265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the service related metrics information.
  ## 
  let valid = call_564272.validator(path, query, header, formData, body)
  let scheme = call_564272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564272.url(scheme.get, call_564272.host, call_564272.base,
                         call_564272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564272, url, valid)

proc call*(call_564273: Call_AddsServicesListMetricMetadata_564265;
          serviceName: string; apiVersion: string; perfCounter: bool = false;
          Filter: string = ""): Recallable =
  ## addsServicesListMetricMetadata
  ## Gets the service related metrics information.
  ##   perfCounter: bool
  ##              : Indicates if only performance counter metrics are requested.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   Filter: string
  ##         : The metric metadata property filter to apply.
  var path_564274 = newJObject()
  var query_564275 = newJObject()
  add(query_564275, "perfCounter", newJBool(perfCounter))
  add(path_564274, "serviceName", newJString(serviceName))
  add(query_564275, "api-version", newJString(apiVersion))
  add(query_564275, "$filter", newJString(Filter))
  result = call_564273.call(path_564274, query_564275, nil, nil, nil)

var addsServicesListMetricMetadata* = Call_AddsServicesListMetricMetadata_564265(
    name: "addsServicesListMetricMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/metricmetadata",
    validator: validate_AddsServicesListMetricMetadata_564266, base: "",
    url: url_AddsServicesListMetricMetadata_564267, schemes: {Scheme.Https})
type
  Call_AddsServicesGetMetricMetadata_564276 = ref object of OpenApiRestCall_563565
proc url_AddsServicesGetMetricMetadata_564278(protocol: Scheme; host: string;
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

proc validate_AddsServicesGetMetricMetadata_564277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service related metric information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   metricName: JString (required)
  ##             : The metric name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564279 = path.getOrDefault("serviceName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "serviceName", valid_564279
  var valid_564280 = path.getOrDefault("metricName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "metricName", valid_564280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564281 = query.getOrDefault("api-version")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "api-version", valid_564281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564282: Call_AddsServicesGetMetricMetadata_564276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the service related metric information.
  ## 
  let valid = call_564282.validator(path, query, header, formData, body)
  let scheme = call_564282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564282.url(scheme.get, call_564282.host, call_564282.base,
                         call_564282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564282, url, valid)

proc call*(call_564283: Call_AddsServicesGetMetricMetadata_564276;
          serviceName: string; apiVersion: string; metricName: string): Recallable =
  ## addsServicesGetMetricMetadata
  ## Gets the service related metric information.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   metricName: string (required)
  ##             : The metric name
  var path_564284 = newJObject()
  var query_564285 = newJObject()
  add(path_564284, "serviceName", newJString(serviceName))
  add(query_564285, "api-version", newJString(apiVersion))
  add(path_564284, "metricName", newJString(metricName))
  result = call_564283.call(path_564284, query_564285, nil, nil, nil)

var addsServicesGetMetricMetadata* = Call_AddsServicesGetMetricMetadata_564276(
    name: "addsServicesGetMetricMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/metricmetadata/{metricName}",
    validator: validate_AddsServicesGetMetricMetadata_564277, base: "",
    url: url_AddsServicesGetMetricMetadata_564278, schemes: {Scheme.Https})
type
  Call_AddsServicesGetMetricMetadataForGroup_564286 = ref object of OpenApiRestCall_563565
proc url_AddsServicesGetMetricMetadataForGroup_564288(protocol: Scheme;
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

proc validate_AddsServicesGetMetricMetadataForGroup_564287(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service related metrics for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   metricName: JString (required)
  ##             : The metric name
  ##   groupName: JString (required)
  ##            : The group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564289 = path.getOrDefault("serviceName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "serviceName", valid_564289
  var valid_564290 = path.getOrDefault("metricName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "metricName", valid_564290
  var valid_564291 = path.getOrDefault("groupName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "groupName", valid_564291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   groupKey: JString
  ##           : The group key
  ##   fromDate: JString
  ##           : The start date.
  ##   toDate: JString
  ##         : The end date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564292 = query.getOrDefault("api-version")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "api-version", valid_564292
  var valid_564293 = query.getOrDefault("groupKey")
  valid_564293 = validateParameter(valid_564293, JString, required = false,
                                 default = nil)
  if valid_564293 != nil:
    section.add "groupKey", valid_564293
  var valid_564294 = query.getOrDefault("fromDate")
  valid_564294 = validateParameter(valid_564294, JString, required = false,
                                 default = nil)
  if valid_564294 != nil:
    section.add "fromDate", valid_564294
  var valid_564295 = query.getOrDefault("toDate")
  valid_564295 = validateParameter(valid_564295, JString, required = false,
                                 default = nil)
  if valid_564295 != nil:
    section.add "toDate", valid_564295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564296: Call_AddsServicesGetMetricMetadataForGroup_564286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the service related metrics for a given metric and group combination.
  ## 
  let valid = call_564296.validator(path, query, header, formData, body)
  let scheme = call_564296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564296.url(scheme.get, call_564296.host, call_564296.base,
                         call_564296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564296, url, valid)

proc call*(call_564297: Call_AddsServicesGetMetricMetadataForGroup_564286;
          serviceName: string; apiVersion: string; metricName: string;
          groupName: string; groupKey: string = ""; fromDate: string = "";
          toDate: string = ""): Recallable =
  ## addsServicesGetMetricMetadataForGroup
  ## Gets the service related metrics for a given metric and group combination.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   groupKey: string
  ##           : The group key
  ##   metricName: string (required)
  ##             : The metric name
  ##   fromDate: string
  ##           : The start date.
  ##   groupName: string (required)
  ##            : The group name
  ##   toDate: string
  ##         : The end date.
  var path_564298 = newJObject()
  var query_564299 = newJObject()
  add(path_564298, "serviceName", newJString(serviceName))
  add(query_564299, "api-version", newJString(apiVersion))
  add(query_564299, "groupKey", newJString(groupKey))
  add(path_564298, "metricName", newJString(metricName))
  add(query_564299, "fromDate", newJString(fromDate))
  add(path_564298, "groupName", newJString(groupName))
  add(query_564299, "toDate", newJString(toDate))
  result = call_564297.call(path_564298, query_564299, nil, nil, nil)

var addsServicesGetMetricMetadataForGroup* = Call_AddsServicesGetMetricMetadataForGroup_564286(
    name: "addsServicesGetMetricMetadataForGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/metricmetadata/{metricName}/groups/{groupName}",
    validator: validate_AddsServicesGetMetricMetadataForGroup_564287, base: "",
    url: url_AddsServicesGetMetricMetadataForGroup_564288, schemes: {Scheme.Https})
type
  Call_AddsServiceGetMetrics_564300 = ref object of OpenApiRestCall_563565
proc url_AddsServiceGetMetrics_564302(protocol: Scheme; host: string; base: string;
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

proc validate_AddsServiceGetMetrics_564301(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the server related metrics for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   metricName: JString (required)
  ##             : The metric name
  ##   groupName: JString (required)
  ##            : The group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564303 = path.getOrDefault("serviceName")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "serviceName", valid_564303
  var valid_564304 = path.getOrDefault("metricName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "metricName", valid_564304
  var valid_564305 = path.getOrDefault("groupName")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "groupName", valid_564305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   groupKey: JString
  ##           : The group key
  ##   fromDate: JString
  ##           : The start date.
  ##   toDate: JString
  ##         : The end date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564306 = query.getOrDefault("api-version")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "api-version", valid_564306
  var valid_564307 = query.getOrDefault("groupKey")
  valid_564307 = validateParameter(valid_564307, JString, required = false,
                                 default = nil)
  if valid_564307 != nil:
    section.add "groupKey", valid_564307
  var valid_564308 = query.getOrDefault("fromDate")
  valid_564308 = validateParameter(valid_564308, JString, required = false,
                                 default = nil)
  if valid_564308 != nil:
    section.add "fromDate", valid_564308
  var valid_564309 = query.getOrDefault("toDate")
  valid_564309 = validateParameter(valid_564309, JString, required = false,
                                 default = nil)
  if valid_564309 != nil:
    section.add "toDate", valid_564309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564310: Call_AddsServiceGetMetrics_564300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the server related metrics for a given metric and group combination.
  ## 
  let valid = call_564310.validator(path, query, header, formData, body)
  let scheme = call_564310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564310.url(scheme.get, call_564310.host, call_564310.base,
                         call_564310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564310, url, valid)

proc call*(call_564311: Call_AddsServiceGetMetrics_564300; serviceName: string;
          apiVersion: string; metricName: string; groupName: string;
          groupKey: string = ""; fromDate: string = ""; toDate: string = ""): Recallable =
  ## addsServiceGetMetrics
  ## Gets the server related metrics for a given metric and group combination.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   groupKey: string
  ##           : The group key
  ##   metricName: string (required)
  ##             : The metric name
  ##   fromDate: string
  ##           : The start date.
  ##   groupName: string (required)
  ##            : The group name
  ##   toDate: string
  ##         : The end date.
  var path_564312 = newJObject()
  var query_564313 = newJObject()
  add(path_564312, "serviceName", newJString(serviceName))
  add(query_564313, "api-version", newJString(apiVersion))
  add(query_564313, "groupKey", newJString(groupKey))
  add(path_564312, "metricName", newJString(metricName))
  add(query_564313, "fromDate", newJString(fromDate))
  add(path_564312, "groupName", newJString(groupName))
  add(query_564313, "toDate", newJString(toDate))
  result = call_564311.call(path_564312, query_564313, nil, nil, nil)

var addsServiceGetMetrics* = Call_AddsServiceGetMetrics_564300(
    name: "addsServiceGetMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/metrics/{metricName}/groups/{groupName}",
    validator: validate_AddsServiceGetMetrics_564301, base: "",
    url: url_AddsServiceGetMetrics_564302, schemes: {Scheme.Https})
type
  Call_AddsServicesListMetricsAverage_564314 = ref object of OpenApiRestCall_563565
proc url_AddsServicesListMetricsAverage_564316(protocol: Scheme; host: string;
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

proc validate_AddsServicesListMetricsAverage_564315(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the average of the metric values for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   metricName: JString (required)
  ##             : The metric name
  ##   groupName: JString (required)
  ##            : The group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564317 = path.getOrDefault("serviceName")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "serviceName", valid_564317
  var valid_564318 = path.getOrDefault("metricName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "metricName", valid_564318
  var valid_564319 = path.getOrDefault("groupName")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "groupName", valid_564319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564320 = query.getOrDefault("api-version")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "api-version", valid_564320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564321: Call_AddsServicesListMetricsAverage_564314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the average of the metric values for a given metric and group combination.
  ## 
  let valid = call_564321.validator(path, query, header, formData, body)
  let scheme = call_564321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564321.url(scheme.get, call_564321.host, call_564321.base,
                         call_564321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564321, url, valid)

proc call*(call_564322: Call_AddsServicesListMetricsAverage_564314;
          serviceName: string; apiVersion: string; metricName: string;
          groupName: string): Recallable =
  ## addsServicesListMetricsAverage
  ## Gets the average of the metric values for a given metric and group combination.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   metricName: string (required)
  ##             : The metric name
  ##   groupName: string (required)
  ##            : The group name
  var path_564323 = newJObject()
  var query_564324 = newJObject()
  add(path_564323, "serviceName", newJString(serviceName))
  add(query_564324, "api-version", newJString(apiVersion))
  add(path_564323, "metricName", newJString(metricName))
  add(path_564323, "groupName", newJString(groupName))
  result = call_564322.call(path_564323, query_564324, nil, nil, nil)

var addsServicesListMetricsAverage* = Call_AddsServicesListMetricsAverage_564314(
    name: "addsServicesListMetricsAverage", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/metrics/{metricName}/groups/{groupName}/average",
    validator: validate_AddsServicesListMetricsAverage_564315, base: "",
    url: url_AddsServicesListMetricsAverage_564316, schemes: {Scheme.Https})
type
  Call_AddsServicesListMetricsSum_564325 = ref object of OpenApiRestCall_563565
proc url_AddsServicesListMetricsSum_564327(protocol: Scheme; host: string;
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

proc validate_AddsServicesListMetricsSum_564326(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the sum of the metric values for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   metricName: JString (required)
  ##             : The metric name
  ##   groupName: JString (required)
  ##            : The group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564328 = path.getOrDefault("serviceName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "serviceName", valid_564328
  var valid_564329 = path.getOrDefault("metricName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "metricName", valid_564329
  var valid_564330 = path.getOrDefault("groupName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "groupName", valid_564330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564331 = query.getOrDefault("api-version")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "api-version", valid_564331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564332: Call_AddsServicesListMetricsSum_564325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the sum of the metric values for a given metric and group combination.
  ## 
  let valid = call_564332.validator(path, query, header, formData, body)
  let scheme = call_564332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564332.url(scheme.get, call_564332.host, call_564332.base,
                         call_564332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564332, url, valid)

proc call*(call_564333: Call_AddsServicesListMetricsSum_564325;
          serviceName: string; apiVersion: string; metricName: string;
          groupName: string): Recallable =
  ## addsServicesListMetricsSum
  ## Gets the sum of the metric values for a given metric and group combination.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   metricName: string (required)
  ##             : The metric name
  ##   groupName: string (required)
  ##            : The group name
  var path_564334 = newJObject()
  var query_564335 = newJObject()
  add(path_564334, "serviceName", newJString(serviceName))
  add(query_564335, "api-version", newJString(apiVersion))
  add(path_564334, "metricName", newJString(metricName))
  add(path_564334, "groupName", newJString(groupName))
  result = call_564333.call(path_564334, query_564335, nil, nil, nil)

var addsServicesListMetricsSum* = Call_AddsServicesListMetricsSum_564325(
    name: "addsServicesListMetricsSum", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/metrics/{metricName}/groups/{groupName}/sum",
    validator: validate_AddsServicesListMetricsSum_564326, base: "",
    url: url_AddsServicesListMetricsSum_564327, schemes: {Scheme.Https})
type
  Call_AddsServicesListReplicationDetails_564336 = ref object of OpenApiRestCall_563565
proc url_AddsServicesListReplicationDetails_564338(protocol: Scheme; host: string;
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

proc validate_AddsServicesListReplicationDetails_564337(path: JsonNode;
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
  var valid_564339 = path.getOrDefault("serviceName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "serviceName", valid_564339
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
  var valid_564340 = query.getOrDefault("api-version")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "api-version", valid_564340
  var valid_564341 = query.getOrDefault("withDetails")
  valid_564341 = validateParameter(valid_564341, JBool, required = false, default = nil)
  if valid_564341 != nil:
    section.add "withDetails", valid_564341
  var valid_564342 = query.getOrDefault("$filter")
  valid_564342 = validateParameter(valid_564342, JString, required = false,
                                 default = nil)
  if valid_564342 != nil:
    section.add "$filter", valid_564342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564343: Call_AddsServicesListReplicationDetails_564336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets complete domain controller list along with replication details for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564343.validator(path, query, header, formData, body)
  let scheme = call_564343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564343.url(scheme.get, call_564343.host, call_564343.base,
                         call_564343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564343, url, valid)

proc call*(call_564344: Call_AddsServicesListReplicationDetails_564336;
          serviceName: string; apiVersion: string; withDetails: bool = false;
          Filter: string = ""): Recallable =
  ## addsServicesListReplicationDetails
  ## Gets complete domain controller list along with replication details for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   withDetails: bool
  ##              : Indicates if InboundReplicationNeighbor details are required or not.
  ##   Filter: string
  ##         : The server property filter to apply.
  var path_564345 = newJObject()
  var query_564346 = newJObject()
  add(path_564345, "serviceName", newJString(serviceName))
  add(query_564346, "api-version", newJString(apiVersion))
  add(query_564346, "withDetails", newJBool(withDetails))
  add(query_564346, "$filter", newJString(Filter))
  result = call_564344.call(path_564345, query_564346, nil, nil, nil)

var addsServicesListReplicationDetails* = Call_AddsServicesListReplicationDetails_564336(
    name: "addsServicesListReplicationDetails", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/replicationdetails",
    validator: validate_AddsServicesListReplicationDetails_564337, base: "",
    url: url_AddsServicesListReplicationDetails_564338, schemes: {Scheme.Https})
type
  Call_AddsServicesReplicationStatusGet_564347 = ref object of OpenApiRestCall_563565
proc url_AddsServicesReplicationStatusGet_564349(protocol: Scheme; host: string;
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

proc validate_AddsServicesReplicationStatusGet_564348(path: JsonNode;
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
  var valid_564350 = path.getOrDefault("serviceName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "serviceName", valid_564350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564351 = query.getOrDefault("api-version")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "api-version", valid_564351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564352: Call_AddsServicesReplicationStatusGet_564347;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets Replication status for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564352.validator(path, query, header, formData, body)
  let scheme = call_564352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564352.url(scheme.get, call_564352.host, call_564352.base,
                         call_564352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564352, url, valid)

proc call*(call_564353: Call_AddsServicesReplicationStatusGet_564347;
          serviceName: string; apiVersion: string): Recallable =
  ## addsServicesReplicationStatusGet
  ## Gets Replication status for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564354 = newJObject()
  var query_564355 = newJObject()
  add(path_564354, "serviceName", newJString(serviceName))
  add(query_564355, "api-version", newJString(apiVersion))
  result = call_564353.call(path_564354, query_564355, nil, nil, nil)

var addsServicesReplicationStatusGet* = Call_AddsServicesReplicationStatusGet_564347(
    name: "addsServicesReplicationStatusGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/replicationstatus",
    validator: validate_AddsServicesReplicationStatusGet_564348, base: "",
    url: url_AddsServicesReplicationStatusGet_564349, schemes: {Scheme.Https})
type
  Call_AddsServicesListReplicationSummary_564356 = ref object of OpenApiRestCall_563565
proc url_AddsServicesListReplicationSummary_564358(protocol: Scheme; host: string;
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

proc validate_AddsServicesListReplicationSummary_564357(path: JsonNode;
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
  var valid_564359 = path.getOrDefault("serviceName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "serviceName", valid_564359
  result.add "path", section
  ## parameters in `query` object:
  ##   nextPartitionKey: JString (required)
  ##                   : The next partition key to query for.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   isGroupbySite: JBool (required)
  ##                : Indicates if the result should be grouped by site or not.
  ##   nextRowKey: JString (required)
  ##             : The next row key to query for.
  ##   query: JString (required)
  ##        : The custom query.
  ##   $filter: JString
  ##          : The server property filter to apply.
  ##   takeCount: JInt
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `nextPartitionKey` field"
  var valid_564360 = query.getOrDefault("nextPartitionKey")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = newJString(" "))
  if valid_564360 != nil:
    section.add "nextPartitionKey", valid_564360
  var valid_564361 = query.getOrDefault("api-version")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "api-version", valid_564361
  var valid_564362 = query.getOrDefault("isGroupbySite")
  valid_564362 = validateParameter(valid_564362, JBool, required = true, default = nil)
  if valid_564362 != nil:
    section.add "isGroupbySite", valid_564362
  var valid_564363 = query.getOrDefault("nextRowKey")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = newJString(" "))
  if valid_564363 != nil:
    section.add "nextRowKey", valid_564363
  var valid_564364 = query.getOrDefault("query")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "query", valid_564364
  var valid_564365 = query.getOrDefault("$filter")
  valid_564365 = validateParameter(valid_564365, JString, required = false,
                                 default = nil)
  if valid_564365 != nil:
    section.add "$filter", valid_564365
  var valid_564366 = query.getOrDefault("takeCount")
  valid_564366 = validateParameter(valid_564366, JInt, required = false, default = nil)
  if valid_564366 != nil:
    section.add "takeCount", valid_564366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564367: Call_AddsServicesListReplicationSummary_564356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets complete domain controller list along with replication details for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564367.validator(path, query, header, formData, body)
  let scheme = call_564367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564367.url(scheme.get, call_564367.host, call_564367.base,
                         call_564367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564367, url, valid)

proc call*(call_564368: Call_AddsServicesListReplicationSummary_564356;
          serviceName: string; apiVersion: string; isGroupbySite: bool; query: string;
          nextPartitionKey: string = " "; nextRowKey: string = " "; Filter: string = "";
          takeCount: int = 0): Recallable =
  ## addsServicesListReplicationSummary
  ## Gets complete domain controller list along with replication details for a given Active Directory Domain Service, that is onboarded to Azure Active Directory Connect Health.
  ##   nextPartitionKey: string (required)
  ##                   : The next partition key to query for.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   isGroupbySite: bool (required)
  ##                : Indicates if the result should be grouped by site or not.
  ##   nextRowKey: string (required)
  ##             : The next row key to query for.
  ##   query: string (required)
  ##        : The custom query.
  ##   Filter: string
  ##         : The server property filter to apply.
  ##   takeCount: int
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  var path_564369 = newJObject()
  var query_564370 = newJObject()
  add(query_564370, "nextPartitionKey", newJString(nextPartitionKey))
  add(path_564369, "serviceName", newJString(serviceName))
  add(query_564370, "api-version", newJString(apiVersion))
  add(query_564370, "isGroupbySite", newJBool(isGroupbySite))
  add(query_564370, "nextRowKey", newJString(nextRowKey))
  add(query_564370, "query", newJString(query))
  add(query_564370, "$filter", newJString(Filter))
  add(query_564370, "takeCount", newJInt(takeCount))
  result = call_564368.call(path_564369, query_564370, nil, nil, nil)

var addsServicesListReplicationSummary* = Call_AddsServicesListReplicationSummary_564356(
    name: "addsServicesListReplicationSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/replicationsummary",
    validator: validate_AddsServicesListReplicationSummary_564357, base: "",
    url: url_AddsServicesListReplicationSummary_564358, schemes: {Scheme.Https})
type
  Call_AddsServicesServiceMembersAdd_564383 = ref object of OpenApiRestCall_563565
proc url_AddsServicesServiceMembersAdd_564385(protocol: Scheme; host: string;
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

proc validate_AddsServicesServiceMembersAdd_564384(path: JsonNode; query: JsonNode;
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
  var valid_564386 = path.getOrDefault("serviceName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "serviceName", valid_564386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564387 = query.getOrDefault("api-version")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "api-version", valid_564387
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

proc call*(call_564389: Call_AddsServicesServiceMembersAdd_564383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Onboards  a server, for a given Active Directory Domain Controller service, to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_564389.validator(path, query, header, formData, body)
  let scheme = call_564389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564389.url(scheme.get, call_564389.host, call_564389.base,
                         call_564389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564389, url, valid)

proc call*(call_564390: Call_AddsServicesServiceMembersAdd_564383;
          serviceName: string; serviceMember: JsonNode; apiVersion: string): Recallable =
  ## addsServicesServiceMembersAdd
  ## Onboards  a server, for a given Active Directory Domain Controller service, to Azure Active Directory Connect Health Service.
  ##   serviceName: string (required)
  ##              : The name of the service under which the server is to be onboarded.
  ##   serviceMember: JObject (required)
  ##                : The server object.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564391 = newJObject()
  var query_564392 = newJObject()
  var body_564393 = newJObject()
  add(path_564391, "serviceName", newJString(serviceName))
  if serviceMember != nil:
    body_564393 = serviceMember
  add(query_564392, "api-version", newJString(apiVersion))
  result = call_564390.call(path_564391, query_564392, nil, nil, body_564393)

var addsServicesServiceMembersAdd* = Call_AddsServicesServiceMembersAdd_564383(
    name: "addsServicesServiceMembersAdd", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/servicemembers",
    validator: validate_AddsServicesServiceMembersAdd_564384, base: "",
    url: url_AddsServicesServiceMembersAdd_564385, schemes: {Scheme.Https})
type
  Call_AddsServicesServiceMembersList_564371 = ref object of OpenApiRestCall_563565
proc url_AddsServicesServiceMembersList_564373(protocol: Scheme; host: string;
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

proc validate_AddsServicesServiceMembersList_564372(path: JsonNode;
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
  var valid_564374 = path.getOrDefault("serviceName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "serviceName", valid_564374
  result.add "path", section
  ## parameters in `query` object:
  ##   dimensionType: JString
  ##                : The server specific dimension.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   dimensionSignature: JString
  ##                     : The value of the dimension.
  ##   $filter: JString
  ##          : The server property filter to apply.
  section = newJObject()
  var valid_564375 = query.getOrDefault("dimensionType")
  valid_564375 = validateParameter(valid_564375, JString, required = false,
                                 default = nil)
  if valid_564375 != nil:
    section.add "dimensionType", valid_564375
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564376 = query.getOrDefault("api-version")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "api-version", valid_564376
  var valid_564377 = query.getOrDefault("dimensionSignature")
  valid_564377 = validateParameter(valid_564377, JString, required = false,
                                 default = nil)
  if valid_564377 != nil:
    section.add "dimensionSignature", valid_564377
  var valid_564378 = query.getOrDefault("$filter")
  valid_564378 = validateParameter(valid_564378, JString, required = false,
                                 default = nil)
  if valid_564378 != nil:
    section.add "$filter", valid_564378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564379: Call_AddsServicesServiceMembersList_564371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the servers, for a given Active Directory Domain Controller service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_564379.validator(path, query, header, formData, body)
  let scheme = call_564379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564379.url(scheme.get, call_564379.host, call_564379.base,
                         call_564379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564379, url, valid)

proc call*(call_564380: Call_AddsServicesServiceMembersList_564371;
          serviceName: string; apiVersion: string; dimensionType: string = "";
          dimensionSignature: string = ""; Filter: string = ""): Recallable =
  ## addsServicesServiceMembersList
  ## Gets the details of the servers, for a given Active Directory Domain Controller service, that are onboarded to Azure Active Directory Connect Health Service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   dimensionType: string
  ##                : The server specific dimension.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   dimensionSignature: string
  ##                     : The value of the dimension.
  ##   Filter: string
  ##         : The server property filter to apply.
  var path_564381 = newJObject()
  var query_564382 = newJObject()
  add(path_564381, "serviceName", newJString(serviceName))
  add(query_564382, "dimensionType", newJString(dimensionType))
  add(query_564382, "api-version", newJString(apiVersion))
  add(query_564382, "dimensionSignature", newJString(dimensionSignature))
  add(query_564382, "$filter", newJString(Filter))
  result = call_564380.call(path_564381, query_564382, nil, nil, nil)

var addsServicesServiceMembersList* = Call_AddsServicesServiceMembersList_564371(
    name: "addsServicesServiceMembersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/servicemembers",
    validator: validate_AddsServicesServiceMembersList_564372, base: "",
    url: url_AddsServicesServiceMembersList_564373, schemes: {Scheme.Https})
type
  Call_AddsServiceMembersGet_564394 = ref object of OpenApiRestCall_563565
proc url_AddsServiceMembersGet_564396(protocol: Scheme; host: string; base: string;
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

proc validate_AddsServiceMembersGet_564395(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a server, for a given Active Directory Domain Controller service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564397 = path.getOrDefault("serviceName")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "serviceName", valid_564397
  var valid_564398 = path.getOrDefault("serviceMemberId")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "serviceMemberId", valid_564398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564399 = query.getOrDefault("api-version")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "api-version", valid_564399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564400: Call_AddsServiceMembersGet_564394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a server, for a given Active Directory Domain Controller service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_564400.validator(path, query, header, formData, body)
  let scheme = call_564400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564400.url(scheme.get, call_564400.host, call_564400.base,
                         call_564400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564400, url, valid)

proc call*(call_564401: Call_AddsServiceMembersGet_564394; serviceName: string;
          apiVersion: string; serviceMemberId: string): Recallable =
  ## addsServiceMembersGet
  ## Gets the details of a server, for a given Active Directory Domain Controller service, that are onboarded to Azure Active Directory Connect Health Service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  var path_564402 = newJObject()
  var query_564403 = newJObject()
  add(path_564402, "serviceName", newJString(serviceName))
  add(query_564403, "api-version", newJString(apiVersion))
  add(path_564402, "serviceMemberId", newJString(serviceMemberId))
  result = call_564401.call(path_564402, query_564403, nil, nil, nil)

var addsServiceMembersGet* = Call_AddsServiceMembersGet_564394(
    name: "addsServiceMembersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/servicemembers/{serviceMemberId}",
    validator: validate_AddsServiceMembersGet_564395, base: "",
    url: url_AddsServiceMembersGet_564396, schemes: {Scheme.Https})
type
  Call_AddsServiceMembersDelete_564404 = ref object of OpenApiRestCall_563565
proc url_AddsServiceMembersDelete_564406(protocol: Scheme; host: string;
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

proc validate_AddsServiceMembersDelete_564405(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Active Directory Domain Controller server that has been onboarded to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564407 = path.getOrDefault("serviceName")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "serviceName", valid_564407
  var valid_564408 = path.getOrDefault("serviceMemberId")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "serviceMemberId", valid_564408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   confirm: JBool
  ##          : Indicates if the server will be permanently deleted or disabled. True indicates that the server will be permanently deleted and False indicates that the server will be marked disabled and then deleted after 30 days, if it is not re-registered.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564409 = query.getOrDefault("api-version")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "api-version", valid_564409
  var valid_564410 = query.getOrDefault("confirm")
  valid_564410 = validateParameter(valid_564410, JBool, required = false, default = nil)
  if valid_564410 != nil:
    section.add "confirm", valid_564410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564411: Call_AddsServiceMembersDelete_564404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Active Directory Domain Controller server that has been onboarded to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_564411.validator(path, query, header, formData, body)
  let scheme = call_564411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564411.url(scheme.get, call_564411.host, call_564411.base,
                         call_564411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564411, url, valid)

proc call*(call_564412: Call_AddsServiceMembersDelete_564404; serviceName: string;
          apiVersion: string; serviceMemberId: string; confirm: bool = false): Recallable =
  ## addsServiceMembersDelete
  ## Deletes a Active Directory Domain Controller server that has been onboarded to Azure Active Directory Connect Health Service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   confirm: bool
  ##          : Indicates if the server will be permanently deleted or disabled. True indicates that the server will be permanently deleted and False indicates that the server will be marked disabled and then deleted after 30 days, if it is not re-registered.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  var path_564413 = newJObject()
  var query_564414 = newJObject()
  add(path_564413, "serviceName", newJString(serviceName))
  add(query_564414, "api-version", newJString(apiVersion))
  add(query_564414, "confirm", newJBool(confirm))
  add(path_564413, "serviceMemberId", newJString(serviceMemberId))
  result = call_564412.call(path_564413, query_564414, nil, nil, nil)

var addsServiceMembersDelete* = Call_AddsServiceMembersDelete_564404(
    name: "addsServiceMembersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/servicemembers/{serviceMemberId}",
    validator: validate_AddsServiceMembersDelete_564405, base: "",
    url: url_AddsServiceMembersDelete_564406, schemes: {Scheme.Https})
type
  Call_AddsServicesListServerAlerts_564415 = ref object of OpenApiRestCall_563565
proc url_AddsServicesListServerAlerts_564417(protocol: Scheme; host: string;
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

proc validate_AddsServicesListServerAlerts_564416(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an alert for a given Active Directory Domain Controller service and server combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id for which the alert details needs to be queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564418 = path.getOrDefault("serviceName")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "serviceName", valid_564418
  var valid_564419 = path.getOrDefault("serviceMemberId")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "serviceMemberId", valid_564419
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   state: JString
  ##        : The alert state to query for.
  ##   to: JString
  ##     : The end date till when to query for.
  ##   from: JString
  ##       : The start date to query for.
  ##   $filter: JString
  ##          : The alert property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564420 = query.getOrDefault("api-version")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "api-version", valid_564420
  var valid_564421 = query.getOrDefault("state")
  valid_564421 = validateParameter(valid_564421, JString, required = false,
                                 default = nil)
  if valid_564421 != nil:
    section.add "state", valid_564421
  var valid_564422 = query.getOrDefault("to")
  valid_564422 = validateParameter(valid_564422, JString, required = false,
                                 default = nil)
  if valid_564422 != nil:
    section.add "to", valid_564422
  var valid_564423 = query.getOrDefault("from")
  valid_564423 = validateParameter(valid_564423, JString, required = false,
                                 default = nil)
  if valid_564423 != nil:
    section.add "from", valid_564423
  var valid_564424 = query.getOrDefault("$filter")
  valid_564424 = validateParameter(valid_564424, JString, required = false,
                                 default = nil)
  if valid_564424 != nil:
    section.add "$filter", valid_564424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564425: Call_AddsServicesListServerAlerts_564415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an alert for a given Active Directory Domain Controller service and server combination.
  ## 
  let valid = call_564425.validator(path, query, header, formData, body)
  let scheme = call_564425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564425.url(scheme.get, call_564425.host, call_564425.base,
                         call_564425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564425, url, valid)

proc call*(call_564426: Call_AddsServicesListServerAlerts_564415;
          serviceName: string; apiVersion: string; serviceMemberId: string;
          state: string = ""; to: string = ""; `from`: string = ""; Filter: string = ""): Recallable =
  ## addsServicesListServerAlerts
  ## Gets the details of an alert for a given Active Directory Domain Controller service and server combination.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   state: string
  ##        : The alert state to query for.
  ##   to: string
  ##     : The end date till when to query for.
  ##   from: string
  ##       : The start date to query for.
  ##   Filter: string
  ##         : The alert property filter to apply.
  ##   serviceMemberId: string (required)
  ##                  : The server Id for which the alert details needs to be queried.
  var path_564427 = newJObject()
  var query_564428 = newJObject()
  add(path_564427, "serviceName", newJString(serviceName))
  add(query_564428, "api-version", newJString(apiVersion))
  add(query_564428, "state", newJString(state))
  add(query_564428, "to", newJString(to))
  add(query_564428, "from", newJString(`from`))
  add(query_564428, "$filter", newJString(Filter))
  add(path_564427, "serviceMemberId", newJString(serviceMemberId))
  result = call_564426.call(path_564427, query_564428, nil, nil, nil)

var addsServicesListServerAlerts* = Call_AddsServicesListServerAlerts_564415(
    name: "addsServicesListServerAlerts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/servicemembers/{serviceMemberId}/alerts",
    validator: validate_AddsServicesListServerAlerts_564416, base: "",
    url: url_AddsServicesListServerAlerts_564417, schemes: {Scheme.Https})
type
  Call_AddsServiceMembersListCredentials_564429 = ref object of OpenApiRestCall_563565
proc url_AddsServiceMembersListCredentials_564431(protocol: Scheme; host: string;
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

proc validate_AddsServiceMembersListCredentials_564430(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the credentials of the server which is needed by the agent to connect to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564432 = path.getOrDefault("serviceName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "serviceName", valid_564432
  var valid_564433 = path.getOrDefault("serviceMemberId")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "serviceMemberId", valid_564433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $filter: JString
  ##          : The property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564434 = query.getOrDefault("api-version")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "api-version", valid_564434
  var valid_564435 = query.getOrDefault("$filter")
  valid_564435 = validateParameter(valid_564435, JString, required = false,
                                 default = nil)
  if valid_564435 != nil:
    section.add "$filter", valid_564435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564436: Call_AddsServiceMembersListCredentials_564429;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the credentials of the server which is needed by the agent to connect to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_564436.validator(path, query, header, formData, body)
  let scheme = call_564436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564436.url(scheme.get, call_564436.host, call_564436.base,
                         call_564436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564436, url, valid)

proc call*(call_564437: Call_AddsServiceMembersListCredentials_564429;
          serviceName: string; apiVersion: string; serviceMemberId: string;
          Filter: string = ""): Recallable =
  ## addsServiceMembersListCredentials
  ## Gets the credentials of the server which is needed by the agent to connect to Azure Active Directory Connect Health Service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   Filter: string
  ##         : The property filter to apply.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  var path_564438 = newJObject()
  var query_564439 = newJObject()
  add(path_564438, "serviceName", newJString(serviceName))
  add(query_564439, "api-version", newJString(apiVersion))
  add(query_564439, "$filter", newJString(Filter))
  add(path_564438, "serviceMemberId", newJString(serviceMemberId))
  result = call_564437.call(path_564438, query_564439, nil, nil, nil)

var addsServiceMembersListCredentials* = Call_AddsServiceMembersListCredentials_564429(
    name: "addsServiceMembersListCredentials", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/addsservices/{serviceName}/servicemembers/{serviceMemberId}/credentials",
    validator: validate_AddsServiceMembersListCredentials_564430, base: "",
    url: url_AddsServiceMembersListCredentials_564431, schemes: {Scheme.Https})
type
  Call_ConfigurationAdd_564447 = ref object of OpenApiRestCall_563565
proc url_ConfigurationAdd_564449(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ConfigurationAdd_564448(path: JsonNode; query: JsonNode;
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
  var valid_564450 = query.getOrDefault("api-version")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "api-version", valid_564450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564451: Call_ConfigurationAdd_564447; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Onboards a tenant in Azure Active Directory Connect Health.
  ## 
  let valid = call_564451.validator(path, query, header, formData, body)
  let scheme = call_564451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564451.url(scheme.get, call_564451.host, call_564451.base,
                         call_564451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564451, url, valid)

proc call*(call_564452: Call_ConfigurationAdd_564447; apiVersion: string): Recallable =
  ## configurationAdd
  ## Onboards a tenant in Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_564453 = newJObject()
  add(query_564453, "api-version", newJString(apiVersion))
  result = call_564452.call(nil, query_564453, nil, nil, nil)

var configurationAdd* = Call_ConfigurationAdd_564447(name: "configurationAdd",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/configuration",
    validator: validate_ConfigurationAdd_564448, base: "",
    url: url_ConfigurationAdd_564449, schemes: {Scheme.Https})
type
  Call_ConfigurationGet_564440 = ref object of OpenApiRestCall_563565
proc url_ConfigurationGet_564442(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ConfigurationGet_564441(path: JsonNode; query: JsonNode;
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
  var valid_564443 = query.getOrDefault("api-version")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "api-version", valid_564443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564444: Call_ConfigurationGet_564440; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a tenant onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564444.validator(path, query, header, formData, body)
  let scheme = call_564444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564444.url(scheme.get, call_564444.host, call_564444.base,
                         call_564444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564444, url, valid)

proc call*(call_564445: Call_ConfigurationGet_564440; apiVersion: string): Recallable =
  ## configurationGet
  ## Gets the details of a tenant onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_564446 = newJObject()
  add(query_564446, "api-version", newJString(apiVersion))
  result = call_564445.call(nil, query_564446, nil, nil, nil)

var configurationGet* = Call_ConfigurationGet_564440(name: "configurationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/configuration",
    validator: validate_ConfigurationGet_564441, base: "",
    url: url_ConfigurationGet_564442, schemes: {Scheme.Https})
type
  Call_ConfigurationUpdate_564454 = ref object of OpenApiRestCall_563565
proc url_ConfigurationUpdate_564456(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ConfigurationUpdate_564455(path: JsonNode; query: JsonNode;
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
  var valid_564457 = query.getOrDefault("api-version")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "api-version", valid_564457
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

proc call*(call_564459: Call_ConfigurationUpdate_564454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates tenant properties for tenants onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564459.validator(path, query, header, formData, body)
  let scheme = call_564459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564459.url(scheme.get, call_564459.host, call_564459.base,
                         call_564459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564459, url, valid)

proc call*(call_564460: Call_ConfigurationUpdate_564454; tenant: JsonNode;
          apiVersion: string): Recallable =
  ## configurationUpdate
  ## Updates tenant properties for tenants onboarded to Azure Active Directory Connect Health.
  ##   tenant: JObject (required)
  ##         : The tenant object with the properties set to the updated value.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_564461 = newJObject()
  var body_564462 = newJObject()
  if tenant != nil:
    body_564462 = tenant
  add(query_564461, "api-version", newJString(apiVersion))
  result = call_564460.call(nil, query_564461, nil, nil, body_564462)

var configurationUpdate* = Call_ConfigurationUpdate_564454(
    name: "configurationUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/configuration",
    validator: validate_ConfigurationUpdate_564455, base: "",
    url: url_ConfigurationUpdate_564456, schemes: {Scheme.Https})
type
  Call_OperationsList_564463 = ref object of OpenApiRestCall_563565
proc url_OperationsList_564465(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564464(path: JsonNode; query: JsonNode;
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
  var valid_564466 = query.getOrDefault("api-version")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "api-version", valid_564466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564467: Call_OperationsList_564463; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available Azure Data Factory API operations.
  ## 
  let valid = call_564467.validator(path, query, header, formData, body)
  let scheme = call_564467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564467.url(scheme.get, call_564467.host, call_564467.base,
                         call_564467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564467, url, valid)

proc call*(call_564468: Call_OperationsList_564463; apiVersion: string): Recallable =
  ## operationsList
  ## Lists the available Azure Data Factory API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_564469 = newJObject()
  add(query_564469, "api-version", newJString(apiVersion))
  result = call_564468.call(nil, query_564469, nil, nil, nil)

var operationsList* = Call_OperationsList_564463(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/operations",
    validator: validate_OperationsList_564464, base: "", url: url_OperationsList_564465,
    schemes: {Scheme.Https})
type
  Call_ReportsGetDevOps_564470 = ref object of OpenApiRestCall_563565
proc url_ReportsGetDevOps_564472(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsGetDevOps_564471(path: JsonNode; query: JsonNode;
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
  var valid_564473 = query.getOrDefault("api-version")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "api-version", valid_564473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564474: Call_ReportsGetDevOps_564470; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the user is enabled for Dev Ops access.
  ## 
  let valid = call_564474.validator(path, query, header, formData, body)
  let scheme = call_564474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564474.url(scheme.get, call_564474.host, call_564474.base,
                         call_564474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564474, url, valid)

proc call*(call_564475: Call_ReportsGetDevOps_564470; apiVersion: string): Recallable =
  ## reportsGetDevOps
  ## Checks if the user is enabled for Dev Ops access.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_564476 = newJObject()
  add(query_564476, "api-version", newJString(apiVersion))
  result = call_564475.call(nil, query_564476, nil, nil, nil)

var reportsGetDevOps* = Call_ReportsGetDevOps_564470(name: "reportsGetDevOps",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/reports/DevOps/IsDevOps",
    validator: validate_ReportsGetDevOps_564471, base: "",
    url: url_ReportsGetDevOps_564472, schemes: {Scheme.Https})
type
  Call_ServiceMembersListConnectors_564477 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersListConnectors_564479(protocol: Scheme; host: string;
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

proc validate_ServiceMembersListConnectors_564478(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the connector details for a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564480 = path.getOrDefault("serviceName")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "serviceName", valid_564480
  var valid_564481 = path.getOrDefault("serviceMemberId")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "serviceMemberId", valid_564481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564482 = query.getOrDefault("api-version")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "api-version", valid_564482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564483: Call_ServiceMembersListConnectors_564477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the connector details for a service.
  ## 
  let valid = call_564483.validator(path, query, header, formData, body)
  let scheme = call_564483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564483.url(scheme.get, call_564483.host, call_564483.base,
                         call_564483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564483, url, valid)

proc call*(call_564484: Call_ServiceMembersListConnectors_564477;
          serviceName: string; apiVersion: string; serviceMemberId: string): Recallable =
  ## serviceMembersListConnectors
  ## Gets the connector details for a service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  var path_564485 = newJObject()
  var query_564486 = newJObject()
  add(path_564485, "serviceName", newJString(serviceName))
  add(query_564486, "api-version", newJString(apiVersion))
  add(path_564485, "serviceMemberId", newJString(serviceMemberId))
  result = call_564484.call(path_564485, query_564486, nil, nil, nil)

var serviceMembersListConnectors* = Call_ServiceMembersListConnectors_564477(
    name: "serviceMembersListConnectors", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/service/{serviceName}/servicemembers/{serviceMemberId}/connectors",
    validator: validate_ServiceMembersListConnectors_564478, base: "",
    url: url_ServiceMembersListConnectors_564479, schemes: {Scheme.Https})
type
  Call_ServicesAdd_564498 = ref object of OpenApiRestCall_563565
proc url_ServicesAdd_564500(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ServicesAdd_564499(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564501 = query.getOrDefault("api-version")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "api-version", valid_564501
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

proc call*(call_564503: Call_ServicesAdd_564498; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Onboards a service for a given tenant in Azure Active Directory Connect Health.
  ## 
  let valid = call_564503.validator(path, query, header, formData, body)
  let scheme = call_564503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564503.url(scheme.get, call_564503.host, call_564503.base,
                         call_564503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564503, url, valid)

proc call*(call_564504: Call_ServicesAdd_564498; apiVersion: string;
          service: JsonNode): Recallable =
  ## servicesAdd
  ## Onboards a service for a given tenant in Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   service: JObject (required)
  ##          : The service object.
  var query_564505 = newJObject()
  var body_564506 = newJObject()
  add(query_564505, "api-version", newJString(apiVersion))
  if service != nil:
    body_564506 = service
  result = call_564504.call(nil, query_564505, nil, nil, body_564506)

var servicesAdd* = Call_ServicesAdd_564498(name: "servicesAdd",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services",
                                        validator: validate_ServicesAdd_564499,
                                        base: "", url: url_ServicesAdd_564500,
                                        schemes: {Scheme.Https})
type
  Call_ServicesList_564487 = ref object of OpenApiRestCall_563565
proc url_ServicesList_564489(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ServicesList_564488(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of services, for a tenant, that are onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   skipCount: JInt
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   serviceType: JString
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   $filter: JString
  ##          : The service property filter to apply.
  ##   takeCount: JInt
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564490 = query.getOrDefault("api-version")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "api-version", valid_564490
  var valid_564491 = query.getOrDefault("skipCount")
  valid_564491 = validateParameter(valid_564491, JInt, required = false, default = nil)
  if valid_564491 != nil:
    section.add "skipCount", valid_564491
  var valid_564492 = query.getOrDefault("serviceType")
  valid_564492 = validateParameter(valid_564492, JString, required = false,
                                 default = nil)
  if valid_564492 != nil:
    section.add "serviceType", valid_564492
  var valid_564493 = query.getOrDefault("$filter")
  valid_564493 = validateParameter(valid_564493, JString, required = false,
                                 default = nil)
  if valid_564493 != nil:
    section.add "$filter", valid_564493
  var valid_564494 = query.getOrDefault("takeCount")
  valid_564494 = validateParameter(valid_564494, JInt, required = false, default = nil)
  if valid_564494 != nil:
    section.add "takeCount", valid_564494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564495: Call_ServicesList_564487; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of services, for a tenant, that are onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564495.validator(path, query, header, formData, body)
  let scheme = call_564495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564495.url(scheme.get, call_564495.host, call_564495.base,
                         call_564495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564495, url, valid)

proc call*(call_564496: Call_ServicesList_564487; apiVersion: string;
          skipCount: int = 0; serviceType: string = ""; Filter: string = "";
          takeCount: int = 0): Recallable =
  ## servicesList
  ## Gets the details of services, for a tenant, that are onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   skipCount: int
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   serviceType: string
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   Filter: string
  ##         : The service property filter to apply.
  ##   takeCount: int
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  var query_564497 = newJObject()
  add(query_564497, "api-version", newJString(apiVersion))
  add(query_564497, "skipCount", newJInt(skipCount))
  add(query_564497, "serviceType", newJString(serviceType))
  add(query_564497, "$filter", newJString(Filter))
  add(query_564497, "takeCount", newJInt(takeCount))
  result = call_564496.call(nil, query_564497, nil, nil, nil)

var servicesList* = Call_ServicesList_564487(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/services",
    validator: validate_ServicesList_564488, base: "", url: url_ServicesList_564489,
    schemes: {Scheme.Https})
type
  Call_ServicesListPremium_564507 = ref object of OpenApiRestCall_563565
proc url_ServicesListPremium_564509(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ServicesListPremium_564508(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the details of services for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   skipCount: JInt
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   serviceType: JString
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   $filter: JString
  ##          : The service property filter to apply.
  ##   takeCount: JInt
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564510 = query.getOrDefault("api-version")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = nil)
  if valid_564510 != nil:
    section.add "api-version", valid_564510
  var valid_564511 = query.getOrDefault("skipCount")
  valid_564511 = validateParameter(valid_564511, JInt, required = false, default = nil)
  if valid_564511 != nil:
    section.add "skipCount", valid_564511
  var valid_564512 = query.getOrDefault("serviceType")
  valid_564512 = validateParameter(valid_564512, JString, required = false,
                                 default = nil)
  if valid_564512 != nil:
    section.add "serviceType", valid_564512
  var valid_564513 = query.getOrDefault("$filter")
  valid_564513 = validateParameter(valid_564513, JString, required = false,
                                 default = nil)
  if valid_564513 != nil:
    section.add "$filter", valid_564513
  var valid_564514 = query.getOrDefault("takeCount")
  valid_564514 = validateParameter(valid_564514, JInt, required = false, default = nil)
  if valid_564514 != nil:
    section.add "takeCount", valid_564514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564515: Call_ServicesListPremium_564507; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of services for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564515.validator(path, query, header, formData, body)
  let scheme = call_564515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564515.url(scheme.get, call_564515.host, call_564515.base,
                         call_564515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564515, url, valid)

proc call*(call_564516: Call_ServicesListPremium_564507; apiVersion: string;
          skipCount: int = 0; serviceType: string = ""; Filter: string = "";
          takeCount: int = 0): Recallable =
  ## servicesListPremium
  ## Gets the details of services for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   skipCount: int
  ##            : The skip count, which specifies the number of elements that can be bypassed from a sequence and then return the remaining elements.
  ##   serviceType: string
  ##              : The service type for the services onboarded to Azure Active Directory Connect Health. Depending on whether the service is monitoring, ADFS, Sync or ADDS roles, the service type can either be AdFederationService or AadSyncService or AdDomainService.
  ##   Filter: string
  ##         : The service property filter to apply.
  ##   takeCount: int
  ##            : The take count , which specifies the number of elements that can be returned from a sequence.
  var query_564517 = newJObject()
  add(query_564517, "api-version", newJString(apiVersion))
  add(query_564517, "skipCount", newJInt(skipCount))
  add(query_564517, "serviceType", newJString(serviceType))
  add(query_564517, "$filter", newJString(Filter))
  add(query_564517, "takeCount", newJInt(takeCount))
  result = call_564516.call(nil, query_564517, nil, nil, nil)

var servicesListPremium* = Call_ServicesListPremium_564507(
    name: "servicesListPremium", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/services/premiumCheck",
    validator: validate_ServicesListPremium_564508, base: "",
    url: url_ServicesListPremium_564509, schemes: {Scheme.Https})
type
  Call_ServicesGet_564518 = ref object of OpenApiRestCall_563565
proc url_ServicesGet_564520(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesGet_564519(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564521 = path.getOrDefault("serviceName")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "serviceName", valid_564521
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564522 = query.getOrDefault("api-version")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "api-version", valid_564522
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564523: Call_ServicesGet_564518; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a service for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564523.validator(path, query, header, formData, body)
  let scheme = call_564523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564523.url(scheme.get, call_564523.host, call_564523.base,
                         call_564523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564523, url, valid)

proc call*(call_564524: Call_ServicesGet_564518; serviceName: string;
          apiVersion: string): Recallable =
  ## servicesGet
  ## Gets the details of a service for a tenant having Azure AD Premium license and is onboarded to Azure Active Directory Connect Health.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564525 = newJObject()
  var query_564526 = newJObject()
  add(path_564525, "serviceName", newJString(serviceName))
  add(query_564526, "api-version", newJString(apiVersion))
  result = call_564524.call(path_564525, query_564526, nil, nil, nil)

var servicesGet* = Call_ServicesGet_564518(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}",
                                        validator: validate_ServicesGet_564519,
                                        base: "", url: url_ServicesGet_564520,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_564537 = ref object of OpenApiRestCall_563565
proc url_ServicesUpdate_564539(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesUpdate_564538(path: JsonNode; query: JsonNode;
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
  var valid_564540 = path.getOrDefault("serviceName")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "serviceName", valid_564540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564541 = query.getOrDefault("api-version")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "api-version", valid_564541
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

proc call*(call_564543: Call_ServicesUpdate_564537; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the service properties of an onboarded service.
  ## 
  let valid = call_564543.validator(path, query, header, formData, body)
  let scheme = call_564543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564543.url(scheme.get, call_564543.host, call_564543.base,
                         call_564543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564543, url, valid)

proc call*(call_564544: Call_ServicesUpdate_564537; serviceName: string;
          apiVersion: string; service: JsonNode): Recallable =
  ## servicesUpdate
  ## Updates the service properties of an onboarded service.
  ##   serviceName: string (required)
  ##              : The name of the service which needs to be deleted.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   service: JObject (required)
  ##          : The service object.
  var path_564545 = newJObject()
  var query_564546 = newJObject()
  var body_564547 = newJObject()
  add(path_564545, "serviceName", newJString(serviceName))
  add(query_564546, "api-version", newJString(apiVersion))
  if service != nil:
    body_564547 = service
  result = call_564544.call(path_564545, query_564546, nil, nil, body_564547)

var servicesUpdate* = Call_ServicesUpdate_564537(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}",
    validator: validate_ServicesUpdate_564538, base: "", url: url_ServicesUpdate_564539,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_564527 = ref object of OpenApiRestCall_563565
proc url_ServicesDelete_564529(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesDelete_564528(path: JsonNode; query: JsonNode;
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
  var valid_564530 = path.getOrDefault("serviceName")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "serviceName", valid_564530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   confirm: JBool
  ##          : Indicates if the service will be permanently deleted or disabled. True indicates that the service will be permanently deleted and False indicates that the service will be marked disabled and then deleted after 30 days, if it is not re-registered.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564531 = query.getOrDefault("api-version")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "api-version", valid_564531
  var valid_564532 = query.getOrDefault("confirm")
  valid_564532 = validateParameter(valid_564532, JBool, required = false, default = nil)
  if valid_564532 != nil:
    section.add "confirm", valid_564532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564533: Call_ServicesDelete_564527; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a service which is onboarded to Azure Active Directory Connect Health.
  ## 
  let valid = call_564533.validator(path, query, header, formData, body)
  let scheme = call_564533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564533.url(scheme.get, call_564533.host, call_564533.base,
                         call_564533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564533, url, valid)

proc call*(call_564534: Call_ServicesDelete_564527; serviceName: string;
          apiVersion: string; confirm: bool = false): Recallable =
  ## servicesDelete
  ## Deletes a service which is onboarded to Azure Active Directory Connect Health.
  ##   serviceName: string (required)
  ##              : The name of the service which needs to be deleted.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   confirm: bool
  ##          : Indicates if the service will be permanently deleted or disabled. True indicates that the service will be permanently deleted and False indicates that the service will be marked disabled and then deleted after 30 days, if it is not re-registered.
  var path_564535 = newJObject()
  var query_564536 = newJObject()
  add(path_564535, "serviceName", newJString(serviceName))
  add(query_564536, "api-version", newJString(apiVersion))
  add(query_564536, "confirm", newJBool(confirm))
  result = call_564534.call(path_564535, query_564536, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_564527(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com",
    route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}",
    validator: validate_ServicesDelete_564528, base: "", url: url_ServicesDelete_564529,
    schemes: {Scheme.Https})
type
  Call_ServicesGetTenantWhitelisting_564548 = ref object of OpenApiRestCall_563565
proc url_ServicesGetTenantWhitelisting_564550(protocol: Scheme; host: string;
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

proc validate_ServicesGetTenantWhitelisting_564549(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks if the tenant, to which a service is registered, is whitelisted to use a feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   featureName: JString (required)
  ##              : The name of the feature.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564551 = path.getOrDefault("serviceName")
  valid_564551 = validateParameter(valid_564551, JString, required = true,
                                 default = nil)
  if valid_564551 != nil:
    section.add "serviceName", valid_564551
  var valid_564552 = path.getOrDefault("featureName")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "featureName", valid_564552
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564553 = query.getOrDefault("api-version")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "api-version", valid_564553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564554: Call_ServicesGetTenantWhitelisting_564548; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the tenant, to which a service is registered, is whitelisted to use a feature.
  ## 
  let valid = call_564554.validator(path, query, header, formData, body)
  let scheme = call_564554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564554.url(scheme.get, call_564554.host, call_564554.base,
                         call_564554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564554, url, valid)

proc call*(call_564555: Call_ServicesGetTenantWhitelisting_564548;
          serviceName: string; apiVersion: string; featureName: string): Recallable =
  ## servicesGetTenantWhitelisting
  ## Checks if the tenant, to which a service is registered, is whitelisted to use a feature.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   featureName: string (required)
  ##              : The name of the feature.
  var path_564556 = newJObject()
  var query_564557 = newJObject()
  add(path_564556, "serviceName", newJString(serviceName))
  add(query_564557, "api-version", newJString(apiVersion))
  add(path_564556, "featureName", newJString(featureName))
  result = call_564555.call(path_564556, query_564557, nil, nil, nil)

var servicesGetTenantWhitelisting* = Call_ServicesGetTenantWhitelisting_564548(
    name: "servicesGetTenantWhitelisting", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/TenantWhitelisting/{featureName}",
    validator: validate_ServicesGetTenantWhitelisting_564549, base: "",
    url: url_ServicesGetTenantWhitelisting_564550, schemes: {Scheme.Https})
type
  Call_ServicesListAlerts_564558 = ref object of OpenApiRestCall_563565
proc url_ServicesListAlerts_564560(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesListAlerts_564559(path: JsonNode; query: JsonNode;
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
  var valid_564561 = path.getOrDefault("serviceName")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "serviceName", valid_564561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   state: JString
  ##        : The alert state to query for.
  ##   to: JString
  ##     : The end date till when to query for.
  ##   from: JString
  ##       : The start date to query for.
  ##   $filter: JString
  ##          : The alert property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564562 = query.getOrDefault("api-version")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "api-version", valid_564562
  var valid_564563 = query.getOrDefault("state")
  valid_564563 = validateParameter(valid_564563, JString, required = false,
                                 default = nil)
  if valid_564563 != nil:
    section.add "state", valid_564563
  var valid_564564 = query.getOrDefault("to")
  valid_564564 = validateParameter(valid_564564, JString, required = false,
                                 default = nil)
  if valid_564564 != nil:
    section.add "to", valid_564564
  var valid_564565 = query.getOrDefault("from")
  valid_564565 = validateParameter(valid_564565, JString, required = false,
                                 default = nil)
  if valid_564565 != nil:
    section.add "from", valid_564565
  var valid_564566 = query.getOrDefault("$filter")
  valid_564566 = validateParameter(valid_564566, JString, required = false,
                                 default = nil)
  if valid_564566 != nil:
    section.add "$filter", valid_564566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564567: Call_ServicesListAlerts_564558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alerts for a given service.
  ## 
  let valid = call_564567.validator(path, query, header, formData, body)
  let scheme = call_564567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564567.url(scheme.get, call_564567.host, call_564567.base,
                         call_564567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564567, url, valid)

proc call*(call_564568: Call_ServicesListAlerts_564558; serviceName: string;
          apiVersion: string; state: string = ""; to: string = ""; `from`: string = "";
          Filter: string = ""): Recallable =
  ## servicesListAlerts
  ## Gets the alerts for a given service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   state: string
  ##        : The alert state to query for.
  ##   to: string
  ##     : The end date till when to query for.
  ##   from: string
  ##       : The start date to query for.
  ##   Filter: string
  ##         : The alert property filter to apply.
  var path_564569 = newJObject()
  var query_564570 = newJObject()
  add(path_564569, "serviceName", newJString(serviceName))
  add(query_564570, "api-version", newJString(apiVersion))
  add(query_564570, "state", newJString(state))
  add(query_564570, "to", newJString(to))
  add(query_564570, "from", newJString(`from`))
  add(query_564570, "$filter", newJString(Filter))
  result = call_564568.call(path_564569, query_564570, nil, nil, nil)

var servicesListAlerts* = Call_ServicesListAlerts_564558(
    name: "servicesListAlerts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/alerts",
    validator: validate_ServicesListAlerts_564559, base: "",
    url: url_ServicesListAlerts_564560, schemes: {Scheme.Https})
type
  Call_ServicesGetFeatureAvailibility_564571 = ref object of OpenApiRestCall_563565
proc url_ServicesGetFeatureAvailibility_564573(protocol: Scheme; host: string;
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

proc validate_ServicesGetFeatureAvailibility_564572(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks if the service has all the pre-requisites met to use a feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   featureName: JString (required)
  ##              : The name of the feature.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564574 = path.getOrDefault("serviceName")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "serviceName", valid_564574
  var valid_564575 = path.getOrDefault("featureName")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "featureName", valid_564575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564576 = query.getOrDefault("api-version")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "api-version", valid_564576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564577: Call_ServicesGetFeatureAvailibility_564571; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the service has all the pre-requisites met to use a feature.
  ## 
  let valid = call_564577.validator(path, query, header, formData, body)
  let scheme = call_564577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564577.url(scheme.get, call_564577.host, call_564577.base,
                         call_564577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564577, url, valid)

proc call*(call_564578: Call_ServicesGetFeatureAvailibility_564571;
          serviceName: string; apiVersion: string; featureName: string): Recallable =
  ## servicesGetFeatureAvailibility
  ## Checks if the service has all the pre-requisites met to use a feature.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   featureName: string (required)
  ##              : The name of the feature.
  var path_564579 = newJObject()
  var query_564580 = newJObject()
  add(path_564579, "serviceName", newJString(serviceName))
  add(query_564580, "api-version", newJString(apiVersion))
  add(path_564579, "featureName", newJString(featureName))
  result = call_564578.call(path_564579, query_564580, nil, nil, nil)

var servicesGetFeatureAvailibility* = Call_ServicesGetFeatureAvailibility_564571(
    name: "servicesGetFeatureAvailibility", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/checkServiceFeatureAvailibility/{featureName}",
    validator: validate_ServicesGetFeatureAvailibility_564572, base: "",
    url: url_ServicesGetFeatureAvailibility_564573, schemes: {Scheme.Https})
type
  Call_ServicesListExportErrors_564581 = ref object of OpenApiRestCall_563565
proc url_ServicesListExportErrors_564583(protocol: Scheme; host: string;
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

proc validate_ServicesListExportErrors_564582(path: JsonNode; query: JsonNode;
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
  var valid_564584 = path.getOrDefault("serviceName")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "serviceName", valid_564584
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564585 = query.getOrDefault("api-version")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "api-version", valid_564585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564586: Call_ServicesListExportErrors_564581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the count of latest AAD export errors.
  ## 
  let valid = call_564586.validator(path, query, header, formData, body)
  let scheme = call_564586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564586.url(scheme.get, call_564586.host, call_564586.base,
                         call_564586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564586, url, valid)

proc call*(call_564587: Call_ServicesListExportErrors_564581; serviceName: string;
          apiVersion: string): Recallable =
  ## servicesListExportErrors
  ## Gets the count of latest AAD export errors.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564588 = newJObject()
  var query_564589 = newJObject()
  add(path_564588, "serviceName", newJString(serviceName))
  add(query_564589, "api-version", newJString(apiVersion))
  result = call_564587.call(path_564588, query_564589, nil, nil, nil)

var servicesListExportErrors* = Call_ServicesListExportErrors_564581(
    name: "servicesListExportErrors", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/exporterrors/counts",
    validator: validate_ServicesListExportErrors_564582, base: "",
    url: url_ServicesListExportErrors_564583, schemes: {Scheme.Https})
type
  Call_ServicesListExportErrorsV2_564590 = ref object of OpenApiRestCall_563565
proc url_ServicesListExportErrorsV2_564592(protocol: Scheme; host: string;
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

proc validate_ServicesListExportErrorsV2_564591(path: JsonNode; query: JsonNode;
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
  var valid_564593 = path.getOrDefault("serviceName")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "serviceName", valid_564593
  result.add "path", section
  ## parameters in `query` object:
  ##   errorBucket: JString (required)
  ##              : The error category to query for.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `errorBucket` field"
  var valid_564594 = query.getOrDefault("errorBucket")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = nil)
  if valid_564594 != nil:
    section.add "errorBucket", valid_564594
  var valid_564595 = query.getOrDefault("api-version")
  valid_564595 = validateParameter(valid_564595, JString, required = true,
                                 default = nil)
  if valid_564595 != nil:
    section.add "api-version", valid_564595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564596: Call_ServicesListExportErrorsV2_564590; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ##  Gets the categorized export errors.
  ## 
  let valid = call_564596.validator(path, query, header, formData, body)
  let scheme = call_564596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564596.url(scheme.get, call_564596.host, call_564596.base,
                         call_564596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564596, url, valid)

proc call*(call_564597: Call_ServicesListExportErrorsV2_564590;
          errorBucket: string; serviceName: string; apiVersion: string): Recallable =
  ## servicesListExportErrorsV2
  ##  Gets the categorized export errors.
  ##   errorBucket: string (required)
  ##              : The error category to query for.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564598 = newJObject()
  var query_564599 = newJObject()
  add(query_564599, "errorBucket", newJString(errorBucket))
  add(path_564598, "serviceName", newJString(serviceName))
  add(query_564599, "api-version", newJString(apiVersion))
  result = call_564597.call(path_564598, query_564599, nil, nil, nil)

var servicesListExportErrorsV2* = Call_ServicesListExportErrorsV2_564590(
    name: "servicesListExportErrorsV2", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/exporterrors/listV2",
    validator: validate_ServicesListExportErrorsV2_564591, base: "",
    url: url_ServicesListExportErrorsV2_564592, schemes: {Scheme.Https})
type
  Call_ServicesListExportStatus_564600 = ref object of OpenApiRestCall_563565
proc url_ServicesListExportStatus_564602(protocol: Scheme; host: string;
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

proc validate_ServicesListExportStatus_564601(path: JsonNode; query: JsonNode;
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
  var valid_564603 = path.getOrDefault("serviceName")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "serviceName", valid_564603
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564604 = query.getOrDefault("api-version")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = nil)
  if valid_564604 != nil:
    section.add "api-version", valid_564604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564605: Call_ServicesListExportStatus_564600; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the export status.
  ## 
  let valid = call_564605.validator(path, query, header, formData, body)
  let scheme = call_564605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564605.url(scheme.get, call_564605.host, call_564605.base,
                         call_564605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564605, url, valid)

proc call*(call_564606: Call_ServicesListExportStatus_564600; serviceName: string;
          apiVersion: string): Recallable =
  ## servicesListExportStatus
  ## Gets the export status.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564607 = newJObject()
  var query_564608 = newJObject()
  add(path_564607, "serviceName", newJString(serviceName))
  add(query_564608, "api-version", newJString(apiVersion))
  result = call_564606.call(path_564607, query_564608, nil, nil, nil)

var servicesListExportStatus* = Call_ServicesListExportStatus_564600(
    name: "servicesListExportStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/exportstatus",
    validator: validate_ServicesListExportStatus_564601, base: "",
    url: url_ServicesListExportStatus_564602, schemes: {Scheme.Https})
type
  Call_ServicesAddAlertFeedback_564609 = ref object of OpenApiRestCall_563565
proc url_ServicesAddAlertFeedback_564611(protocol: Scheme; host: string;
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

proc validate_ServicesAddAlertFeedback_564610(path: JsonNode; query: JsonNode;
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
  var valid_564612 = path.getOrDefault("serviceName")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "serviceName", valid_564612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564613 = query.getOrDefault("api-version")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "api-version", valid_564613
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

proc call*(call_564615: Call_ServicesAddAlertFeedback_564609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an alert feedback submitted by customer.
  ## 
  let valid = call_564615.validator(path, query, header, formData, body)
  let scheme = call_564615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564615.url(scheme.get, call_564615.host, call_564615.base,
                         call_564615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564615, url, valid)

proc call*(call_564616: Call_ServicesAddAlertFeedback_564609; serviceName: string;
          apiVersion: string; alertFeedback: JsonNode): Recallable =
  ## servicesAddAlertFeedback
  ## Adds an alert feedback submitted by customer.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   alertFeedback: JObject (required)
  ##                : The alert feedback.
  var path_564617 = newJObject()
  var query_564618 = newJObject()
  var body_564619 = newJObject()
  add(path_564617, "serviceName", newJString(serviceName))
  add(query_564618, "api-version", newJString(apiVersion))
  if alertFeedback != nil:
    body_564619 = alertFeedback
  result = call_564616.call(path_564617, query_564618, nil, nil, body_564619)

var servicesAddAlertFeedback* = Call_ServicesAddAlertFeedback_564609(
    name: "servicesAddAlertFeedback", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/feedbacktype/alerts/feedback",
    validator: validate_ServicesAddAlertFeedback_564610, base: "",
    url: url_ServicesAddAlertFeedback_564611, schemes: {Scheme.Https})
type
  Call_ServicesListAlertFeedback_564620 = ref object of OpenApiRestCall_563565
proc url_ServicesListAlertFeedback_564622(protocol: Scheme; host: string;
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

proc validate_ServicesListAlertFeedback_564621(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all alert feedback for a given tenant and alert type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   shortName: JString (required)
  ##            : The name of the alert.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564623 = path.getOrDefault("serviceName")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "serviceName", valid_564623
  var valid_564624 = path.getOrDefault("shortName")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "shortName", valid_564624
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564625 = query.getOrDefault("api-version")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "api-version", valid_564625
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564626: Call_ServicesListAlertFeedback_564620; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all alert feedback for a given tenant and alert type.
  ## 
  let valid = call_564626.validator(path, query, header, formData, body)
  let scheme = call_564626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564626.url(scheme.get, call_564626.host, call_564626.base,
                         call_564626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564626, url, valid)

proc call*(call_564627: Call_ServicesListAlertFeedback_564620; serviceName: string;
          shortName: string; apiVersion: string): Recallable =
  ## servicesListAlertFeedback
  ## Gets a list of all alert feedback for a given tenant and alert type.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   shortName: string (required)
  ##            : The name of the alert.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564628 = newJObject()
  var query_564629 = newJObject()
  add(path_564628, "serviceName", newJString(serviceName))
  add(path_564628, "shortName", newJString(shortName))
  add(query_564629, "api-version", newJString(apiVersion))
  result = call_564627.call(path_564628, query_564629, nil, nil, nil)

var servicesListAlertFeedback* = Call_ServicesListAlertFeedback_564620(
    name: "servicesListAlertFeedback", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/feedbacktype/alerts/{shortName}/alertfeedback",
    validator: validate_ServicesListAlertFeedback_564621, base: "",
    url: url_ServicesListAlertFeedback_564622, schemes: {Scheme.Https})
type
  Call_ServicesListMetricMetadata_564630 = ref object of OpenApiRestCall_563565
proc url_ServicesListMetricMetadata_564632(protocol: Scheme; host: string;
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

proc validate_ServicesListMetricMetadata_564631(path: JsonNode; query: JsonNode;
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
  var valid_564633 = path.getOrDefault("serviceName")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "serviceName", valid_564633
  result.add "path", section
  ## parameters in `query` object:
  ##   perfCounter: JBool
  ##              : Indicates if only performance counter metrics are requested.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $filter: JString
  ##          : The metric metadata property filter to apply.
  section = newJObject()
  var valid_564634 = query.getOrDefault("perfCounter")
  valid_564634 = validateParameter(valid_564634, JBool, required = false, default = nil)
  if valid_564634 != nil:
    section.add "perfCounter", valid_564634
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564635 = query.getOrDefault("api-version")
  valid_564635 = validateParameter(valid_564635, JString, required = true,
                                 default = nil)
  if valid_564635 != nil:
    section.add "api-version", valid_564635
  var valid_564636 = query.getOrDefault("$filter")
  valid_564636 = validateParameter(valid_564636, JString, required = false,
                                 default = nil)
  if valid_564636 != nil:
    section.add "$filter", valid_564636
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564637: Call_ServicesListMetricMetadata_564630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the service related metrics information.
  ## 
  let valid = call_564637.validator(path, query, header, formData, body)
  let scheme = call_564637.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564637.url(scheme.get, call_564637.host, call_564637.base,
                         call_564637.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564637, url, valid)

proc call*(call_564638: Call_ServicesListMetricMetadata_564630;
          serviceName: string; apiVersion: string; perfCounter: bool = false;
          Filter: string = ""): Recallable =
  ## servicesListMetricMetadata
  ## Gets the service related metrics information.
  ##   perfCounter: bool
  ##              : Indicates if only performance counter metrics are requested.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   Filter: string
  ##         : The metric metadata property filter to apply.
  var path_564639 = newJObject()
  var query_564640 = newJObject()
  add(query_564640, "perfCounter", newJBool(perfCounter))
  add(path_564639, "serviceName", newJString(serviceName))
  add(query_564640, "api-version", newJString(apiVersion))
  add(query_564640, "$filter", newJString(Filter))
  result = call_564638.call(path_564639, query_564640, nil, nil, nil)

var servicesListMetricMetadata* = Call_ServicesListMetricMetadata_564630(
    name: "servicesListMetricMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/metricmetadata",
    validator: validate_ServicesListMetricMetadata_564631, base: "",
    url: url_ServicesListMetricMetadata_564632, schemes: {Scheme.Https})
type
  Call_ServicesGetMetricMetadata_564641 = ref object of OpenApiRestCall_563565
proc url_ServicesGetMetricMetadata_564643(protocol: Scheme; host: string;
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

proc validate_ServicesGetMetricMetadata_564642(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service related metrics information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   metricName: JString (required)
  ##             : The metric name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564644 = path.getOrDefault("serviceName")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "serviceName", valid_564644
  var valid_564645 = path.getOrDefault("metricName")
  valid_564645 = validateParameter(valid_564645, JString, required = true,
                                 default = nil)
  if valid_564645 != nil:
    section.add "metricName", valid_564645
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564646 = query.getOrDefault("api-version")
  valid_564646 = validateParameter(valid_564646, JString, required = true,
                                 default = nil)
  if valid_564646 != nil:
    section.add "api-version", valid_564646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564647: Call_ServicesGetMetricMetadata_564641; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the service related metrics information.
  ## 
  let valid = call_564647.validator(path, query, header, formData, body)
  let scheme = call_564647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564647.url(scheme.get, call_564647.host, call_564647.base,
                         call_564647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564647, url, valid)

proc call*(call_564648: Call_ServicesGetMetricMetadata_564641; serviceName: string;
          apiVersion: string; metricName: string): Recallable =
  ## servicesGetMetricMetadata
  ## Gets the service related metrics information.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   metricName: string (required)
  ##             : The metric name
  var path_564649 = newJObject()
  var query_564650 = newJObject()
  add(path_564649, "serviceName", newJString(serviceName))
  add(query_564650, "api-version", newJString(apiVersion))
  add(path_564649, "metricName", newJString(metricName))
  result = call_564648.call(path_564649, query_564650, nil, nil, nil)

var servicesGetMetricMetadata* = Call_ServicesGetMetricMetadata_564641(
    name: "servicesGetMetricMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/metricmetadata/{metricName}",
    validator: validate_ServicesGetMetricMetadata_564642, base: "",
    url: url_ServicesGetMetricMetadata_564643, schemes: {Scheme.Https})
type
  Call_ServicesGetMetricMetadataForGroup_564651 = ref object of OpenApiRestCall_563565
proc url_ServicesGetMetricMetadataForGroup_564653(protocol: Scheme; host: string;
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

proc validate_ServicesGetMetricMetadataForGroup_564652(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service related metrics for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   metricName: JString (required)
  ##             : The metric name
  ##   groupName: JString (required)
  ##            : The group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564654 = path.getOrDefault("serviceName")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "serviceName", valid_564654
  var valid_564655 = path.getOrDefault("metricName")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "metricName", valid_564655
  var valid_564656 = path.getOrDefault("groupName")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "groupName", valid_564656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   groupKey: JString
  ##           : The group key
  ##   fromDate: JString
  ##           : The start date.
  ##   toDate: JString
  ##         : The end date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564657 = query.getOrDefault("api-version")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "api-version", valid_564657
  var valid_564658 = query.getOrDefault("groupKey")
  valid_564658 = validateParameter(valid_564658, JString, required = false,
                                 default = nil)
  if valid_564658 != nil:
    section.add "groupKey", valid_564658
  var valid_564659 = query.getOrDefault("fromDate")
  valid_564659 = validateParameter(valid_564659, JString, required = false,
                                 default = nil)
  if valid_564659 != nil:
    section.add "fromDate", valid_564659
  var valid_564660 = query.getOrDefault("toDate")
  valid_564660 = validateParameter(valid_564660, JString, required = false,
                                 default = nil)
  if valid_564660 != nil:
    section.add "toDate", valid_564660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564661: Call_ServicesGetMetricMetadataForGroup_564651;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the service related metrics for a given metric and group combination.
  ## 
  let valid = call_564661.validator(path, query, header, formData, body)
  let scheme = call_564661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564661.url(scheme.get, call_564661.host, call_564661.base,
                         call_564661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564661, url, valid)

proc call*(call_564662: Call_ServicesGetMetricMetadataForGroup_564651;
          serviceName: string; apiVersion: string; metricName: string;
          groupName: string; groupKey: string = ""; fromDate: string = "";
          toDate: string = ""): Recallable =
  ## servicesGetMetricMetadataForGroup
  ## Gets the service related metrics for a given metric and group combination.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   groupKey: string
  ##           : The group key
  ##   metricName: string (required)
  ##             : The metric name
  ##   fromDate: string
  ##           : The start date.
  ##   groupName: string (required)
  ##            : The group name
  ##   toDate: string
  ##         : The end date.
  var path_564663 = newJObject()
  var query_564664 = newJObject()
  add(path_564663, "serviceName", newJString(serviceName))
  add(query_564664, "api-version", newJString(apiVersion))
  add(query_564664, "groupKey", newJString(groupKey))
  add(path_564663, "metricName", newJString(metricName))
  add(query_564664, "fromDate", newJString(fromDate))
  add(path_564663, "groupName", newJString(groupName))
  add(query_564664, "toDate", newJString(toDate))
  result = call_564662.call(path_564663, query_564664, nil, nil, nil)

var servicesGetMetricMetadataForGroup* = Call_ServicesGetMetricMetadataForGroup_564651(
    name: "servicesGetMetricMetadataForGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/metricmetadata/{metricName}/groups/{groupName}",
    validator: validate_ServicesGetMetricMetadataForGroup_564652, base: "",
    url: url_ServicesGetMetricMetadataForGroup_564653, schemes: {Scheme.Https})
type
  Call_ServiceGetMetrics_564665 = ref object of OpenApiRestCall_563565
proc url_ServiceGetMetrics_564667(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceGetMetrics_564666(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the server related metrics for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   metricName: JString (required)
  ##             : The metric name
  ##   groupName: JString (required)
  ##            : The group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564668 = path.getOrDefault("serviceName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "serviceName", valid_564668
  var valid_564669 = path.getOrDefault("metricName")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "metricName", valid_564669
  var valid_564670 = path.getOrDefault("groupName")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "groupName", valid_564670
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   groupKey: JString
  ##           : The group key
  ##   fromDate: JString
  ##           : The start date.
  ##   toDate: JString
  ##         : The end date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564671 = query.getOrDefault("api-version")
  valid_564671 = validateParameter(valid_564671, JString, required = true,
                                 default = nil)
  if valid_564671 != nil:
    section.add "api-version", valid_564671
  var valid_564672 = query.getOrDefault("groupKey")
  valid_564672 = validateParameter(valid_564672, JString, required = false,
                                 default = nil)
  if valid_564672 != nil:
    section.add "groupKey", valid_564672
  var valid_564673 = query.getOrDefault("fromDate")
  valid_564673 = validateParameter(valid_564673, JString, required = false,
                                 default = nil)
  if valid_564673 != nil:
    section.add "fromDate", valid_564673
  var valid_564674 = query.getOrDefault("toDate")
  valid_564674 = validateParameter(valid_564674, JString, required = false,
                                 default = nil)
  if valid_564674 != nil:
    section.add "toDate", valid_564674
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564675: Call_ServiceGetMetrics_564665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the server related metrics for a given metric and group combination.
  ## 
  let valid = call_564675.validator(path, query, header, formData, body)
  let scheme = call_564675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564675.url(scheme.get, call_564675.host, call_564675.base,
                         call_564675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564675, url, valid)

proc call*(call_564676: Call_ServiceGetMetrics_564665; serviceName: string;
          apiVersion: string; metricName: string; groupName: string;
          groupKey: string = ""; fromDate: string = ""; toDate: string = ""): Recallable =
  ## serviceGetMetrics
  ## Gets the server related metrics for a given metric and group combination.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   groupKey: string
  ##           : The group key
  ##   metricName: string (required)
  ##             : The metric name
  ##   fromDate: string
  ##           : The start date.
  ##   groupName: string (required)
  ##            : The group name
  ##   toDate: string
  ##         : The end date.
  var path_564677 = newJObject()
  var query_564678 = newJObject()
  add(path_564677, "serviceName", newJString(serviceName))
  add(query_564678, "api-version", newJString(apiVersion))
  add(query_564678, "groupKey", newJString(groupKey))
  add(path_564677, "metricName", newJString(metricName))
  add(query_564678, "fromDate", newJString(fromDate))
  add(path_564677, "groupName", newJString(groupName))
  add(query_564678, "toDate", newJString(toDate))
  result = call_564676.call(path_564677, query_564678, nil, nil, nil)

var serviceGetMetrics* = Call_ServiceGetMetrics_564665(name: "serviceGetMetrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/metrics/{metricName}/groups/{groupName}",
    validator: validate_ServiceGetMetrics_564666, base: "",
    url: url_ServiceGetMetrics_564667, schemes: {Scheme.Https})
type
  Call_ServicesListMetricsAverage_564679 = ref object of OpenApiRestCall_563565
proc url_ServicesListMetricsAverage_564681(protocol: Scheme; host: string;
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

proc validate_ServicesListMetricsAverage_564680(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the average of the metric values for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   metricName: JString (required)
  ##             : The metric name
  ##   groupName: JString (required)
  ##            : The group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564682 = path.getOrDefault("serviceName")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "serviceName", valid_564682
  var valid_564683 = path.getOrDefault("metricName")
  valid_564683 = validateParameter(valid_564683, JString, required = true,
                                 default = nil)
  if valid_564683 != nil:
    section.add "metricName", valid_564683
  var valid_564684 = path.getOrDefault("groupName")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = nil)
  if valid_564684 != nil:
    section.add "groupName", valid_564684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564685 = query.getOrDefault("api-version")
  valid_564685 = validateParameter(valid_564685, JString, required = true,
                                 default = nil)
  if valid_564685 != nil:
    section.add "api-version", valid_564685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564686: Call_ServicesListMetricsAverage_564679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the average of the metric values for a given metric and group combination.
  ## 
  let valid = call_564686.validator(path, query, header, formData, body)
  let scheme = call_564686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564686.url(scheme.get, call_564686.host, call_564686.base,
                         call_564686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564686, url, valid)

proc call*(call_564687: Call_ServicesListMetricsAverage_564679;
          serviceName: string; apiVersion: string; metricName: string;
          groupName: string): Recallable =
  ## servicesListMetricsAverage
  ## Gets the average of the metric values for a given metric and group combination.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   metricName: string (required)
  ##             : The metric name
  ##   groupName: string (required)
  ##            : The group name
  var path_564688 = newJObject()
  var query_564689 = newJObject()
  add(path_564688, "serviceName", newJString(serviceName))
  add(query_564689, "api-version", newJString(apiVersion))
  add(path_564688, "metricName", newJString(metricName))
  add(path_564688, "groupName", newJString(groupName))
  result = call_564687.call(path_564688, query_564689, nil, nil, nil)

var servicesListMetricsAverage* = Call_ServicesListMetricsAverage_564679(
    name: "servicesListMetricsAverage", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/metrics/{metricName}/groups/{groupName}/average",
    validator: validate_ServicesListMetricsAverage_564680, base: "",
    url: url_ServicesListMetricsAverage_564681, schemes: {Scheme.Https})
type
  Call_ServicesListMetricsSum_564690 = ref object of OpenApiRestCall_563565
proc url_ServicesListMetricsSum_564692(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesListMetricsSum_564691(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the sum of the metric values for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   metricName: JString (required)
  ##             : The metric name
  ##   groupName: JString (required)
  ##            : The group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564693 = path.getOrDefault("serviceName")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "serviceName", valid_564693
  var valid_564694 = path.getOrDefault("metricName")
  valid_564694 = validateParameter(valid_564694, JString, required = true,
                                 default = nil)
  if valid_564694 != nil:
    section.add "metricName", valid_564694
  var valid_564695 = path.getOrDefault("groupName")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "groupName", valid_564695
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564696 = query.getOrDefault("api-version")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "api-version", valid_564696
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564697: Call_ServicesListMetricsSum_564690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the sum of the metric values for a given metric and group combination.
  ## 
  let valid = call_564697.validator(path, query, header, formData, body)
  let scheme = call_564697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564697.url(scheme.get, call_564697.host, call_564697.base,
                         call_564697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564697, url, valid)

proc call*(call_564698: Call_ServicesListMetricsSum_564690; serviceName: string;
          apiVersion: string; metricName: string; groupName: string): Recallable =
  ## servicesListMetricsSum
  ## Gets the sum of the metric values for a given metric and group combination.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   metricName: string (required)
  ##             : The metric name
  ##   groupName: string (required)
  ##            : The group name
  var path_564699 = newJObject()
  var query_564700 = newJObject()
  add(path_564699, "serviceName", newJString(serviceName))
  add(query_564700, "api-version", newJString(apiVersion))
  add(path_564699, "metricName", newJString(metricName))
  add(path_564699, "groupName", newJString(groupName))
  result = call_564698.call(path_564699, query_564700, nil, nil, nil)

var servicesListMetricsSum* = Call_ServicesListMetricsSum_564690(
    name: "servicesListMetricsSum", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/metrics/{metricName}/groups/{groupName}/sum",
    validator: validate_ServicesListMetricsSum_564691, base: "",
    url: url_ServicesListMetricsSum_564692, schemes: {Scheme.Https})
type
  Call_ServicesUpdateMonitoringConfiguration_564701 = ref object of OpenApiRestCall_563565
proc url_ServicesUpdateMonitoringConfiguration_564703(protocol: Scheme;
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

proc validate_ServicesUpdateMonitoringConfiguration_564702(path: JsonNode;
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
  var valid_564704 = path.getOrDefault("serviceName")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "serviceName", valid_564704
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564705 = query.getOrDefault("api-version")
  valid_564705 = validateParameter(valid_564705, JString, required = true,
                                 default = nil)
  if valid_564705 != nil:
    section.add "api-version", valid_564705
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

proc call*(call_564707: Call_ServicesUpdateMonitoringConfiguration_564701;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the service level monitoring configuration.
  ## 
  let valid = call_564707.validator(path, query, header, formData, body)
  let scheme = call_564707.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564707.url(scheme.get, call_564707.host, call_564707.base,
                         call_564707.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564707, url, valid)

proc call*(call_564708: Call_ServicesUpdateMonitoringConfiguration_564701;
          serviceName: string; apiVersion: string; configurationSetting: JsonNode): Recallable =
  ## servicesUpdateMonitoringConfiguration
  ## Updates the service level monitoring configuration.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   configurationSetting: JObject (required)
  ##                       : The monitoring configuration to update
  var path_564709 = newJObject()
  var query_564710 = newJObject()
  var body_564711 = newJObject()
  add(path_564709, "serviceName", newJString(serviceName))
  add(query_564710, "api-version", newJString(apiVersion))
  if configurationSetting != nil:
    body_564711 = configurationSetting
  result = call_564708.call(path_564709, query_564710, nil, nil, body_564711)

var servicesUpdateMonitoringConfiguration* = Call_ServicesUpdateMonitoringConfiguration_564701(
    name: "servicesUpdateMonitoringConfiguration", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/monitoringconfiguration",
    validator: validate_ServicesUpdateMonitoringConfiguration_564702, base: "",
    url: url_ServicesUpdateMonitoringConfiguration_564703, schemes: {Scheme.Https})
type
  Call_ServicesListMonitoringConfigurations_564712 = ref object of OpenApiRestCall_563565
proc url_ServicesListMonitoringConfigurations_564714(protocol: Scheme;
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

proc validate_ServicesListMonitoringConfigurations_564713(path: JsonNode;
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
  var valid_564715 = path.getOrDefault("serviceName")
  valid_564715 = validateParameter(valid_564715, JString, required = true,
                                 default = nil)
  if valid_564715 != nil:
    section.add "serviceName", valid_564715
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564716 = query.getOrDefault("api-version")
  valid_564716 = validateParameter(valid_564716, JString, required = true,
                                 default = nil)
  if valid_564716 != nil:
    section.add "api-version", valid_564716
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564717: Call_ServicesListMonitoringConfigurations_564712;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the service level monitoring configurations.
  ## 
  let valid = call_564717.validator(path, query, header, formData, body)
  let scheme = call_564717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564717.url(scheme.get, call_564717.host, call_564717.base,
                         call_564717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564717, url, valid)

proc call*(call_564718: Call_ServicesListMonitoringConfigurations_564712;
          serviceName: string; apiVersion: string): Recallable =
  ## servicesListMonitoringConfigurations
  ## Gets the service level monitoring configurations.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564719 = newJObject()
  var query_564720 = newJObject()
  add(path_564719, "serviceName", newJString(serviceName))
  add(query_564720, "api-version", newJString(apiVersion))
  result = call_564718.call(path_564719, query_564720, nil, nil, nil)

var servicesListMonitoringConfigurations* = Call_ServicesListMonitoringConfigurations_564712(
    name: "servicesListMonitoringConfigurations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/monitoringconfigurations",
    validator: validate_ServicesListMonitoringConfigurations_564713, base: "",
    url: url_ServicesListMonitoringConfigurations_564714, schemes: {Scheme.Https})
type
  Call_ServicesListUserBadPasswordReport_564721 = ref object of OpenApiRestCall_563565
proc url_ServicesListUserBadPasswordReport_564723(protocol: Scheme; host: string;
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

proc validate_ServicesListUserBadPasswordReport_564722(path: JsonNode;
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
  var valid_564724 = path.getOrDefault("serviceName")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "serviceName", valid_564724
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   dataSource: JString
  ##             : The source of data, if its test data or customer data.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564725 = query.getOrDefault("api-version")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "api-version", valid_564725
  var valid_564726 = query.getOrDefault("dataSource")
  valid_564726 = validateParameter(valid_564726, JString, required = false,
                                 default = nil)
  if valid_564726 != nil:
    section.add "dataSource", valid_564726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564727: Call_ServicesListUserBadPasswordReport_564721;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the bad password login attempt report for an user
  ## 
  let valid = call_564727.validator(path, query, header, formData, body)
  let scheme = call_564727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564727.url(scheme.get, call_564727.host, call_564727.base,
                         call_564727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564727, url, valid)

proc call*(call_564728: Call_ServicesListUserBadPasswordReport_564721;
          serviceName: string; apiVersion: string; dataSource: string = ""): Recallable =
  ## servicesListUserBadPasswordReport
  ## Gets the bad password login attempt report for an user
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   dataSource: string
  ##             : The source of data, if its test data or customer data.
  var path_564729 = newJObject()
  var query_564730 = newJObject()
  add(path_564729, "serviceName", newJString(serviceName))
  add(query_564730, "api-version", newJString(apiVersion))
  add(query_564730, "dataSource", newJString(dataSource))
  result = call_564728.call(path_564729, query_564730, nil, nil, nil)

var servicesListUserBadPasswordReport* = Call_ServicesListUserBadPasswordReport_564721(
    name: "servicesListUserBadPasswordReport", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/reports/badpassword/details/user",
    validator: validate_ServicesListUserBadPasswordReport_564722, base: "",
    url: url_ServicesListUserBadPasswordReport_564723, schemes: {Scheme.Https})
type
  Call_ServicesListAllRiskyIpDownloadReport_564731 = ref object of OpenApiRestCall_563565
proc url_ServicesListAllRiskyIpDownloadReport_564733(protocol: Scheme;
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

proc validate_ServicesListAllRiskyIpDownloadReport_564732(path: JsonNode;
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
  var valid_564734 = path.getOrDefault("serviceName")
  valid_564734 = validateParameter(valid_564734, JString, required = true,
                                 default = nil)
  if valid_564734 != nil:
    section.add "serviceName", valid_564734
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564735 = query.getOrDefault("api-version")
  valid_564735 = validateParameter(valid_564735, JString, required = true,
                                 default = nil)
  if valid_564735 != nil:
    section.add "api-version", valid_564735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564736: Call_ServicesListAllRiskyIpDownloadReport_564731;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all Risky IP report URIs for the last 7 days.
  ## 
  let valid = call_564736.validator(path, query, header, formData, body)
  let scheme = call_564736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564736.url(scheme.get, call_564736.host, call_564736.base,
                         call_564736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564736, url, valid)

proc call*(call_564737: Call_ServicesListAllRiskyIpDownloadReport_564731;
          serviceName: string; apiVersion: string): Recallable =
  ## servicesListAllRiskyIpDownloadReport
  ## Gets all Risky IP report URIs for the last 7 days.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564738 = newJObject()
  var query_564739 = newJObject()
  add(path_564738, "serviceName", newJString(serviceName))
  add(query_564739, "api-version", newJString(apiVersion))
  result = call_564737.call(path_564738, query_564739, nil, nil, nil)

var servicesListAllRiskyIpDownloadReport* = Call_ServicesListAllRiskyIpDownloadReport_564731(
    name: "servicesListAllRiskyIpDownloadReport", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/reports/riskyIp/blobUris",
    validator: validate_ServicesListAllRiskyIpDownloadReport_564732, base: "",
    url: url_ServicesListAllRiskyIpDownloadReport_564733, schemes: {Scheme.Https})
type
  Call_ServicesListCurrentRiskyIpDownloadReport_564740 = ref object of OpenApiRestCall_563565
proc url_ServicesListCurrentRiskyIpDownloadReport_564742(protocol: Scheme;
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

proc validate_ServicesListCurrentRiskyIpDownloadReport_564741(path: JsonNode;
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
  var valid_564743 = path.getOrDefault("serviceName")
  valid_564743 = validateParameter(valid_564743, JString, required = true,
                                 default = nil)
  if valid_564743 != nil:
    section.add "serviceName", valid_564743
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564744 = query.getOrDefault("api-version")
  valid_564744 = validateParameter(valid_564744, JString, required = true,
                                 default = nil)
  if valid_564744 != nil:
    section.add "api-version", valid_564744
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564745: Call_ServicesListCurrentRiskyIpDownloadReport_564740;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Initiate the generation of a new Risky IP report. Returns the URI for the new one.
  ## 
  let valid = call_564745.validator(path, query, header, formData, body)
  let scheme = call_564745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564745.url(scheme.get, call_564745.host, call_564745.base,
                         call_564745.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564745, url, valid)

proc call*(call_564746: Call_ServicesListCurrentRiskyIpDownloadReport_564740;
          serviceName: string; apiVersion: string): Recallable =
  ## servicesListCurrentRiskyIpDownloadReport
  ## Initiate the generation of a new Risky IP report. Returns the URI for the new one.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564747 = newJObject()
  var query_564748 = newJObject()
  add(path_564747, "serviceName", newJString(serviceName))
  add(query_564748, "api-version", newJString(apiVersion))
  result = call_564746.call(path_564747, query_564748, nil, nil, nil)

var servicesListCurrentRiskyIpDownloadReport* = Call_ServicesListCurrentRiskyIpDownloadReport_564740(
    name: "servicesListCurrentRiskyIpDownloadReport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/reports/riskyIp/generateBlobUri",
    validator: validate_ServicesListCurrentRiskyIpDownloadReport_564741, base: "",
    url: url_ServicesListCurrentRiskyIpDownloadReport_564742,
    schemes: {Scheme.Https})
type
  Call_ServiceMembersAdd_564761 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersAdd_564763(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceMembersAdd_564762(path: JsonNode; query: JsonNode;
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
  var valid_564764 = path.getOrDefault("serviceName")
  valid_564764 = validateParameter(valid_564764, JString, required = true,
                                 default = nil)
  if valid_564764 != nil:
    section.add "serviceName", valid_564764
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564765 = query.getOrDefault("api-version")
  valid_564765 = validateParameter(valid_564765, JString, required = true,
                                 default = nil)
  if valid_564765 != nil:
    section.add "api-version", valid_564765
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

proc call*(call_564767: Call_ServiceMembersAdd_564761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Onboards  a server, for a given service, to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_564767.validator(path, query, header, formData, body)
  let scheme = call_564767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564767.url(scheme.get, call_564767.host, call_564767.base,
                         call_564767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564767, url, valid)

proc call*(call_564768: Call_ServiceMembersAdd_564761; serviceName: string;
          serviceMember: JsonNode; apiVersion: string): Recallable =
  ## serviceMembersAdd
  ## Onboards  a server, for a given service, to Azure Active Directory Connect Health Service.
  ##   serviceName: string (required)
  ##              : The name of the service under which the server is to be onboarded.
  ##   serviceMember: JObject (required)
  ##                : The server object.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var path_564769 = newJObject()
  var query_564770 = newJObject()
  var body_564771 = newJObject()
  add(path_564769, "serviceName", newJString(serviceName))
  if serviceMember != nil:
    body_564771 = serviceMember
  add(query_564770, "api-version", newJString(apiVersion))
  result = call_564768.call(path_564769, query_564770, nil, nil, body_564771)

var serviceMembersAdd* = Call_ServiceMembersAdd_564761(name: "serviceMembersAdd",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers",
    validator: validate_ServiceMembersAdd_564762, base: "",
    url: url_ServiceMembersAdd_564763, schemes: {Scheme.Https})
type
  Call_ServiceMembersList_564749 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersList_564751(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceMembersList_564750(path: JsonNode; query: JsonNode;
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
  var valid_564752 = path.getOrDefault("serviceName")
  valid_564752 = validateParameter(valid_564752, JString, required = true,
                                 default = nil)
  if valid_564752 != nil:
    section.add "serviceName", valid_564752
  result.add "path", section
  ## parameters in `query` object:
  ##   dimensionType: JString
  ##                : The server specific dimension.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   dimensionSignature: JString
  ##                     : The value of the dimension.
  ##   $filter: JString
  ##          : The server property filter to apply.
  section = newJObject()
  var valid_564753 = query.getOrDefault("dimensionType")
  valid_564753 = validateParameter(valid_564753, JString, required = false,
                                 default = nil)
  if valid_564753 != nil:
    section.add "dimensionType", valid_564753
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564754 = query.getOrDefault("api-version")
  valid_564754 = validateParameter(valid_564754, JString, required = true,
                                 default = nil)
  if valid_564754 != nil:
    section.add "api-version", valid_564754
  var valid_564755 = query.getOrDefault("dimensionSignature")
  valid_564755 = validateParameter(valid_564755, JString, required = false,
                                 default = nil)
  if valid_564755 != nil:
    section.add "dimensionSignature", valid_564755
  var valid_564756 = query.getOrDefault("$filter")
  valid_564756 = validateParameter(valid_564756, JString, required = false,
                                 default = nil)
  if valid_564756 != nil:
    section.add "$filter", valid_564756
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564757: Call_ServiceMembersList_564749; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the servers, for a given service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_564757.validator(path, query, header, formData, body)
  let scheme = call_564757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564757.url(scheme.get, call_564757.host, call_564757.base,
                         call_564757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564757, url, valid)

proc call*(call_564758: Call_ServiceMembersList_564749; serviceName: string;
          apiVersion: string; dimensionType: string = "";
          dimensionSignature: string = ""; Filter: string = ""): Recallable =
  ## serviceMembersList
  ## Gets the details of the servers, for a given service, that are onboarded to Azure Active Directory Connect Health Service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   dimensionType: string
  ##                : The server specific dimension.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   dimensionSignature: string
  ##                     : The value of the dimension.
  ##   Filter: string
  ##         : The server property filter to apply.
  var path_564759 = newJObject()
  var query_564760 = newJObject()
  add(path_564759, "serviceName", newJString(serviceName))
  add(query_564760, "dimensionType", newJString(dimensionType))
  add(query_564760, "api-version", newJString(apiVersion))
  add(query_564760, "dimensionSignature", newJString(dimensionSignature))
  add(query_564760, "$filter", newJString(Filter))
  result = call_564758.call(path_564759, query_564760, nil, nil, nil)

var serviceMembersList* = Call_ServiceMembersList_564749(
    name: "serviceMembersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers",
    validator: validate_ServiceMembersList_564750, base: "",
    url: url_ServiceMembersList_564751, schemes: {Scheme.Https})
type
  Call_ServiceMembersGet_564772 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersGet_564774(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceMembersGet_564773(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the details of a server, for a given service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564775 = path.getOrDefault("serviceName")
  valid_564775 = validateParameter(valid_564775, JString, required = true,
                                 default = nil)
  if valid_564775 != nil:
    section.add "serviceName", valid_564775
  var valid_564776 = path.getOrDefault("serviceMemberId")
  valid_564776 = validateParameter(valid_564776, JString, required = true,
                                 default = nil)
  if valid_564776 != nil:
    section.add "serviceMemberId", valid_564776
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564777 = query.getOrDefault("api-version")
  valid_564777 = validateParameter(valid_564777, JString, required = true,
                                 default = nil)
  if valid_564777 != nil:
    section.add "api-version", valid_564777
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564778: Call_ServiceMembersGet_564772; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a server, for a given service, that are onboarded to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_564778.validator(path, query, header, formData, body)
  let scheme = call_564778.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564778.url(scheme.get, call_564778.host, call_564778.base,
                         call_564778.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564778, url, valid)

proc call*(call_564779: Call_ServiceMembersGet_564772; serviceName: string;
          apiVersion: string; serviceMemberId: string): Recallable =
  ## serviceMembersGet
  ## Gets the details of a server, for a given service, that are onboarded to Azure Active Directory Connect Health Service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  var path_564780 = newJObject()
  var query_564781 = newJObject()
  add(path_564780, "serviceName", newJString(serviceName))
  add(query_564781, "api-version", newJString(apiVersion))
  add(path_564780, "serviceMemberId", newJString(serviceMemberId))
  result = call_564779.call(path_564780, query_564781, nil, nil, nil)

var serviceMembersGet* = Call_ServiceMembersGet_564772(name: "serviceMembersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}",
    validator: validate_ServiceMembersGet_564773, base: "",
    url: url_ServiceMembersGet_564774, schemes: {Scheme.Https})
type
  Call_ServiceMembersDelete_564782 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersDelete_564784(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceMembersDelete_564783(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a server that has been onboarded to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564785 = path.getOrDefault("serviceName")
  valid_564785 = validateParameter(valid_564785, JString, required = true,
                                 default = nil)
  if valid_564785 != nil:
    section.add "serviceName", valid_564785
  var valid_564786 = path.getOrDefault("serviceMemberId")
  valid_564786 = validateParameter(valid_564786, JString, required = true,
                                 default = nil)
  if valid_564786 != nil:
    section.add "serviceMemberId", valid_564786
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   confirm: JBool
  ##          : Indicates if the server will be permanently deleted or disabled. True indicates that the server will be permanently deleted and False indicates that the server will be marked disabled and then deleted after 30 days, if it is not re-registered.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564787 = query.getOrDefault("api-version")
  valid_564787 = validateParameter(valid_564787, JString, required = true,
                                 default = nil)
  if valid_564787 != nil:
    section.add "api-version", valid_564787
  var valid_564788 = query.getOrDefault("confirm")
  valid_564788 = validateParameter(valid_564788, JBool, required = false, default = nil)
  if valid_564788 != nil:
    section.add "confirm", valid_564788
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564789: Call_ServiceMembersDelete_564782; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a server that has been onboarded to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_564789.validator(path, query, header, formData, body)
  let scheme = call_564789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564789.url(scheme.get, call_564789.host, call_564789.base,
                         call_564789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564789, url, valid)

proc call*(call_564790: Call_ServiceMembersDelete_564782; serviceName: string;
          apiVersion: string; serviceMemberId: string; confirm: bool = false): Recallable =
  ## serviceMembersDelete
  ## Deletes a server that has been onboarded to Azure Active Directory Connect Health Service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   confirm: bool
  ##          : Indicates if the server will be permanently deleted or disabled. True indicates that the server will be permanently deleted and False indicates that the server will be marked disabled and then deleted after 30 days, if it is not re-registered.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  var path_564791 = newJObject()
  var query_564792 = newJObject()
  add(path_564791, "serviceName", newJString(serviceName))
  add(query_564792, "api-version", newJString(apiVersion))
  add(query_564792, "confirm", newJBool(confirm))
  add(path_564791, "serviceMemberId", newJString(serviceMemberId))
  result = call_564790.call(path_564791, query_564792, nil, nil, nil)

var serviceMembersDelete* = Call_ServiceMembersDelete_564782(
    name: "serviceMembersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}",
    validator: validate_ServiceMembersDelete_564783, base: "",
    url: url_ServiceMembersDelete_564784, schemes: {Scheme.Https})
type
  Call_ServiceMembersListAlerts_564793 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersListAlerts_564795(protocol: Scheme; host: string;
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

proc validate_ServiceMembersListAlerts_564794(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an alert for a given service and server combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id for which the alert details needs to be queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564796 = path.getOrDefault("serviceName")
  valid_564796 = validateParameter(valid_564796, JString, required = true,
                                 default = nil)
  if valid_564796 != nil:
    section.add "serviceName", valid_564796
  var valid_564797 = path.getOrDefault("serviceMemberId")
  valid_564797 = validateParameter(valid_564797, JString, required = true,
                                 default = nil)
  if valid_564797 != nil:
    section.add "serviceMemberId", valid_564797
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   state: JString
  ##        : The alert state to query for.
  ##   to: JString
  ##     : The end date till when to query for.
  ##   from: JString
  ##       : The start date to query for.
  ##   $filter: JString
  ##          : The alert property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564798 = query.getOrDefault("api-version")
  valid_564798 = validateParameter(valid_564798, JString, required = true,
                                 default = nil)
  if valid_564798 != nil:
    section.add "api-version", valid_564798
  var valid_564799 = query.getOrDefault("state")
  valid_564799 = validateParameter(valid_564799, JString, required = false,
                                 default = nil)
  if valid_564799 != nil:
    section.add "state", valid_564799
  var valid_564800 = query.getOrDefault("to")
  valid_564800 = validateParameter(valid_564800, JString, required = false,
                                 default = nil)
  if valid_564800 != nil:
    section.add "to", valid_564800
  var valid_564801 = query.getOrDefault("from")
  valid_564801 = validateParameter(valid_564801, JString, required = false,
                                 default = nil)
  if valid_564801 != nil:
    section.add "from", valid_564801
  var valid_564802 = query.getOrDefault("$filter")
  valid_564802 = validateParameter(valid_564802, JString, required = false,
                                 default = nil)
  if valid_564802 != nil:
    section.add "$filter", valid_564802
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564803: Call_ServiceMembersListAlerts_564793; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an alert for a given service and server combination.
  ## 
  let valid = call_564803.validator(path, query, header, formData, body)
  let scheme = call_564803.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564803.url(scheme.get, call_564803.host, call_564803.base,
                         call_564803.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564803, url, valid)

proc call*(call_564804: Call_ServiceMembersListAlerts_564793; serviceName: string;
          apiVersion: string; serviceMemberId: string; state: string = "";
          to: string = ""; `from`: string = ""; Filter: string = ""): Recallable =
  ## serviceMembersListAlerts
  ## Gets the details of an alert for a given service and server combination.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   state: string
  ##        : The alert state to query for.
  ##   to: string
  ##     : The end date till when to query for.
  ##   from: string
  ##       : The start date to query for.
  ##   Filter: string
  ##         : The alert property filter to apply.
  ##   serviceMemberId: string (required)
  ##                  : The server Id for which the alert details needs to be queried.
  var path_564805 = newJObject()
  var query_564806 = newJObject()
  add(path_564805, "serviceName", newJString(serviceName))
  add(query_564806, "api-version", newJString(apiVersion))
  add(query_564806, "state", newJString(state))
  add(query_564806, "to", newJString(to))
  add(query_564806, "from", newJString(`from`))
  add(query_564806, "$filter", newJString(Filter))
  add(path_564805, "serviceMemberId", newJString(serviceMemberId))
  result = call_564804.call(path_564805, query_564806, nil, nil, nil)

var serviceMembersListAlerts* = Call_ServiceMembersListAlerts_564793(
    name: "serviceMembersListAlerts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/alerts",
    validator: validate_ServiceMembersListAlerts_564794, base: "",
    url: url_ServiceMembersListAlerts_564795, schemes: {Scheme.Https})
type
  Call_ServiceMembersListCredentials_564807 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersListCredentials_564809(protocol: Scheme; host: string;
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

proc validate_ServiceMembersListCredentials_564808(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the credentials of the server which is needed by the agent to connect to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564810 = path.getOrDefault("serviceName")
  valid_564810 = validateParameter(valid_564810, JString, required = true,
                                 default = nil)
  if valid_564810 != nil:
    section.add "serviceName", valid_564810
  var valid_564811 = path.getOrDefault("serviceMemberId")
  valid_564811 = validateParameter(valid_564811, JString, required = true,
                                 default = nil)
  if valid_564811 != nil:
    section.add "serviceMemberId", valid_564811
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $filter: JString
  ##          : The property filter to apply.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564812 = query.getOrDefault("api-version")
  valid_564812 = validateParameter(valid_564812, JString, required = true,
                                 default = nil)
  if valid_564812 != nil:
    section.add "api-version", valid_564812
  var valid_564813 = query.getOrDefault("$filter")
  valid_564813 = validateParameter(valid_564813, JString, required = false,
                                 default = nil)
  if valid_564813 != nil:
    section.add "$filter", valid_564813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564814: Call_ServiceMembersListCredentials_564807; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the credentials of the server which is needed by the agent to connect to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_564814.validator(path, query, header, formData, body)
  let scheme = call_564814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564814.url(scheme.get, call_564814.host, call_564814.base,
                         call_564814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564814, url, valid)

proc call*(call_564815: Call_ServiceMembersListCredentials_564807;
          serviceName: string; apiVersion: string; serviceMemberId: string;
          Filter: string = ""): Recallable =
  ## serviceMembersListCredentials
  ## Gets the credentials of the server which is needed by the agent to connect to Azure Active Directory Connect Health Service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   Filter: string
  ##         : The property filter to apply.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  var path_564816 = newJObject()
  var query_564817 = newJObject()
  add(path_564816, "serviceName", newJString(serviceName))
  add(query_564817, "api-version", newJString(apiVersion))
  add(query_564817, "$filter", newJString(Filter))
  add(path_564816, "serviceMemberId", newJString(serviceMemberId))
  result = call_564815.call(path_564816, query_564817, nil, nil, nil)

var serviceMembersListCredentials* = Call_ServiceMembersListCredentials_564807(
    name: "serviceMembersListCredentials", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/credentials",
    validator: validate_ServiceMembersListCredentials_564808, base: "",
    url: url_ServiceMembersListCredentials_564809, schemes: {Scheme.Https})
type
  Call_ServiceMembersDeleteData_564818 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersDeleteData_564820(protocol: Scheme; host: string;
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

proc validate_ServiceMembersDeleteData_564819(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the data uploaded by the server to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564821 = path.getOrDefault("serviceName")
  valid_564821 = validateParameter(valid_564821, JString, required = true,
                                 default = nil)
  if valid_564821 != nil:
    section.add "serviceName", valid_564821
  var valid_564822 = path.getOrDefault("serviceMemberId")
  valid_564822 = validateParameter(valid_564822, JString, required = true,
                                 default = nil)
  if valid_564822 != nil:
    section.add "serviceMemberId", valid_564822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564823 = query.getOrDefault("api-version")
  valid_564823 = validateParameter(valid_564823, JString, required = true,
                                 default = nil)
  if valid_564823 != nil:
    section.add "api-version", valid_564823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564824: Call_ServiceMembersDeleteData_564818; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the data uploaded by the server to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_564824.validator(path, query, header, formData, body)
  let scheme = call_564824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564824.url(scheme.get, call_564824.host, call_564824.base,
                         call_564824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564824, url, valid)

proc call*(call_564825: Call_ServiceMembersDeleteData_564818; serviceName: string;
          apiVersion: string; serviceMemberId: string): Recallable =
  ## serviceMembersDeleteData
  ## Deletes the data uploaded by the server to Azure Active Directory Connect Health Service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  var path_564826 = newJObject()
  var query_564827 = newJObject()
  add(path_564826, "serviceName", newJString(serviceName))
  add(query_564827, "api-version", newJString(apiVersion))
  add(path_564826, "serviceMemberId", newJString(serviceMemberId))
  result = call_564825.call(path_564826, query_564827, nil, nil, nil)

var serviceMembersDeleteData* = Call_ServiceMembersDeleteData_564818(
    name: "serviceMembersDeleteData", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/data",
    validator: validate_ServiceMembersDeleteData_564819, base: "",
    url: url_ServiceMembersDeleteData_564820, schemes: {Scheme.Https})
type
  Call_ServiceMembersListDataFreshness_564828 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersListDataFreshness_564830(protocol: Scheme; host: string;
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

proc validate_ServiceMembersListDataFreshness_564829(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the last time when the server uploaded data to Azure Active Directory Connect Health Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564831 = path.getOrDefault("serviceName")
  valid_564831 = validateParameter(valid_564831, JString, required = true,
                                 default = nil)
  if valid_564831 != nil:
    section.add "serviceName", valid_564831
  var valid_564832 = path.getOrDefault("serviceMemberId")
  valid_564832 = validateParameter(valid_564832, JString, required = true,
                                 default = nil)
  if valid_564832 != nil:
    section.add "serviceMemberId", valid_564832
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564833 = query.getOrDefault("api-version")
  valid_564833 = validateParameter(valid_564833, JString, required = true,
                                 default = nil)
  if valid_564833 != nil:
    section.add "api-version", valid_564833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564834: Call_ServiceMembersListDataFreshness_564828;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the last time when the server uploaded data to Azure Active Directory Connect Health Service.
  ## 
  let valid = call_564834.validator(path, query, header, formData, body)
  let scheme = call_564834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564834.url(scheme.get, call_564834.host, call_564834.base,
                         call_564834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564834, url, valid)

proc call*(call_564835: Call_ServiceMembersListDataFreshness_564828;
          serviceName: string; apiVersion: string; serviceMemberId: string): Recallable =
  ## serviceMembersListDataFreshness
  ## Gets the last time when the server uploaded data to Azure Active Directory Connect Health Service.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  var path_564836 = newJObject()
  var query_564837 = newJObject()
  add(path_564836, "serviceName", newJString(serviceName))
  add(query_564837, "api-version", newJString(apiVersion))
  add(path_564836, "serviceMemberId", newJString(serviceMemberId))
  result = call_564835.call(path_564836, query_564837, nil, nil, nil)

var serviceMembersListDataFreshness* = Call_ServiceMembersListDataFreshness_564828(
    name: "serviceMembersListDataFreshness", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/datafreshness",
    validator: validate_ServiceMembersListDataFreshness_564829, base: "",
    url: url_ServiceMembersListDataFreshness_564830, schemes: {Scheme.Https})
type
  Call_ServiceMembersListExportStatus_564838 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersListExportStatus_564840(protocol: Scheme; host: string;
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

proc validate_ServiceMembersListExportStatus_564839(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the export status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564841 = path.getOrDefault("serviceName")
  valid_564841 = validateParameter(valid_564841, JString, required = true,
                                 default = nil)
  if valid_564841 != nil:
    section.add "serviceName", valid_564841
  var valid_564842 = path.getOrDefault("serviceMemberId")
  valid_564842 = validateParameter(valid_564842, JString, required = true,
                                 default = nil)
  if valid_564842 != nil:
    section.add "serviceMemberId", valid_564842
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564843 = query.getOrDefault("api-version")
  valid_564843 = validateParameter(valid_564843, JString, required = true,
                                 default = nil)
  if valid_564843 != nil:
    section.add "api-version", valid_564843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564844: Call_ServiceMembersListExportStatus_564838; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the export status.
  ## 
  let valid = call_564844.validator(path, query, header, formData, body)
  let scheme = call_564844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564844.url(scheme.get, call_564844.host, call_564844.base,
                         call_564844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564844, url, valid)

proc call*(call_564845: Call_ServiceMembersListExportStatus_564838;
          serviceName: string; apiVersion: string; serviceMemberId: string): Recallable =
  ## serviceMembersListExportStatus
  ## Gets the export status.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  var path_564846 = newJObject()
  var query_564847 = newJObject()
  add(path_564846, "serviceName", newJString(serviceName))
  add(query_564847, "api-version", newJString(apiVersion))
  add(path_564846, "serviceMemberId", newJString(serviceMemberId))
  result = call_564845.call(path_564846, query_564847, nil, nil, nil)

var serviceMembersListExportStatus* = Call_ServiceMembersListExportStatus_564838(
    name: "serviceMembersListExportStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/exportstatus",
    validator: validate_ServiceMembersListExportStatus_564839, base: "",
    url: url_ServiceMembersListExportStatus_564840, schemes: {Scheme.Https})
type
  Call_ServiceMembersListGlobalConfiguration_564848 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersListGlobalConfiguration_564850(protocol: Scheme;
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

proc validate_ServiceMembersListGlobalConfiguration_564849(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the global configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564851 = path.getOrDefault("serviceName")
  valid_564851 = validateParameter(valid_564851, JString, required = true,
                                 default = nil)
  if valid_564851 != nil:
    section.add "serviceName", valid_564851
  var valid_564852 = path.getOrDefault("serviceMemberId")
  valid_564852 = validateParameter(valid_564852, JString, required = true,
                                 default = nil)
  if valid_564852 != nil:
    section.add "serviceMemberId", valid_564852
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564853 = query.getOrDefault("api-version")
  valid_564853 = validateParameter(valid_564853, JString, required = true,
                                 default = nil)
  if valid_564853 != nil:
    section.add "api-version", valid_564853
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564854: Call_ServiceMembersListGlobalConfiguration_564848;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the global configuration.
  ## 
  let valid = call_564854.validator(path, query, header, formData, body)
  let scheme = call_564854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564854.url(scheme.get, call_564854.host, call_564854.base,
                         call_564854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564854, url, valid)

proc call*(call_564855: Call_ServiceMembersListGlobalConfiguration_564848;
          serviceName: string; apiVersion: string; serviceMemberId: string): Recallable =
  ## serviceMembersListGlobalConfiguration
  ## Gets the global configuration.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server id.
  var path_564856 = newJObject()
  var query_564857 = newJObject()
  add(path_564856, "serviceName", newJString(serviceName))
  add(query_564857, "api-version", newJString(apiVersion))
  add(path_564856, "serviceMemberId", newJString(serviceMemberId))
  result = call_564855.call(path_564856, query_564857, nil, nil, nil)

var serviceMembersListGlobalConfiguration* = Call_ServiceMembersListGlobalConfiguration_564848(
    name: "serviceMembersListGlobalConfiguration", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/globalconfiguration",
    validator: validate_ServiceMembersListGlobalConfiguration_564849, base: "",
    url: url_ServiceMembersListGlobalConfiguration_564850, schemes: {Scheme.Https})
type
  Call_ServiceMembersGetConnectorMetadata_564858 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersGetConnectorMetadata_564860(protocol: Scheme; host: string;
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

proc validate_ServiceMembersGetConnectorMetadata_564859(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of connectors and run profile names.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   metricName: JString (required)
  ##             : The name of the metric.
  ##   serviceMemberId: JString (required)
  ##                  : The service member id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564861 = path.getOrDefault("serviceName")
  valid_564861 = validateParameter(valid_564861, JString, required = true,
                                 default = nil)
  if valid_564861 != nil:
    section.add "serviceName", valid_564861
  var valid_564862 = path.getOrDefault("metricName")
  valid_564862 = validateParameter(valid_564862, JString, required = true,
                                 default = nil)
  if valid_564862 != nil:
    section.add "metricName", valid_564862
  var valid_564863 = path.getOrDefault("serviceMemberId")
  valid_564863 = validateParameter(valid_564863, JString, required = true,
                                 default = nil)
  if valid_564863 != nil:
    section.add "serviceMemberId", valid_564863
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564864 = query.getOrDefault("api-version")
  valid_564864 = validateParameter(valid_564864, JString, required = true,
                                 default = nil)
  if valid_564864 != nil:
    section.add "api-version", valid_564864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564865: Call_ServiceMembersGetConnectorMetadata_564858;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of connectors and run profile names.
  ## 
  let valid = call_564865.validator(path, query, header, formData, body)
  let scheme = call_564865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564865.url(scheme.get, call_564865.host, call_564865.base,
                         call_564865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564865, url, valid)

proc call*(call_564866: Call_ServiceMembersGetConnectorMetadata_564858;
          serviceName: string; apiVersion: string; metricName: string;
          serviceMemberId: string): Recallable =
  ## serviceMembersGetConnectorMetadata
  ## Gets the list of connectors and run profile names.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   metricName: string (required)
  ##             : The name of the metric.
  ##   serviceMemberId: string (required)
  ##                  : The service member id.
  var path_564867 = newJObject()
  var query_564868 = newJObject()
  add(path_564867, "serviceName", newJString(serviceName))
  add(query_564868, "api-version", newJString(apiVersion))
  add(path_564867, "metricName", newJString(metricName))
  add(path_564867, "serviceMemberId", newJString(serviceMemberId))
  result = call_564866.call(path_564867, query_564868, nil, nil, nil)

var serviceMembersGetConnectorMetadata* = Call_ServiceMembersGetConnectorMetadata_564858(
    name: "serviceMembersGetConnectorMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/metrics/{metricName}",
    validator: validate_ServiceMembersGetConnectorMetadata_564859, base: "",
    url: url_ServiceMembersGetConnectorMetadata_564860, schemes: {Scheme.Https})
type
  Call_ServiceMembersGetMetrics_564869 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersGetMetrics_564871(protocol: Scheme; host: string;
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

proc validate_ServiceMembersGetMetrics_564870(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the server related metrics for a given metric and group combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceMemberId: JString (required)
  ##                  : The server id.
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   metricName: JString (required)
  ##             : The metric name
  ##   groupName: JString (required)
  ##            : The group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceMemberId` field"
  var valid_564872 = path.getOrDefault("serviceMemberId")
  valid_564872 = validateParameter(valid_564872, JString, required = true,
                                 default = nil)
  if valid_564872 != nil:
    section.add "serviceMemberId", valid_564872
  var valid_564873 = path.getOrDefault("serviceName")
  valid_564873 = validateParameter(valid_564873, JString, required = true,
                                 default = nil)
  if valid_564873 != nil:
    section.add "serviceName", valid_564873
  var valid_564874 = path.getOrDefault("metricName")
  valid_564874 = validateParameter(valid_564874, JString, required = true,
                                 default = nil)
  if valid_564874 != nil:
    section.add "metricName", valid_564874
  var valid_564875 = path.getOrDefault("groupName")
  valid_564875 = validateParameter(valid_564875, JString, required = true,
                                 default = nil)
  if valid_564875 != nil:
    section.add "groupName", valid_564875
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   groupKey: JString
  ##           : The group key
  ##   fromDate: JString
  ##           : The start date.
  ##   toDate: JString
  ##         : The end date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564876 = query.getOrDefault("api-version")
  valid_564876 = validateParameter(valid_564876, JString, required = true,
                                 default = nil)
  if valid_564876 != nil:
    section.add "api-version", valid_564876
  var valid_564877 = query.getOrDefault("groupKey")
  valid_564877 = validateParameter(valid_564877, JString, required = false,
                                 default = nil)
  if valid_564877 != nil:
    section.add "groupKey", valid_564877
  var valid_564878 = query.getOrDefault("fromDate")
  valid_564878 = validateParameter(valid_564878, JString, required = false,
                                 default = nil)
  if valid_564878 != nil:
    section.add "fromDate", valid_564878
  var valid_564879 = query.getOrDefault("toDate")
  valid_564879 = validateParameter(valid_564879, JString, required = false,
                                 default = nil)
  if valid_564879 != nil:
    section.add "toDate", valid_564879
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564880: Call_ServiceMembersGetMetrics_564869; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the server related metrics for a given metric and group combination.
  ## 
  let valid = call_564880.validator(path, query, header, formData, body)
  let scheme = call_564880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564880.url(scheme.get, call_564880.host, call_564880.base,
                         call_564880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564880, url, valid)

proc call*(call_564881: Call_ServiceMembersGetMetrics_564869;
          serviceMemberId: string; serviceName: string; apiVersion: string;
          metricName: string; groupName: string; groupKey: string = "";
          fromDate: string = ""; toDate: string = ""): Recallable =
  ## serviceMembersGetMetrics
  ## Gets the server related metrics for a given metric and group combination.
  ##   serviceMemberId: string (required)
  ##                  : The server id.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   groupKey: string
  ##           : The group key
  ##   metricName: string (required)
  ##             : The metric name
  ##   fromDate: string
  ##           : The start date.
  ##   groupName: string (required)
  ##            : The group name
  ##   toDate: string
  ##         : The end date.
  var path_564882 = newJObject()
  var query_564883 = newJObject()
  add(path_564882, "serviceMemberId", newJString(serviceMemberId))
  add(path_564882, "serviceName", newJString(serviceName))
  add(query_564883, "api-version", newJString(apiVersion))
  add(query_564883, "groupKey", newJString(groupKey))
  add(path_564882, "metricName", newJString(metricName))
  add(query_564883, "fromDate", newJString(fromDate))
  add(path_564882, "groupName", newJString(groupName))
  add(query_564883, "toDate", newJString(toDate))
  result = call_564881.call(path_564882, query_564883, nil, nil, nil)

var serviceMembersGetMetrics* = Call_ServiceMembersGetMetrics_564869(
    name: "serviceMembersGetMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/metrics/{metricName}/groups/{groupName}",
    validator: validate_ServiceMembersGetMetrics_564870, base: "",
    url: url_ServiceMembersGetMetrics_564871, schemes: {Scheme.Https})
type
  Call_ServiceMembersGetServiceConfiguration_564884 = ref object of OpenApiRestCall_563565
proc url_ServiceMembersGetServiceConfiguration_564886(protocol: Scheme;
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

proc validate_ServiceMembersGetServiceConfiguration_564885(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the service configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.
  ##   serviceMemberId: JString (required)
  ##                  : The server Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564887 = path.getOrDefault("serviceName")
  valid_564887 = validateParameter(valid_564887, JString, required = true,
                                 default = nil)
  if valid_564887 != nil:
    section.add "serviceName", valid_564887
  var valid_564888 = path.getOrDefault("serviceMemberId")
  valid_564888 = validateParameter(valid_564888, JString, required = true,
                                 default = nil)
  if valid_564888 != nil:
    section.add "serviceMemberId", valid_564888
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564889 = query.getOrDefault("api-version")
  valid_564889 = validateParameter(valid_564889, JString, required = true,
                                 default = nil)
  if valid_564889 != nil:
    section.add "api-version", valid_564889
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564890: Call_ServiceMembersGetServiceConfiguration_564884;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the service configuration.
  ## 
  let valid = call_564890.validator(path, query, header, formData, body)
  let scheme = call_564890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564890.url(scheme.get, call_564890.host, call_564890.base,
                         call_564890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564890, url, valid)

proc call*(call_564891: Call_ServiceMembersGetServiceConfiguration_564884;
          serviceName: string; apiVersion: string; serviceMemberId: string): Recallable =
  ## serviceMembersGetServiceConfiguration
  ## Gets the service configuration.
  ##   serviceName: string (required)
  ##              : The name of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   serviceMemberId: string (required)
  ##                  : The server Id.
  var path_564892 = newJObject()
  var query_564893 = newJObject()
  add(path_564892, "serviceName", newJString(serviceName))
  add(query_564893, "api-version", newJString(apiVersion))
  add(path_564892, "serviceMemberId", newJString(serviceMemberId))
  result = call_564891.call(path_564892, query_564893, nil, nil, nil)

var serviceMembersGetServiceConfiguration* = Call_ServiceMembersGetServiceConfiguration_564884(
    name: "serviceMembersGetServiceConfiguration", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.ADHybridHealthService/services/{serviceName}/servicemembers/{serviceMemberId}/serviceconfiguration",
    validator: validate_ServiceMembersGetServiceConfiguration_564885, base: "",
    url: url_ServiceMembersGetServiceConfiguration_564886, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
