
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "powerbidedicated"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
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
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available PowerBIDedicated REST API operations.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567880; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available PowerBIDedicated REST API operations.
  ##   apiVersion: string (required)
  ##             : The client API version.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.PowerBIDedicated/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_CapacitiesList_568176 = ref object of OpenApiRestCall_567658
proc url_CapacitiesList_568178(protocol: Scheme; host: string; base: string;
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

proc validate_CapacitiesList_568177(path: JsonNode; query: JsonNode;
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
  var valid_568193 = path.getOrDefault("subscriptionId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "subscriptionId", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568194 = query.getOrDefault("api-version")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "api-version", valid_568194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568195: Call_CapacitiesList_568176; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Dedicated capacities for the given subscription.
  ## 
  let valid = call_568195.validator(path, query, header, formData, body)
  let scheme = call_568195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568195.url(scheme.get, call_568195.host, call_568195.base,
                         call_568195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568195, url, valid)

proc call*(call_568196: Call_CapacitiesList_568176; apiVersion: string;
          subscriptionId: string): Recallable =
  ## capacitiesList
  ## Lists all the Dedicated capacities for the given subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568197 = newJObject()
  var query_568198 = newJObject()
  add(query_568198, "api-version", newJString(apiVersion))
  add(path_568197, "subscriptionId", newJString(subscriptionId))
  result = call_568196.call(path_568197, query_568198, nil, nil, nil)

var capacitiesList* = Call_CapacitiesList_568176(name: "capacitiesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PowerBIDedicated/capacities",
    validator: validate_CapacitiesList_568177, base: "", url: url_CapacitiesList_568178,
    schemes: {Scheme.Https})
type
  Call_CapacitiesCheckNameAvailability_568199 = ref object of OpenApiRestCall_567658
proc url_CapacitiesCheckNameAvailability_568201(protocol: Scheme; host: string;
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

proc validate_CapacitiesCheckNameAvailability_568200(path: JsonNode;
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
  var valid_568202 = path.getOrDefault("subscriptionId")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "subscriptionId", valid_568202
  var valid_568203 = path.getOrDefault("location")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "location", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
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

proc call*(call_568206: Call_CapacitiesCheckNameAvailability_568199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the name availability in the target location.
  ## 
  let valid = call_568206.validator(path, query, header, formData, body)
  let scheme = call_568206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568206.url(scheme.get, call_568206.host, call_568206.base,
                         call_568206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568206, url, valid)

proc call*(call_568207: Call_CapacitiesCheckNameAvailability_568199;
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
  var path_568208 = newJObject()
  var query_568209 = newJObject()
  var body_568210 = newJObject()
  add(query_568209, "api-version", newJString(apiVersion))
  add(path_568208, "subscriptionId", newJString(subscriptionId))
  add(path_568208, "location", newJString(location))
  if capacityParameters != nil:
    body_568210 = capacityParameters
  result = call_568207.call(path_568208, query_568209, nil, nil, body_568210)

var capacitiesCheckNameAvailability* = Call_CapacitiesCheckNameAvailability_568199(
    name: "capacitiesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PowerBIDedicated/locations/{location}/checkNameAvailability",
    validator: validate_CapacitiesCheckNameAvailability_568200, base: "",
    url: url_CapacitiesCheckNameAvailability_568201, schemes: {Scheme.Https})
type
  Call_CapacitiesListSkus_568211 = ref object of OpenApiRestCall_567658
proc url_CapacitiesListSkus_568213(protocol: Scheme; host: string; base: string;
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

proc validate_CapacitiesListSkus_568212(path: JsonNode; query: JsonNode;
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
  var valid_568214 = path.getOrDefault("subscriptionId")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "subscriptionId", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_CapacitiesListSkus_568211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists eligible SKUs for PowerBI Dedicated resource provider.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_CapacitiesListSkus_568211; apiVersion: string;
          subscriptionId: string): Recallable =
  ## capacitiesListSkus
  ## Lists eligible SKUs for PowerBI Dedicated resource provider.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var capacitiesListSkus* = Call_CapacitiesListSkus_568211(
    name: "capacitiesListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PowerBIDedicated/skus",
    validator: validate_CapacitiesListSkus_568212, base: "",
    url: url_CapacitiesListSkus_568213, schemes: {Scheme.Https})
type
  Call_CapacitiesListByResourceGroup_568220 = ref object of OpenApiRestCall_567658
proc url_CapacitiesListByResourceGroup_568222(protocol: Scheme; host: string;
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

proc validate_CapacitiesListByResourceGroup_568221(path: JsonNode; query: JsonNode;
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
  var valid_568223 = path.getOrDefault("resourceGroupName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "resourceGroupName", valid_568223
  var valid_568224 = path.getOrDefault("subscriptionId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "subscriptionId", valid_568224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568225 = query.getOrDefault("api-version")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "api-version", valid_568225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_CapacitiesListByResourceGroup_568220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Dedicated capacities for the given resource group.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_CapacitiesListByResourceGroup_568220;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## capacitiesListByResourceGroup
  ## Gets all the Dedicated capacities for the given resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given PowerBIDedicated capacity is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  add(path_568228, "resourceGroupName", newJString(resourceGroupName))
  add(query_568229, "api-version", newJString(apiVersion))
  add(path_568228, "subscriptionId", newJString(subscriptionId))
  result = call_568227.call(path_568228, query_568229, nil, nil, nil)

var capacitiesListByResourceGroup* = Call_CapacitiesListByResourceGroup_568220(
    name: "capacitiesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities",
    validator: validate_CapacitiesListByResourceGroup_568221, base: "",
    url: url_CapacitiesListByResourceGroup_568222, schemes: {Scheme.Https})
type
  Call_CapacitiesCreate_568241 = ref object of OpenApiRestCall_567658
proc url_CapacitiesCreate_568243(protocol: Scheme; host: string; base: string;
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

proc validate_CapacitiesCreate_568242(path: JsonNode; query: JsonNode;
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
  var valid_568244 = path.getOrDefault("resourceGroupName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "resourceGroupName", valid_568244
  var valid_568245 = path.getOrDefault("subscriptionId")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "subscriptionId", valid_568245
  var valid_568246 = path.getOrDefault("dedicatedCapacityName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "dedicatedCapacityName", valid_568246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568247 = query.getOrDefault("api-version")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "api-version", valid_568247
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

proc call*(call_568249: Call_CapacitiesCreate_568241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions the specified Dedicated capacity based on the configuration specified in the request.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_CapacitiesCreate_568241; resourceGroupName: string;
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
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  var body_568253 = newJObject()
  add(path_568251, "resourceGroupName", newJString(resourceGroupName))
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "subscriptionId", newJString(subscriptionId))
  add(path_568251, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  if capacityParameters != nil:
    body_568253 = capacityParameters
  result = call_568250.call(path_568251, query_568252, nil, nil, body_568253)

var capacitiesCreate* = Call_CapacitiesCreate_568241(name: "capacitiesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}",
    validator: validate_CapacitiesCreate_568242, base: "",
    url: url_CapacitiesCreate_568243, schemes: {Scheme.Https})
type
  Call_CapacitiesGetDetails_568230 = ref object of OpenApiRestCall_567658
proc url_CapacitiesGetDetails_568232(protocol: Scheme; host: string; base: string;
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

proc validate_CapacitiesGetDetails_568231(path: JsonNode; query: JsonNode;
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
  var valid_568233 = path.getOrDefault("resourceGroupName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "resourceGroupName", valid_568233
  var valid_568234 = path.getOrDefault("subscriptionId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "subscriptionId", valid_568234
  var valid_568235 = path.getOrDefault("dedicatedCapacityName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "dedicatedCapacityName", valid_568235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_CapacitiesGetDetails_568230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details about the specified dedicated capacity.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_CapacitiesGetDetails_568230;
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
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  add(path_568239, "resourceGroupName", newJString(resourceGroupName))
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  add(path_568239, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  result = call_568238.call(path_568239, query_568240, nil, nil, nil)

var capacitiesGetDetails* = Call_CapacitiesGetDetails_568230(
    name: "capacitiesGetDetails", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}",
    validator: validate_CapacitiesGetDetails_568231, base: "",
    url: url_CapacitiesGetDetails_568232, schemes: {Scheme.Https})
type
  Call_CapacitiesUpdate_568265 = ref object of OpenApiRestCall_567658
proc url_CapacitiesUpdate_568267(protocol: Scheme; host: string; base: string;
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

proc validate_CapacitiesUpdate_568266(path: JsonNode; query: JsonNode;
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
  var valid_568268 = path.getOrDefault("resourceGroupName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "resourceGroupName", valid_568268
  var valid_568269 = path.getOrDefault("subscriptionId")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "subscriptionId", valid_568269
  var valid_568270 = path.getOrDefault("dedicatedCapacityName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "dedicatedCapacityName", valid_568270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "api-version", valid_568271
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

proc call*(call_568273: Call_CapacitiesUpdate_568265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the current state of the specified Dedicated capacity.
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_CapacitiesUpdate_568265; resourceGroupName: string;
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
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  var body_568277 = newJObject()
  add(path_568275, "resourceGroupName", newJString(resourceGroupName))
  add(query_568276, "api-version", newJString(apiVersion))
  if capacityUpdateParameters != nil:
    body_568277 = capacityUpdateParameters
  add(path_568275, "subscriptionId", newJString(subscriptionId))
  add(path_568275, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  result = call_568274.call(path_568275, query_568276, nil, nil, body_568277)

var capacitiesUpdate* = Call_CapacitiesUpdate_568265(name: "capacitiesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}",
    validator: validate_CapacitiesUpdate_568266, base: "",
    url: url_CapacitiesUpdate_568267, schemes: {Scheme.Https})
type
  Call_CapacitiesDelete_568254 = ref object of OpenApiRestCall_567658
proc url_CapacitiesDelete_568256(protocol: Scheme; host: string; base: string;
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

proc validate_CapacitiesDelete_568255(path: JsonNode; query: JsonNode;
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
  var valid_568257 = path.getOrDefault("resourceGroupName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "resourceGroupName", valid_568257
  var valid_568258 = path.getOrDefault("subscriptionId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "subscriptionId", valid_568258
  var valid_568259 = path.getOrDefault("dedicatedCapacityName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "dedicatedCapacityName", valid_568259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568260 = query.getOrDefault("api-version")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "api-version", valid_568260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_CapacitiesDelete_568254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Dedicated capacity.
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_CapacitiesDelete_568254; resourceGroupName: string;
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
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  add(path_568263, "resourceGroupName", newJString(resourceGroupName))
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "subscriptionId", newJString(subscriptionId))
  add(path_568263, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  result = call_568262.call(path_568263, query_568264, nil, nil, nil)

var capacitiesDelete* = Call_CapacitiesDelete_568254(name: "capacitiesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}",
    validator: validate_CapacitiesDelete_568255, base: "",
    url: url_CapacitiesDelete_568256, schemes: {Scheme.Https})
type
  Call_CapacitiesResume_568278 = ref object of OpenApiRestCall_567658
proc url_CapacitiesResume_568280(protocol: Scheme; host: string; base: string;
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

proc validate_CapacitiesResume_568279(path: JsonNode; query: JsonNode;
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
  var valid_568281 = path.getOrDefault("resourceGroupName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "resourceGroupName", valid_568281
  var valid_568282 = path.getOrDefault("subscriptionId")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "subscriptionId", valid_568282
  var valid_568283 = path.getOrDefault("dedicatedCapacityName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "dedicatedCapacityName", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "api-version", valid_568284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568285: Call_CapacitiesResume_568278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resumes operation of the specified Dedicated capacity instance.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_CapacitiesResume_568278; resourceGroupName: string;
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
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  add(path_568287, "resourceGroupName", newJString(resourceGroupName))
  add(query_568288, "api-version", newJString(apiVersion))
  add(path_568287, "subscriptionId", newJString(subscriptionId))
  add(path_568287, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  result = call_568286.call(path_568287, query_568288, nil, nil, nil)

var capacitiesResume* = Call_CapacitiesResume_568278(name: "capacitiesResume",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}/resume",
    validator: validate_CapacitiesResume_568279, base: "",
    url: url_CapacitiesResume_568280, schemes: {Scheme.Https})
type
  Call_CapacitiesListSkusForCapacity_568289 = ref object of OpenApiRestCall_567658
proc url_CapacitiesListSkusForCapacity_568291(protocol: Scheme; host: string;
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

proc validate_CapacitiesListSkusForCapacity_568290(path: JsonNode; query: JsonNode;
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
  var valid_568292 = path.getOrDefault("resourceGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceGroupName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  var valid_568294 = path.getOrDefault("dedicatedCapacityName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "dedicatedCapacityName", valid_568294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568295 = query.getOrDefault("api-version")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "api-version", valid_568295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568296: Call_CapacitiesListSkusForCapacity_568289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists eligible SKUs for a PowerBI Dedicated resource.
  ## 
  let valid = call_568296.validator(path, query, header, formData, body)
  let scheme = call_568296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568296.url(scheme.get, call_568296.host, call_568296.base,
                         call_568296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568296, url, valid)

proc call*(call_568297: Call_CapacitiesListSkusForCapacity_568289;
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
  var path_568298 = newJObject()
  var query_568299 = newJObject()
  add(path_568298, "resourceGroupName", newJString(resourceGroupName))
  add(query_568299, "api-version", newJString(apiVersion))
  add(path_568298, "subscriptionId", newJString(subscriptionId))
  add(path_568298, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  result = call_568297.call(path_568298, query_568299, nil, nil, nil)

var capacitiesListSkusForCapacity* = Call_CapacitiesListSkusForCapacity_568289(
    name: "capacitiesListSkusForCapacity", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}/skus",
    validator: validate_CapacitiesListSkusForCapacity_568290, base: "",
    url: url_CapacitiesListSkusForCapacity_568291, schemes: {Scheme.Https})
type
  Call_CapacitiesSuspend_568300 = ref object of OpenApiRestCall_567658
proc url_CapacitiesSuspend_568302(protocol: Scheme; host: string; base: string;
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

proc validate_CapacitiesSuspend_568301(path: JsonNode; query: JsonNode;
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
  var valid_568303 = path.getOrDefault("resourceGroupName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "resourceGroupName", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  var valid_568305 = path.getOrDefault("dedicatedCapacityName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "dedicatedCapacityName", valid_568305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568306 = query.getOrDefault("api-version")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "api-version", valid_568306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568307: Call_CapacitiesSuspend_568300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspends operation of the specified dedicated capacity instance.
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_CapacitiesSuspend_568300; resourceGroupName: string;
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
  var path_568309 = newJObject()
  var query_568310 = newJObject()
  add(path_568309, "resourceGroupName", newJString(resourceGroupName))
  add(query_568310, "api-version", newJString(apiVersion))
  add(path_568309, "subscriptionId", newJString(subscriptionId))
  add(path_568309, "dedicatedCapacityName", newJString(dedicatedCapacityName))
  result = call_568308.call(path_568309, query_568310, nil, nil, nil)

var capacitiesSuspend* = Call_CapacitiesSuspend_568300(name: "capacitiesSuspend",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBIDedicated/capacities/{dedicatedCapacityName}/suspend",
    validator: validate_CapacitiesSuspend_568301, base: "",
    url: url_CapacitiesSuspend_568302, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
