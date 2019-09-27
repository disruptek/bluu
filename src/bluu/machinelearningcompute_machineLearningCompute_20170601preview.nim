
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningcompute-machineLearningCompute"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MachineLearningComputeListAvailableOperations_593646 = ref object of OpenApiRestCall_593424
proc url_MachineLearningComputeListAvailableOperations_593648(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_MachineLearningComputeListAvailableOperations_593647(
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
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593830: Call_MachineLearningComputeListAvailableOperations_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all available operations.
  ## 
  let valid = call_593830.validator(path, query, header, formData, body)
  let scheme = call_593830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593830.url(scheme.get, call_593830.host, call_593830.base,
                         call_593830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593830, url, valid)

proc call*(call_593901: Call_MachineLearningComputeListAvailableOperations_593646;
          apiVersion: string): Recallable =
  ## machineLearningComputeListAvailableOperations
  ## Gets all available operations.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  var query_593902 = newJObject()
  add(query_593902, "api-version", newJString(apiVersion))
  result = call_593901.call(nil, query_593902, nil, nil, nil)

var machineLearningComputeListAvailableOperations* = Call_MachineLearningComputeListAvailableOperations_593646(
    name: "machineLearningComputeListAvailableOperations",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MachineLearningCompute/operations",
    validator: validate_MachineLearningComputeListAvailableOperations_593647,
    base: "", url: url_MachineLearningComputeListAvailableOperations_593648,
    schemes: {Scheme.Https})
type
  Call_OperationalizationClustersListBySubscriptionId_593942 = ref object of OpenApiRestCall_593424
proc url_OperationalizationClustersListBySubscriptionId_593944(protocol: Scheme;
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

proc validate_OperationalizationClustersListBySubscriptionId_593943(
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
  var valid_593960 = path.getOrDefault("subscriptionId")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "subscriptionId", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  var valid_593962 = query.getOrDefault("$skiptoken")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "$skiptoken", valid_593962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593963: Call_OperationalizationClustersListBySubscriptionId_593942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the operationalization clusters in the specified subscription.
  ## 
  let valid = call_593963.validator(path, query, header, formData, body)
  let scheme = call_593963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593963.url(scheme.get, call_593963.host, call_593963.base,
                         call_593963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593963, url, valid)

proc call*(call_593964: Call_OperationalizationClustersListBySubscriptionId_593942;
          apiVersion: string; subscriptionId: string; Skiptoken: string = ""): Recallable =
  ## operationalizationClustersListBySubscriptionId
  ## Gets the operationalization clusters in the specified subscription.
  ##   apiVersion: string (required)
  ##             : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_593965 = newJObject()
  var query_593966 = newJObject()
  add(query_593966, "api-version", newJString(apiVersion))
  add(path_593965, "subscriptionId", newJString(subscriptionId))
  add(query_593966, "$skiptoken", newJString(Skiptoken))
  result = call_593964.call(path_593965, query_593966, nil, nil, nil)

var operationalizationClustersListBySubscriptionId* = Call_OperationalizationClustersListBySubscriptionId_593942(
    name: "operationalizationClustersListBySubscriptionId",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningCompute/operationalizationClusters",
    validator: validate_OperationalizationClustersListBySubscriptionId_593943,
    base: "", url: url_OperationalizationClustersListBySubscriptionId_593944,
    schemes: {Scheme.Https})
type
  Call_OperationalizationClustersListByResourceGroup_593967 = ref object of OpenApiRestCall_593424
proc url_OperationalizationClustersListByResourceGroup_593969(protocol: Scheme;
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

proc validate_OperationalizationClustersListByResourceGroup_593968(
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
  var valid_593970 = path.getOrDefault("resourceGroupName")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "resourceGroupName", valid_593970
  var valid_593971 = path.getOrDefault("subscriptionId")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "subscriptionId", valid_593971
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593972 = query.getOrDefault("api-version")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "api-version", valid_593972
  var valid_593973 = query.getOrDefault("$skiptoken")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "$skiptoken", valid_593973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593974: Call_OperationalizationClustersListByResourceGroup_593967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the clusters in the specified resource group.
  ## 
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_OperationalizationClustersListByResourceGroup_593967;
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
  var path_593976 = newJObject()
  var query_593977 = newJObject()
  add(path_593976, "resourceGroupName", newJString(resourceGroupName))
  add(query_593977, "api-version", newJString(apiVersion))
  add(path_593976, "subscriptionId", newJString(subscriptionId))
  add(query_593977, "$skiptoken", newJString(Skiptoken))
  result = call_593975.call(path_593976, query_593977, nil, nil, nil)

var operationalizationClustersListByResourceGroup* = Call_OperationalizationClustersListByResourceGroup_593967(
    name: "operationalizationClustersListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters",
    validator: validate_OperationalizationClustersListByResourceGroup_593968,
    base: "", url: url_OperationalizationClustersListByResourceGroup_593969,
    schemes: {Scheme.Https})
type
  Call_OperationalizationClustersCreateOrUpdate_593989 = ref object of OpenApiRestCall_593424
proc url_OperationalizationClustersCreateOrUpdate_593991(protocol: Scheme;
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

proc validate_OperationalizationClustersCreateOrUpdate_593990(path: JsonNode;
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
  var valid_593992 = path.getOrDefault("clusterName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "clusterName", valid_593992
  var valid_593993 = path.getOrDefault("resourceGroupName")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "resourceGroupName", valid_593993
  var valid_593994 = path.getOrDefault("subscriptionId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "subscriptionId", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "api-version", valid_593995
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

proc call*(call_593997: Call_OperationalizationClustersCreateOrUpdate_593989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an operationalization cluster.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_OperationalizationClustersCreateOrUpdate_593989;
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
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  var body_594001 = newJObject()
  add(path_593999, "clusterName", newJString(clusterName))
  add(path_593999, "resourceGroupName", newJString(resourceGroupName))
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594001 = parameters
  result = call_593998.call(path_593999, query_594000, nil, nil, body_594001)

var operationalizationClustersCreateOrUpdate* = Call_OperationalizationClustersCreateOrUpdate_593989(
    name: "operationalizationClustersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}",
    validator: validate_OperationalizationClustersCreateOrUpdate_593990, base: "",
    url: url_OperationalizationClustersCreateOrUpdate_593991,
    schemes: {Scheme.Https})
type
  Call_OperationalizationClustersGet_593978 = ref object of OpenApiRestCall_593424
proc url_OperationalizationClustersGet_593980(protocol: Scheme; host: string;
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

proc validate_OperationalizationClustersGet_593979(path: JsonNode; query: JsonNode;
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
  var valid_593981 = path.getOrDefault("clusterName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "clusterName", valid_593981
  var valid_593982 = path.getOrDefault("resourceGroupName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceGroupName", valid_593982
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_OperationalizationClustersGet_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the operationalization cluster resource view. Note that the credentials are not returned by this call. Call ListKeys to get them.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_OperationalizationClustersGet_593978;
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
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(path_593987, "clusterName", newJString(clusterName))
  add(path_593987, "resourceGroupName", newJString(resourceGroupName))
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "subscriptionId", newJString(subscriptionId))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var operationalizationClustersGet* = Call_OperationalizationClustersGet_593978(
    name: "operationalizationClustersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}",
    validator: validate_OperationalizationClustersGet_593979, base: "",
    url: url_OperationalizationClustersGet_593980, schemes: {Scheme.Https})
type
  Call_OperationalizationClustersUpdate_594013 = ref object of OpenApiRestCall_593424
proc url_OperationalizationClustersUpdate_594015(protocol: Scheme; host: string;
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

proc validate_OperationalizationClustersUpdate_594014(path: JsonNode;
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
  var valid_594016 = path.getOrDefault("clusterName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "clusterName", valid_594016
  var valid_594017 = path.getOrDefault("resourceGroupName")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "resourceGroupName", valid_594017
  var valid_594018 = path.getOrDefault("subscriptionId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "subscriptionId", valid_594018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594019 = query.getOrDefault("api-version")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "api-version", valid_594019
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

proc call*(call_594021: Call_OperationalizationClustersUpdate_594013;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The PATCH operation can be used to update only the tags for a cluster. Use PUT operation to update other properties.
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_OperationalizationClustersUpdate_594013;
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
  var path_594023 = newJObject()
  var query_594024 = newJObject()
  var body_594025 = newJObject()
  add(path_594023, "clusterName", newJString(clusterName))
  add(path_594023, "resourceGroupName", newJString(resourceGroupName))
  add(query_594024, "api-version", newJString(apiVersion))
  add(path_594023, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594025 = parameters
  result = call_594022.call(path_594023, query_594024, nil, nil, body_594025)

var operationalizationClustersUpdate* = Call_OperationalizationClustersUpdate_594013(
    name: "operationalizationClustersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}",
    validator: validate_OperationalizationClustersUpdate_594014, base: "",
    url: url_OperationalizationClustersUpdate_594015, schemes: {Scheme.Https})
type
  Call_OperationalizationClustersDelete_594002 = ref object of OpenApiRestCall_593424
proc url_OperationalizationClustersDelete_594004(protocol: Scheme; host: string;
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

proc validate_OperationalizationClustersDelete_594003(path: JsonNode;
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
  var valid_594005 = path.getOrDefault("clusterName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "clusterName", valid_594005
  var valid_594006 = path.getOrDefault("resourceGroupName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "resourceGroupName", valid_594006
  var valid_594007 = path.getOrDefault("subscriptionId")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "subscriptionId", valid_594007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594008 = query.getOrDefault("api-version")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "api-version", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_OperationalizationClustersDelete_594002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified cluster.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_OperationalizationClustersDelete_594002;
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
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(path_594011, "clusterName", newJString(clusterName))
  add(path_594011, "resourceGroupName", newJString(resourceGroupName))
  add(query_594012, "api-version", newJString(apiVersion))
  add(path_594011, "subscriptionId", newJString(subscriptionId))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var operationalizationClustersDelete* = Call_OperationalizationClustersDelete_594002(
    name: "operationalizationClustersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}",
    validator: validate_OperationalizationClustersDelete_594003, base: "",
    url: url_OperationalizationClustersDelete_594004, schemes: {Scheme.Https})
type
  Call_OperationalizationClustersCheckUpdate_594026 = ref object of OpenApiRestCall_593424
proc url_OperationalizationClustersCheckUpdate_594028(protocol: Scheme;
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

proc validate_OperationalizationClustersCheckUpdate_594027(path: JsonNode;
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
  var valid_594029 = path.getOrDefault("clusterName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "clusterName", valid_594029
  var valid_594030 = path.getOrDefault("resourceGroupName")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "resourceGroupName", valid_594030
  var valid_594031 = path.getOrDefault("subscriptionId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "subscriptionId", valid_594031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594032 = query.getOrDefault("api-version")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "api-version", valid_594032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594033: Call_OperationalizationClustersCheckUpdate_594026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks if updates are available for system services in the cluster
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_OperationalizationClustersCheckUpdate_594026;
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
  var path_594035 = newJObject()
  var query_594036 = newJObject()
  add(path_594035, "clusterName", newJString(clusterName))
  add(path_594035, "resourceGroupName", newJString(resourceGroupName))
  add(query_594036, "api-version", newJString(apiVersion))
  add(path_594035, "subscriptionId", newJString(subscriptionId))
  result = call_594034.call(path_594035, query_594036, nil, nil, nil)

var operationalizationClustersCheckUpdate* = Call_OperationalizationClustersCheckUpdate_594026(
    name: "operationalizationClustersCheckUpdate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}/checkUpdate",
    validator: validate_OperationalizationClustersCheckUpdate_594027, base: "",
    url: url_OperationalizationClustersCheckUpdate_594028, schemes: {Scheme.Https})
type
  Call_OperationalizationClustersListKeys_594037 = ref object of OpenApiRestCall_593424
proc url_OperationalizationClustersListKeys_594039(protocol: Scheme; host: string;
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

proc validate_OperationalizationClustersListKeys_594038(path: JsonNode;
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
  var valid_594040 = path.getOrDefault("clusterName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "clusterName", valid_594040
  var valid_594041 = path.getOrDefault("resourceGroupName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "resourceGroupName", valid_594041
  var valid_594042 = path.getOrDefault("subscriptionId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "subscriptionId", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594044: Call_OperationalizationClustersListKeys_594037;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the credentials for the specified cluster such as Storage, ACR and ACS credentials. This is a long running operation because it fetches keys from dependencies.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_OperationalizationClustersListKeys_594037;
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
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  add(path_594046, "clusterName", newJString(clusterName))
  add(path_594046, "resourceGroupName", newJString(resourceGroupName))
  add(query_594047, "api-version", newJString(apiVersion))
  add(path_594046, "subscriptionId", newJString(subscriptionId))
  result = call_594045.call(path_594046, query_594047, nil, nil, nil)

var operationalizationClustersListKeys* = Call_OperationalizationClustersListKeys_594037(
    name: "operationalizationClustersListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}/listKeys",
    validator: validate_OperationalizationClustersListKeys_594038, base: "",
    url: url_OperationalizationClustersListKeys_594039, schemes: {Scheme.Https})
type
  Call_OperationalizationClustersUpdateSystem_594048 = ref object of OpenApiRestCall_593424
proc url_OperationalizationClustersUpdateSystem_594050(protocol: Scheme;
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

proc validate_OperationalizationClustersUpdateSystem_594049(path: JsonNode;
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
  var valid_594051 = path.getOrDefault("clusterName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "clusterName", valid_594051
  var valid_594052 = path.getOrDefault("resourceGroupName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "resourceGroupName", valid_594052
  var valid_594053 = path.getOrDefault("subscriptionId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "subscriptionId", valid_594053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Microsoft.MachineLearningCompute resource provider API to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594054 = query.getOrDefault("api-version")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "api-version", valid_594054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594055: Call_OperationalizationClustersUpdateSystem_594048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates system services in a cluster.
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_OperationalizationClustersUpdateSystem_594048;
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
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  add(path_594057, "clusterName", newJString(clusterName))
  add(path_594057, "resourceGroupName", newJString(resourceGroupName))
  add(query_594058, "api-version", newJString(apiVersion))
  add(path_594057, "subscriptionId", newJString(subscriptionId))
  result = call_594056.call(path_594057, query_594058, nil, nil, nil)

var operationalizationClustersUpdateSystem* = Call_OperationalizationClustersUpdateSystem_594048(
    name: "operationalizationClustersUpdateSystem", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningCompute/operationalizationClusters/{clusterName}/updateSystem",
    validator: validate_OperationalizationClustersUpdateSystem_594049, base: "",
    url: url_OperationalizationClustersUpdateSystem_594050,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
