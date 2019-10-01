
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ContainerServiceClient
## version: 2019-06-01
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
  macServiceName = "containerservice-managedClusters"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567889 = ref object of OpenApiRestCall_567667
proc url_OperationsList_567891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567890(path: JsonNode; query: JsonNode;
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
  var valid_568050 = query.getOrDefault("api-version")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "api-version", valid_568050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568073: Call_OperationsList_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of compute operations.
  ## 
  let valid = call_568073.validator(path, query, header, formData, body)
  let scheme = call_568073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568073.url(scheme.get, call_568073.host, call_568073.base,
                         call_568073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568073, url, valid)

proc call*(call_568144: Call_OperationsList_567889; apiVersion: string): Recallable =
  ## operationsList
  ## Gets a list of compute operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568145 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  result = call_568144.call(nil, query_568145, nil, nil, nil)

var operationsList* = Call_OperationsList_567889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ContainerService/operations",
    validator: validate_OperationsList_567890, base: "", url: url_OperationsList_567891,
    schemes: {Scheme.Https})
type
  Call_ManagedClustersList_568185 = ref object of OpenApiRestCall_567667
proc url_ManagedClustersList_568187(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedClustersList_568186(path: JsonNode; query: JsonNode;
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
  var valid_568202 = path.getOrDefault("subscriptionId")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "subscriptionId", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568203 = query.getOrDefault("api-version")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "api-version", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_ManagedClustersList_568185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of managed clusters in the specified subscription. The operation returns properties of each managed cluster.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_ManagedClustersList_568185; apiVersion: string;
          subscriptionId: string): Recallable =
  ## managedClustersList
  ## Gets a list of managed clusters in the specified subscription. The operation returns properties of each managed cluster.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var managedClustersList* = Call_ManagedClustersList_568185(
    name: "managedClustersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ContainerService/managedClusters",
    validator: validate_ManagedClustersList_568186, base: "",
    url: url_ManagedClustersList_568187, schemes: {Scheme.Https})
type
  Call_ManagedClustersListByResourceGroup_568208 = ref object of OpenApiRestCall_567667
proc url_ManagedClustersListByResourceGroup_568210(protocol: Scheme; host: string;
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

proc validate_ManagedClustersListByResourceGroup_568209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists managed clusters in the specified subscription and resource group. The operation returns properties of each managed cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568211 = path.getOrDefault("resourceGroupName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "resourceGroupName", valid_568211
  var valid_568212 = path.getOrDefault("subscriptionId")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "subscriptionId", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_ManagedClustersListByResourceGroup_568208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists managed clusters in the specified subscription and resource group. The operation returns properties of each managed cluster.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_ManagedClustersListByResourceGroup_568208;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## managedClustersListByResourceGroup
  ## Lists managed clusters in the specified subscription and resource group. The operation returns properties of each managed cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(path_568216, "resourceGroupName", newJString(resourceGroupName))
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "subscriptionId", newJString(subscriptionId))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var managedClustersListByResourceGroup* = Call_ManagedClustersListByResourceGroup_568208(
    name: "managedClustersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters",
    validator: validate_ManagedClustersListByResourceGroup_568209, base: "",
    url: url_ManagedClustersListByResourceGroup_568210, schemes: {Scheme.Https})
type
  Call_ManagedClustersCreateOrUpdate_568229 = ref object of OpenApiRestCall_567667
proc url_ManagedClustersCreateOrUpdate_568231(protocol: Scheme; host: string;
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

proc validate_ManagedClustersCreateOrUpdate_568230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a managed cluster with the specified configuration for agents and Kubernetes version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568232 = path.getOrDefault("resourceGroupName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "resourceGroupName", valid_568232
  var valid_568233 = path.getOrDefault("subscriptionId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "subscriptionId", valid_568233
  var valid_568234 = path.getOrDefault("resourceName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "resourceName", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "api-version", valid_568235
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

proc call*(call_568237: Call_ManagedClustersCreateOrUpdate_568229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a managed cluster with the specified configuration for agents and Kubernetes version.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_ManagedClustersCreateOrUpdate_568229;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode): Recallable =
  ## managedClustersCreateOrUpdate
  ## Creates or updates a managed cluster with the specified configuration for agents and Kubernetes version.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or Update a Managed Cluster operation.
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  var body_568241 = newJObject()
  add(path_568239, "resourceGroupName", newJString(resourceGroupName))
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  add(path_568239, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568241 = parameters
  result = call_568238.call(path_568239, query_568240, nil, nil, body_568241)

var managedClustersCreateOrUpdate* = Call_ManagedClustersCreateOrUpdate_568229(
    name: "managedClustersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}",
    validator: validate_ManagedClustersCreateOrUpdate_568230, base: "",
    url: url_ManagedClustersCreateOrUpdate_568231, schemes: {Scheme.Https})
type
  Call_ManagedClustersGet_568218 = ref object of OpenApiRestCall_567667
proc url_ManagedClustersGet_568220(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedClustersGet_568219(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the details of the managed cluster with a specified resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568221 = path.getOrDefault("resourceGroupName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "resourceGroupName", valid_568221
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  var valid_568223 = path.getOrDefault("resourceName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "resourceName", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_ManagedClustersGet_568218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the managed cluster with a specified resource group and name.
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_ManagedClustersGet_568218; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## managedClustersGet
  ## Gets the details of the managed cluster with a specified resource group and name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  add(path_568227, "resourceGroupName", newJString(resourceGroupName))
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "subscriptionId", newJString(subscriptionId))
  add(path_568227, "resourceName", newJString(resourceName))
  result = call_568226.call(path_568227, query_568228, nil, nil, nil)

var managedClustersGet* = Call_ManagedClustersGet_568218(
    name: "managedClustersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}",
    validator: validate_ManagedClustersGet_568219, base: "",
    url: url_ManagedClustersGet_568220, schemes: {Scheme.Https})
type
  Call_ManagedClustersUpdateTags_568253 = ref object of OpenApiRestCall_567667
proc url_ManagedClustersUpdateTags_568255(protocol: Scheme; host: string;
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

proc validate_ManagedClustersUpdateTags_568254(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a managed cluster with the specified tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568273 = path.getOrDefault("resourceGroupName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "resourceGroupName", valid_568273
  var valid_568274 = path.getOrDefault("subscriptionId")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "subscriptionId", valid_568274
  var valid_568275 = path.getOrDefault("resourceName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "resourceName", valid_568275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "api-version", valid_568276
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

proc call*(call_568278: Call_ManagedClustersUpdateTags_568253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a managed cluster with the specified tags.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_ManagedClustersUpdateTags_568253;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode): Recallable =
  ## managedClustersUpdateTags
  ## Updates a managed cluster with the specified tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Managed Cluster Tags operation.
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  var body_568282 = newJObject()
  add(path_568280, "resourceGroupName", newJString(resourceGroupName))
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "subscriptionId", newJString(subscriptionId))
  add(path_568280, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568282 = parameters
  result = call_568279.call(path_568280, query_568281, nil, nil, body_568282)

var managedClustersUpdateTags* = Call_ManagedClustersUpdateTags_568253(
    name: "managedClustersUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}",
    validator: validate_ManagedClustersUpdateTags_568254, base: "",
    url: url_ManagedClustersUpdateTags_568255, schemes: {Scheme.Https})
type
  Call_ManagedClustersDelete_568242 = ref object of OpenApiRestCall_567667
proc url_ManagedClustersDelete_568244(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedClustersDelete_568243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the managed cluster with a specified resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568245 = path.getOrDefault("resourceGroupName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "resourceGroupName", valid_568245
  var valid_568246 = path.getOrDefault("subscriptionId")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "subscriptionId", valid_568246
  var valid_568247 = path.getOrDefault("resourceName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "resourceName", valid_568247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "api-version", valid_568248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_ManagedClustersDelete_568242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the managed cluster with a specified resource group and name.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_ManagedClustersDelete_568242;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## managedClustersDelete
  ## Deletes the managed cluster with a specified resource group and name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  add(path_568251, "resourceGroupName", newJString(resourceGroupName))
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "subscriptionId", newJString(subscriptionId))
  add(path_568251, "resourceName", newJString(resourceName))
  result = call_568250.call(path_568251, query_568252, nil, nil, nil)

var managedClustersDelete* = Call_ManagedClustersDelete_568242(
    name: "managedClustersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}",
    validator: validate_ManagedClustersDelete_568243, base: "",
    url: url_ManagedClustersDelete_568244, schemes: {Scheme.Https})
type
  Call_ManagedClustersGetAccessProfile_568283 = ref object of OpenApiRestCall_567667
proc url_ManagedClustersGetAccessProfile_568285(protocol: Scheme; host: string;
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

proc validate_ManagedClustersGetAccessProfile_568284(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the accessProfile for the specified role name of the managed cluster with a specified resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  ##   roleName: JString (required)
  ##           : The name of the role for managed cluster accessProfile resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568286 = path.getOrDefault("resourceGroupName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "resourceGroupName", valid_568286
  var valid_568287 = path.getOrDefault("subscriptionId")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "subscriptionId", valid_568287
  var valid_568288 = path.getOrDefault("resourceName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "resourceName", valid_568288
  var valid_568289 = path.getOrDefault("roleName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "roleName", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "api-version", valid_568290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_ManagedClustersGetAccessProfile_568283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the accessProfile for the specified role name of the managed cluster with a specified resource group and name.
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_ManagedClustersGetAccessProfile_568283;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; roleName: string): Recallable =
  ## managedClustersGetAccessProfile
  ## Gets the accessProfile for the specified role name of the managed cluster with a specified resource group and name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   roleName: string (required)
  ##           : The name of the role for managed cluster accessProfile resource.
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  add(path_568293, "resourceName", newJString(resourceName))
  add(path_568293, "roleName", newJString(roleName))
  result = call_568292.call(path_568293, query_568294, nil, nil, nil)

var managedClustersGetAccessProfile* = Call_ManagedClustersGetAccessProfile_568283(
    name: "managedClustersGetAccessProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/accessProfiles/{roleName}/listCredential",
    validator: validate_ManagedClustersGetAccessProfile_568284, base: "",
    url: url_ManagedClustersGetAccessProfile_568285, schemes: {Scheme.Https})
type
  Call_AgentPoolsList_568295 = ref object of OpenApiRestCall_567667
proc url_AgentPoolsList_568297(protocol: Scheme; host: string; base: string;
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

proc validate_AgentPoolsList_568296(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a list of agent pools in the specified managed cluster. The operation returns properties of each agent pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568298 = path.getOrDefault("resourceGroupName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "resourceGroupName", valid_568298
  var valid_568299 = path.getOrDefault("subscriptionId")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "subscriptionId", valid_568299
  var valid_568300 = path.getOrDefault("resourceName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "resourceName", valid_568300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568302: Call_AgentPoolsList_568295; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of agent pools in the specified managed cluster. The operation returns properties of each agent pool.
  ## 
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_AgentPoolsList_568295; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## agentPoolsList
  ## Gets a list of agent pools in the specified managed cluster. The operation returns properties of each agent pool.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  add(path_568304, "resourceGroupName", newJString(resourceGroupName))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "subscriptionId", newJString(subscriptionId))
  add(path_568304, "resourceName", newJString(resourceName))
  result = call_568303.call(path_568304, query_568305, nil, nil, nil)

var agentPoolsList* = Call_AgentPoolsList_568295(name: "agentPoolsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/agentPools",
    validator: validate_AgentPoolsList_568296, base: "", url: url_AgentPoolsList_568297,
    schemes: {Scheme.Https})
type
  Call_AgentPoolsCreateOrUpdate_568318 = ref object of OpenApiRestCall_567667
proc url_AgentPoolsCreateOrUpdate_568320(protocol: Scheme; host: string;
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

proc validate_AgentPoolsCreateOrUpdate_568319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an agent pool in the specified managed cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  ##   agentPoolName: JString (required)
  ##                : The name of the agent pool.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568321 = path.getOrDefault("resourceGroupName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "resourceGroupName", valid_568321
  var valid_568322 = path.getOrDefault("subscriptionId")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "subscriptionId", valid_568322
  var valid_568323 = path.getOrDefault("resourceName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "resourceName", valid_568323
  var valid_568324 = path.getOrDefault("agentPoolName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "agentPoolName", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "api-version", valid_568325
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

proc call*(call_568327: Call_AgentPoolsCreateOrUpdate_568318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an agent pool in the specified managed cluster.
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_AgentPoolsCreateOrUpdate_568318;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; agentPoolName: string; parameters: JsonNode): Recallable =
  ## agentPoolsCreateOrUpdate
  ## Creates or updates an agent pool in the specified managed cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   agentPoolName: string (required)
  ##                : The name of the agent pool.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create or Update an agent pool operation.
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  var body_568331 = newJObject()
  add(path_568329, "resourceGroupName", newJString(resourceGroupName))
  add(query_568330, "api-version", newJString(apiVersion))
  add(path_568329, "subscriptionId", newJString(subscriptionId))
  add(path_568329, "resourceName", newJString(resourceName))
  add(path_568329, "agentPoolName", newJString(agentPoolName))
  if parameters != nil:
    body_568331 = parameters
  result = call_568328.call(path_568329, query_568330, nil, nil, body_568331)

var agentPoolsCreateOrUpdate* = Call_AgentPoolsCreateOrUpdate_568318(
    name: "agentPoolsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/agentPools/{agentPoolName}",
    validator: validate_AgentPoolsCreateOrUpdate_568319, base: "",
    url: url_AgentPoolsCreateOrUpdate_568320, schemes: {Scheme.Https})
type
  Call_AgentPoolsGet_568306 = ref object of OpenApiRestCall_567667
proc url_AgentPoolsGet_568308(protocol: Scheme; host: string; base: string;
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

proc validate_AgentPoolsGet_568307(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the agent pool by managed cluster and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  ##   agentPoolName: JString (required)
  ##                : The name of the agent pool.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568309 = path.getOrDefault("resourceGroupName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "resourceGroupName", valid_568309
  var valid_568310 = path.getOrDefault("subscriptionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "subscriptionId", valid_568310
  var valid_568311 = path.getOrDefault("resourceName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "resourceName", valid_568311
  var valid_568312 = path.getOrDefault("agentPoolName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "agentPoolName", valid_568312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568313 = query.getOrDefault("api-version")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "api-version", valid_568313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568314: Call_AgentPoolsGet_568306; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the agent pool by managed cluster and resource group.
  ## 
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_AgentPoolsGet_568306; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          agentPoolName: string): Recallable =
  ## agentPoolsGet
  ## Gets the details of the agent pool by managed cluster and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   agentPoolName: string (required)
  ##                : The name of the agent pool.
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  add(path_568316, "resourceGroupName", newJString(resourceGroupName))
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "subscriptionId", newJString(subscriptionId))
  add(path_568316, "resourceName", newJString(resourceName))
  add(path_568316, "agentPoolName", newJString(agentPoolName))
  result = call_568315.call(path_568316, query_568317, nil, nil, nil)

var agentPoolsGet* = Call_AgentPoolsGet_568306(name: "agentPoolsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/agentPools/{agentPoolName}",
    validator: validate_AgentPoolsGet_568307, base: "", url: url_AgentPoolsGet_568308,
    schemes: {Scheme.Https})
type
  Call_AgentPoolsDelete_568332 = ref object of OpenApiRestCall_567667
proc url_AgentPoolsDelete_568334(protocol: Scheme; host: string; base: string;
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

proc validate_AgentPoolsDelete_568333(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the agent pool in the specified managed cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  ##   agentPoolName: JString (required)
  ##                : The name of the agent pool.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568335 = path.getOrDefault("resourceGroupName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "resourceGroupName", valid_568335
  var valid_568336 = path.getOrDefault("subscriptionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "subscriptionId", valid_568336
  var valid_568337 = path.getOrDefault("resourceName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "resourceName", valid_568337
  var valid_568338 = path.getOrDefault("agentPoolName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "agentPoolName", valid_568338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568339 = query.getOrDefault("api-version")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "api-version", valid_568339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568340: Call_AgentPoolsDelete_568332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the agent pool in the specified managed cluster.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_AgentPoolsDelete_568332; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          agentPoolName: string): Recallable =
  ## agentPoolsDelete
  ## Deletes the agent pool in the specified managed cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   agentPoolName: string (required)
  ##                : The name of the agent pool.
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  add(path_568342, "resourceGroupName", newJString(resourceGroupName))
  add(query_568343, "api-version", newJString(apiVersion))
  add(path_568342, "subscriptionId", newJString(subscriptionId))
  add(path_568342, "resourceName", newJString(resourceName))
  add(path_568342, "agentPoolName", newJString(agentPoolName))
  result = call_568341.call(path_568342, query_568343, nil, nil, nil)

var agentPoolsDelete* = Call_AgentPoolsDelete_568332(name: "agentPoolsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/agentPools/{agentPoolName}",
    validator: validate_AgentPoolsDelete_568333, base: "",
    url: url_AgentPoolsDelete_568334, schemes: {Scheme.Https})
type
  Call_AgentPoolsGetUpgradeProfile_568344 = ref object of OpenApiRestCall_567667
proc url_AgentPoolsGetUpgradeProfile_568346(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "agentPoolName"),
               (kind: ConstantSegment, value: "/upgradeProfiles/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgentPoolsGetUpgradeProfile_568345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the upgrade profile for an agent pool with a specified resource group and managed cluster name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  ##   agentPoolName: JString (required)
  ##                : The name of the agent pool.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568347 = path.getOrDefault("resourceGroupName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "resourceGroupName", valid_568347
  var valid_568348 = path.getOrDefault("subscriptionId")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "subscriptionId", valid_568348
  var valid_568349 = path.getOrDefault("resourceName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "resourceName", valid_568349
  var valid_568350 = path.getOrDefault("agentPoolName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "agentPoolName", valid_568350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568351 = query.getOrDefault("api-version")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "api-version", valid_568351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568352: Call_AgentPoolsGetUpgradeProfile_568344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the upgrade profile for an agent pool with a specified resource group and managed cluster name.
  ## 
  let valid = call_568352.validator(path, query, header, formData, body)
  let scheme = call_568352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568352.url(scheme.get, call_568352.host, call_568352.base,
                         call_568352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568352, url, valid)

proc call*(call_568353: Call_AgentPoolsGetUpgradeProfile_568344;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; agentPoolName: string): Recallable =
  ## agentPoolsGetUpgradeProfile
  ## Gets the details of the upgrade profile for an agent pool with a specified resource group and managed cluster name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   agentPoolName: string (required)
  ##                : The name of the agent pool.
  var path_568354 = newJObject()
  var query_568355 = newJObject()
  add(path_568354, "resourceGroupName", newJString(resourceGroupName))
  add(query_568355, "api-version", newJString(apiVersion))
  add(path_568354, "subscriptionId", newJString(subscriptionId))
  add(path_568354, "resourceName", newJString(resourceName))
  add(path_568354, "agentPoolName", newJString(agentPoolName))
  result = call_568353.call(path_568354, query_568355, nil, nil, nil)

var agentPoolsGetUpgradeProfile* = Call_AgentPoolsGetUpgradeProfile_568344(
    name: "agentPoolsGetUpgradeProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/agentPools/{agentPoolName}/upgradeProfiles/default",
    validator: validate_AgentPoolsGetUpgradeProfile_568345, base: "",
    url: url_AgentPoolsGetUpgradeProfile_568346, schemes: {Scheme.Https})
type
  Call_AgentPoolsGetAvailableAgentPoolVersions_568356 = ref object of OpenApiRestCall_567667
proc url_AgentPoolsGetAvailableAgentPoolVersions_568358(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/availableAgentPoolVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgentPoolsGetAvailableAgentPoolVersions_568357(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of supported versions for the specified agent pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568359 = path.getOrDefault("resourceGroupName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "resourceGroupName", valid_568359
  var valid_568360 = path.getOrDefault("subscriptionId")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "subscriptionId", valid_568360
  var valid_568361 = path.getOrDefault("resourceName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "resourceName", valid_568361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568362 = query.getOrDefault("api-version")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "api-version", valid_568362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568363: Call_AgentPoolsGetAvailableAgentPoolVersions_568356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of supported versions for the specified agent pool.
  ## 
  let valid = call_568363.validator(path, query, header, formData, body)
  let scheme = call_568363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568363.url(scheme.get, call_568363.host, call_568363.base,
                         call_568363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568363, url, valid)

proc call*(call_568364: Call_AgentPoolsGetAvailableAgentPoolVersions_568356;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## agentPoolsGetAvailableAgentPoolVersions
  ## Gets a list of supported versions for the specified agent pool.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_568365 = newJObject()
  var query_568366 = newJObject()
  add(path_568365, "resourceGroupName", newJString(resourceGroupName))
  add(query_568366, "api-version", newJString(apiVersion))
  add(path_568365, "subscriptionId", newJString(subscriptionId))
  add(path_568365, "resourceName", newJString(resourceName))
  result = call_568364.call(path_568365, query_568366, nil, nil, nil)

var agentPoolsGetAvailableAgentPoolVersions* = Call_AgentPoolsGetAvailableAgentPoolVersions_568356(
    name: "agentPoolsGetAvailableAgentPoolVersions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/availableAgentPoolVersions",
    validator: validate_AgentPoolsGetAvailableAgentPoolVersions_568357, base: "",
    url: url_AgentPoolsGetAvailableAgentPoolVersions_568358,
    schemes: {Scheme.Https})
type
  Call_ManagedClustersListClusterAdminCredentials_568367 = ref object of OpenApiRestCall_567667
proc url_ManagedClustersListClusterAdminCredentials_568369(protocol: Scheme;
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

proc validate_ManagedClustersListClusterAdminCredentials_568368(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets cluster admin credential of the managed cluster with a specified resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568370 = path.getOrDefault("resourceGroupName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "resourceGroupName", valid_568370
  var valid_568371 = path.getOrDefault("subscriptionId")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "subscriptionId", valid_568371
  var valid_568372 = path.getOrDefault("resourceName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "resourceName", valid_568372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568373 = query.getOrDefault("api-version")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "api-version", valid_568373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568374: Call_ManagedClustersListClusterAdminCredentials_568367;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets cluster admin credential of the managed cluster with a specified resource group and name.
  ## 
  let valid = call_568374.validator(path, query, header, formData, body)
  let scheme = call_568374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568374.url(scheme.get, call_568374.host, call_568374.base,
                         call_568374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568374, url, valid)

proc call*(call_568375: Call_ManagedClustersListClusterAdminCredentials_568367;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## managedClustersListClusterAdminCredentials
  ## Gets cluster admin credential of the managed cluster with a specified resource group and name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_568376 = newJObject()
  var query_568377 = newJObject()
  add(path_568376, "resourceGroupName", newJString(resourceGroupName))
  add(query_568377, "api-version", newJString(apiVersion))
  add(path_568376, "subscriptionId", newJString(subscriptionId))
  add(path_568376, "resourceName", newJString(resourceName))
  result = call_568375.call(path_568376, query_568377, nil, nil, nil)

var managedClustersListClusterAdminCredentials* = Call_ManagedClustersListClusterAdminCredentials_568367(
    name: "managedClustersListClusterAdminCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/listClusterAdminCredential",
    validator: validate_ManagedClustersListClusterAdminCredentials_568368,
    base: "", url: url_ManagedClustersListClusterAdminCredentials_568369,
    schemes: {Scheme.Https})
type
  Call_ManagedClustersListClusterUserCredentials_568378 = ref object of OpenApiRestCall_567667
proc url_ManagedClustersListClusterUserCredentials_568380(protocol: Scheme;
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

proc validate_ManagedClustersListClusterUserCredentials_568379(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets cluster user credential of the managed cluster with a specified resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568381 = path.getOrDefault("resourceGroupName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "resourceGroupName", valid_568381
  var valid_568382 = path.getOrDefault("subscriptionId")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "subscriptionId", valid_568382
  var valid_568383 = path.getOrDefault("resourceName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "resourceName", valid_568383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568384 = query.getOrDefault("api-version")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "api-version", valid_568384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568385: Call_ManagedClustersListClusterUserCredentials_568378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets cluster user credential of the managed cluster with a specified resource group and name.
  ## 
  let valid = call_568385.validator(path, query, header, formData, body)
  let scheme = call_568385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568385.url(scheme.get, call_568385.host, call_568385.base,
                         call_568385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568385, url, valid)

proc call*(call_568386: Call_ManagedClustersListClusterUserCredentials_568378;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## managedClustersListClusterUserCredentials
  ## Gets cluster user credential of the managed cluster with a specified resource group and name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_568387 = newJObject()
  var query_568388 = newJObject()
  add(path_568387, "resourceGroupName", newJString(resourceGroupName))
  add(query_568388, "api-version", newJString(apiVersion))
  add(path_568387, "subscriptionId", newJString(subscriptionId))
  add(path_568387, "resourceName", newJString(resourceName))
  result = call_568386.call(path_568387, query_568388, nil, nil, nil)

var managedClustersListClusterUserCredentials* = Call_ManagedClustersListClusterUserCredentials_568378(
    name: "managedClustersListClusterUserCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/listClusterUserCredential",
    validator: validate_ManagedClustersListClusterUserCredentials_568379,
    base: "", url: url_ManagedClustersListClusterUserCredentials_568380,
    schemes: {Scheme.Https})
type
  Call_ManagedClustersResetAADProfile_568389 = ref object of OpenApiRestCall_567667
proc url_ManagedClustersResetAADProfile_568391(protocol: Scheme; host: string;
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

proc validate_ManagedClustersResetAADProfile_568390(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the AAD Profile for a managed cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568392 = path.getOrDefault("resourceGroupName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "resourceGroupName", valid_568392
  var valid_568393 = path.getOrDefault("subscriptionId")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "subscriptionId", valid_568393
  var valid_568394 = path.getOrDefault("resourceName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "resourceName", valid_568394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568395 = query.getOrDefault("api-version")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "api-version", valid_568395
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

proc call*(call_568397: Call_ManagedClustersResetAADProfile_568389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the AAD Profile for a managed cluster.
  ## 
  let valid = call_568397.validator(path, query, header, formData, body)
  let scheme = call_568397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568397.url(scheme.get, call_568397.host, call_568397.base,
                         call_568397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568397, url, valid)

proc call*(call_568398: Call_ManagedClustersResetAADProfile_568389;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode): Recallable =
  ## managedClustersResetAADProfile
  ## Update the AAD Profile for a managed cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Reset AAD Profile operation for a Managed Cluster.
  var path_568399 = newJObject()
  var query_568400 = newJObject()
  var body_568401 = newJObject()
  add(path_568399, "resourceGroupName", newJString(resourceGroupName))
  add(query_568400, "api-version", newJString(apiVersion))
  add(path_568399, "subscriptionId", newJString(subscriptionId))
  add(path_568399, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568401 = parameters
  result = call_568398.call(path_568399, query_568400, nil, nil, body_568401)

var managedClustersResetAADProfile* = Call_ManagedClustersResetAADProfile_568389(
    name: "managedClustersResetAADProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/resetAADProfile",
    validator: validate_ManagedClustersResetAADProfile_568390, base: "",
    url: url_ManagedClustersResetAADProfile_568391, schemes: {Scheme.Https})
type
  Call_ManagedClustersResetServicePrincipalProfile_568402 = ref object of OpenApiRestCall_567667
proc url_ManagedClustersResetServicePrincipalProfile_568404(protocol: Scheme;
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

proc validate_ManagedClustersResetServicePrincipalProfile_568403(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the service principal Profile for a managed cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568405 = path.getOrDefault("resourceGroupName")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "resourceGroupName", valid_568405
  var valid_568406 = path.getOrDefault("subscriptionId")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "subscriptionId", valid_568406
  var valid_568407 = path.getOrDefault("resourceName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "resourceName", valid_568407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568408 = query.getOrDefault("api-version")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "api-version", valid_568408
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

proc call*(call_568410: Call_ManagedClustersResetServicePrincipalProfile_568402;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the service principal Profile for a managed cluster.
  ## 
  let valid = call_568410.validator(path, query, header, formData, body)
  let scheme = call_568410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568410.url(scheme.get, call_568410.host, call_568410.base,
                         call_568410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568410, url, valid)

proc call*(call_568411: Call_ManagedClustersResetServicePrincipalProfile_568402;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode): Recallable =
  ## managedClustersResetServicePrincipalProfile
  ## Update the service principal Profile for a managed cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Reset Service Principal Profile operation for a Managed Cluster.
  var path_568412 = newJObject()
  var query_568413 = newJObject()
  var body_568414 = newJObject()
  add(path_568412, "resourceGroupName", newJString(resourceGroupName))
  add(query_568413, "api-version", newJString(apiVersion))
  add(path_568412, "subscriptionId", newJString(subscriptionId))
  add(path_568412, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568414 = parameters
  result = call_568411.call(path_568412, query_568413, nil, nil, body_568414)

var managedClustersResetServicePrincipalProfile* = Call_ManagedClustersResetServicePrincipalProfile_568402(
    name: "managedClustersResetServicePrincipalProfile",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/resetServicePrincipalProfile",
    validator: validate_ManagedClustersResetServicePrincipalProfile_568403,
    base: "", url: url_ManagedClustersResetServicePrincipalProfile_568404,
    schemes: {Scheme.Https})
type
  Call_ManagedClustersGetUpgradeProfile_568415 = ref object of OpenApiRestCall_567667
proc url_ManagedClustersGetUpgradeProfile_568417(protocol: Scheme; host: string;
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

proc validate_ManagedClustersGetUpgradeProfile_568416(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the upgrade profile for a managed cluster with a specified resource group and name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the managed cluster resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568418 = path.getOrDefault("resourceGroupName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "resourceGroupName", valid_568418
  var valid_568419 = path.getOrDefault("subscriptionId")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "subscriptionId", valid_568419
  var valid_568420 = path.getOrDefault("resourceName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "resourceName", valid_568420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568421 = query.getOrDefault("api-version")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "api-version", valid_568421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568422: Call_ManagedClustersGetUpgradeProfile_568415;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the upgrade profile for a managed cluster with a specified resource group and name.
  ## 
  let valid = call_568422.validator(path, query, header, formData, body)
  let scheme = call_568422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568422.url(scheme.get, call_568422.host, call_568422.base,
                         call_568422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568422, url, valid)

proc call*(call_568423: Call_ManagedClustersGetUpgradeProfile_568415;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## managedClustersGetUpgradeProfile
  ## Gets the details of the upgrade profile for a managed cluster with a specified resource group and name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the managed cluster resource.
  var path_568424 = newJObject()
  var query_568425 = newJObject()
  add(path_568424, "resourceGroupName", newJString(resourceGroupName))
  add(query_568425, "api-version", newJString(apiVersion))
  add(path_568424, "subscriptionId", newJString(subscriptionId))
  add(path_568424, "resourceName", newJString(resourceName))
  result = call_568423.call(path_568424, query_568425, nil, nil, nil)

var managedClustersGetUpgradeProfile* = Call_ManagedClustersGetUpgradeProfile_568415(
    name: "managedClustersGetUpgradeProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{resourceName}/upgradeProfiles/default",
    validator: validate_ManagedClustersGetUpgradeProfile_568416, base: "",
    url: url_ManagedClustersGetUpgradeProfile_568417, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
