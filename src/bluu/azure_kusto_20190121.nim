
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: KustoManagementClient
## version: 2019-01-21
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

  OpenApiRestCall_574458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574458): Option[Scheme] {.used.} =
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
  macServiceName = "azure-kusto"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_574680 = ref object of OpenApiRestCall_574458
proc url_OperationsList_574682(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574681(path: JsonNode; query: JsonNode;
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
  var valid_574841 = query.getOrDefault("api-version")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = nil)
  if valid_574841 != nil:
    section.add "api-version", valid_574841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574864: Call_OperationsList_574680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the Microsoft.Kusto provider.
  ## 
  let valid = call_574864.validator(path, query, header, formData, body)
  let scheme = call_574864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574864.url(scheme.get, call_574864.host, call_574864.base,
                         call_574864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574864, url, valid)

proc call*(call_574935: Call_OperationsList_574680; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the Microsoft.Kusto provider.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_574936 = newJObject()
  add(query_574936, "api-version", newJString(apiVersion))
  result = call_574935.call(nil, query_574936, nil, nil, nil)

var operationsList* = Call_OperationsList_574680(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Kusto/operations",
    validator: validate_OperationsList_574681, base: "", url: url_OperationsList_574682,
    schemes: {Scheme.Https})
type
  Call_ClustersList_574976 = ref object of OpenApiRestCall_574458
proc url_ClustersList_574978(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersList_574977(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574993 = path.getOrDefault("subscriptionId")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "subscriptionId", valid_574993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574994 = query.getOrDefault("api-version")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "api-version", valid_574994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574995: Call_ClustersList_574976; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Kusto clusters within a subscription.
  ## 
  let valid = call_574995.validator(path, query, header, formData, body)
  let scheme = call_574995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574995.url(scheme.get, call_574995.host, call_574995.base,
                         call_574995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574995, url, valid)

proc call*(call_574996: Call_ClustersList_574976; apiVersion: string;
          subscriptionId: string): Recallable =
  ## clustersList
  ## Lists all Kusto clusters within a subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574997 = newJObject()
  var query_574998 = newJObject()
  add(query_574998, "api-version", newJString(apiVersion))
  add(path_574997, "subscriptionId", newJString(subscriptionId))
  result = call_574996.call(path_574997, query_574998, nil, nil, nil)

var clustersList* = Call_ClustersList_574976(name: "clustersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Kusto/clusters",
    validator: validate_ClustersList_574977, base: "", url: url_ClustersList_574978,
    schemes: {Scheme.Https})
type
  Call_ClustersCheckNameAvailability_574999 = ref object of OpenApiRestCall_574458
proc url_ClustersCheckNameAvailability_575001(protocol: Scheme; host: string;
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

proc validate_ClustersCheckNameAvailability_575000(path: JsonNode; query: JsonNode;
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
  var valid_575002 = path.getOrDefault("subscriptionId")
  valid_575002 = validateParameter(valid_575002, JString, required = true,
                                 default = nil)
  if valid_575002 != nil:
    section.add "subscriptionId", valid_575002
  var valid_575003 = path.getOrDefault("location")
  valid_575003 = validateParameter(valid_575003, JString, required = true,
                                 default = nil)
  if valid_575003 != nil:
    section.add "location", valid_575003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575004 = query.getOrDefault("api-version")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "api-version", valid_575004
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

proc call*(call_575006: Call_ClustersCheckNameAvailability_574999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the cluster name is valid and is not already in use.
  ## 
  let valid = call_575006.validator(path, query, header, formData, body)
  let scheme = call_575006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575006.url(scheme.get, call_575006.host, call_575006.base,
                         call_575006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575006, url, valid)

proc call*(call_575007: Call_ClustersCheckNameAvailability_574999;
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
  var path_575008 = newJObject()
  var query_575009 = newJObject()
  var body_575010 = newJObject()
  add(query_575009, "api-version", newJString(apiVersion))
  add(path_575008, "subscriptionId", newJString(subscriptionId))
  if clusterName != nil:
    body_575010 = clusterName
  add(path_575008, "location", newJString(location))
  result = call_575007.call(path_575008, query_575009, nil, nil, body_575010)

var clustersCheckNameAvailability* = Call_ClustersCheckNameAvailability_574999(
    name: "clustersCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Kusto/locations/{location}/checkNameAvailability",
    validator: validate_ClustersCheckNameAvailability_575000, base: "",
    url: url_ClustersCheckNameAvailability_575001, schemes: {Scheme.Https})
type
  Call_ClustersListSkus_575011 = ref object of OpenApiRestCall_574458
proc url_ClustersListSkus_575013(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersListSkus_575012(path: JsonNode; query: JsonNode;
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
  var valid_575014 = path.getOrDefault("subscriptionId")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "subscriptionId", valid_575014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575015 = query.getOrDefault("api-version")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = nil)
  if valid_575015 != nil:
    section.add "api-version", valid_575015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575016: Call_ClustersListSkus_575011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists eligible SKUs for Kusto resource provider.
  ## 
  let valid = call_575016.validator(path, query, header, formData, body)
  let scheme = call_575016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575016.url(scheme.get, call_575016.host, call_575016.base,
                         call_575016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575016, url, valid)

proc call*(call_575017: Call_ClustersListSkus_575011; apiVersion: string;
          subscriptionId: string): Recallable =
  ## clustersListSkus
  ## Lists eligible SKUs for Kusto resource provider.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575018 = newJObject()
  var query_575019 = newJObject()
  add(query_575019, "api-version", newJString(apiVersion))
  add(path_575018, "subscriptionId", newJString(subscriptionId))
  result = call_575017.call(path_575018, query_575019, nil, nil, nil)

var clustersListSkus* = Call_ClustersListSkus_575011(name: "clustersListSkus",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers/Microsoft.Kusto/skus",
    validator: validate_ClustersListSkus_575012, base: "",
    url: url_ClustersListSkus_575013, schemes: {Scheme.Https})
type
  Call_ClustersListByResourceGroup_575020 = ref object of OpenApiRestCall_574458
proc url_ClustersListByResourceGroup_575022(protocol: Scheme; host: string;
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

proc validate_ClustersListByResourceGroup_575021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Kusto clusters within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575023 = path.getOrDefault("resourceGroupName")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = nil)
  if valid_575023 != nil:
    section.add "resourceGroupName", valid_575023
  var valid_575024 = path.getOrDefault("subscriptionId")
  valid_575024 = validateParameter(valid_575024, JString, required = true,
                                 default = nil)
  if valid_575024 != nil:
    section.add "subscriptionId", valid_575024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575025 = query.getOrDefault("api-version")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = nil)
  if valid_575025 != nil:
    section.add "api-version", valid_575025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575026: Call_ClustersListByResourceGroup_575020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Kusto clusters within a resource group.
  ## 
  let valid = call_575026.validator(path, query, header, formData, body)
  let scheme = call_575026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575026.url(scheme.get, call_575026.host, call_575026.base,
                         call_575026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575026, url, valid)

proc call*(call_575027: Call_ClustersListByResourceGroup_575020;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## clustersListByResourceGroup
  ## Lists all Kusto clusters within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575028 = newJObject()
  var query_575029 = newJObject()
  add(path_575028, "resourceGroupName", newJString(resourceGroupName))
  add(query_575029, "api-version", newJString(apiVersion))
  add(path_575028, "subscriptionId", newJString(subscriptionId))
  result = call_575027.call(path_575028, query_575029, nil, nil, nil)

var clustersListByResourceGroup* = Call_ClustersListByResourceGroup_575020(
    name: "clustersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters",
    validator: validate_ClustersListByResourceGroup_575021, base: "",
    url: url_ClustersListByResourceGroup_575022, schemes: {Scheme.Https})
type
  Call_ClustersCreateOrUpdate_575041 = ref object of OpenApiRestCall_574458
proc url_ClustersCreateOrUpdate_575043(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersCreateOrUpdate_575042(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575061 = path.getOrDefault("clusterName")
  valid_575061 = validateParameter(valid_575061, JString, required = true,
                                 default = nil)
  if valid_575061 != nil:
    section.add "clusterName", valid_575061
  var valid_575062 = path.getOrDefault("resourceGroupName")
  valid_575062 = validateParameter(valid_575062, JString, required = true,
                                 default = nil)
  if valid_575062 != nil:
    section.add "resourceGroupName", valid_575062
  var valid_575063 = path.getOrDefault("subscriptionId")
  valid_575063 = validateParameter(valid_575063, JString, required = true,
                                 default = nil)
  if valid_575063 != nil:
    section.add "subscriptionId", valid_575063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575064 = query.getOrDefault("api-version")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "api-version", valid_575064
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

proc call*(call_575066: Call_ClustersCreateOrUpdate_575041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Kusto cluster.
  ## 
  let valid = call_575066.validator(path, query, header, formData, body)
  let scheme = call_575066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575066.url(scheme.get, call_575066.host, call_575066.base,
                         call_575066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575066, url, valid)

proc call*(call_575067: Call_ClustersCreateOrUpdate_575041; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## clustersCreateOrUpdate
  ## Create or update a Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The Kusto cluster parameters supplied to the CreateOrUpdate operation.
  var path_575068 = newJObject()
  var query_575069 = newJObject()
  var body_575070 = newJObject()
  add(path_575068, "clusterName", newJString(clusterName))
  add(path_575068, "resourceGroupName", newJString(resourceGroupName))
  add(query_575069, "api-version", newJString(apiVersion))
  add(path_575068, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575070 = parameters
  result = call_575067.call(path_575068, query_575069, nil, nil, body_575070)

var clustersCreateOrUpdate* = Call_ClustersCreateOrUpdate_575041(
    name: "clustersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}",
    validator: validate_ClustersCreateOrUpdate_575042, base: "",
    url: url_ClustersCreateOrUpdate_575043, schemes: {Scheme.Https})
type
  Call_ClustersGet_575030 = ref object of OpenApiRestCall_574458
proc url_ClustersGet_575032(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersGet_575031(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575033 = path.getOrDefault("clusterName")
  valid_575033 = validateParameter(valid_575033, JString, required = true,
                                 default = nil)
  if valid_575033 != nil:
    section.add "clusterName", valid_575033
  var valid_575034 = path.getOrDefault("resourceGroupName")
  valid_575034 = validateParameter(valid_575034, JString, required = true,
                                 default = nil)
  if valid_575034 != nil:
    section.add "resourceGroupName", valid_575034
  var valid_575035 = path.getOrDefault("subscriptionId")
  valid_575035 = validateParameter(valid_575035, JString, required = true,
                                 default = nil)
  if valid_575035 != nil:
    section.add "subscriptionId", valid_575035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575036 = query.getOrDefault("api-version")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = nil)
  if valid_575036 != nil:
    section.add "api-version", valid_575036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575037: Call_ClustersGet_575030; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Kusto cluster.
  ## 
  let valid = call_575037.validator(path, query, header, formData, body)
  let scheme = call_575037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575037.url(scheme.get, call_575037.host, call_575037.base,
                         call_575037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575037, url, valid)

proc call*(call_575038: Call_ClustersGet_575030; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## clustersGet
  ## Gets a Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575039 = newJObject()
  var query_575040 = newJObject()
  add(path_575039, "clusterName", newJString(clusterName))
  add(path_575039, "resourceGroupName", newJString(resourceGroupName))
  add(query_575040, "api-version", newJString(apiVersion))
  add(path_575039, "subscriptionId", newJString(subscriptionId))
  result = call_575038.call(path_575039, query_575040, nil, nil, nil)

var clustersGet* = Call_ClustersGet_575030(name: "clustersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}",
                                        validator: validate_ClustersGet_575031,
                                        base: "", url: url_ClustersGet_575032,
                                        schemes: {Scheme.Https})
type
  Call_ClustersUpdate_575082 = ref object of OpenApiRestCall_574458
proc url_ClustersUpdate_575084(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersUpdate_575083(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update a Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575085 = path.getOrDefault("clusterName")
  valid_575085 = validateParameter(valid_575085, JString, required = true,
                                 default = nil)
  if valid_575085 != nil:
    section.add "clusterName", valid_575085
  var valid_575086 = path.getOrDefault("resourceGroupName")
  valid_575086 = validateParameter(valid_575086, JString, required = true,
                                 default = nil)
  if valid_575086 != nil:
    section.add "resourceGroupName", valid_575086
  var valid_575087 = path.getOrDefault("subscriptionId")
  valid_575087 = validateParameter(valid_575087, JString, required = true,
                                 default = nil)
  if valid_575087 != nil:
    section.add "subscriptionId", valid_575087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575088 = query.getOrDefault("api-version")
  valid_575088 = validateParameter(valid_575088, JString, required = true,
                                 default = nil)
  if valid_575088 != nil:
    section.add "api-version", valid_575088
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

proc call*(call_575090: Call_ClustersUpdate_575082; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Kusto cluster.
  ## 
  let valid = call_575090.validator(path, query, header, formData, body)
  let scheme = call_575090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575090.url(scheme.get, call_575090.host, call_575090.base,
                         call_575090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575090, url, valid)

proc call*(call_575091: Call_ClustersUpdate_575082; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## clustersUpdate
  ## Update a Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The Kusto cluster parameters supplied to the Update operation.
  var path_575092 = newJObject()
  var query_575093 = newJObject()
  var body_575094 = newJObject()
  add(path_575092, "clusterName", newJString(clusterName))
  add(path_575092, "resourceGroupName", newJString(resourceGroupName))
  add(query_575093, "api-version", newJString(apiVersion))
  add(path_575092, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575094 = parameters
  result = call_575091.call(path_575092, query_575093, nil, nil, body_575094)

var clustersUpdate* = Call_ClustersUpdate_575082(name: "clustersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}",
    validator: validate_ClustersUpdate_575083, base: "", url: url_ClustersUpdate_575084,
    schemes: {Scheme.Https})
type
  Call_ClustersDelete_575071 = ref object of OpenApiRestCall_574458
proc url_ClustersDelete_575073(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersDelete_575072(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575074 = path.getOrDefault("clusterName")
  valid_575074 = validateParameter(valid_575074, JString, required = true,
                                 default = nil)
  if valid_575074 != nil:
    section.add "clusterName", valid_575074
  var valid_575075 = path.getOrDefault("resourceGroupName")
  valid_575075 = validateParameter(valid_575075, JString, required = true,
                                 default = nil)
  if valid_575075 != nil:
    section.add "resourceGroupName", valid_575075
  var valid_575076 = path.getOrDefault("subscriptionId")
  valid_575076 = validateParameter(valid_575076, JString, required = true,
                                 default = nil)
  if valid_575076 != nil:
    section.add "subscriptionId", valid_575076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575077 = query.getOrDefault("api-version")
  valid_575077 = validateParameter(valid_575077, JString, required = true,
                                 default = nil)
  if valid_575077 != nil:
    section.add "api-version", valid_575077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575078: Call_ClustersDelete_575071; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Kusto cluster.
  ## 
  let valid = call_575078.validator(path, query, header, formData, body)
  let scheme = call_575078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575078.url(scheme.get, call_575078.host, call_575078.base,
                         call_575078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575078, url, valid)

proc call*(call_575079: Call_ClustersDelete_575071; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## clustersDelete
  ## Deletes a Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575080 = newJObject()
  var query_575081 = newJObject()
  add(path_575080, "clusterName", newJString(clusterName))
  add(path_575080, "resourceGroupName", newJString(resourceGroupName))
  add(query_575081, "api-version", newJString(apiVersion))
  add(path_575080, "subscriptionId", newJString(subscriptionId))
  result = call_575079.call(path_575080, query_575081, nil, nil, nil)

var clustersDelete* = Call_ClustersDelete_575071(name: "clustersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}",
    validator: validate_ClustersDelete_575072, base: "", url: url_ClustersDelete_575073,
    schemes: {Scheme.Https})
type
  Call_DatabasesCheckNameAvailability_575095 = ref object of OpenApiRestCall_574458
proc url_DatabasesCheckNameAvailability_575097(protocol: Scheme; host: string;
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

proc validate_DatabasesCheckNameAvailability_575096(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the database name is valid and is not already in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575098 = path.getOrDefault("clusterName")
  valid_575098 = validateParameter(valid_575098, JString, required = true,
                                 default = nil)
  if valid_575098 != nil:
    section.add "clusterName", valid_575098
  var valid_575099 = path.getOrDefault("resourceGroupName")
  valid_575099 = validateParameter(valid_575099, JString, required = true,
                                 default = nil)
  if valid_575099 != nil:
    section.add "resourceGroupName", valid_575099
  var valid_575100 = path.getOrDefault("subscriptionId")
  valid_575100 = validateParameter(valid_575100, JString, required = true,
                                 default = nil)
  if valid_575100 != nil:
    section.add "subscriptionId", valid_575100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575101 = query.getOrDefault("api-version")
  valid_575101 = validateParameter(valid_575101, JString, required = true,
                                 default = nil)
  if valid_575101 != nil:
    section.add "api-version", valid_575101
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

proc call*(call_575103: Call_DatabasesCheckNameAvailability_575095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the database name is valid and is not already in use.
  ## 
  let valid = call_575103.validator(path, query, header, formData, body)
  let scheme = call_575103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575103.url(scheme.get, call_575103.host, call_575103.base,
                         call_575103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575103, url, valid)

proc call*(call_575104: Call_DatabasesCheckNameAvailability_575095;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; databaseName: JsonNode): Recallable =
  ## databasesCheckNameAvailability
  ## Checks that the database name is valid and is not already in use.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JObject (required)
  ##               : The name of the database.
  var path_575105 = newJObject()
  var query_575106 = newJObject()
  var body_575107 = newJObject()
  add(path_575105, "clusterName", newJString(clusterName))
  add(path_575105, "resourceGroupName", newJString(resourceGroupName))
  add(query_575106, "api-version", newJString(apiVersion))
  add(path_575105, "subscriptionId", newJString(subscriptionId))
  if databaseName != nil:
    body_575107 = databaseName
  result = call_575104.call(path_575105, query_575106, nil, nil, body_575107)

var databasesCheckNameAvailability* = Call_DatabasesCheckNameAvailability_575095(
    name: "databasesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/checkNameAvailability",
    validator: validate_DatabasesCheckNameAvailability_575096, base: "",
    url: url_DatabasesCheckNameAvailability_575097, schemes: {Scheme.Https})
type
  Call_DatabasesListByCluster_575108 = ref object of OpenApiRestCall_574458
proc url_DatabasesListByCluster_575110(protocol: Scheme; host: string; base: string;
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

proc validate_DatabasesListByCluster_575109(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of databases of the given Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575111 = path.getOrDefault("clusterName")
  valid_575111 = validateParameter(valid_575111, JString, required = true,
                                 default = nil)
  if valid_575111 != nil:
    section.add "clusterName", valid_575111
  var valid_575112 = path.getOrDefault("resourceGroupName")
  valid_575112 = validateParameter(valid_575112, JString, required = true,
                                 default = nil)
  if valid_575112 != nil:
    section.add "resourceGroupName", valid_575112
  var valid_575113 = path.getOrDefault("subscriptionId")
  valid_575113 = validateParameter(valid_575113, JString, required = true,
                                 default = nil)
  if valid_575113 != nil:
    section.add "subscriptionId", valid_575113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575114 = query.getOrDefault("api-version")
  valid_575114 = validateParameter(valid_575114, JString, required = true,
                                 default = nil)
  if valid_575114 != nil:
    section.add "api-version", valid_575114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575115: Call_DatabasesListByCluster_575108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of databases of the given Kusto cluster.
  ## 
  let valid = call_575115.validator(path, query, header, formData, body)
  let scheme = call_575115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575115.url(scheme.get, call_575115.host, call_575115.base,
                         call_575115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575115, url, valid)

proc call*(call_575116: Call_DatabasesListByCluster_575108; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## databasesListByCluster
  ## Returns the list of databases of the given Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575117 = newJObject()
  var query_575118 = newJObject()
  add(path_575117, "clusterName", newJString(clusterName))
  add(path_575117, "resourceGroupName", newJString(resourceGroupName))
  add(query_575118, "api-version", newJString(apiVersion))
  add(path_575117, "subscriptionId", newJString(subscriptionId))
  result = call_575116.call(path_575117, query_575118, nil, nil, nil)

var databasesListByCluster* = Call_DatabasesListByCluster_575108(
    name: "databasesListByCluster", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases",
    validator: validate_DatabasesListByCluster_575109, base: "",
    url: url_DatabasesListByCluster_575110, schemes: {Scheme.Https})
type
  Call_DatabasesCreateOrUpdate_575131 = ref object of OpenApiRestCall_574458
proc url_DatabasesCreateOrUpdate_575133(protocol: Scheme; host: string; base: string;
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

proc validate_DatabasesCreateOrUpdate_575132(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575134 = path.getOrDefault("clusterName")
  valid_575134 = validateParameter(valid_575134, JString, required = true,
                                 default = nil)
  if valid_575134 != nil:
    section.add "clusterName", valid_575134
  var valid_575135 = path.getOrDefault("resourceGroupName")
  valid_575135 = validateParameter(valid_575135, JString, required = true,
                                 default = nil)
  if valid_575135 != nil:
    section.add "resourceGroupName", valid_575135
  var valid_575136 = path.getOrDefault("subscriptionId")
  valid_575136 = validateParameter(valid_575136, JString, required = true,
                                 default = nil)
  if valid_575136 != nil:
    section.add "subscriptionId", valid_575136
  var valid_575137 = path.getOrDefault("databaseName")
  valid_575137 = validateParameter(valid_575137, JString, required = true,
                                 default = nil)
  if valid_575137 != nil:
    section.add "databaseName", valid_575137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575138 = query.getOrDefault("api-version")
  valid_575138 = validateParameter(valid_575138, JString, required = true,
                                 default = nil)
  if valid_575138 != nil:
    section.add "api-version", valid_575138
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

proc call*(call_575140: Call_DatabasesCreateOrUpdate_575131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a database.
  ## 
  let valid = call_575140.validator(path, query, header, formData, body)
  let scheme = call_575140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575140.url(scheme.get, call_575140.host, call_575140.base,
                         call_575140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575140, url, valid)

proc call*(call_575141: Call_DatabasesCreateOrUpdate_575131; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; parameters: JsonNode): Recallable =
  ## databasesCreateOrUpdate
  ## Creates or updates a database.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   parameters: JObject (required)
  ##             : The database parameters supplied to the CreateOrUpdate operation.
  var path_575142 = newJObject()
  var query_575143 = newJObject()
  var body_575144 = newJObject()
  add(path_575142, "clusterName", newJString(clusterName))
  add(path_575142, "resourceGroupName", newJString(resourceGroupName))
  add(query_575143, "api-version", newJString(apiVersion))
  add(path_575142, "subscriptionId", newJString(subscriptionId))
  add(path_575142, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_575144 = parameters
  result = call_575141.call(path_575142, query_575143, nil, nil, body_575144)

var databasesCreateOrUpdate* = Call_DatabasesCreateOrUpdate_575131(
    name: "databasesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}",
    validator: validate_DatabasesCreateOrUpdate_575132, base: "",
    url: url_DatabasesCreateOrUpdate_575133, schemes: {Scheme.Https})
type
  Call_DatabasesGet_575119 = ref object of OpenApiRestCall_574458
proc url_DatabasesGet_575121(protocol: Scheme; host: string; base: string;
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

proc validate_DatabasesGet_575120(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575122 = path.getOrDefault("clusterName")
  valid_575122 = validateParameter(valid_575122, JString, required = true,
                                 default = nil)
  if valid_575122 != nil:
    section.add "clusterName", valid_575122
  var valid_575123 = path.getOrDefault("resourceGroupName")
  valid_575123 = validateParameter(valid_575123, JString, required = true,
                                 default = nil)
  if valid_575123 != nil:
    section.add "resourceGroupName", valid_575123
  var valid_575124 = path.getOrDefault("subscriptionId")
  valid_575124 = validateParameter(valid_575124, JString, required = true,
                                 default = nil)
  if valid_575124 != nil:
    section.add "subscriptionId", valid_575124
  var valid_575125 = path.getOrDefault("databaseName")
  valid_575125 = validateParameter(valid_575125, JString, required = true,
                                 default = nil)
  if valid_575125 != nil:
    section.add "databaseName", valid_575125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575126 = query.getOrDefault("api-version")
  valid_575126 = validateParameter(valid_575126, JString, required = true,
                                 default = nil)
  if valid_575126 != nil:
    section.add "api-version", valid_575126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575127: Call_DatabasesGet_575119; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a database.
  ## 
  let valid = call_575127.validator(path, query, header, formData, body)
  let scheme = call_575127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575127.url(scheme.get, call_575127.host, call_575127.base,
                         call_575127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575127, url, valid)

proc call*(call_575128: Call_DatabasesGet_575119; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string): Recallable =
  ## databasesGet
  ## Returns a database.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  var path_575129 = newJObject()
  var query_575130 = newJObject()
  add(path_575129, "clusterName", newJString(clusterName))
  add(path_575129, "resourceGroupName", newJString(resourceGroupName))
  add(query_575130, "api-version", newJString(apiVersion))
  add(path_575129, "subscriptionId", newJString(subscriptionId))
  add(path_575129, "databaseName", newJString(databaseName))
  result = call_575128.call(path_575129, query_575130, nil, nil, nil)

var databasesGet* = Call_DatabasesGet_575119(name: "databasesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}",
    validator: validate_DatabasesGet_575120, base: "", url: url_DatabasesGet_575121,
    schemes: {Scheme.Https})
type
  Call_DatabasesUpdate_575157 = ref object of OpenApiRestCall_574458
proc url_DatabasesUpdate_575159(protocol: Scheme; host: string; base: string;
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

proc validate_DatabasesUpdate_575158(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575160 = path.getOrDefault("clusterName")
  valid_575160 = validateParameter(valid_575160, JString, required = true,
                                 default = nil)
  if valid_575160 != nil:
    section.add "clusterName", valid_575160
  var valid_575161 = path.getOrDefault("resourceGroupName")
  valid_575161 = validateParameter(valid_575161, JString, required = true,
                                 default = nil)
  if valid_575161 != nil:
    section.add "resourceGroupName", valid_575161
  var valid_575162 = path.getOrDefault("subscriptionId")
  valid_575162 = validateParameter(valid_575162, JString, required = true,
                                 default = nil)
  if valid_575162 != nil:
    section.add "subscriptionId", valid_575162
  var valid_575163 = path.getOrDefault("databaseName")
  valid_575163 = validateParameter(valid_575163, JString, required = true,
                                 default = nil)
  if valid_575163 != nil:
    section.add "databaseName", valid_575163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575164 = query.getOrDefault("api-version")
  valid_575164 = validateParameter(valid_575164, JString, required = true,
                                 default = nil)
  if valid_575164 != nil:
    section.add "api-version", valid_575164
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

proc call*(call_575166: Call_DatabasesUpdate_575157; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a database.
  ## 
  let valid = call_575166.validator(path, query, header, formData, body)
  let scheme = call_575166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575166.url(scheme.get, call_575166.host, call_575166.base,
                         call_575166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575166, url, valid)

proc call*(call_575167: Call_DatabasesUpdate_575157; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; parameters: JsonNode): Recallable =
  ## databasesUpdate
  ## Updates a database.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   parameters: JObject (required)
  ##             : The database parameters supplied to the Update operation.
  var path_575168 = newJObject()
  var query_575169 = newJObject()
  var body_575170 = newJObject()
  add(path_575168, "clusterName", newJString(clusterName))
  add(path_575168, "resourceGroupName", newJString(resourceGroupName))
  add(query_575169, "api-version", newJString(apiVersion))
  add(path_575168, "subscriptionId", newJString(subscriptionId))
  add(path_575168, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_575170 = parameters
  result = call_575167.call(path_575168, query_575169, nil, nil, body_575170)

var databasesUpdate* = Call_DatabasesUpdate_575157(name: "databasesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}",
    validator: validate_DatabasesUpdate_575158, base: "", url: url_DatabasesUpdate_575159,
    schemes: {Scheme.Https})
type
  Call_DatabasesDelete_575145 = ref object of OpenApiRestCall_574458
proc url_DatabasesDelete_575147(protocol: Scheme; host: string; base: string;
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

proc validate_DatabasesDelete_575146(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the database with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575148 = path.getOrDefault("clusterName")
  valid_575148 = validateParameter(valid_575148, JString, required = true,
                                 default = nil)
  if valid_575148 != nil:
    section.add "clusterName", valid_575148
  var valid_575149 = path.getOrDefault("resourceGroupName")
  valid_575149 = validateParameter(valid_575149, JString, required = true,
                                 default = nil)
  if valid_575149 != nil:
    section.add "resourceGroupName", valid_575149
  var valid_575150 = path.getOrDefault("subscriptionId")
  valid_575150 = validateParameter(valid_575150, JString, required = true,
                                 default = nil)
  if valid_575150 != nil:
    section.add "subscriptionId", valid_575150
  var valid_575151 = path.getOrDefault("databaseName")
  valid_575151 = validateParameter(valid_575151, JString, required = true,
                                 default = nil)
  if valid_575151 != nil:
    section.add "databaseName", valid_575151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575152 = query.getOrDefault("api-version")
  valid_575152 = validateParameter(valid_575152, JString, required = true,
                                 default = nil)
  if valid_575152 != nil:
    section.add "api-version", valid_575152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575153: Call_DatabasesDelete_575145; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the database with the given name.
  ## 
  let valid = call_575153.validator(path, query, header, formData, body)
  let scheme = call_575153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575153.url(scheme.get, call_575153.host, call_575153.base,
                         call_575153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575153, url, valid)

proc call*(call_575154: Call_DatabasesDelete_575145; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string): Recallable =
  ## databasesDelete
  ## Deletes the database with the given name.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  var path_575155 = newJObject()
  var query_575156 = newJObject()
  add(path_575155, "clusterName", newJString(clusterName))
  add(path_575155, "resourceGroupName", newJString(resourceGroupName))
  add(query_575156, "api-version", newJString(apiVersion))
  add(path_575155, "subscriptionId", newJString(subscriptionId))
  add(path_575155, "databaseName", newJString(databaseName))
  result = call_575154.call(path_575155, query_575156, nil, nil, nil)

var databasesDelete* = Call_DatabasesDelete_575145(name: "databasesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}",
    validator: validate_DatabasesDelete_575146, base: "", url: url_DatabasesDelete_575147,
    schemes: {Scheme.Https})
type
  Call_DatabasesAddPrincipals_575171 = ref object of OpenApiRestCall_574458
proc url_DatabasesAddPrincipals_575173(protocol: Scheme; host: string; base: string;
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

proc validate_DatabasesAddPrincipals_575172(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add Database principals permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575174 = path.getOrDefault("clusterName")
  valid_575174 = validateParameter(valid_575174, JString, required = true,
                                 default = nil)
  if valid_575174 != nil:
    section.add "clusterName", valid_575174
  var valid_575175 = path.getOrDefault("resourceGroupName")
  valid_575175 = validateParameter(valid_575175, JString, required = true,
                                 default = nil)
  if valid_575175 != nil:
    section.add "resourceGroupName", valid_575175
  var valid_575176 = path.getOrDefault("subscriptionId")
  valid_575176 = validateParameter(valid_575176, JString, required = true,
                                 default = nil)
  if valid_575176 != nil:
    section.add "subscriptionId", valid_575176
  var valid_575177 = path.getOrDefault("databaseName")
  valid_575177 = validateParameter(valid_575177, JString, required = true,
                                 default = nil)
  if valid_575177 != nil:
    section.add "databaseName", valid_575177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575178 = query.getOrDefault("api-version")
  valid_575178 = validateParameter(valid_575178, JString, required = true,
                                 default = nil)
  if valid_575178 != nil:
    section.add "api-version", valid_575178
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

proc call*(call_575180: Call_DatabasesAddPrincipals_575171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add Database principals permissions.
  ## 
  let valid = call_575180.validator(path, query, header, formData, body)
  let scheme = call_575180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575180.url(scheme.get, call_575180.host, call_575180.base,
                         call_575180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575180, url, valid)

proc call*(call_575181: Call_DatabasesAddPrincipals_575171; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; databasePrincipalsToAdd: JsonNode): Recallable =
  ## databasesAddPrincipals
  ## Add Database principals permissions.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   databasePrincipalsToAdd: JObject (required)
  ##                          : List of database principals to add.
  var path_575182 = newJObject()
  var query_575183 = newJObject()
  var body_575184 = newJObject()
  add(path_575182, "clusterName", newJString(clusterName))
  add(path_575182, "resourceGroupName", newJString(resourceGroupName))
  add(query_575183, "api-version", newJString(apiVersion))
  add(path_575182, "subscriptionId", newJString(subscriptionId))
  add(path_575182, "databaseName", newJString(databaseName))
  if databasePrincipalsToAdd != nil:
    body_575184 = databasePrincipalsToAdd
  result = call_575181.call(path_575182, query_575183, nil, nil, body_575184)

var databasesAddPrincipals* = Call_DatabasesAddPrincipals_575171(
    name: "databasesAddPrincipals", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/addPrincipals",
    validator: validate_DatabasesAddPrincipals_575172, base: "",
    url: url_DatabasesAddPrincipals_575173, schemes: {Scheme.Https})
type
  Call_DataConnectionsCheckNameAvailability_575185 = ref object of OpenApiRestCall_574458
proc url_DataConnectionsCheckNameAvailability_575187(protocol: Scheme;
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

proc validate_DataConnectionsCheckNameAvailability_575186(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the data connection name is valid and is not already in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575188 = path.getOrDefault("clusterName")
  valid_575188 = validateParameter(valid_575188, JString, required = true,
                                 default = nil)
  if valid_575188 != nil:
    section.add "clusterName", valid_575188
  var valid_575189 = path.getOrDefault("resourceGroupName")
  valid_575189 = validateParameter(valid_575189, JString, required = true,
                                 default = nil)
  if valid_575189 != nil:
    section.add "resourceGroupName", valid_575189
  var valid_575190 = path.getOrDefault("subscriptionId")
  valid_575190 = validateParameter(valid_575190, JString, required = true,
                                 default = nil)
  if valid_575190 != nil:
    section.add "subscriptionId", valid_575190
  var valid_575191 = path.getOrDefault("databaseName")
  valid_575191 = validateParameter(valid_575191, JString, required = true,
                                 default = nil)
  if valid_575191 != nil:
    section.add "databaseName", valid_575191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575192 = query.getOrDefault("api-version")
  valid_575192 = validateParameter(valid_575192, JString, required = true,
                                 default = nil)
  if valid_575192 != nil:
    section.add "api-version", valid_575192
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

proc call*(call_575194: Call_DataConnectionsCheckNameAvailability_575185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that the data connection name is valid and is not already in use.
  ## 
  let valid = call_575194.validator(path, query, header, formData, body)
  let scheme = call_575194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575194.url(scheme.get, call_575194.host, call_575194.base,
                         call_575194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575194, url, valid)

proc call*(call_575195: Call_DataConnectionsCheckNameAvailability_575185;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; dataConnectionName: JsonNode; databaseName: string): Recallable =
  ## dataConnectionsCheckNameAvailability
  ## Checks that the data connection name is valid and is not already in use.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataConnectionName: JObject (required)
  ##                     : The name of the data connection.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  var path_575196 = newJObject()
  var query_575197 = newJObject()
  var body_575198 = newJObject()
  add(path_575196, "clusterName", newJString(clusterName))
  add(path_575196, "resourceGroupName", newJString(resourceGroupName))
  add(query_575197, "api-version", newJString(apiVersion))
  add(path_575196, "subscriptionId", newJString(subscriptionId))
  if dataConnectionName != nil:
    body_575198 = dataConnectionName
  add(path_575196, "databaseName", newJString(databaseName))
  result = call_575195.call(path_575196, query_575197, nil, nil, body_575198)

var dataConnectionsCheckNameAvailability* = Call_DataConnectionsCheckNameAvailability_575185(
    name: "dataConnectionsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/checkNameAvailability",
    validator: validate_DataConnectionsCheckNameAvailability_575186, base: "",
    url: url_DataConnectionsCheckNameAvailability_575187, schemes: {Scheme.Https})
type
  Call_DataConnectionsDataConnectionValidation_575199 = ref object of OpenApiRestCall_574458
proc url_DataConnectionsDataConnectionValidation_575201(protocol: Scheme;
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

proc validate_DataConnectionsDataConnectionValidation_575200(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the data connection parameters are valid.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575202 = path.getOrDefault("clusterName")
  valid_575202 = validateParameter(valid_575202, JString, required = true,
                                 default = nil)
  if valid_575202 != nil:
    section.add "clusterName", valid_575202
  var valid_575203 = path.getOrDefault("resourceGroupName")
  valid_575203 = validateParameter(valid_575203, JString, required = true,
                                 default = nil)
  if valid_575203 != nil:
    section.add "resourceGroupName", valid_575203
  var valid_575204 = path.getOrDefault("subscriptionId")
  valid_575204 = validateParameter(valid_575204, JString, required = true,
                                 default = nil)
  if valid_575204 != nil:
    section.add "subscriptionId", valid_575204
  var valid_575205 = path.getOrDefault("databaseName")
  valid_575205 = validateParameter(valid_575205, JString, required = true,
                                 default = nil)
  if valid_575205 != nil:
    section.add "databaseName", valid_575205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575206 = query.getOrDefault("api-version")
  valid_575206 = validateParameter(valid_575206, JString, required = true,
                                 default = nil)
  if valid_575206 != nil:
    section.add "api-version", valid_575206
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

proc call*(call_575208: Call_DataConnectionsDataConnectionValidation_575199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that the data connection parameters are valid.
  ## 
  let valid = call_575208.validator(path, query, header, formData, body)
  let scheme = call_575208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575208.url(scheme.get, call_575208.host, call_575208.base,
                         call_575208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575208, url, valid)

proc call*(call_575209: Call_DataConnectionsDataConnectionValidation_575199;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; databaseName: string; parameters: JsonNode): Recallable =
  ## dataConnectionsDataConnectionValidation
  ## Checks that the data connection parameters are valid.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   parameters: JObject (required)
  ##             : The data connection parameters supplied to the CreateOrUpdate operation.
  var path_575210 = newJObject()
  var query_575211 = newJObject()
  var body_575212 = newJObject()
  add(path_575210, "clusterName", newJString(clusterName))
  add(path_575210, "resourceGroupName", newJString(resourceGroupName))
  add(query_575211, "api-version", newJString(apiVersion))
  add(path_575210, "subscriptionId", newJString(subscriptionId))
  add(path_575210, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_575212 = parameters
  result = call_575209.call(path_575210, query_575211, nil, nil, body_575212)

var dataConnectionsDataConnectionValidation* = Call_DataConnectionsDataConnectionValidation_575199(
    name: "dataConnectionsDataConnectionValidation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/dataConnectionValidation",
    validator: validate_DataConnectionsDataConnectionValidation_575200, base: "",
    url: url_DataConnectionsDataConnectionValidation_575201,
    schemes: {Scheme.Https})
type
  Call_DataConnectionsListByDatabase_575213 = ref object of OpenApiRestCall_574458
proc url_DataConnectionsListByDatabase_575215(protocol: Scheme; host: string;
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

proc validate_DataConnectionsListByDatabase_575214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of data connections of the given Kusto database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575216 = path.getOrDefault("clusterName")
  valid_575216 = validateParameter(valid_575216, JString, required = true,
                                 default = nil)
  if valid_575216 != nil:
    section.add "clusterName", valid_575216
  var valid_575217 = path.getOrDefault("resourceGroupName")
  valid_575217 = validateParameter(valid_575217, JString, required = true,
                                 default = nil)
  if valid_575217 != nil:
    section.add "resourceGroupName", valid_575217
  var valid_575218 = path.getOrDefault("subscriptionId")
  valid_575218 = validateParameter(valid_575218, JString, required = true,
                                 default = nil)
  if valid_575218 != nil:
    section.add "subscriptionId", valid_575218
  var valid_575219 = path.getOrDefault("databaseName")
  valid_575219 = validateParameter(valid_575219, JString, required = true,
                                 default = nil)
  if valid_575219 != nil:
    section.add "databaseName", valid_575219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575220 = query.getOrDefault("api-version")
  valid_575220 = validateParameter(valid_575220, JString, required = true,
                                 default = nil)
  if valid_575220 != nil:
    section.add "api-version", valid_575220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575221: Call_DataConnectionsListByDatabase_575213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of data connections of the given Kusto database.
  ## 
  let valid = call_575221.validator(path, query, header, formData, body)
  let scheme = call_575221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575221.url(scheme.get, call_575221.host, call_575221.base,
                         call_575221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575221, url, valid)

proc call*(call_575222: Call_DataConnectionsListByDatabase_575213;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; databaseName: string): Recallable =
  ## dataConnectionsListByDatabase
  ## Returns the list of data connections of the given Kusto database.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  var path_575223 = newJObject()
  var query_575224 = newJObject()
  add(path_575223, "clusterName", newJString(clusterName))
  add(path_575223, "resourceGroupName", newJString(resourceGroupName))
  add(query_575224, "api-version", newJString(apiVersion))
  add(path_575223, "subscriptionId", newJString(subscriptionId))
  add(path_575223, "databaseName", newJString(databaseName))
  result = call_575222.call(path_575223, query_575224, nil, nil, nil)

var dataConnectionsListByDatabase* = Call_DataConnectionsListByDatabase_575213(
    name: "dataConnectionsListByDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/dataConnections",
    validator: validate_DataConnectionsListByDatabase_575214, base: "",
    url: url_DataConnectionsListByDatabase_575215, schemes: {Scheme.Https})
type
  Call_DataConnectionsCreateOrUpdate_575238 = ref object of OpenApiRestCall_574458
proc url_DataConnectionsCreateOrUpdate_575240(protocol: Scheme; host: string;
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

proc validate_DataConnectionsCreateOrUpdate_575239(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a data connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   dataConnectionName: JString (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575241 = path.getOrDefault("clusterName")
  valid_575241 = validateParameter(valid_575241, JString, required = true,
                                 default = nil)
  if valid_575241 != nil:
    section.add "clusterName", valid_575241
  var valid_575242 = path.getOrDefault("dataConnectionName")
  valid_575242 = validateParameter(valid_575242, JString, required = true,
                                 default = nil)
  if valid_575242 != nil:
    section.add "dataConnectionName", valid_575242
  var valid_575243 = path.getOrDefault("resourceGroupName")
  valid_575243 = validateParameter(valid_575243, JString, required = true,
                                 default = nil)
  if valid_575243 != nil:
    section.add "resourceGroupName", valid_575243
  var valid_575244 = path.getOrDefault("subscriptionId")
  valid_575244 = validateParameter(valid_575244, JString, required = true,
                                 default = nil)
  if valid_575244 != nil:
    section.add "subscriptionId", valid_575244
  var valid_575245 = path.getOrDefault("databaseName")
  valid_575245 = validateParameter(valid_575245, JString, required = true,
                                 default = nil)
  if valid_575245 != nil:
    section.add "databaseName", valid_575245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575246 = query.getOrDefault("api-version")
  valid_575246 = validateParameter(valid_575246, JString, required = true,
                                 default = nil)
  if valid_575246 != nil:
    section.add "api-version", valid_575246
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

proc call*(call_575248: Call_DataConnectionsCreateOrUpdate_575238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a data connection.
  ## 
  let valid = call_575248.validator(path, query, header, formData, body)
  let scheme = call_575248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575248.url(scheme.get, call_575248.host, call_575248.base,
                         call_575248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575248, url, valid)

proc call*(call_575249: Call_DataConnectionsCreateOrUpdate_575238;
          clusterName: string; dataConnectionName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; parameters: JsonNode): Recallable =
  ## dataConnectionsCreateOrUpdate
  ## Creates or updates a data connection.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   dataConnectionName: string (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   parameters: JObject (required)
  ##             : The data connection parameters supplied to the CreateOrUpdate operation.
  var path_575250 = newJObject()
  var query_575251 = newJObject()
  var body_575252 = newJObject()
  add(path_575250, "clusterName", newJString(clusterName))
  add(path_575250, "dataConnectionName", newJString(dataConnectionName))
  add(path_575250, "resourceGroupName", newJString(resourceGroupName))
  add(query_575251, "api-version", newJString(apiVersion))
  add(path_575250, "subscriptionId", newJString(subscriptionId))
  add(path_575250, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_575252 = parameters
  result = call_575249.call(path_575250, query_575251, nil, nil, body_575252)

var dataConnectionsCreateOrUpdate* = Call_DataConnectionsCreateOrUpdate_575238(
    name: "dataConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/dataConnections/{dataConnectionName}",
    validator: validate_DataConnectionsCreateOrUpdate_575239, base: "",
    url: url_DataConnectionsCreateOrUpdate_575240, schemes: {Scheme.Https})
type
  Call_DataConnectionsGet_575225 = ref object of OpenApiRestCall_574458
proc url_DataConnectionsGet_575227(protocol: Scheme; host: string; base: string;
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

proc validate_DataConnectionsGet_575226(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns a data connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   dataConnectionName: JString (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575228 = path.getOrDefault("clusterName")
  valid_575228 = validateParameter(valid_575228, JString, required = true,
                                 default = nil)
  if valid_575228 != nil:
    section.add "clusterName", valid_575228
  var valid_575229 = path.getOrDefault("dataConnectionName")
  valid_575229 = validateParameter(valid_575229, JString, required = true,
                                 default = nil)
  if valid_575229 != nil:
    section.add "dataConnectionName", valid_575229
  var valid_575230 = path.getOrDefault("resourceGroupName")
  valid_575230 = validateParameter(valid_575230, JString, required = true,
                                 default = nil)
  if valid_575230 != nil:
    section.add "resourceGroupName", valid_575230
  var valid_575231 = path.getOrDefault("subscriptionId")
  valid_575231 = validateParameter(valid_575231, JString, required = true,
                                 default = nil)
  if valid_575231 != nil:
    section.add "subscriptionId", valid_575231
  var valid_575232 = path.getOrDefault("databaseName")
  valid_575232 = validateParameter(valid_575232, JString, required = true,
                                 default = nil)
  if valid_575232 != nil:
    section.add "databaseName", valid_575232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575233 = query.getOrDefault("api-version")
  valid_575233 = validateParameter(valid_575233, JString, required = true,
                                 default = nil)
  if valid_575233 != nil:
    section.add "api-version", valid_575233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575234: Call_DataConnectionsGet_575225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a data connection.
  ## 
  let valid = call_575234.validator(path, query, header, formData, body)
  let scheme = call_575234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575234.url(scheme.get, call_575234.host, call_575234.base,
                         call_575234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575234, url, valid)

proc call*(call_575235: Call_DataConnectionsGet_575225; clusterName: string;
          dataConnectionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; databaseName: string): Recallable =
  ## dataConnectionsGet
  ## Returns a data connection.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   dataConnectionName: string (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  var path_575236 = newJObject()
  var query_575237 = newJObject()
  add(path_575236, "clusterName", newJString(clusterName))
  add(path_575236, "dataConnectionName", newJString(dataConnectionName))
  add(path_575236, "resourceGroupName", newJString(resourceGroupName))
  add(query_575237, "api-version", newJString(apiVersion))
  add(path_575236, "subscriptionId", newJString(subscriptionId))
  add(path_575236, "databaseName", newJString(databaseName))
  result = call_575235.call(path_575236, query_575237, nil, nil, nil)

var dataConnectionsGet* = Call_DataConnectionsGet_575225(
    name: "dataConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/dataConnections/{dataConnectionName}",
    validator: validate_DataConnectionsGet_575226, base: "",
    url: url_DataConnectionsGet_575227, schemes: {Scheme.Https})
type
  Call_DataConnectionsUpdate_575266 = ref object of OpenApiRestCall_574458
proc url_DataConnectionsUpdate_575268(protocol: Scheme; host: string; base: string;
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

proc validate_DataConnectionsUpdate_575267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a data connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   dataConnectionName: JString (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575269 = path.getOrDefault("clusterName")
  valid_575269 = validateParameter(valid_575269, JString, required = true,
                                 default = nil)
  if valid_575269 != nil:
    section.add "clusterName", valid_575269
  var valid_575270 = path.getOrDefault("dataConnectionName")
  valid_575270 = validateParameter(valid_575270, JString, required = true,
                                 default = nil)
  if valid_575270 != nil:
    section.add "dataConnectionName", valid_575270
  var valid_575271 = path.getOrDefault("resourceGroupName")
  valid_575271 = validateParameter(valid_575271, JString, required = true,
                                 default = nil)
  if valid_575271 != nil:
    section.add "resourceGroupName", valid_575271
  var valid_575272 = path.getOrDefault("subscriptionId")
  valid_575272 = validateParameter(valid_575272, JString, required = true,
                                 default = nil)
  if valid_575272 != nil:
    section.add "subscriptionId", valid_575272
  var valid_575273 = path.getOrDefault("databaseName")
  valid_575273 = validateParameter(valid_575273, JString, required = true,
                                 default = nil)
  if valid_575273 != nil:
    section.add "databaseName", valid_575273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575274 = query.getOrDefault("api-version")
  valid_575274 = validateParameter(valid_575274, JString, required = true,
                                 default = nil)
  if valid_575274 != nil:
    section.add "api-version", valid_575274
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

proc call*(call_575276: Call_DataConnectionsUpdate_575266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data connection.
  ## 
  let valid = call_575276.validator(path, query, header, formData, body)
  let scheme = call_575276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575276.url(scheme.get, call_575276.host, call_575276.base,
                         call_575276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575276, url, valid)

proc call*(call_575277: Call_DataConnectionsUpdate_575266; clusterName: string;
          dataConnectionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; databaseName: string; parameters: JsonNode): Recallable =
  ## dataConnectionsUpdate
  ## Updates a data connection.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   dataConnectionName: string (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   parameters: JObject (required)
  ##             : The data connection parameters supplied to the Update operation.
  var path_575278 = newJObject()
  var query_575279 = newJObject()
  var body_575280 = newJObject()
  add(path_575278, "clusterName", newJString(clusterName))
  add(path_575278, "dataConnectionName", newJString(dataConnectionName))
  add(path_575278, "resourceGroupName", newJString(resourceGroupName))
  add(query_575279, "api-version", newJString(apiVersion))
  add(path_575278, "subscriptionId", newJString(subscriptionId))
  add(path_575278, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_575280 = parameters
  result = call_575277.call(path_575278, query_575279, nil, nil, body_575280)

var dataConnectionsUpdate* = Call_DataConnectionsUpdate_575266(
    name: "dataConnectionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/dataConnections/{dataConnectionName}",
    validator: validate_DataConnectionsUpdate_575267, base: "",
    url: url_DataConnectionsUpdate_575268, schemes: {Scheme.Https})
type
  Call_DataConnectionsDelete_575253 = ref object of OpenApiRestCall_574458
proc url_DataConnectionsDelete_575255(protocol: Scheme; host: string; base: string;
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

proc validate_DataConnectionsDelete_575254(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the data connection with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   dataConnectionName: JString (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575256 = path.getOrDefault("clusterName")
  valid_575256 = validateParameter(valid_575256, JString, required = true,
                                 default = nil)
  if valid_575256 != nil:
    section.add "clusterName", valid_575256
  var valid_575257 = path.getOrDefault("dataConnectionName")
  valid_575257 = validateParameter(valid_575257, JString, required = true,
                                 default = nil)
  if valid_575257 != nil:
    section.add "dataConnectionName", valid_575257
  var valid_575258 = path.getOrDefault("resourceGroupName")
  valid_575258 = validateParameter(valid_575258, JString, required = true,
                                 default = nil)
  if valid_575258 != nil:
    section.add "resourceGroupName", valid_575258
  var valid_575259 = path.getOrDefault("subscriptionId")
  valid_575259 = validateParameter(valid_575259, JString, required = true,
                                 default = nil)
  if valid_575259 != nil:
    section.add "subscriptionId", valid_575259
  var valid_575260 = path.getOrDefault("databaseName")
  valid_575260 = validateParameter(valid_575260, JString, required = true,
                                 default = nil)
  if valid_575260 != nil:
    section.add "databaseName", valid_575260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575261 = query.getOrDefault("api-version")
  valid_575261 = validateParameter(valid_575261, JString, required = true,
                                 default = nil)
  if valid_575261 != nil:
    section.add "api-version", valid_575261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575262: Call_DataConnectionsDelete_575253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the data connection with the given name.
  ## 
  let valid = call_575262.validator(path, query, header, formData, body)
  let scheme = call_575262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575262.url(scheme.get, call_575262.host, call_575262.base,
                         call_575262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575262, url, valid)

proc call*(call_575263: Call_DataConnectionsDelete_575253; clusterName: string;
          dataConnectionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; databaseName: string): Recallable =
  ## dataConnectionsDelete
  ## Deletes the data connection with the given name.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   dataConnectionName: string (required)
  ##                     : The name of the data connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  var path_575264 = newJObject()
  var query_575265 = newJObject()
  add(path_575264, "clusterName", newJString(clusterName))
  add(path_575264, "dataConnectionName", newJString(dataConnectionName))
  add(path_575264, "resourceGroupName", newJString(resourceGroupName))
  add(query_575265, "api-version", newJString(apiVersion))
  add(path_575264, "subscriptionId", newJString(subscriptionId))
  add(path_575264, "databaseName", newJString(databaseName))
  result = call_575263.call(path_575264, query_575265, nil, nil, nil)

var dataConnectionsDelete* = Call_DataConnectionsDelete_575253(
    name: "dataConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/dataConnections/{dataConnectionName}",
    validator: validate_DataConnectionsDelete_575254, base: "",
    url: url_DataConnectionsDelete_575255, schemes: {Scheme.Https})
type
  Call_DatabasesListPrincipals_575281 = ref object of OpenApiRestCall_574458
proc url_DatabasesListPrincipals_575283(protocol: Scheme; host: string; base: string;
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

proc validate_DatabasesListPrincipals_575282(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of database principals of the given Kusto cluster and database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575284 = path.getOrDefault("clusterName")
  valid_575284 = validateParameter(valid_575284, JString, required = true,
                                 default = nil)
  if valid_575284 != nil:
    section.add "clusterName", valid_575284
  var valid_575285 = path.getOrDefault("resourceGroupName")
  valid_575285 = validateParameter(valid_575285, JString, required = true,
                                 default = nil)
  if valid_575285 != nil:
    section.add "resourceGroupName", valid_575285
  var valid_575286 = path.getOrDefault("subscriptionId")
  valid_575286 = validateParameter(valid_575286, JString, required = true,
                                 default = nil)
  if valid_575286 != nil:
    section.add "subscriptionId", valid_575286
  var valid_575287 = path.getOrDefault("databaseName")
  valid_575287 = validateParameter(valid_575287, JString, required = true,
                                 default = nil)
  if valid_575287 != nil:
    section.add "databaseName", valid_575287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575288 = query.getOrDefault("api-version")
  valid_575288 = validateParameter(valid_575288, JString, required = true,
                                 default = nil)
  if valid_575288 != nil:
    section.add "api-version", valid_575288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575289: Call_DatabasesListPrincipals_575281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of database principals of the given Kusto cluster and database.
  ## 
  let valid = call_575289.validator(path, query, header, formData, body)
  let scheme = call_575289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575289.url(scheme.get, call_575289.host, call_575289.base,
                         call_575289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575289, url, valid)

proc call*(call_575290: Call_DatabasesListPrincipals_575281; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string): Recallable =
  ## databasesListPrincipals
  ## Returns a list of database principals of the given Kusto cluster and database.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  var path_575291 = newJObject()
  var query_575292 = newJObject()
  add(path_575291, "clusterName", newJString(clusterName))
  add(path_575291, "resourceGroupName", newJString(resourceGroupName))
  add(query_575292, "api-version", newJString(apiVersion))
  add(path_575291, "subscriptionId", newJString(subscriptionId))
  add(path_575291, "databaseName", newJString(databaseName))
  result = call_575290.call(path_575291, query_575292, nil, nil, nil)

var databasesListPrincipals* = Call_DatabasesListPrincipals_575281(
    name: "databasesListPrincipals", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/listPrincipals",
    validator: validate_DatabasesListPrincipals_575282, base: "",
    url: url_DatabasesListPrincipals_575283, schemes: {Scheme.Https})
type
  Call_DatabasesRemovePrincipals_575293 = ref object of OpenApiRestCall_574458
proc url_DatabasesRemovePrincipals_575295(protocol: Scheme; host: string;
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

proc validate_DatabasesRemovePrincipals_575294(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove Database principals permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: JString (required)
  ##               : The name of the database in the Kusto cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575296 = path.getOrDefault("clusterName")
  valid_575296 = validateParameter(valid_575296, JString, required = true,
                                 default = nil)
  if valid_575296 != nil:
    section.add "clusterName", valid_575296
  var valid_575297 = path.getOrDefault("resourceGroupName")
  valid_575297 = validateParameter(valid_575297, JString, required = true,
                                 default = nil)
  if valid_575297 != nil:
    section.add "resourceGroupName", valid_575297
  var valid_575298 = path.getOrDefault("subscriptionId")
  valid_575298 = validateParameter(valid_575298, JString, required = true,
                                 default = nil)
  if valid_575298 != nil:
    section.add "subscriptionId", valid_575298
  var valid_575299 = path.getOrDefault("databaseName")
  valid_575299 = validateParameter(valid_575299, JString, required = true,
                                 default = nil)
  if valid_575299 != nil:
    section.add "databaseName", valid_575299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575300 = query.getOrDefault("api-version")
  valid_575300 = validateParameter(valid_575300, JString, required = true,
                                 default = nil)
  if valid_575300 != nil:
    section.add "api-version", valid_575300
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

proc call*(call_575302: Call_DatabasesRemovePrincipals_575293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove Database principals permissions.
  ## 
  let valid = call_575302.validator(path, query, header, formData, body)
  let scheme = call_575302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575302.url(scheme.get, call_575302.host, call_575302.base,
                         call_575302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575302, url, valid)

proc call*(call_575303: Call_DatabasesRemovePrincipals_575293; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; databasePrincipalsToRemove: JsonNode): Recallable =
  ## databasesRemovePrincipals
  ## Remove Database principals permissions.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   databaseName: string (required)
  ##               : The name of the database in the Kusto cluster.
  ##   databasePrincipalsToRemove: JObject (required)
  ##                             : List of database principals to remove.
  var path_575304 = newJObject()
  var query_575305 = newJObject()
  var body_575306 = newJObject()
  add(path_575304, "clusterName", newJString(clusterName))
  add(path_575304, "resourceGroupName", newJString(resourceGroupName))
  add(query_575305, "api-version", newJString(apiVersion))
  add(path_575304, "subscriptionId", newJString(subscriptionId))
  add(path_575304, "databaseName", newJString(databaseName))
  if databasePrincipalsToRemove != nil:
    body_575306 = databasePrincipalsToRemove
  result = call_575303.call(path_575304, query_575305, nil, nil, body_575306)

var databasesRemovePrincipals* = Call_DatabasesRemovePrincipals_575293(
    name: "databasesRemovePrincipals", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/removePrincipals",
    validator: validate_DatabasesRemovePrincipals_575294, base: "",
    url: url_DatabasesRemovePrincipals_575295, schemes: {Scheme.Https})
type
  Call_ClustersListSkusByResource_575307 = ref object of OpenApiRestCall_574458
proc url_ClustersListSkusByResource_575309(protocol: Scheme; host: string;
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

proc validate_ClustersListSkusByResource_575308(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the SKUs available for the provided resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575310 = path.getOrDefault("clusterName")
  valid_575310 = validateParameter(valid_575310, JString, required = true,
                                 default = nil)
  if valid_575310 != nil:
    section.add "clusterName", valid_575310
  var valid_575311 = path.getOrDefault("resourceGroupName")
  valid_575311 = validateParameter(valid_575311, JString, required = true,
                                 default = nil)
  if valid_575311 != nil:
    section.add "resourceGroupName", valid_575311
  var valid_575312 = path.getOrDefault("subscriptionId")
  valid_575312 = validateParameter(valid_575312, JString, required = true,
                                 default = nil)
  if valid_575312 != nil:
    section.add "subscriptionId", valid_575312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575313 = query.getOrDefault("api-version")
  valid_575313 = validateParameter(valid_575313, JString, required = true,
                                 default = nil)
  if valid_575313 != nil:
    section.add "api-version", valid_575313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575314: Call_ClustersListSkusByResource_575307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the SKUs available for the provided resource.
  ## 
  let valid = call_575314.validator(path, query, header, formData, body)
  let scheme = call_575314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575314.url(scheme.get, call_575314.host, call_575314.base,
                         call_575314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575314, url, valid)

proc call*(call_575315: Call_ClustersListSkusByResource_575307;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## clustersListSkusByResource
  ## Returns the SKUs available for the provided resource.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575316 = newJObject()
  var query_575317 = newJObject()
  add(path_575316, "clusterName", newJString(clusterName))
  add(path_575316, "resourceGroupName", newJString(resourceGroupName))
  add(query_575317, "api-version", newJString(apiVersion))
  add(path_575316, "subscriptionId", newJString(subscriptionId))
  result = call_575315.call(path_575316, query_575317, nil, nil, nil)

var clustersListSkusByResource* = Call_ClustersListSkusByResource_575307(
    name: "clustersListSkusByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/skus",
    validator: validate_ClustersListSkusByResource_575308, base: "",
    url: url_ClustersListSkusByResource_575309, schemes: {Scheme.Https})
type
  Call_ClustersStart_575318 = ref object of OpenApiRestCall_574458
proc url_ClustersStart_575320(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersStart_575319(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575321 = path.getOrDefault("clusterName")
  valid_575321 = validateParameter(valid_575321, JString, required = true,
                                 default = nil)
  if valid_575321 != nil:
    section.add "clusterName", valid_575321
  var valid_575322 = path.getOrDefault("resourceGroupName")
  valid_575322 = validateParameter(valid_575322, JString, required = true,
                                 default = nil)
  if valid_575322 != nil:
    section.add "resourceGroupName", valid_575322
  var valid_575323 = path.getOrDefault("subscriptionId")
  valid_575323 = validateParameter(valid_575323, JString, required = true,
                                 default = nil)
  if valid_575323 != nil:
    section.add "subscriptionId", valid_575323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575324 = query.getOrDefault("api-version")
  valid_575324 = validateParameter(valid_575324, JString, required = true,
                                 default = nil)
  if valid_575324 != nil:
    section.add "api-version", valid_575324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575325: Call_ClustersStart_575318; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a Kusto cluster.
  ## 
  let valid = call_575325.validator(path, query, header, formData, body)
  let scheme = call_575325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575325.url(scheme.get, call_575325.host, call_575325.base,
                         call_575325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575325, url, valid)

proc call*(call_575326: Call_ClustersStart_575318; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## clustersStart
  ## Starts a Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575327 = newJObject()
  var query_575328 = newJObject()
  add(path_575327, "clusterName", newJString(clusterName))
  add(path_575327, "resourceGroupName", newJString(resourceGroupName))
  add(query_575328, "api-version", newJString(apiVersion))
  add(path_575327, "subscriptionId", newJString(subscriptionId))
  result = call_575326.call(path_575327, query_575328, nil, nil, nil)

var clustersStart* = Call_ClustersStart_575318(name: "clustersStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/start",
    validator: validate_ClustersStart_575319, base: "", url: url_ClustersStart_575320,
    schemes: {Scheme.Https})
type
  Call_ClustersStop_575329 = ref object of OpenApiRestCall_574458
proc url_ClustersStop_575331(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersStop_575330(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a Kusto cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575332 = path.getOrDefault("clusterName")
  valid_575332 = validateParameter(valid_575332, JString, required = true,
                                 default = nil)
  if valid_575332 != nil:
    section.add "clusterName", valid_575332
  var valid_575333 = path.getOrDefault("resourceGroupName")
  valid_575333 = validateParameter(valid_575333, JString, required = true,
                                 default = nil)
  if valid_575333 != nil:
    section.add "resourceGroupName", valid_575333
  var valid_575334 = path.getOrDefault("subscriptionId")
  valid_575334 = validateParameter(valid_575334, JString, required = true,
                                 default = nil)
  if valid_575334 != nil:
    section.add "subscriptionId", valid_575334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575335 = query.getOrDefault("api-version")
  valid_575335 = validateParameter(valid_575335, JString, required = true,
                                 default = nil)
  if valid_575335 != nil:
    section.add "api-version", valid_575335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575336: Call_ClustersStop_575329; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a Kusto cluster.
  ## 
  let valid = call_575336.validator(path, query, header, formData, body)
  let scheme = call_575336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575336.url(scheme.get, call_575336.host, call_575336.base,
                         call_575336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575336, url, valid)

proc call*(call_575337: Call_ClustersStop_575329; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## clustersStop
  ## Stops a Kusto cluster.
  ##   clusterName: string (required)
  ##              : The name of the Kusto cluster.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Kusto cluster.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575338 = newJObject()
  var query_575339 = newJObject()
  add(path_575338, "clusterName", newJString(clusterName))
  add(path_575338, "resourceGroupName", newJString(resourceGroupName))
  add(query_575339, "api-version", newJString(apiVersion))
  add(path_575338, "subscriptionId", newJString(subscriptionId))
  result = call_575337.call(path_575338, query_575339, nil, nil, nil)

var clustersStop* = Call_ClustersStop_575329(name: "clustersStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/stop",
    validator: validate_ClustersStop_575330, base: "", url: url_ClustersStop_575331,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
