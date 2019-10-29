
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Data Migration Service Resource Provider
## version: 2018-03-15-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Data Migration Service helps people migrate their data from on-premise database servers to Azure, or from older database software to newer software. The service manages one or more workers that are joined to a customer's virtual network, which is assumed to provide connectivity to their databases. To avoid frequent updates to the resource provider, data migration tasks are implemented by the resource provider in a generic way as task resources, each of which has a task type (which identifies the type of work to run), input, and output. The client is responsible for providing appropriate task type and inputs, which will be passed through unexamined to the machines that implement the functionality, and for understanding the output, which is passed back unexamined to the client.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "datamigration"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563777 = ref object of OpenApiRestCall_563555
proc url_OperationsList_563779(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563778(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all available actions exposed by the Data Migration Service resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_OperationsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all available actions exposed by the Data Migration Service resource provider.
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_OperationsList_563777; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all available actions exposed by the Data Migration Service resource provider.
  ##   apiVersion: string (required)
  ##             : Version of the API
  var query_564035 = newJObject()
  add(query_564035, "api-version", newJString(apiVersion))
  result = call_564034.call(nil, query_564035, nil, nil, nil)

var operationsList* = Call_OperationsList_563777(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataMigration/operations",
    validator: validate_OperationsList_563778, base: "", url: url_OperationsList_563779,
    schemes: {Scheme.Https})
type
  Call_ServicesCheckNameAvailability_564075 = ref object of OpenApiRestCall_563555
proc url_ServicesCheckNameAvailability_564077(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCheckNameAvailability_564076(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method checks whether a proposed top-level resource name is valid and available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   location: JString (required)
  ##           : The Azure region of the operation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564092 = path.getOrDefault("subscriptionId")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "subscriptionId", valid_564092
  var valid_564093 = path.getOrDefault("location")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "location", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564094 = query.getOrDefault("api-version")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "api-version", valid_564094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Requested name to validate
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564096: Call_ServicesCheckNameAvailability_564075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method checks whether a proposed top-level resource name is valid and available.
  ## 
  let valid = call_564096.validator(path, query, header, formData, body)
  let scheme = call_564096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564096.url(scheme.get, call_564096.host, call_564096.base,
                         call_564096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564096, url, valid)

proc call*(call_564097: Call_ServicesCheckNameAvailability_564075;
          apiVersion: string; subscriptionId: string; location: string;
          parameters: JsonNode): Recallable =
  ## servicesCheckNameAvailability
  ## This method checks whether a proposed top-level resource name is valid and available.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   location: string (required)
  ##           : The Azure region of the operation
  ##   parameters: JObject (required)
  ##             : Requested name to validate
  var path_564098 = newJObject()
  var query_564099 = newJObject()
  var body_564100 = newJObject()
  add(query_564099, "api-version", newJString(apiVersion))
  add(path_564098, "subscriptionId", newJString(subscriptionId))
  add(path_564098, "location", newJString(location))
  if parameters != nil:
    body_564100 = parameters
  result = call_564097.call(path_564098, query_564099, nil, nil, body_564100)

var servicesCheckNameAvailability* = Call_ServicesCheckNameAvailability_564075(
    name: "servicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataMigration/locations/{location}/checkNameAvailability",
    validator: validate_ServicesCheckNameAvailability_564076, base: "",
    url: url_ServicesCheckNameAvailability_564077, schemes: {Scheme.Https})
type
  Call_UsagesList_564101 = ref object of OpenApiRestCall_563555
proc url_UsagesList_564103(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesList_564102(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## This method returns region-specific quotas and resource usage information for the Data Migration Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   location: JString (required)
  ##           : The Azure region of the operation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564104 = path.getOrDefault("subscriptionId")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "subscriptionId", valid_564104
  var valid_564105 = path.getOrDefault("location")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "location", valid_564105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564107: Call_UsagesList_564101; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method returns region-specific quotas and resource usage information for the Data Migration Service.
  ## 
  let valid = call_564107.validator(path, query, header, formData, body)
  let scheme = call_564107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564107.url(scheme.get, call_564107.host, call_564107.base,
                         call_564107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564107, url, valid)

proc call*(call_564108: Call_UsagesList_564101; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesList
  ## This method returns region-specific quotas and resource usage information for the Data Migration Service.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   location: string (required)
  ##           : The Azure region of the operation
  var path_564109 = newJObject()
  var query_564110 = newJObject()
  add(query_564110, "api-version", newJString(apiVersion))
  add(path_564109, "subscriptionId", newJString(subscriptionId))
  add(path_564109, "location", newJString(location))
  result = call_564108.call(path_564109, query_564110, nil, nil, nil)

var usagesList* = Call_UsagesList_564101(name: "usagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataMigration/locations/{location}/usages",
                                      validator: validate_UsagesList_564102,
                                      base: "", url: url_UsagesList_564103,
                                      schemes: {Scheme.Https})
type
  Call_ServicesList_564111 = ref object of OpenApiRestCall_563555
proc url_ServicesList_564113(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesList_564112(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564114 = path.getOrDefault("subscriptionId")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "subscriptionId", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_ServicesList_564111; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a subscription.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_ServicesList_564111; apiVersion: string;
          subscriptionId: string): Recallable =
  ## servicesList
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var servicesList* = Call_ServicesList_564111(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataMigration/services",
    validator: validate_ServicesList_564112, base: "", url: url_ServicesList_564113,
    schemes: {Scheme.Https})
type
  Call_ResourceSkusListSkus_564120 = ref object of OpenApiRestCall_563555
proc url_ResourceSkusListSkus_564122(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataMigration/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceSkusListSkus_564121(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The skus action returns the list of SKUs that DMS supports.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564124 = query.getOrDefault("api-version")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "api-version", valid_564124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564125: Call_ResourceSkusListSkus_564120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The skus action returns the list of SKUs that DMS supports.
  ## 
  let valid = call_564125.validator(path, query, header, formData, body)
  let scheme = call_564125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564125.url(scheme.get, call_564125.host, call_564125.base,
                         call_564125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564125, url, valid)

proc call*(call_564126: Call_ResourceSkusListSkus_564120; apiVersion: string;
          subscriptionId: string): Recallable =
  ## resourceSkusListSkus
  ## The skus action returns the list of SKUs that DMS supports.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  var path_564127 = newJObject()
  var query_564128 = newJObject()
  add(query_564128, "api-version", newJString(apiVersion))
  add(path_564127, "subscriptionId", newJString(subscriptionId))
  result = call_564126.call(path_564127, query_564128, nil, nil, nil)

var resourceSkusListSkus* = Call_ResourceSkusListSkus_564120(
    name: "resourceSkusListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataMigration/skus",
    validator: validate_ResourceSkusListSkus_564121, base: "",
    url: url_ResourceSkusListSkus_564122, schemes: {Scheme.Https})
type
  Call_ServicesListByResourceGroup_564129 = ref object of OpenApiRestCall_563555
proc url_ServicesListByResourceGroup_564131(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListByResourceGroup_564130(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564132 = path.getOrDefault("subscriptionId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "subscriptionId", valid_564132
  var valid_564133 = path.getOrDefault("groupName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "groupName", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_ServicesListByResourceGroup_564129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a resource group.
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_ServicesListByResourceGroup_564129;
          apiVersion: string; subscriptionId: string; groupName: string): Recallable =
  ## servicesListByResourceGroup
  ## The Services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  add(path_564137, "groupName", newJString(groupName))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var servicesListByResourceGroup* = Call_ServicesListByResourceGroup_564129(
    name: "servicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services",
    validator: validate_ServicesListByResourceGroup_564130, base: "",
    url: url_ServicesListByResourceGroup_564131, schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_564150 = ref object of OpenApiRestCall_563555
proc url_ServicesCreateOrUpdate_564152(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCreateOrUpdate_564151(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The PUT method creates a new service or updates an existing one. When a service is updated, existing child resources (i.e. tasks) are unaffected. Services currently support a single kind, "vm", which refers to a VM-based service, although other kinds may be added in the future. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy"). The provider will reply when successful with 200 OK or 201 Created. Long-running operations use the provisioningState property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564153 = path.getOrDefault("serviceName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "serviceName", valid_564153
  var valid_564154 = path.getOrDefault("subscriptionId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "subscriptionId", valid_564154
  var valid_564155 = path.getOrDefault("groupName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "groupName", valid_564155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564156 = query.getOrDefault("api-version")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "api-version", valid_564156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the service
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564158: Call_ServicesCreateOrUpdate_564150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The PUT method creates a new service or updates an existing one. When a service is updated, existing child resources (i.e. tasks) are unaffected. Services currently support a single kind, "vm", which refers to a VM-based service, although other kinds may be added in the future. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy"). The provider will reply when successful with 200 OK or 201 Created. Long-running operations use the provisioningState property.
  ## 
  let valid = call_564158.validator(path, query, header, formData, body)
  let scheme = call_564158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564158.url(scheme.get, call_564158.host, call_564158.base,
                         call_564158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564158, url, valid)

proc call*(call_564159: Call_ServicesCreateOrUpdate_564150; serviceName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          groupName: string): Recallable =
  ## servicesCreateOrUpdate
  ## The services resource is the top-level resource that represents the Data Migration Service. The PUT method creates a new service or updates an existing one. When a service is updated, existing child resources (i.e. tasks) are unaffected. Services currently support a single kind, "vm", which refers to a VM-based service, although other kinds may be added in the future. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy"). The provider will reply when successful with 200 OK or 201 Created. Long-running operations use the provisioningState property.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   parameters: JObject (required)
  ##             : Information about the service
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564160 = newJObject()
  var query_564161 = newJObject()
  var body_564162 = newJObject()
  add(path_564160, "serviceName", newJString(serviceName))
  add(query_564161, "api-version", newJString(apiVersion))
  add(path_564160, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564162 = parameters
  add(path_564160, "groupName", newJString(groupName))
  result = call_564159.call(path_564160, query_564161, nil, nil, body_564162)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_564150(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}",
    validator: validate_ServicesCreateOrUpdate_564151, base: "",
    url: url_ServicesCreateOrUpdate_564152, schemes: {Scheme.Https})
type
  Call_ServicesGet_564139 = ref object of OpenApiRestCall_563555
proc url_ServicesGet_564141(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGet_564140(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The GET method retrieves information about a service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564142 = path.getOrDefault("serviceName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "serviceName", valid_564142
  var valid_564143 = path.getOrDefault("subscriptionId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "subscriptionId", valid_564143
  var valid_564144 = path.getOrDefault("groupName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "groupName", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "api-version", valid_564145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564146: Call_ServicesGet_564139; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The GET method retrieves information about a service instance.
  ## 
  let valid = call_564146.validator(path, query, header, formData, body)
  let scheme = call_564146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564146.url(scheme.get, call_564146.host, call_564146.base,
                         call_564146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564146, url, valid)

proc call*(call_564147: Call_ServicesGet_564139; serviceName: string;
          apiVersion: string; subscriptionId: string; groupName: string): Recallable =
  ## servicesGet
  ## The services resource is the top-level resource that represents the Data Migration Service. The GET method retrieves information about a service instance.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564148 = newJObject()
  var query_564149 = newJObject()
  add(path_564148, "serviceName", newJString(serviceName))
  add(query_564149, "api-version", newJString(apiVersion))
  add(path_564148, "subscriptionId", newJString(subscriptionId))
  add(path_564148, "groupName", newJString(groupName))
  result = call_564147.call(path_564148, query_564149, nil, nil, nil)

var servicesGet* = Call_ServicesGet_564139(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}",
                                        validator: validate_ServicesGet_564140,
                                        base: "", url: url_ServicesGet_564141,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_564175 = ref object of OpenApiRestCall_563555
proc url_ServicesUpdate_564177(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesUpdate_564176(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The PATCH method updates an existing service. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy").
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564178 = path.getOrDefault("serviceName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "serviceName", valid_564178
  var valid_564179 = path.getOrDefault("subscriptionId")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "subscriptionId", valid_564179
  var valid_564180 = path.getOrDefault("groupName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "groupName", valid_564180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564181 = query.getOrDefault("api-version")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "api-version", valid_564181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the service
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564183: Call_ServicesUpdate_564175; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The PATCH method updates an existing service. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy").
  ## 
  let valid = call_564183.validator(path, query, header, formData, body)
  let scheme = call_564183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564183.url(scheme.get, call_564183.host, call_564183.base,
                         call_564183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564183, url, valid)

proc call*(call_564184: Call_ServicesUpdate_564175; serviceName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          groupName: string): Recallable =
  ## servicesUpdate
  ## The services resource is the top-level resource that represents the Data Migration Service. The PATCH method updates an existing service. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy").
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   parameters: JObject (required)
  ##             : Information about the service
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564185 = newJObject()
  var query_564186 = newJObject()
  var body_564187 = newJObject()
  add(path_564185, "serviceName", newJString(serviceName))
  add(query_564186, "api-version", newJString(apiVersion))
  add(path_564185, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564187 = parameters
  add(path_564185, "groupName", newJString(groupName))
  result = call_564184.call(path_564185, query_564186, nil, nil, body_564187)

var servicesUpdate* = Call_ServicesUpdate_564175(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}",
    validator: validate_ServicesUpdate_564176, base: "", url: url_ServicesUpdate_564177,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_564163 = ref object of OpenApiRestCall_563555
proc url_ServicesDelete_564165(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesDelete_564164(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The DELETE method deletes a service. Any running tasks will be canceled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564166 = path.getOrDefault("serviceName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "serviceName", valid_564166
  var valid_564167 = path.getOrDefault("subscriptionId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subscriptionId", valid_564167
  var valid_564168 = path.getOrDefault("groupName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "groupName", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   deleteRunningTasks: JBool
  ##                     : Delete the resource even if it contains running tasks
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  var valid_564169 = query.getOrDefault("deleteRunningTasks")
  valid_564169 = validateParameter(valid_564169, JBool, required = false, default = nil)
  if valid_564169 != nil:
    section.add "deleteRunningTasks", valid_564169
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564170 = query.getOrDefault("api-version")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "api-version", valid_564170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564171: Call_ServicesDelete_564163; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The DELETE method deletes a service. Any running tasks will be canceled.
  ## 
  let valid = call_564171.validator(path, query, header, formData, body)
  let scheme = call_564171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564171.url(scheme.get, call_564171.host, call_564171.base,
                         call_564171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564171, url, valid)

proc call*(call_564172: Call_ServicesDelete_564163; serviceName: string;
          apiVersion: string; subscriptionId: string; groupName: string;
          deleteRunningTasks: bool = false): Recallable =
  ## servicesDelete
  ## The services resource is the top-level resource that represents the Data Migration Service. The DELETE method deletes a service. Any running tasks will be canceled.
  ##   deleteRunningTasks: bool
  ##                     : Delete the resource even if it contains running tasks
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564173 = newJObject()
  var query_564174 = newJObject()
  add(query_564174, "deleteRunningTasks", newJBool(deleteRunningTasks))
  add(path_564173, "serviceName", newJString(serviceName))
  add(query_564174, "api-version", newJString(apiVersion))
  add(path_564173, "subscriptionId", newJString(subscriptionId))
  add(path_564173, "groupName", newJString(groupName))
  result = call_564172.call(path_564173, query_564174, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_564163(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}",
    validator: validate_ServicesDelete_564164, base: "", url: url_ServicesDelete_564165,
    schemes: {Scheme.Https})
type
  Call_ServicesCheckChildrenNameAvailability_564188 = ref object of OpenApiRestCall_563555
proc url_ServicesCheckChildrenNameAvailability_564190(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCheckChildrenNameAvailability_564189(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method checks whether a proposed nested resource name is valid and available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564191 = path.getOrDefault("serviceName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "serviceName", valid_564191
  var valid_564192 = path.getOrDefault("subscriptionId")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "subscriptionId", valid_564192
  var valid_564193 = path.getOrDefault("groupName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "groupName", valid_564193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564194 = query.getOrDefault("api-version")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "api-version", valid_564194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Requested name to validate
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564196: Call_ServicesCheckChildrenNameAvailability_564188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method checks whether a proposed nested resource name is valid and available.
  ## 
  let valid = call_564196.validator(path, query, header, formData, body)
  let scheme = call_564196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564196.url(scheme.get, call_564196.host, call_564196.base,
                         call_564196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564196, url, valid)

proc call*(call_564197: Call_ServicesCheckChildrenNameAvailability_564188;
          serviceName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; groupName: string): Recallable =
  ## servicesCheckChildrenNameAvailability
  ## This method checks whether a proposed nested resource name is valid and available.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   parameters: JObject (required)
  ##             : Requested name to validate
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564198 = newJObject()
  var query_564199 = newJObject()
  var body_564200 = newJObject()
  add(path_564198, "serviceName", newJString(serviceName))
  add(query_564199, "api-version", newJString(apiVersion))
  add(path_564198, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564200 = parameters
  add(path_564198, "groupName", newJString(groupName))
  result = call_564197.call(path_564198, query_564199, nil, nil, body_564200)

var servicesCheckChildrenNameAvailability* = Call_ServicesCheckChildrenNameAvailability_564188(
    name: "servicesCheckChildrenNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/checkNameAvailability",
    validator: validate_ServicesCheckChildrenNameAvailability_564189, base: "",
    url: url_ServicesCheckChildrenNameAvailability_564190, schemes: {Scheme.Https})
type
  Call_ServicesCheckStatus_564201 = ref object of OpenApiRestCall_563555
proc url_ServicesCheckStatus_564203(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/checkStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCheckStatus_564202(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action performs a health check and returns the status of the service and virtual machine size.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564204 = path.getOrDefault("serviceName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "serviceName", valid_564204
  var valid_564205 = path.getOrDefault("subscriptionId")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "subscriptionId", valid_564205
  var valid_564206 = path.getOrDefault("groupName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "groupName", valid_564206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564207 = query.getOrDefault("api-version")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "api-version", valid_564207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564208: Call_ServicesCheckStatus_564201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action performs a health check and returns the status of the service and virtual machine size.
  ## 
  let valid = call_564208.validator(path, query, header, formData, body)
  let scheme = call_564208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564208.url(scheme.get, call_564208.host, call_564208.base,
                         call_564208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564208, url, valid)

proc call*(call_564209: Call_ServicesCheckStatus_564201; serviceName: string;
          apiVersion: string; subscriptionId: string; groupName: string): Recallable =
  ## servicesCheckStatus
  ## The services resource is the top-level resource that represents the Data Migration Service. This action performs a health check and returns the status of the service and virtual machine size.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564210 = newJObject()
  var query_564211 = newJObject()
  add(path_564210, "serviceName", newJString(serviceName))
  add(query_564211, "api-version", newJString(apiVersion))
  add(path_564210, "subscriptionId", newJString(subscriptionId))
  add(path_564210, "groupName", newJString(groupName))
  result = call_564209.call(path_564210, query_564211, nil, nil, nil)

var servicesCheckStatus* = Call_ServicesCheckStatus_564201(
    name: "servicesCheckStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/checkStatus",
    validator: validate_ServicesCheckStatus_564202, base: "",
    url: url_ServicesCheckStatus_564203, schemes: {Scheme.Https})
type
  Call_ProjectsList_564212 = ref object of OpenApiRestCall_563555
proc url_ProjectsList_564214(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsList_564213(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. This method returns a list of projects owned by a service resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564215 = path.getOrDefault("serviceName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "serviceName", valid_564215
  var valid_564216 = path.getOrDefault("subscriptionId")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "subscriptionId", valid_564216
  var valid_564217 = path.getOrDefault("groupName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "groupName", valid_564217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564218 = query.getOrDefault("api-version")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "api-version", valid_564218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564219: Call_ProjectsList_564212; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. This method returns a list of projects owned by a service resource.
  ## 
  let valid = call_564219.validator(path, query, header, formData, body)
  let scheme = call_564219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564219.url(scheme.get, call_564219.host, call_564219.base,
                         call_564219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564219, url, valid)

proc call*(call_564220: Call_ProjectsList_564212; serviceName: string;
          apiVersion: string; subscriptionId: string; groupName: string): Recallable =
  ## projectsList
  ## The project resource is a nested resource representing a stored migration project. This method returns a list of projects owned by a service resource.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564221 = newJObject()
  var query_564222 = newJObject()
  add(path_564221, "serviceName", newJString(serviceName))
  add(query_564222, "api-version", newJString(apiVersion))
  add(path_564221, "subscriptionId", newJString(subscriptionId))
  add(path_564221, "groupName", newJString(groupName))
  result = call_564220.call(path_564221, query_564222, nil, nil, nil)

var projectsList* = Call_ProjectsList_564212(name: "projectsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects",
    validator: validate_ProjectsList_564213, base: "", url: url_ProjectsList_564214,
    schemes: {Scheme.Https})
type
  Call_ProjectsCreateOrUpdate_564235 = ref object of OpenApiRestCall_563555
proc url_ProjectsCreateOrUpdate_564237(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsCreateOrUpdate_564236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. The PUT method creates a new project or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564238 = path.getOrDefault("serviceName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "serviceName", valid_564238
  var valid_564239 = path.getOrDefault("subscriptionId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "subscriptionId", valid_564239
  var valid_564240 = path.getOrDefault("projectName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "projectName", valid_564240
  var valid_564241 = path.getOrDefault("groupName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "groupName", valid_564241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564242 = query.getOrDefault("api-version")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "api-version", valid_564242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the project
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564244: Call_ProjectsCreateOrUpdate_564235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. The PUT method creates a new project or updates an existing one.
  ## 
  let valid = call_564244.validator(path, query, header, formData, body)
  let scheme = call_564244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564244.url(scheme.get, call_564244.host, call_564244.base,
                         call_564244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564244, url, valid)

proc call*(call_564245: Call_ProjectsCreateOrUpdate_564235; serviceName: string;
          apiVersion: string; subscriptionId: string; projectName: string;
          parameters: JsonNode; groupName: string): Recallable =
  ## projectsCreateOrUpdate
  ## The project resource is a nested resource representing a stored migration project. The PUT method creates a new project or updates an existing one.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   projectName: string (required)
  ##              : Name of the project
  ##   parameters: JObject (required)
  ##             : Information about the project
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564246 = newJObject()
  var query_564247 = newJObject()
  var body_564248 = newJObject()
  add(path_564246, "serviceName", newJString(serviceName))
  add(query_564247, "api-version", newJString(apiVersion))
  add(path_564246, "subscriptionId", newJString(subscriptionId))
  add(path_564246, "projectName", newJString(projectName))
  if parameters != nil:
    body_564248 = parameters
  add(path_564246, "groupName", newJString(groupName))
  result = call_564245.call(path_564246, query_564247, nil, nil, body_564248)

var projectsCreateOrUpdate* = Call_ProjectsCreateOrUpdate_564235(
    name: "projectsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}",
    validator: validate_ProjectsCreateOrUpdate_564236, base: "",
    url: url_ProjectsCreateOrUpdate_564237, schemes: {Scheme.Https})
type
  Call_ProjectsGet_564223 = ref object of OpenApiRestCall_563555
proc url_ProjectsGet_564225(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsGet_564224(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. The GET method retrieves information about a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564226 = path.getOrDefault("serviceName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "serviceName", valid_564226
  var valid_564227 = path.getOrDefault("subscriptionId")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "subscriptionId", valid_564227
  var valid_564228 = path.getOrDefault("projectName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "projectName", valid_564228
  var valid_564229 = path.getOrDefault("groupName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "groupName", valid_564229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564230 = query.getOrDefault("api-version")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "api-version", valid_564230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564231: Call_ProjectsGet_564223; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. The GET method retrieves information about a project.
  ## 
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_ProjectsGet_564223; serviceName: string;
          apiVersion: string; subscriptionId: string; projectName: string;
          groupName: string): Recallable =
  ## projectsGet
  ## The project resource is a nested resource representing a stored migration project. The GET method retrieves information about a project.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   projectName: string (required)
  ##              : Name of the project
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  add(path_564233, "serviceName", newJString(serviceName))
  add(query_564234, "api-version", newJString(apiVersion))
  add(path_564233, "subscriptionId", newJString(subscriptionId))
  add(path_564233, "projectName", newJString(projectName))
  add(path_564233, "groupName", newJString(groupName))
  result = call_564232.call(path_564233, query_564234, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_564223(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}",
                                        validator: validate_ProjectsGet_564224,
                                        base: "", url: url_ProjectsGet_564225,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_564262 = ref object of OpenApiRestCall_563555
proc url_ProjectsUpdate_564264(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsUpdate_564263(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. The PATCH method updates an existing project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564265 = path.getOrDefault("serviceName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "serviceName", valid_564265
  var valid_564266 = path.getOrDefault("subscriptionId")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "subscriptionId", valid_564266
  var valid_564267 = path.getOrDefault("projectName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "projectName", valid_564267
  var valid_564268 = path.getOrDefault("groupName")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "groupName", valid_564268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564269 = query.getOrDefault("api-version")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "api-version", valid_564269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the project
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564271: Call_ProjectsUpdate_564262; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. The PATCH method updates an existing project.
  ## 
  let valid = call_564271.validator(path, query, header, formData, body)
  let scheme = call_564271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564271.url(scheme.get, call_564271.host, call_564271.base,
                         call_564271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564271, url, valid)

proc call*(call_564272: Call_ProjectsUpdate_564262; serviceName: string;
          apiVersion: string; subscriptionId: string; projectName: string;
          parameters: JsonNode; groupName: string): Recallable =
  ## projectsUpdate
  ## The project resource is a nested resource representing a stored migration project. The PATCH method updates an existing project.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   projectName: string (required)
  ##              : Name of the project
  ##   parameters: JObject (required)
  ##             : Information about the project
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564273 = newJObject()
  var query_564274 = newJObject()
  var body_564275 = newJObject()
  add(path_564273, "serviceName", newJString(serviceName))
  add(query_564274, "api-version", newJString(apiVersion))
  add(path_564273, "subscriptionId", newJString(subscriptionId))
  add(path_564273, "projectName", newJString(projectName))
  if parameters != nil:
    body_564275 = parameters
  add(path_564273, "groupName", newJString(groupName))
  result = call_564272.call(path_564273, query_564274, nil, nil, body_564275)

var projectsUpdate* = Call_ProjectsUpdate_564262(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}",
    validator: validate_ProjectsUpdate_564263, base: "", url: url_ProjectsUpdate_564264,
    schemes: {Scheme.Https})
type
  Call_ProjectsDelete_564249 = ref object of OpenApiRestCall_563555
proc url_ProjectsDelete_564251(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsDelete_564250(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. The DELETE method deletes a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564252 = path.getOrDefault("serviceName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "serviceName", valid_564252
  var valid_564253 = path.getOrDefault("subscriptionId")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "subscriptionId", valid_564253
  var valid_564254 = path.getOrDefault("projectName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "projectName", valid_564254
  var valid_564255 = path.getOrDefault("groupName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "groupName", valid_564255
  result.add "path", section
  ## parameters in `query` object:
  ##   deleteRunningTasks: JBool
  ##                     : Delete the resource even if it contains running tasks
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  var valid_564256 = query.getOrDefault("deleteRunningTasks")
  valid_564256 = validateParameter(valid_564256, JBool, required = false, default = nil)
  if valid_564256 != nil:
    section.add "deleteRunningTasks", valid_564256
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "api-version", valid_564257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564258: Call_ProjectsDelete_564249; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. The DELETE method deletes a project.
  ## 
  let valid = call_564258.validator(path, query, header, formData, body)
  let scheme = call_564258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564258.url(scheme.get, call_564258.host, call_564258.base,
                         call_564258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564258, url, valid)

proc call*(call_564259: Call_ProjectsDelete_564249; serviceName: string;
          apiVersion: string; subscriptionId: string; projectName: string;
          groupName: string; deleteRunningTasks: bool = false): Recallable =
  ## projectsDelete
  ## The project resource is a nested resource representing a stored migration project. The DELETE method deletes a project.
  ##   deleteRunningTasks: bool
  ##                     : Delete the resource even if it contains running tasks
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   projectName: string (required)
  ##              : Name of the project
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564260 = newJObject()
  var query_564261 = newJObject()
  add(query_564261, "deleteRunningTasks", newJBool(deleteRunningTasks))
  add(path_564260, "serviceName", newJString(serviceName))
  add(query_564261, "api-version", newJString(apiVersion))
  add(path_564260, "subscriptionId", newJString(subscriptionId))
  add(path_564260, "projectName", newJString(projectName))
  add(path_564260, "groupName", newJString(groupName))
  result = call_564259.call(path_564260, query_564261, nil, nil, nil)

var projectsDelete* = Call_ProjectsDelete_564249(name: "projectsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}",
    validator: validate_ProjectsDelete_564250, base: "", url: url_ProjectsDelete_564251,
    schemes: {Scheme.Https})
type
  Call_TasksList_564276 = ref object of OpenApiRestCall_563555
proc url_TasksList_564278(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksList_564277(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of tasks owned by a service resource. Some tasks may have a status of Unknown, which indicates that an error occurred while querying the status of that task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564279 = path.getOrDefault("serviceName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "serviceName", valid_564279
  var valid_564280 = path.getOrDefault("subscriptionId")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "subscriptionId", valid_564280
  var valid_564281 = path.getOrDefault("projectName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "projectName", valid_564281
  var valid_564282 = path.getOrDefault("groupName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "groupName", valid_564282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  ##   taskType: JString
  ##           : Filter tasks by task type
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564283 = query.getOrDefault("api-version")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "api-version", valid_564283
  var valid_564284 = query.getOrDefault("taskType")
  valid_564284 = validateParameter(valid_564284, JString, required = false,
                                 default = nil)
  if valid_564284 != nil:
    section.add "taskType", valid_564284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564285: Call_TasksList_564276; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of tasks owned by a service resource. Some tasks may have a status of Unknown, which indicates that an error occurred while querying the status of that task.
  ## 
  let valid = call_564285.validator(path, query, header, formData, body)
  let scheme = call_564285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564285.url(scheme.get, call_564285.host, call_564285.base,
                         call_564285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564285, url, valid)

proc call*(call_564286: Call_TasksList_564276; serviceName: string;
          apiVersion: string; subscriptionId: string; projectName: string;
          groupName: string; taskType: string = ""): Recallable =
  ## tasksList
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of tasks owned by a service resource. Some tasks may have a status of Unknown, which indicates that an error occurred while querying the status of that task.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   taskType: string
  ##           : Filter tasks by task type
  ##   projectName: string (required)
  ##              : Name of the project
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564287 = newJObject()
  var query_564288 = newJObject()
  add(path_564287, "serviceName", newJString(serviceName))
  add(query_564288, "api-version", newJString(apiVersion))
  add(path_564287, "subscriptionId", newJString(subscriptionId))
  add(query_564288, "taskType", newJString(taskType))
  add(path_564287, "projectName", newJString(projectName))
  add(path_564287, "groupName", newJString(groupName))
  result = call_564286.call(path_564287, query_564288, nil, nil, nil)

var tasksList* = Call_TasksList_564276(name: "tasksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks",
                                    validator: validate_TasksList_564277,
                                    base: "", url: url_TasksList_564278,
                                    schemes: {Scheme.Https})
type
  Call_TasksCreateOrUpdate_564304 = ref object of OpenApiRestCall_563555
proc url_TasksCreateOrUpdate_564306(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksCreateOrUpdate_564305(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PUT method creates a new task or updates an existing one, although since tasks have no mutable custom properties, there is little reason to update an exising one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564307 = path.getOrDefault("serviceName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "serviceName", valid_564307
  var valid_564308 = path.getOrDefault("subscriptionId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "subscriptionId", valid_564308
  var valid_564309 = path.getOrDefault("taskName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "taskName", valid_564309
  var valid_564310 = path.getOrDefault("projectName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "projectName", valid_564310
  var valid_564311 = path.getOrDefault("groupName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "groupName", valid_564311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564312 = query.getOrDefault("api-version")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "api-version", valid_564312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the task
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_TasksCreateOrUpdate_564304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PUT method creates a new task or updates an existing one, although since tasks have no mutable custom properties, there is little reason to update an exising one.
  ## 
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_TasksCreateOrUpdate_564304; serviceName: string;
          apiVersion: string; subscriptionId: string; taskName: string;
          projectName: string; parameters: JsonNode; groupName: string): Recallable =
  ## tasksCreateOrUpdate
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PUT method creates a new task or updates an existing one, although since tasks have no mutable custom properties, there is little reason to update an exising one.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   parameters: JObject (required)
  ##             : Information about the task
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  var body_564318 = newJObject()
  add(path_564316, "serviceName", newJString(serviceName))
  add(query_564317, "api-version", newJString(apiVersion))
  add(path_564316, "subscriptionId", newJString(subscriptionId))
  add(path_564316, "taskName", newJString(taskName))
  add(path_564316, "projectName", newJString(projectName))
  if parameters != nil:
    body_564318 = parameters
  add(path_564316, "groupName", newJString(groupName))
  result = call_564315.call(path_564316, query_564317, nil, nil, body_564318)

var tasksCreateOrUpdate* = Call_TasksCreateOrUpdate_564304(
    name: "tasksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}",
    validator: validate_TasksCreateOrUpdate_564305, base: "",
    url: url_TasksCreateOrUpdate_564306, schemes: {Scheme.Https})
type
  Call_TasksGet_564289 = ref object of OpenApiRestCall_563555
proc url_TasksGet_564291(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksGet_564290(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The GET method retrieves information about a task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564293 = path.getOrDefault("serviceName")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "serviceName", valid_564293
  var valid_564294 = path.getOrDefault("subscriptionId")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "subscriptionId", valid_564294
  var valid_564295 = path.getOrDefault("taskName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "taskName", valid_564295
  var valid_564296 = path.getOrDefault("projectName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "projectName", valid_564296
  var valid_564297 = path.getOrDefault("groupName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "groupName", valid_564297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  ##   $expand: JString
  ##          : Expand the response
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564298 = query.getOrDefault("api-version")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "api-version", valid_564298
  var valid_564299 = query.getOrDefault("$expand")
  valid_564299 = validateParameter(valid_564299, JString, required = false,
                                 default = nil)
  if valid_564299 != nil:
    section.add "$expand", valid_564299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564300: Call_TasksGet_564289; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The GET method retrieves information about a task.
  ## 
  let valid = call_564300.validator(path, query, header, formData, body)
  let scheme = call_564300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564300.url(scheme.get, call_564300.host, call_564300.base,
                         call_564300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564300, url, valid)

proc call*(call_564301: Call_TasksGet_564289; serviceName: string;
          apiVersion: string; subscriptionId: string; taskName: string;
          projectName: string; groupName: string; Expand: string = ""): Recallable =
  ## tasksGet
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The GET method retrieves information about a task.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   Expand: string
  ##         : Expand the response
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564302 = newJObject()
  var query_564303 = newJObject()
  add(path_564302, "serviceName", newJString(serviceName))
  add(query_564303, "api-version", newJString(apiVersion))
  add(query_564303, "$expand", newJString(Expand))
  add(path_564302, "subscriptionId", newJString(subscriptionId))
  add(path_564302, "taskName", newJString(taskName))
  add(path_564302, "projectName", newJString(projectName))
  add(path_564302, "groupName", newJString(groupName))
  result = call_564301.call(path_564302, query_564303, nil, nil, nil)

var tasksGet* = Call_TasksGet_564289(name: "tasksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}",
                                  validator: validate_TasksGet_564290, base: "",
                                  url: url_TasksGet_564291,
                                  schemes: {Scheme.Https})
type
  Call_TasksUpdate_564333 = ref object of OpenApiRestCall_563555
proc url_TasksUpdate_564335(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksUpdate_564334(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PATCH method updates an existing task, but since tasks have no mutable custom properties, there is little reason to do so.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564336 = path.getOrDefault("serviceName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "serviceName", valid_564336
  var valid_564337 = path.getOrDefault("subscriptionId")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "subscriptionId", valid_564337
  var valid_564338 = path.getOrDefault("taskName")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "taskName", valid_564338
  var valid_564339 = path.getOrDefault("projectName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "projectName", valid_564339
  var valid_564340 = path.getOrDefault("groupName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "groupName", valid_564340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564341 = query.getOrDefault("api-version")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "api-version", valid_564341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the task
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564343: Call_TasksUpdate_564333; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PATCH method updates an existing task, but since tasks have no mutable custom properties, there is little reason to do so.
  ## 
  let valid = call_564343.validator(path, query, header, formData, body)
  let scheme = call_564343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564343.url(scheme.get, call_564343.host, call_564343.base,
                         call_564343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564343, url, valid)

proc call*(call_564344: Call_TasksUpdate_564333; serviceName: string;
          apiVersion: string; subscriptionId: string; taskName: string;
          projectName: string; parameters: JsonNode; groupName: string): Recallable =
  ## tasksUpdate
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PATCH method updates an existing task, but since tasks have no mutable custom properties, there is little reason to do so.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   parameters: JObject (required)
  ##             : Information about the task
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564345 = newJObject()
  var query_564346 = newJObject()
  var body_564347 = newJObject()
  add(path_564345, "serviceName", newJString(serviceName))
  add(query_564346, "api-version", newJString(apiVersion))
  add(path_564345, "subscriptionId", newJString(subscriptionId))
  add(path_564345, "taskName", newJString(taskName))
  add(path_564345, "projectName", newJString(projectName))
  if parameters != nil:
    body_564347 = parameters
  add(path_564345, "groupName", newJString(groupName))
  result = call_564344.call(path_564345, query_564346, nil, nil, body_564347)

var tasksUpdate* = Call_TasksUpdate_564333(name: "tasksUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}",
                                        validator: validate_TasksUpdate_564334,
                                        base: "", url: url_TasksUpdate_564335,
                                        schemes: {Scheme.Https})
type
  Call_TasksDelete_564319 = ref object of OpenApiRestCall_563555
proc url_TasksDelete_564321(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksDelete_564320(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The DELETE method deletes a task, canceling it first if it's running.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564322 = path.getOrDefault("serviceName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "serviceName", valid_564322
  var valid_564323 = path.getOrDefault("subscriptionId")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "subscriptionId", valid_564323
  var valid_564324 = path.getOrDefault("taskName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "taskName", valid_564324
  var valid_564325 = path.getOrDefault("projectName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "projectName", valid_564325
  var valid_564326 = path.getOrDefault("groupName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "groupName", valid_564326
  result.add "path", section
  ## parameters in `query` object:
  ##   deleteRunningTasks: JBool
  ##                     : Delete the resource even if it contains running tasks
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  var valid_564327 = query.getOrDefault("deleteRunningTasks")
  valid_564327 = validateParameter(valid_564327, JBool, required = false, default = nil)
  if valid_564327 != nil:
    section.add "deleteRunningTasks", valid_564327
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564328 = query.getOrDefault("api-version")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "api-version", valid_564328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564329: Call_TasksDelete_564319; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The DELETE method deletes a task, canceling it first if it's running.
  ## 
  let valid = call_564329.validator(path, query, header, formData, body)
  let scheme = call_564329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564329.url(scheme.get, call_564329.host, call_564329.base,
                         call_564329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564329, url, valid)

proc call*(call_564330: Call_TasksDelete_564319; serviceName: string;
          apiVersion: string; subscriptionId: string; taskName: string;
          projectName: string; groupName: string; deleteRunningTasks: bool = false): Recallable =
  ## tasksDelete
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The DELETE method deletes a task, canceling it first if it's running.
  ##   deleteRunningTasks: bool
  ##                     : Delete the resource even if it contains running tasks
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564331 = newJObject()
  var query_564332 = newJObject()
  add(query_564332, "deleteRunningTasks", newJBool(deleteRunningTasks))
  add(path_564331, "serviceName", newJString(serviceName))
  add(query_564332, "api-version", newJString(apiVersion))
  add(path_564331, "subscriptionId", newJString(subscriptionId))
  add(path_564331, "taskName", newJString(taskName))
  add(path_564331, "projectName", newJString(projectName))
  add(path_564331, "groupName", newJString(groupName))
  result = call_564330.call(path_564331, query_564332, nil, nil, nil)

var tasksDelete* = Call_TasksDelete_564319(name: "tasksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}",
                                        validator: validate_TasksDelete_564320,
                                        base: "", url: url_TasksDelete_564321,
                                        schemes: {Scheme.Https})
type
  Call_TasksCancel_564348 = ref object of OpenApiRestCall_563555
proc url_TasksCancel_564350(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksCancel_564349(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. This method cancels a task if it's currently queued or running.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564351 = path.getOrDefault("serviceName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "serviceName", valid_564351
  var valid_564352 = path.getOrDefault("subscriptionId")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "subscriptionId", valid_564352
  var valid_564353 = path.getOrDefault("taskName")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "taskName", valid_564353
  var valid_564354 = path.getOrDefault("projectName")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "projectName", valid_564354
  var valid_564355 = path.getOrDefault("groupName")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "groupName", valid_564355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564356 = query.getOrDefault("api-version")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "api-version", valid_564356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564357: Call_TasksCancel_564348; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. This method cancels a task if it's currently queued or running.
  ## 
  let valid = call_564357.validator(path, query, header, formData, body)
  let scheme = call_564357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564357.url(scheme.get, call_564357.host, call_564357.base,
                         call_564357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564357, url, valid)

proc call*(call_564358: Call_TasksCancel_564348; serviceName: string;
          apiVersion: string; subscriptionId: string; taskName: string;
          projectName: string; groupName: string): Recallable =
  ## tasksCancel
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. This method cancels a task if it's currently queued or running.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564359 = newJObject()
  var query_564360 = newJObject()
  add(path_564359, "serviceName", newJString(serviceName))
  add(query_564360, "api-version", newJString(apiVersion))
  add(path_564359, "subscriptionId", newJString(subscriptionId))
  add(path_564359, "taskName", newJString(taskName))
  add(path_564359, "projectName", newJString(projectName))
  add(path_564359, "groupName", newJString(groupName))
  result = call_564358.call(path_564359, query_564360, nil, nil, nil)

var tasksCancel* = Call_TasksCancel_564348(name: "tasksCancel",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}/cancel",
                                        validator: validate_TasksCancel_564349,
                                        base: "", url: url_TasksCancel_564350,
                                        schemes: {Scheme.Https})
type
  Call_ServicesListSkus_564361 = ref object of OpenApiRestCall_563555
proc url_ServicesListSkus_564363(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListSkus_564362(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The skus action returns the list of SKUs that a service resource can be updated to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564364 = path.getOrDefault("serviceName")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "serviceName", valid_564364
  var valid_564365 = path.getOrDefault("subscriptionId")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "subscriptionId", valid_564365
  var valid_564366 = path.getOrDefault("groupName")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "groupName", valid_564366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564367 = query.getOrDefault("api-version")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "api-version", valid_564367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564368: Call_ServicesListSkus_564361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The skus action returns the list of SKUs that a service resource can be updated to.
  ## 
  let valid = call_564368.validator(path, query, header, formData, body)
  let scheme = call_564368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564368.url(scheme.get, call_564368.host, call_564368.base,
                         call_564368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564368, url, valid)

proc call*(call_564369: Call_ServicesListSkus_564361; serviceName: string;
          apiVersion: string; subscriptionId: string; groupName: string): Recallable =
  ## servicesListSkus
  ## The services resource is the top-level resource that represents the Data Migration Service. The skus action returns the list of SKUs that a service resource can be updated to.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564370 = newJObject()
  var query_564371 = newJObject()
  add(path_564370, "serviceName", newJString(serviceName))
  add(query_564371, "api-version", newJString(apiVersion))
  add(path_564370, "subscriptionId", newJString(subscriptionId))
  add(path_564370, "groupName", newJString(groupName))
  result = call_564369.call(path_564370, query_564371, nil, nil, nil)

var servicesListSkus* = Call_ServicesListSkus_564361(name: "servicesListSkus",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/skus",
    validator: validate_ServicesListSkus_564362, base: "",
    url: url_ServicesListSkus_564363, schemes: {Scheme.Https})
type
  Call_ServicesStart_564372 = ref object of OpenApiRestCall_563555
proc url_ServicesStart_564374(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesStart_564373(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action starts the service and the service can be used for data migration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564375 = path.getOrDefault("serviceName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "serviceName", valid_564375
  var valid_564376 = path.getOrDefault("subscriptionId")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "subscriptionId", valid_564376
  var valid_564377 = path.getOrDefault("groupName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "groupName", valid_564377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564378 = query.getOrDefault("api-version")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "api-version", valid_564378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564379: Call_ServicesStart_564372; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action starts the service and the service can be used for data migration.
  ## 
  let valid = call_564379.validator(path, query, header, formData, body)
  let scheme = call_564379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564379.url(scheme.get, call_564379.host, call_564379.base,
                         call_564379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564379, url, valid)

proc call*(call_564380: Call_ServicesStart_564372; serviceName: string;
          apiVersion: string; subscriptionId: string; groupName: string): Recallable =
  ## servicesStart
  ## The services resource is the top-level resource that represents the Data Migration Service. This action starts the service and the service can be used for data migration.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564381 = newJObject()
  var query_564382 = newJObject()
  add(path_564381, "serviceName", newJString(serviceName))
  add(query_564382, "api-version", newJString(apiVersion))
  add(path_564381, "subscriptionId", newJString(subscriptionId))
  add(path_564381, "groupName", newJString(groupName))
  result = call_564380.call(path_564381, query_564382, nil, nil, nil)

var servicesStart* = Call_ServicesStart_564372(name: "servicesStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/start",
    validator: validate_ServicesStart_564373, base: "", url: url_ServicesStart_564374,
    schemes: {Scheme.Https})
type
  Call_ServicesStop_564383 = ref object of OpenApiRestCall_563555
proc url_ServicesStop_564385(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesStop_564384(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action stops the service and the service cannot be used for data migration. The service owner won't be billed when the service is stopped.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564386 = path.getOrDefault("serviceName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "serviceName", valid_564386
  var valid_564387 = path.getOrDefault("subscriptionId")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "subscriptionId", valid_564387
  var valid_564388 = path.getOrDefault("groupName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "groupName", valid_564388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564389 = query.getOrDefault("api-version")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "api-version", valid_564389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564390: Call_ServicesStop_564383; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action stops the service and the service cannot be used for data migration. The service owner won't be billed when the service is stopped.
  ## 
  let valid = call_564390.validator(path, query, header, formData, body)
  let scheme = call_564390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564390.url(scheme.get, call_564390.host, call_564390.base,
                         call_564390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564390, url, valid)

proc call*(call_564391: Call_ServicesStop_564383; serviceName: string;
          apiVersion: string; subscriptionId: string; groupName: string): Recallable =
  ## servicesStop
  ## The services resource is the top-level resource that represents the Data Migration Service. This action stops the service and the service cannot be used for data migration. The service owner won't be billed when the service is stopped.
  ##   serviceName: string (required)
  ##              : Name of the service
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_564392 = newJObject()
  var query_564393 = newJObject()
  add(path_564392, "serviceName", newJString(serviceName))
  add(query_564393, "api-version", newJString(apiVersion))
  add(path_564392, "subscriptionId", newJString(subscriptionId))
  add(path_564392, "groupName", newJString(groupName))
  result = call_564391.call(path_564392, query_564393, nil, nil, nil)

var servicesStop* = Call_ServicesStop_564383(name: "servicesStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/stop",
    validator: validate_ServicesStop_564384, base: "", url: url_ServicesStop_564385,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
