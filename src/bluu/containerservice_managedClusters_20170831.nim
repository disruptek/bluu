
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ContainerServiceClient
## version: 2017-08-31
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
  macServiceName = "containerservice-managedClusters"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManagedClustersList_563777 = ref object of OpenApiRestCall_563555
proc url_ManagedClustersList_563779(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedClustersList_563778(path: JsonNode; query: JsonNode;
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
  var valid_563954 = path.getOrDefault("subscriptionId")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "subscriptionId", valid_563954
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563955 = query.getOrDefault("api-version")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "api-version", valid_563955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563978: Call_ManagedClustersList_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of managed clusters in the specified subscription. The operation returns properties of each managed cluster.
  ## 
  let valid = call_563978.validator(path, query, header, formData, body)
  let scheme = call_563978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563978.url(scheme.get, call_563978.host, call_563978.base,
                         call_563978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563978, url, valid)

proc call*(call_564049: Call_ManagedClustersList_563777; apiVersion: string;
          subscriptionId: string): Recallable =
  ## managedClustersList
  ## Gets a list of managed clusters in the specified subscription. The operation returns properties of each managed cluster.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564050 = newJObject()
  var query_564052 = newJObject()
  add(query_564052, "api-version", newJString(apiVersion))
  add(path_564050, "subscriptionId", newJString(subscriptionId))
  result = call_564049.call(path_564050, query_564052, nil, nil, nil)

var managedClustersList* = Call_ManagedClustersList_563777(
    name: "managedClustersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ContainerService/managedClusters",
    validator: validate_ManagedClustersList_563778, base: "",
    url: url_ManagedClustersList_563779, schemes: {Scheme.Https})
type
  Call_ManagedClustersListByResourceGroup_564091 = ref object of OpenApiRestCall_563555
proc url_ManagedClustersListByResourceGroup_564093(protocol: Scheme; host: string;
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

proc validate_ManagedClustersListByResourceGroup_564092(path: JsonNode;
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
  var valid_564094 = path.getOrDefault("subscriptionId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "subscriptionId", valid_564094
  var valid_564095 = path.getOrDefault("resourceGroupName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "resourceGroupName", valid_564095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564096 = query.getOrDefault("api-version")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "api-version", valid_564096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_ManagedClustersListByResourceGroup_564091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists managed clusters in the specified subscription and resource group. The operation returns properties of each managed cluster.
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_ManagedClustersListByResourceGroup_564091;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## managedClustersListByResourceGroup
  ## Lists managed clusters in the specified subscription and resource group. The operation returns properties of each managed cluster.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "subscriptionId", newJString(subscriptionId))
  add(path_564099, "resourceGroupName", newJString(resourceGroupName))
  result = call_564098.call(path_564099, query_564100, nil, nil, nil)

var managedClustersListByResourceGroup* = Call_ManagedClustersListByResourceGroup_564091(
    name: "managedClustersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters",
    validator: validate_ManagedClustersListByResourceGroup_564092, base: "",
    url: url_ManagedClustersListByResourceGroup_564093, schemes: {Scheme.Https})
type
  Call_ManagedClustersCreateOrUpdate_564112 = ref object of OpenApiRestCall_563555
proc url_ManagedClustersCreateOrUpdate_564114(protocol: Scheme; host: string;
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

proc validate_ManagedClustersCreateOrUpdate_564113(path: JsonNode; query: JsonNode;
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
  var valid_564115 = path.getOrDefault("subscriptionId")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "subscriptionId", valid_564115
  var valid_564116 = path.getOrDefault("resourceGroupName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "resourceGroupName", valid_564116
  var valid_564117 = path.getOrDefault("resourceName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "resourceName", valid_564117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564118 = query.getOrDefault("api-version")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "api-version", valid_564118
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

proc call*(call_564120: Call_ManagedClustersCreateOrUpdate_564112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a managed cluster with the specified configuration for agents and Kubernetes version.
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_ManagedClustersCreateOrUpdate_564112;
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
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  var body_564124 = newJObject()
  add(query_564123, "api-version", newJString(apiVersion))
  add(path_564122, "subscriptionId", newJString(subscriptionId))
  add(path_564122, "resourceGroupName", newJString(resourceGroupName))
  add(path_564122, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_564124 = parameters
  result = call_564121.call(path_564122, query_564123, nil, nil, body_564124)

var managedClustersCreateOrUpdate* = Call_ManagedClustersCreateOrUpdate_564112(
    name: "managedClustersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}",
    validator: validate_ManagedClustersCreateOrUpdate_564113, base: "",
    url: url_ManagedClustersCreateOrUpdate_564114, schemes: {Scheme.Https})
type
  Call_ManagedClustersGet_564101 = ref object of OpenApiRestCall_563555
proc url_ManagedClustersGet_564103(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedClustersGet_564102(path: JsonNode; query: JsonNode;
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
  var valid_564104 = path.getOrDefault("subscriptionId")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "subscriptionId", valid_564104
  var valid_564105 = path.getOrDefault("resourceGroupName")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "resourceGroupName", valid_564105
  var valid_564106 = path.getOrDefault("resourceName")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "resourceName", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_ManagedClustersGet_564101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the managed cluster with a specified resource group and name.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_ManagedClustersGet_564101; apiVersion: string;
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
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "subscriptionId", newJString(subscriptionId))
  add(path_564110, "resourceGroupName", newJString(resourceGroupName))
  add(path_564110, "resourceName", newJString(resourceName))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var managedClustersGet* = Call_ManagedClustersGet_564101(
    name: "managedClustersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}",
    validator: validate_ManagedClustersGet_564102, base: "",
    url: url_ManagedClustersGet_564103, schemes: {Scheme.Https})
type
  Call_ManagedClustersDelete_564125 = ref object of OpenApiRestCall_563555
proc url_ManagedClustersDelete_564127(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedClustersDelete_564126(path: JsonNode; query: JsonNode;
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
  var valid_564128 = path.getOrDefault("subscriptionId")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "subscriptionId", valid_564128
  var valid_564129 = path.getOrDefault("resourceGroupName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "resourceGroupName", valid_564129
  var valid_564130 = path.getOrDefault("resourceName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "resourceName", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564131 = query.getOrDefault("api-version")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "api-version", valid_564131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564132: Call_ManagedClustersDelete_564125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the managed cluster with a specified resource group and name.
  ## 
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_ManagedClustersDelete_564125; apiVersion: string;
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
  var path_564134 = newJObject()
  var query_564135 = newJObject()
  add(query_564135, "api-version", newJString(apiVersion))
  add(path_564134, "subscriptionId", newJString(subscriptionId))
  add(path_564134, "resourceGroupName", newJString(resourceGroupName))
  add(path_564134, "resourceName", newJString(resourceName))
  result = call_564133.call(path_564134, query_564135, nil, nil, nil)

var managedClustersDelete* = Call_ManagedClustersDelete_564125(
    name: "managedClustersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}",
    validator: validate_ManagedClustersDelete_564126, base: "",
    url: url_ManagedClustersDelete_564127, schemes: {Scheme.Https})
type
  Call_ManagedClustersGetAccessProfiles_564136 = ref object of OpenApiRestCall_563555
proc url_ManagedClustersGetAccessProfiles_564138(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "roleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedClustersGetAccessProfiles_564137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Use ManagedClusters_GetAccessProfile instead.
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
  var valid_564139 = path.getOrDefault("subscriptionId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "subscriptionId", valid_564139
  var valid_564140 = path.getOrDefault("roleName")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "roleName", valid_564140
  var valid_564141 = path.getOrDefault("resourceGroupName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "resourceGroupName", valid_564141
  var valid_564142 = path.getOrDefault("resourceName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "resourceName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_ManagedClustersGetAccessProfiles_564136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Use ManagedClusters_GetAccessProfile instead.
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_ManagedClustersGetAccessProfiles_564136;
          apiVersion: string; subscriptionId: string; roleName: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## managedClustersGetAccessProfiles
  ## Use ManagedClusters_GetAccessProfile instead.
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
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "roleName", newJString(roleName))
  add(path_564146, "resourceGroupName", newJString(resourceGroupName))
  add(path_564146, "resourceName", newJString(resourceName))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var managedClustersGetAccessProfiles* = Call_ManagedClustersGetAccessProfiles_564136(
    name: "managedClustersGetAccessProfiles", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/accessProfiles/{roleName}",
    validator: validate_ManagedClustersGetAccessProfiles_564137, base: "",
    url: url_ManagedClustersGetAccessProfiles_564138, schemes: {Scheme.Https})
type
  Call_ManagedClustersGetAccessProfile_564148 = ref object of OpenApiRestCall_563555
proc url_ManagedClustersGetAccessProfile_564150(protocol: Scheme; host: string;
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

proc validate_ManagedClustersGetAccessProfile_564149(path: JsonNode;
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
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  var valid_564152 = path.getOrDefault("roleName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "roleName", valid_564152
  var valid_564153 = path.getOrDefault("resourceGroupName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "resourceGroupName", valid_564153
  var valid_564154 = path.getOrDefault("resourceName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "resourceName", valid_564154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "api-version", valid_564155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_ManagedClustersGetAccessProfile_564148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the accessProfile for the specified role name of the managed cluster with a specified resource group and name.
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_ManagedClustersGetAccessProfile_564148;
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
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "subscriptionId", newJString(subscriptionId))
  add(path_564158, "roleName", newJString(roleName))
  add(path_564158, "resourceGroupName", newJString(resourceGroupName))
  add(path_564158, "resourceName", newJString(resourceName))
  result = call_564157.call(path_564158, query_564159, nil, nil, nil)

var managedClustersGetAccessProfile* = Call_ManagedClustersGetAccessProfile_564148(
    name: "managedClustersGetAccessProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/accessProfiles/{roleName}/listCredential",
    validator: validate_ManagedClustersGetAccessProfile_564149, base: "",
    url: url_ManagedClustersGetAccessProfile_564150, schemes: {Scheme.Https})
type
  Call_ManagedClustersGetUpgradeProfile_564160 = ref object of OpenApiRestCall_563555
proc url_ManagedClustersGetUpgradeProfile_564162(protocol: Scheme; host: string;
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

proc validate_ManagedClustersGetUpgradeProfile_564161(path: JsonNode;
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
  var valid_564163 = path.getOrDefault("subscriptionId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "subscriptionId", valid_564163
  var valid_564164 = path.getOrDefault("resourceGroupName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "resourceGroupName", valid_564164
  var valid_564165 = path.getOrDefault("resourceName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "resourceName", valid_564165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564167: Call_ManagedClustersGetUpgradeProfile_564160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the upgrade profile for a managed cluster with a specified resource group and name.
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_ManagedClustersGetUpgradeProfile_564160;
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
  var path_564169 = newJObject()
  var query_564170 = newJObject()
  add(query_564170, "api-version", newJString(apiVersion))
  add(path_564169, "subscriptionId", newJString(subscriptionId))
  add(path_564169, "resourceGroupName", newJString(resourceGroupName))
  add(path_564169, "resourceName", newJString(resourceName))
  result = call_564168.call(path_564169, query_564170, nil, nil, nil)

var managedClustersGetUpgradeProfile* = Call_ManagedClustersGetUpgradeProfile_564160(
    name: "managedClustersGetUpgradeProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/upgradeProfiles/default",
    validator: validate_ManagedClustersGetUpgradeProfile_564161, base: "",
    url: url_ManagedClustersGetUpgradeProfile_564162, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
