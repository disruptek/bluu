
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Machine Learning Compute Management Client
## version: 2017-08-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## These APIs allow end users to operate on Azure Machine Learning Compute resources. They support the following operations:<ul><li>Create or update a cluster</li><li>Get a cluster</li><li>Patch a cluster</li><li>Delete a cluster</li><li>Get keys for a cluster</li><li>Check if updates are available for system services in a cluster</li><li>Update system services in a cluster</li><li>Get all clusters in a resource group</li><li>Get all clusters in a subscription</li></ul>
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningcompute-machineLearningCompute"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MachineLearningComputeListAvailableOperations_567879 = ref object of OpenApiRestCall_567657
proc url_MachineLearningComputeListAvailableOperations_567881(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_MachineLearningComputeListAvailableOperations_567880(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets all available operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_MachineLearningComputeListAvailableOperations_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all available operations.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_MachineLearningComputeListAvailableOperations_567879;
          apiVersion: string): Recallable =
  ## machineLearningComputeListAvailableOperations
  ## Gets all available operations.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var machineLearningComputeListAvailableOperations* = Call_MachineLearningComputeListAvailableOperations_567879(
    name: "machineLearningComputeListAvailableOperations",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MachineLearningCompute/operations",
    validator: validate_MachineLearningComputeListAvailableOperations_567880,
    base: "", url: url_MachineLearningComputeListAvailableOperations_567881,
    schemes: {Scheme.Https})
type
  Call_OperationalizationClustersListBySubscriptionId_568175 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersListBySubscriptionId_568177(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.MachineLearningCompute/operationalizationClusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationalizationClustersListBySubscriptionId_568176(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the operationalization clusters in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568193 = path.getOrDefault("subscriptionId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "subscriptionId", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568194 = query.getOrDefault("api-version")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "api-version", valid_568194
  var valid_568195 = query.getOrDefault("$skiptoken")
  valid_568195 = validateParameter(valid_568195, JString, required = false,
                                 default = nil)
  if valid_568195 != nil:
    section.add "$skiptoken", valid_568195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568196: Call_OperationalizationClustersListBySubscriptionId_568175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the operationalization clusters in the specified subscription.
  ## 
  let valid = call_568196.validator(path, query, header, formData, body)
  let scheme = call_568196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568196.url(scheme.get, call_568196.host, call_568196.base,
                         call_568196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568196, url, valid)

proc call*(call_568197: Call_OperationalizationClustersListBySubscriptionId_568175;
          apiVersion: string; subscriptionId: string; Skiptoken: string = ""): Recallable =
  ## operationalizationClustersListBySubscriptionId
  ## Gets the operationalization clusters in the specified subscription.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_568198 = newJObject()
  var query_568199 = newJObject()
  add(query_568199, "api-version", newJString(apiVersion))
  add(path_568198, "subscriptionId", newJString(subscriptionId))
  add(query_568199, "$skiptoken", newJString(Skiptoken))
  result = call_568197.call(path_568198, query_568199, nil, nil, nil)

var operationalizationClustersListBySubscriptionId* = Call_OperationalizationClustersListBySubscriptionId_568175(
    name: "operationalizationClustersListBySubscriptionId",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningCompute/operationalizationClusters",
    validator: validate_OperationalizationClustersListBySubscriptionId_568176,
    base: "", url: url_OperationalizationClustersListBySubscriptionId_568177,
    schemes: {Scheme.Https})
type
  Call_OperationalizationClustersListByResourceGroup_568200 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersListByResourceGroup_568202(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.MachineLearningCompute/operationalizationClusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationalizationClustersListByResourceGroup_568201(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the clusters in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568203 = path.getOrDefault("resourceGroupName")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "resourceGroupName", valid_568203
  var valid_568204 = path.getOrDefault("subscriptionId")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "subscriptionId", valid_568204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568205 = query.getOrDefault("api-version")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "api-version", valid_568205
  var valid_568206 = query.getOrDefault("$skiptoken")
  valid_568206 = validateParameter(valid_568206, JString, required = false,
                                 default = nil)
  if valid_568206 != nil:
    section.add "$skiptoken", valid_568206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568207: Call_OperationalizationClustersListByResourceGroup_568200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the clusters in the specified resource group.
  ## 
  let valid = call_568207.validator(path, query, header, formData, body)
  let scheme = call_568207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568207.url(scheme.get, call_568207.host, call_568207.base,
                         call_568207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568207, url, valid)

proc call*(call_568208: Call_OperationalizationClustersListByResourceGroup_568200;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Skiptoken: string = ""): Recallable =
  ## operationalizationClustersListByResourceGroup
  ## Gets the clusters in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_568209 = newJObject()
  var query_568210 = newJObject()
  add(path_568209, "resourceGroupName", newJString(resourceGroupName))
  add(query_568210, "api-version", newJString(apiVersion))
  add(path_568209, "subscriptionId", newJString(subscriptionId))
  add(query_568210, "$skiptoken", newJString(Skiptoken))
  result = call_568208.call(path_568209, query_568210, nil, nil, nil)

var operationalizationClustersListByResourceGroup* = Call_OperationalizationClustersListByResourceGroup_568200(
    name: "operationalizationClustersListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters",
    validator: validate_OperationalizationClustersListByResourceGroup_568201,
    base: "", url: url_OperationalizationClustersListByResourceGroup_568202,
    schemes: {Scheme.Https})
type
  Call_OperationalizationClustersCreateOrUpdate_568222 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersCreateOrUpdate_568224(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.MachineLearningCompute/operationalizationClusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationalizationClustersCreateOrUpdate_568223(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an operationalization cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568225 = path.getOrDefault("clusterName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "clusterName", valid_568225
  var valid_568226 = path.getOrDefault("resourceGroupName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "resourceGroupName", valid_568226
  var valid_568227 = path.getOrDefault("subscriptionId")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "subscriptionId", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update an Operationalization cluster.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568230: Call_OperationalizationClustersCreateOrUpdate_568222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an operationalization cluster.
  ## 
  let valid = call_568230.validator(path, query, header, formData, body)
  let scheme = call_568230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568230.url(scheme.get, call_568230.host, call_568230.base,
                         call_568230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568230, url, valid)

proc call*(call_568231: Call_OperationalizationClustersCreateOrUpdate_568222;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## operationalizationClustersCreateOrUpdate
  ## Create or update an operationalization cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update an Operationalization cluster.
  var path_568232 = newJObject()
  var query_568233 = newJObject()
  var body_568234 = newJObject()
  add(path_568232, "clusterName", newJString(clusterName))
  add(path_568232, "resourceGroupName", newJString(resourceGroupName))
  add(query_568233, "api-version", newJString(apiVersion))
  add(path_568232, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568234 = parameters
  result = call_568231.call(path_568232, query_568233, nil, nil, body_568234)

var operationalizationClustersCreateOrUpdate* = Call_OperationalizationClustersCreateOrUpdate_568222(
    name: "operationalizationClustersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}",
    validator: validate_OperationalizationClustersCreateOrUpdate_568223, base: "",
    url: url_OperationalizationClustersCreateOrUpdate_568224,
    schemes: {Scheme.Https})
type
  Call_OperationalizationClustersGet_568211 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersGet_568213(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.MachineLearningCompute/operationalizationClusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationalizationClustersGet_568212(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the operationalization cluster resource view. Note that the credentials are not returned by this call. Call ListKeys to get them.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568214 = path.getOrDefault("clusterName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "clusterName", valid_568214
  var valid_568215 = path.getOrDefault("resourceGroupName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "resourceGroupName", valid_568215
  var valid_568216 = path.getOrDefault("subscriptionId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "subscriptionId", valid_568216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568218: Call_OperationalizationClustersGet_568211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the operationalization cluster resource view. Note that the credentials are not returned by this call. Call ListKeys to get them.
  ## 
  let valid = call_568218.validator(path, query, header, formData, body)
  let scheme = call_568218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568218.url(scheme.get, call_568218.host, call_568218.base,
                         call_568218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568218, url, valid)

proc call*(call_568219: Call_OperationalizationClustersGet_568211;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## operationalizationClustersGet
  ## Gets the operationalization cluster resource view. Note that the credentials are not returned by this call. Call ListKeys to get them.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_568220 = newJObject()
  var query_568221 = newJObject()
  add(path_568220, "clusterName", newJString(clusterName))
  add(path_568220, "resourceGroupName", newJString(resourceGroupName))
  add(query_568221, "api-version", newJString(apiVersion))
  add(path_568220, "subscriptionId", newJString(subscriptionId))
  result = call_568219.call(path_568220, query_568221, nil, nil, nil)

var operationalizationClustersGet* = Call_OperationalizationClustersGet_568211(
    name: "operationalizationClustersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}",
    validator: validate_OperationalizationClustersGet_568212, base: "",
    url: url_OperationalizationClustersGet_568213, schemes: {Scheme.Https})
type
  Call_OperationalizationClustersUpdate_568247 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersUpdate_568249(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.MachineLearningCompute/operationalizationClusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationalizationClustersUpdate_568248(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The PATCH operation can be used to update only the tags for a cluster. Use PUT operation to update other properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568250 = path.getOrDefault("clusterName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "clusterName", valid_568250
  var valid_568251 = path.getOrDefault("resourceGroupName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "resourceGroupName", valid_568251
  var valid_568252 = path.getOrDefault("subscriptionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "subscriptionId", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "api-version", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters supplied to patch the cluster.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568255: Call_OperationalizationClustersUpdate_568247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The PATCH operation can be used to update only the tags for a cluster. Use PUT operation to update other properties.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_OperationalizationClustersUpdate_568247;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## operationalizationClustersUpdate
  ## The PATCH operation can be used to update only the tags for a cluster. Use PUT operation to update other properties.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   parameters: JObject (required)
  ##             : The parameters supplied to patch the cluster.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  var body_568259 = newJObject()
  add(path_568257, "clusterName", newJString(clusterName))
  add(path_568257, "resourceGroupName", newJString(resourceGroupName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568259 = parameters
  result = call_568256.call(path_568257, query_568258, nil, nil, body_568259)

var operationalizationClustersUpdate* = Call_OperationalizationClustersUpdate_568247(
    name: "operationalizationClustersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}",
    validator: validate_OperationalizationClustersUpdate_568248, base: "",
    url: url_OperationalizationClustersUpdate_568249, schemes: {Scheme.Https})
type
  Call_OperationalizationClustersDelete_568235 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersDelete_568237(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.MachineLearningCompute/operationalizationClusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationalizationClustersDelete_568236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568238 = path.getOrDefault("clusterName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "clusterName", valid_568238
  var valid_568239 = path.getOrDefault("resourceGroupName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "resourceGroupName", valid_568239
  var valid_568240 = path.getOrDefault("subscriptionId")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "subscriptionId", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   deleteAll: JBool
  ##            : If true, deletes all resources associated with this cluster.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  var valid_568242 = query.getOrDefault("deleteAll")
  valid_568242 = validateParameter(valid_568242, JBool, required = false, default = nil)
  if valid_568242 != nil:
    section.add "deleteAll", valid_568242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_OperationalizationClustersDelete_568235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified cluster.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_OperationalizationClustersDelete_568235;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; deleteAll: bool = false): Recallable =
  ## operationalizationClustersDelete
  ## Deletes the specified cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   deleteAll: bool
  ##            : If true, deletes all resources associated with this cluster.
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  add(path_568245, "clusterName", newJString(clusterName))
  add(path_568245, "resourceGroupName", newJString(resourceGroupName))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  add(query_568246, "deleteAll", newJBool(deleteAll))
  result = call_568244.call(path_568245, query_568246, nil, nil, nil)

var operationalizationClustersDelete* = Call_OperationalizationClustersDelete_568235(
    name: "operationalizationClustersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}",
    validator: validate_OperationalizationClustersDelete_568236, base: "",
    url: url_OperationalizationClustersDelete_568237, schemes: {Scheme.Https})
type
  Call_OperationalizationClustersCheckSystemServicesUpdatesAvailable_568260 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersCheckSystemServicesUpdatesAvailable_568262(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.MachineLearningCompute/operationalizationClusters/"),
               (kind: VariableSegment, value: "clusterName"), (
        kind: ConstantSegment, value: "/checkSystemServicesUpdatesAvailable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationalizationClustersCheckSystemServicesUpdatesAvailable_568261(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Checks if updates are available for system services in the cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568263 = path.getOrDefault("clusterName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "clusterName", valid_568263
  var valid_568264 = path.getOrDefault("resourceGroupName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceGroupName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568267: Call_OperationalizationClustersCheckSystemServicesUpdatesAvailable_568260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks if updates are available for system services in the cluster.
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_OperationalizationClustersCheckSystemServicesUpdatesAvailable_568260;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## operationalizationClustersCheckSystemServicesUpdatesAvailable
  ## Checks if updates are available for system services in the cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_568269 = newJObject()
  var query_568270 = newJObject()
  add(path_568269, "clusterName", newJString(clusterName))
  add(path_568269, "resourceGroupName", newJString(resourceGroupName))
  add(query_568270, "api-version", newJString(apiVersion))
  add(path_568269, "subscriptionId", newJString(subscriptionId))
  result = call_568268.call(path_568269, query_568270, nil, nil, nil)

var operationalizationClustersCheckSystemServicesUpdatesAvailable* = Call_OperationalizationClustersCheckSystemServicesUpdatesAvailable_568260(
    name: "operationalizationClustersCheckSystemServicesUpdatesAvailable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}/checkSystemServicesUpdatesAvailable", validator: validate_OperationalizationClustersCheckSystemServicesUpdatesAvailable_568261,
    base: "",
    url: url_OperationalizationClustersCheckSystemServicesUpdatesAvailable_568262,
    schemes: {Scheme.Https})
type
  Call_OperationalizationClustersListKeys_568271 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersListKeys_568273(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.MachineLearningCompute/operationalizationClusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationalizationClustersListKeys_568272(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the credentials for the specified cluster such as Storage, ACR and ACS credentials. This is a long running operation because it fetches keys from dependencies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568274 = path.getOrDefault("clusterName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "clusterName", valid_568274
  var valid_568275 = path.getOrDefault("resourceGroupName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "resourceGroupName", valid_568275
  var valid_568276 = path.getOrDefault("subscriptionId")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "subscriptionId", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_OperationalizationClustersListKeys_568271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the credentials for the specified cluster such as Storage, ACR and ACS credentials. This is a long running operation because it fetches keys from dependencies.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_OperationalizationClustersListKeys_568271;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## operationalizationClustersListKeys
  ## Gets the credentials for the specified cluster such as Storage, ACR and ACS credentials. This is a long running operation because it fetches keys from dependencies.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  add(path_568280, "clusterName", newJString(clusterName))
  add(path_568280, "resourceGroupName", newJString(resourceGroupName))
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "subscriptionId", newJString(subscriptionId))
  result = call_568279.call(path_568280, query_568281, nil, nil, nil)

var operationalizationClustersListKeys* = Call_OperationalizationClustersListKeys_568271(
    name: "operationalizationClustersListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}/listKeys",
    validator: validate_OperationalizationClustersListKeys_568272, base: "",
    url: url_OperationalizationClustersListKeys_568273, schemes: {Scheme.Https})
type
  Call_OperationalizationClustersUpdateSystemServices_568282 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersUpdateSystemServices_568284(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.MachineLearningCompute/operationalizationClusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/updateSystemServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationalizationClustersUpdateSystemServices_568283(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates system services in a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568285 = path.getOrDefault("clusterName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "clusterName", valid_568285
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568288 = query.getOrDefault("api-version")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "api-version", valid_568288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568289: Call_OperationalizationClustersUpdateSystemServices_568282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates system services in a cluster.
  ## 
  let valid = call_568289.validator(path, query, header, formData, body)
  let scheme = call_568289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568289.url(scheme.get, call_568289.host, call_568289.base,
                         call_568289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568289, url, valid)

proc call*(call_568290: Call_OperationalizationClustersUpdateSystemServices_568282;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## operationalizationClustersUpdateSystemServices
  ## Updates system services in a cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_568291 = newJObject()
  var query_568292 = newJObject()
  add(path_568291, "clusterName", newJString(clusterName))
  add(path_568291, "resourceGroupName", newJString(resourceGroupName))
  add(query_568292, "api-version", newJString(apiVersion))
  add(path_568291, "subscriptionId", newJString(subscriptionId))
  result = call_568290.call(path_568291, query_568292, nil, nil, nil)

var operationalizationClustersUpdateSystemServices* = Call_OperationalizationClustersUpdateSystemServices_568282(
    name: "operationalizationClustersUpdateSystemServices",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}/updateSystemServices",
    validator: validate_OperationalizationClustersUpdateSystemServices_568283,
    base: "", url: url_OperationalizationClustersUpdateSystemServices_568284,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
