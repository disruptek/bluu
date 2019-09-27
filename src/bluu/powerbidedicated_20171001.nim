
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PowerBIDedicated
## version: 2017-10-01
## termsOfService: (not provided)
## license: (not provided)
## 
## PowerBI Dedicated Web API provides a RESTful set of web services that enables users to create, retrieve, update, and delete Power BI dedicated capacities
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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "powerbidedicated"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593647 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593648(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available PowerBIDedicated REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593831: Call_OperationsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available PowerBIDedicated REST API operations.
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_OperationsList_593647; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available PowerBIDedicated REST API operations.
  ##   apiVersion: string (required)
  ##             : The client API version.
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  result = call_593902.call(nil, query_593903, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.PowerBIDedicated/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_CapacitiesList_593943 = ref object of OpenApiRestCall_593425
proc url_CapacitiesList_593945(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.PowerBIDedicated/capacities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CapacitiesList_593944(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the Dedicated capacities for the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_CapacitiesList_593943; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Dedicated capacities for the given subscription.
  ## 
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_CapacitiesList_593943; apiVersion: string;
          subscriptionId: string): Recallable =
  ## capacitiesList
  ## Lists all the Dedicated capacities for the given subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593964 = newJObject()
  var query_593965 = newJObject()
  add(query_593965, "api-version", newJString(apiVersion))
  add(path_593964, "subscriptionId", newJString(subscriptionId))
  result = call_593963.call(path_593964, query_593965, nil, nil, nil)

var capacitiesList* = Call_CapacitiesList_593943(name: "capacitiesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PowerBIDedicated/capacities",
    validator: validate_CapacitiesList_593944, base: "", url: url_CapacitiesList_593945,
    schemes: {Scheme.Https})
type
  Call_CapacitiesCheckNameAvailability_593966 = ref object of OpenApiRestCall_593425
proc url_CapacitiesCheckNameAvailability_593968(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBIDedicated/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CapacitiesCheckNameAvailability_593967(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the name availability in the target location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The region name which the operation will lookup into.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593969 = path.getOrDefault("subscriptionId")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "subscriptionId", valid_593969
  var valid_593970 = path.getOrDefault("location")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "location", valid_593970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   capacityParameters: JObject (required)
  ##                     : The name of the capacity.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593973: Call_CapacitiesCheckNameAvailability_593966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the name availability in the target location.
  ## 
  let valid = call_593973.validator(path, query, header, formData, body)
  let scheme = call_593973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593973.url(scheme.get, call_593973.host, call_593973.base,
                         call_593973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593973, url, valid)

proc call*(call_593974: Call_CapacitiesCheckNameAvailability_593966;
          apiVersion: string; subscriptionId: string; location: string;
          capacityParameters: JsonNode): Recallable =
  ## capacitiesCheckNameAvailability
  ## Check the name availability in the target location.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The region name which the operation will lookup into.
  ##   capacityParameters: JObject (required)
  ##                     : The name of the capacity.
  var path_593975 = newJObject()
  var query_593976 = newJObject()
  var body_593977 = newJObject()
  add(query_593976, "api-version", newJString(apiVersion))
  add(path_593975, "subscriptionId", newJString(subscriptionId))
  add(path_593975, "location", newJString(location))
  if capacityParameters != nil:
    body_593977 = capacityParameters
  result = call_593974.call(path_593975, query_593976, nil, nil, body_593977)

var capacitiesCheckNameAvailability* = Call_CapacitiesCheckNameAvailability_593966(
    name: "capacitiesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PowerBIDedicated/locations/{location}/checkNameAvailability",
    validator: validate_CapacitiesCheckNameAvailability_593967, base: "",
    url: url_CapacitiesCheckNameAvailability_593968, schemes: {Scheme.Https})
type
  Call_CapacitiesListSkus_593978 = ref object of OpenApiRestCall_593425
proc url_CapacitiesListSkus_593980(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.PowerBIDedicated/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CapacitiesListSkus_593979(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists eligible SKUs for PowerBI Dedicated resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593981 = path.getOrDefault("subscriptionId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "subscriptionId", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_CapacitiesListSkus_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists eligible SKUs for PowerBI Dedicated resource provider.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_CapacitiesListSkus_593978; apiVersion: string;
          subscriptionId: string): Recallable =
  ## capacitiesListSkus
  ## Lists eligible SKUs for PowerBI Dedicated resource provider.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  add(query_593986, "api-version", newJString(apiVersion))
  add(path_593985, "subscriptionId", newJString(subscriptionId))
  result = call_593984.call(path_593985, query_593986, nil, nil, nil)

var capacitiesListSkus* = Call_CapacitiesListSkus_593978(
    name: "capacitiesListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PowerBIDedicated/skus",
    validator: validate_CapacitiesListSkus_593979, base: "",
    url: url_CapacitiesListSkus_593980, schemes: {Scheme.Https})
type
  Call_CapacitiesListByResourceGroup_593987 = ref object of OpenApiRestCall_593425
proc url_CapacitiesListByResourceGroup_593989(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.PowerBIDedicated/capacities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CapacitiesListByResourceGroup_593988(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the Dedicated capacities for the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593990 = path.getOrDefault("resourceGroupName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "resourceGroupName", valid_593990
  var valid_593991 = path.getOrDefault("subscriptionId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "subscriptionId", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_CapacitiesListByResourceGroup_593987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Dedicated capacities for the given resource group.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_CapacitiesListByResourceGroup_593987;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## capacitiesListByResourceGroup
  ## Gets all the Dedicated capacities for the given resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(path_593995, "resourceGroupName", newJString(resourceGroupName))
  add(query_593996, "api-version", newJString(apiVersion))
  add(path_593995, "subscriptionId", newJString(subscriptionId))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var capacitiesListByResourceGroup* = Call_CapacitiesListByResourceGroup_593987(
    name: "capacitiesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities",
    validator: validate_CapacitiesListByResourceGroup_593988, base: "",
    url: url_CapacitiesListByResourceGroup_593989, schemes: {Scheme.Https})
type
  Call_CapacitiesCreate_594008 = ref object of OpenApiRestCall_593425
proc url_CapacitiesCreate_594010(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCapacityName" in path,
        "`dedicatedCapacityName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBIDedicated/capacities/"),
               (kind: VariableSegment, value: "dedicatedCapacityName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CapacitiesCreate_594009(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Provisions the specified Dedicated capacity based on the configuration specified in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: JString (required)
  ##                        : The name of the Dedicated capacity. It must be a minimum of 3 characters, and a maximum of 63.
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
  var valid_594013 = path.getOrDefault("dedicatedCapacityName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "dedicatedCapacityName", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ## parameters in `body` object:
  ##   capacityParameters: JObject (required)
  ##                     : Contains the information used to provision the Dedicated capacity.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_CapacitiesCreate_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions the specified Dedicated capacity based on the configuration specified in the request.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_CapacitiesCreate_594008; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dedicatedCapacityName: string;
          capacityParameters: JsonNode): Recallable =
  ## capacitiesCreate
  ## Provisions the specified Dedicated capacity based on the configuration specified in the request.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: string (required)
  ##                        : The name of the Dedicated capacity. It must be a minimum of 3 characters, and a maximum of 63.
  ##   capacityParameters: JObject (required)
  ##                     : Contains the information used to provision the Dedicated capacity.
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  var body_594020 = newJObject()
  add(path_594018, "resourceGroupName", newJString(resourceGroupName))
  add(query_594019, "api-version", newJString(apiVersion))
  add(path_594018, "subscriptionId", newJString(subscriptionId))
  add(path_594018, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  if capacityParameters != nil:
    body_594020 = capacityParameters
  result = call_594017.call(path_594018, query_594019, nil, nil, body_594020)

var capacitiesCreate* = Call_CapacitiesCreate_594008(name: "capacitiesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}",
    validator: validate_CapacitiesCreate_594009, base: "",
    url: url_CapacitiesCreate_594010, schemes: {Scheme.Https})
type
  Call_CapacitiesGetDetails_593997 = ref object of OpenApiRestCall_593425
proc url_CapacitiesGetDetails_593999(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCapacityName" in path,
        "`dedicatedCapacityName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBIDedicated/capacities/"),
               (kind: VariableSegment, value: "dedicatedCapacityName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CapacitiesGetDetails_593998(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details about the specified dedicated capacity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: JString (required)
  ##                        : The name of the dedicated capacity. It must be a minimum of 3 characters, and a maximum of 63.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594000 = path.getOrDefault("resourceGroupName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "resourceGroupName", valid_594000
  var valid_594001 = path.getOrDefault("subscriptionId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "subscriptionId", valid_594001
  var valid_594002 = path.getOrDefault("dedicatedCapacityName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "dedicatedCapacityName", valid_594002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_CapacitiesGetDetails_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details about the specified dedicated capacity.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_CapacitiesGetDetails_593997;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dedicatedCapacityName: string): Recallable =
  ## capacitiesGetDetails
  ## Gets details about the specified dedicated capacity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: string (required)
  ##                        : The name of the dedicated capacity. It must be a minimum of 3 characters, and a maximum of 63.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(path_594006, "resourceGroupName", newJString(resourceGroupName))
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  add(path_594006, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var capacitiesGetDetails* = Call_CapacitiesGetDetails_593997(
    name: "capacitiesGetDetails", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}",
    validator: validate_CapacitiesGetDetails_593998, base: "",
    url: url_CapacitiesGetDetails_593999, schemes: {Scheme.Https})
type
  Call_CapacitiesUpdate_594032 = ref object of OpenApiRestCall_593425
proc url_CapacitiesUpdate_594034(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCapacityName" in path,
        "`dedicatedCapacityName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBIDedicated/capacities/"),
               (kind: VariableSegment, value: "dedicatedCapacityName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CapacitiesUpdate_594033(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates the current state of the specified Dedicated capacity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: JString (required)
  ##                        : The name of the Dedicated capacity. It must be at least 3 characters in length, and no more than 63.
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
  var valid_594037 = path.getOrDefault("dedicatedCapacityName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "dedicatedCapacityName", valid_594037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ## parameters in `body` object:
  ##   capacityUpdateParameters: JObject (required)
  ##                           : Request object that contains the updated information for the capacity.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_CapacitiesUpdate_594032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the current state of the specified Dedicated capacity.
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_CapacitiesUpdate_594032; resourceGroupName: string;
          apiVersion: string; capacityUpdateParameters: JsonNode;
          subscriptionId: string; dedicatedCapacityName: string): Recallable =
  ## capacitiesUpdate
  ## Updates the current state of the specified Dedicated capacity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   capacityUpdateParameters: JObject (required)
  ##                           : Request object that contains the updated information for the capacity.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: string (required)
  ##                        : The name of the Dedicated capacity. It must be at least 3 characters in length, and no more than 63.
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  var body_594044 = newJObject()
  add(path_594042, "resourceGroupName", newJString(resourceGroupName))
  add(query_594043, "api-version", newJString(apiVersion))
  if capacityUpdateParameters != nil:
    body_594044 = capacityUpdateParameters
  add(path_594042, "subscriptionId", newJString(subscriptionId))
  add(path_594042, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  result = call_594041.call(path_594042, query_594043, nil, nil, body_594044)

var capacitiesUpdate* = Call_CapacitiesUpdate_594032(name: "capacitiesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}",
    validator: validate_CapacitiesUpdate_594033, base: "",
    url: url_CapacitiesUpdate_594034, schemes: {Scheme.Https})
type
  Call_CapacitiesDelete_594021 = ref object of OpenApiRestCall_593425
proc url_CapacitiesDelete_594023(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCapacityName" in path,
        "`dedicatedCapacityName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBIDedicated/capacities/"),
               (kind: VariableSegment, value: "dedicatedCapacityName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CapacitiesDelete_594022(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the specified Dedicated capacity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: JString (required)
  ##                        : The name of the Dedicated capacity. It must be at least 3 characters in length, and no more than 63.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594024 = path.getOrDefault("resourceGroupName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "resourceGroupName", valid_594024
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  var valid_594026 = path.getOrDefault("dedicatedCapacityName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "dedicatedCapacityName", valid_594026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594027 = query.getOrDefault("api-version")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "api-version", valid_594027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594028: Call_CapacitiesDelete_594021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Dedicated capacity.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_CapacitiesDelete_594021; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dedicatedCapacityName: string): Recallable =
  ## capacitiesDelete
  ## Deletes the specified Dedicated capacity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: string (required)
  ##                        : The name of the Dedicated capacity. It must be at least 3 characters in length, and no more than 63.
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  add(path_594030, "resourceGroupName", newJString(resourceGroupName))
  add(query_594031, "api-version", newJString(apiVersion))
  add(path_594030, "subscriptionId", newJString(subscriptionId))
  add(path_594030, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  result = call_594029.call(path_594030, query_594031, nil, nil, nil)

var capacitiesDelete* = Call_CapacitiesDelete_594021(name: "capacitiesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}",
    validator: validate_CapacitiesDelete_594022, base: "",
    url: url_CapacitiesDelete_594023, schemes: {Scheme.Https})
type
  Call_CapacitiesResume_594045 = ref object of OpenApiRestCall_593425
proc url_CapacitiesResume_594047(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCapacityName" in path,
        "`dedicatedCapacityName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBIDedicated/capacities/"),
               (kind: VariableSegment, value: "dedicatedCapacityName"),
               (kind: ConstantSegment, value: "/resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CapacitiesResume_594046(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Resumes operation of the specified Dedicated capacity instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: JString (required)
  ##                        : The name of the Dedicated capacity. It must be at least 3 characters in length, and no more than 63.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594048 = path.getOrDefault("resourceGroupName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "resourceGroupName", valid_594048
  var valid_594049 = path.getOrDefault("subscriptionId")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "subscriptionId", valid_594049
  var valid_594050 = path.getOrDefault("dedicatedCapacityName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "dedicatedCapacityName", valid_594050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594051 = query.getOrDefault("api-version")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "api-version", valid_594051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594052: Call_CapacitiesResume_594045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resumes operation of the specified Dedicated capacity instance.
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_CapacitiesResume_594045; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dedicatedCapacityName: string): Recallable =
  ## capacitiesResume
  ## Resumes operation of the specified Dedicated capacity instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: string (required)
  ##                        : The name of the Dedicated capacity. It must be at least 3 characters in length, and no more than 63.
  var path_594054 = newJObject()
  var query_594055 = newJObject()
  add(path_594054, "resourceGroupName", newJString(resourceGroupName))
  add(query_594055, "api-version", newJString(apiVersion))
  add(path_594054, "subscriptionId", newJString(subscriptionId))
  add(path_594054, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  result = call_594053.call(path_594054, query_594055, nil, nil, nil)

var capacitiesResume* = Call_CapacitiesResume_594045(name: "capacitiesResume",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}/resume",
    validator: validate_CapacitiesResume_594046, base: "",
    url: url_CapacitiesResume_594047, schemes: {Scheme.Https})
type
  Call_CapacitiesListSkusForCapacity_594056 = ref object of OpenApiRestCall_593425
proc url_CapacitiesListSkusForCapacity_594058(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCapacityName" in path,
        "`dedicatedCapacityName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBIDedicated/capacities/"),
               (kind: VariableSegment, value: "dedicatedCapacityName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CapacitiesListSkusForCapacity_594057(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists eligible SKUs for a PowerBI Dedicated resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: JString (required)
  ##                        : The name of the Dedicated capacity. It must be at least 3 characters in length, and no more than 63.
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
  var valid_594061 = path.getOrDefault("dedicatedCapacityName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "dedicatedCapacityName", valid_594061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_594063: Call_CapacitiesListSkusForCapacity_594056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists eligible SKUs for a PowerBI Dedicated resource.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_CapacitiesListSkusForCapacity_594056;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dedicatedCapacityName: string): Recallable =
  ## capacitiesListSkusForCapacity
  ## Lists eligible SKUs for a PowerBI Dedicated resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: string (required)
  ##                        : The name of the Dedicated capacity. It must be at least 3 characters in length, and no more than 63.
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  add(path_594065, "resourceGroupName", newJString(resourceGroupName))
  add(query_594066, "api-version", newJString(apiVersion))
  add(path_594065, "subscriptionId", newJString(subscriptionId))
  add(path_594065, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  result = call_594064.call(path_594065, query_594066, nil, nil, nil)

var capacitiesListSkusForCapacity* = Call_CapacitiesListSkusForCapacity_594056(
    name: "capacitiesListSkusForCapacity", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}/skus",
    validator: validate_CapacitiesListSkusForCapacity_594057, base: "",
    url: url_CapacitiesListSkusForCapacity_594058, schemes: {Scheme.Https})
type
  Call_CapacitiesSuspend_594067 = ref object of OpenApiRestCall_593425
proc url_CapacitiesSuspend_594069(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCapacityName" in path,
        "`dedicatedCapacityName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBIDedicated/capacities/"),
               (kind: VariableSegment, value: "dedicatedCapacityName"),
               (kind: ConstantSegment, value: "/suspend")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CapacitiesSuspend_594068(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Suspends operation of the specified dedicated capacity instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: JString (required)
  ##                        : The name of the Dedicated capacity. It must be at least 3 characters in length, and no more than 63.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594070 = path.getOrDefault("resourceGroupName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "resourceGroupName", valid_594070
  var valid_594071 = path.getOrDefault("subscriptionId")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "subscriptionId", valid_594071
  var valid_594072 = path.getOrDefault("dedicatedCapacityName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "dedicatedCapacityName", valid_594072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594073 = query.getOrDefault("api-version")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "api-version", valid_594073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_CapacitiesSuspend_594067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspends operation of the specified dedicated capacity instance.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_CapacitiesSuspend_594067; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dedicatedCapacityName: string): Recallable =
  ## capacitiesSuspend
  ## Suspends operation of the specified dedicated capacity instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dedicatedCapacityName: string (required)
  ##                        : The name of the Dedicated capacity. It must be at least 3 characters in length, and no more than 63.
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(path_594076, "resourceGroupName", newJString(resourceGroupName))
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "subscriptionId", newJString(subscriptionId))
  add(path_594076, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var capacitiesSuspend* = Call_CapacitiesSuspend_594067(name: "capacitiesSuspend",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}/suspend",
    validator: validate_CapacitiesSuspend_594068, base: "",
    url: url_CapacitiesSuspend_594069, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
