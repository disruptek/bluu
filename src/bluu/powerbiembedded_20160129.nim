
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Power BI Embedded Management Client
## version: 2016-01-29
## termsOfService: (not provided)
## license: (not provided)
## 
## Client to manage your Power BI Embedded workspace collections and retrieve workspaces.
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

  OpenApiRestCall_593409 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593409](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593409): Option[Scheme] {.used.} =
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
  macServiceName = "powerbiembedded"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetAvailableOperations_593631 = ref object of OpenApiRestCall_593409
proc url_GetAvailableOperations_593633(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAvailableOperations_593632(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Indicates which operations can be performed by the Power BI Resource Provider.
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
  var valid_593792 = query.getOrDefault("api-version")
  valid_593792 = validateParameter(valid_593792, JString, required = true,
                                 default = nil)
  if valid_593792 != nil:
    section.add "api-version", valid_593792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593815: Call_GetAvailableOperations_593631; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates which operations can be performed by the Power BI Resource Provider.
  ## 
  let valid = call_593815.validator(path, query, header, formData, body)
  let scheme = call_593815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593815.url(scheme.get, call_593815.host, call_593815.base,
                         call_593815.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593815, url, valid)

proc call*(call_593886: Call_GetAvailableOperations_593631; apiVersion: string): Recallable =
  ## getAvailableOperations
  ## Indicates which operations can be performed by the Power BI Resource Provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593887 = newJObject()
  add(query_593887, "api-version", newJString(apiVersion))
  result = call_593886.call(nil, query_593887, nil, nil, nil)

var getAvailableOperations* = Call_GetAvailableOperations_593631(
    name: "getAvailableOperations", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.PowerBI/operations",
    validator: validate_GetAvailableOperations_593632, base: "",
    url: url_GetAvailableOperations_593633, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsCheckNameAvailability_593927 = ref object of OpenApiRestCall_593409
proc url_WorkspaceCollectionsCheckNameAvailability_593929(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.PowerBI/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsCheckNameAvailability_593928(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verify the specified Power BI Workspace Collection name is valid and not already in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Azure location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593944 = path.getOrDefault("subscriptionId")
  valid_593944 = validateParameter(valid_593944, JString, required = true,
                                 default = nil)
  if valid_593944 != nil:
    section.add "subscriptionId", valid_593944
  var valid_593945 = path.getOrDefault("location")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = nil)
  if valid_593945 != nil:
    section.add "location", valid_593945
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593946 = query.getOrDefault("api-version")
  valid_593946 = validateParameter(valid_593946, JString, required = true,
                                 default = nil)
  if valid_593946 != nil:
    section.add "api-version", valid_593946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Check name availability request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593948: Call_WorkspaceCollectionsCheckNameAvailability_593927;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verify the specified Power BI Workspace Collection name is valid and not already in use.
  ## 
  let valid = call_593948.validator(path, query, header, formData, body)
  let scheme = call_593948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593948.url(scheme.get, call_593948.host, call_593948.base,
                         call_593948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593948, url, valid)

proc call*(call_593949: Call_WorkspaceCollectionsCheckNameAvailability_593927;
          apiVersion: string; subscriptionId: string; body: JsonNode; location: string): Recallable =
  ## workspaceCollectionsCheckNameAvailability
  ## Verify the specified Power BI Workspace Collection name is valid and not already in use.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : Check name availability request
  ##   location: string (required)
  ##           : Azure location
  var path_593950 = newJObject()
  var query_593951 = newJObject()
  var body_593952 = newJObject()
  add(query_593951, "api-version", newJString(apiVersion))
  add(path_593950, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_593952 = body
  add(path_593950, "location", newJString(location))
  result = call_593949.call(path_593950, query_593951, nil, nil, body_593952)

var workspaceCollectionsCheckNameAvailability* = Call_WorkspaceCollectionsCheckNameAvailability_593927(
    name: "workspaceCollectionsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PowerBI/locations/{location}/checkNameAvailability",
    validator: validate_WorkspaceCollectionsCheckNameAvailability_593928,
    base: "", url: url_WorkspaceCollectionsCheckNameAvailability_593929,
    schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsListBySubscription_593953 = ref object of OpenApiRestCall_593409
proc url_WorkspaceCollectionsListBySubscription_593955(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsListBySubscription_593954(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all existing Power BI workspace collections in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593956 = path.getOrDefault("subscriptionId")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "subscriptionId", valid_593956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593957 = query.getOrDefault("api-version")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "api-version", valid_593957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593958: Call_WorkspaceCollectionsListBySubscription_593953;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all existing Power BI workspace collections in the specified subscription.
  ## 
  let valid = call_593958.validator(path, query, header, formData, body)
  let scheme = call_593958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593958.url(scheme.get, call_593958.host, call_593958.base,
                         call_593958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593958, url, valid)

proc call*(call_593959: Call_WorkspaceCollectionsListBySubscription_593953;
          apiVersion: string; subscriptionId: string): Recallable =
  ## workspaceCollectionsListBySubscription
  ## Retrieves all existing Power BI workspace collections in the specified subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593960 = newJObject()
  var query_593961 = newJObject()
  add(query_593961, "api-version", newJString(apiVersion))
  add(path_593960, "subscriptionId", newJString(subscriptionId))
  result = call_593959.call(path_593960, query_593961, nil, nil, nil)

var workspaceCollectionsListBySubscription* = Call_WorkspaceCollectionsListBySubscription_593953(
    name: "workspaceCollectionsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PowerBI/workspaceCollections",
    validator: validate_WorkspaceCollectionsListBySubscription_593954, base: "",
    url: url_WorkspaceCollectionsListBySubscription_593955,
    schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsMigrate_593962 = ref object of OpenApiRestCall_593409
proc url_WorkspaceCollectionsMigrate_593964(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/moveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsMigrate_593963(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Migrates an existing Power BI Workspace Collection to a different resource group and/or subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593965 = path.getOrDefault("resourceGroupName")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "resourceGroupName", valid_593965
  var valid_593966 = path.getOrDefault("subscriptionId")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "subscriptionId", valid_593966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593967 = query.getOrDefault("api-version")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "api-version", valid_593967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Workspace migration request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_WorkspaceCollectionsMigrate_593962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Migrates an existing Power BI Workspace Collection to a different resource group and/or subscription.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_WorkspaceCollectionsMigrate_593962;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          body: JsonNode): Recallable =
  ## workspaceCollectionsMigrate
  ## Migrates an existing Power BI Workspace Collection to a different resource group and/or subscription.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : Workspace migration request
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  var body_593973 = newJObject()
  add(path_593971, "resourceGroupName", newJString(resourceGroupName))
  add(query_593972, "api-version", newJString(apiVersion))
  add(path_593971, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_593973 = body
  result = call_593970.call(path_593971, query_593972, nil, nil, body_593973)

var workspaceCollectionsMigrate* = Call_WorkspaceCollectionsMigrate_593962(
    name: "workspaceCollectionsMigrate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/moveResources",
    validator: validate_WorkspaceCollectionsMigrate_593963, base: "",
    url: url_WorkspaceCollectionsMigrate_593964, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsListByResourceGroup_593974 = ref object of OpenApiRestCall_593409
proc url_WorkspaceCollectionsListByResourceGroup_593976(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsListByResourceGroup_593975(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all existing Power BI workspace collections in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593977 = path.getOrDefault("resourceGroupName")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "resourceGroupName", valid_593977
  var valid_593978 = path.getOrDefault("subscriptionId")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "subscriptionId", valid_593978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593979 = query.getOrDefault("api-version")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "api-version", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_WorkspaceCollectionsListByResourceGroup_593974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all existing Power BI workspace collections in the specified resource group.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_WorkspaceCollectionsListByResourceGroup_593974;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workspaceCollectionsListByResourceGroup
  ## Retrieves all existing Power BI workspace collections in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(path_593982, "resourceGroupName", newJString(resourceGroupName))
  add(query_593983, "api-version", newJString(apiVersion))
  add(path_593982, "subscriptionId", newJString(subscriptionId))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var workspaceCollectionsListByResourceGroup* = Call_WorkspaceCollectionsListByResourceGroup_593974(
    name: "workspaceCollectionsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections",
    validator: validate_WorkspaceCollectionsListByResourceGroup_593975, base: "",
    url: url_WorkspaceCollectionsListByResourceGroup_593976,
    schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsCreate_593995 = ref object of OpenApiRestCall_593409
proc url_WorkspaceCollectionsCreate_593997(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsCreate_593996(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Power BI Workspace Collection with the specified properties. A Power BI Workspace Collection contains one or more workspaces, and can be used to provision keys that provide API access to those workspaces.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593998 = path.getOrDefault("resourceGroupName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "resourceGroupName", valid_593998
  var valid_593999 = path.getOrDefault("subscriptionId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "subscriptionId", valid_593999
  var valid_594000 = path.getOrDefault("workspaceCollectionName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "workspaceCollectionName", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Create workspace collection request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_WorkspaceCollectionsCreate_593995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Power BI Workspace Collection with the specified properties. A Power BI Workspace Collection contains one or more workspaces, and can be used to provision keys that provide API access to those workspaces.
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_WorkspaceCollectionsCreate_593995;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string; body: JsonNode): Recallable =
  ## workspaceCollectionsCreate
  ## Creates a new Power BI Workspace Collection with the specified properties. A Power BI Workspace Collection contains one or more workspaces, and can be used to provision keys that provide API access to those workspaces.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  ##   body: JObject (required)
  ##       : Create workspace collection request
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  var body_594007 = newJObject()
  add(path_594005, "resourceGroupName", newJString(resourceGroupName))
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "subscriptionId", newJString(subscriptionId))
  add(path_594005, "workspaceCollectionName", newJString(workspaceCollectionName))
  if body != nil:
    body_594007 = body
  result = call_594004.call(path_594005, query_594006, nil, nil, body_594007)

var workspaceCollectionsCreate* = Call_WorkspaceCollectionsCreate_593995(
    name: "workspaceCollectionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}",
    validator: validate_WorkspaceCollectionsCreate_593996, base: "",
    url: url_WorkspaceCollectionsCreate_593997, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsGetByName_593984 = ref object of OpenApiRestCall_593409
proc url_WorkspaceCollectionsGetByName_593986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsGetByName_593985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an existing Power BI Workspace Collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593987 = path.getOrDefault("resourceGroupName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "resourceGroupName", valid_593987
  var valid_593988 = path.getOrDefault("subscriptionId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "subscriptionId", valid_593988
  var valid_593989 = path.getOrDefault("workspaceCollectionName")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "workspaceCollectionName", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_WorkspaceCollectionsGetByName_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an existing Power BI Workspace Collection.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_WorkspaceCollectionsGetByName_593984;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string): Recallable =
  ## workspaceCollectionsGetByName
  ## Retrieves an existing Power BI Workspace Collection.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  add(path_593993, "resourceGroupName", newJString(resourceGroupName))
  add(query_593994, "api-version", newJString(apiVersion))
  add(path_593993, "subscriptionId", newJString(subscriptionId))
  add(path_593993, "workspaceCollectionName", newJString(workspaceCollectionName))
  result = call_593992.call(path_593993, query_593994, nil, nil, nil)

var workspaceCollectionsGetByName* = Call_WorkspaceCollectionsGetByName_593984(
    name: "workspaceCollectionsGetByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}",
    validator: validate_WorkspaceCollectionsGetByName_593985, base: "",
    url: url_WorkspaceCollectionsGetByName_593986, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsUpdate_594019 = ref object of OpenApiRestCall_593409
proc url_WorkspaceCollectionsUpdate_594021(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsUpdate_594020(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing Power BI Workspace Collection with the specified properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("subscriptionId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "subscriptionId", valid_594023
  var valid_594024 = path.getOrDefault("workspaceCollectionName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "workspaceCollectionName", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Update workspace collection request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_WorkspaceCollectionsUpdate_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing Power BI Workspace Collection with the specified properties.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_WorkspaceCollectionsUpdate_594019;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string; body: JsonNode): Recallable =
  ## workspaceCollectionsUpdate
  ## Update an existing Power BI Workspace Collection with the specified properties.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  ##   body: JObject (required)
  ##       : Update workspace collection request
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  var body_594031 = newJObject()
  add(path_594029, "resourceGroupName", newJString(resourceGroupName))
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "subscriptionId", newJString(subscriptionId))
  add(path_594029, "workspaceCollectionName", newJString(workspaceCollectionName))
  if body != nil:
    body_594031 = body
  result = call_594028.call(path_594029, query_594030, nil, nil, body_594031)

var workspaceCollectionsUpdate* = Call_WorkspaceCollectionsUpdate_594019(
    name: "workspaceCollectionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}",
    validator: validate_WorkspaceCollectionsUpdate_594020, base: "",
    url: url_WorkspaceCollectionsUpdate_594021, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsDelete_594008 = ref object of OpenApiRestCall_593409
proc url_WorkspaceCollectionsDelete_594010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsDelete_594009(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Power BI Workspace Collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594011 = path.getOrDefault("resourceGroupName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "resourceGroupName", valid_594011
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  var valid_594013 = path.getOrDefault("workspaceCollectionName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "workspaceCollectionName", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "api-version", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_WorkspaceCollectionsDelete_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Power BI Workspace Collection.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_WorkspaceCollectionsDelete_594008;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string): Recallable =
  ## workspaceCollectionsDelete
  ## Delete a Power BI Workspace Collection.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(path_594017, "resourceGroupName", newJString(resourceGroupName))
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  add(path_594017, "workspaceCollectionName", newJString(workspaceCollectionName))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var workspaceCollectionsDelete* = Call_WorkspaceCollectionsDelete_594008(
    name: "workspaceCollectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}",
    validator: validate_WorkspaceCollectionsDelete_594009, base: "",
    url: url_WorkspaceCollectionsDelete_594010, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsGetAccessKeys_594032 = ref object of OpenApiRestCall_593409
proc url_WorkspaceCollectionsGetAccessKeys_594034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsGetAccessKeys_594033(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the primary and secondary access keys for the specified Power BI Workspace Collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594035 = path.getOrDefault("resourceGroupName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "resourceGroupName", valid_594035
  var valid_594036 = path.getOrDefault("subscriptionId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "subscriptionId", valid_594036
  var valid_594037 = path.getOrDefault("workspaceCollectionName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "workspaceCollectionName", valid_594037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594038 = query.getOrDefault("api-version")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "api-version", valid_594038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594039: Call_WorkspaceCollectionsGetAccessKeys_594032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the primary and secondary access keys for the specified Power BI Workspace Collection.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_WorkspaceCollectionsGetAccessKeys_594032;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string): Recallable =
  ## workspaceCollectionsGetAccessKeys
  ## Retrieves the primary and secondary access keys for the specified Power BI Workspace Collection.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  add(path_594041, "resourceGroupName", newJString(resourceGroupName))
  add(query_594042, "api-version", newJString(apiVersion))
  add(path_594041, "subscriptionId", newJString(subscriptionId))
  add(path_594041, "workspaceCollectionName", newJString(workspaceCollectionName))
  result = call_594040.call(path_594041, query_594042, nil, nil, nil)

var workspaceCollectionsGetAccessKeys* = Call_WorkspaceCollectionsGetAccessKeys_594032(
    name: "workspaceCollectionsGetAccessKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}/listKeys",
    validator: validate_WorkspaceCollectionsGetAccessKeys_594033, base: "",
    url: url_WorkspaceCollectionsGetAccessKeys_594034, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsRegenerateKey_594043 = ref object of OpenApiRestCall_593409
proc url_WorkspaceCollectionsRegenerateKey_594045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName"),
               (kind: ConstantSegment, value: "/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsRegenerateKey_594044(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary access key for the specified Power BI Workspace Collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594046 = path.getOrDefault("resourceGroupName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "resourceGroupName", valid_594046
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  var valid_594048 = path.getOrDefault("workspaceCollectionName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "workspaceCollectionName", valid_594048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "api-version", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Access key to regenerate
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594051: Call_WorkspaceCollectionsRegenerateKey_594043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the primary or secondary access key for the specified Power BI Workspace Collection.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_WorkspaceCollectionsRegenerateKey_594043;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string; body: JsonNode): Recallable =
  ## workspaceCollectionsRegenerateKey
  ## Regenerates the primary or secondary access key for the specified Power BI Workspace Collection.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  ##   body: JObject (required)
  ##       : Access key to regenerate
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  var body_594055 = newJObject()
  add(path_594053, "resourceGroupName", newJString(resourceGroupName))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  add(path_594053, "workspaceCollectionName", newJString(workspaceCollectionName))
  if body != nil:
    body_594055 = body
  result = call_594052.call(path_594053, query_594054, nil, nil, body_594055)

var workspaceCollectionsRegenerateKey* = Call_WorkspaceCollectionsRegenerateKey_594043(
    name: "workspaceCollectionsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}/regenerateKey",
    validator: validate_WorkspaceCollectionsRegenerateKey_594044, base: "",
    url: url_WorkspaceCollectionsRegenerateKey_594045, schemes: {Scheme.Https})
type
  Call_WorkspacesList_594056 = ref object of OpenApiRestCall_593409
proc url_WorkspacesList_594058(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName"),
               (kind: ConstantSegment, value: "/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesList_594057(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves all existing Power BI workspaces in the specified workspace collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594059 = path.getOrDefault("resourceGroupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "resourceGroupName", valid_594059
  var valid_594060 = path.getOrDefault("subscriptionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subscriptionId", valid_594060
  var valid_594061 = path.getOrDefault("workspaceCollectionName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "workspaceCollectionName", valid_594061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594062 = query.getOrDefault("api-version")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "api-version", valid_594062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594063: Call_WorkspacesList_594056; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all existing Power BI workspaces in the specified workspace collection.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_WorkspacesList_594056; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string): Recallable =
  ## workspacesList
  ## Retrieves all existing Power BI workspaces in the specified workspace collection.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  add(path_594065, "resourceGroupName", newJString(resourceGroupName))
  add(query_594066, "api-version", newJString(apiVersion))
  add(path_594065, "subscriptionId", newJString(subscriptionId))
  add(path_594065, "workspaceCollectionName", newJString(workspaceCollectionName))
  result = call_594064.call(path_594065, query_594066, nil, nil, nil)

var workspacesList* = Call_WorkspacesList_594056(name: "workspacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}/workspaces",
    validator: validate_WorkspacesList_594057, base: "", url: url_WorkspacesList_594058,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
