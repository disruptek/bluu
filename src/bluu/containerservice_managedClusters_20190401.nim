
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ContainerServiceClient
## version: 2019-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Container Service Client.
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
  macServiceName = "containerservice-managedClusters"
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
  ## Gets a list of compute operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ## Gets a list of compute operations.
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
  ## Gets a list of compute operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ContainerService/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_ManagedClustersList_564076 = ref object of OpenApiRestCall_563556
proc url_ManagedClustersList_564078(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.ContainerService/managedClusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersList_564077(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets a list of managed clusters in the specified subscription. The operation returns properties of each managed cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
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

proc call*(call_564095: Call_ManagedClustersList_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of managed clusters in the specified subscription. The operation returns properties of each managed cluster.
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_ManagedClustersList_564076; apiVersion: string;
          subscriptionId: string): Recallable =
  ## managedClustersList
  ## Gets a list of managed clusters in the specified subscription. The operation returns properties of each managed cluster.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564097 = newJObject()
  var query_564098 = newJObject()
  add(query_564098, "api-version", newJString(apiVersion))
  add(path_564097, "subscriptionId", newJString(subscriptionId))
  result = call_564096.call(path_564097, query_564098, nil, nil, nil)

var managedClustersList* = Call_ManagedClustersList_564076(
    name: "managedClustersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ContainerService/managedClusters",
    validator: validate_ManagedClustersList_564077, base: "",
    url: url_ManagedClustersList_564078, schemes: {Scheme.Https})
type
  Call_ManagedClustersListByResourceGroup_564099 = ref object of OpenApiRestCall_563556
proc url_ManagedClustersListByResourceGroup_564101(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersListByResourceGroup_564100(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists managed clusters in the specified subscription and resource group. The operation returns properties of each managed cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  var valid_564103 = path.getOrDefault("resourceGroupName")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "resourceGroupName", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564105: Call_ManagedClustersListByResourceGroup_564099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists managed clusters in the specified subscription and resource group. The operation returns properties of each managed cluster.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_ManagedClustersListByResourceGroup_564099;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## managedClustersListByResourceGroup
  ## Lists managed clusters in the specified subscription and resource group. The operation returns properties of each managed cluster.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  add(query_564108, "api-version", newJString(apiVersion))
  add(path_564107, "subscriptionId", newJString(subscriptionId))
  add(path_564107, "resourceGroupName", newJString(resourceGroupName))
  result = call_564106.call(path_564107, query_564108, nil, nil, nil)

var managedClustersListByResourceGroup* = Call_ManagedClustersListByResourceGroup_564099(
    name: "managedClustersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters",
    validator: validate_ManagedClustersListByResourceGroup_564100, base: "",
    url: url_ManagedClustersListByResourceGroup_564101, schemes: {Scheme.Https})
type
  Call_ManagedClustersCreateOrUpdate_564120 = ref object of OpenApiRestCall_563556
proc url_ManagedClustersCreateOrUpdate_564122(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersCreateOrUpdate_564121(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a managed cluster with the specified configuration for agents and Kubernetes version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
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
  var valid_564125 = path.getOrDefault("resourceName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "resourceName", valid_564125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564126 = query.getOrDefault("api-version")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "api-version", valid_564126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or Update a Managed Cluster operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564128: Call_ManagedClustersCreateOrUpdate_564120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a managed cluster with the specified configuration for agents and Kubernetes version.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_ManagedClustersCreateOrUpdate_564120;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string; parameters: JsonNode): Recallable =
  ## managedClustersCreateOrUpdate
  ## Creates or updates a managed cluster with the specified configuration for agents and Kubernetes version.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or Update a Managed Cluster operation.
  var path_564130 = newJObject()
  var query_564131 = newJObject()
  var body_564132 = newJObject()
  add(query_564131, "api-version", newJString(apiVersion))
  add(path_564130, "subscriptionId", newJString(subscriptionId))
  add(path_564130, "resourceGroupName", newJString(resourceGroupName))
  add(path_564130, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_564132 = parameters
  result = call_564129.call(path_564130, query_564131, nil, nil, body_564132)

var managedClustersCreateOrUpdate* = Call_ManagedClustersCreateOrUpdate_564120(
    name: "managedClustersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}",
    validator: validate_ManagedClustersCreateOrUpdate_564121, base: "",
    url: url_ManagedClustersCreateOrUpdate_564122, schemes: {Scheme.Https})
type
  Call_ManagedClustersGet_564109 = ref object of OpenApiRestCall_563556
proc url_ManagedClustersGet_564111(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersGet_564110(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the details of the managed cluster with a specified resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  var valid_564113 = path.getOrDefault("resourceGroupName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "resourceGroupName", valid_564113
  var valid_564114 = path.getOrDefault("resourceName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "resourceName", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_564116: Call_ManagedClustersGet_564109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the managed cluster with a specified resource group and name.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_ManagedClustersGet_564109; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## managedClustersGet
  ## Gets the details of the managed cluster with a specified resource group and name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  add(path_564118, "resourceGroupName", newJString(resourceGroupName))
  add(path_564118, "resourceName", newJString(resourceName))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var managedClustersGet* = Call_ManagedClustersGet_564109(
    name: "managedClustersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}",
    validator: validate_ManagedClustersGet_564110, base: "",
    url: url_ManagedClustersGet_564111, schemes: {Scheme.Https})
type
  Call_ManagedClustersUpdateTags_564144 = ref object of OpenApiRestCall_563556
proc url_ManagedClustersUpdateTags_564146(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersUpdateTags_564145(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a managed cluster with the specified tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564164 = path.getOrDefault("subscriptionId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "subscriptionId", valid_564164
  var valid_564165 = path.getOrDefault("resourceGroupName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "resourceGroupName", valid_564165
  var valid_564166 = path.getOrDefault("resourceName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "resourceName", valid_564166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564167 = query.getOrDefault("api-version")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "api-version", valid_564167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Managed Cluster Tags operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564169: Call_ManagedClustersUpdateTags_564144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a managed cluster with the specified tags.
  ## 
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_ManagedClustersUpdateTags_564144; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          parameters: JsonNode): Recallable =
  ## managedClustersUpdateTags
  ## Updates a managed cluster with the specified tags.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Managed Cluster Tags operation.
  var path_564171 = newJObject()
  var query_564172 = newJObject()
  var body_564173 = newJObject()
  add(query_564172, "api-version", newJString(apiVersion))
  add(path_564171, "subscriptionId", newJString(subscriptionId))
  add(path_564171, "resourceGroupName", newJString(resourceGroupName))
  add(path_564171, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_564173 = parameters
  result = call_564170.call(path_564171, query_564172, nil, nil, body_564173)

var managedClustersUpdateTags* = Call_ManagedClustersUpdateTags_564144(
    name: "managedClustersUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}",
    validator: validate_ManagedClustersUpdateTags_564145, base: "",
    url: url_ManagedClustersUpdateTags_564146, schemes: {Scheme.Https})
type
  Call_ManagedClustersDelete_564133 = ref object of OpenApiRestCall_563556
proc url_ManagedClustersDelete_564135(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersDelete_564134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the managed cluster with a specified resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564136 = path.getOrDefault("subscriptionId")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "subscriptionId", valid_564136
  var valid_564137 = path.getOrDefault("resourceGroupName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "resourceGroupName", valid_564137
  var valid_564138 = path.getOrDefault("resourceName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "resourceName", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564139 = query.getOrDefault("api-version")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "api-version", valid_564139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_ManagedClustersDelete_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the managed cluster with a specified resource group and name.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_ManagedClustersDelete_564133; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## managedClustersDelete
  ## Deletes the managed cluster with a specified resource group and name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "resourceGroupName", newJString(resourceGroupName))
  add(path_564142, "resourceName", newJString(resourceName))
  result = call_564141.call(path_564142, query_564143, nil, nil, nil)

var managedClustersDelete* = Call_ManagedClustersDelete_564133(
    name: "managedClustersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}",
    validator: validate_ManagedClustersDelete_564134, base: "",
    url: url_ManagedClustersDelete_564135, schemes: {Scheme.Https})
type
  Call_ManagedClustersGetAccessProfile_564174 = ref object of OpenApiRestCall_563556
proc url_ManagedClustersGetAccessProfile_564176(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "roleName" in path, "`roleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/accessProfiles/"),
               (kind: VariableSegment, value: "roleName"),
               (kind: ConstantSegment, value: "/listCredential")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersGetAccessProfile_564175(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the accessProfile for the specified role name of the managed cluster with a specified resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   roleName: JString (required)
  ##           : The name of the role for managed cluster accessProfile resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564177 = path.getOrDefault("subscriptionId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "subscriptionId", valid_564177
  var valid_564178 = path.getOrDefault("roleName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "roleName", valid_564178
  var valid_564179 = path.getOrDefault("resourceGroupName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "resourceGroupName", valid_564179
  var valid_564180 = path.getOrDefault("resourceName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "resourceName", valid_564180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564182: Call_ManagedClustersGetAccessProfile_564174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the accessProfile for the specified role name of the managed cluster with a specified resource group and name.
  ## 
  let valid = call_564182.validator(path, query, header, formData, body)
  let scheme = call_564182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564182.url(scheme.get, call_564182.host, call_564182.base,
                         call_564182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564182, url, valid)

proc call*(call_564183: Call_ManagedClustersGetAccessProfile_564174;
          apiVersion: string; subscriptionId: string; roleName: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## managedClustersGetAccessProfile
  ## Gets the accessProfile for the specified role name of the managed cluster with a specified resource group and name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   roleName: string (required)
  ##           : The name of the role for managed cluster accessProfile resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_564184 = newJObject()
  var query_564185 = newJObject()
  add(query_564185, "api-version", newJString(apiVersion))
  add(path_564184, "subscriptionId", newJString(subscriptionId))
  add(path_564184, "roleName", newJString(roleName))
  add(path_564184, "resourceGroupName", newJString(resourceGroupName))
  add(path_564184, "resourceName", newJString(resourceName))
  result = call_564183.call(path_564184, query_564185, nil, nil, nil)

var managedClustersGetAccessProfile* = Call_ManagedClustersGetAccessProfile_564174(
    name: "managedClustersGetAccessProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/accessProfiles/{roleName}/listCredential",
    validator: validate_ManagedClustersGetAccessProfile_564175, base: "",
    url: url_ManagedClustersGetAccessProfile_564176, schemes: {Scheme.Https})
type
  Call_AgentPoolsList_564186 = ref object of OpenApiRestCall_563556
proc url_AgentPoolsList_564188(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/agentPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgentPoolsList_564187(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a list of agent pools in the specified managed cluster. The operation returns properties of each agent pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564189 = path.getOrDefault("subscriptionId")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "subscriptionId", valid_564189
  var valid_564190 = path.getOrDefault("resourceGroupName")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "resourceGroupName", valid_564190
  var valid_564191 = path.getOrDefault("resourceName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "resourceName", valid_564191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564192 = query.getOrDefault("api-version")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "api-version", valid_564192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564193: Call_AgentPoolsList_564186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of agent pools in the specified managed cluster. The operation returns properties of each agent pool.
  ## 
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_AgentPoolsList_564186; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## agentPoolsList
  ## Gets a list of agent pools in the specified managed cluster. The operation returns properties of each agent pool.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_564195 = newJObject()
  var query_564196 = newJObject()
  add(query_564196, "api-version", newJString(apiVersion))
  add(path_564195, "subscriptionId", newJString(subscriptionId))
  add(path_564195, "resourceGroupName", newJString(resourceGroupName))
  add(path_564195, "resourceName", newJString(resourceName))
  result = call_564194.call(path_564195, query_564196, nil, nil, nil)

var agentPoolsList* = Call_AgentPoolsList_564186(name: "agentPoolsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/agentPools",
    validator: validate_AgentPoolsList_564187, base: "", url: url_AgentPoolsList_564188,
    schemes: {Scheme.Https})
type
  Call_AgentPoolsCreateOrUpdate_564209 = ref object of OpenApiRestCall_563556
proc url_AgentPoolsCreateOrUpdate_564211(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "agentPoolName" in path, "`agentPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/agentPools/"),
               (kind: VariableSegment, value: "agentPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgentPoolsCreateOrUpdate_564210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an agent pool in the specified managed cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   agentPoolName: JString (required)
  ##                : The name of the agent pool.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564212 = path.getOrDefault("subscriptionId")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "subscriptionId", valid_564212
  var valid_564213 = path.getOrDefault("agentPoolName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "agentPoolName", valid_564213
  var valid_564214 = path.getOrDefault("resourceGroupName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "resourceGroupName", valid_564214
  var valid_564215 = path.getOrDefault("resourceName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "resourceName", valid_564215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564216 = query.getOrDefault("api-version")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "api-version", valid_564216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or Update an agent pool operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_AgentPoolsCreateOrUpdate_564209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an agent pool in the specified managed cluster.
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_AgentPoolsCreateOrUpdate_564209; apiVersion: string;
          subscriptionId: string; agentPoolName: string; resourceGroupName: string;
          resourceName: string; parameters: JsonNode): Recallable =
  ## agentPoolsCreateOrUpdate
  ## Creates or updates an agent pool in the specified managed cluster.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   agentPoolName: string (required)
  ##                : The name of the agent pool.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or Update an agent pool operation.
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  var body_564222 = newJObject()
  add(query_564221, "api-version", newJString(apiVersion))
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  add(path_564220, "agentPoolName", newJString(agentPoolName))
  add(path_564220, "resourceGroupName", newJString(resourceGroupName))
  add(path_564220, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_564222 = parameters
  result = call_564219.call(path_564220, query_564221, nil, nil, body_564222)

var agentPoolsCreateOrUpdate* = Call_AgentPoolsCreateOrUpdate_564209(
    name: "agentPoolsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/agentPools/{agentPoolName}",
    validator: validate_AgentPoolsCreateOrUpdate_564210, base: "",
    url: url_AgentPoolsCreateOrUpdate_564211, schemes: {Scheme.Https})
type
  Call_AgentPoolsGet_564197 = ref object of OpenApiRestCall_563556
proc url_AgentPoolsGet_564199(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "agentPoolName" in path, "`agentPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/agentPools/"),
               (kind: VariableSegment, value: "agentPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgentPoolsGet_564198(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the agent pool by managed cluster and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   agentPoolName: JString (required)
  ##                : The name of the agent pool.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564200 = path.getOrDefault("subscriptionId")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "subscriptionId", valid_564200
  var valid_564201 = path.getOrDefault("agentPoolName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "agentPoolName", valid_564201
  var valid_564202 = path.getOrDefault("resourceGroupName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "resourceGroupName", valid_564202
  var valid_564203 = path.getOrDefault("resourceName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "resourceName", valid_564203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564204 = query.getOrDefault("api-version")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "api-version", valid_564204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564205: Call_AgentPoolsGet_564197; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the agent pool by managed cluster and resource group.
  ## 
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_AgentPoolsGet_564197; apiVersion: string;
          subscriptionId: string; agentPoolName: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## agentPoolsGet
  ## Gets the details of the agent pool by managed cluster and resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   agentPoolName: string (required)
  ##                : The name of the agent pool.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  add(query_564208, "api-version", newJString(apiVersion))
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  add(path_564207, "agentPoolName", newJString(agentPoolName))
  add(path_564207, "resourceGroupName", newJString(resourceGroupName))
  add(path_564207, "resourceName", newJString(resourceName))
  result = call_564206.call(path_564207, query_564208, nil, nil, nil)

var agentPoolsGet* = Call_AgentPoolsGet_564197(name: "agentPoolsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/agentPools/{agentPoolName}",
    validator: validate_AgentPoolsGet_564198, base: "", url: url_AgentPoolsGet_564199,
    schemes: {Scheme.Https})
type
  Call_AgentPoolsDelete_564223 = ref object of OpenApiRestCall_563556
proc url_AgentPoolsDelete_564225(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "agentPoolName" in path, "`agentPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/agentPools/"),
               (kind: VariableSegment, value: "agentPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgentPoolsDelete_564224(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the agent pool in the specified managed cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   agentPoolName: JString (required)
  ##                : The name of the agent pool.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564226 = path.getOrDefault("subscriptionId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "subscriptionId", valid_564226
  var valid_564227 = path.getOrDefault("agentPoolName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "agentPoolName", valid_564227
  var valid_564228 = path.getOrDefault("resourceGroupName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "resourceGroupName", valid_564228
  var valid_564229 = path.getOrDefault("resourceName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceName", valid_564229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_564231: Call_AgentPoolsDelete_564223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the agent pool in the specified managed cluster.
  ## 
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_AgentPoolsDelete_564223; apiVersion: string;
          subscriptionId: string; agentPoolName: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## agentPoolsDelete
  ## Deletes the agent pool in the specified managed cluster.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   agentPoolName: string (required)
  ##                : The name of the agent pool.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  add(query_564234, "api-version", newJString(apiVersion))
  add(path_564233, "subscriptionId", newJString(subscriptionId))
  add(path_564233, "agentPoolName", newJString(agentPoolName))
  add(path_564233, "resourceGroupName", newJString(resourceGroupName))
  add(path_564233, "resourceName", newJString(resourceName))
  result = call_564232.call(path_564233, query_564234, nil, nil, nil)

var agentPoolsDelete* = Call_AgentPoolsDelete_564223(name: "agentPoolsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/agentPools/{agentPoolName}",
    validator: validate_AgentPoolsDelete_564224, base: "",
    url: url_AgentPoolsDelete_564225, schemes: {Scheme.Https})
type
  Call_ManagedClustersListClusterAdminCredentials_564235 = ref object of OpenApiRestCall_563556
proc url_ManagedClustersListClusterAdminCredentials_564237(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/listClusterAdminCredential")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersListClusterAdminCredentials_564236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets cluster admin credential of the managed cluster with a specified resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564238 = path.getOrDefault("subscriptionId")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "subscriptionId", valid_564238
  var valid_564239 = path.getOrDefault("resourceGroupName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "resourceGroupName", valid_564239
  var valid_564240 = path.getOrDefault("resourceName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "resourceName", valid_564240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564241 = query.getOrDefault("api-version")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "api-version", valid_564241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564242: Call_ManagedClustersListClusterAdminCredentials_564235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets cluster admin credential of the managed cluster with a specified resource group and name.
  ## 
  let valid = call_564242.validator(path, query, header, formData, body)
  let scheme = call_564242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564242.url(scheme.get, call_564242.host, call_564242.base,
                         call_564242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564242, url, valid)

proc call*(call_564243: Call_ManagedClustersListClusterAdminCredentials_564235;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## managedClustersListClusterAdminCredentials
  ## Gets cluster admin credential of the managed cluster with a specified resource group and name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_564244 = newJObject()
  var query_564245 = newJObject()
  add(query_564245, "api-version", newJString(apiVersion))
  add(path_564244, "subscriptionId", newJString(subscriptionId))
  add(path_564244, "resourceGroupName", newJString(resourceGroupName))
  add(path_564244, "resourceName", newJString(resourceName))
  result = call_564243.call(path_564244, query_564245, nil, nil, nil)

var managedClustersListClusterAdminCredentials* = Call_ManagedClustersListClusterAdminCredentials_564235(
    name: "managedClustersListClusterAdminCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/listClusterAdminCredential",
    validator: validate_ManagedClustersListClusterAdminCredentials_564236,
    base: "", url: url_ManagedClustersListClusterAdminCredentials_564237,
    schemes: {Scheme.Https})
type
  Call_ManagedClustersListClusterUserCredentials_564246 = ref object of OpenApiRestCall_563556
proc url_ManagedClustersListClusterUserCredentials_564248(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/listClusterUserCredential")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersListClusterUserCredentials_564247(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets cluster user credential of the managed cluster with a specified resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564249 = path.getOrDefault("subscriptionId")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "subscriptionId", valid_564249
  var valid_564250 = path.getOrDefault("resourceGroupName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "resourceGroupName", valid_564250
  var valid_564251 = path.getOrDefault("resourceName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "resourceName", valid_564251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_564253: Call_ManagedClustersListClusterUserCredentials_564246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets cluster user credential of the managed cluster with a specified resource group and name.
  ## 
  let valid = call_564253.validator(path, query, header, formData, body)
  let scheme = call_564253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564253.url(scheme.get, call_564253.host, call_564253.base,
                         call_564253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564253, url, valid)

proc call*(call_564254: Call_ManagedClustersListClusterUserCredentials_564246;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## managedClustersListClusterUserCredentials
  ## Gets cluster user credential of the managed cluster with a specified resource group and name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_564255 = newJObject()
  var query_564256 = newJObject()
  add(query_564256, "api-version", newJString(apiVersion))
  add(path_564255, "subscriptionId", newJString(subscriptionId))
  add(path_564255, "resourceGroupName", newJString(resourceGroupName))
  add(path_564255, "resourceName", newJString(resourceName))
  result = call_564254.call(path_564255, query_564256, nil, nil, nil)

var managedClustersListClusterUserCredentials* = Call_ManagedClustersListClusterUserCredentials_564246(
    name: "managedClustersListClusterUserCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/listClusterUserCredential",
    validator: validate_ManagedClustersListClusterUserCredentials_564247,
    base: "", url: url_ManagedClustersListClusterUserCredentials_564248,
    schemes: {Scheme.Https})
type
  Call_ManagedClustersResetAADProfile_564257 = ref object of OpenApiRestCall_563556
proc url_ManagedClustersResetAADProfile_564259(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/resetAADProfile")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersResetAADProfile_564258(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the AAD Profile for a managed cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564260 = path.getOrDefault("subscriptionId")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "subscriptionId", valid_564260
  var valid_564261 = path.getOrDefault("resourceGroupName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "resourceGroupName", valid_564261
  var valid_564262 = path.getOrDefault("resourceName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "resourceName", valid_564262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564263 = query.getOrDefault("api-version")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "api-version", valid_564263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Reset AAD Profile operation for a Managed Cluster.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564265: Call_ManagedClustersResetAADProfile_564257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the AAD Profile for a managed cluster.
  ## 
  let valid = call_564265.validator(path, query, header, formData, body)
  let scheme = call_564265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564265.url(scheme.get, call_564265.host, call_564265.base,
                         call_564265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564265, url, valid)

proc call*(call_564266: Call_ManagedClustersResetAADProfile_564257;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string; parameters: JsonNode): Recallable =
  ## managedClustersResetAADProfile
  ## Update the AAD Profile for a managed cluster.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Reset AAD Profile operation for a Managed Cluster.
  var path_564267 = newJObject()
  var query_564268 = newJObject()
  var body_564269 = newJObject()
  add(query_564268, "api-version", newJString(apiVersion))
  add(path_564267, "subscriptionId", newJString(subscriptionId))
  add(path_564267, "resourceGroupName", newJString(resourceGroupName))
  add(path_564267, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_564269 = parameters
  result = call_564266.call(path_564267, query_564268, nil, nil, body_564269)

var managedClustersResetAADProfile* = Call_ManagedClustersResetAADProfile_564257(
    name: "managedClustersResetAADProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/resetAADProfile",
    validator: validate_ManagedClustersResetAADProfile_564258, base: "",
    url: url_ManagedClustersResetAADProfile_564259, schemes: {Scheme.Https})
type
  Call_ManagedClustersResetServicePrincipalProfile_564270 = ref object of OpenApiRestCall_563556
proc url_ManagedClustersResetServicePrincipalProfile_564272(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/resetServicePrincipalProfile")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersResetServicePrincipalProfile_564271(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the service principal Profile for a managed cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564273 = path.getOrDefault("subscriptionId")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "subscriptionId", valid_564273
  var valid_564274 = path.getOrDefault("resourceGroupName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "resourceGroupName", valid_564274
  var valid_564275 = path.getOrDefault("resourceName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "resourceName", valid_564275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564276 = query.getOrDefault("api-version")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "api-version", valid_564276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Reset Service Principal Profile operation for a Managed Cluster.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564278: Call_ManagedClustersResetServicePrincipalProfile_564270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the service principal Profile for a managed cluster.
  ## 
  let valid = call_564278.validator(path, query, header, formData, body)
  let scheme = call_564278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564278.url(scheme.get, call_564278.host, call_564278.base,
                         call_564278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564278, url, valid)

proc call*(call_564279: Call_ManagedClustersResetServicePrincipalProfile_564270;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string; parameters: JsonNode): Recallable =
  ## managedClustersResetServicePrincipalProfile
  ## Update the service principal Profile for a managed cluster.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Reset Service Principal Profile operation for a Managed Cluster.
  var path_564280 = newJObject()
  var query_564281 = newJObject()
  var body_564282 = newJObject()
  add(query_564281, "api-version", newJString(apiVersion))
  add(path_564280, "subscriptionId", newJString(subscriptionId))
  add(path_564280, "resourceGroupName", newJString(resourceGroupName))
  add(path_564280, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_564282 = parameters
  result = call_564279.call(path_564280, query_564281, nil, nil, body_564282)

var managedClustersResetServicePrincipalProfile* = Call_ManagedClustersResetServicePrincipalProfile_564270(
    name: "managedClustersResetServicePrincipalProfile",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/resetServicePrincipalProfile",
    validator: validate_ManagedClustersResetServicePrincipalProfile_564271,
    base: "", url: url_ManagedClustersResetServicePrincipalProfile_564272,
    schemes: {Scheme.Https})
type
  Call_ManagedClustersGetUpgradeProfile_564283 = ref object of OpenApiRestCall_563556
proc url_ManagedClustersGetUpgradeProfile_564285(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerService/managedClusters/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/upgradeProfiles/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersGetUpgradeProfile_564284(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the upgrade profile for a managed cluster with a specified resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564286 = path.getOrDefault("subscriptionId")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "subscriptionId", valid_564286
  var valid_564287 = path.getOrDefault("resourceGroupName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "resourceGroupName", valid_564287
  var valid_564288 = path.getOrDefault("resourceName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "resourceName", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564289 = query.getOrDefault("api-version")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "api-version", valid_564289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564290: Call_ManagedClustersGetUpgradeProfile_564283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the upgrade profile for a managed cluster with a specified resource group and name.
  ## 
  let valid = call_564290.validator(path, query, header, formData, body)
  let scheme = call_564290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564290.url(scheme.get, call_564290.host, call_564290.base,
                         call_564290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564290, url, valid)

proc call*(call_564291: Call_ManagedClustersGetUpgradeProfile_564283;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## managedClustersGetUpgradeProfile
  ## Gets the details of the upgrade profile for a managed cluster with a specified resource group and name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_564292 = newJObject()
  var query_564293 = newJObject()
  add(query_564293, "api-version", newJString(apiVersion))
  add(path_564292, "subscriptionId", newJString(subscriptionId))
  add(path_564292, "resourceGroupName", newJString(resourceGroupName))
  add(path_564292, "resourceName", newJString(resourceName))
  result = call_564291.call(path_564292, query_564293, nil, nil, nil)

var managedClustersGetUpgradeProfile* = Call_ManagedClustersGetUpgradeProfile_564283(
    name: "managedClustersGetUpgradeProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/upgradeProfiles/default",
    validator: validate_ManagedClustersGetUpgradeProfile_564284, base: "",
    url: url_ManagedClustersGetUpgradeProfile_564285, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
