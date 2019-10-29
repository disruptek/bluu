
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: EventHub2018PreviewManagementClient
## version: 2018-01-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Event Hubs client for managing Event Hubs Cluster, IPFilter Rules and VirtualNetworkRules resources.
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
  macServiceName = "eventhub-EventHub-preview"
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
  ## Lists all of the available Event Hub REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## Lists all of the available Event Hub REST API operations.
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
  ## Lists all of the available Event Hub REST API operations.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_564035 = newJObject()
  add(query_564035, "api-version", newJString(apiVersion))
  result = call_564034.call(nil, query_564035, nil, nil, nil)

var operationsList* = Call_OperationsList_563777(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventHub/operations",
    validator: validate_OperationsList_563778, base: "", url: url_OperationsList_563779,
    schemes: {Scheme.Https})
type
  Call_ClustersListAvailableClusters_564075 = ref object of OpenApiRestCall_563555
proc url_ClustersListAvailableClusters_564077(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.EventHub/availableClusterRegions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersListAvailableClusters_564076(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the quantity of available pre-provisioned Event Hubs Clusters, indexed by Azure region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564092 = path.getOrDefault("subscriptionId")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "subscriptionId", valid_564092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564094: Call_ClustersListAvailableClusters_564075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the quantity of available pre-provisioned Event Hubs Clusters, indexed by Azure region.
  ## 
  let valid = call_564094.validator(path, query, header, formData, body)
  let scheme = call_564094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564094.url(scheme.get, call_564094.host, call_564094.base,
                         call_564094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564094, url, valid)

proc call*(call_564095: Call_ClustersListAvailableClusters_564075;
          apiVersion: string; subscriptionId: string): Recallable =
  ## clustersListAvailableClusters
  ## List the quantity of available pre-provisioned Event Hubs Clusters, indexed by Azure region.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564096 = newJObject()
  var query_564097 = newJObject()
  add(query_564097, "api-version", newJString(apiVersion))
  add(path_564096, "subscriptionId", newJString(subscriptionId))
  result = call_564095.call(path_564096, query_564097, nil, nil, nil)

var clustersListAvailableClusters* = Call_ClustersListAvailableClusters_564075(
    name: "clustersListAvailableClusters", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventHub/availableClusterRegions",
    validator: validate_ClustersListAvailableClusters_564076, base: "",
    url: url_ClustersListAvailableClusters_564077, schemes: {Scheme.Https})
type
  Call_NamespacesList_564098 = ref object of OpenApiRestCall_563555
proc url_NamespacesList_564100(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesList_564099(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564101 = path.getOrDefault("subscriptionId")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "subscriptionId", valid_564101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564103: Call_NamespacesList_564098; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ## 
  let valid = call_564103.validator(path, query, header, formData, body)
  let scheme = call_564103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564103.url(scheme.get, call_564103.host, call_564103.base,
                         call_564103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564103, url, valid)

proc call*(call_564104: Call_NamespacesList_564098; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesList
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564105 = newJObject()
  var query_564106 = newJObject()
  add(query_564106, "api-version", newJString(apiVersion))
  add(path_564105, "subscriptionId", newJString(subscriptionId))
  result = call_564104.call(path_564105, query_564106, nil, nil, nil)

var namespacesList* = Call_NamespacesList_564098(name: "namespacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventHub/namespaces",
    validator: validate_NamespacesList_564099, base: "", url: url_NamespacesList_564100,
    schemes: {Scheme.Https})
type
  Call_ClustersListByResourceGroup_564107 = ref object of OpenApiRestCall_563555
proc url_ClustersListByResourceGroup_564109(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersListByResourceGroup_564108(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available Event Hubs Clusters within an ARM resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564110 = path.getOrDefault("subscriptionId")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "subscriptionId", valid_564110
  var valid_564111 = path.getOrDefault("resourceGroupName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "resourceGroupName", valid_564111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564112 = query.getOrDefault("api-version")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "api-version", valid_564112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564113: Call_ClustersListByResourceGroup_564107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available Event Hubs Clusters within an ARM resource group.
  ## 
  let valid = call_564113.validator(path, query, header, formData, body)
  let scheme = call_564113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564113.url(scheme.get, call_564113.host, call_564113.base,
                         call_564113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564113, url, valid)

proc call*(call_564114: Call_ClustersListByResourceGroup_564107;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## clustersListByResourceGroup
  ## Lists the available Event Hubs Clusters within an ARM resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564115 = newJObject()
  var query_564116 = newJObject()
  add(query_564116, "api-version", newJString(apiVersion))
  add(path_564115, "subscriptionId", newJString(subscriptionId))
  add(path_564115, "resourceGroupName", newJString(resourceGroupName))
  result = call_564114.call(path_564115, query_564116, nil, nil, nil)

var clustersListByResourceGroup* = Call_ClustersListByResourceGroup_564107(
    name: "clustersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/clusters",
    validator: validate_ClustersListByResourceGroup_564108, base: "",
    url: url_ClustersListByResourceGroup_564109, schemes: {Scheme.Https})
type
  Call_ClustersPut_564128 = ref object of OpenApiRestCall_563555
proc url_ClustersPut_564130(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersPut_564129(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an instance of an Event Hubs Cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Event Hubs Cluster.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564131 = path.getOrDefault("clusterName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "clusterName", valid_564131
  var valid_564132 = path.getOrDefault("subscriptionId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "subscriptionId", valid_564132
  var valid_564133 = path.getOrDefault("resourceGroupName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "resourceGroupName", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_564135: Call_ClustersPut_564128; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an instance of an Event Hubs Cluster.
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_ClustersPut_564128; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## clustersPut
  ## Creates or updates an instance of an Event Hubs Cluster.
  ##   clusterName: string (required)
  ##              : The name of the Event Hubs Cluster.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(path_564137, "clusterName", newJString(clusterName))
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  add(path_564137, "resourceGroupName", newJString(resourceGroupName))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var clustersPut* = Call_ClustersPut_564128(name: "clustersPut",
                                        meth: HttpMethod.HttpPut,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/clusters/{clusterName}",
                                        validator: validate_ClustersPut_564129,
                                        base: "", url: url_ClustersPut_564130,
                                        schemes: {Scheme.Https})
type
  Call_ClustersGet_564117 = ref object of OpenApiRestCall_563555
proc url_ClustersGet_564119(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersGet_564118(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the resource description of the specified Event Hubs Cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Event Hubs Cluster.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564120 = path.getOrDefault("clusterName")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "clusterName", valid_564120
  var valid_564121 = path.getOrDefault("subscriptionId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "subscriptionId", valid_564121
  var valid_564122 = path.getOrDefault("resourceGroupName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "resourceGroupName", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_ClustersGet_564117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource description of the specified Event Hubs Cluster.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_ClustersGet_564117; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## clustersGet
  ## Gets the resource description of the specified Event Hubs Cluster.
  ##   clusterName: string (required)
  ##              : The name of the Event Hubs Cluster.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564126 = newJObject()
  var query_564127 = newJObject()
  add(path_564126, "clusterName", newJString(clusterName))
  add(query_564127, "api-version", newJString(apiVersion))
  add(path_564126, "subscriptionId", newJString(subscriptionId))
  add(path_564126, "resourceGroupName", newJString(resourceGroupName))
  result = call_564125.call(path_564126, query_564127, nil, nil, nil)

var clustersGet* = Call_ClustersGet_564117(name: "clustersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/clusters/{clusterName}",
                                        validator: validate_ClustersGet_564118,
                                        base: "", url: url_ClustersGet_564119,
                                        schemes: {Scheme.Https})
type
  Call_ClustersPatch_564150 = ref object of OpenApiRestCall_563555
proc url_ClustersPatch_564152(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersPatch_564151(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies mutable properties on the Event Hubs Cluster. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Event Hubs Cluster.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564170 = path.getOrDefault("clusterName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "clusterName", valid_564170
  var valid_564171 = path.getOrDefault("subscriptionId")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "subscriptionId", valid_564171
  var valid_564172 = path.getOrDefault("resourceGroupName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "resourceGroupName", valid_564172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "api-version", valid_564173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The properties of the Event Hubs Cluster which should be updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564175: Call_ClustersPatch_564150; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies mutable properties on the Event Hubs Cluster. This operation is idempotent.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_ClustersPatch_564150; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## clustersPatch
  ## Modifies mutable properties on the Event Hubs Cluster. This operation is idempotent.
  ##   clusterName: string (required)
  ##              : The name of the Event Hubs Cluster.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : The properties of the Event Hubs Cluster which should be updated.
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  var body_564179 = newJObject()
  add(path_564177, "clusterName", newJString(clusterName))
  add(query_564178, "api-version", newJString(apiVersion))
  add(path_564177, "subscriptionId", newJString(subscriptionId))
  add(path_564177, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564179 = parameters
  result = call_564176.call(path_564177, query_564178, nil, nil, body_564179)

var clustersPatch* = Call_ClustersPatch_564150(name: "clustersPatch",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/clusters/{clusterName}",
    validator: validate_ClustersPatch_564151, base: "", url: url_ClustersPatch_564152,
    schemes: {Scheme.Https})
type
  Call_ClustersDelete_564139 = ref object of OpenApiRestCall_563555
proc url_ClustersDelete_564141(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersDelete_564140(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an existing Event Hubs Cluster. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Event Hubs Cluster.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564142 = path.getOrDefault("clusterName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "clusterName", valid_564142
  var valid_564143 = path.getOrDefault("subscriptionId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "subscriptionId", valid_564143
  var valid_564144 = path.getOrDefault("resourceGroupName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "resourceGroupName", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_564146: Call_ClustersDelete_564139; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Event Hubs Cluster. This operation is idempotent.
  ## 
  let valid = call_564146.validator(path, query, header, formData, body)
  let scheme = call_564146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564146.url(scheme.get, call_564146.host, call_564146.base,
                         call_564146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564146, url, valid)

proc call*(call_564147: Call_ClustersDelete_564139; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## clustersDelete
  ## Deletes an existing Event Hubs Cluster. This operation is idempotent.
  ##   clusterName: string (required)
  ##              : The name of the Event Hubs Cluster.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564148 = newJObject()
  var query_564149 = newJObject()
  add(path_564148, "clusterName", newJString(clusterName))
  add(query_564149, "api-version", newJString(apiVersion))
  add(path_564148, "subscriptionId", newJString(subscriptionId))
  add(path_564148, "resourceGroupName", newJString(resourceGroupName))
  result = call_564147.call(path_564148, query_564149, nil, nil, nil)

var clustersDelete* = Call_ClustersDelete_564139(name: "clustersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/clusters/{clusterName}",
    validator: validate_ClustersDelete_564140, base: "", url: url_ClustersDelete_564141,
    schemes: {Scheme.Https})
type
  Call_ClustersListNamespaces_564180 = ref object of OpenApiRestCall_563555
proc url_ClustersListNamespaces_564182(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersListNamespaces_564181(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all Event Hubs Namespace IDs in an Event Hubs Dedicated Cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Event Hubs Cluster.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564183 = path.getOrDefault("clusterName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "clusterName", valid_564183
  var valid_564184 = path.getOrDefault("subscriptionId")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "subscriptionId", valid_564184
  var valid_564185 = path.getOrDefault("resourceGroupName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "resourceGroupName", valid_564185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "api-version", valid_564186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564187: Call_ClustersListNamespaces_564180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all Event Hubs Namespace IDs in an Event Hubs Dedicated Cluster.
  ## 
  let valid = call_564187.validator(path, query, header, formData, body)
  let scheme = call_564187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564187.url(scheme.get, call_564187.host, call_564187.base,
                         call_564187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564187, url, valid)

proc call*(call_564188: Call_ClustersListNamespaces_564180; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## clustersListNamespaces
  ## List all Event Hubs Namespace IDs in an Event Hubs Dedicated Cluster.
  ##   clusterName: string (required)
  ##              : The name of the Event Hubs Cluster.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564189 = newJObject()
  var query_564190 = newJObject()
  add(path_564189, "clusterName", newJString(clusterName))
  add(query_564190, "api-version", newJString(apiVersion))
  add(path_564189, "subscriptionId", newJString(subscriptionId))
  add(path_564189, "resourceGroupName", newJString(resourceGroupName))
  result = call_564188.call(path_564189, query_564190, nil, nil, nil)

var clustersListNamespaces* = Call_ClustersListNamespaces_564180(
    name: "clustersListNamespaces", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/clusters/{clusterName}/namespaces",
    validator: validate_ClustersListNamespaces_564181, base: "",
    url: url_ClustersListNamespaces_564182, schemes: {Scheme.Https})
type
  Call_ConfigurationGet_564191 = ref object of OpenApiRestCall_563555
proc url_ConfigurationGet_564193(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/quotaConfiguration/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationGet_564192(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get all Event Hubs Cluster settings - a collection of key/value pairs which represent the quotas and settings imposed on the cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Event Hubs Cluster.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564194 = path.getOrDefault("clusterName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "clusterName", valid_564194
  var valid_564195 = path.getOrDefault("subscriptionId")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "subscriptionId", valid_564195
  var valid_564196 = path.getOrDefault("resourceGroupName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "resourceGroupName", valid_564196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564197 = query.getOrDefault("api-version")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "api-version", valid_564197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564198: Call_ConfigurationGet_564191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Event Hubs Cluster settings - a collection of key/value pairs which represent the quotas and settings imposed on the cluster.
  ## 
  let valid = call_564198.validator(path, query, header, formData, body)
  let scheme = call_564198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564198.url(scheme.get, call_564198.host, call_564198.base,
                         call_564198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564198, url, valid)

proc call*(call_564199: Call_ConfigurationGet_564191; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## configurationGet
  ## Get all Event Hubs Cluster settings - a collection of key/value pairs which represent the quotas and settings imposed on the cluster.
  ##   clusterName: string (required)
  ##              : The name of the Event Hubs Cluster.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564200 = newJObject()
  var query_564201 = newJObject()
  add(path_564200, "clusterName", newJString(clusterName))
  add(query_564201, "api-version", newJString(apiVersion))
  add(path_564200, "subscriptionId", newJString(subscriptionId))
  add(path_564200, "resourceGroupName", newJString(resourceGroupName))
  result = call_564199.call(path_564200, query_564201, nil, nil, nil)

var configurationGet* = Call_ConfigurationGet_564191(name: "configurationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/clusters/{clusterName}/quotaConfiguration/default",
    validator: validate_ConfigurationGet_564192, base: "",
    url: url_ConfigurationGet_564193, schemes: {Scheme.Https})
type
  Call_ConfigurationPatch_564202 = ref object of OpenApiRestCall_563555
proc url_ConfigurationPatch_564204(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/quotaConfiguration/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationPatch_564203(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Replace all specified Event Hubs Cluster settings with those contained in the request body. Leaves the settings not specified in the request body unmodified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Event Hubs Cluster.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564205 = path.getOrDefault("clusterName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "clusterName", valid_564205
  var valid_564206 = path.getOrDefault("subscriptionId")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "subscriptionId", valid_564206
  var valid_564207 = path.getOrDefault("resourceGroupName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "resourceGroupName", valid_564207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564208 = query.getOrDefault("api-version")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "api-version", valid_564208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating an Event Hubs Cluster resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564210: Call_ConfigurationPatch_564202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replace all specified Event Hubs Cluster settings with those contained in the request body. Leaves the settings not specified in the request body unmodified.
  ## 
  let valid = call_564210.validator(path, query, header, formData, body)
  let scheme = call_564210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564210.url(scheme.get, call_564210.host, call_564210.base,
                         call_564210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564210, url, valid)

proc call*(call_564211: Call_ConfigurationPatch_564202; clusterName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## configurationPatch
  ## Replace all specified Event Hubs Cluster settings with those contained in the request body. Leaves the settings not specified in the request body unmodified.
  ##   clusterName: string (required)
  ##              : The name of the Event Hubs Cluster.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for creating an Event Hubs Cluster resource.
  var path_564212 = newJObject()
  var query_564213 = newJObject()
  var body_564214 = newJObject()
  add(path_564212, "clusterName", newJString(clusterName))
  add(query_564213, "api-version", newJString(apiVersion))
  add(path_564212, "subscriptionId", newJString(subscriptionId))
  add(path_564212, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564214 = parameters
  result = call_564211.call(path_564212, query_564213, nil, nil, body_564214)

var configurationPatch* = Call_ConfigurationPatch_564202(
    name: "configurationPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/clusters/{clusterName}/quotaConfiguration/default",
    validator: validate_ConfigurationPatch_564203, base: "",
    url: url_ConfigurationPatch_564204, schemes: {Scheme.Https})
type
  Call_NamespacesListByResourceGroup_564215 = ref object of OpenApiRestCall_563555
proc url_NamespacesListByResourceGroup_564217(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListByResourceGroup_564216(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available Namespaces within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564218 = path.getOrDefault("subscriptionId")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "subscriptionId", valid_564218
  var valid_564219 = path.getOrDefault("resourceGroupName")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "resourceGroupName", valid_564219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564220 = query.getOrDefault("api-version")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "api-version", valid_564220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564221: Call_NamespacesListByResourceGroup_564215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available Namespaces within a resource group.
  ## 
  let valid = call_564221.validator(path, query, header, formData, body)
  let scheme = call_564221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564221.url(scheme.get, call_564221.host, call_564221.base,
                         call_564221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564221, url, valid)

proc call*(call_564222: Call_NamespacesListByResourceGroup_564215;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesListByResourceGroup
  ## Lists the available Namespaces within a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564223 = newJObject()
  var query_564224 = newJObject()
  add(query_564224, "api-version", newJString(apiVersion))
  add(path_564223, "subscriptionId", newJString(subscriptionId))
  add(path_564223, "resourceGroupName", newJString(resourceGroupName))
  result = call_564222.call(path_564223, query_564224, nil, nil, nil)

var namespacesListByResourceGroup* = Call_NamespacesListByResourceGroup_564215(
    name: "namespacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces",
    validator: validate_NamespacesListByResourceGroup_564216, base: "",
    url: url_NamespacesListByResourceGroup_564217, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_564236 = ref object of OpenApiRestCall_563555
proc url_NamespacesCreateOrUpdate_564238(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdate_564237(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564249 = path.getOrDefault("namespaceName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "namespaceName", valid_564249
  var valid_564250 = path.getOrDefault("subscriptionId")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "subscriptionId", valid_564250
  var valid_564251 = path.getOrDefault("resourceGroupName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "resourceGroupName", valid_564251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating a namespace resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564254: Call_NamespacesCreateOrUpdate_564236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_564254.validator(path, query, header, formData, body)
  let scheme = call_564254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564254.url(scheme.get, call_564254.host, call_564254.base,
                         call_564254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564254, url, valid)

proc call*(call_564255: Call_NamespacesCreateOrUpdate_564236; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdate
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for creating a namespace resource.
  var path_564256 = newJObject()
  var query_564257 = newJObject()
  var body_564258 = newJObject()
  add(query_564257, "api-version", newJString(apiVersion))
  add(path_564256, "namespaceName", newJString(namespaceName))
  add(path_564256, "subscriptionId", newJString(subscriptionId))
  add(path_564256, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564258 = parameters
  result = call_564255.call(path_564256, query_564257, nil, nil, body_564258)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_564236(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_564237, base: "",
    url: url_NamespacesCreateOrUpdate_564238, schemes: {Scheme.Https})
type
  Call_NamespacesGet_564225 = ref object of OpenApiRestCall_563555
proc url_NamespacesGet_564227(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGet_564226(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the description of the specified namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564228 = path.getOrDefault("namespaceName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "namespaceName", valid_564228
  var valid_564229 = path.getOrDefault("subscriptionId")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "subscriptionId", valid_564229
  var valid_564230 = path.getOrDefault("resourceGroupName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "resourceGroupName", valid_564230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564231 = query.getOrDefault("api-version")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "api-version", valid_564231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564232: Call_NamespacesGet_564225; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the description of the specified namespace.
  ## 
  let valid = call_564232.validator(path, query, header, formData, body)
  let scheme = call_564232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564232.url(scheme.get, call_564232.host, call_564232.base,
                         call_564232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564232, url, valid)

proc call*(call_564233: Call_NamespacesGet_564225; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesGet
  ## Gets the description of the specified namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564234 = newJObject()
  var query_564235 = newJObject()
  add(query_564235, "api-version", newJString(apiVersion))
  add(path_564234, "namespaceName", newJString(namespaceName))
  add(path_564234, "subscriptionId", newJString(subscriptionId))
  add(path_564234, "resourceGroupName", newJString(resourceGroupName))
  result = call_564233.call(path_564234, query_564235, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_564225(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_564226, base: "", url: url_NamespacesGet_564227,
    schemes: {Scheme.Https})
type
  Call_NamespacesUpdate_564270 = ref object of OpenApiRestCall_563555
proc url_NamespacesUpdate_564272(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesUpdate_564271(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564273 = path.getOrDefault("namespaceName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "namespaceName", valid_564273
  var valid_564274 = path.getOrDefault("subscriptionId")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "subscriptionId", valid_564274
  var valid_564275 = path.getOrDefault("resourceGroupName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "resourceGroupName", valid_564275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ##             : Parameters for updating a namespace resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564278: Call_NamespacesUpdate_564270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_564278.validator(path, query, header, formData, body)
  let scheme = call_564278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564278.url(scheme.get, call_564278.host, call_564278.base,
                         call_564278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564278, url, valid)

proc call*(call_564279: Call_NamespacesUpdate_564270; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesUpdate
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for updating a namespace resource.
  var path_564280 = newJObject()
  var query_564281 = newJObject()
  var body_564282 = newJObject()
  add(query_564281, "api-version", newJString(apiVersion))
  add(path_564280, "namespaceName", newJString(namespaceName))
  add(path_564280, "subscriptionId", newJString(subscriptionId))
  add(path_564280, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564282 = parameters
  result = call_564279.call(path_564280, query_564281, nil, nil, body_564282)

var namespacesUpdate* = Call_NamespacesUpdate_564270(name: "namespacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesUpdate_564271, base: "",
    url: url_NamespacesUpdate_564272, schemes: {Scheme.Https})
type
  Call_NamespacesDelete_564259 = ref object of OpenApiRestCall_563555
proc url_NamespacesDelete_564261(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDelete_564260(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564262 = path.getOrDefault("namespaceName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "namespaceName", valid_564262
  var valid_564263 = path.getOrDefault("subscriptionId")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "subscriptionId", valid_564263
  var valid_564264 = path.getOrDefault("resourceGroupName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "resourceGroupName", valid_564264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564265 = query.getOrDefault("api-version")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "api-version", valid_564265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564266: Call_NamespacesDelete_564259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  let valid = call_564266.validator(path, query, header, formData, body)
  let scheme = call_564266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564266.url(scheme.get, call_564266.host, call_564266.base,
                         call_564266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564266, url, valid)

proc call*(call_564267: Call_NamespacesDelete_564259; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesDelete
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564268 = newJObject()
  var query_564269 = newJObject()
  add(query_564269, "api-version", newJString(apiVersion))
  add(path_564268, "namespaceName", newJString(namespaceName))
  add(path_564268, "subscriptionId", newJString(subscriptionId))
  add(path_564268, "resourceGroupName", newJString(resourceGroupName))
  result = call_564267.call(path_564268, query_564269, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_564259(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_564260, base: "",
    url: url_NamespacesDelete_564261, schemes: {Scheme.Https})
type
  Call_NamespacesListIPFilterRules_564283 = ref object of OpenApiRestCall_563555
proc url_NamespacesListIPFilterRules_564285(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/ipfilterrules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListIPFilterRules_564284(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of IP Filter rules for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564286 = path.getOrDefault("namespaceName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "namespaceName", valid_564286
  var valid_564287 = path.getOrDefault("subscriptionId")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "subscriptionId", valid_564287
  var valid_564288 = path.getOrDefault("resourceGroupName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "resourceGroupName", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_564290: Call_NamespacesListIPFilterRules_564283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of IP Filter rules for a Namespace.
  ## 
  let valid = call_564290.validator(path, query, header, formData, body)
  let scheme = call_564290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564290.url(scheme.get, call_564290.host, call_564290.base,
                         call_564290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564290, url, valid)

proc call*(call_564291: Call_NamespacesListIPFilterRules_564283;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## namespacesListIPFilterRules
  ## Gets a list of IP Filter rules for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564292 = newJObject()
  var query_564293 = newJObject()
  add(query_564293, "api-version", newJString(apiVersion))
  add(path_564292, "namespaceName", newJString(namespaceName))
  add(path_564292, "subscriptionId", newJString(subscriptionId))
  add(path_564292, "resourceGroupName", newJString(resourceGroupName))
  result = call_564291.call(path_564292, query_564293, nil, nil, nil)

var namespacesListIPFilterRules* = Call_NamespacesListIPFilterRules_564283(
    name: "namespacesListIPFilterRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/ipfilterrules",
    validator: validate_NamespacesListIPFilterRules_564284, base: "",
    url: url_NamespacesListIPFilterRules_564285, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateIpFilterRule_564306 = ref object of OpenApiRestCall_563555
proc url_NamespacesCreateOrUpdateIpFilterRule_564308(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "ipFilterRuleName" in path,
        "`ipFilterRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/ipfilterrules/"),
               (kind: VariableSegment, value: "ipFilterRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateIpFilterRule_564307(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an IpFilterRule for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ipFilterRuleName: JString (required)
  ##                   : The IP Filter Rule name.
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ipFilterRuleName` field"
  var valid_564309 = path.getOrDefault("ipFilterRuleName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "ipFilterRuleName", valid_564309
  var valid_564310 = path.getOrDefault("namespaceName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "namespaceName", valid_564310
  var valid_564311 = path.getOrDefault("subscriptionId")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "subscriptionId", valid_564311
  var valid_564312 = path.getOrDefault("resourceGroupName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "resourceGroupName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Namespace IpFilterRule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564315: Call_NamespacesCreateOrUpdateIpFilterRule_564306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an IpFilterRule for a Namespace.
  ## 
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_NamespacesCreateOrUpdateIpFilterRule_564306;
          ipFilterRuleName: string; apiVersion: string; namespaceName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateIpFilterRule
  ## Creates or updates an IpFilterRule for a Namespace.
  ##   ipFilterRuleName: string (required)
  ##                   : The IP Filter Rule name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : The Namespace IpFilterRule.
  var path_564317 = newJObject()
  var query_564318 = newJObject()
  var body_564319 = newJObject()
  add(path_564317, "ipFilterRuleName", newJString(ipFilterRuleName))
  add(query_564318, "api-version", newJString(apiVersion))
  add(path_564317, "namespaceName", newJString(namespaceName))
  add(path_564317, "subscriptionId", newJString(subscriptionId))
  add(path_564317, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564319 = parameters
  result = call_564316.call(path_564317, query_564318, nil, nil, body_564319)

var namespacesCreateOrUpdateIpFilterRule* = Call_NamespacesCreateOrUpdateIpFilterRule_564306(
    name: "namespacesCreateOrUpdateIpFilterRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/ipfilterrules/{ipFilterRuleName}",
    validator: validate_NamespacesCreateOrUpdateIpFilterRule_564307, base: "",
    url: url_NamespacesCreateOrUpdateIpFilterRule_564308, schemes: {Scheme.Https})
type
  Call_NamespacesGetIpFilterRule_564294 = ref object of OpenApiRestCall_563555
proc url_NamespacesGetIpFilterRule_564296(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "ipFilterRuleName" in path,
        "`ipFilterRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/ipfilterrules/"),
               (kind: VariableSegment, value: "ipFilterRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetIpFilterRule_564295(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an IpFilterRule for a Namespace by rule name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ipFilterRuleName: JString (required)
  ##                   : The IP Filter Rule name.
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ipFilterRuleName` field"
  var valid_564297 = path.getOrDefault("ipFilterRuleName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "ipFilterRuleName", valid_564297
  var valid_564298 = path.getOrDefault("namespaceName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "namespaceName", valid_564298
  var valid_564299 = path.getOrDefault("subscriptionId")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "subscriptionId", valid_564299
  var valid_564300 = path.getOrDefault("resourceGroupName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "resourceGroupName", valid_564300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564301 = query.getOrDefault("api-version")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "api-version", valid_564301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564302: Call_NamespacesGetIpFilterRule_564294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an IpFilterRule for a Namespace by rule name.
  ## 
  let valid = call_564302.validator(path, query, header, formData, body)
  let scheme = call_564302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564302.url(scheme.get, call_564302.host, call_564302.base,
                         call_564302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564302, url, valid)

proc call*(call_564303: Call_NamespacesGetIpFilterRule_564294;
          ipFilterRuleName: string; apiVersion: string; namespaceName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesGetIpFilterRule
  ## Gets an IpFilterRule for a Namespace by rule name.
  ##   ipFilterRuleName: string (required)
  ##                   : The IP Filter Rule name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564304 = newJObject()
  var query_564305 = newJObject()
  add(path_564304, "ipFilterRuleName", newJString(ipFilterRuleName))
  add(query_564305, "api-version", newJString(apiVersion))
  add(path_564304, "namespaceName", newJString(namespaceName))
  add(path_564304, "subscriptionId", newJString(subscriptionId))
  add(path_564304, "resourceGroupName", newJString(resourceGroupName))
  result = call_564303.call(path_564304, query_564305, nil, nil, nil)

var namespacesGetIpFilterRule* = Call_NamespacesGetIpFilterRule_564294(
    name: "namespacesGetIpFilterRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/ipfilterrules/{ipFilterRuleName}",
    validator: validate_NamespacesGetIpFilterRule_564295, base: "",
    url: url_NamespacesGetIpFilterRule_564296, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteIpFilterRule_564320 = ref object of OpenApiRestCall_563555
proc url_NamespacesDeleteIpFilterRule_564322(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "ipFilterRuleName" in path,
        "`ipFilterRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/ipfilterrules/"),
               (kind: VariableSegment, value: "ipFilterRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDeleteIpFilterRule_564321(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an IpFilterRule for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ipFilterRuleName: JString (required)
  ##                   : The IP Filter Rule name.
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ipFilterRuleName` field"
  var valid_564323 = path.getOrDefault("ipFilterRuleName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "ipFilterRuleName", valid_564323
  var valid_564324 = path.getOrDefault("namespaceName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "namespaceName", valid_564324
  var valid_564325 = path.getOrDefault("subscriptionId")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "subscriptionId", valid_564325
  var valid_564326 = path.getOrDefault("resourceGroupName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "resourceGroupName", valid_564326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564327 = query.getOrDefault("api-version")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "api-version", valid_564327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564328: Call_NamespacesDeleteIpFilterRule_564320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an IpFilterRule for a Namespace.
  ## 
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_NamespacesDeleteIpFilterRule_564320;
          ipFilterRuleName: string; apiVersion: string; namespaceName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesDeleteIpFilterRule
  ## Deletes an IpFilterRule for a Namespace.
  ##   ipFilterRuleName: string (required)
  ##                   : The IP Filter Rule name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564330 = newJObject()
  var query_564331 = newJObject()
  add(path_564330, "ipFilterRuleName", newJString(ipFilterRuleName))
  add(query_564331, "api-version", newJString(apiVersion))
  add(path_564330, "namespaceName", newJString(namespaceName))
  add(path_564330, "subscriptionId", newJString(subscriptionId))
  add(path_564330, "resourceGroupName", newJString(resourceGroupName))
  result = call_564329.call(path_564330, query_564331, nil, nil, nil)

var namespacesDeleteIpFilterRule* = Call_NamespacesDeleteIpFilterRule_564320(
    name: "namespacesDeleteIpFilterRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/ipfilterrules/{ipFilterRuleName}",
    validator: validate_NamespacesDeleteIpFilterRule_564321, base: "",
    url: url_NamespacesDeleteIpFilterRule_564322, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateNetworkRuleSet_564343 = ref object of OpenApiRestCall_563555
proc url_NamespacesCreateOrUpdateNetworkRuleSet_564345(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/networkRuleSets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateNetworkRuleSet_564344(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update NetworkRuleSet for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564346 = path.getOrDefault("namespaceName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "namespaceName", valid_564346
  var valid_564347 = path.getOrDefault("subscriptionId")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "subscriptionId", valid_564347
  var valid_564348 = path.getOrDefault("resourceGroupName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "resourceGroupName", valid_564348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564349 = query.getOrDefault("api-version")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "api-version", valid_564349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Namespace IpFilterRule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564351: Call_NamespacesCreateOrUpdateNetworkRuleSet_564343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update NetworkRuleSet for a Namespace.
  ## 
  let valid = call_564351.validator(path, query, header, formData, body)
  let scheme = call_564351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564351.url(scheme.get, call_564351.host, call_564351.base,
                         call_564351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564351, url, valid)

proc call*(call_564352: Call_NamespacesCreateOrUpdateNetworkRuleSet_564343;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateNetworkRuleSet
  ## Create or update NetworkRuleSet for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : The Namespace IpFilterRule.
  var path_564353 = newJObject()
  var query_564354 = newJObject()
  var body_564355 = newJObject()
  add(query_564354, "api-version", newJString(apiVersion))
  add(path_564353, "namespaceName", newJString(namespaceName))
  add(path_564353, "subscriptionId", newJString(subscriptionId))
  add(path_564353, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564355 = parameters
  result = call_564352.call(path_564353, query_564354, nil, nil, body_564355)

var namespacesCreateOrUpdateNetworkRuleSet* = Call_NamespacesCreateOrUpdateNetworkRuleSet_564343(
    name: "namespacesCreateOrUpdateNetworkRuleSet", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/networkRuleSets/default",
    validator: validate_NamespacesCreateOrUpdateNetworkRuleSet_564344, base: "",
    url: url_NamespacesCreateOrUpdateNetworkRuleSet_564345,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetNetworkRuleSet_564332 = ref object of OpenApiRestCall_563555
proc url_NamespacesGetNetworkRuleSet_564334(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/networkRuleSets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetNetworkRuleSet_564333(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets NetworkRuleSet for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564335 = path.getOrDefault("namespaceName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "namespaceName", valid_564335
  var valid_564336 = path.getOrDefault("subscriptionId")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "subscriptionId", valid_564336
  var valid_564337 = path.getOrDefault("resourceGroupName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "resourceGroupName", valid_564337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564338 = query.getOrDefault("api-version")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "api-version", valid_564338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564339: Call_NamespacesGetNetworkRuleSet_564332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets NetworkRuleSet for a Namespace.
  ## 
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_NamespacesGetNetworkRuleSet_564332;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## namespacesGetNetworkRuleSet
  ## Gets NetworkRuleSet for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564341 = newJObject()
  var query_564342 = newJObject()
  add(query_564342, "api-version", newJString(apiVersion))
  add(path_564341, "namespaceName", newJString(namespaceName))
  add(path_564341, "subscriptionId", newJString(subscriptionId))
  add(path_564341, "resourceGroupName", newJString(resourceGroupName))
  result = call_564340.call(path_564341, query_564342, nil, nil, nil)

var namespacesGetNetworkRuleSet* = Call_NamespacesGetNetworkRuleSet_564332(
    name: "namespacesGetNetworkRuleSet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/networkRuleSets/default",
    validator: validate_NamespacesGetNetworkRuleSet_564333, base: "",
    url: url_NamespacesGetNetworkRuleSet_564334, schemes: {Scheme.Https})
type
  Call_NamespacesListVirtualNetworkRules_564356 = ref object of OpenApiRestCall_563555
proc url_NamespacesListVirtualNetworkRules_564358(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/virtualnetworkrules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListVirtualNetworkRules_564357(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of VirtualNetwork rules for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564359 = path.getOrDefault("namespaceName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "namespaceName", valid_564359
  var valid_564360 = path.getOrDefault("subscriptionId")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "subscriptionId", valid_564360
  var valid_564361 = path.getOrDefault("resourceGroupName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "resourceGroupName", valid_564361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564362 = query.getOrDefault("api-version")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "api-version", valid_564362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564363: Call_NamespacesListVirtualNetworkRules_564356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of VirtualNetwork rules for a Namespace.
  ## 
  let valid = call_564363.validator(path, query, header, formData, body)
  let scheme = call_564363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564363.url(scheme.get, call_564363.host, call_564363.base,
                         call_564363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564363, url, valid)

proc call*(call_564364: Call_NamespacesListVirtualNetworkRules_564356;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## namespacesListVirtualNetworkRules
  ## Gets a list of VirtualNetwork rules for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564365 = newJObject()
  var query_564366 = newJObject()
  add(query_564366, "api-version", newJString(apiVersion))
  add(path_564365, "namespaceName", newJString(namespaceName))
  add(path_564365, "subscriptionId", newJString(subscriptionId))
  add(path_564365, "resourceGroupName", newJString(resourceGroupName))
  result = call_564364.call(path_564365, query_564366, nil, nil, nil)

var namespacesListVirtualNetworkRules* = Call_NamespacesListVirtualNetworkRules_564356(
    name: "namespacesListVirtualNetworkRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/virtualnetworkrules",
    validator: validate_NamespacesListVirtualNetworkRules_564357, base: "",
    url: url_NamespacesListVirtualNetworkRules_564358, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateVirtualNetworkRule_564379 = ref object of OpenApiRestCall_563555
proc url_NamespacesCreateOrUpdateVirtualNetworkRule_564381(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/virtualnetworkrules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateVirtualNetworkRule_564380(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an VirtualNetworkRule for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The Virtual Network Rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564382 = path.getOrDefault("namespaceName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "namespaceName", valid_564382
  var valid_564383 = path.getOrDefault("virtualNetworkRuleName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "virtualNetworkRuleName", valid_564383
  var valid_564384 = path.getOrDefault("subscriptionId")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "subscriptionId", valid_564384
  var valid_564385 = path.getOrDefault("resourceGroupName")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "resourceGroupName", valid_564385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564386 = query.getOrDefault("api-version")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "api-version", valid_564386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Namespace VirtualNetworkRule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564388: Call_NamespacesCreateOrUpdateVirtualNetworkRule_564379;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an VirtualNetworkRule for a Namespace.
  ## 
  let valid = call_564388.validator(path, query, header, formData, body)
  let scheme = call_564388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564388.url(scheme.get, call_564388.host, call_564388.base,
                         call_564388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564388, url, valid)

proc call*(call_564389: Call_NamespacesCreateOrUpdateVirtualNetworkRule_564379;
          apiVersion: string; namespaceName: string; virtualNetworkRuleName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateVirtualNetworkRule
  ## Creates or updates an VirtualNetworkRule for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   virtualNetworkRuleName: string (required)
  ##                         : The Virtual Network Rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : The Namespace VirtualNetworkRule.
  var path_564390 = newJObject()
  var query_564391 = newJObject()
  var body_564392 = newJObject()
  add(query_564391, "api-version", newJString(apiVersion))
  add(path_564390, "namespaceName", newJString(namespaceName))
  add(path_564390, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  add(path_564390, "subscriptionId", newJString(subscriptionId))
  add(path_564390, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564392 = parameters
  result = call_564389.call(path_564390, query_564391, nil, nil, body_564392)

var namespacesCreateOrUpdateVirtualNetworkRule* = Call_NamespacesCreateOrUpdateVirtualNetworkRule_564379(
    name: "namespacesCreateOrUpdateVirtualNetworkRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/virtualnetworkrules/{virtualNetworkRuleName}",
    validator: validate_NamespacesCreateOrUpdateVirtualNetworkRule_564380,
    base: "", url: url_NamespacesCreateOrUpdateVirtualNetworkRule_564381,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetVirtualNetworkRule_564367 = ref object of OpenApiRestCall_563555
proc url_NamespacesGetVirtualNetworkRule_564369(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/virtualnetworkrules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetVirtualNetworkRule_564368(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an VirtualNetworkRule for a Namespace by rule name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The Virtual Network Rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564370 = path.getOrDefault("namespaceName")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "namespaceName", valid_564370
  var valid_564371 = path.getOrDefault("virtualNetworkRuleName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "virtualNetworkRuleName", valid_564371
  var valid_564372 = path.getOrDefault("subscriptionId")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "subscriptionId", valid_564372
  var valid_564373 = path.getOrDefault("resourceGroupName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "resourceGroupName", valid_564373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564375: Call_NamespacesGetVirtualNetworkRule_564367;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an VirtualNetworkRule for a Namespace by rule name.
  ## 
  let valid = call_564375.validator(path, query, header, formData, body)
  let scheme = call_564375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564375.url(scheme.get, call_564375.host, call_564375.base,
                         call_564375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564375, url, valid)

proc call*(call_564376: Call_NamespacesGetVirtualNetworkRule_564367;
          apiVersion: string; namespaceName: string; virtualNetworkRuleName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesGetVirtualNetworkRule
  ## Gets an VirtualNetworkRule for a Namespace by rule name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   virtualNetworkRuleName: string (required)
  ##                         : The Virtual Network Rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564377 = newJObject()
  var query_564378 = newJObject()
  add(query_564378, "api-version", newJString(apiVersion))
  add(path_564377, "namespaceName", newJString(namespaceName))
  add(path_564377, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  add(path_564377, "subscriptionId", newJString(subscriptionId))
  add(path_564377, "resourceGroupName", newJString(resourceGroupName))
  result = call_564376.call(path_564377, query_564378, nil, nil, nil)

var namespacesGetVirtualNetworkRule* = Call_NamespacesGetVirtualNetworkRule_564367(
    name: "namespacesGetVirtualNetworkRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/virtualnetworkrules/{virtualNetworkRuleName}",
    validator: validate_NamespacesGetVirtualNetworkRule_564368, base: "",
    url: url_NamespacesGetVirtualNetworkRule_564369, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteVirtualNetworkRule_564393 = ref object of OpenApiRestCall_563555
proc url_NamespacesDeleteVirtualNetworkRule_564395(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/virtualnetworkrules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDeleteVirtualNetworkRule_564394(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an VirtualNetworkRule for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The Virtual Network Rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564396 = path.getOrDefault("namespaceName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "namespaceName", valid_564396
  var valid_564397 = path.getOrDefault("virtualNetworkRuleName")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "virtualNetworkRuleName", valid_564397
  var valid_564398 = path.getOrDefault("subscriptionId")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "subscriptionId", valid_564398
  var valid_564399 = path.getOrDefault("resourceGroupName")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "resourceGroupName", valid_564399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564401: Call_NamespacesDeleteVirtualNetworkRule_564393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an VirtualNetworkRule for a Namespace.
  ## 
  let valid = call_564401.validator(path, query, header, formData, body)
  let scheme = call_564401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564401.url(scheme.get, call_564401.host, call_564401.base,
                         call_564401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564401, url, valid)

proc call*(call_564402: Call_NamespacesDeleteVirtualNetworkRule_564393;
          apiVersion: string; namespaceName: string; virtualNetworkRuleName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesDeleteVirtualNetworkRule
  ## Deletes an VirtualNetworkRule for a Namespace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   virtualNetworkRuleName: string (required)
  ##                         : The Virtual Network Rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the Azure subscription.
  var path_564403 = newJObject()
  var query_564404 = newJObject()
  add(query_564404, "api-version", newJString(apiVersion))
  add(path_564403, "namespaceName", newJString(namespaceName))
  add(path_564403, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  add(path_564403, "subscriptionId", newJString(subscriptionId))
  add(path_564403, "resourceGroupName", newJString(resourceGroupName))
  result = call_564402.call(path_564403, query_564404, nil, nil, nil)

var namespacesDeleteVirtualNetworkRule* = Call_NamespacesDeleteVirtualNetworkRule_564393(
    name: "namespacesDeleteVirtualNetworkRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/virtualnetworkrules/{virtualNetworkRuleName}",
    validator: validate_NamespacesDeleteVirtualNetworkRule_564394, base: "",
    url: url_NamespacesDeleteVirtualNetworkRule_564395, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
