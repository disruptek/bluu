
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Machine Learning Compute Management Client
## version: 2017-06-01-preview
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
  Call_OperationalizationClustersUpdate_568246 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersUpdate_568248(protocol: Scheme; host: string;
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

proc validate_OperationalizationClustersUpdate_568247(path: JsonNode;
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
  var valid_568249 = path.getOrDefault("clusterName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "clusterName", valid_568249
  var valid_568250 = path.getOrDefault("resourceGroupName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "resourceGroupName", valid_568250
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "api-version", valid_568252
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

proc call*(call_568254: Call_OperationalizationClustersUpdate_568246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The PATCH operation can be used to update only the tags for a cluster. Use PUT operation to update other properties.
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_OperationalizationClustersUpdate_568246;
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
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  var body_568258 = newJObject()
  add(path_568256, "clusterName", newJString(clusterName))
  add(path_568256, "resourceGroupName", newJString(resourceGroupName))
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568258 = parameters
  result = call_568255.call(path_568256, query_568257, nil, nil, body_568258)

var operationalizationClustersUpdate* = Call_OperationalizationClustersUpdate_568246(
    name: "operationalizationClustersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}",
    validator: validate_OperationalizationClustersUpdate_568247, base: "",
    url: url_OperationalizationClustersUpdate_568248, schemes: {Scheme.Https})
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_OperationalizationClustersDelete_568235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified cluster.
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_OperationalizationClustersDelete_568235;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
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
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  add(path_568244, "clusterName", newJString(clusterName))
  add(path_568244, "resourceGroupName", newJString(resourceGroupName))
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "subscriptionId", newJString(subscriptionId))
  result = call_568243.call(path_568244, query_568245, nil, nil, nil)

var operationalizationClustersDelete* = Call_OperationalizationClustersDelete_568235(
    name: "operationalizationClustersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}",
    validator: validate_OperationalizationClustersDelete_568236, base: "",
    url: url_OperationalizationClustersDelete_568237, schemes: {Scheme.Https})
type
  Call_OperationalizationClustersCheckUpdate_568259 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersCheckUpdate_568261(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/checkUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationalizationClustersCheckUpdate_568260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks if updates are available for system services in the cluster
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
  var valid_568262 = path.getOrDefault("clusterName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "clusterName", valid_568262
  var valid_568263 = path.getOrDefault("resourceGroupName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "resourceGroupName", valid_568263
  var valid_568264 = path.getOrDefault("subscriptionId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "subscriptionId", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_OperationalizationClustersCheckUpdate_568259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks if updates are available for system services in the cluster
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_OperationalizationClustersCheckUpdate_568259;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## operationalizationClustersCheckUpdate
  ## Checks if updates are available for system services in the cluster
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  add(path_568268, "clusterName", newJString(clusterName))
  add(path_568268, "resourceGroupName", newJString(resourceGroupName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  result = call_568267.call(path_568268, query_568269, nil, nil, nil)

var operationalizationClustersCheckUpdate* = Call_OperationalizationClustersCheckUpdate_568259(
    name: "operationalizationClustersCheckUpdate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}/checkUpdate",
    validator: validate_OperationalizationClustersCheckUpdate_568260, base: "",
    url: url_OperationalizationClustersCheckUpdate_568261, schemes: {Scheme.Https})
type
  Call_OperationalizationClustersListKeys_568270 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersListKeys_568272(protocol: Scheme; host: string;
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

proc validate_OperationalizationClustersListKeys_568271(path: JsonNode;
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
  var valid_568273 = path.getOrDefault("clusterName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "clusterName", valid_568273
  var valid_568274 = path.getOrDefault("resourceGroupName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "resourceGroupName", valid_568274
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
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
  if body != nil:
    result.add "body", body

proc call*(call_568277: Call_OperationalizationClustersListKeys_568270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the credentials for the specified cluster such as Storage, ACR and ACS credentials. This is a long running operation because it fetches keys from dependencies.
  ## 
  let valid = call_568277.validator(path, query, header, formData, body)
  let scheme = call_568277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568277.url(scheme.get, call_568277.host, call_568277.base,
                         call_568277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568277, url, valid)

proc call*(call_568278: Call_OperationalizationClustersListKeys_568270;
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
  var path_568279 = newJObject()
  var query_568280 = newJObject()
  add(path_568279, "clusterName", newJString(clusterName))
  add(path_568279, "resourceGroupName", newJString(resourceGroupName))
  add(query_568280, "api-version", newJString(apiVersion))
  add(path_568279, "subscriptionId", newJString(subscriptionId))
  result = call_568278.call(path_568279, query_568280, nil, nil, nil)

var operationalizationClustersListKeys* = Call_OperationalizationClustersListKeys_568270(
    name: "operationalizationClustersListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}/listKeys",
    validator: validate_OperationalizationClustersListKeys_568271, base: "",
    url: url_OperationalizationClustersListKeys_568272, schemes: {Scheme.Https})
type
  Call_OperationalizationClustersUpdateSystem_568281 = ref object of OpenApiRestCall_567657
proc url_OperationalizationClustersUpdateSystem_568283(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/updateSystem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationalizationClustersUpdateSystem_568282(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_568284 = path.getOrDefault("clusterName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "clusterName", valid_568284
  var valid_568285 = path.getOrDefault("resourceGroupName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "resourceGroupName", valid_568285
  var valid_568286 = path.getOrDefault("subscriptionId")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "subscriptionId", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_OperationalizationClustersUpdateSystem_568281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates system services in a cluster.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_OperationalizationClustersUpdateSystem_568281;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## operationalizationClustersUpdateSystem
  ## Updates system services in a cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which the cluster is located.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  add(path_568290, "clusterName", newJString(clusterName))
  add(path_568290, "resourceGroupName", newJString(resourceGroupName))
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "subscriptionId", newJString(subscriptionId))
  result = call_568289.call(path_568290, query_568291, nil, nil, nil)

var operationalizationClustersUpdateSystem* = Call_OperationalizationClustersUpdateSystem_568281(
    name: "operationalizationClustersUpdateSystem", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}/updateSystem",
    validator: validate_OperationalizationClustersUpdateSystem_568282, base: "",
    url: url_OperationalizationClustersUpdateSystem_568283,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
