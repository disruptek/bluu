
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: KustoManagementClient
## version: 2019-05-15
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
  macServiceName = "azure-kusto"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists available operations for the Microsoft.Kusto provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the Microsoft.Kusto provider.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_OperationsList_563778; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the Microsoft.Kusto provider.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Kusto/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_ClustersList_564076 = ref object of OpenApiRestCall_563556
proc url_ClustersList_564078(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersList_564077(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Kusto clusters within a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564093 = path.getOrDefault("subscriptionId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "subscriptionId", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564095: Call_ClustersList_564076; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Kusto clusters within a subscription.
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_ClustersList_564076; apiVersion: string;
          subscriptionId: string): Recallable =
  ## clustersList
  ## Lists all Kusto clusters within a subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564097 = newJObject()
  var query_564098 = newJObject()
  add(query_564098, "api-version", newJString(apiVersion))
  add(path_564097, "subscriptionId", newJString(subscriptionId))
  result = call_564096.call(path_564097, query_564098, nil, nil, nil)

var clustersList* = Call_ClustersList_564076(name: "clustersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Kusto/clusters",
    validator: validate_ClustersList_564077, base: "", url: url_ClustersList_564078,
    schemes: {Scheme.Https})
type
  Call_ClustersCheckNameAvailability_564099 = ref object of OpenApiRestCall_563556
proc url_ClustersCheckNameAvailability_564101(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersCheckNameAvailability_564100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the cluster name is valid and is not already in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Azure location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  var valid_564103 = path.getOrDefault("location")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "location", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   clusterName: JObject (required)
  ##              : The name of the cluster.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564106: Call_ClustersCheckNameAvailability_564099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the cluster name is valid and is not already in use.
  ## 
  let valid = call_564106.validator(path, query, header, formData, body)
  let scheme = call_564106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564106.url(scheme.get, call_564106.host, call_564106.base,
                         call_564106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564106, url, valid)

proc call*(call_564107: Call_ClustersCheckNameAvailability_564099;
          apiVersion: string; subscriptionId: string; clusterName: JsonNode;
          location: string): Recallable =
  ## clustersCheckNameAvailability
  ## Checks that the cluster name is valid and is not already in use.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   clusterName: JObject (required)
  ##              : The name of the cluster.
  ##   location: string (required)
  ##           : Azure location.
  var path_564108 = newJObject()
  var query_564109 = newJObject()
  var body_564110 = newJObject()
  add(query_564109, "api-version", newJString(apiVersion))
  add(path_564108, "subscriptionId", newJString(subscriptionId))
  if clusterName != nil:
    body_564110 = clusterName
  add(path_564108, "location", newJString(location))
  result = call_564107.call(path_564108, query_564109, nil, nil, body_564110)

var clustersCheckNameAvailability* = Call_ClustersCheckNameAvailability_564099(
    name: "clustersCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Kusto/locations/{location}/checkNameAvailability",
    validator: validate_ClustersCheckNameAvailability_564100, base: "",
    url: url_ClustersCheckNameAvailability_564101, schemes: {Scheme.Https})
type
  Call_ClustersListSkus_564111 = ref object of OpenApiRestCall_563556
proc url_ClustersListSkus_564113(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersListSkus_564112(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists eligible SKUs for Kusto resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client API Version.
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

proc call*(call_564116: Call_ClustersListSkus_564111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists eligible SKUs for Kusto resource provider.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_ClustersListSkus_564111; apiVersion: string;
          subscriptionId: string): Recallable =
  ## clustersListSkus
  ## Lists eligible SKUs for Kusto resource provider.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var clustersListSkus* = Call_ClustersListSkus_564111(name: "clustersListSkus",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers/Microsoft.Kusto/skus",
    validator: validate_ClustersListSkus_564112, base: "",
    url: url_ClustersListSkus_564113, schemes: {Scheme.Https})
type
  Call_ClustersListByResourceGroup_564120 = ref object of OpenApiRestCall_563556
proc url_ClustersListByResourceGroup_564122(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersListByResourceGroup_564121(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Kusto clusters within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  var valid_564124 = path.getOrDefault("resourceGroupName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "resourceGroupName", valid_564124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564125 = query.getOrDefault("api-version")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "api-version", valid_564125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564126: Call_ClustersListByResourceGroup_564120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Kusto clusters within a resource group.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_ClustersListByResourceGroup_564120;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## clustersListByResourceGroup
  ## Lists all Kusto clusters within a resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  add(query_564129, "api-version", newJString(apiVersion))
  add(path_564128, "subscriptionId", newJString(subscriptionId))
  add(path_564128, "resourceGroupName", newJString(resourceGroupName))
  result = call_564127.call(path_564128, query_564129, nil, nil, nil)

var clustersListByResourceGroup* = Call_ClustersListByResourceGroup_564120(
    name: "clustersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters",
    validator: validate_ClustersListByResourceGroup_564121, base: "",
    url: url_ClustersListByResourceGroup_564122, schemes: {Scheme.Https})
type
  Call_ClustersCreateOrUpdate_564141 = ref object of OpenApiRestCall_563556
proc url_ClustersCreateOrUpdate_564143(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersCreateOrUpdate_564142(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564161 = path.getOrDefault("clusterName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "clusterName", valid_564161
  var valid_564162 = path.getOrDefault("subscriptionId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "subscriptionId", valid_564162
  var valid_564163 = path.getOrDefault("resourceGroupName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "resourceGroupName", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Kusto cluster parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564166: Call_ClustersCreateOrUpdate_564141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Kusto cluster.
  ## 
  let valid = call_564166.validator(path, query, header, formData, body)
  let scheme = call_564166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564166.url(scheme.get, call_564166.host, call_564166.base,
                         call_564166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564166, url, valid)

proc call*(call_564167: Call_ClustersCreateOrUpdate_564141; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## clustersCreateOrUpdate
  ## Create or update a Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   parameters: JObject (required)
  ##             : The Kusto cluster parameters supplied to the CreateOrUpdate operation.
  var path_564168 = newJObject()
  var query_564169 = newJObject()
  var body_564170 = newJObject()
  add(path_564168, "clusterName", newJString(clusterName))
  add(query_564169, "api-version", newJString(apiVersion))
  add(path_564168, "subscriptionId", newJString(subscriptionId))
  add(path_564168, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564170 = parameters
  result = call_564167.call(path_564168, query_564169, nil, nil, body_564170)

var clustersCreateOrUpdate* = Call_ClustersCreateOrUpdate_564141(
    name: "clustersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}",
    validator: validate_ClustersCreateOrUpdate_564142, base: "",
    url: url_ClustersCreateOrUpdate_564143, schemes: {Scheme.Https})
type
  Call_ClustersGet_564130 = ref object of OpenApiRestCall_563556
proc url_ClustersGet_564132(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersGet_564131(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564133 = path.getOrDefault("clusterName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "clusterName", valid_564133
  var valid_564134 = path.getOrDefault("subscriptionId")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "subscriptionId", valid_564134
  var valid_564135 = path.getOrDefault("resourceGroupName")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "resourceGroupName", valid_564135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564136 = query.getOrDefault("api-version")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "api-version", valid_564136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564137: Call_ClustersGet_564130; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Kusto cluster.
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_ClustersGet_564130; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## clustersGet
  ## Gets a Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  add(path_564139, "clusterName", newJString(clusterName))
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "subscriptionId", newJString(subscriptionId))
  add(path_564139, "resourceGroupName", newJString(resourceGroupName))
  result = call_564138.call(path_564139, query_564140, nil, nil, nil)

var clustersGet* = Call_ClustersGet_564130(name: "clustersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}",
                                        validator: validate_ClustersGet_564131,
                                        base: "", url: url_ClustersGet_564132,
                                        schemes: {Scheme.Https})
type
  Call_ClustersUpdate_564182 = ref object of OpenApiRestCall_563556
proc url_ClustersUpdate_564184(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersUpdate_564183(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update a Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564185 = path.getOrDefault("clusterName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "clusterName", valid_564185
  var valid_564186 = path.getOrDefault("subscriptionId")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "subscriptionId", valid_564186
  var valid_564187 = path.getOrDefault("resourceGroupName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "resourceGroupName", valid_564187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564188 = query.getOrDefault("api-version")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "api-version", valid_564188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Kusto cluster parameters supplied to the Update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564190: Call_ClustersUpdate_564182; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Kusto cluster.
  ## 
  let valid = call_564190.validator(path, query, header, formData, body)
  let scheme = call_564190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564190.url(scheme.get, call_564190.host, call_564190.base,
                         call_564190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564190, url, valid)

proc call*(call_564191: Call_ClustersUpdate_564182; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## clustersUpdate
  ## Update a Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   parameters: JObject (required)
  ##             : The Kusto cluster parameters supplied to the Update operation.
  var path_564192 = newJObject()
  var query_564193 = newJObject()
  var body_564194 = newJObject()
  add(path_564192, "clusterName", newJString(clusterName))
  add(query_564193, "api-version", newJString(apiVersion))
  add(path_564192, "subscriptionId", newJString(subscriptionId))
  add(path_564192, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564194 = parameters
  result = call_564191.call(path_564192, query_564193, nil, nil, body_564194)

var clustersUpdate* = Call_ClustersUpdate_564182(name: "clustersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}",
    validator: validate_ClustersUpdate_564183, base: "", url: url_ClustersUpdate_564184,
    schemes: {Scheme.Https})
type
  Call_ClustersDelete_564171 = ref object of OpenApiRestCall_563556
proc url_ClustersDelete_564173(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersDelete_564172(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564174 = path.getOrDefault("clusterName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "clusterName", valid_564174
  var valid_564175 = path.getOrDefault("subscriptionId")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "subscriptionId", valid_564175
  var valid_564176 = path.getOrDefault("resourceGroupName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "resourceGroupName", valid_564176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564177 = query.getOrDefault("api-version")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "api-version", valid_564177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564178: Call_ClustersDelete_564171; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Kusto cluster.
  ## 
  let valid = call_564178.validator(path, query, header, formData, body)
  let scheme = call_564178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564178.url(scheme.get, call_564178.host, call_564178.base,
                         call_564178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564178, url, valid)

proc call*(call_564179: Call_ClustersDelete_564171; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## clustersDelete
  ## Deletes a Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564180 = newJObject()
  var query_564181 = newJObject()
  add(path_564180, "clusterName", newJString(clusterName))
  add(query_564181, "api-version", newJString(apiVersion))
  add(path_564180, "subscriptionId", newJString(subscriptionId))
  add(path_564180, "resourceGroupName", newJString(resourceGroupName))
  result = call_564179.call(path_564180, query_564181, nil, nil, nil)

var clustersDelete* = Call_ClustersDelete_564171(name: "clustersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}",
    validator: validate_ClustersDelete_564172, base: "", url: url_ClustersDelete_564173,
    schemes: {Scheme.Https})
type
  Call_DatabasesCheckNameAvailability_564195 = ref object of OpenApiRestCall_563556
proc url_DatabasesCheckNameAvailability_564197(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesCheckNameAvailability_564196(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the database name is valid and is not already in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564198 = path.getOrDefault("clusterName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "clusterName", valid_564198
  var valid_564199 = path.getOrDefault("subscriptionId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "subscriptionId", valid_564199
  var valid_564200 = path.getOrDefault("resourceGroupName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "resourceGroupName", valid_564200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564201 = query.getOrDefault("api-version")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "api-version", valid_564201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   databaseName: JObject (required)
  ##               : The name of the database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564203: Call_DatabasesCheckNameAvailability_564195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the database name is valid and is not already in use.
  ## 
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_DatabasesCheckNameAvailability_564195;
          clusterName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; databaseName: JsonNode): Recallable =
  ## databasesCheckNameAvailability
  ## Checks that the database name is valid and is not already in use.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   databaseName: JObject (required)
  ##               : The name of the database.
  var path_564205 = newJObject()
  var query_564206 = newJObject()
  var body_564207 = newJObject()
  add(path_564205, "clusterName", newJString(clusterName))
  add(query_564206, "api-version", newJString(apiVersion))
  add(path_564205, "subscriptionId", newJString(subscriptionId))
  add(path_564205, "resourceGroupName", newJString(resourceGroupName))
  if databaseName != nil:
    body_564207 = databaseName
  result = call_564204.call(path_564205, query_564206, nil, nil, body_564207)

var databasesCheckNameAvailability* = Call_DatabasesCheckNameAvailability_564195(
    name: "databasesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/checkNameAvailability",
    validator: validate_DatabasesCheckNameAvailability_564196, base: "",
    url: url_DatabasesCheckNameAvailability_564197, schemes: {Scheme.Https})
type
  Call_DatabasesListByCluster_564208 = ref object of OpenApiRestCall_563556
proc url_DatabasesListByCluster_564210(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesListByCluster_564209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of databases of the given Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564211 = path.getOrDefault("clusterName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "clusterName", valid_564211
  var valid_564212 = path.getOrDefault("subscriptionId")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "subscriptionId", valid_564212
  var valid_564213 = path.getOrDefault("resourceGroupName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "resourceGroupName", valid_564213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "api-version", valid_564214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564215: Call_DatabasesListByCluster_564208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of databases of the given Kusto cluster.
  ## 
  let valid = call_564215.validator(path, query, header, formData, body)
  let scheme = call_564215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564215.url(scheme.get, call_564215.host, call_564215.base,
                         call_564215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564215, url, valid)

proc call*(call_564216: Call_DatabasesListByCluster_564208; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## databasesListByCluster
  ## Returns the list of databases of the given Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564217 = newJObject()
  var query_564218 = newJObject()
  add(path_564217, "clusterName", newJString(clusterName))
  add(query_564218, "api-version", newJString(apiVersion))
  add(path_564217, "subscriptionId", newJString(subscriptionId))
  add(path_564217, "resourceGroupName", newJString(resourceGroupName))
  result = call_564216.call(path_564217, query_564218, nil, nil, nil)

var databasesListByCluster* = Call_DatabasesListByCluster_564208(
    name: "databasesListByCluster", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases",
    validator: validate_DatabasesListByCluster_564209, base: "",
    url: url_DatabasesListByCluster_564210, schemes: {Scheme.Https})
type
  Call_DatabasesCreateOrUpdate_564231 = ref object of OpenApiRestCall_563556
proc url_DatabasesCreateOrUpdate_564233(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesCreateOrUpdate_564232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564234 = path.getOrDefault("clusterName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "clusterName", valid_564234
  var valid_564235 = path.getOrDefault("subscriptionId")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "subscriptionId", valid_564235
  var valid_564236 = path.getOrDefault("databaseName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "databaseName", valid_564236
  var valid_564237 = path.getOrDefault("resourceGroupName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "resourceGroupName", valid_564237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564238 = query.getOrDefault("api-version")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "api-version", valid_564238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The database parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564240: Call_DatabasesCreateOrUpdate_564231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a database.
  ## 
  let valid = call_564240.validator(path, query, header, formData, body)
  let scheme = call_564240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564240.url(scheme.get, call_564240.host, call_564240.base,
                         call_564240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564240, url, valid)

proc call*(call_564241: Call_DatabasesCreateOrUpdate_564231; clusterName: string;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## databasesCreateOrUpdate
  ## Creates or updates a database.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   parameters: JObject (required)
  ##             : The database parameters supplied to the CreateOrUpdate operation.
  var path_564242 = newJObject()
  var query_564243 = newJObject()
  var body_564244 = newJObject()
  add(path_564242, "clusterName", newJString(clusterName))
  add(query_564243, "api-version", newJString(apiVersion))
  add(path_564242, "subscriptionId", newJString(subscriptionId))
  add(path_564242, "databaseName", newJString(databaseName))
  add(path_564242, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564244 = parameters
  result = call_564241.call(path_564242, query_564243, nil, nil, body_564244)

var databasesCreateOrUpdate* = Call_DatabasesCreateOrUpdate_564231(
    name: "databasesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}",
    validator: validate_DatabasesCreateOrUpdate_564232, base: "",
    url: url_DatabasesCreateOrUpdate_564233, schemes: {Scheme.Https})
type
  Call_DatabasesGet_564219 = ref object of OpenApiRestCall_563556
proc url_DatabasesGet_564221(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesGet_564220(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564222 = path.getOrDefault("clusterName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "clusterName", valid_564222
  var valid_564223 = path.getOrDefault("subscriptionId")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "subscriptionId", valid_564223
  var valid_564224 = path.getOrDefault("databaseName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "databaseName", valid_564224
  var valid_564225 = path.getOrDefault("resourceGroupName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "resourceGroupName", valid_564225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_DatabasesGet_564219; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a database.
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_DatabasesGet_564219; clusterName: string;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string): Recallable =
  ## databasesGet
  ## Returns a database.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564229 = newJObject()
  var query_564230 = newJObject()
  add(path_564229, "clusterName", newJString(clusterName))
  add(query_564230, "api-version", newJString(apiVersion))
  add(path_564229, "subscriptionId", newJString(subscriptionId))
  add(path_564229, "databaseName", newJString(databaseName))
  add(path_564229, "resourceGroupName", newJString(resourceGroupName))
  result = call_564228.call(path_564229, query_564230, nil, nil, nil)

var databasesGet* = Call_DatabasesGet_564219(name: "databasesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}",
    validator: validate_DatabasesGet_564220, base: "", url: url_DatabasesGet_564221,
    schemes: {Scheme.Https})
type
  Call_DatabasesUpdate_564257 = ref object of OpenApiRestCall_563556
proc url_DatabasesUpdate_564259(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesUpdate_564258(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564260 = path.getOrDefault("clusterName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "clusterName", valid_564260
  var valid_564261 = path.getOrDefault("subscriptionId")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "subscriptionId", valid_564261
  var valid_564262 = path.getOrDefault("databaseName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "databaseName", valid_564262
  var valid_564263 = path.getOrDefault("resourceGroupName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "resourceGroupName", valid_564263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564264 = query.getOrDefault("api-version")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "api-version", valid_564264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The database parameters supplied to the Update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564266: Call_DatabasesUpdate_564257; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a database.
  ## 
  let valid = call_564266.validator(path, query, header, formData, body)
  let scheme = call_564266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564266.url(scheme.get, call_564266.host, call_564266.base,
                         call_564266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564266, url, valid)

proc call*(call_564267: Call_DatabasesUpdate_564257; clusterName: string;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## databasesUpdate
  ## Updates a database.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   parameters: JObject (required)
  ##             : The database parameters supplied to the Update operation.
  var path_564268 = newJObject()
  var query_564269 = newJObject()
  var body_564270 = newJObject()
  add(path_564268, "clusterName", newJString(clusterName))
  add(query_564269, "api-version", newJString(apiVersion))
  add(path_564268, "subscriptionId", newJString(subscriptionId))
  add(path_564268, "databaseName", newJString(databaseName))
  add(path_564268, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564270 = parameters
  result = call_564267.call(path_564268, query_564269, nil, nil, body_564270)

var databasesUpdate* = Call_DatabasesUpdate_564257(name: "databasesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}",
    validator: validate_DatabasesUpdate_564258, base: "", url: url_DatabasesUpdate_564259,
    schemes: {Scheme.Https})
type
  Call_DatabasesDelete_564245 = ref object of OpenApiRestCall_563556
proc url_DatabasesDelete_564247(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesDelete_564246(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the database with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564248 = path.getOrDefault("clusterName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "clusterName", valid_564248
  var valid_564249 = path.getOrDefault("subscriptionId")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "subscriptionId", valid_564249
  var valid_564250 = path.getOrDefault("databaseName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "databaseName", valid_564250
  var valid_564251 = path.getOrDefault("resourceGroupName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "resourceGroupName", valid_564251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564252 = query.getOrDefault("api-version")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "api-version", valid_564252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564253: Call_DatabasesDelete_564245; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the database with the given name.
  ## 
  let valid = call_564253.validator(path, query, header, formData, body)
  let scheme = call_564253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564253.url(scheme.get, call_564253.host, call_564253.base,
                         call_564253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564253, url, valid)

proc call*(call_564254: Call_DatabasesDelete_564245; clusterName: string;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string): Recallable =
  ## databasesDelete
  ## Deletes the database with the given name.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564255 = newJObject()
  var query_564256 = newJObject()
  add(path_564255, "clusterName", newJString(clusterName))
  add(query_564256, "api-version", newJString(apiVersion))
  add(path_564255, "subscriptionId", newJString(subscriptionId))
  add(path_564255, "databaseName", newJString(databaseName))
  add(path_564255, "resourceGroupName", newJString(resourceGroupName))
  result = call_564254.call(path_564255, query_564256, nil, nil, nil)

var databasesDelete* = Call_DatabasesDelete_564245(name: "databasesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}",
    validator: validate_DatabasesDelete_564246, base: "", url: url_DatabasesDelete_564247,
    schemes: {Scheme.Https})
type
  Call_DatabasesAddPrincipals_564271 = ref object of OpenApiRestCall_563556
proc url_DatabasesAddPrincipals_564273(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/addPrincipals")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesAddPrincipals_564272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add Database principals permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564274 = path.getOrDefault("clusterName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "clusterName", valid_564274
  var valid_564275 = path.getOrDefault("subscriptionId")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "subscriptionId", valid_564275
  var valid_564276 = path.getOrDefault("databaseName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "databaseName", valid_564276
  var valid_564277 = path.getOrDefault("resourceGroupName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "resourceGroupName", valid_564277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564278 = query.getOrDefault("api-version")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "api-version", valid_564278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   databasePrincipalsToAdd: JObject (required)
  ##                          : List of database principals to add.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564280: Call_DatabasesAddPrincipals_564271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add Database principals permissions.
  ## 
  let valid = call_564280.validator(path, query, header, formData, body)
  let scheme = call_564280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564280.url(scheme.get, call_564280.host, call_564280.base,
                         call_564280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564280, url, valid)

proc call*(call_564281: Call_DatabasesAddPrincipals_564271; clusterName: string;
          apiVersion: string; subscriptionId: string; databaseName: string;
          databasePrincipalsToAdd: JsonNode; resourceGroupName: string): Recallable =
  ## databasesAddPrincipals
  ## Add Database principals permissions.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   databasePrincipalsToAdd: JObject (required)
  ##                          : List of database principals to add.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564282 = newJObject()
  var query_564283 = newJObject()
  var body_564284 = newJObject()
  add(path_564282, "clusterName", newJString(clusterName))
  add(query_564283, "api-version", newJString(apiVersion))
  add(path_564282, "subscriptionId", newJString(subscriptionId))
  add(path_564282, "databaseName", newJString(databaseName))
  if databasePrincipalsToAdd != nil:
    body_564284 = databasePrincipalsToAdd
  add(path_564282, "resourceGroupName", newJString(resourceGroupName))
  result = call_564281.call(path_564282, query_564283, nil, nil, body_564284)

var databasesAddPrincipals* = Call_DatabasesAddPrincipals_564271(
    name: "databasesAddPrincipals", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/addPrincipals",
    validator: validate_DatabasesAddPrincipals_564272, base: "",
    url: url_DatabasesAddPrincipals_564273, schemes: {Scheme.Https})
type
  Call_DataConnectionsCheckNameAvailability_564285 = ref object of OpenApiRestCall_563556
proc url_DataConnectionsCheckNameAvailability_564287(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectionsCheckNameAvailability_564286(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the data connection name is valid and is not already in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564288 = path.getOrDefault("clusterName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "clusterName", valid_564288
  var valid_564289 = path.getOrDefault("subscriptionId")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "subscriptionId", valid_564289
  var valid_564290 = path.getOrDefault("databaseName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "databaseName", valid_564290
  var valid_564291 = path.getOrDefault("resourceGroupName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "resourceGroupName", valid_564291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564292 = query.getOrDefault("api-version")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "api-version", valid_564292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataConnectionName: JObject (required)
  ##                     : The name of the data connection.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564294: Call_DataConnectionsCheckNameAvailability_564285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that the data connection name is valid and is not already in use.
  ## 
  let valid = call_564294.validator(path, query, header, formData, body)
  let scheme = call_564294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564294.url(scheme.get, call_564294.host, call_564294.base,
                         call_564294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564294, url, valid)

proc call*(call_564295: Call_DataConnectionsCheckNameAvailability_564285;
          clusterName: string; dataConnectionName: JsonNode; apiVersion: string;
          subscriptionId: string; databaseName: string; resourceGroupName: string): Recallable =
  ## dataConnectionsCheckNameAvailability
  ## Checks that the data connection name is valid and is not already in use.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   dataConnectionName: JObject (required)
  ##                     : The name of the data connection.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564296 = newJObject()
  var query_564297 = newJObject()
  var body_564298 = newJObject()
  add(path_564296, "clusterName", newJString(clusterName))
  if dataConnectionName != nil:
    body_564298 = dataConnectionName
  add(query_564297, "api-version", newJString(apiVersion))
  add(path_564296, "subscriptionId", newJString(subscriptionId))
  add(path_564296, "databaseName", newJString(databaseName))
  add(path_564296, "resourceGroupName", newJString(resourceGroupName))
  result = call_564295.call(path_564296, query_564297, nil, nil, body_564298)

var dataConnectionsCheckNameAvailability* = Call_DataConnectionsCheckNameAvailability_564285(
    name: "dataConnectionsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/checkNameAvailability",
    validator: validate_DataConnectionsCheckNameAvailability_564286, base: "",
    url: url_DataConnectionsCheckNameAvailability_564287, schemes: {Scheme.Https})
type
  Call_DataConnectionsDataConnectionValidation_564299 = ref object of OpenApiRestCall_563556
proc url_DataConnectionsDataConnectionValidation_564301(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/dataConnectionValidation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectionsDataConnectionValidation_564300(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the data connection parameters are valid.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564302 = path.getOrDefault("clusterName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "clusterName", valid_564302
  var valid_564303 = path.getOrDefault("subscriptionId")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "subscriptionId", valid_564303
  var valid_564304 = path.getOrDefault("databaseName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "databaseName", valid_564304
  var valid_564305 = path.getOrDefault("resourceGroupName")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "resourceGroupName", valid_564305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564306 = query.getOrDefault("api-version")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "api-version", valid_564306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The data connection parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564308: Call_DataConnectionsDataConnectionValidation_564299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that the data connection parameters are valid.
  ## 
  let valid = call_564308.validator(path, query, header, formData, body)
  let scheme = call_564308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564308.url(scheme.get, call_564308.host, call_564308.base,
                         call_564308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564308, url, valid)

proc call*(call_564309: Call_DataConnectionsDataConnectionValidation_564299;
          clusterName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## dataConnectionsDataConnectionValidation
  ## Checks that the data connection parameters are valid.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   parameters: JObject (required)
  ##             : The data connection parameters supplied to the CreateOrUpdate operation.
  var path_564310 = newJObject()
  var query_564311 = newJObject()
  var body_564312 = newJObject()
  add(path_564310, "clusterName", newJString(clusterName))
  add(query_564311, "api-version", newJString(apiVersion))
  add(path_564310, "subscriptionId", newJString(subscriptionId))
  add(path_564310, "databaseName", newJString(databaseName))
  add(path_564310, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564312 = parameters
  result = call_564309.call(path_564310, query_564311, nil, nil, body_564312)

var dataConnectionsDataConnectionValidation* = Call_DataConnectionsDataConnectionValidation_564299(
    name: "dataConnectionsDataConnectionValidation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/dataConnectionValidation",
    validator: validate_DataConnectionsDataConnectionValidation_564300, base: "",
    url: url_DataConnectionsDataConnectionValidation_564301,
    schemes: {Scheme.Https})
type
  Call_DataConnectionsListByDatabase_564313 = ref object of OpenApiRestCall_563556
proc url_DataConnectionsListByDatabase_564315(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/dataConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectionsListByDatabase_564314(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of data connections of the given Kusto database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564316 = path.getOrDefault("clusterName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "clusterName", valid_564316
  var valid_564317 = path.getOrDefault("subscriptionId")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "subscriptionId", valid_564317
  var valid_564318 = path.getOrDefault("databaseName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "databaseName", valid_564318
  var valid_564319 = path.getOrDefault("resourceGroupName")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "resourceGroupName", valid_564319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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

proc call*(call_564321: Call_DataConnectionsListByDatabase_564313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of data connections of the given Kusto database.
  ## 
  let valid = call_564321.validator(path, query, header, formData, body)
  let scheme = call_564321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564321.url(scheme.get, call_564321.host, call_564321.base,
                         call_564321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564321, url, valid)

proc call*(call_564322: Call_DataConnectionsListByDatabase_564313;
          clusterName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string): Recallable =
  ## dataConnectionsListByDatabase
  ## Returns the list of data connections of the given Kusto database.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564323 = newJObject()
  var query_564324 = newJObject()
  add(path_564323, "clusterName", newJString(clusterName))
  add(query_564324, "api-version", newJString(apiVersion))
  add(path_564323, "subscriptionId", newJString(subscriptionId))
  add(path_564323, "databaseName", newJString(databaseName))
  add(path_564323, "resourceGroupName", newJString(resourceGroupName))
  result = call_564322.call(path_564323, query_564324, nil, nil, nil)

var dataConnectionsListByDatabase* = Call_DataConnectionsListByDatabase_564313(
    name: "dataConnectionsListByDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/dataConnections",
    validator: validate_DataConnectionsListByDatabase_564314, base: "",
    url: url_DataConnectionsListByDatabase_564315, schemes: {Scheme.Https})
type
  Call_DataConnectionsCreateOrUpdate_564338 = ref object of OpenApiRestCall_563556
proc url_DataConnectionsCreateOrUpdate_564340(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "dataConnectionName" in path,
        "`dataConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/dataConnections/"),
               (kind: VariableSegment, value: "dataConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectionsCreateOrUpdate_564339(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a data connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   dataConnectionName: JString (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564341 = path.getOrDefault("clusterName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "clusterName", valid_564341
  var valid_564342 = path.getOrDefault("subscriptionId")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "subscriptionId", valid_564342
  var valid_564343 = path.getOrDefault("databaseName")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "databaseName", valid_564343
  var valid_564344 = path.getOrDefault("dataConnectionName")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "dataConnectionName", valid_564344
  var valid_564345 = path.getOrDefault("resourceGroupName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "resourceGroupName", valid_564345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564346 = query.getOrDefault("api-version")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "api-version", valid_564346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The data connection parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564348: Call_DataConnectionsCreateOrUpdate_564338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a data connection.
  ## 
  let valid = call_564348.validator(path, query, header, formData, body)
  let scheme = call_564348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564348.url(scheme.get, call_564348.host, call_564348.base,
                         call_564348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564348, url, valid)

proc call*(call_564349: Call_DataConnectionsCreateOrUpdate_564338;
          clusterName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; dataConnectionName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## dataConnectionsCreateOrUpdate
  ## Creates or updates a data connection.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   dataConnectionName: string (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   parameters: JObject (required)
  ##             : The data connection parameters supplied to the CreateOrUpdate operation.
  var path_564350 = newJObject()
  var query_564351 = newJObject()
  var body_564352 = newJObject()
  add(path_564350, "clusterName", newJString(clusterName))
  add(query_564351, "api-version", newJString(apiVersion))
  add(path_564350, "subscriptionId", newJString(subscriptionId))
  add(path_564350, "databaseName", newJString(databaseName))
  add(path_564350, "dataConnectionName", newJString(dataConnectionName))
  add(path_564350, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564352 = parameters
  result = call_564349.call(path_564350, query_564351, nil, nil, body_564352)

var dataConnectionsCreateOrUpdate* = Call_DataConnectionsCreateOrUpdate_564338(
    name: "dataConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/dataConnections/{dataConnectionName}",
    validator: validate_DataConnectionsCreateOrUpdate_564339, base: "",
    url: url_DataConnectionsCreateOrUpdate_564340, schemes: {Scheme.Https})
type
  Call_DataConnectionsGet_564325 = ref object of OpenApiRestCall_563556
proc url_DataConnectionsGet_564327(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "dataConnectionName" in path,
        "`dataConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/dataConnections/"),
               (kind: VariableSegment, value: "dataConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectionsGet_564326(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns a data connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   dataConnectionName: JString (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564328 = path.getOrDefault("clusterName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "clusterName", valid_564328
  var valid_564329 = path.getOrDefault("subscriptionId")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "subscriptionId", valid_564329
  var valid_564330 = path.getOrDefault("databaseName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "databaseName", valid_564330
  var valid_564331 = path.getOrDefault("dataConnectionName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "dataConnectionName", valid_564331
  var valid_564332 = path.getOrDefault("resourceGroupName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "resourceGroupName", valid_564332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564333 = query.getOrDefault("api-version")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "api-version", valid_564333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564334: Call_DataConnectionsGet_564325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a data connection.
  ## 
  let valid = call_564334.validator(path, query, header, formData, body)
  let scheme = call_564334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564334.url(scheme.get, call_564334.host, call_564334.base,
                         call_564334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564334, url, valid)

proc call*(call_564335: Call_DataConnectionsGet_564325; clusterName: string;
          apiVersion: string; subscriptionId: string; databaseName: string;
          dataConnectionName: string; resourceGroupName: string): Recallable =
  ## dataConnectionsGet
  ## Returns a data connection.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   dataConnectionName: string (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564336 = newJObject()
  var query_564337 = newJObject()
  add(path_564336, "clusterName", newJString(clusterName))
  add(query_564337, "api-version", newJString(apiVersion))
  add(path_564336, "subscriptionId", newJString(subscriptionId))
  add(path_564336, "databaseName", newJString(databaseName))
  add(path_564336, "dataConnectionName", newJString(dataConnectionName))
  add(path_564336, "resourceGroupName", newJString(resourceGroupName))
  result = call_564335.call(path_564336, query_564337, nil, nil, nil)

var dataConnectionsGet* = Call_DataConnectionsGet_564325(
    name: "dataConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/dataConnections/{dataConnectionName}",
    validator: validate_DataConnectionsGet_564326, base: "",
    url: url_DataConnectionsGet_564327, schemes: {Scheme.Https})
type
  Call_DataConnectionsUpdate_564366 = ref object of OpenApiRestCall_563556
proc url_DataConnectionsUpdate_564368(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "dataConnectionName" in path,
        "`dataConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/dataConnections/"),
               (kind: VariableSegment, value: "dataConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectionsUpdate_564367(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a data connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   dataConnectionName: JString (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564369 = path.getOrDefault("clusterName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "clusterName", valid_564369
  var valid_564370 = path.getOrDefault("subscriptionId")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "subscriptionId", valid_564370
  var valid_564371 = path.getOrDefault("databaseName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "databaseName", valid_564371
  var valid_564372 = path.getOrDefault("dataConnectionName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "dataConnectionName", valid_564372
  var valid_564373 = path.getOrDefault("resourceGroupName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "resourceGroupName", valid_564373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564374 = query.getOrDefault("api-version")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "api-version", valid_564374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The data connection parameters supplied to the Update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564376: Call_DataConnectionsUpdate_564366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data connection.
  ## 
  let valid = call_564376.validator(path, query, header, formData, body)
  let scheme = call_564376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564376.url(scheme.get, call_564376.host, call_564376.base,
                         call_564376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564376, url, valid)

proc call*(call_564377: Call_DataConnectionsUpdate_564366; clusterName: string;
          apiVersion: string; subscriptionId: string; databaseName: string;
          dataConnectionName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## dataConnectionsUpdate
  ## Updates a data connection.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   dataConnectionName: string (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   parameters: JObject (required)
  ##             : The data connection parameters supplied to the Update operation.
  var path_564378 = newJObject()
  var query_564379 = newJObject()
  var body_564380 = newJObject()
  add(path_564378, "clusterName", newJString(clusterName))
  add(query_564379, "api-version", newJString(apiVersion))
  add(path_564378, "subscriptionId", newJString(subscriptionId))
  add(path_564378, "databaseName", newJString(databaseName))
  add(path_564378, "dataConnectionName", newJString(dataConnectionName))
  add(path_564378, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564380 = parameters
  result = call_564377.call(path_564378, query_564379, nil, nil, body_564380)

var dataConnectionsUpdate* = Call_DataConnectionsUpdate_564366(
    name: "dataConnectionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/dataConnections/{dataConnectionName}",
    validator: validate_DataConnectionsUpdate_564367, base: "",
    url: url_DataConnectionsUpdate_564368, schemes: {Scheme.Https})
type
  Call_DataConnectionsDelete_564353 = ref object of OpenApiRestCall_563556
proc url_DataConnectionsDelete_564355(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "dataConnectionName" in path,
        "`dataConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/dataConnections/"),
               (kind: VariableSegment, value: "dataConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectionsDelete_564354(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the data connection with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   dataConnectionName: JString (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564356 = path.getOrDefault("clusterName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "clusterName", valid_564356
  var valid_564357 = path.getOrDefault("subscriptionId")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "subscriptionId", valid_564357
  var valid_564358 = path.getOrDefault("databaseName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "databaseName", valid_564358
  var valid_564359 = path.getOrDefault("dataConnectionName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "dataConnectionName", valid_564359
  var valid_564360 = path.getOrDefault("resourceGroupName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "resourceGroupName", valid_564360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564361 = query.getOrDefault("api-version")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "api-version", valid_564361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564362: Call_DataConnectionsDelete_564353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the data connection with the given name.
  ## 
  let valid = call_564362.validator(path, query, header, formData, body)
  let scheme = call_564362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564362.url(scheme.get, call_564362.host, call_564362.base,
                         call_564362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564362, url, valid)

proc call*(call_564363: Call_DataConnectionsDelete_564353; clusterName: string;
          apiVersion: string; subscriptionId: string; databaseName: string;
          dataConnectionName: string; resourceGroupName: string): Recallable =
  ## dataConnectionsDelete
  ## Deletes the data connection with the given name.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   dataConnectionName: string (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564364 = newJObject()
  var query_564365 = newJObject()
  add(path_564364, "clusterName", newJString(clusterName))
  add(query_564365, "api-version", newJString(apiVersion))
  add(path_564364, "subscriptionId", newJString(subscriptionId))
  add(path_564364, "databaseName", newJString(databaseName))
  add(path_564364, "dataConnectionName", newJString(dataConnectionName))
  add(path_564364, "resourceGroupName", newJString(resourceGroupName))
  result = call_564363.call(path_564364, query_564365, nil, nil, nil)

var dataConnectionsDelete* = Call_DataConnectionsDelete_564353(
    name: "dataConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/dataConnections/{dataConnectionName}",
    validator: validate_DataConnectionsDelete_564354, base: "",
    url: url_DataConnectionsDelete_564355, schemes: {Scheme.Https})
type
  Call_DatabasesListPrincipals_564381 = ref object of OpenApiRestCall_563556
proc url_DatabasesListPrincipals_564383(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/listPrincipals")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesListPrincipals_564382(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of database principals of the given Kusto cluster and database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564384 = path.getOrDefault("clusterName")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "clusterName", valid_564384
  var valid_564385 = path.getOrDefault("subscriptionId")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "subscriptionId", valid_564385
  var valid_564386 = path.getOrDefault("databaseName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "databaseName", valid_564386
  var valid_564387 = path.getOrDefault("resourceGroupName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "resourceGroupName", valid_564387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564388 = query.getOrDefault("api-version")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "api-version", valid_564388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564389: Call_DatabasesListPrincipals_564381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of database principals of the given Kusto cluster and database.
  ## 
  let valid = call_564389.validator(path, query, header, formData, body)
  let scheme = call_564389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564389.url(scheme.get, call_564389.host, call_564389.base,
                         call_564389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564389, url, valid)

proc call*(call_564390: Call_DatabasesListPrincipals_564381; clusterName: string;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string): Recallable =
  ## databasesListPrincipals
  ## Returns a list of database principals of the given Kusto cluster and database.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564391 = newJObject()
  var query_564392 = newJObject()
  add(path_564391, "clusterName", newJString(clusterName))
  add(query_564392, "api-version", newJString(apiVersion))
  add(path_564391, "subscriptionId", newJString(subscriptionId))
  add(path_564391, "databaseName", newJString(databaseName))
  add(path_564391, "resourceGroupName", newJString(resourceGroupName))
  result = call_564390.call(path_564391, query_564392, nil, nil, nil)

var databasesListPrincipals* = Call_DatabasesListPrincipals_564381(
    name: "databasesListPrincipals", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/listPrincipals",
    validator: validate_DatabasesListPrincipals_564382, base: "",
    url: url_DatabasesListPrincipals_564383, schemes: {Scheme.Https})
type
  Call_DatabasesRemovePrincipals_564393 = ref object of OpenApiRestCall_563556
proc url_DatabasesRemovePrincipals_564395(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/removePrincipals")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesRemovePrincipals_564394(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove Database principals permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564396 = path.getOrDefault("clusterName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "clusterName", valid_564396
  var valid_564397 = path.getOrDefault("subscriptionId")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "subscriptionId", valid_564397
  var valid_564398 = path.getOrDefault("databaseName")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "databaseName", valid_564398
  var valid_564399 = path.getOrDefault("resourceGroupName")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "resourceGroupName", valid_564399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564400 = query.getOrDefault("api-version")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "api-version", valid_564400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   databasePrincipalsToRemove: JObject (required)
  ##                             : List of database principals to remove.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564402: Call_DatabasesRemovePrincipals_564393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove Database principals permissions.
  ## 
  let valid = call_564402.validator(path, query, header, formData, body)
  let scheme = call_564402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564402.url(scheme.get, call_564402.host, call_564402.base,
                         call_564402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564402, url, valid)

proc call*(call_564403: Call_DatabasesRemovePrincipals_564393; clusterName: string;
          apiVersion: string; subscriptionId: string; databaseName: string;
          databasePrincipalsToRemove: JsonNode; resourceGroupName: string): Recallable =
  ## databasesRemovePrincipals
  ## Remove Database principals permissions.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   databasePrincipalsToRemove: JObject (required)
  ##                             : List of database principals to remove.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564404 = newJObject()
  var query_564405 = newJObject()
  var body_564406 = newJObject()
  add(path_564404, "clusterName", newJString(clusterName))
  add(query_564405, "api-version", newJString(apiVersion))
  add(path_564404, "subscriptionId", newJString(subscriptionId))
  add(path_564404, "databaseName", newJString(databaseName))
  if databasePrincipalsToRemove != nil:
    body_564406 = databasePrincipalsToRemove
  add(path_564404, "resourceGroupName", newJString(resourceGroupName))
  result = call_564403.call(path_564404, query_564405, nil, nil, body_564406)

var databasesRemovePrincipals* = Call_DatabasesRemovePrincipals_564393(
    name: "databasesRemovePrincipals", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/removePrincipals",
    validator: validate_DatabasesRemovePrincipals_564394, base: "",
    url: url_DatabasesRemovePrincipals_564395, schemes: {Scheme.Https})
type
  Call_ClustersListSkusByResource_564407 = ref object of OpenApiRestCall_563556
proc url_ClustersListSkusByResource_564409(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersListSkusByResource_564408(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the SKUs available for the provided resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564410 = path.getOrDefault("clusterName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "clusterName", valid_564410
  var valid_564411 = path.getOrDefault("subscriptionId")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "subscriptionId", valid_564411
  var valid_564412 = path.getOrDefault("resourceGroupName")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "resourceGroupName", valid_564412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564413 = query.getOrDefault("api-version")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "api-version", valid_564413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564414: Call_ClustersListSkusByResource_564407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the SKUs available for the provided resource.
  ## 
  let valid = call_564414.validator(path, query, header, formData, body)
  let scheme = call_564414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564414.url(scheme.get, call_564414.host, call_564414.base,
                         call_564414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564414, url, valid)

proc call*(call_564415: Call_ClustersListSkusByResource_564407;
          clusterName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## clustersListSkusByResource
  ## Returns the SKUs available for the provided resource.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564416 = newJObject()
  var query_564417 = newJObject()
  add(path_564416, "clusterName", newJString(clusterName))
  add(query_564417, "api-version", newJString(apiVersion))
  add(path_564416, "subscriptionId", newJString(subscriptionId))
  add(path_564416, "resourceGroupName", newJString(resourceGroupName))
  result = call_564415.call(path_564416, query_564417, nil, nil, nil)

var clustersListSkusByResource* = Call_ClustersListSkusByResource_564407(
    name: "clustersListSkusByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/skus",
    validator: validate_ClustersListSkusByResource_564408, base: "",
    url: url_ClustersListSkusByResource_564409, schemes: {Scheme.Https})
type
  Call_ClustersStart_564418 = ref object of OpenApiRestCall_563556
proc url_ClustersStart_564420(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersStart_564419(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564421 = path.getOrDefault("clusterName")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "clusterName", valid_564421
  var valid_564422 = path.getOrDefault("subscriptionId")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "subscriptionId", valid_564422
  var valid_564423 = path.getOrDefault("resourceGroupName")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "resourceGroupName", valid_564423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564424 = query.getOrDefault("api-version")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "api-version", valid_564424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564425: Call_ClustersStart_564418; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a Kusto cluster.
  ## 
  let valid = call_564425.validator(path, query, header, formData, body)
  let scheme = call_564425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564425.url(scheme.get, call_564425.host, call_564425.base,
                         call_564425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564425, url, valid)

proc call*(call_564426: Call_ClustersStart_564418; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## clustersStart
  ## Starts a Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564427 = newJObject()
  var query_564428 = newJObject()
  add(path_564427, "clusterName", newJString(clusterName))
  add(query_564428, "api-version", newJString(apiVersion))
  add(path_564427, "subscriptionId", newJString(subscriptionId))
  add(path_564427, "resourceGroupName", newJString(resourceGroupName))
  result = call_564426.call(path_564427, query_564428, nil, nil, nil)

var clustersStart* = Call_ClustersStart_564418(name: "clustersStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/start",
    validator: validate_ClustersStart_564419, base: "", url: url_ClustersStart_564420,
    schemes: {Scheme.Https})
type
  Call_ClustersStop_564429 = ref object of OpenApiRestCall_563556
proc url_ClustersStop_564431(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Kusto/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersStop_564430(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564432 = path.getOrDefault("clusterName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "clusterName", valid_564432
  var valid_564433 = path.getOrDefault("subscriptionId")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "subscriptionId", valid_564433
  var valid_564434 = path.getOrDefault("resourceGroupName")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "resourceGroupName", valid_564434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564435 = query.getOrDefault("api-version")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "api-version", valid_564435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564436: Call_ClustersStop_564429; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a Kusto cluster.
  ## 
  let valid = call_564436.validator(path, query, header, formData, body)
  let scheme = call_564436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564436.url(scheme.get, call_564436.host, call_564436.base,
                         call_564436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564436, url, valid)

proc call*(call_564437: Call_ClustersStop_564429; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## clustersStop
  ## Stops a Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  var path_564438 = newJObject()
  var query_564439 = newJObject()
  add(path_564438, "clusterName", newJString(clusterName))
  add(query_564439, "api-version", newJString(apiVersion))
  add(path_564438, "subscriptionId", newJString(subscriptionId))
  add(path_564438, "resourceGroupName", newJString(resourceGroupName))
  result = call_564437.call(path_564438, query_564439, nil, nil, nil)

var clustersStop* = Call_ClustersStop_564429(name: "clustersStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/stop",
    validator: validate_ClustersStop_564430, base: "", url: url_ClustersStop_564431,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
