
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DevTestLabsClient
## version: 2018-09-15
## termsOfService: (not provided)
## license: (not provided)
## 
## The DevTest Labs Client.
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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
  macServiceName = "devtestlabs-DTL"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProviderOperationsList_593659 = ref object of OpenApiRestCall_593437
proc url_ProviderOperationsList_593661(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderOperationsList_593660(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Result of the request to list REST API operations
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
  var valid_593833 = query.getOrDefault("api-version")
  valid_593833 = validateParameter(valid_593833, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_593833 != nil:
    section.add "api-version", valid_593833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593856: Call_ProviderOperationsList_593659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Result of the request to list REST API operations
  ## 
  let valid = call_593856.validator(path, query, header, formData, body)
  let scheme = call_593856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593856.url(scheme.get, call_593856.host, call_593856.base,
                         call_593856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593856, url, valid)

proc call*(call_593927: Call_ProviderOperationsList_593659;
          apiVersion: string = "2018-09-15"): Recallable =
  ## providerOperationsList
  ## Result of the request to list REST API operations
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_593928 = newJObject()
  add(query_593928, "api-version", newJString(apiVersion))
  result = call_593927.call(nil, query_593928, nil, nil, nil)

var providerOperationsList* = Call_ProviderOperationsList_593659(
    name: "providerOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.DevTestLab/operations",
    validator: validate_ProviderOperationsList_593660, base: "",
    url: url_ProviderOperationsList_593661, schemes: {Scheme.Https})
type
  Call_LabsListBySubscription_593968 = ref object of OpenApiRestCall_593437
proc url_LabsListBySubscription_593970(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsListBySubscription_593969(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List labs in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_593987 = query.getOrDefault("$orderby")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "$orderby", valid_593987
  var valid_593988 = query.getOrDefault("$expand")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "$expand", valid_593988
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593989 = query.getOrDefault("api-version")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_593989 != nil:
    section.add "api-version", valid_593989
  var valid_593990 = query.getOrDefault("$top")
  valid_593990 = validateParameter(valid_593990, JInt, required = false, default = nil)
  if valid_593990 != nil:
    section.add "$top", valid_593990
  var valid_593991 = query.getOrDefault("$filter")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "$filter", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_LabsListBySubscription_593968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a subscription.
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_LabsListBySubscription_593968; subscriptionId: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## labsListBySubscription
  ## List labs in a subscription.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  add(query_593995, "$orderby", newJString(Orderby))
  add(query_593995, "$expand", newJString(Expand))
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "subscriptionId", newJString(subscriptionId))
  add(query_593995, "$top", newJInt(Top))
  add(query_593995, "$filter", newJString(Filter))
  result = call_593993.call(path_593994, query_593995, nil, nil, nil)

var labsListBySubscription* = Call_LabsListBySubscription_593968(
    name: "labsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabsListBySubscription_593969, base: "",
    url: url_LabsListBySubscription_593970, schemes: {Scheme.Https})
type
  Call_OperationsGet_593996 = ref object of OpenApiRestCall_593437
proc url_OperationsGet_593998(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsGet_593997(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   locationName: JString (required)
  ##               : The name of the location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593999 = path.getOrDefault("name")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "name", valid_593999
  var valid_594000 = path.getOrDefault("subscriptionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "subscriptionId", valid_594000
  var valid_594001 = path.getOrDefault("locationName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "locationName", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_OperationsGet_593996; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get operation.
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_OperationsGet_593996; name: string;
          subscriptionId: string; locationName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## operationsGet
  ## Get operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   locationName: string (required)
  ##               : The name of the location.
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "name", newJString(name))
  add(path_594005, "subscriptionId", newJString(subscriptionId))
  add(path_594005, "locationName", newJString(locationName))
  result = call_594004.call(path_594005, query_594006, nil, nil, nil)

var operationsGet* = Call_OperationsGet_593996(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/locations/{locationName}/operations/{name}",
    validator: validate_OperationsGet_593997, base: "", url: url_OperationsGet_593998,
    schemes: {Scheme.Https})
type
  Call_GlobalSchedulesListBySubscription_594007 = ref object of OpenApiRestCall_593437
proc url_GlobalSchedulesListBySubscription_594009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesListBySubscription_594008(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594010 = path.getOrDefault("subscriptionId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "subscriptionId", valid_594010
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594011 = query.getOrDefault("$orderby")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "$orderby", valid_594011
  var valid_594012 = query.getOrDefault("$expand")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "$expand", valid_594012
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594013 = query.getOrDefault("api-version")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594013 != nil:
    section.add "api-version", valid_594013
  var valid_594014 = query.getOrDefault("$top")
  valid_594014 = validateParameter(valid_594014, JInt, required = false, default = nil)
  if valid_594014 != nil:
    section.add "$top", valid_594014
  var valid_594015 = query.getOrDefault("$filter")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "$filter", valid_594015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_GlobalSchedulesListBySubscription_594007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List schedules in a subscription.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_GlobalSchedulesListBySubscription_594007;
          subscriptionId: string; Orderby: string = ""; Expand: string = "";
          apiVersion: string = "2018-09-15"; Top: int = 0; Filter: string = ""): Recallable =
  ## globalSchedulesListBySubscription
  ## List schedules in a subscription.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  add(query_594019, "$orderby", newJString(Orderby))
  add(query_594019, "$expand", newJString(Expand))
  add(query_594019, "api-version", newJString(apiVersion))
  add(path_594018, "subscriptionId", newJString(subscriptionId))
  add(query_594019, "$top", newJInt(Top))
  add(query_594019, "$filter", newJString(Filter))
  result = call_594017.call(path_594018, query_594019, nil, nil, nil)

var globalSchedulesListBySubscription* = Call_GlobalSchedulesListBySubscription_594007(
    name: "globalSchedulesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/schedules",
    validator: validate_GlobalSchedulesListBySubscription_594008, base: "",
    url: url_GlobalSchedulesListBySubscription_594009, schemes: {Scheme.Https})
type
  Call_LabsListByResourceGroup_594020 = ref object of OpenApiRestCall_593437
proc url_LabsListByResourceGroup_594022(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsListByResourceGroup_594021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List labs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594023 = path.getOrDefault("resourceGroupName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "resourceGroupName", valid_594023
  var valid_594024 = path.getOrDefault("subscriptionId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "subscriptionId", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594025 = query.getOrDefault("$orderby")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "$orderby", valid_594025
  var valid_594026 = query.getOrDefault("$expand")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "$expand", valid_594026
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594027 = query.getOrDefault("api-version")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594027 != nil:
    section.add "api-version", valid_594027
  var valid_594028 = query.getOrDefault("$top")
  valid_594028 = validateParameter(valid_594028, JInt, required = false, default = nil)
  if valid_594028 != nil:
    section.add "$top", valid_594028
  var valid_594029 = query.getOrDefault("$filter")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "$filter", valid_594029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594030: Call_LabsListByResourceGroup_594020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a resource group.
  ## 
  let valid = call_594030.validator(path, query, header, formData, body)
  let scheme = call_594030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594030.url(scheme.get, call_594030.host, call_594030.base,
                         call_594030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594030, url, valid)

proc call*(call_594031: Call_LabsListByResourceGroup_594020;
          resourceGroupName: string; subscriptionId: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## labsListByResourceGroup
  ## List labs in a resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594032 = newJObject()
  var query_594033 = newJObject()
  add(query_594033, "$orderby", newJString(Orderby))
  add(path_594032, "resourceGroupName", newJString(resourceGroupName))
  add(query_594033, "$expand", newJString(Expand))
  add(query_594033, "api-version", newJString(apiVersion))
  add(path_594032, "subscriptionId", newJString(subscriptionId))
  add(query_594033, "$top", newJInt(Top))
  add(query_594033, "$filter", newJString(Filter))
  result = call_594031.call(path_594032, query_594033, nil, nil, nil)

var labsListByResourceGroup* = Call_LabsListByResourceGroup_594020(
    name: "labsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabsListByResourceGroup_594021, base: "",
    url: url_LabsListByResourceGroup_594022, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesList_594034 = ref object of OpenApiRestCall_593437
proc url_ArtifactSourcesList_594036(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesList_594035(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List artifact sources in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594037 = path.getOrDefault("resourceGroupName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "resourceGroupName", valid_594037
  var valid_594038 = path.getOrDefault("subscriptionId")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "subscriptionId", valid_594038
  var valid_594039 = path.getOrDefault("labName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "labName", valid_594039
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594040 = query.getOrDefault("$orderby")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "$orderby", valid_594040
  var valid_594041 = query.getOrDefault("$expand")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "$expand", valid_594041
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594042 = query.getOrDefault("api-version")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594042 != nil:
    section.add "api-version", valid_594042
  var valid_594043 = query.getOrDefault("$top")
  valid_594043 = validateParameter(valid_594043, JInt, required = false, default = nil)
  if valid_594043 != nil:
    section.add "$top", valid_594043
  var valid_594044 = query.getOrDefault("$filter")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "$filter", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_ArtifactSourcesList_594034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifact sources in a given lab.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_ArtifactSourcesList_594034; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## artifactSourcesList
  ## List artifact sources in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(query_594048, "$orderby", newJString(Orderby))
  add(path_594047, "resourceGroupName", newJString(resourceGroupName))
  add(query_594048, "$expand", newJString(Expand))
  add(query_594048, "api-version", newJString(apiVersion))
  add(path_594047, "subscriptionId", newJString(subscriptionId))
  add(query_594048, "$top", newJInt(Top))
  add(path_594047, "labName", newJString(labName))
  add(query_594048, "$filter", newJString(Filter))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var artifactSourcesList* = Call_ArtifactSourcesList_594034(
    name: "artifactSourcesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources",
    validator: validate_ArtifactSourcesList_594035, base: "",
    url: url_ArtifactSourcesList_594036, schemes: {Scheme.Https})
type
  Call_ArmTemplatesList_594049 = ref object of OpenApiRestCall_593437
proc url_ArmTemplatesList_594051(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/armtemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArmTemplatesList_594050(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List azure resource manager templates in a given artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_594054 = path.getOrDefault("artifactSourceName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "artifactSourceName", valid_594054
  var valid_594055 = path.getOrDefault("labName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "labName", valid_594055
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594056 = query.getOrDefault("$orderby")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "$orderby", valid_594056
  var valid_594057 = query.getOrDefault("$expand")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "$expand", valid_594057
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594058 = query.getOrDefault("api-version")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594058 != nil:
    section.add "api-version", valid_594058
  var valid_594059 = query.getOrDefault("$top")
  valid_594059 = validateParameter(valid_594059, JInt, required = false, default = nil)
  if valid_594059 != nil:
    section.add "$top", valid_594059
  var valid_594060 = query.getOrDefault("$filter")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "$filter", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_ArmTemplatesList_594049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List azure resource manager templates in a given artifact source.
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_ArmTemplatesList_594049; resourceGroupName: string;
          subscriptionId: string; artifactSourceName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## armTemplatesList
  ## List azure resource manager templates in a given artifact source.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(query_594064, "$orderby", newJString(Orderby))
  add(path_594063, "resourceGroupName", newJString(resourceGroupName))
  add(query_594064, "$expand", newJString(Expand))
  add(query_594064, "api-version", newJString(apiVersion))
  add(path_594063, "subscriptionId", newJString(subscriptionId))
  add(query_594064, "$top", newJInt(Top))
  add(path_594063, "artifactSourceName", newJString(artifactSourceName))
  add(path_594063, "labName", newJString(labName))
  add(query_594064, "$filter", newJString(Filter))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var armTemplatesList* = Call_ArmTemplatesList_594049(name: "armTemplatesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/armtemplates",
    validator: validate_ArmTemplatesList_594050, base: "",
    url: url_ArmTemplatesList_594051, schemes: {Scheme.Https})
type
  Call_ArmTemplatesGet_594065 = ref object of OpenApiRestCall_593437
proc url_ArmTemplatesGet_594067(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/armtemplates/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArmTemplatesGet_594066(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get azure resource manager template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the azure resource manager template.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594068 = path.getOrDefault("resourceGroupName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "resourceGroupName", valid_594068
  var valid_594069 = path.getOrDefault("name")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "name", valid_594069
  var valid_594070 = path.getOrDefault("subscriptionId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "subscriptionId", valid_594070
  var valid_594071 = path.getOrDefault("artifactSourceName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "artifactSourceName", valid_594071
  var valid_594072 = path.getOrDefault("labName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "labName", valid_594072
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594073 = query.getOrDefault("$expand")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "$expand", valid_594073
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594074 = query.getOrDefault("api-version")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594074 != nil:
    section.add "api-version", valid_594074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594075: Call_ArmTemplatesGet_594065; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get azure resource manager template.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_ArmTemplatesGet_594065; resourceGroupName: string;
          name: string; subscriptionId: string; artifactSourceName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## armTemplatesGet
  ## Get azure resource manager template.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   name: string (required)
  ##       : The name of the azure resource manager template.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  add(path_594077, "resourceGroupName", newJString(resourceGroupName))
  add(query_594078, "$expand", newJString(Expand))
  add(path_594077, "name", newJString(name))
  add(query_594078, "api-version", newJString(apiVersion))
  add(path_594077, "subscriptionId", newJString(subscriptionId))
  add(path_594077, "artifactSourceName", newJString(artifactSourceName))
  add(path_594077, "labName", newJString(labName))
  result = call_594076.call(path_594077, query_594078, nil, nil, nil)

var armTemplatesGet* = Call_ArmTemplatesGet_594065(name: "armTemplatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/armtemplates/{name}",
    validator: validate_ArmTemplatesGet_594066, base: "", url: url_ArmTemplatesGet_594067,
    schemes: {Scheme.Https})
type
  Call_ArtifactsList_594079 = ref object of OpenApiRestCall_593437
proc url_ArtifactsList_594081(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/artifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsList_594080(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List artifacts in a given artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594082 = path.getOrDefault("resourceGroupName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "resourceGroupName", valid_594082
  var valid_594083 = path.getOrDefault("subscriptionId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "subscriptionId", valid_594083
  var valid_594084 = path.getOrDefault("artifactSourceName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "artifactSourceName", valid_594084
  var valid_594085 = path.getOrDefault("labName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "labName", valid_594085
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=title)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594086 = query.getOrDefault("$orderby")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "$orderby", valid_594086
  var valid_594087 = query.getOrDefault("$expand")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "$expand", valid_594087
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594088 = query.getOrDefault("api-version")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594088 != nil:
    section.add "api-version", valid_594088
  var valid_594089 = query.getOrDefault("$top")
  valid_594089 = validateParameter(valid_594089, JInt, required = false, default = nil)
  if valid_594089 != nil:
    section.add "$top", valid_594089
  var valid_594090 = query.getOrDefault("$filter")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "$filter", valid_594090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594091: Call_ArtifactsList_594079; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts in a given artifact source.
  ## 
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_ArtifactsList_594079; resourceGroupName: string;
          subscriptionId: string; artifactSourceName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## artifactsList
  ## List artifacts in a given artifact source.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=title)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594093 = newJObject()
  var query_594094 = newJObject()
  add(query_594094, "$orderby", newJString(Orderby))
  add(path_594093, "resourceGroupName", newJString(resourceGroupName))
  add(query_594094, "$expand", newJString(Expand))
  add(query_594094, "api-version", newJString(apiVersion))
  add(path_594093, "subscriptionId", newJString(subscriptionId))
  add(query_594094, "$top", newJInt(Top))
  add(path_594093, "artifactSourceName", newJString(artifactSourceName))
  add(path_594093, "labName", newJString(labName))
  add(query_594094, "$filter", newJString(Filter))
  result = call_594092.call(path_594093, query_594094, nil, nil, nil)

var artifactsList* = Call_ArtifactsList_594079(name: "artifactsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts",
    validator: validate_ArtifactsList_594080, base: "", url: url_ArtifactsList_594081,
    schemes: {Scheme.Https})
type
  Call_ArtifactsGet_594095 = ref object of OpenApiRestCall_593437
proc url_ArtifactsGet_594097(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGet_594096(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594098 = path.getOrDefault("resourceGroupName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "resourceGroupName", valid_594098
  var valid_594099 = path.getOrDefault("name")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "name", valid_594099
  var valid_594100 = path.getOrDefault("subscriptionId")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "subscriptionId", valid_594100
  var valid_594101 = path.getOrDefault("artifactSourceName")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "artifactSourceName", valid_594101
  var valid_594102 = path.getOrDefault("labName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "labName", valid_594102
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=title)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594103 = query.getOrDefault("$expand")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "$expand", valid_594103
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594104 = query.getOrDefault("api-version")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594104 != nil:
    section.add "api-version", valid_594104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594105: Call_ArtifactsGet_594095; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact.
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_ArtifactsGet_594095; resourceGroupName: string;
          name: string; subscriptionId: string; artifactSourceName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## artifactsGet
  ## Get artifact.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=title)'
  ##   name: string (required)
  ##       : The name of the artifact.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  add(path_594107, "resourceGroupName", newJString(resourceGroupName))
  add(query_594108, "$expand", newJString(Expand))
  add(path_594107, "name", newJString(name))
  add(query_594108, "api-version", newJString(apiVersion))
  add(path_594107, "subscriptionId", newJString(subscriptionId))
  add(path_594107, "artifactSourceName", newJString(artifactSourceName))
  add(path_594107, "labName", newJString(labName))
  result = call_594106.call(path_594107, query_594108, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_594095(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}",
    validator: validate_ArtifactsGet_594096, base: "", url: url_ArtifactsGet_594097,
    schemes: {Scheme.Https})
type
  Call_ArtifactsGenerateArmTemplate_594109 = ref object of OpenApiRestCall_593437
proc url_ArtifactsGenerateArmTemplate_594111(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/generateArmTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGenerateArmTemplate_594110(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594112 = path.getOrDefault("resourceGroupName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "resourceGroupName", valid_594112
  var valid_594113 = path.getOrDefault("name")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "name", valid_594113
  var valid_594114 = path.getOrDefault("subscriptionId")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "subscriptionId", valid_594114
  var valid_594115 = path.getOrDefault("artifactSourceName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "artifactSourceName", valid_594115
  var valid_594116 = path.getOrDefault("labName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "labName", valid_594116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594117 = query.getOrDefault("api-version")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594117 != nil:
    section.add "api-version", valid_594117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   generateArmTemplateRequest: JObject (required)
  ##                             : Parameters for generating an ARM template for deploying artifacts.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594119: Call_ArtifactsGenerateArmTemplate_594109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  let valid = call_594119.validator(path, query, header, formData, body)
  let scheme = call_594119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594119.url(scheme.get, call_594119.host, call_594119.base,
                         call_594119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594119, url, valid)

proc call*(call_594120: Call_ArtifactsGenerateArmTemplate_594109;
          resourceGroupName: string; name: string; subscriptionId: string;
          artifactSourceName: string; labName: string;
          generateArmTemplateRequest: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## artifactsGenerateArmTemplate
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   generateArmTemplateRequest: JObject (required)
  ##                             : Parameters for generating an ARM template for deploying artifacts.
  var path_594121 = newJObject()
  var query_594122 = newJObject()
  var body_594123 = newJObject()
  add(path_594121, "resourceGroupName", newJString(resourceGroupName))
  add(query_594122, "api-version", newJString(apiVersion))
  add(path_594121, "name", newJString(name))
  add(path_594121, "subscriptionId", newJString(subscriptionId))
  add(path_594121, "artifactSourceName", newJString(artifactSourceName))
  add(path_594121, "labName", newJString(labName))
  if generateArmTemplateRequest != nil:
    body_594123 = generateArmTemplateRequest
  result = call_594120.call(path_594121, query_594122, nil, nil, body_594123)

var artifactsGenerateArmTemplate* = Call_ArtifactsGenerateArmTemplate_594109(
    name: "artifactsGenerateArmTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}/generateArmTemplate",
    validator: validate_ArtifactsGenerateArmTemplate_594110, base: "",
    url: url_ArtifactsGenerateArmTemplate_594111, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesCreateOrUpdate_594137 = ref object of OpenApiRestCall_593437
proc url_ArtifactSourcesCreateOrUpdate_594139(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesCreateOrUpdate_594138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594140 = path.getOrDefault("resourceGroupName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "resourceGroupName", valid_594140
  var valid_594141 = path.getOrDefault("name")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "name", valid_594141
  var valid_594142 = path.getOrDefault("subscriptionId")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "subscriptionId", valid_594142
  var valid_594143 = path.getOrDefault("labName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "labName", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594144 = query.getOrDefault("api-version")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594144 != nil:
    section.add "api-version", valid_594144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactSource: JObject (required)
  ##                 : Properties of an artifact source.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594146: Call_ArtifactSourcesCreateOrUpdate_594137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing artifact source.
  ## 
  let valid = call_594146.validator(path, query, header, formData, body)
  let scheme = call_594146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594146.url(scheme.get, call_594146.host, call_594146.base,
                         call_594146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594146, url, valid)

proc call*(call_594147: Call_ArtifactSourcesCreateOrUpdate_594137;
          resourceGroupName: string; name: string; artifactSource: JsonNode;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## artifactSourcesCreateOrUpdate
  ## Create or replace an existing artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   artifactSource: JObject (required)
  ##                 : Properties of an artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594148 = newJObject()
  var query_594149 = newJObject()
  var body_594150 = newJObject()
  add(path_594148, "resourceGroupName", newJString(resourceGroupName))
  add(query_594149, "api-version", newJString(apiVersion))
  add(path_594148, "name", newJString(name))
  if artifactSource != nil:
    body_594150 = artifactSource
  add(path_594148, "subscriptionId", newJString(subscriptionId))
  add(path_594148, "labName", newJString(labName))
  result = call_594147.call(path_594148, query_594149, nil, nil, body_594150)

var artifactSourcesCreateOrUpdate* = Call_ArtifactSourcesCreateOrUpdate_594137(
    name: "artifactSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesCreateOrUpdate_594138, base: "",
    url: url_ArtifactSourcesCreateOrUpdate_594139, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesGet_594124 = ref object of OpenApiRestCall_593437
proc url_ArtifactSourcesGet_594126(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesGet_594125(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594127 = path.getOrDefault("resourceGroupName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "resourceGroupName", valid_594127
  var valid_594128 = path.getOrDefault("name")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "name", valid_594128
  var valid_594129 = path.getOrDefault("subscriptionId")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "subscriptionId", valid_594129
  var valid_594130 = path.getOrDefault("labName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "labName", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594131 = query.getOrDefault("$expand")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "$expand", valid_594131
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594132 = query.getOrDefault("api-version")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594132 != nil:
    section.add "api-version", valid_594132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_ArtifactSourcesGet_594124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact source.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_ArtifactSourcesGet_594124; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
  ## artifactSourcesGet
  ## Get artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  add(path_594135, "resourceGroupName", newJString(resourceGroupName))
  add(query_594136, "$expand", newJString(Expand))
  add(path_594135, "name", newJString(name))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "subscriptionId", newJString(subscriptionId))
  add(path_594135, "labName", newJString(labName))
  result = call_594134.call(path_594135, query_594136, nil, nil, nil)

var artifactSourcesGet* = Call_ArtifactSourcesGet_594124(
    name: "artifactSourcesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesGet_594125, base: "",
    url: url_ArtifactSourcesGet_594126, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesUpdate_594163 = ref object of OpenApiRestCall_593437
proc url_ArtifactSourcesUpdate_594165(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesUpdate_594164(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of artifact sources. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594166 = path.getOrDefault("resourceGroupName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "resourceGroupName", valid_594166
  var valid_594167 = path.getOrDefault("name")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "name", valid_594167
  var valid_594168 = path.getOrDefault("subscriptionId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "subscriptionId", valid_594168
  var valid_594169 = path.getOrDefault("labName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "labName", valid_594169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594170 = query.getOrDefault("api-version")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594170 != nil:
    section.add "api-version", valid_594170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactSource: JObject (required)
  ##                 : Properties of an artifact source.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594172: Call_ArtifactSourcesUpdate_594163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of artifact sources. All other properties will be ignored.
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_ArtifactSourcesUpdate_594163;
          resourceGroupName: string; name: string; artifactSource: JsonNode;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## artifactSourcesUpdate
  ## Allows modifying tags of artifact sources. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   artifactSource: JObject (required)
  ##                 : Properties of an artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  var body_594176 = newJObject()
  add(path_594174, "resourceGroupName", newJString(resourceGroupName))
  add(query_594175, "api-version", newJString(apiVersion))
  add(path_594174, "name", newJString(name))
  if artifactSource != nil:
    body_594176 = artifactSource
  add(path_594174, "subscriptionId", newJString(subscriptionId))
  add(path_594174, "labName", newJString(labName))
  result = call_594173.call(path_594174, query_594175, nil, nil, body_594176)

var artifactSourcesUpdate* = Call_ArtifactSourcesUpdate_594163(
    name: "artifactSourcesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesUpdate_594164, base: "",
    url: url_ArtifactSourcesUpdate_594165, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesDelete_594151 = ref object of OpenApiRestCall_593437
proc url_ArtifactSourcesDelete_594153(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesDelete_594152(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594154 = path.getOrDefault("resourceGroupName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "resourceGroupName", valid_594154
  var valid_594155 = path.getOrDefault("name")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "name", valid_594155
  var valid_594156 = path.getOrDefault("subscriptionId")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "subscriptionId", valid_594156
  var valid_594157 = path.getOrDefault("labName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "labName", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_ArtifactSourcesDelete_594151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete artifact source.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_ArtifactSourcesDelete_594151;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## artifactSourcesDelete
  ## Delete artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  add(path_594161, "resourceGroupName", newJString(resourceGroupName))
  add(query_594162, "api-version", newJString(apiVersion))
  add(path_594161, "name", newJString(name))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  add(path_594161, "labName", newJString(labName))
  result = call_594160.call(path_594161, query_594162, nil, nil, nil)

var artifactSourcesDelete* = Call_ArtifactSourcesDelete_594151(
    name: "artifactSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesDelete_594152, base: "",
    url: url_ArtifactSourcesDelete_594153, schemes: {Scheme.Https})
type
  Call_CostsCreateOrUpdate_594190 = ref object of OpenApiRestCall_593437
proc url_CostsCreateOrUpdate_594192(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostsCreateOrUpdate_594191(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing cost.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the cost.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594193 = path.getOrDefault("resourceGroupName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "resourceGroupName", valid_594193
  var valid_594194 = path.getOrDefault("name")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "name", valid_594194
  var valid_594195 = path.getOrDefault("subscriptionId")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "subscriptionId", valid_594195
  var valid_594196 = path.getOrDefault("labName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "labName", valid_594196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594197 = query.getOrDefault("api-version")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594197 != nil:
    section.add "api-version", valid_594197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labCost: JObject (required)
  ##          : A cost item.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594199: Call_CostsCreateOrUpdate_594190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing cost.
  ## 
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_CostsCreateOrUpdate_594190; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; labCost: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## costsCreateOrUpdate
  ## Create or replace an existing cost.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   labCost: JObject (required)
  ##          : A cost item.
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  var body_594203 = newJObject()
  add(path_594201, "resourceGroupName", newJString(resourceGroupName))
  add(query_594202, "api-version", newJString(apiVersion))
  add(path_594201, "name", newJString(name))
  add(path_594201, "subscriptionId", newJString(subscriptionId))
  add(path_594201, "labName", newJString(labName))
  if labCost != nil:
    body_594203 = labCost
  result = call_594200.call(path_594201, query_594202, nil, nil, body_594203)

var costsCreateOrUpdate* = Call_CostsCreateOrUpdate_594190(
    name: "costsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
    validator: validate_CostsCreateOrUpdate_594191, base: "",
    url: url_CostsCreateOrUpdate_594192, schemes: {Scheme.Https})
type
  Call_CostsGet_594177 = ref object of OpenApiRestCall_593437
proc url_CostsGet_594179(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostsGet_594178(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get cost.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the cost.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594180 = path.getOrDefault("resourceGroupName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "resourceGroupName", valid_594180
  var valid_594181 = path.getOrDefault("name")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "name", valid_594181
  var valid_594182 = path.getOrDefault("subscriptionId")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "subscriptionId", valid_594182
  var valid_594183 = path.getOrDefault("labName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "labName", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=labCostDetails)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594184 = query.getOrDefault("$expand")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "$expand", valid_594184
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594185 = query.getOrDefault("api-version")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594185 != nil:
    section.add "api-version", valid_594185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594186: Call_CostsGet_594177; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost.
  ## 
  let valid = call_594186.validator(path, query, header, formData, body)
  let scheme = call_594186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594186.url(scheme.get, call_594186.host, call_594186.base,
                         call_594186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594186, url, valid)

proc call*(call_594187: Call_CostsGet_594177; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
  ## costsGet
  ## Get cost.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=labCostDetails)'
  ##   name: string (required)
  ##       : The name of the cost.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594188 = newJObject()
  var query_594189 = newJObject()
  add(path_594188, "resourceGroupName", newJString(resourceGroupName))
  add(query_594189, "$expand", newJString(Expand))
  add(path_594188, "name", newJString(name))
  add(query_594189, "api-version", newJString(apiVersion))
  add(path_594188, "subscriptionId", newJString(subscriptionId))
  add(path_594188, "labName", newJString(labName))
  result = call_594187.call(path_594188, query_594189, nil, nil, nil)

var costsGet* = Call_CostsGet_594177(name: "costsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
                                  validator: validate_CostsGet_594178, base: "",
                                  url: url_CostsGet_594179,
                                  schemes: {Scheme.Https})
type
  Call_CustomImagesList_594204 = ref object of OpenApiRestCall_593437
proc url_CustomImagesList_594206(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImagesList_594205(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List custom images in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594207 = path.getOrDefault("resourceGroupName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "resourceGroupName", valid_594207
  var valid_594208 = path.getOrDefault("subscriptionId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "subscriptionId", valid_594208
  var valid_594209 = path.getOrDefault("labName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "labName", valid_594209
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=vm)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594210 = query.getOrDefault("$orderby")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "$orderby", valid_594210
  var valid_594211 = query.getOrDefault("$expand")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "$expand", valid_594211
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594212 = query.getOrDefault("api-version")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594212 != nil:
    section.add "api-version", valid_594212
  var valid_594213 = query.getOrDefault("$top")
  valid_594213 = validateParameter(valid_594213, JInt, required = false, default = nil)
  if valid_594213 != nil:
    section.add "$top", valid_594213
  var valid_594214 = query.getOrDefault("$filter")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "$filter", valid_594214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594215: Call_CustomImagesList_594204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List custom images in a given lab.
  ## 
  let valid = call_594215.validator(path, query, header, formData, body)
  let scheme = call_594215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594215.url(scheme.get, call_594215.host, call_594215.base,
                         call_594215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594215, url, valid)

proc call*(call_594216: Call_CustomImagesList_594204; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## customImagesList
  ## List custom images in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=vm)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594217 = newJObject()
  var query_594218 = newJObject()
  add(query_594218, "$orderby", newJString(Orderby))
  add(path_594217, "resourceGroupName", newJString(resourceGroupName))
  add(query_594218, "$expand", newJString(Expand))
  add(query_594218, "api-version", newJString(apiVersion))
  add(path_594217, "subscriptionId", newJString(subscriptionId))
  add(query_594218, "$top", newJInt(Top))
  add(path_594217, "labName", newJString(labName))
  add(query_594218, "$filter", newJString(Filter))
  result = call_594216.call(path_594217, query_594218, nil, nil, nil)

var customImagesList* = Call_CustomImagesList_594204(name: "customImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages",
    validator: validate_CustomImagesList_594205, base: "",
    url: url_CustomImagesList_594206, schemes: {Scheme.Https})
type
  Call_CustomImagesCreateOrUpdate_594232 = ref object of OpenApiRestCall_593437
proc url_CustomImagesCreateOrUpdate_594234(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImagesCreateOrUpdate_594233(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594235 = path.getOrDefault("resourceGroupName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "resourceGroupName", valid_594235
  var valid_594236 = path.getOrDefault("name")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "name", valid_594236
  var valid_594237 = path.getOrDefault("subscriptionId")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "subscriptionId", valid_594237
  var valid_594238 = path.getOrDefault("labName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "labName", valid_594238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594239 = query.getOrDefault("api-version")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594239 != nil:
    section.add "api-version", valid_594239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customImage: JObject (required)
  ##              : A custom image.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594241: Call_CustomImagesCreateOrUpdate_594232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  let valid = call_594241.validator(path, query, header, formData, body)
  let scheme = call_594241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594241.url(scheme.get, call_594241.host, call_594241.base,
                         call_594241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594241, url, valid)

proc call*(call_594242: Call_CustomImagesCreateOrUpdate_594232;
          resourceGroupName: string; name: string; subscriptionId: string;
          customImage: JsonNode; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## customImagesCreateOrUpdate
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   customImage: JObject (required)
  ##              : A custom image.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594243 = newJObject()
  var query_594244 = newJObject()
  var body_594245 = newJObject()
  add(path_594243, "resourceGroupName", newJString(resourceGroupName))
  add(query_594244, "api-version", newJString(apiVersion))
  add(path_594243, "name", newJString(name))
  add(path_594243, "subscriptionId", newJString(subscriptionId))
  if customImage != nil:
    body_594245 = customImage
  add(path_594243, "labName", newJString(labName))
  result = call_594242.call(path_594243, query_594244, nil, nil, body_594245)

var customImagesCreateOrUpdate* = Call_CustomImagesCreateOrUpdate_594232(
    name: "customImagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesCreateOrUpdate_594233, base: "",
    url: url_CustomImagesCreateOrUpdate_594234, schemes: {Scheme.Https})
type
  Call_CustomImagesGet_594219 = ref object of OpenApiRestCall_593437
proc url_CustomImagesGet_594221(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImagesGet_594220(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get custom image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594222 = path.getOrDefault("resourceGroupName")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "resourceGroupName", valid_594222
  var valid_594223 = path.getOrDefault("name")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "name", valid_594223
  var valid_594224 = path.getOrDefault("subscriptionId")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "subscriptionId", valid_594224
  var valid_594225 = path.getOrDefault("labName")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "labName", valid_594225
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=vm)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594226 = query.getOrDefault("$expand")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "$expand", valid_594226
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594227 = query.getOrDefault("api-version")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594227 != nil:
    section.add "api-version", valid_594227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594228: Call_CustomImagesGet_594219; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get custom image.
  ## 
  let valid = call_594228.validator(path, query, header, formData, body)
  let scheme = call_594228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594228.url(scheme.get, call_594228.host, call_594228.base,
                         call_594228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594228, url, valid)

proc call*(call_594229: Call_CustomImagesGet_594219; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
  ## customImagesGet
  ## Get custom image.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=vm)'
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594230 = newJObject()
  var query_594231 = newJObject()
  add(path_594230, "resourceGroupName", newJString(resourceGroupName))
  add(query_594231, "$expand", newJString(Expand))
  add(path_594230, "name", newJString(name))
  add(query_594231, "api-version", newJString(apiVersion))
  add(path_594230, "subscriptionId", newJString(subscriptionId))
  add(path_594230, "labName", newJString(labName))
  result = call_594229.call(path_594230, query_594231, nil, nil, nil)

var customImagesGet* = Call_CustomImagesGet_594219(name: "customImagesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesGet_594220, base: "", url: url_CustomImagesGet_594221,
    schemes: {Scheme.Https})
type
  Call_CustomImagesUpdate_594258 = ref object of OpenApiRestCall_593437
proc url_CustomImagesUpdate_594260(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImagesUpdate_594259(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Allows modifying tags of custom images. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594261 = path.getOrDefault("resourceGroupName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "resourceGroupName", valid_594261
  var valid_594262 = path.getOrDefault("name")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "name", valid_594262
  var valid_594263 = path.getOrDefault("subscriptionId")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "subscriptionId", valid_594263
  var valid_594264 = path.getOrDefault("labName")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "labName", valid_594264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594265 = query.getOrDefault("api-version")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594265 != nil:
    section.add "api-version", valid_594265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customImage: JObject (required)
  ##              : A custom image.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594267: Call_CustomImagesUpdate_594258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of custom images. All other properties will be ignored.
  ## 
  let valid = call_594267.validator(path, query, header, formData, body)
  let scheme = call_594267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594267.url(scheme.get, call_594267.host, call_594267.base,
                         call_594267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594267, url, valid)

proc call*(call_594268: Call_CustomImagesUpdate_594258; resourceGroupName: string;
          name: string; subscriptionId: string; customImage: JsonNode;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## customImagesUpdate
  ## Allows modifying tags of custom images. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   customImage: JObject (required)
  ##              : A custom image.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594269 = newJObject()
  var query_594270 = newJObject()
  var body_594271 = newJObject()
  add(path_594269, "resourceGroupName", newJString(resourceGroupName))
  add(query_594270, "api-version", newJString(apiVersion))
  add(path_594269, "name", newJString(name))
  add(path_594269, "subscriptionId", newJString(subscriptionId))
  if customImage != nil:
    body_594271 = customImage
  add(path_594269, "labName", newJString(labName))
  result = call_594268.call(path_594269, query_594270, nil, nil, body_594271)

var customImagesUpdate* = Call_CustomImagesUpdate_594258(
    name: "customImagesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesUpdate_594259, base: "",
    url: url_CustomImagesUpdate_594260, schemes: {Scheme.Https})
type
  Call_CustomImagesDelete_594246 = ref object of OpenApiRestCall_593437
proc url_CustomImagesDelete_594248(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImagesDelete_594247(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594249 = path.getOrDefault("resourceGroupName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "resourceGroupName", valid_594249
  var valid_594250 = path.getOrDefault("name")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "name", valid_594250
  var valid_594251 = path.getOrDefault("subscriptionId")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "subscriptionId", valid_594251
  var valid_594252 = path.getOrDefault("labName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "labName", valid_594252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594253 = query.getOrDefault("api-version")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594253 != nil:
    section.add "api-version", valid_594253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594254: Call_CustomImagesDelete_594246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  let valid = call_594254.validator(path, query, header, formData, body)
  let scheme = call_594254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594254.url(scheme.get, call_594254.host, call_594254.base,
                         call_594254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594254, url, valid)

proc call*(call_594255: Call_CustomImagesDelete_594246; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## customImagesDelete
  ## Delete custom image. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594256 = newJObject()
  var query_594257 = newJObject()
  add(path_594256, "resourceGroupName", newJString(resourceGroupName))
  add(query_594257, "api-version", newJString(apiVersion))
  add(path_594256, "name", newJString(name))
  add(path_594256, "subscriptionId", newJString(subscriptionId))
  add(path_594256, "labName", newJString(labName))
  result = call_594255.call(path_594256, query_594257, nil, nil, nil)

var customImagesDelete* = Call_CustomImagesDelete_594246(
    name: "customImagesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesDelete_594247, base: "",
    url: url_CustomImagesDelete_594248, schemes: {Scheme.Https})
type
  Call_FormulasList_594272 = ref object of OpenApiRestCall_593437
proc url_FormulasList_594274(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulasList_594273(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List formulas in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594275 = path.getOrDefault("resourceGroupName")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "resourceGroupName", valid_594275
  var valid_594276 = path.getOrDefault("subscriptionId")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "subscriptionId", valid_594276
  var valid_594277 = path.getOrDefault("labName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "labName", valid_594277
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594278 = query.getOrDefault("$orderby")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "$orderby", valid_594278
  var valid_594279 = query.getOrDefault("$expand")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "$expand", valid_594279
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594280 = query.getOrDefault("api-version")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594280 != nil:
    section.add "api-version", valid_594280
  var valid_594281 = query.getOrDefault("$top")
  valid_594281 = validateParameter(valid_594281, JInt, required = false, default = nil)
  if valid_594281 != nil:
    section.add "$top", valid_594281
  var valid_594282 = query.getOrDefault("$filter")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "$filter", valid_594282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594283: Call_FormulasList_594272; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List formulas in a given lab.
  ## 
  let valid = call_594283.validator(path, query, header, formData, body)
  let scheme = call_594283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594283.url(scheme.get, call_594283.host, call_594283.base,
                         call_594283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594283, url, valid)

proc call*(call_594284: Call_FormulasList_594272; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## formulasList
  ## List formulas in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594285 = newJObject()
  var query_594286 = newJObject()
  add(query_594286, "$orderby", newJString(Orderby))
  add(path_594285, "resourceGroupName", newJString(resourceGroupName))
  add(query_594286, "$expand", newJString(Expand))
  add(query_594286, "api-version", newJString(apiVersion))
  add(path_594285, "subscriptionId", newJString(subscriptionId))
  add(query_594286, "$top", newJInt(Top))
  add(path_594285, "labName", newJString(labName))
  add(query_594286, "$filter", newJString(Filter))
  result = call_594284.call(path_594285, query_594286, nil, nil, nil)

var formulasList* = Call_FormulasList_594272(name: "formulasList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas",
    validator: validate_FormulasList_594273, base: "", url: url_FormulasList_594274,
    schemes: {Scheme.Https})
type
  Call_FormulasCreateOrUpdate_594300 = ref object of OpenApiRestCall_593437
proc url_FormulasCreateOrUpdate_594302(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulasCreateOrUpdate_594301(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing formula. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594303 = path.getOrDefault("resourceGroupName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "resourceGroupName", valid_594303
  var valid_594304 = path.getOrDefault("name")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "name", valid_594304
  var valid_594305 = path.getOrDefault("subscriptionId")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "subscriptionId", valid_594305
  var valid_594306 = path.getOrDefault("labName")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "labName", valid_594306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594307 = query.getOrDefault("api-version")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594307 != nil:
    section.add "api-version", valid_594307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   formula: JObject (required)
  ##          : A formula for creating a VM, specifying an image base and other parameters
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594309: Call_FormulasCreateOrUpdate_594300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing formula. This operation can take a while to complete.
  ## 
  let valid = call_594309.validator(path, query, header, formData, body)
  let scheme = call_594309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594309.url(scheme.get, call_594309.host, call_594309.base,
                         call_594309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594309, url, valid)

proc call*(call_594310: Call_FormulasCreateOrUpdate_594300;
          resourceGroupName: string; formula: JsonNode; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## formulasCreateOrUpdate
  ## Create or replace an existing formula. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   formula: JObject (required)
  ##          : A formula for creating a VM, specifying an image base and other parameters
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594311 = newJObject()
  var query_594312 = newJObject()
  var body_594313 = newJObject()
  add(path_594311, "resourceGroupName", newJString(resourceGroupName))
  if formula != nil:
    body_594313 = formula
  add(query_594312, "api-version", newJString(apiVersion))
  add(path_594311, "name", newJString(name))
  add(path_594311, "subscriptionId", newJString(subscriptionId))
  add(path_594311, "labName", newJString(labName))
  result = call_594310.call(path_594311, query_594312, nil, nil, body_594313)

var formulasCreateOrUpdate* = Call_FormulasCreateOrUpdate_594300(
    name: "formulasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasCreateOrUpdate_594301, base: "",
    url: url_FormulasCreateOrUpdate_594302, schemes: {Scheme.Https})
type
  Call_FormulasGet_594287 = ref object of OpenApiRestCall_593437
proc url_FormulasGet_594289(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulasGet_594288(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594290 = path.getOrDefault("resourceGroupName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "resourceGroupName", valid_594290
  var valid_594291 = path.getOrDefault("name")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "name", valid_594291
  var valid_594292 = path.getOrDefault("subscriptionId")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "subscriptionId", valid_594292
  var valid_594293 = path.getOrDefault("labName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "labName", valid_594293
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594294 = query.getOrDefault("$expand")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "$expand", valid_594294
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594295 = query.getOrDefault("api-version")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594295 != nil:
    section.add "api-version", valid_594295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594296: Call_FormulasGet_594287; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get formula.
  ## 
  let valid = call_594296.validator(path, query, header, formData, body)
  let scheme = call_594296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594296.url(scheme.get, call_594296.host, call_594296.base,
                         call_594296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594296, url, valid)

proc call*(call_594297: Call_FormulasGet_594287; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
  ## formulasGet
  ## Get formula.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   name: string (required)
  ##       : The name of the formula.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594298 = newJObject()
  var query_594299 = newJObject()
  add(path_594298, "resourceGroupName", newJString(resourceGroupName))
  add(query_594299, "$expand", newJString(Expand))
  add(path_594298, "name", newJString(name))
  add(query_594299, "api-version", newJString(apiVersion))
  add(path_594298, "subscriptionId", newJString(subscriptionId))
  add(path_594298, "labName", newJString(labName))
  result = call_594297.call(path_594298, query_594299, nil, nil, nil)

var formulasGet* = Call_FormulasGet_594287(name: "formulasGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
                                        validator: validate_FormulasGet_594288,
                                        base: "", url: url_FormulasGet_594289,
                                        schemes: {Scheme.Https})
type
  Call_FormulasUpdate_594326 = ref object of OpenApiRestCall_593437
proc url_FormulasUpdate_594328(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulasUpdate_594327(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Allows modifying tags of formulas. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594329 = path.getOrDefault("resourceGroupName")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "resourceGroupName", valid_594329
  var valid_594330 = path.getOrDefault("name")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "name", valid_594330
  var valid_594331 = path.getOrDefault("subscriptionId")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "subscriptionId", valid_594331
  var valid_594332 = path.getOrDefault("labName")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "labName", valid_594332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594333 = query.getOrDefault("api-version")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594333 != nil:
    section.add "api-version", valid_594333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   formula: JObject (required)
  ##          : A formula for creating a VM, specifying an image base and other parameters
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594335: Call_FormulasUpdate_594326; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of formulas. All other properties will be ignored.
  ## 
  let valid = call_594335.validator(path, query, header, formData, body)
  let scheme = call_594335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594335.url(scheme.get, call_594335.host, call_594335.base,
                         call_594335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594335, url, valid)

proc call*(call_594336: Call_FormulasUpdate_594326; resourceGroupName: string;
          formula: JsonNode; name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## formulasUpdate
  ## Allows modifying tags of formulas. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   formula: JObject (required)
  ##          : A formula for creating a VM, specifying an image base and other parameters
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594337 = newJObject()
  var query_594338 = newJObject()
  var body_594339 = newJObject()
  add(path_594337, "resourceGroupName", newJString(resourceGroupName))
  if formula != nil:
    body_594339 = formula
  add(query_594338, "api-version", newJString(apiVersion))
  add(path_594337, "name", newJString(name))
  add(path_594337, "subscriptionId", newJString(subscriptionId))
  add(path_594337, "labName", newJString(labName))
  result = call_594336.call(path_594337, query_594338, nil, nil, body_594339)

var formulasUpdate* = Call_FormulasUpdate_594326(name: "formulasUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasUpdate_594327, base: "", url: url_FormulasUpdate_594328,
    schemes: {Scheme.Https})
type
  Call_FormulasDelete_594314 = ref object of OpenApiRestCall_593437
proc url_FormulasDelete_594316(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulasDelete_594315(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594317 = path.getOrDefault("resourceGroupName")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "resourceGroupName", valid_594317
  var valid_594318 = path.getOrDefault("name")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "name", valid_594318
  var valid_594319 = path.getOrDefault("subscriptionId")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "subscriptionId", valid_594319
  var valid_594320 = path.getOrDefault("labName")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "labName", valid_594320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594321 = query.getOrDefault("api-version")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594321 != nil:
    section.add "api-version", valid_594321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594322: Call_FormulasDelete_594314; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete formula.
  ## 
  let valid = call_594322.validator(path, query, header, formData, body)
  let scheme = call_594322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594322.url(scheme.get, call_594322.host, call_594322.base,
                         call_594322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594322, url, valid)

proc call*(call_594323: Call_FormulasDelete_594314; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## formulasDelete
  ## Delete formula.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594324 = newJObject()
  var query_594325 = newJObject()
  add(path_594324, "resourceGroupName", newJString(resourceGroupName))
  add(query_594325, "api-version", newJString(apiVersion))
  add(path_594324, "name", newJString(name))
  add(path_594324, "subscriptionId", newJString(subscriptionId))
  add(path_594324, "labName", newJString(labName))
  result = call_594323.call(path_594324, query_594325, nil, nil, nil)

var formulasDelete* = Call_FormulasDelete_594314(name: "formulasDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasDelete_594315, base: "", url: url_FormulasDelete_594316,
    schemes: {Scheme.Https})
type
  Call_GalleryImagesList_594340 = ref object of OpenApiRestCall_593437
proc url_GalleryImagesList_594342(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/galleryimages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImagesList_594341(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List gallery images in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594343 = path.getOrDefault("resourceGroupName")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "resourceGroupName", valid_594343
  var valid_594344 = path.getOrDefault("subscriptionId")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "subscriptionId", valid_594344
  var valid_594345 = path.getOrDefault("labName")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "labName", valid_594345
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=author)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594346 = query.getOrDefault("$orderby")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = nil)
  if valid_594346 != nil:
    section.add "$orderby", valid_594346
  var valid_594347 = query.getOrDefault("$expand")
  valid_594347 = validateParameter(valid_594347, JString, required = false,
                                 default = nil)
  if valid_594347 != nil:
    section.add "$expand", valid_594347
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594348 = query.getOrDefault("api-version")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594348 != nil:
    section.add "api-version", valid_594348
  var valid_594349 = query.getOrDefault("$top")
  valid_594349 = validateParameter(valid_594349, JInt, required = false, default = nil)
  if valid_594349 != nil:
    section.add "$top", valid_594349
  var valid_594350 = query.getOrDefault("$filter")
  valid_594350 = validateParameter(valid_594350, JString, required = false,
                                 default = nil)
  if valid_594350 != nil:
    section.add "$filter", valid_594350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594351: Call_GalleryImagesList_594340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery images in a given lab.
  ## 
  let valid = call_594351.validator(path, query, header, formData, body)
  let scheme = call_594351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594351.url(scheme.get, call_594351.host, call_594351.base,
                         call_594351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594351, url, valid)

proc call*(call_594352: Call_GalleryImagesList_594340; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## galleryImagesList
  ## List gallery images in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=author)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594353 = newJObject()
  var query_594354 = newJObject()
  add(query_594354, "$orderby", newJString(Orderby))
  add(path_594353, "resourceGroupName", newJString(resourceGroupName))
  add(query_594354, "$expand", newJString(Expand))
  add(query_594354, "api-version", newJString(apiVersion))
  add(path_594353, "subscriptionId", newJString(subscriptionId))
  add(query_594354, "$top", newJInt(Top))
  add(path_594353, "labName", newJString(labName))
  add(query_594354, "$filter", newJString(Filter))
  result = call_594352.call(path_594353, query_594354, nil, nil, nil)

var galleryImagesList* = Call_GalleryImagesList_594340(name: "galleryImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/galleryimages",
    validator: validate_GalleryImagesList_594341, base: "",
    url: url_GalleryImagesList_594342, schemes: {Scheme.Https})
type
  Call_NotificationChannelsList_594355 = ref object of OpenApiRestCall_593437
proc url_NotificationChannelsList_594357(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/notificationchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationChannelsList_594356(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List notification channels in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594358 = path.getOrDefault("resourceGroupName")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "resourceGroupName", valid_594358
  var valid_594359 = path.getOrDefault("subscriptionId")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "subscriptionId", valid_594359
  var valid_594360 = path.getOrDefault("labName")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "labName", valid_594360
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594361 = query.getOrDefault("$orderby")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "$orderby", valid_594361
  var valid_594362 = query.getOrDefault("$expand")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "$expand", valid_594362
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594363 = query.getOrDefault("api-version")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594363 != nil:
    section.add "api-version", valid_594363
  var valid_594364 = query.getOrDefault("$top")
  valid_594364 = validateParameter(valid_594364, JInt, required = false, default = nil)
  if valid_594364 != nil:
    section.add "$top", valid_594364
  var valid_594365 = query.getOrDefault("$filter")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "$filter", valid_594365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594366: Call_NotificationChannelsList_594355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List notification channels in a given lab.
  ## 
  let valid = call_594366.validator(path, query, header, formData, body)
  let scheme = call_594366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594366.url(scheme.get, call_594366.host, call_594366.base,
                         call_594366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594366, url, valid)

proc call*(call_594367: Call_NotificationChannelsList_594355;
          resourceGroupName: string; subscriptionId: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## notificationChannelsList
  ## List notification channels in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594368 = newJObject()
  var query_594369 = newJObject()
  add(query_594369, "$orderby", newJString(Orderby))
  add(path_594368, "resourceGroupName", newJString(resourceGroupName))
  add(query_594369, "$expand", newJString(Expand))
  add(query_594369, "api-version", newJString(apiVersion))
  add(path_594368, "subscriptionId", newJString(subscriptionId))
  add(query_594369, "$top", newJInt(Top))
  add(path_594368, "labName", newJString(labName))
  add(query_594369, "$filter", newJString(Filter))
  result = call_594367.call(path_594368, query_594369, nil, nil, nil)

var notificationChannelsList* = Call_NotificationChannelsList_594355(
    name: "notificationChannelsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels",
    validator: validate_NotificationChannelsList_594356, base: "",
    url: url_NotificationChannelsList_594357, schemes: {Scheme.Https})
type
  Call_NotificationChannelsCreateOrUpdate_594383 = ref object of OpenApiRestCall_593437
proc url_NotificationChannelsCreateOrUpdate_594385(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/notificationchannels/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationChannelsCreateOrUpdate_594384(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing notification channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594386 = path.getOrDefault("resourceGroupName")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "resourceGroupName", valid_594386
  var valid_594387 = path.getOrDefault("name")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "name", valid_594387
  var valid_594388 = path.getOrDefault("subscriptionId")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "subscriptionId", valid_594388
  var valid_594389 = path.getOrDefault("labName")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "labName", valid_594389
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594390 = query.getOrDefault("api-version")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594390 != nil:
    section.add "api-version", valid_594390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594392: Call_NotificationChannelsCreateOrUpdate_594383;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing notification channel.
  ## 
  let valid = call_594392.validator(path, query, header, formData, body)
  let scheme = call_594392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594392.url(scheme.get, call_594392.host, call_594392.base,
                         call_594392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594392, url, valid)

proc call*(call_594393: Call_NotificationChannelsCreateOrUpdate_594383;
          notificationChannel: JsonNode; resourceGroupName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsCreateOrUpdate
  ## Create or replace an existing notification channel.
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594394 = newJObject()
  var query_594395 = newJObject()
  var body_594396 = newJObject()
  if notificationChannel != nil:
    body_594396 = notificationChannel
  add(path_594394, "resourceGroupName", newJString(resourceGroupName))
  add(query_594395, "api-version", newJString(apiVersion))
  add(path_594394, "name", newJString(name))
  add(path_594394, "subscriptionId", newJString(subscriptionId))
  add(path_594394, "labName", newJString(labName))
  result = call_594393.call(path_594394, query_594395, nil, nil, body_594396)

var notificationChannelsCreateOrUpdate* = Call_NotificationChannelsCreateOrUpdate_594383(
    name: "notificationChannelsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsCreateOrUpdate_594384, base: "",
    url: url_NotificationChannelsCreateOrUpdate_594385, schemes: {Scheme.Https})
type
  Call_NotificationChannelsGet_594370 = ref object of OpenApiRestCall_593437
proc url_NotificationChannelsGet_594372(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/notificationchannels/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationChannelsGet_594371(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get notification channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594373 = path.getOrDefault("resourceGroupName")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "resourceGroupName", valid_594373
  var valid_594374 = path.getOrDefault("name")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "name", valid_594374
  var valid_594375 = path.getOrDefault("subscriptionId")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "subscriptionId", valid_594375
  var valid_594376 = path.getOrDefault("labName")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "labName", valid_594376
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594377 = query.getOrDefault("$expand")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = nil)
  if valid_594377 != nil:
    section.add "$expand", valid_594377
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594378 = query.getOrDefault("api-version")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594378 != nil:
    section.add "api-version", valid_594378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594379: Call_NotificationChannelsGet_594370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get notification channel.
  ## 
  let valid = call_594379.validator(path, query, header, formData, body)
  let scheme = call_594379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594379.url(scheme.get, call_594379.host, call_594379.base,
                         call_594379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594379, url, valid)

proc call*(call_594380: Call_NotificationChannelsGet_594370;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsGet
  ## Get notification channel.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594381 = newJObject()
  var query_594382 = newJObject()
  add(path_594381, "resourceGroupName", newJString(resourceGroupName))
  add(query_594382, "$expand", newJString(Expand))
  add(path_594381, "name", newJString(name))
  add(query_594382, "api-version", newJString(apiVersion))
  add(path_594381, "subscriptionId", newJString(subscriptionId))
  add(path_594381, "labName", newJString(labName))
  result = call_594380.call(path_594381, query_594382, nil, nil, nil)

var notificationChannelsGet* = Call_NotificationChannelsGet_594370(
    name: "notificationChannelsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsGet_594371, base: "",
    url: url_NotificationChannelsGet_594372, schemes: {Scheme.Https})
type
  Call_NotificationChannelsUpdate_594409 = ref object of OpenApiRestCall_593437
proc url_NotificationChannelsUpdate_594411(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/notificationchannels/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationChannelsUpdate_594410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of notification channels. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594412 = path.getOrDefault("resourceGroupName")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "resourceGroupName", valid_594412
  var valid_594413 = path.getOrDefault("name")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "name", valid_594413
  var valid_594414 = path.getOrDefault("subscriptionId")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "subscriptionId", valid_594414
  var valid_594415 = path.getOrDefault("labName")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "labName", valid_594415
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594416 = query.getOrDefault("api-version")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594416 != nil:
    section.add "api-version", valid_594416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594418: Call_NotificationChannelsUpdate_594409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of notification channels. All other properties will be ignored.
  ## 
  let valid = call_594418.validator(path, query, header, formData, body)
  let scheme = call_594418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594418.url(scheme.get, call_594418.host, call_594418.base,
                         call_594418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594418, url, valid)

proc call*(call_594419: Call_NotificationChannelsUpdate_594409;
          notificationChannel: JsonNode; resourceGroupName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsUpdate
  ## Allows modifying tags of notification channels. All other properties will be ignored.
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594420 = newJObject()
  var query_594421 = newJObject()
  var body_594422 = newJObject()
  if notificationChannel != nil:
    body_594422 = notificationChannel
  add(path_594420, "resourceGroupName", newJString(resourceGroupName))
  add(query_594421, "api-version", newJString(apiVersion))
  add(path_594420, "name", newJString(name))
  add(path_594420, "subscriptionId", newJString(subscriptionId))
  add(path_594420, "labName", newJString(labName))
  result = call_594419.call(path_594420, query_594421, nil, nil, body_594422)

var notificationChannelsUpdate* = Call_NotificationChannelsUpdate_594409(
    name: "notificationChannelsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsUpdate_594410, base: "",
    url: url_NotificationChannelsUpdate_594411, schemes: {Scheme.Https})
type
  Call_NotificationChannelsDelete_594397 = ref object of OpenApiRestCall_593437
proc url_NotificationChannelsDelete_594399(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/notificationchannels/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationChannelsDelete_594398(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete notification channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594400 = path.getOrDefault("resourceGroupName")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "resourceGroupName", valid_594400
  var valid_594401 = path.getOrDefault("name")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "name", valid_594401
  var valid_594402 = path.getOrDefault("subscriptionId")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "subscriptionId", valid_594402
  var valid_594403 = path.getOrDefault("labName")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "labName", valid_594403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594404 = query.getOrDefault("api-version")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594404 != nil:
    section.add "api-version", valid_594404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594405: Call_NotificationChannelsDelete_594397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete notification channel.
  ## 
  let valid = call_594405.validator(path, query, header, formData, body)
  let scheme = call_594405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594405.url(scheme.get, call_594405.host, call_594405.base,
                         call_594405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594405, url, valid)

proc call*(call_594406: Call_NotificationChannelsDelete_594397;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsDelete
  ## Delete notification channel.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594407 = newJObject()
  var query_594408 = newJObject()
  add(path_594407, "resourceGroupName", newJString(resourceGroupName))
  add(query_594408, "api-version", newJString(apiVersion))
  add(path_594407, "name", newJString(name))
  add(path_594407, "subscriptionId", newJString(subscriptionId))
  add(path_594407, "labName", newJString(labName))
  result = call_594406.call(path_594407, query_594408, nil, nil, nil)

var notificationChannelsDelete* = Call_NotificationChannelsDelete_594397(
    name: "notificationChannelsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsDelete_594398, base: "",
    url: url_NotificationChannelsDelete_594399, schemes: {Scheme.Https})
type
  Call_NotificationChannelsNotify_594423 = ref object of OpenApiRestCall_593437
proc url_NotificationChannelsNotify_594425(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/notificationchannels/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationChannelsNotify_594424(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send notification to provided channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594426 = path.getOrDefault("resourceGroupName")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "resourceGroupName", valid_594426
  var valid_594427 = path.getOrDefault("name")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "name", valid_594427
  var valid_594428 = path.getOrDefault("subscriptionId")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "subscriptionId", valid_594428
  var valid_594429 = path.getOrDefault("labName")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "labName", valid_594429
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594430 = query.getOrDefault("api-version")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594430 != nil:
    section.add "api-version", valid_594430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   notifyParameters: JObject (required)
  ##                   : Properties for generating a Notification.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594432: Call_NotificationChannelsNotify_594423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send notification to provided channel.
  ## 
  let valid = call_594432.validator(path, query, header, formData, body)
  let scheme = call_594432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594432.url(scheme.get, call_594432.host, call_594432.base,
                         call_594432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594432, url, valid)

proc call*(call_594433: Call_NotificationChannelsNotify_594423;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; notifyParameters: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsNotify
  ## Send notification to provided channel.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   notifyParameters: JObject (required)
  ##                   : Properties for generating a Notification.
  var path_594434 = newJObject()
  var query_594435 = newJObject()
  var body_594436 = newJObject()
  add(path_594434, "resourceGroupName", newJString(resourceGroupName))
  add(query_594435, "api-version", newJString(apiVersion))
  add(path_594434, "name", newJString(name))
  add(path_594434, "subscriptionId", newJString(subscriptionId))
  add(path_594434, "labName", newJString(labName))
  if notifyParameters != nil:
    body_594436 = notifyParameters
  result = call_594433.call(path_594434, query_594435, nil, nil, body_594436)

var notificationChannelsNotify* = Call_NotificationChannelsNotify_594423(
    name: "notificationChannelsNotify", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}/notify",
    validator: validate_NotificationChannelsNotify_594424, base: "",
    url: url_NotificationChannelsNotify_594425, schemes: {Scheme.Https})
type
  Call_PolicySetsEvaluatePolicies_594437 = ref object of OpenApiRestCall_593437
proc url_PolicySetsEvaluatePolicies_594439(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/evaluatePolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetsEvaluatePolicies_594438(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Evaluates lab policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594440 = path.getOrDefault("resourceGroupName")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "resourceGroupName", valid_594440
  var valid_594441 = path.getOrDefault("name")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "name", valid_594441
  var valid_594442 = path.getOrDefault("subscriptionId")
  valid_594442 = validateParameter(valid_594442, JString, required = true,
                                 default = nil)
  if valid_594442 != nil:
    section.add "subscriptionId", valid_594442
  var valid_594443 = path.getOrDefault("labName")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "labName", valid_594443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594444 = query.getOrDefault("api-version")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594444 != nil:
    section.add "api-version", valid_594444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   evaluatePoliciesRequest: JObject (required)
  ##                          : Request body for evaluating a policy set.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594446: Call_PolicySetsEvaluatePolicies_594437; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Evaluates lab policy.
  ## 
  let valid = call_594446.validator(path, query, header, formData, body)
  let scheme = call_594446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594446.url(scheme.get, call_594446.host, call_594446.base,
                         call_594446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594446, url, valid)

proc call*(call_594447: Call_PolicySetsEvaluatePolicies_594437;
          resourceGroupName: string; name: string; subscriptionId: string;
          evaluatePoliciesRequest: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## policySetsEvaluatePolicies
  ## Evaluates lab policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   evaluatePoliciesRequest: JObject (required)
  ##                          : Request body for evaluating a policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594448 = newJObject()
  var query_594449 = newJObject()
  var body_594450 = newJObject()
  add(path_594448, "resourceGroupName", newJString(resourceGroupName))
  add(query_594449, "api-version", newJString(apiVersion))
  add(path_594448, "name", newJString(name))
  add(path_594448, "subscriptionId", newJString(subscriptionId))
  if evaluatePoliciesRequest != nil:
    body_594450 = evaluatePoliciesRequest
  add(path_594448, "labName", newJString(labName))
  result = call_594447.call(path_594448, query_594449, nil, nil, body_594450)

var policySetsEvaluatePolicies* = Call_PolicySetsEvaluatePolicies_594437(
    name: "policySetsEvaluatePolicies", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{name}/evaluatePolicies",
    validator: validate_PolicySetsEvaluatePolicies_594438, base: "",
    url: url_PolicySetsEvaluatePolicies_594439, schemes: {Scheme.Https})
type
  Call_PoliciesList_594451 = ref object of OpenApiRestCall_593437
proc url_PoliciesList_594453(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesList_594452(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List policies in a given policy set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594454 = path.getOrDefault("resourceGroupName")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "resourceGroupName", valid_594454
  var valid_594455 = path.getOrDefault("subscriptionId")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "subscriptionId", valid_594455
  var valid_594456 = path.getOrDefault("policySetName")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "policySetName", valid_594456
  var valid_594457 = path.getOrDefault("labName")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = nil)
  if valid_594457 != nil:
    section.add "labName", valid_594457
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594458 = query.getOrDefault("$orderby")
  valid_594458 = validateParameter(valid_594458, JString, required = false,
                                 default = nil)
  if valid_594458 != nil:
    section.add "$orderby", valid_594458
  var valid_594459 = query.getOrDefault("$expand")
  valid_594459 = validateParameter(valid_594459, JString, required = false,
                                 default = nil)
  if valid_594459 != nil:
    section.add "$expand", valid_594459
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594460 = query.getOrDefault("api-version")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594460 != nil:
    section.add "api-version", valid_594460
  var valid_594461 = query.getOrDefault("$top")
  valid_594461 = validateParameter(valid_594461, JInt, required = false, default = nil)
  if valid_594461 != nil:
    section.add "$top", valid_594461
  var valid_594462 = query.getOrDefault("$filter")
  valid_594462 = validateParameter(valid_594462, JString, required = false,
                                 default = nil)
  if valid_594462 != nil:
    section.add "$filter", valid_594462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594463: Call_PoliciesList_594451; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List policies in a given policy set.
  ## 
  let valid = call_594463.validator(path, query, header, formData, body)
  let scheme = call_594463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594463.url(scheme.get, call_594463.host, call_594463.base,
                         call_594463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594463, url, valid)

proc call*(call_594464: Call_PoliciesList_594451; resourceGroupName: string;
          subscriptionId: string; policySetName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## policiesList
  ## List policies in a given policy set.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594465 = newJObject()
  var query_594466 = newJObject()
  add(query_594466, "$orderby", newJString(Orderby))
  add(path_594465, "resourceGroupName", newJString(resourceGroupName))
  add(query_594466, "$expand", newJString(Expand))
  add(query_594466, "api-version", newJString(apiVersion))
  add(path_594465, "subscriptionId", newJString(subscriptionId))
  add(query_594466, "$top", newJInt(Top))
  add(path_594465, "policySetName", newJString(policySetName))
  add(path_594465, "labName", newJString(labName))
  add(query_594466, "$filter", newJString(Filter))
  result = call_594464.call(path_594465, query_594466, nil, nil, nil)

var policiesList* = Call_PoliciesList_594451(name: "policiesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies",
    validator: validate_PoliciesList_594452, base: "", url: url_PoliciesList_594453,
    schemes: {Scheme.Https})
type
  Call_PoliciesCreateOrUpdate_594481 = ref object of OpenApiRestCall_593437
proc url_PoliciesCreateOrUpdate_594483(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesCreateOrUpdate_594482(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594484 = path.getOrDefault("resourceGroupName")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = nil)
  if valid_594484 != nil:
    section.add "resourceGroupName", valid_594484
  var valid_594485 = path.getOrDefault("name")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "name", valid_594485
  var valid_594486 = path.getOrDefault("subscriptionId")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "subscriptionId", valid_594486
  var valid_594487 = path.getOrDefault("policySetName")
  valid_594487 = validateParameter(valid_594487, JString, required = true,
                                 default = nil)
  if valid_594487 != nil:
    section.add "policySetName", valid_594487
  var valid_594488 = path.getOrDefault("labName")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "labName", valid_594488
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594489 = query.getOrDefault("api-version")
  valid_594489 = validateParameter(valid_594489, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594489 != nil:
    section.add "api-version", valid_594489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   policy: JObject (required)
  ##         : A Policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594491: Call_PoliciesCreateOrUpdate_594481; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing policy.
  ## 
  let valid = call_594491.validator(path, query, header, formData, body)
  let scheme = call_594491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594491.url(scheme.get, call_594491.host, call_594491.base,
                         call_594491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594491, url, valid)

proc call*(call_594492: Call_PoliciesCreateOrUpdate_594481;
          resourceGroupName: string; name: string; subscriptionId: string;
          policySetName: string; labName: string; policy: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## policiesCreateOrUpdate
  ## Create or replace an existing policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   policy: JObject (required)
  ##         : A Policy.
  var path_594493 = newJObject()
  var query_594494 = newJObject()
  var body_594495 = newJObject()
  add(path_594493, "resourceGroupName", newJString(resourceGroupName))
  add(query_594494, "api-version", newJString(apiVersion))
  add(path_594493, "name", newJString(name))
  add(path_594493, "subscriptionId", newJString(subscriptionId))
  add(path_594493, "policySetName", newJString(policySetName))
  add(path_594493, "labName", newJString(labName))
  if policy != nil:
    body_594495 = policy
  result = call_594492.call(path_594493, query_594494, nil, nil, body_594495)

var policiesCreateOrUpdate* = Call_PoliciesCreateOrUpdate_594481(
    name: "policiesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesCreateOrUpdate_594482, base: "",
    url: url_PoliciesCreateOrUpdate_594483, schemes: {Scheme.Https})
type
  Call_PoliciesGet_594467 = ref object of OpenApiRestCall_593437
proc url_PoliciesGet_594469(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesGet_594468(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594470 = path.getOrDefault("resourceGroupName")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "resourceGroupName", valid_594470
  var valid_594471 = path.getOrDefault("name")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "name", valid_594471
  var valid_594472 = path.getOrDefault("subscriptionId")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "subscriptionId", valid_594472
  var valid_594473 = path.getOrDefault("policySetName")
  valid_594473 = validateParameter(valid_594473, JString, required = true,
                                 default = nil)
  if valid_594473 != nil:
    section.add "policySetName", valid_594473
  var valid_594474 = path.getOrDefault("labName")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "labName", valid_594474
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594475 = query.getOrDefault("$expand")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = nil)
  if valid_594475 != nil:
    section.add "$expand", valid_594475
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594476 = query.getOrDefault("api-version")
  valid_594476 = validateParameter(valid_594476, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594476 != nil:
    section.add "api-version", valid_594476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594477: Call_PoliciesGet_594467; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get policy.
  ## 
  let valid = call_594477.validator(path, query, header, formData, body)
  let scheme = call_594477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594477.url(scheme.get, call_594477.host, call_594477.base,
                         call_594477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594477, url, valid)

proc call*(call_594478: Call_PoliciesGet_594467; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## policiesGet
  ## Get policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   name: string (required)
  ##       : The name of the policy.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594479 = newJObject()
  var query_594480 = newJObject()
  add(path_594479, "resourceGroupName", newJString(resourceGroupName))
  add(query_594480, "$expand", newJString(Expand))
  add(path_594479, "name", newJString(name))
  add(query_594480, "api-version", newJString(apiVersion))
  add(path_594479, "subscriptionId", newJString(subscriptionId))
  add(path_594479, "policySetName", newJString(policySetName))
  add(path_594479, "labName", newJString(labName))
  result = call_594478.call(path_594479, query_594480, nil, nil, nil)

var policiesGet* = Call_PoliciesGet_594467(name: "policiesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
                                        validator: validate_PoliciesGet_594468,
                                        base: "", url: url_PoliciesGet_594469,
                                        schemes: {Scheme.Https})
type
  Call_PoliciesUpdate_594509 = ref object of OpenApiRestCall_593437
proc url_PoliciesUpdate_594511(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesUpdate_594510(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Allows modifying tags of policies. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594512 = path.getOrDefault("resourceGroupName")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "resourceGroupName", valid_594512
  var valid_594513 = path.getOrDefault("name")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "name", valid_594513
  var valid_594514 = path.getOrDefault("subscriptionId")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "subscriptionId", valid_594514
  var valid_594515 = path.getOrDefault("policySetName")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = nil)
  if valid_594515 != nil:
    section.add "policySetName", valid_594515
  var valid_594516 = path.getOrDefault("labName")
  valid_594516 = validateParameter(valid_594516, JString, required = true,
                                 default = nil)
  if valid_594516 != nil:
    section.add "labName", valid_594516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594517 = query.getOrDefault("api-version")
  valid_594517 = validateParameter(valid_594517, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594517 != nil:
    section.add "api-version", valid_594517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   policy: JObject (required)
  ##         : A Policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594519: Call_PoliciesUpdate_594509; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of policies. All other properties will be ignored.
  ## 
  let valid = call_594519.validator(path, query, header, formData, body)
  let scheme = call_594519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594519.url(scheme.get, call_594519.host, call_594519.base,
                         call_594519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594519, url, valid)

proc call*(call_594520: Call_PoliciesUpdate_594509; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; policy: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## policiesUpdate
  ## Allows modifying tags of policies. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   policy: JObject (required)
  ##         : A Policy.
  var path_594521 = newJObject()
  var query_594522 = newJObject()
  var body_594523 = newJObject()
  add(path_594521, "resourceGroupName", newJString(resourceGroupName))
  add(query_594522, "api-version", newJString(apiVersion))
  add(path_594521, "name", newJString(name))
  add(path_594521, "subscriptionId", newJString(subscriptionId))
  add(path_594521, "policySetName", newJString(policySetName))
  add(path_594521, "labName", newJString(labName))
  if policy != nil:
    body_594523 = policy
  result = call_594520.call(path_594521, query_594522, nil, nil, body_594523)

var policiesUpdate* = Call_PoliciesUpdate_594509(name: "policiesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesUpdate_594510, base: "", url: url_PoliciesUpdate_594511,
    schemes: {Scheme.Https})
type
  Call_PoliciesDelete_594496 = ref object of OpenApiRestCall_593437
proc url_PoliciesDelete_594498(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesDelete_594497(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594499 = path.getOrDefault("resourceGroupName")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "resourceGroupName", valid_594499
  var valid_594500 = path.getOrDefault("name")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "name", valid_594500
  var valid_594501 = path.getOrDefault("subscriptionId")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "subscriptionId", valid_594501
  var valid_594502 = path.getOrDefault("policySetName")
  valid_594502 = validateParameter(valid_594502, JString, required = true,
                                 default = nil)
  if valid_594502 != nil:
    section.add "policySetName", valid_594502
  var valid_594503 = path.getOrDefault("labName")
  valid_594503 = validateParameter(valid_594503, JString, required = true,
                                 default = nil)
  if valid_594503 != nil:
    section.add "labName", valid_594503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594504 = query.getOrDefault("api-version")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594504 != nil:
    section.add "api-version", valid_594504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594505: Call_PoliciesDelete_594496; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy.
  ## 
  let valid = call_594505.validator(path, query, header, formData, body)
  let scheme = call_594505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594505.url(scheme.get, call_594505.host, call_594505.base,
                         call_594505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594505, url, valid)

proc call*(call_594506: Call_PoliciesDelete_594496; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## policiesDelete
  ## Delete policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594507 = newJObject()
  var query_594508 = newJObject()
  add(path_594507, "resourceGroupName", newJString(resourceGroupName))
  add(query_594508, "api-version", newJString(apiVersion))
  add(path_594507, "name", newJString(name))
  add(path_594507, "subscriptionId", newJString(subscriptionId))
  add(path_594507, "policySetName", newJString(policySetName))
  add(path_594507, "labName", newJString(labName))
  result = call_594506.call(path_594507, query_594508, nil, nil, nil)

var policiesDelete* = Call_PoliciesDelete_594496(name: "policiesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesDelete_594497, base: "", url: url_PoliciesDelete_594498,
    schemes: {Scheme.Https})
type
  Call_SchedulesList_594524 = ref object of OpenApiRestCall_593437
proc url_SchedulesList_594526(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesList_594525(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594527 = path.getOrDefault("resourceGroupName")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "resourceGroupName", valid_594527
  var valid_594528 = path.getOrDefault("subscriptionId")
  valid_594528 = validateParameter(valid_594528, JString, required = true,
                                 default = nil)
  if valid_594528 != nil:
    section.add "subscriptionId", valid_594528
  var valid_594529 = path.getOrDefault("labName")
  valid_594529 = validateParameter(valid_594529, JString, required = true,
                                 default = nil)
  if valid_594529 != nil:
    section.add "labName", valid_594529
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594530 = query.getOrDefault("$orderby")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = nil)
  if valid_594530 != nil:
    section.add "$orderby", valid_594530
  var valid_594531 = query.getOrDefault("$expand")
  valid_594531 = validateParameter(valid_594531, JString, required = false,
                                 default = nil)
  if valid_594531 != nil:
    section.add "$expand", valid_594531
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594532 = query.getOrDefault("api-version")
  valid_594532 = validateParameter(valid_594532, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594532 != nil:
    section.add "api-version", valid_594532
  var valid_594533 = query.getOrDefault("$top")
  valid_594533 = validateParameter(valid_594533, JInt, required = false, default = nil)
  if valid_594533 != nil:
    section.add "$top", valid_594533
  var valid_594534 = query.getOrDefault("$filter")
  valid_594534 = validateParameter(valid_594534, JString, required = false,
                                 default = nil)
  if valid_594534 != nil:
    section.add "$filter", valid_594534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594535: Call_SchedulesList_594524; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given lab.
  ## 
  let valid = call_594535.validator(path, query, header, formData, body)
  let scheme = call_594535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594535.url(scheme.get, call_594535.host, call_594535.base,
                         call_594535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594535, url, valid)

proc call*(call_594536: Call_SchedulesList_594524; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## schedulesList
  ## List schedules in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594537 = newJObject()
  var query_594538 = newJObject()
  add(query_594538, "$orderby", newJString(Orderby))
  add(path_594537, "resourceGroupName", newJString(resourceGroupName))
  add(query_594538, "$expand", newJString(Expand))
  add(query_594538, "api-version", newJString(apiVersion))
  add(path_594537, "subscriptionId", newJString(subscriptionId))
  add(query_594538, "$top", newJInt(Top))
  add(path_594537, "labName", newJString(labName))
  add(query_594538, "$filter", newJString(Filter))
  result = call_594536.call(path_594537, query_594538, nil, nil, nil)

var schedulesList* = Call_SchedulesList_594524(name: "schedulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules",
    validator: validate_SchedulesList_594525, base: "", url: url_SchedulesList_594526,
    schemes: {Scheme.Https})
type
  Call_SchedulesCreateOrUpdate_594552 = ref object of OpenApiRestCall_593437
proc url_SchedulesCreateOrUpdate_594554(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesCreateOrUpdate_594553(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594555 = path.getOrDefault("resourceGroupName")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = nil)
  if valid_594555 != nil:
    section.add "resourceGroupName", valid_594555
  var valid_594556 = path.getOrDefault("name")
  valid_594556 = validateParameter(valid_594556, JString, required = true,
                                 default = nil)
  if valid_594556 != nil:
    section.add "name", valid_594556
  var valid_594557 = path.getOrDefault("subscriptionId")
  valid_594557 = validateParameter(valid_594557, JString, required = true,
                                 default = nil)
  if valid_594557 != nil:
    section.add "subscriptionId", valid_594557
  var valid_594558 = path.getOrDefault("labName")
  valid_594558 = validateParameter(valid_594558, JString, required = true,
                                 default = nil)
  if valid_594558 != nil:
    section.add "labName", valid_594558
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594559 = query.getOrDefault("api-version")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594559 != nil:
    section.add "api-version", valid_594559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594561: Call_SchedulesCreateOrUpdate_594552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_594561.validator(path, query, header, formData, body)
  let scheme = call_594561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594561.url(scheme.get, call_594561.host, call_594561.base,
                         call_594561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594561, url, valid)

proc call*(call_594562: Call_SchedulesCreateOrUpdate_594552;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; schedule: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## schedulesCreateOrUpdate
  ## Create or replace an existing schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_594563 = newJObject()
  var query_594564 = newJObject()
  var body_594565 = newJObject()
  add(path_594563, "resourceGroupName", newJString(resourceGroupName))
  add(query_594564, "api-version", newJString(apiVersion))
  add(path_594563, "name", newJString(name))
  add(path_594563, "subscriptionId", newJString(subscriptionId))
  add(path_594563, "labName", newJString(labName))
  if schedule != nil:
    body_594565 = schedule
  result = call_594562.call(path_594563, query_594564, nil, nil, body_594565)

var schedulesCreateOrUpdate* = Call_SchedulesCreateOrUpdate_594552(
    name: "schedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesCreateOrUpdate_594553, base: "",
    url: url_SchedulesCreateOrUpdate_594554, schemes: {Scheme.Https})
type
  Call_SchedulesGet_594539 = ref object of OpenApiRestCall_593437
proc url_SchedulesGet_594541(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesGet_594540(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594542 = path.getOrDefault("resourceGroupName")
  valid_594542 = validateParameter(valid_594542, JString, required = true,
                                 default = nil)
  if valid_594542 != nil:
    section.add "resourceGroupName", valid_594542
  var valid_594543 = path.getOrDefault("name")
  valid_594543 = validateParameter(valid_594543, JString, required = true,
                                 default = nil)
  if valid_594543 != nil:
    section.add "name", valid_594543
  var valid_594544 = path.getOrDefault("subscriptionId")
  valid_594544 = validateParameter(valid_594544, JString, required = true,
                                 default = nil)
  if valid_594544 != nil:
    section.add "subscriptionId", valid_594544
  var valid_594545 = path.getOrDefault("labName")
  valid_594545 = validateParameter(valid_594545, JString, required = true,
                                 default = nil)
  if valid_594545 != nil:
    section.add "labName", valid_594545
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594546 = query.getOrDefault("$expand")
  valid_594546 = validateParameter(valid_594546, JString, required = false,
                                 default = nil)
  if valid_594546 != nil:
    section.add "$expand", valid_594546
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594547 = query.getOrDefault("api-version")
  valid_594547 = validateParameter(valid_594547, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594547 != nil:
    section.add "api-version", valid_594547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594548: Call_SchedulesGet_594539; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_594548.validator(path, query, header, formData, body)
  let scheme = call_594548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594548.url(scheme.get, call_594548.host, call_594548.base,
                         call_594548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594548, url, valid)

proc call*(call_594549: Call_SchedulesGet_594539; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
  ## schedulesGet
  ## Get schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594550 = newJObject()
  var query_594551 = newJObject()
  add(path_594550, "resourceGroupName", newJString(resourceGroupName))
  add(query_594551, "$expand", newJString(Expand))
  add(path_594550, "name", newJString(name))
  add(query_594551, "api-version", newJString(apiVersion))
  add(path_594550, "subscriptionId", newJString(subscriptionId))
  add(path_594550, "labName", newJString(labName))
  result = call_594549.call(path_594550, query_594551, nil, nil, nil)

var schedulesGet* = Call_SchedulesGet_594539(name: "schedulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesGet_594540, base: "", url: url_SchedulesGet_594541,
    schemes: {Scheme.Https})
type
  Call_SchedulesUpdate_594578 = ref object of OpenApiRestCall_593437
proc url_SchedulesUpdate_594580(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesUpdate_594579(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594581 = path.getOrDefault("resourceGroupName")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "resourceGroupName", valid_594581
  var valid_594582 = path.getOrDefault("name")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "name", valid_594582
  var valid_594583 = path.getOrDefault("subscriptionId")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "subscriptionId", valid_594583
  var valid_594584 = path.getOrDefault("labName")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "labName", valid_594584
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594585 = query.getOrDefault("api-version")
  valid_594585 = validateParameter(valid_594585, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594585 != nil:
    section.add "api-version", valid_594585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594587: Call_SchedulesUpdate_594578; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  let valid = call_594587.validator(path, query, header, formData, body)
  let scheme = call_594587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594587.url(scheme.get, call_594587.host, call_594587.base,
                         call_594587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594587, url, valid)

proc call*(call_594588: Call_SchedulesUpdate_594578; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; schedule: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## schedulesUpdate
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_594589 = newJObject()
  var query_594590 = newJObject()
  var body_594591 = newJObject()
  add(path_594589, "resourceGroupName", newJString(resourceGroupName))
  add(query_594590, "api-version", newJString(apiVersion))
  add(path_594589, "name", newJString(name))
  add(path_594589, "subscriptionId", newJString(subscriptionId))
  add(path_594589, "labName", newJString(labName))
  if schedule != nil:
    body_594591 = schedule
  result = call_594588.call(path_594589, query_594590, nil, nil, body_594591)

var schedulesUpdate* = Call_SchedulesUpdate_594578(name: "schedulesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesUpdate_594579, base: "", url: url_SchedulesUpdate_594580,
    schemes: {Scheme.Https})
type
  Call_SchedulesDelete_594566 = ref object of OpenApiRestCall_593437
proc url_SchedulesDelete_594568(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesDelete_594567(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594569 = path.getOrDefault("resourceGroupName")
  valid_594569 = validateParameter(valid_594569, JString, required = true,
                                 default = nil)
  if valid_594569 != nil:
    section.add "resourceGroupName", valid_594569
  var valid_594570 = path.getOrDefault("name")
  valid_594570 = validateParameter(valid_594570, JString, required = true,
                                 default = nil)
  if valid_594570 != nil:
    section.add "name", valid_594570
  var valid_594571 = path.getOrDefault("subscriptionId")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "subscriptionId", valid_594571
  var valid_594572 = path.getOrDefault("labName")
  valid_594572 = validateParameter(valid_594572, JString, required = true,
                                 default = nil)
  if valid_594572 != nil:
    section.add "labName", valid_594572
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594573 = query.getOrDefault("api-version")
  valid_594573 = validateParameter(valid_594573, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594573 != nil:
    section.add "api-version", valid_594573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594574: Call_SchedulesDelete_594566; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_594574.validator(path, query, header, formData, body)
  let scheme = call_594574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594574.url(scheme.get, call_594574.host, call_594574.base,
                         call_594574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594574, url, valid)

proc call*(call_594575: Call_SchedulesDelete_594566; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## schedulesDelete
  ## Delete schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594576 = newJObject()
  var query_594577 = newJObject()
  add(path_594576, "resourceGroupName", newJString(resourceGroupName))
  add(query_594577, "api-version", newJString(apiVersion))
  add(path_594576, "name", newJString(name))
  add(path_594576, "subscriptionId", newJString(subscriptionId))
  add(path_594576, "labName", newJString(labName))
  result = call_594575.call(path_594576, query_594577, nil, nil, nil)

var schedulesDelete* = Call_SchedulesDelete_594566(name: "schedulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesDelete_594567, base: "", url: url_SchedulesDelete_594568,
    schemes: {Scheme.Https})
type
  Call_SchedulesExecute_594592 = ref object of OpenApiRestCall_593437
proc url_SchedulesExecute_594594(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesExecute_594593(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594595 = path.getOrDefault("resourceGroupName")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "resourceGroupName", valid_594595
  var valid_594596 = path.getOrDefault("name")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "name", valid_594596
  var valid_594597 = path.getOrDefault("subscriptionId")
  valid_594597 = validateParameter(valid_594597, JString, required = true,
                                 default = nil)
  if valid_594597 != nil:
    section.add "subscriptionId", valid_594597
  var valid_594598 = path.getOrDefault("labName")
  valid_594598 = validateParameter(valid_594598, JString, required = true,
                                 default = nil)
  if valid_594598 != nil:
    section.add "labName", valid_594598
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594599 = query.getOrDefault("api-version")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594599 != nil:
    section.add "api-version", valid_594599
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594600: Call_SchedulesExecute_594592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_594600.validator(path, query, header, formData, body)
  let scheme = call_594600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594600.url(scheme.get, call_594600.host, call_594600.base,
                         call_594600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594600, url, valid)

proc call*(call_594601: Call_SchedulesExecute_594592; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## schedulesExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594602 = newJObject()
  var query_594603 = newJObject()
  add(path_594602, "resourceGroupName", newJString(resourceGroupName))
  add(query_594603, "api-version", newJString(apiVersion))
  add(path_594602, "name", newJString(name))
  add(path_594602, "subscriptionId", newJString(subscriptionId))
  add(path_594602, "labName", newJString(labName))
  result = call_594601.call(path_594602, query_594603, nil, nil, nil)

var schedulesExecute* = Call_SchedulesExecute_594592(name: "schedulesExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/execute",
    validator: validate_SchedulesExecute_594593, base: "",
    url: url_SchedulesExecute_594594, schemes: {Scheme.Https})
type
  Call_SchedulesListApplicable_594604 = ref object of OpenApiRestCall_593437
proc url_SchedulesListApplicable_594606(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/listApplicable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesListApplicable_594605(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all applicable schedules
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594607 = path.getOrDefault("resourceGroupName")
  valid_594607 = validateParameter(valid_594607, JString, required = true,
                                 default = nil)
  if valid_594607 != nil:
    section.add "resourceGroupName", valid_594607
  var valid_594608 = path.getOrDefault("name")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = nil)
  if valid_594608 != nil:
    section.add "name", valid_594608
  var valid_594609 = path.getOrDefault("subscriptionId")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "subscriptionId", valid_594609
  var valid_594610 = path.getOrDefault("labName")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "labName", valid_594610
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594611 = query.getOrDefault("api-version")
  valid_594611 = validateParameter(valid_594611, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594611 != nil:
    section.add "api-version", valid_594611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594612: Call_SchedulesListApplicable_594604; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all applicable schedules
  ## 
  let valid = call_594612.validator(path, query, header, formData, body)
  let scheme = call_594612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594612.url(scheme.get, call_594612.host, call_594612.base,
                         call_594612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594612, url, valid)

proc call*(call_594613: Call_SchedulesListApplicable_594604;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## schedulesListApplicable
  ## Lists all applicable schedules
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594614 = newJObject()
  var query_594615 = newJObject()
  add(path_594614, "resourceGroupName", newJString(resourceGroupName))
  add(query_594615, "api-version", newJString(apiVersion))
  add(path_594614, "name", newJString(name))
  add(path_594614, "subscriptionId", newJString(subscriptionId))
  add(path_594614, "labName", newJString(labName))
  result = call_594613.call(path_594614, query_594615, nil, nil, nil)

var schedulesListApplicable* = Call_SchedulesListApplicable_594604(
    name: "schedulesListApplicable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/listApplicable",
    validator: validate_SchedulesListApplicable_594605, base: "",
    url: url_SchedulesListApplicable_594606, schemes: {Scheme.Https})
type
  Call_ServiceRunnersCreateOrUpdate_594628 = ref object of OpenApiRestCall_593437
proc url_ServiceRunnersCreateOrUpdate_594630(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/servicerunners/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceRunnersCreateOrUpdate_594629(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing service runner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service runner.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594631 = path.getOrDefault("resourceGroupName")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "resourceGroupName", valid_594631
  var valid_594632 = path.getOrDefault("name")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = nil)
  if valid_594632 != nil:
    section.add "name", valid_594632
  var valid_594633 = path.getOrDefault("subscriptionId")
  valid_594633 = validateParameter(valid_594633, JString, required = true,
                                 default = nil)
  if valid_594633 != nil:
    section.add "subscriptionId", valid_594633
  var valid_594634 = path.getOrDefault("labName")
  valid_594634 = validateParameter(valid_594634, JString, required = true,
                                 default = nil)
  if valid_594634 != nil:
    section.add "labName", valid_594634
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594635 = query.getOrDefault("api-version")
  valid_594635 = validateParameter(valid_594635, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594635 != nil:
    section.add "api-version", valid_594635
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceRunner: JObject (required)
  ##                : A container for a managed identity to execute DevTest lab services.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594637: Call_ServiceRunnersCreateOrUpdate_594628; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing service runner.
  ## 
  let valid = call_594637.validator(path, query, header, formData, body)
  let scheme = call_594637.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594637.url(scheme.get, call_594637.host, call_594637.base,
                         call_594637.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594637, url, valid)

proc call*(call_594638: Call_ServiceRunnersCreateOrUpdate_594628;
          resourceGroupName: string; name: string; subscriptionId: string;
          serviceRunner: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceRunnersCreateOrUpdate
  ## Create or replace an existing service runner.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service runner.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   serviceRunner: JObject (required)
  ##                : A container for a managed identity to execute DevTest lab services.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594639 = newJObject()
  var query_594640 = newJObject()
  var body_594641 = newJObject()
  add(path_594639, "resourceGroupName", newJString(resourceGroupName))
  add(query_594640, "api-version", newJString(apiVersion))
  add(path_594639, "name", newJString(name))
  add(path_594639, "subscriptionId", newJString(subscriptionId))
  if serviceRunner != nil:
    body_594641 = serviceRunner
  add(path_594639, "labName", newJString(labName))
  result = call_594638.call(path_594639, query_594640, nil, nil, body_594641)

var serviceRunnersCreateOrUpdate* = Call_ServiceRunnersCreateOrUpdate_594628(
    name: "serviceRunnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersCreateOrUpdate_594629, base: "",
    url: url_ServiceRunnersCreateOrUpdate_594630, schemes: {Scheme.Https})
type
  Call_ServiceRunnersGet_594616 = ref object of OpenApiRestCall_593437
proc url_ServiceRunnersGet_594618(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/servicerunners/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceRunnersGet_594617(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get service runner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service runner.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594619 = path.getOrDefault("resourceGroupName")
  valid_594619 = validateParameter(valid_594619, JString, required = true,
                                 default = nil)
  if valid_594619 != nil:
    section.add "resourceGroupName", valid_594619
  var valid_594620 = path.getOrDefault("name")
  valid_594620 = validateParameter(valid_594620, JString, required = true,
                                 default = nil)
  if valid_594620 != nil:
    section.add "name", valid_594620
  var valid_594621 = path.getOrDefault("subscriptionId")
  valid_594621 = validateParameter(valid_594621, JString, required = true,
                                 default = nil)
  if valid_594621 != nil:
    section.add "subscriptionId", valid_594621
  var valid_594622 = path.getOrDefault("labName")
  valid_594622 = validateParameter(valid_594622, JString, required = true,
                                 default = nil)
  if valid_594622 != nil:
    section.add "labName", valid_594622
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594623 = query.getOrDefault("api-version")
  valid_594623 = validateParameter(valid_594623, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594623 != nil:
    section.add "api-version", valid_594623
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594624: Call_ServiceRunnersGet_594616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service runner.
  ## 
  let valid = call_594624.validator(path, query, header, formData, body)
  let scheme = call_594624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594624.url(scheme.get, call_594624.host, call_594624.base,
                         call_594624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594624, url, valid)

proc call*(call_594625: Call_ServiceRunnersGet_594616; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceRunnersGet
  ## Get service runner.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service runner.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594626 = newJObject()
  var query_594627 = newJObject()
  add(path_594626, "resourceGroupName", newJString(resourceGroupName))
  add(query_594627, "api-version", newJString(apiVersion))
  add(path_594626, "name", newJString(name))
  add(path_594626, "subscriptionId", newJString(subscriptionId))
  add(path_594626, "labName", newJString(labName))
  result = call_594625.call(path_594626, query_594627, nil, nil, nil)

var serviceRunnersGet* = Call_ServiceRunnersGet_594616(name: "serviceRunnersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersGet_594617, base: "",
    url: url_ServiceRunnersGet_594618, schemes: {Scheme.Https})
type
  Call_ServiceRunnersDelete_594642 = ref object of OpenApiRestCall_593437
proc url_ServiceRunnersDelete_594644(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/servicerunners/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceRunnersDelete_594643(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete service runner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service runner.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594645 = path.getOrDefault("resourceGroupName")
  valid_594645 = validateParameter(valid_594645, JString, required = true,
                                 default = nil)
  if valid_594645 != nil:
    section.add "resourceGroupName", valid_594645
  var valid_594646 = path.getOrDefault("name")
  valid_594646 = validateParameter(valid_594646, JString, required = true,
                                 default = nil)
  if valid_594646 != nil:
    section.add "name", valid_594646
  var valid_594647 = path.getOrDefault("subscriptionId")
  valid_594647 = validateParameter(valid_594647, JString, required = true,
                                 default = nil)
  if valid_594647 != nil:
    section.add "subscriptionId", valid_594647
  var valid_594648 = path.getOrDefault("labName")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "labName", valid_594648
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594649 = query.getOrDefault("api-version")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594649 != nil:
    section.add "api-version", valid_594649
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594650: Call_ServiceRunnersDelete_594642; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete service runner.
  ## 
  let valid = call_594650.validator(path, query, header, formData, body)
  let scheme = call_594650.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594650.url(scheme.get, call_594650.host, call_594650.base,
                         call_594650.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594650, url, valid)

proc call*(call_594651: Call_ServiceRunnersDelete_594642;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceRunnersDelete
  ## Delete service runner.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service runner.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594652 = newJObject()
  var query_594653 = newJObject()
  add(path_594652, "resourceGroupName", newJString(resourceGroupName))
  add(query_594653, "api-version", newJString(apiVersion))
  add(path_594652, "name", newJString(name))
  add(path_594652, "subscriptionId", newJString(subscriptionId))
  add(path_594652, "labName", newJString(labName))
  result = call_594651.call(path_594652, query_594653, nil, nil, nil)

var serviceRunnersDelete* = Call_ServiceRunnersDelete_594642(
    name: "serviceRunnersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersDelete_594643, base: "",
    url: url_ServiceRunnersDelete_594644, schemes: {Scheme.Https})
type
  Call_UsersList_594654 = ref object of OpenApiRestCall_593437
proc url_UsersList_594656(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersList_594655(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## List user profiles in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594657 = path.getOrDefault("resourceGroupName")
  valid_594657 = validateParameter(valid_594657, JString, required = true,
                                 default = nil)
  if valid_594657 != nil:
    section.add "resourceGroupName", valid_594657
  var valid_594658 = path.getOrDefault("subscriptionId")
  valid_594658 = validateParameter(valid_594658, JString, required = true,
                                 default = nil)
  if valid_594658 != nil:
    section.add "subscriptionId", valid_594658
  var valid_594659 = path.getOrDefault("labName")
  valid_594659 = validateParameter(valid_594659, JString, required = true,
                                 default = nil)
  if valid_594659 != nil:
    section.add "labName", valid_594659
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=identity)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594660 = query.getOrDefault("$orderby")
  valid_594660 = validateParameter(valid_594660, JString, required = false,
                                 default = nil)
  if valid_594660 != nil:
    section.add "$orderby", valid_594660
  var valid_594661 = query.getOrDefault("$expand")
  valid_594661 = validateParameter(valid_594661, JString, required = false,
                                 default = nil)
  if valid_594661 != nil:
    section.add "$expand", valid_594661
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594662 = query.getOrDefault("api-version")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594662 != nil:
    section.add "api-version", valid_594662
  var valid_594663 = query.getOrDefault("$top")
  valid_594663 = validateParameter(valid_594663, JInt, required = false, default = nil)
  if valid_594663 != nil:
    section.add "$top", valid_594663
  var valid_594664 = query.getOrDefault("$filter")
  valid_594664 = validateParameter(valid_594664, JString, required = false,
                                 default = nil)
  if valid_594664 != nil:
    section.add "$filter", valid_594664
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594665: Call_UsersList_594654; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List user profiles in a given lab.
  ## 
  let valid = call_594665.validator(path, query, header, formData, body)
  let scheme = call_594665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594665.url(scheme.get, call_594665.host, call_594665.base,
                         call_594665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594665, url, valid)

proc call*(call_594666: Call_UsersList_594654; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## usersList
  ## List user profiles in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=identity)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594667 = newJObject()
  var query_594668 = newJObject()
  add(query_594668, "$orderby", newJString(Orderby))
  add(path_594667, "resourceGroupName", newJString(resourceGroupName))
  add(query_594668, "$expand", newJString(Expand))
  add(query_594668, "api-version", newJString(apiVersion))
  add(path_594667, "subscriptionId", newJString(subscriptionId))
  add(query_594668, "$top", newJInt(Top))
  add(path_594667, "labName", newJString(labName))
  add(query_594668, "$filter", newJString(Filter))
  result = call_594666.call(path_594667, query_594668, nil, nil, nil)

var usersList* = Call_UsersList_594654(name: "usersList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users",
                                    validator: validate_UsersList_594655,
                                    base: "", url: url_UsersList_594656,
                                    schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_594682 = ref object of OpenApiRestCall_593437
proc url_UsersCreateOrUpdate_594684(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersCreateOrUpdate_594683(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing user profile. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the user profile.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594685 = path.getOrDefault("resourceGroupName")
  valid_594685 = validateParameter(valid_594685, JString, required = true,
                                 default = nil)
  if valid_594685 != nil:
    section.add "resourceGroupName", valid_594685
  var valid_594686 = path.getOrDefault("name")
  valid_594686 = validateParameter(valid_594686, JString, required = true,
                                 default = nil)
  if valid_594686 != nil:
    section.add "name", valid_594686
  var valid_594687 = path.getOrDefault("subscriptionId")
  valid_594687 = validateParameter(valid_594687, JString, required = true,
                                 default = nil)
  if valid_594687 != nil:
    section.add "subscriptionId", valid_594687
  var valid_594688 = path.getOrDefault("labName")
  valid_594688 = validateParameter(valid_594688, JString, required = true,
                                 default = nil)
  if valid_594688 != nil:
    section.add "labName", valid_594688
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594689 = query.getOrDefault("api-version")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594689 != nil:
    section.add "api-version", valid_594689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   user: JObject (required)
  ##       : Profile of a lab user.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594691: Call_UsersCreateOrUpdate_594682; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing user profile. This operation can take a while to complete.
  ## 
  let valid = call_594691.validator(path, query, header, formData, body)
  let scheme = call_594691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594691.url(scheme.get, call_594691.host, call_594691.base,
                         call_594691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594691, url, valid)

proc call*(call_594692: Call_UsersCreateOrUpdate_594682; resourceGroupName: string;
          name: string; user: JsonNode; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## usersCreateOrUpdate
  ## Create or replace an existing user profile. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the user profile.
  ##   user: JObject (required)
  ##       : Profile of a lab user.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594693 = newJObject()
  var query_594694 = newJObject()
  var body_594695 = newJObject()
  add(path_594693, "resourceGroupName", newJString(resourceGroupName))
  add(query_594694, "api-version", newJString(apiVersion))
  add(path_594693, "name", newJString(name))
  if user != nil:
    body_594695 = user
  add(path_594693, "subscriptionId", newJString(subscriptionId))
  add(path_594693, "labName", newJString(labName))
  result = call_594692.call(path_594693, query_594694, nil, nil, body_594695)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_594682(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
    validator: validate_UsersCreateOrUpdate_594683, base: "",
    url: url_UsersCreateOrUpdate_594684, schemes: {Scheme.Https})
type
  Call_UsersGet_594669 = ref object of OpenApiRestCall_593437
proc url_UsersGet_594671(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersGet_594670(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the user profile.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594672 = path.getOrDefault("resourceGroupName")
  valid_594672 = validateParameter(valid_594672, JString, required = true,
                                 default = nil)
  if valid_594672 != nil:
    section.add "resourceGroupName", valid_594672
  var valid_594673 = path.getOrDefault("name")
  valid_594673 = validateParameter(valid_594673, JString, required = true,
                                 default = nil)
  if valid_594673 != nil:
    section.add "name", valid_594673
  var valid_594674 = path.getOrDefault("subscriptionId")
  valid_594674 = validateParameter(valid_594674, JString, required = true,
                                 default = nil)
  if valid_594674 != nil:
    section.add "subscriptionId", valid_594674
  var valid_594675 = path.getOrDefault("labName")
  valid_594675 = validateParameter(valid_594675, JString, required = true,
                                 default = nil)
  if valid_594675 != nil:
    section.add "labName", valid_594675
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=identity)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594676 = query.getOrDefault("$expand")
  valid_594676 = validateParameter(valid_594676, JString, required = false,
                                 default = nil)
  if valid_594676 != nil:
    section.add "$expand", valid_594676
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594677 = query.getOrDefault("api-version")
  valid_594677 = validateParameter(valid_594677, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594677 != nil:
    section.add "api-version", valid_594677
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594678: Call_UsersGet_594669; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get user profile.
  ## 
  let valid = call_594678.validator(path, query, header, formData, body)
  let scheme = call_594678.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594678.url(scheme.get, call_594678.host, call_594678.base,
                         call_594678.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594678, url, valid)

proc call*(call_594679: Call_UsersGet_594669; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
  ## usersGet
  ## Get user profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=identity)'
  ##   name: string (required)
  ##       : The name of the user profile.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594680 = newJObject()
  var query_594681 = newJObject()
  add(path_594680, "resourceGroupName", newJString(resourceGroupName))
  add(query_594681, "$expand", newJString(Expand))
  add(path_594680, "name", newJString(name))
  add(query_594681, "api-version", newJString(apiVersion))
  add(path_594680, "subscriptionId", newJString(subscriptionId))
  add(path_594680, "labName", newJString(labName))
  result = call_594679.call(path_594680, query_594681, nil, nil, nil)

var usersGet* = Call_UsersGet_594669(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                  validator: validate_UsersGet_594670, base: "",
                                  url: url_UsersGet_594671,
                                  schemes: {Scheme.Https})
type
  Call_UsersUpdate_594708 = ref object of OpenApiRestCall_593437
proc url_UsersUpdate_594710(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersUpdate_594709(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of user profiles. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the user profile.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594711 = path.getOrDefault("resourceGroupName")
  valid_594711 = validateParameter(valid_594711, JString, required = true,
                                 default = nil)
  if valid_594711 != nil:
    section.add "resourceGroupName", valid_594711
  var valid_594712 = path.getOrDefault("name")
  valid_594712 = validateParameter(valid_594712, JString, required = true,
                                 default = nil)
  if valid_594712 != nil:
    section.add "name", valid_594712
  var valid_594713 = path.getOrDefault("subscriptionId")
  valid_594713 = validateParameter(valid_594713, JString, required = true,
                                 default = nil)
  if valid_594713 != nil:
    section.add "subscriptionId", valid_594713
  var valid_594714 = path.getOrDefault("labName")
  valid_594714 = validateParameter(valid_594714, JString, required = true,
                                 default = nil)
  if valid_594714 != nil:
    section.add "labName", valid_594714
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594715 = query.getOrDefault("api-version")
  valid_594715 = validateParameter(valid_594715, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594715 != nil:
    section.add "api-version", valid_594715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   user: JObject (required)
  ##       : Profile of a lab user.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594717: Call_UsersUpdate_594708; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of user profiles. All other properties will be ignored.
  ## 
  let valid = call_594717.validator(path, query, header, formData, body)
  let scheme = call_594717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594717.url(scheme.get, call_594717.host, call_594717.base,
                         call_594717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594717, url, valid)

proc call*(call_594718: Call_UsersUpdate_594708; resourceGroupName: string;
          name: string; user: JsonNode; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## usersUpdate
  ## Allows modifying tags of user profiles. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the user profile.
  ##   user: JObject (required)
  ##       : Profile of a lab user.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594719 = newJObject()
  var query_594720 = newJObject()
  var body_594721 = newJObject()
  add(path_594719, "resourceGroupName", newJString(resourceGroupName))
  add(query_594720, "api-version", newJString(apiVersion))
  add(path_594719, "name", newJString(name))
  if user != nil:
    body_594721 = user
  add(path_594719, "subscriptionId", newJString(subscriptionId))
  add(path_594719, "labName", newJString(labName))
  result = call_594718.call(path_594719, query_594720, nil, nil, body_594721)

var usersUpdate* = Call_UsersUpdate_594708(name: "usersUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                        validator: validate_UsersUpdate_594709,
                                        base: "", url: url_UsersUpdate_594710,
                                        schemes: {Scheme.Https})
type
  Call_UsersDelete_594696 = ref object of OpenApiRestCall_593437
proc url_UsersDelete_594698(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersDelete_594697(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete user profile. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the user profile.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594699 = path.getOrDefault("resourceGroupName")
  valid_594699 = validateParameter(valid_594699, JString, required = true,
                                 default = nil)
  if valid_594699 != nil:
    section.add "resourceGroupName", valid_594699
  var valid_594700 = path.getOrDefault("name")
  valid_594700 = validateParameter(valid_594700, JString, required = true,
                                 default = nil)
  if valid_594700 != nil:
    section.add "name", valid_594700
  var valid_594701 = path.getOrDefault("subscriptionId")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = nil)
  if valid_594701 != nil:
    section.add "subscriptionId", valid_594701
  var valid_594702 = path.getOrDefault("labName")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "labName", valid_594702
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594703 = query.getOrDefault("api-version")
  valid_594703 = validateParameter(valid_594703, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594703 != nil:
    section.add "api-version", valid_594703
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594704: Call_UsersDelete_594696; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user profile. This operation can take a while to complete.
  ## 
  let valid = call_594704.validator(path, query, header, formData, body)
  let scheme = call_594704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594704.url(scheme.get, call_594704.host, call_594704.base,
                         call_594704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594704, url, valid)

proc call*(call_594705: Call_UsersDelete_594696; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## usersDelete
  ## Delete user profile. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the user profile.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594706 = newJObject()
  var query_594707 = newJObject()
  add(path_594706, "resourceGroupName", newJString(resourceGroupName))
  add(query_594707, "api-version", newJString(apiVersion))
  add(path_594706, "name", newJString(name))
  add(path_594706, "subscriptionId", newJString(subscriptionId))
  add(path_594706, "labName", newJString(labName))
  result = call_594705.call(path_594706, query_594707, nil, nil, nil)

var usersDelete* = Call_UsersDelete_594696(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                        validator: validate_UsersDelete_594697,
                                        base: "", url: url_UsersDelete_594698,
                                        schemes: {Scheme.Https})
type
  Call_DisksList_594722 = ref object of OpenApiRestCall_593437
proc url_DisksList_594724(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksList_594723(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## List disks in a given user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594725 = path.getOrDefault("resourceGroupName")
  valid_594725 = validateParameter(valid_594725, JString, required = true,
                                 default = nil)
  if valid_594725 != nil:
    section.add "resourceGroupName", valid_594725
  var valid_594726 = path.getOrDefault("subscriptionId")
  valid_594726 = validateParameter(valid_594726, JString, required = true,
                                 default = nil)
  if valid_594726 != nil:
    section.add "subscriptionId", valid_594726
  var valid_594727 = path.getOrDefault("userName")
  valid_594727 = validateParameter(valid_594727, JString, required = true,
                                 default = nil)
  if valid_594727 != nil:
    section.add "userName", valid_594727
  var valid_594728 = path.getOrDefault("labName")
  valid_594728 = validateParameter(valid_594728, JString, required = true,
                                 default = nil)
  if valid_594728 != nil:
    section.add "labName", valid_594728
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594729 = query.getOrDefault("$orderby")
  valid_594729 = validateParameter(valid_594729, JString, required = false,
                                 default = nil)
  if valid_594729 != nil:
    section.add "$orderby", valid_594729
  var valid_594730 = query.getOrDefault("$expand")
  valid_594730 = validateParameter(valid_594730, JString, required = false,
                                 default = nil)
  if valid_594730 != nil:
    section.add "$expand", valid_594730
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594731 = query.getOrDefault("api-version")
  valid_594731 = validateParameter(valid_594731, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594731 != nil:
    section.add "api-version", valid_594731
  var valid_594732 = query.getOrDefault("$top")
  valid_594732 = validateParameter(valid_594732, JInt, required = false, default = nil)
  if valid_594732 != nil:
    section.add "$top", valid_594732
  var valid_594733 = query.getOrDefault("$filter")
  valid_594733 = validateParameter(valid_594733, JString, required = false,
                                 default = nil)
  if valid_594733 != nil:
    section.add "$filter", valid_594733
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594734: Call_DisksList_594722; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disks in a given user profile.
  ## 
  let valid = call_594734.validator(path, query, header, formData, body)
  let scheme = call_594734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594734.url(scheme.get, call_594734.host, call_594734.base,
                         call_594734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594734, url, valid)

proc call*(call_594735: Call_DisksList_594722; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## disksList
  ## List disks in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594736 = newJObject()
  var query_594737 = newJObject()
  add(query_594737, "$orderby", newJString(Orderby))
  add(path_594736, "resourceGroupName", newJString(resourceGroupName))
  add(query_594737, "$expand", newJString(Expand))
  add(query_594737, "api-version", newJString(apiVersion))
  add(path_594736, "subscriptionId", newJString(subscriptionId))
  add(query_594737, "$top", newJInt(Top))
  add(path_594736, "userName", newJString(userName))
  add(path_594736, "labName", newJString(labName))
  add(query_594737, "$filter", newJString(Filter))
  result = call_594735.call(path_594736, query_594737, nil, nil, nil)

var disksList* = Call_DisksList_594722(name: "disksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks",
                                    validator: validate_DisksList_594723,
                                    base: "", url: url_DisksList_594724,
                                    schemes: {Scheme.Https})
type
  Call_DisksCreateOrUpdate_594752 = ref object of OpenApiRestCall_593437
proc url_DisksCreateOrUpdate_594754(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksCreateOrUpdate_594753(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing disk. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594755 = path.getOrDefault("resourceGroupName")
  valid_594755 = validateParameter(valid_594755, JString, required = true,
                                 default = nil)
  if valid_594755 != nil:
    section.add "resourceGroupName", valid_594755
  var valid_594756 = path.getOrDefault("name")
  valid_594756 = validateParameter(valid_594756, JString, required = true,
                                 default = nil)
  if valid_594756 != nil:
    section.add "name", valid_594756
  var valid_594757 = path.getOrDefault("subscriptionId")
  valid_594757 = validateParameter(valid_594757, JString, required = true,
                                 default = nil)
  if valid_594757 != nil:
    section.add "subscriptionId", valid_594757
  var valid_594758 = path.getOrDefault("userName")
  valid_594758 = validateParameter(valid_594758, JString, required = true,
                                 default = nil)
  if valid_594758 != nil:
    section.add "userName", valid_594758
  var valid_594759 = path.getOrDefault("labName")
  valid_594759 = validateParameter(valid_594759, JString, required = true,
                                 default = nil)
  if valid_594759 != nil:
    section.add "labName", valid_594759
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594760 = query.getOrDefault("api-version")
  valid_594760 = validateParameter(valid_594760, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594760 != nil:
    section.add "api-version", valid_594760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   disk: JObject (required)
  ##       : A Disk.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594762: Call_DisksCreateOrUpdate_594752; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing disk. This operation can take a while to complete.
  ## 
  let valid = call_594762.validator(path, query, header, formData, body)
  let scheme = call_594762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594762.url(scheme.get, call_594762.host, call_594762.base,
                         call_594762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594762, url, valid)

proc call*(call_594763: Call_DisksCreateOrUpdate_594752; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; disk: JsonNode;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## disksCreateOrUpdate
  ## Create or replace an existing disk. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   disk: JObject (required)
  ##       : A Disk.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594764 = newJObject()
  var query_594765 = newJObject()
  var body_594766 = newJObject()
  add(path_594764, "resourceGroupName", newJString(resourceGroupName))
  add(query_594765, "api-version", newJString(apiVersion))
  add(path_594764, "name", newJString(name))
  add(path_594764, "subscriptionId", newJString(subscriptionId))
  add(path_594764, "userName", newJString(userName))
  if disk != nil:
    body_594766 = disk
  add(path_594764, "labName", newJString(labName))
  result = call_594763.call(path_594764, query_594765, nil, nil, body_594766)

var disksCreateOrUpdate* = Call_DisksCreateOrUpdate_594752(
    name: "disksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
    validator: validate_DisksCreateOrUpdate_594753, base: "",
    url: url_DisksCreateOrUpdate_594754, schemes: {Scheme.Https})
type
  Call_DisksGet_594738 = ref object of OpenApiRestCall_593437
proc url_DisksGet_594740(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksGet_594739(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get disk.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594741 = path.getOrDefault("resourceGroupName")
  valid_594741 = validateParameter(valid_594741, JString, required = true,
                                 default = nil)
  if valid_594741 != nil:
    section.add "resourceGroupName", valid_594741
  var valid_594742 = path.getOrDefault("name")
  valid_594742 = validateParameter(valid_594742, JString, required = true,
                                 default = nil)
  if valid_594742 != nil:
    section.add "name", valid_594742
  var valid_594743 = path.getOrDefault("subscriptionId")
  valid_594743 = validateParameter(valid_594743, JString, required = true,
                                 default = nil)
  if valid_594743 != nil:
    section.add "subscriptionId", valid_594743
  var valid_594744 = path.getOrDefault("userName")
  valid_594744 = validateParameter(valid_594744, JString, required = true,
                                 default = nil)
  if valid_594744 != nil:
    section.add "userName", valid_594744
  var valid_594745 = path.getOrDefault("labName")
  valid_594745 = validateParameter(valid_594745, JString, required = true,
                                 default = nil)
  if valid_594745 != nil:
    section.add "labName", valid_594745
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594746 = query.getOrDefault("$expand")
  valid_594746 = validateParameter(valid_594746, JString, required = false,
                                 default = nil)
  if valid_594746 != nil:
    section.add "$expand", valid_594746
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594747 = query.getOrDefault("api-version")
  valid_594747 = validateParameter(valid_594747, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594747 != nil:
    section.add "api-version", valid_594747
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594748: Call_DisksGet_594738; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get disk.
  ## 
  let valid = call_594748.validator(path, query, header, formData, body)
  let scheme = call_594748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594748.url(scheme.get, call_594748.host, call_594748.base,
                         call_594748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594748, url, valid)

proc call*(call_594749: Call_DisksGet_594738; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## disksGet
  ## Get disk.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   name: string (required)
  ##       : The name of the disk.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594750 = newJObject()
  var query_594751 = newJObject()
  add(path_594750, "resourceGroupName", newJString(resourceGroupName))
  add(query_594751, "$expand", newJString(Expand))
  add(path_594750, "name", newJString(name))
  add(query_594751, "api-version", newJString(apiVersion))
  add(path_594750, "subscriptionId", newJString(subscriptionId))
  add(path_594750, "userName", newJString(userName))
  add(path_594750, "labName", newJString(labName))
  result = call_594749.call(path_594750, query_594751, nil, nil, nil)

var disksGet* = Call_DisksGet_594738(name: "disksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                  validator: validate_DisksGet_594739, base: "",
                                  url: url_DisksGet_594740,
                                  schemes: {Scheme.Https})
type
  Call_DisksUpdate_594780 = ref object of OpenApiRestCall_593437
proc url_DisksUpdate_594782(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksUpdate_594781(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of disks. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594783 = path.getOrDefault("resourceGroupName")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "resourceGroupName", valid_594783
  var valid_594784 = path.getOrDefault("name")
  valid_594784 = validateParameter(valid_594784, JString, required = true,
                                 default = nil)
  if valid_594784 != nil:
    section.add "name", valid_594784
  var valid_594785 = path.getOrDefault("subscriptionId")
  valid_594785 = validateParameter(valid_594785, JString, required = true,
                                 default = nil)
  if valid_594785 != nil:
    section.add "subscriptionId", valid_594785
  var valid_594786 = path.getOrDefault("userName")
  valid_594786 = validateParameter(valid_594786, JString, required = true,
                                 default = nil)
  if valid_594786 != nil:
    section.add "userName", valid_594786
  var valid_594787 = path.getOrDefault("labName")
  valid_594787 = validateParameter(valid_594787, JString, required = true,
                                 default = nil)
  if valid_594787 != nil:
    section.add "labName", valid_594787
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594788 = query.getOrDefault("api-version")
  valid_594788 = validateParameter(valid_594788, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594788 != nil:
    section.add "api-version", valid_594788
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   disk: JObject (required)
  ##       : A Disk.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594790: Call_DisksUpdate_594780; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of disks. All other properties will be ignored.
  ## 
  let valid = call_594790.validator(path, query, header, formData, body)
  let scheme = call_594790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594790.url(scheme.get, call_594790.host, call_594790.base,
                         call_594790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594790, url, valid)

proc call*(call_594791: Call_DisksUpdate_594780; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; disk: JsonNode;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## disksUpdate
  ## Allows modifying tags of disks. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   disk: JObject (required)
  ##       : A Disk.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594792 = newJObject()
  var query_594793 = newJObject()
  var body_594794 = newJObject()
  add(path_594792, "resourceGroupName", newJString(resourceGroupName))
  add(query_594793, "api-version", newJString(apiVersion))
  add(path_594792, "name", newJString(name))
  add(path_594792, "subscriptionId", newJString(subscriptionId))
  add(path_594792, "userName", newJString(userName))
  if disk != nil:
    body_594794 = disk
  add(path_594792, "labName", newJString(labName))
  result = call_594791.call(path_594792, query_594793, nil, nil, body_594794)

var disksUpdate* = Call_DisksUpdate_594780(name: "disksUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                        validator: validate_DisksUpdate_594781,
                                        base: "", url: url_DisksUpdate_594782,
                                        schemes: {Scheme.Https})
type
  Call_DisksDelete_594767 = ref object of OpenApiRestCall_593437
proc url_DisksDelete_594769(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksDelete_594768(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete disk. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594770 = path.getOrDefault("resourceGroupName")
  valid_594770 = validateParameter(valid_594770, JString, required = true,
                                 default = nil)
  if valid_594770 != nil:
    section.add "resourceGroupName", valid_594770
  var valid_594771 = path.getOrDefault("name")
  valid_594771 = validateParameter(valid_594771, JString, required = true,
                                 default = nil)
  if valid_594771 != nil:
    section.add "name", valid_594771
  var valid_594772 = path.getOrDefault("subscriptionId")
  valid_594772 = validateParameter(valid_594772, JString, required = true,
                                 default = nil)
  if valid_594772 != nil:
    section.add "subscriptionId", valid_594772
  var valid_594773 = path.getOrDefault("userName")
  valid_594773 = validateParameter(valid_594773, JString, required = true,
                                 default = nil)
  if valid_594773 != nil:
    section.add "userName", valid_594773
  var valid_594774 = path.getOrDefault("labName")
  valid_594774 = validateParameter(valid_594774, JString, required = true,
                                 default = nil)
  if valid_594774 != nil:
    section.add "labName", valid_594774
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594775 = query.getOrDefault("api-version")
  valid_594775 = validateParameter(valid_594775, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594775 != nil:
    section.add "api-version", valid_594775
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594776: Call_DisksDelete_594767; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete disk. This operation can take a while to complete.
  ## 
  let valid = call_594776.validator(path, query, header, formData, body)
  let scheme = call_594776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594776.url(scheme.get, call_594776.host, call_594776.base,
                         call_594776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594776, url, valid)

proc call*(call_594777: Call_DisksDelete_594767; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## disksDelete
  ## Delete disk. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594778 = newJObject()
  var query_594779 = newJObject()
  add(path_594778, "resourceGroupName", newJString(resourceGroupName))
  add(query_594779, "api-version", newJString(apiVersion))
  add(path_594778, "name", newJString(name))
  add(path_594778, "subscriptionId", newJString(subscriptionId))
  add(path_594778, "userName", newJString(userName))
  add(path_594778, "labName", newJString(labName))
  result = call_594777.call(path_594778, query_594779, nil, nil, nil)

var disksDelete* = Call_DisksDelete_594767(name: "disksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                        validator: validate_DisksDelete_594768,
                                        base: "", url: url_DisksDelete_594769,
                                        schemes: {Scheme.Https})
type
  Call_DisksAttach_594795 = ref object of OpenApiRestCall_593437
proc url_DisksAttach_594797(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/attach")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksAttach_594796(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Attach and create the lease of the disk to the virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594798 = path.getOrDefault("resourceGroupName")
  valid_594798 = validateParameter(valid_594798, JString, required = true,
                                 default = nil)
  if valid_594798 != nil:
    section.add "resourceGroupName", valid_594798
  var valid_594799 = path.getOrDefault("name")
  valid_594799 = validateParameter(valid_594799, JString, required = true,
                                 default = nil)
  if valid_594799 != nil:
    section.add "name", valid_594799
  var valid_594800 = path.getOrDefault("subscriptionId")
  valid_594800 = validateParameter(valid_594800, JString, required = true,
                                 default = nil)
  if valid_594800 != nil:
    section.add "subscriptionId", valid_594800
  var valid_594801 = path.getOrDefault("userName")
  valid_594801 = validateParameter(valid_594801, JString, required = true,
                                 default = nil)
  if valid_594801 != nil:
    section.add "userName", valid_594801
  var valid_594802 = path.getOrDefault("labName")
  valid_594802 = validateParameter(valid_594802, JString, required = true,
                                 default = nil)
  if valid_594802 != nil:
    section.add "labName", valid_594802
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594803 = query.getOrDefault("api-version")
  valid_594803 = validateParameter(valid_594803, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594803 != nil:
    section.add "api-version", valid_594803
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   attachDiskProperties: JObject (required)
  ##                       : Properties of the disk to attach.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594805: Call_DisksAttach_594795; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attach and create the lease of the disk to the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_594805.validator(path, query, header, formData, body)
  let scheme = call_594805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594805.url(scheme.get, call_594805.host, call_594805.base,
                         call_594805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594805, url, valid)

proc call*(call_594806: Call_DisksAttach_594795; resourceGroupName: string;
          name: string; subscriptionId: string; attachDiskProperties: JsonNode;
          userName: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## disksAttach
  ## Attach and create the lease of the disk to the virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   attachDiskProperties: JObject (required)
  ##                       : Properties of the disk to attach.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594807 = newJObject()
  var query_594808 = newJObject()
  var body_594809 = newJObject()
  add(path_594807, "resourceGroupName", newJString(resourceGroupName))
  add(query_594808, "api-version", newJString(apiVersion))
  add(path_594807, "name", newJString(name))
  add(path_594807, "subscriptionId", newJString(subscriptionId))
  if attachDiskProperties != nil:
    body_594809 = attachDiskProperties
  add(path_594807, "userName", newJString(userName))
  add(path_594807, "labName", newJString(labName))
  result = call_594806.call(path_594807, query_594808, nil, nil, body_594809)

var disksAttach* = Call_DisksAttach_594795(name: "disksAttach",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}/attach",
                                        validator: validate_DisksAttach_594796,
                                        base: "", url: url_DisksAttach_594797,
                                        schemes: {Scheme.Https})
type
  Call_DisksDetach_594810 = ref object of OpenApiRestCall_593437
proc url_DisksDetach_594812(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/detach")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksDetach_594811(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Detach and break the lease of the disk attached to the virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594813 = path.getOrDefault("resourceGroupName")
  valid_594813 = validateParameter(valid_594813, JString, required = true,
                                 default = nil)
  if valid_594813 != nil:
    section.add "resourceGroupName", valid_594813
  var valid_594814 = path.getOrDefault("name")
  valid_594814 = validateParameter(valid_594814, JString, required = true,
                                 default = nil)
  if valid_594814 != nil:
    section.add "name", valid_594814
  var valid_594815 = path.getOrDefault("subscriptionId")
  valid_594815 = validateParameter(valid_594815, JString, required = true,
                                 default = nil)
  if valid_594815 != nil:
    section.add "subscriptionId", valid_594815
  var valid_594816 = path.getOrDefault("userName")
  valid_594816 = validateParameter(valid_594816, JString, required = true,
                                 default = nil)
  if valid_594816 != nil:
    section.add "userName", valid_594816
  var valid_594817 = path.getOrDefault("labName")
  valid_594817 = validateParameter(valid_594817, JString, required = true,
                                 default = nil)
  if valid_594817 != nil:
    section.add "labName", valid_594817
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594818 = query.getOrDefault("api-version")
  valid_594818 = validateParameter(valid_594818, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594818 != nil:
    section.add "api-version", valid_594818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   detachDiskProperties: JObject (required)
  ##                       : Properties of the disk to detach.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594820: Call_DisksDetach_594810; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach and break the lease of the disk attached to the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_594820.validator(path, query, header, formData, body)
  let scheme = call_594820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594820.url(scheme.get, call_594820.host, call_594820.base,
                         call_594820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594820, url, valid)

proc call*(call_594821: Call_DisksDetach_594810; resourceGroupName: string;
          name: string; subscriptionId: string; detachDiskProperties: JsonNode;
          userName: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## disksDetach
  ## Detach and break the lease of the disk attached to the virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   detachDiskProperties: JObject (required)
  ##                       : Properties of the disk to detach.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594822 = newJObject()
  var query_594823 = newJObject()
  var body_594824 = newJObject()
  add(path_594822, "resourceGroupName", newJString(resourceGroupName))
  add(query_594823, "api-version", newJString(apiVersion))
  add(path_594822, "name", newJString(name))
  add(path_594822, "subscriptionId", newJString(subscriptionId))
  if detachDiskProperties != nil:
    body_594824 = detachDiskProperties
  add(path_594822, "userName", newJString(userName))
  add(path_594822, "labName", newJString(labName))
  result = call_594821.call(path_594822, query_594823, nil, nil, body_594824)

var disksDetach* = Call_DisksDetach_594810(name: "disksDetach",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}/detach",
                                        validator: validate_DisksDetach_594811,
                                        base: "", url: url_DisksDetach_594812,
                                        schemes: {Scheme.Https})
type
  Call_EnvironmentsList_594825 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsList_594827(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/environments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsList_594826(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List environments in a given user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594828 = path.getOrDefault("resourceGroupName")
  valid_594828 = validateParameter(valid_594828, JString, required = true,
                                 default = nil)
  if valid_594828 != nil:
    section.add "resourceGroupName", valid_594828
  var valid_594829 = path.getOrDefault("subscriptionId")
  valid_594829 = validateParameter(valid_594829, JString, required = true,
                                 default = nil)
  if valid_594829 != nil:
    section.add "subscriptionId", valid_594829
  var valid_594830 = path.getOrDefault("userName")
  valid_594830 = validateParameter(valid_594830, JString, required = true,
                                 default = nil)
  if valid_594830 != nil:
    section.add "userName", valid_594830
  var valid_594831 = path.getOrDefault("labName")
  valid_594831 = validateParameter(valid_594831, JString, required = true,
                                 default = nil)
  if valid_594831 != nil:
    section.add "labName", valid_594831
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594832 = query.getOrDefault("$orderby")
  valid_594832 = validateParameter(valid_594832, JString, required = false,
                                 default = nil)
  if valid_594832 != nil:
    section.add "$orderby", valid_594832
  var valid_594833 = query.getOrDefault("$expand")
  valid_594833 = validateParameter(valid_594833, JString, required = false,
                                 default = nil)
  if valid_594833 != nil:
    section.add "$expand", valid_594833
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594834 = query.getOrDefault("api-version")
  valid_594834 = validateParameter(valid_594834, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594834 != nil:
    section.add "api-version", valid_594834
  var valid_594835 = query.getOrDefault("$top")
  valid_594835 = validateParameter(valid_594835, JInt, required = false, default = nil)
  if valid_594835 != nil:
    section.add "$top", valid_594835
  var valid_594836 = query.getOrDefault("$filter")
  valid_594836 = validateParameter(valid_594836, JString, required = false,
                                 default = nil)
  if valid_594836 != nil:
    section.add "$filter", valid_594836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594837: Call_EnvironmentsList_594825; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List environments in a given user profile.
  ## 
  let valid = call_594837.validator(path, query, header, formData, body)
  let scheme = call_594837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594837.url(scheme.get, call_594837.host, call_594837.base,
                         call_594837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594837, url, valid)

proc call*(call_594838: Call_EnvironmentsList_594825; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## environmentsList
  ## List environments in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594839 = newJObject()
  var query_594840 = newJObject()
  add(query_594840, "$orderby", newJString(Orderby))
  add(path_594839, "resourceGroupName", newJString(resourceGroupName))
  add(query_594840, "$expand", newJString(Expand))
  add(query_594840, "api-version", newJString(apiVersion))
  add(path_594839, "subscriptionId", newJString(subscriptionId))
  add(query_594840, "$top", newJInt(Top))
  add(path_594839, "userName", newJString(userName))
  add(path_594839, "labName", newJString(labName))
  add(query_594840, "$filter", newJString(Filter))
  result = call_594838.call(path_594839, query_594840, nil, nil, nil)

var environmentsList* = Call_EnvironmentsList_594825(name: "environmentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments",
    validator: validate_EnvironmentsList_594826, base: "",
    url: url_EnvironmentsList_594827, schemes: {Scheme.Https})
type
  Call_EnvironmentsCreateOrUpdate_594855 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsCreateOrUpdate_594857(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsCreateOrUpdate_594856(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing environment. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594858 = path.getOrDefault("resourceGroupName")
  valid_594858 = validateParameter(valid_594858, JString, required = true,
                                 default = nil)
  if valid_594858 != nil:
    section.add "resourceGroupName", valid_594858
  var valid_594859 = path.getOrDefault("name")
  valid_594859 = validateParameter(valid_594859, JString, required = true,
                                 default = nil)
  if valid_594859 != nil:
    section.add "name", valid_594859
  var valid_594860 = path.getOrDefault("subscriptionId")
  valid_594860 = validateParameter(valid_594860, JString, required = true,
                                 default = nil)
  if valid_594860 != nil:
    section.add "subscriptionId", valid_594860
  var valid_594861 = path.getOrDefault("userName")
  valid_594861 = validateParameter(valid_594861, JString, required = true,
                                 default = nil)
  if valid_594861 != nil:
    section.add "userName", valid_594861
  var valid_594862 = path.getOrDefault("labName")
  valid_594862 = validateParameter(valid_594862, JString, required = true,
                                 default = nil)
  if valid_594862 != nil:
    section.add "labName", valid_594862
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594863 = query.getOrDefault("api-version")
  valid_594863 = validateParameter(valid_594863, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594863 != nil:
    section.add "api-version", valid_594863
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dtlEnvironment: JObject (required)
  ##                 : An environment, which is essentially an ARM template deployment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594865: Call_EnvironmentsCreateOrUpdate_594855; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing environment. This operation can take a while to complete.
  ## 
  let valid = call_594865.validator(path, query, header, formData, body)
  let scheme = call_594865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594865.url(scheme.get, call_594865.host, call_594865.base,
                         call_594865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594865, url, valid)

proc call*(call_594866: Call_EnvironmentsCreateOrUpdate_594855;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; dtlEnvironment: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## environmentsCreateOrUpdate
  ## Create or replace an existing environment. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   dtlEnvironment: JObject (required)
  ##                 : An environment, which is essentially an ARM template deployment.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594867 = newJObject()
  var query_594868 = newJObject()
  var body_594869 = newJObject()
  add(path_594867, "resourceGroupName", newJString(resourceGroupName))
  add(query_594868, "api-version", newJString(apiVersion))
  add(path_594867, "name", newJString(name))
  add(path_594867, "subscriptionId", newJString(subscriptionId))
  add(path_594867, "userName", newJString(userName))
  if dtlEnvironment != nil:
    body_594869 = dtlEnvironment
  add(path_594867, "labName", newJString(labName))
  result = call_594866.call(path_594867, query_594868, nil, nil, body_594869)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_594855(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsCreateOrUpdate_594856, base: "",
    url: url_EnvironmentsCreateOrUpdate_594857, schemes: {Scheme.Https})
type
  Call_EnvironmentsGet_594841 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsGet_594843(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsGet_594842(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594844 = path.getOrDefault("resourceGroupName")
  valid_594844 = validateParameter(valid_594844, JString, required = true,
                                 default = nil)
  if valid_594844 != nil:
    section.add "resourceGroupName", valid_594844
  var valid_594845 = path.getOrDefault("name")
  valid_594845 = validateParameter(valid_594845, JString, required = true,
                                 default = nil)
  if valid_594845 != nil:
    section.add "name", valid_594845
  var valid_594846 = path.getOrDefault("subscriptionId")
  valid_594846 = validateParameter(valid_594846, JString, required = true,
                                 default = nil)
  if valid_594846 != nil:
    section.add "subscriptionId", valid_594846
  var valid_594847 = path.getOrDefault("userName")
  valid_594847 = validateParameter(valid_594847, JString, required = true,
                                 default = nil)
  if valid_594847 != nil:
    section.add "userName", valid_594847
  var valid_594848 = path.getOrDefault("labName")
  valid_594848 = validateParameter(valid_594848, JString, required = true,
                                 default = nil)
  if valid_594848 != nil:
    section.add "labName", valid_594848
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594849 = query.getOrDefault("$expand")
  valid_594849 = validateParameter(valid_594849, JString, required = false,
                                 default = nil)
  if valid_594849 != nil:
    section.add "$expand", valid_594849
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594850 = query.getOrDefault("api-version")
  valid_594850 = validateParameter(valid_594850, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594850 != nil:
    section.add "api-version", valid_594850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594851: Call_EnvironmentsGet_594841; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get environment.
  ## 
  let valid = call_594851.validator(path, query, header, formData, body)
  let scheme = call_594851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594851.url(scheme.get, call_594851.host, call_594851.base,
                         call_594851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594851, url, valid)

proc call*(call_594852: Call_EnvironmentsGet_594841; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## environmentsGet
  ## Get environment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   name: string (required)
  ##       : The name of the environment.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594853 = newJObject()
  var query_594854 = newJObject()
  add(path_594853, "resourceGroupName", newJString(resourceGroupName))
  add(query_594854, "$expand", newJString(Expand))
  add(path_594853, "name", newJString(name))
  add(query_594854, "api-version", newJString(apiVersion))
  add(path_594853, "subscriptionId", newJString(subscriptionId))
  add(path_594853, "userName", newJString(userName))
  add(path_594853, "labName", newJString(labName))
  result = call_594852.call(path_594853, query_594854, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_594841(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsGet_594842, base: "", url: url_EnvironmentsGet_594843,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsUpdate_594883 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsUpdate_594885(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsUpdate_594884(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Allows modifying tags of environments. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594886 = path.getOrDefault("resourceGroupName")
  valid_594886 = validateParameter(valid_594886, JString, required = true,
                                 default = nil)
  if valid_594886 != nil:
    section.add "resourceGroupName", valid_594886
  var valid_594887 = path.getOrDefault("name")
  valid_594887 = validateParameter(valid_594887, JString, required = true,
                                 default = nil)
  if valid_594887 != nil:
    section.add "name", valid_594887
  var valid_594888 = path.getOrDefault("subscriptionId")
  valid_594888 = validateParameter(valid_594888, JString, required = true,
                                 default = nil)
  if valid_594888 != nil:
    section.add "subscriptionId", valid_594888
  var valid_594889 = path.getOrDefault("userName")
  valid_594889 = validateParameter(valid_594889, JString, required = true,
                                 default = nil)
  if valid_594889 != nil:
    section.add "userName", valid_594889
  var valid_594890 = path.getOrDefault("labName")
  valid_594890 = validateParameter(valid_594890, JString, required = true,
                                 default = nil)
  if valid_594890 != nil:
    section.add "labName", valid_594890
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594891 = query.getOrDefault("api-version")
  valid_594891 = validateParameter(valid_594891, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594891 != nil:
    section.add "api-version", valid_594891
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dtlEnvironment: JObject (required)
  ##                 : An environment, which is essentially an ARM template deployment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594893: Call_EnvironmentsUpdate_594883; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of environments. All other properties will be ignored.
  ## 
  let valid = call_594893.validator(path, query, header, formData, body)
  let scheme = call_594893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594893.url(scheme.get, call_594893.host, call_594893.base,
                         call_594893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594893, url, valid)

proc call*(call_594894: Call_EnvironmentsUpdate_594883; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string;
          dtlEnvironment: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## environmentsUpdate
  ## Allows modifying tags of environments. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   dtlEnvironment: JObject (required)
  ##                 : An environment, which is essentially an ARM template deployment.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594895 = newJObject()
  var query_594896 = newJObject()
  var body_594897 = newJObject()
  add(path_594895, "resourceGroupName", newJString(resourceGroupName))
  add(query_594896, "api-version", newJString(apiVersion))
  add(path_594895, "name", newJString(name))
  add(path_594895, "subscriptionId", newJString(subscriptionId))
  add(path_594895, "userName", newJString(userName))
  if dtlEnvironment != nil:
    body_594897 = dtlEnvironment
  add(path_594895, "labName", newJString(labName))
  result = call_594894.call(path_594895, query_594896, nil, nil, body_594897)

var environmentsUpdate* = Call_EnvironmentsUpdate_594883(
    name: "environmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsUpdate_594884, base: "",
    url: url_EnvironmentsUpdate_594885, schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_594870 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsDelete_594872(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsDelete_594871(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete environment. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594873 = path.getOrDefault("resourceGroupName")
  valid_594873 = validateParameter(valid_594873, JString, required = true,
                                 default = nil)
  if valid_594873 != nil:
    section.add "resourceGroupName", valid_594873
  var valid_594874 = path.getOrDefault("name")
  valid_594874 = validateParameter(valid_594874, JString, required = true,
                                 default = nil)
  if valid_594874 != nil:
    section.add "name", valid_594874
  var valid_594875 = path.getOrDefault("subscriptionId")
  valid_594875 = validateParameter(valid_594875, JString, required = true,
                                 default = nil)
  if valid_594875 != nil:
    section.add "subscriptionId", valid_594875
  var valid_594876 = path.getOrDefault("userName")
  valid_594876 = validateParameter(valid_594876, JString, required = true,
                                 default = nil)
  if valid_594876 != nil:
    section.add "userName", valid_594876
  var valid_594877 = path.getOrDefault("labName")
  valid_594877 = validateParameter(valid_594877, JString, required = true,
                                 default = nil)
  if valid_594877 != nil:
    section.add "labName", valid_594877
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594878 = query.getOrDefault("api-version")
  valid_594878 = validateParameter(valid_594878, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594878 != nil:
    section.add "api-version", valid_594878
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594879: Call_EnvironmentsDelete_594870; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete environment. This operation can take a while to complete.
  ## 
  let valid = call_594879.validator(path, query, header, formData, body)
  let scheme = call_594879.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594879.url(scheme.get, call_594879.host, call_594879.base,
                         call_594879.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594879, url, valid)

proc call*(call_594880: Call_EnvironmentsDelete_594870; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## environmentsDelete
  ## Delete environment. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594881 = newJObject()
  var query_594882 = newJObject()
  add(path_594881, "resourceGroupName", newJString(resourceGroupName))
  add(query_594882, "api-version", newJString(apiVersion))
  add(path_594881, "name", newJString(name))
  add(path_594881, "subscriptionId", newJString(subscriptionId))
  add(path_594881, "userName", newJString(userName))
  add(path_594881, "labName", newJString(labName))
  result = call_594880.call(path_594881, query_594882, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_594870(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsDelete_594871, base: "",
    url: url_EnvironmentsDelete_594872, schemes: {Scheme.Https})
type
  Call_SecretsList_594898 = ref object of OpenApiRestCall_593437
proc url_SecretsList_594900(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/secrets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretsList_594899(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List secrets in a given user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594901 = path.getOrDefault("resourceGroupName")
  valid_594901 = validateParameter(valid_594901, JString, required = true,
                                 default = nil)
  if valid_594901 != nil:
    section.add "resourceGroupName", valid_594901
  var valid_594902 = path.getOrDefault("subscriptionId")
  valid_594902 = validateParameter(valid_594902, JString, required = true,
                                 default = nil)
  if valid_594902 != nil:
    section.add "subscriptionId", valid_594902
  var valid_594903 = path.getOrDefault("userName")
  valid_594903 = validateParameter(valid_594903, JString, required = true,
                                 default = nil)
  if valid_594903 != nil:
    section.add "userName", valid_594903
  var valid_594904 = path.getOrDefault("labName")
  valid_594904 = validateParameter(valid_594904, JString, required = true,
                                 default = nil)
  if valid_594904 != nil:
    section.add "labName", valid_594904
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=value)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594905 = query.getOrDefault("$orderby")
  valid_594905 = validateParameter(valid_594905, JString, required = false,
                                 default = nil)
  if valid_594905 != nil:
    section.add "$orderby", valid_594905
  var valid_594906 = query.getOrDefault("$expand")
  valid_594906 = validateParameter(valid_594906, JString, required = false,
                                 default = nil)
  if valid_594906 != nil:
    section.add "$expand", valid_594906
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594907 = query.getOrDefault("api-version")
  valid_594907 = validateParameter(valid_594907, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594907 != nil:
    section.add "api-version", valid_594907
  var valid_594908 = query.getOrDefault("$top")
  valid_594908 = validateParameter(valid_594908, JInt, required = false, default = nil)
  if valid_594908 != nil:
    section.add "$top", valid_594908
  var valid_594909 = query.getOrDefault("$filter")
  valid_594909 = validateParameter(valid_594909, JString, required = false,
                                 default = nil)
  if valid_594909 != nil:
    section.add "$filter", valid_594909
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594910: Call_SecretsList_594898; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List secrets in a given user profile.
  ## 
  let valid = call_594910.validator(path, query, header, formData, body)
  let scheme = call_594910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594910.url(scheme.get, call_594910.host, call_594910.base,
                         call_594910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594910, url, valid)

proc call*(call_594911: Call_SecretsList_594898; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## secretsList
  ## List secrets in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=value)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594912 = newJObject()
  var query_594913 = newJObject()
  add(query_594913, "$orderby", newJString(Orderby))
  add(path_594912, "resourceGroupName", newJString(resourceGroupName))
  add(query_594913, "$expand", newJString(Expand))
  add(query_594913, "api-version", newJString(apiVersion))
  add(path_594912, "subscriptionId", newJString(subscriptionId))
  add(query_594913, "$top", newJInt(Top))
  add(path_594912, "userName", newJString(userName))
  add(path_594912, "labName", newJString(labName))
  add(query_594913, "$filter", newJString(Filter))
  result = call_594911.call(path_594912, query_594913, nil, nil, nil)

var secretsList* = Call_SecretsList_594898(name: "secretsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets",
                                        validator: validate_SecretsList_594899,
                                        base: "", url: url_SecretsList_594900,
                                        schemes: {Scheme.Https})
type
  Call_SecretsCreateOrUpdate_594928 = ref object of OpenApiRestCall_593437
proc url_SecretsCreateOrUpdate_594930(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretsCreateOrUpdate_594929(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing secret. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the secret.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594931 = path.getOrDefault("resourceGroupName")
  valid_594931 = validateParameter(valid_594931, JString, required = true,
                                 default = nil)
  if valid_594931 != nil:
    section.add "resourceGroupName", valid_594931
  var valid_594932 = path.getOrDefault("name")
  valid_594932 = validateParameter(valid_594932, JString, required = true,
                                 default = nil)
  if valid_594932 != nil:
    section.add "name", valid_594932
  var valid_594933 = path.getOrDefault("subscriptionId")
  valid_594933 = validateParameter(valid_594933, JString, required = true,
                                 default = nil)
  if valid_594933 != nil:
    section.add "subscriptionId", valid_594933
  var valid_594934 = path.getOrDefault("userName")
  valid_594934 = validateParameter(valid_594934, JString, required = true,
                                 default = nil)
  if valid_594934 != nil:
    section.add "userName", valid_594934
  var valid_594935 = path.getOrDefault("labName")
  valid_594935 = validateParameter(valid_594935, JString, required = true,
                                 default = nil)
  if valid_594935 != nil:
    section.add "labName", valid_594935
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594936 = query.getOrDefault("api-version")
  valid_594936 = validateParameter(valid_594936, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594936 != nil:
    section.add "api-version", valid_594936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   secret: JObject (required)
  ##         : A secret.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594938: Call_SecretsCreateOrUpdate_594928; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing secret. This operation can take a while to complete.
  ## 
  let valid = call_594938.validator(path, query, header, formData, body)
  let scheme = call_594938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594938.url(scheme.get, call_594938.host, call_594938.base,
                         call_594938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594938, url, valid)

proc call*(call_594939: Call_SecretsCreateOrUpdate_594928;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; secret: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## secretsCreateOrUpdate
  ## Create or replace an existing secret. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the secret.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   secret: JObject (required)
  ##         : A secret.
  var path_594940 = newJObject()
  var query_594941 = newJObject()
  var body_594942 = newJObject()
  add(path_594940, "resourceGroupName", newJString(resourceGroupName))
  add(query_594941, "api-version", newJString(apiVersion))
  add(path_594940, "name", newJString(name))
  add(path_594940, "subscriptionId", newJString(subscriptionId))
  add(path_594940, "userName", newJString(userName))
  add(path_594940, "labName", newJString(labName))
  if secret != nil:
    body_594942 = secret
  result = call_594939.call(path_594940, query_594941, nil, nil, body_594942)

var secretsCreateOrUpdate* = Call_SecretsCreateOrUpdate_594928(
    name: "secretsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsCreateOrUpdate_594929, base: "",
    url: url_SecretsCreateOrUpdate_594930, schemes: {Scheme.Https})
type
  Call_SecretsGet_594914 = ref object of OpenApiRestCall_593437
proc url_SecretsGet_594916(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretsGet_594915(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the secret.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594917 = path.getOrDefault("resourceGroupName")
  valid_594917 = validateParameter(valid_594917, JString, required = true,
                                 default = nil)
  if valid_594917 != nil:
    section.add "resourceGroupName", valid_594917
  var valid_594918 = path.getOrDefault("name")
  valid_594918 = validateParameter(valid_594918, JString, required = true,
                                 default = nil)
  if valid_594918 != nil:
    section.add "name", valid_594918
  var valid_594919 = path.getOrDefault("subscriptionId")
  valid_594919 = validateParameter(valid_594919, JString, required = true,
                                 default = nil)
  if valid_594919 != nil:
    section.add "subscriptionId", valid_594919
  var valid_594920 = path.getOrDefault("userName")
  valid_594920 = validateParameter(valid_594920, JString, required = true,
                                 default = nil)
  if valid_594920 != nil:
    section.add "userName", valid_594920
  var valid_594921 = path.getOrDefault("labName")
  valid_594921 = validateParameter(valid_594921, JString, required = true,
                                 default = nil)
  if valid_594921 != nil:
    section.add "labName", valid_594921
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=value)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594922 = query.getOrDefault("$expand")
  valid_594922 = validateParameter(valid_594922, JString, required = false,
                                 default = nil)
  if valid_594922 != nil:
    section.add "$expand", valid_594922
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594923 = query.getOrDefault("api-version")
  valid_594923 = validateParameter(valid_594923, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594923 != nil:
    section.add "api-version", valid_594923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594924: Call_SecretsGet_594914; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get secret.
  ## 
  let valid = call_594924.validator(path, query, header, formData, body)
  let scheme = call_594924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594924.url(scheme.get, call_594924.host, call_594924.base,
                         call_594924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594924, url, valid)

proc call*(call_594925: Call_SecretsGet_594914; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## secretsGet
  ## Get secret.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=value)'
  ##   name: string (required)
  ##       : The name of the secret.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594926 = newJObject()
  var query_594927 = newJObject()
  add(path_594926, "resourceGroupName", newJString(resourceGroupName))
  add(query_594927, "$expand", newJString(Expand))
  add(path_594926, "name", newJString(name))
  add(query_594927, "api-version", newJString(apiVersion))
  add(path_594926, "subscriptionId", newJString(subscriptionId))
  add(path_594926, "userName", newJString(userName))
  add(path_594926, "labName", newJString(labName))
  result = call_594925.call(path_594926, query_594927, nil, nil, nil)

var secretsGet* = Call_SecretsGet_594914(name: "secretsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
                                      validator: validate_SecretsGet_594915,
                                      base: "", url: url_SecretsGet_594916,
                                      schemes: {Scheme.Https})
type
  Call_SecretsUpdate_594956 = ref object of OpenApiRestCall_593437
proc url_SecretsUpdate_594958(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretsUpdate_594957(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of secrets. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the secret.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594959 = path.getOrDefault("resourceGroupName")
  valid_594959 = validateParameter(valid_594959, JString, required = true,
                                 default = nil)
  if valid_594959 != nil:
    section.add "resourceGroupName", valid_594959
  var valid_594960 = path.getOrDefault("name")
  valid_594960 = validateParameter(valid_594960, JString, required = true,
                                 default = nil)
  if valid_594960 != nil:
    section.add "name", valid_594960
  var valid_594961 = path.getOrDefault("subscriptionId")
  valid_594961 = validateParameter(valid_594961, JString, required = true,
                                 default = nil)
  if valid_594961 != nil:
    section.add "subscriptionId", valid_594961
  var valid_594962 = path.getOrDefault("userName")
  valid_594962 = validateParameter(valid_594962, JString, required = true,
                                 default = nil)
  if valid_594962 != nil:
    section.add "userName", valid_594962
  var valid_594963 = path.getOrDefault("labName")
  valid_594963 = validateParameter(valid_594963, JString, required = true,
                                 default = nil)
  if valid_594963 != nil:
    section.add "labName", valid_594963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594964 = query.getOrDefault("api-version")
  valid_594964 = validateParameter(valid_594964, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594964 != nil:
    section.add "api-version", valid_594964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   secret: JObject (required)
  ##         : A secret.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594966: Call_SecretsUpdate_594956; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of secrets. All other properties will be ignored.
  ## 
  let valid = call_594966.validator(path, query, header, formData, body)
  let scheme = call_594966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594966.url(scheme.get, call_594966.host, call_594966.base,
                         call_594966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594966, url, valid)

proc call*(call_594967: Call_SecretsUpdate_594956; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          secret: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## secretsUpdate
  ## Allows modifying tags of secrets. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the secret.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   secret: JObject (required)
  ##         : A secret.
  var path_594968 = newJObject()
  var query_594969 = newJObject()
  var body_594970 = newJObject()
  add(path_594968, "resourceGroupName", newJString(resourceGroupName))
  add(query_594969, "api-version", newJString(apiVersion))
  add(path_594968, "name", newJString(name))
  add(path_594968, "subscriptionId", newJString(subscriptionId))
  add(path_594968, "userName", newJString(userName))
  add(path_594968, "labName", newJString(labName))
  if secret != nil:
    body_594970 = secret
  result = call_594967.call(path_594968, query_594969, nil, nil, body_594970)

var secretsUpdate* = Call_SecretsUpdate_594956(name: "secretsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsUpdate_594957, base: "", url: url_SecretsUpdate_594958,
    schemes: {Scheme.Https})
type
  Call_SecretsDelete_594943 = ref object of OpenApiRestCall_593437
proc url_SecretsDelete_594945(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretsDelete_594944(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the secret.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594946 = path.getOrDefault("resourceGroupName")
  valid_594946 = validateParameter(valid_594946, JString, required = true,
                                 default = nil)
  if valid_594946 != nil:
    section.add "resourceGroupName", valid_594946
  var valid_594947 = path.getOrDefault("name")
  valid_594947 = validateParameter(valid_594947, JString, required = true,
                                 default = nil)
  if valid_594947 != nil:
    section.add "name", valid_594947
  var valid_594948 = path.getOrDefault("subscriptionId")
  valid_594948 = validateParameter(valid_594948, JString, required = true,
                                 default = nil)
  if valid_594948 != nil:
    section.add "subscriptionId", valid_594948
  var valid_594949 = path.getOrDefault("userName")
  valid_594949 = validateParameter(valid_594949, JString, required = true,
                                 default = nil)
  if valid_594949 != nil:
    section.add "userName", valid_594949
  var valid_594950 = path.getOrDefault("labName")
  valid_594950 = validateParameter(valid_594950, JString, required = true,
                                 default = nil)
  if valid_594950 != nil:
    section.add "labName", valid_594950
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594951 = query.getOrDefault("api-version")
  valid_594951 = validateParameter(valid_594951, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594951 != nil:
    section.add "api-version", valid_594951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594952: Call_SecretsDelete_594943; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete secret.
  ## 
  let valid = call_594952.validator(path, query, header, formData, body)
  let scheme = call_594952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594952.url(scheme.get, call_594952.host, call_594952.base,
                         call_594952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594952, url, valid)

proc call*(call_594953: Call_SecretsDelete_594943; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## secretsDelete
  ## Delete secret.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the secret.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594954 = newJObject()
  var query_594955 = newJObject()
  add(path_594954, "resourceGroupName", newJString(resourceGroupName))
  add(query_594955, "api-version", newJString(apiVersion))
  add(path_594954, "name", newJString(name))
  add(path_594954, "subscriptionId", newJString(subscriptionId))
  add(path_594954, "userName", newJString(userName))
  add(path_594954, "labName", newJString(labName))
  result = call_594953.call(path_594954, query_594955, nil, nil, nil)

var secretsDelete* = Call_SecretsDelete_594943(name: "secretsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsDelete_594944, base: "", url: url_SecretsDelete_594945,
    schemes: {Scheme.Https})
type
  Call_ServiceFabricsList_594971 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricsList_594973(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsList_594972(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List service fabrics in a given user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594974 = path.getOrDefault("resourceGroupName")
  valid_594974 = validateParameter(valid_594974, JString, required = true,
                                 default = nil)
  if valid_594974 != nil:
    section.add "resourceGroupName", valid_594974
  var valid_594975 = path.getOrDefault("subscriptionId")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "subscriptionId", valid_594975
  var valid_594976 = path.getOrDefault("userName")
  valid_594976 = validateParameter(valid_594976, JString, required = true,
                                 default = nil)
  if valid_594976 != nil:
    section.add "userName", valid_594976
  var valid_594977 = path.getOrDefault("labName")
  valid_594977 = validateParameter(valid_594977, JString, required = true,
                                 default = nil)
  if valid_594977 != nil:
    section.add "labName", valid_594977
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=applicableSchedule)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_594978 = query.getOrDefault("$orderby")
  valid_594978 = validateParameter(valid_594978, JString, required = false,
                                 default = nil)
  if valid_594978 != nil:
    section.add "$orderby", valid_594978
  var valid_594979 = query.getOrDefault("$expand")
  valid_594979 = validateParameter(valid_594979, JString, required = false,
                                 default = nil)
  if valid_594979 != nil:
    section.add "$expand", valid_594979
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594980 = query.getOrDefault("api-version")
  valid_594980 = validateParameter(valid_594980, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594980 != nil:
    section.add "api-version", valid_594980
  var valid_594981 = query.getOrDefault("$top")
  valid_594981 = validateParameter(valid_594981, JInt, required = false, default = nil)
  if valid_594981 != nil:
    section.add "$top", valid_594981
  var valid_594982 = query.getOrDefault("$filter")
  valid_594982 = validateParameter(valid_594982, JString, required = false,
                                 default = nil)
  if valid_594982 != nil:
    section.add "$filter", valid_594982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594983: Call_ServiceFabricsList_594971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List service fabrics in a given user profile.
  ## 
  let valid = call_594983.validator(path, query, header, formData, body)
  let scheme = call_594983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594983.url(scheme.get, call_594983.host, call_594983.base,
                         call_594983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594983, url, valid)

proc call*(call_594984: Call_ServiceFabricsList_594971; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## serviceFabricsList
  ## List service fabrics in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=applicableSchedule)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_594985 = newJObject()
  var query_594986 = newJObject()
  add(query_594986, "$orderby", newJString(Orderby))
  add(path_594985, "resourceGroupName", newJString(resourceGroupName))
  add(query_594986, "$expand", newJString(Expand))
  add(query_594986, "api-version", newJString(apiVersion))
  add(path_594985, "subscriptionId", newJString(subscriptionId))
  add(query_594986, "$top", newJInt(Top))
  add(path_594985, "userName", newJString(userName))
  add(path_594985, "labName", newJString(labName))
  add(query_594986, "$filter", newJString(Filter))
  result = call_594984.call(path_594985, query_594986, nil, nil, nil)

var serviceFabricsList* = Call_ServiceFabricsList_594971(
    name: "serviceFabricsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics",
    validator: validate_ServiceFabricsList_594972, base: "",
    url: url_ServiceFabricsList_594973, schemes: {Scheme.Https})
type
  Call_ServiceFabricsCreateOrUpdate_595001 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricsCreateOrUpdate_595003(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsCreateOrUpdate_595002(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing service fabric. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595004 = path.getOrDefault("resourceGroupName")
  valid_595004 = validateParameter(valid_595004, JString, required = true,
                                 default = nil)
  if valid_595004 != nil:
    section.add "resourceGroupName", valid_595004
  var valid_595005 = path.getOrDefault("name")
  valid_595005 = validateParameter(valid_595005, JString, required = true,
                                 default = nil)
  if valid_595005 != nil:
    section.add "name", valid_595005
  var valid_595006 = path.getOrDefault("subscriptionId")
  valid_595006 = validateParameter(valid_595006, JString, required = true,
                                 default = nil)
  if valid_595006 != nil:
    section.add "subscriptionId", valid_595006
  var valid_595007 = path.getOrDefault("userName")
  valid_595007 = validateParameter(valid_595007, JString, required = true,
                                 default = nil)
  if valid_595007 != nil:
    section.add "userName", valid_595007
  var valid_595008 = path.getOrDefault("labName")
  valid_595008 = validateParameter(valid_595008, JString, required = true,
                                 default = nil)
  if valid_595008 != nil:
    section.add "labName", valid_595008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595009 = query.getOrDefault("api-version")
  valid_595009 = validateParameter(valid_595009, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595009 != nil:
    section.add "api-version", valid_595009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceFabric: JObject (required)
  ##                : A Service Fabric.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595011: Call_ServiceFabricsCreateOrUpdate_595001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing service fabric. This operation can take a while to complete.
  ## 
  let valid = call_595011.validator(path, query, header, formData, body)
  let scheme = call_595011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595011.url(scheme.get, call_595011.host, call_595011.base,
                         call_595011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595011, url, valid)

proc call*(call_595012: Call_ServiceFabricsCreateOrUpdate_595001;
          serviceFabric: JsonNode; resourceGroupName: string; name: string;
          subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsCreateOrUpdate
  ## Create or replace an existing service fabric. This operation can take a while to complete.
  ##   serviceFabric: JObject (required)
  ##                : A Service Fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595013 = newJObject()
  var query_595014 = newJObject()
  var body_595015 = newJObject()
  if serviceFabric != nil:
    body_595015 = serviceFabric
  add(path_595013, "resourceGroupName", newJString(resourceGroupName))
  add(query_595014, "api-version", newJString(apiVersion))
  add(path_595013, "name", newJString(name))
  add(path_595013, "subscriptionId", newJString(subscriptionId))
  add(path_595013, "userName", newJString(userName))
  add(path_595013, "labName", newJString(labName))
  result = call_595012.call(path_595013, query_595014, nil, nil, body_595015)

var serviceFabricsCreateOrUpdate* = Call_ServiceFabricsCreateOrUpdate_595001(
    name: "serviceFabricsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}",
    validator: validate_ServiceFabricsCreateOrUpdate_595002, base: "",
    url: url_ServiceFabricsCreateOrUpdate_595003, schemes: {Scheme.Https})
type
  Call_ServiceFabricsGet_594987 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricsGet_594989(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsGet_594988(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get service fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594990 = path.getOrDefault("resourceGroupName")
  valid_594990 = validateParameter(valid_594990, JString, required = true,
                                 default = nil)
  if valid_594990 != nil:
    section.add "resourceGroupName", valid_594990
  var valid_594991 = path.getOrDefault("name")
  valid_594991 = validateParameter(valid_594991, JString, required = true,
                                 default = nil)
  if valid_594991 != nil:
    section.add "name", valid_594991
  var valid_594992 = path.getOrDefault("subscriptionId")
  valid_594992 = validateParameter(valid_594992, JString, required = true,
                                 default = nil)
  if valid_594992 != nil:
    section.add "subscriptionId", valid_594992
  var valid_594993 = path.getOrDefault("userName")
  valid_594993 = validateParameter(valid_594993, JString, required = true,
                                 default = nil)
  if valid_594993 != nil:
    section.add "userName", valid_594993
  var valid_594994 = path.getOrDefault("labName")
  valid_594994 = validateParameter(valid_594994, JString, required = true,
                                 default = nil)
  if valid_594994 != nil:
    section.add "labName", valid_594994
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=applicableSchedule)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594995 = query.getOrDefault("$expand")
  valid_594995 = validateParameter(valid_594995, JString, required = false,
                                 default = nil)
  if valid_594995 != nil:
    section.add "$expand", valid_594995
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594996 = query.getOrDefault("api-version")
  valid_594996 = validateParameter(valid_594996, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_594996 != nil:
    section.add "api-version", valid_594996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594997: Call_ServiceFabricsGet_594987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service fabric.
  ## 
  let valid = call_594997.validator(path, query, header, formData, body)
  let scheme = call_594997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594997.url(scheme.get, call_594997.host, call_594997.base,
                         call_594997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594997, url, valid)

proc call*(call_594998: Call_ServiceFabricsGet_594987; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsGet
  ## Get service fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=applicableSchedule)'
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594999 = newJObject()
  var query_595000 = newJObject()
  add(path_594999, "resourceGroupName", newJString(resourceGroupName))
  add(query_595000, "$expand", newJString(Expand))
  add(path_594999, "name", newJString(name))
  add(query_595000, "api-version", newJString(apiVersion))
  add(path_594999, "subscriptionId", newJString(subscriptionId))
  add(path_594999, "userName", newJString(userName))
  add(path_594999, "labName", newJString(labName))
  result = call_594998.call(path_594999, query_595000, nil, nil, nil)

var serviceFabricsGet* = Call_ServiceFabricsGet_594987(name: "serviceFabricsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}",
    validator: validate_ServiceFabricsGet_594988, base: "",
    url: url_ServiceFabricsGet_594989, schemes: {Scheme.Https})
type
  Call_ServiceFabricsUpdate_595029 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricsUpdate_595031(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsUpdate_595030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of service fabrics. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595032 = path.getOrDefault("resourceGroupName")
  valid_595032 = validateParameter(valid_595032, JString, required = true,
                                 default = nil)
  if valid_595032 != nil:
    section.add "resourceGroupName", valid_595032
  var valid_595033 = path.getOrDefault("name")
  valid_595033 = validateParameter(valid_595033, JString, required = true,
                                 default = nil)
  if valid_595033 != nil:
    section.add "name", valid_595033
  var valid_595034 = path.getOrDefault("subscriptionId")
  valid_595034 = validateParameter(valid_595034, JString, required = true,
                                 default = nil)
  if valid_595034 != nil:
    section.add "subscriptionId", valid_595034
  var valid_595035 = path.getOrDefault("userName")
  valid_595035 = validateParameter(valid_595035, JString, required = true,
                                 default = nil)
  if valid_595035 != nil:
    section.add "userName", valid_595035
  var valid_595036 = path.getOrDefault("labName")
  valid_595036 = validateParameter(valid_595036, JString, required = true,
                                 default = nil)
  if valid_595036 != nil:
    section.add "labName", valid_595036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595037 = query.getOrDefault("api-version")
  valid_595037 = validateParameter(valid_595037, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595037 != nil:
    section.add "api-version", valid_595037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceFabric: JObject (required)
  ##                : A Service Fabric.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595039: Call_ServiceFabricsUpdate_595029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of service fabrics. All other properties will be ignored.
  ## 
  let valid = call_595039.validator(path, query, header, formData, body)
  let scheme = call_595039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595039.url(scheme.get, call_595039.host, call_595039.base,
                         call_595039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595039, url, valid)

proc call*(call_595040: Call_ServiceFabricsUpdate_595029; serviceFabric: JsonNode;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsUpdate
  ## Allows modifying tags of service fabrics. All other properties will be ignored.
  ##   serviceFabric: JObject (required)
  ##                : A Service Fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595041 = newJObject()
  var query_595042 = newJObject()
  var body_595043 = newJObject()
  if serviceFabric != nil:
    body_595043 = serviceFabric
  add(path_595041, "resourceGroupName", newJString(resourceGroupName))
  add(query_595042, "api-version", newJString(apiVersion))
  add(path_595041, "name", newJString(name))
  add(path_595041, "subscriptionId", newJString(subscriptionId))
  add(path_595041, "userName", newJString(userName))
  add(path_595041, "labName", newJString(labName))
  result = call_595040.call(path_595041, query_595042, nil, nil, body_595043)

var serviceFabricsUpdate* = Call_ServiceFabricsUpdate_595029(
    name: "serviceFabricsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}",
    validator: validate_ServiceFabricsUpdate_595030, base: "",
    url: url_ServiceFabricsUpdate_595031, schemes: {Scheme.Https})
type
  Call_ServiceFabricsDelete_595016 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricsDelete_595018(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsDelete_595017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete service fabric. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595019 = path.getOrDefault("resourceGroupName")
  valid_595019 = validateParameter(valid_595019, JString, required = true,
                                 default = nil)
  if valid_595019 != nil:
    section.add "resourceGroupName", valid_595019
  var valid_595020 = path.getOrDefault("name")
  valid_595020 = validateParameter(valid_595020, JString, required = true,
                                 default = nil)
  if valid_595020 != nil:
    section.add "name", valid_595020
  var valid_595021 = path.getOrDefault("subscriptionId")
  valid_595021 = validateParameter(valid_595021, JString, required = true,
                                 default = nil)
  if valid_595021 != nil:
    section.add "subscriptionId", valid_595021
  var valid_595022 = path.getOrDefault("userName")
  valid_595022 = validateParameter(valid_595022, JString, required = true,
                                 default = nil)
  if valid_595022 != nil:
    section.add "userName", valid_595022
  var valid_595023 = path.getOrDefault("labName")
  valid_595023 = validateParameter(valid_595023, JString, required = true,
                                 default = nil)
  if valid_595023 != nil:
    section.add "labName", valid_595023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595024 = query.getOrDefault("api-version")
  valid_595024 = validateParameter(valid_595024, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595024 != nil:
    section.add "api-version", valid_595024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595025: Call_ServiceFabricsDelete_595016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete service fabric. This operation can take a while to complete.
  ## 
  let valid = call_595025.validator(path, query, header, formData, body)
  let scheme = call_595025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595025.url(scheme.get, call_595025.host, call_595025.base,
                         call_595025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595025, url, valid)

proc call*(call_595026: Call_ServiceFabricsDelete_595016;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsDelete
  ## Delete service fabric. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595027 = newJObject()
  var query_595028 = newJObject()
  add(path_595027, "resourceGroupName", newJString(resourceGroupName))
  add(query_595028, "api-version", newJString(apiVersion))
  add(path_595027, "name", newJString(name))
  add(path_595027, "subscriptionId", newJString(subscriptionId))
  add(path_595027, "userName", newJString(userName))
  add(path_595027, "labName", newJString(labName))
  result = call_595026.call(path_595027, query_595028, nil, nil, nil)

var serviceFabricsDelete* = Call_ServiceFabricsDelete_595016(
    name: "serviceFabricsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}",
    validator: validate_ServiceFabricsDelete_595017, base: "",
    url: url_ServiceFabricsDelete_595018, schemes: {Scheme.Https})
type
  Call_ServiceFabricsListApplicableSchedules_595044 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricsListApplicableSchedules_595046(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/listApplicableSchedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsListApplicableSchedules_595045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the applicable start/stop schedules, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595047 = path.getOrDefault("resourceGroupName")
  valid_595047 = validateParameter(valid_595047, JString, required = true,
                                 default = nil)
  if valid_595047 != nil:
    section.add "resourceGroupName", valid_595047
  var valid_595048 = path.getOrDefault("name")
  valid_595048 = validateParameter(valid_595048, JString, required = true,
                                 default = nil)
  if valid_595048 != nil:
    section.add "name", valid_595048
  var valid_595049 = path.getOrDefault("subscriptionId")
  valid_595049 = validateParameter(valid_595049, JString, required = true,
                                 default = nil)
  if valid_595049 != nil:
    section.add "subscriptionId", valid_595049
  var valid_595050 = path.getOrDefault("userName")
  valid_595050 = validateParameter(valid_595050, JString, required = true,
                                 default = nil)
  if valid_595050 != nil:
    section.add "userName", valid_595050
  var valid_595051 = path.getOrDefault("labName")
  valid_595051 = validateParameter(valid_595051, JString, required = true,
                                 default = nil)
  if valid_595051 != nil:
    section.add "labName", valid_595051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595052 = query.getOrDefault("api-version")
  valid_595052 = validateParameter(valid_595052, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595052 != nil:
    section.add "api-version", valid_595052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595053: Call_ServiceFabricsListApplicableSchedules_595044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the applicable start/stop schedules, if any.
  ## 
  let valid = call_595053.validator(path, query, header, formData, body)
  let scheme = call_595053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595053.url(scheme.get, call_595053.host, call_595053.base,
                         call_595053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595053, url, valid)

proc call*(call_595054: Call_ServiceFabricsListApplicableSchedules_595044;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsListApplicableSchedules
  ## Lists the applicable start/stop schedules, if any.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595055 = newJObject()
  var query_595056 = newJObject()
  add(path_595055, "resourceGroupName", newJString(resourceGroupName))
  add(query_595056, "api-version", newJString(apiVersion))
  add(path_595055, "name", newJString(name))
  add(path_595055, "subscriptionId", newJString(subscriptionId))
  add(path_595055, "userName", newJString(userName))
  add(path_595055, "labName", newJString(labName))
  result = call_595054.call(path_595055, query_595056, nil, nil, nil)

var serviceFabricsListApplicableSchedules* = Call_ServiceFabricsListApplicableSchedules_595044(
    name: "serviceFabricsListApplicableSchedules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}/listApplicableSchedules",
    validator: validate_ServiceFabricsListApplicableSchedules_595045, base: "",
    url: url_ServiceFabricsListApplicableSchedules_595046, schemes: {Scheme.Https})
type
  Call_ServiceFabricsStart_595057 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricsStart_595059(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsStart_595058(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Start a service fabric. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595060 = path.getOrDefault("resourceGroupName")
  valid_595060 = validateParameter(valid_595060, JString, required = true,
                                 default = nil)
  if valid_595060 != nil:
    section.add "resourceGroupName", valid_595060
  var valid_595061 = path.getOrDefault("name")
  valid_595061 = validateParameter(valid_595061, JString, required = true,
                                 default = nil)
  if valid_595061 != nil:
    section.add "name", valid_595061
  var valid_595062 = path.getOrDefault("subscriptionId")
  valid_595062 = validateParameter(valid_595062, JString, required = true,
                                 default = nil)
  if valid_595062 != nil:
    section.add "subscriptionId", valid_595062
  var valid_595063 = path.getOrDefault("userName")
  valid_595063 = validateParameter(valid_595063, JString, required = true,
                                 default = nil)
  if valid_595063 != nil:
    section.add "userName", valid_595063
  var valid_595064 = path.getOrDefault("labName")
  valid_595064 = validateParameter(valid_595064, JString, required = true,
                                 default = nil)
  if valid_595064 != nil:
    section.add "labName", valid_595064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595065 = query.getOrDefault("api-version")
  valid_595065 = validateParameter(valid_595065, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595065 != nil:
    section.add "api-version", valid_595065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595066: Call_ServiceFabricsStart_595057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start a service fabric. This operation can take a while to complete.
  ## 
  let valid = call_595066.validator(path, query, header, formData, body)
  let scheme = call_595066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595066.url(scheme.get, call_595066.host, call_595066.base,
                         call_595066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595066, url, valid)

proc call*(call_595067: Call_ServiceFabricsStart_595057; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsStart
  ## Start a service fabric. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595068 = newJObject()
  var query_595069 = newJObject()
  add(path_595068, "resourceGroupName", newJString(resourceGroupName))
  add(query_595069, "api-version", newJString(apiVersion))
  add(path_595068, "name", newJString(name))
  add(path_595068, "subscriptionId", newJString(subscriptionId))
  add(path_595068, "userName", newJString(userName))
  add(path_595068, "labName", newJString(labName))
  result = call_595067.call(path_595068, query_595069, nil, nil, nil)

var serviceFabricsStart* = Call_ServiceFabricsStart_595057(
    name: "serviceFabricsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}/start",
    validator: validate_ServiceFabricsStart_595058, base: "",
    url: url_ServiceFabricsStart_595059, schemes: {Scheme.Https})
type
  Call_ServiceFabricsStop_595070 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricsStop_595072(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsStop_595071(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Stop a service fabric This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595073 = path.getOrDefault("resourceGroupName")
  valid_595073 = validateParameter(valid_595073, JString, required = true,
                                 default = nil)
  if valid_595073 != nil:
    section.add "resourceGroupName", valid_595073
  var valid_595074 = path.getOrDefault("name")
  valid_595074 = validateParameter(valid_595074, JString, required = true,
                                 default = nil)
  if valid_595074 != nil:
    section.add "name", valid_595074
  var valid_595075 = path.getOrDefault("subscriptionId")
  valid_595075 = validateParameter(valid_595075, JString, required = true,
                                 default = nil)
  if valid_595075 != nil:
    section.add "subscriptionId", valid_595075
  var valid_595076 = path.getOrDefault("userName")
  valid_595076 = validateParameter(valid_595076, JString, required = true,
                                 default = nil)
  if valid_595076 != nil:
    section.add "userName", valid_595076
  var valid_595077 = path.getOrDefault("labName")
  valid_595077 = validateParameter(valid_595077, JString, required = true,
                                 default = nil)
  if valid_595077 != nil:
    section.add "labName", valid_595077
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595078 = query.getOrDefault("api-version")
  valid_595078 = validateParameter(valid_595078, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595078 != nil:
    section.add "api-version", valid_595078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595079: Call_ServiceFabricsStop_595070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop a service fabric This operation can take a while to complete.
  ## 
  let valid = call_595079.validator(path, query, header, formData, body)
  let scheme = call_595079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595079.url(scheme.get, call_595079.host, call_595079.base,
                         call_595079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595079, url, valid)

proc call*(call_595080: Call_ServiceFabricsStop_595070; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsStop
  ## Stop a service fabric This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595081 = newJObject()
  var query_595082 = newJObject()
  add(path_595081, "resourceGroupName", newJString(resourceGroupName))
  add(query_595082, "api-version", newJString(apiVersion))
  add(path_595081, "name", newJString(name))
  add(path_595081, "subscriptionId", newJString(subscriptionId))
  add(path_595081, "userName", newJString(userName))
  add(path_595081, "labName", newJString(labName))
  result = call_595080.call(path_595081, query_595082, nil, nil, nil)

var serviceFabricsStop* = Call_ServiceFabricsStop_595070(
    name: "serviceFabricsStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}/stop",
    validator: validate_ServiceFabricsStop_595071, base: "",
    url: url_ServiceFabricsStop_595072, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesList_595083 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricSchedulesList_595085(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "serviceFabricName" in path,
        "`serviceFabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "serviceFabricName"),
               (kind: ConstantSegment, value: "/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricSchedulesList_595084(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a given service fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595086 = path.getOrDefault("resourceGroupName")
  valid_595086 = validateParameter(valid_595086, JString, required = true,
                                 default = nil)
  if valid_595086 != nil:
    section.add "resourceGroupName", valid_595086
  var valid_595087 = path.getOrDefault("subscriptionId")
  valid_595087 = validateParameter(valid_595087, JString, required = true,
                                 default = nil)
  if valid_595087 != nil:
    section.add "subscriptionId", valid_595087
  var valid_595088 = path.getOrDefault("userName")
  valid_595088 = validateParameter(valid_595088, JString, required = true,
                                 default = nil)
  if valid_595088 != nil:
    section.add "userName", valid_595088
  var valid_595089 = path.getOrDefault("labName")
  valid_595089 = validateParameter(valid_595089, JString, required = true,
                                 default = nil)
  if valid_595089 != nil:
    section.add "labName", valid_595089
  var valid_595090 = path.getOrDefault("serviceFabricName")
  valid_595090 = validateParameter(valid_595090, JString, required = true,
                                 default = nil)
  if valid_595090 != nil:
    section.add "serviceFabricName", valid_595090
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_595091 = query.getOrDefault("$orderby")
  valid_595091 = validateParameter(valid_595091, JString, required = false,
                                 default = nil)
  if valid_595091 != nil:
    section.add "$orderby", valid_595091
  var valid_595092 = query.getOrDefault("$expand")
  valid_595092 = validateParameter(valid_595092, JString, required = false,
                                 default = nil)
  if valid_595092 != nil:
    section.add "$expand", valid_595092
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595093 = query.getOrDefault("api-version")
  valid_595093 = validateParameter(valid_595093, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595093 != nil:
    section.add "api-version", valid_595093
  var valid_595094 = query.getOrDefault("$top")
  valid_595094 = validateParameter(valid_595094, JInt, required = false, default = nil)
  if valid_595094 != nil:
    section.add "$top", valid_595094
  var valid_595095 = query.getOrDefault("$filter")
  valid_595095 = validateParameter(valid_595095, JString, required = false,
                                 default = nil)
  if valid_595095 != nil:
    section.add "$filter", valid_595095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595096: Call_ServiceFabricSchedulesList_595083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given service fabric.
  ## 
  let valid = call_595096.validator(path, query, header, formData, body)
  let scheme = call_595096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595096.url(scheme.get, call_595096.host, call_595096.base,
                         call_595096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595096, url, valid)

proc call*(call_595097: Call_ServiceFabricSchedulesList_595083;
          resourceGroupName: string; subscriptionId: string; userName: string;
          labName: string; serviceFabricName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## serviceFabricSchedulesList
  ## List schedules in a given service fabric.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_595098 = newJObject()
  var query_595099 = newJObject()
  add(query_595099, "$orderby", newJString(Orderby))
  add(path_595098, "resourceGroupName", newJString(resourceGroupName))
  add(query_595099, "$expand", newJString(Expand))
  add(query_595099, "api-version", newJString(apiVersion))
  add(path_595098, "subscriptionId", newJString(subscriptionId))
  add(query_595099, "$top", newJInt(Top))
  add(path_595098, "userName", newJString(userName))
  add(path_595098, "labName", newJString(labName))
  add(path_595098, "serviceFabricName", newJString(serviceFabricName))
  add(query_595099, "$filter", newJString(Filter))
  result = call_595097.call(path_595098, query_595099, nil, nil, nil)

var serviceFabricSchedulesList* = Call_ServiceFabricSchedulesList_595083(
    name: "serviceFabricSchedulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules",
    validator: validate_ServiceFabricSchedulesList_595084, base: "",
    url: url_ServiceFabricSchedulesList_595085, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesCreateOrUpdate_595115 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricSchedulesCreateOrUpdate_595117(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "serviceFabricName" in path,
        "`serviceFabricName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "serviceFabricName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricSchedulesCreateOrUpdate_595116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595118 = path.getOrDefault("resourceGroupName")
  valid_595118 = validateParameter(valid_595118, JString, required = true,
                                 default = nil)
  if valid_595118 != nil:
    section.add "resourceGroupName", valid_595118
  var valid_595119 = path.getOrDefault("name")
  valid_595119 = validateParameter(valid_595119, JString, required = true,
                                 default = nil)
  if valid_595119 != nil:
    section.add "name", valid_595119
  var valid_595120 = path.getOrDefault("subscriptionId")
  valid_595120 = validateParameter(valid_595120, JString, required = true,
                                 default = nil)
  if valid_595120 != nil:
    section.add "subscriptionId", valid_595120
  var valid_595121 = path.getOrDefault("userName")
  valid_595121 = validateParameter(valid_595121, JString, required = true,
                                 default = nil)
  if valid_595121 != nil:
    section.add "userName", valid_595121
  var valid_595122 = path.getOrDefault("labName")
  valid_595122 = validateParameter(valid_595122, JString, required = true,
                                 default = nil)
  if valid_595122 != nil:
    section.add "labName", valid_595122
  var valid_595123 = path.getOrDefault("serviceFabricName")
  valid_595123 = validateParameter(valid_595123, JString, required = true,
                                 default = nil)
  if valid_595123 != nil:
    section.add "serviceFabricName", valid_595123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595124 = query.getOrDefault("api-version")
  valid_595124 = validateParameter(valid_595124, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595124 != nil:
    section.add "api-version", valid_595124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595126: Call_ServiceFabricSchedulesCreateOrUpdate_595115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_595126.validator(path, query, header, formData, body)
  let scheme = call_595126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595126.url(scheme.get, call_595126.host, call_595126.base,
                         call_595126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595126, url, valid)

proc call*(call_595127: Call_ServiceFabricSchedulesCreateOrUpdate_595115;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; schedule: JsonNode;
          serviceFabricName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesCreateOrUpdate
  ## Create or replace an existing schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  ##           : A schedule.
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  var path_595128 = newJObject()
  var query_595129 = newJObject()
  var body_595130 = newJObject()
  add(path_595128, "resourceGroupName", newJString(resourceGroupName))
  add(query_595129, "api-version", newJString(apiVersion))
  add(path_595128, "name", newJString(name))
  add(path_595128, "subscriptionId", newJString(subscriptionId))
  add(path_595128, "userName", newJString(userName))
  add(path_595128, "labName", newJString(labName))
  if schedule != nil:
    body_595130 = schedule
  add(path_595128, "serviceFabricName", newJString(serviceFabricName))
  result = call_595127.call(path_595128, query_595129, nil, nil, body_595130)

var serviceFabricSchedulesCreateOrUpdate* = Call_ServiceFabricSchedulesCreateOrUpdate_595115(
    name: "serviceFabricSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}",
    validator: validate_ServiceFabricSchedulesCreateOrUpdate_595116, base: "",
    url: url_ServiceFabricSchedulesCreateOrUpdate_595117, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesGet_595100 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricSchedulesGet_595102(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "serviceFabricName" in path,
        "`serviceFabricName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "serviceFabricName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricSchedulesGet_595101(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595103 = path.getOrDefault("resourceGroupName")
  valid_595103 = validateParameter(valid_595103, JString, required = true,
                                 default = nil)
  if valid_595103 != nil:
    section.add "resourceGroupName", valid_595103
  var valid_595104 = path.getOrDefault("name")
  valid_595104 = validateParameter(valid_595104, JString, required = true,
                                 default = nil)
  if valid_595104 != nil:
    section.add "name", valid_595104
  var valid_595105 = path.getOrDefault("subscriptionId")
  valid_595105 = validateParameter(valid_595105, JString, required = true,
                                 default = nil)
  if valid_595105 != nil:
    section.add "subscriptionId", valid_595105
  var valid_595106 = path.getOrDefault("userName")
  valid_595106 = validateParameter(valid_595106, JString, required = true,
                                 default = nil)
  if valid_595106 != nil:
    section.add "userName", valid_595106
  var valid_595107 = path.getOrDefault("labName")
  valid_595107 = validateParameter(valid_595107, JString, required = true,
                                 default = nil)
  if valid_595107 != nil:
    section.add "labName", valid_595107
  var valid_595108 = path.getOrDefault("serviceFabricName")
  valid_595108 = validateParameter(valid_595108, JString, required = true,
                                 default = nil)
  if valid_595108 != nil:
    section.add "serviceFabricName", valid_595108
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_595109 = query.getOrDefault("$expand")
  valid_595109 = validateParameter(valid_595109, JString, required = false,
                                 default = nil)
  if valid_595109 != nil:
    section.add "$expand", valid_595109
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595110 = query.getOrDefault("api-version")
  valid_595110 = validateParameter(valid_595110, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595110 != nil:
    section.add "api-version", valid_595110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595111: Call_ServiceFabricSchedulesGet_595100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_595111.validator(path, query, header, formData, body)
  let scheme = call_595111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595111.url(scheme.get, call_595111.host, call_595111.base,
                         call_595111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595111, url, valid)

proc call*(call_595112: Call_ServiceFabricSchedulesGet_595100;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; serviceFabricName: string;
          Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesGet
  ## Get schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  var path_595113 = newJObject()
  var query_595114 = newJObject()
  add(path_595113, "resourceGroupName", newJString(resourceGroupName))
  add(query_595114, "$expand", newJString(Expand))
  add(path_595113, "name", newJString(name))
  add(query_595114, "api-version", newJString(apiVersion))
  add(path_595113, "subscriptionId", newJString(subscriptionId))
  add(path_595113, "userName", newJString(userName))
  add(path_595113, "labName", newJString(labName))
  add(path_595113, "serviceFabricName", newJString(serviceFabricName))
  result = call_595112.call(path_595113, query_595114, nil, nil, nil)

var serviceFabricSchedulesGet* = Call_ServiceFabricSchedulesGet_595100(
    name: "serviceFabricSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}",
    validator: validate_ServiceFabricSchedulesGet_595101, base: "",
    url: url_ServiceFabricSchedulesGet_595102, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesUpdate_595145 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricSchedulesUpdate_595147(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "serviceFabricName" in path,
        "`serviceFabricName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "serviceFabricName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricSchedulesUpdate_595146(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595148 = path.getOrDefault("resourceGroupName")
  valid_595148 = validateParameter(valid_595148, JString, required = true,
                                 default = nil)
  if valid_595148 != nil:
    section.add "resourceGroupName", valid_595148
  var valid_595149 = path.getOrDefault("name")
  valid_595149 = validateParameter(valid_595149, JString, required = true,
                                 default = nil)
  if valid_595149 != nil:
    section.add "name", valid_595149
  var valid_595150 = path.getOrDefault("subscriptionId")
  valid_595150 = validateParameter(valid_595150, JString, required = true,
                                 default = nil)
  if valid_595150 != nil:
    section.add "subscriptionId", valid_595150
  var valid_595151 = path.getOrDefault("userName")
  valid_595151 = validateParameter(valid_595151, JString, required = true,
                                 default = nil)
  if valid_595151 != nil:
    section.add "userName", valid_595151
  var valid_595152 = path.getOrDefault("labName")
  valid_595152 = validateParameter(valid_595152, JString, required = true,
                                 default = nil)
  if valid_595152 != nil:
    section.add "labName", valid_595152
  var valid_595153 = path.getOrDefault("serviceFabricName")
  valid_595153 = validateParameter(valid_595153, JString, required = true,
                                 default = nil)
  if valid_595153 != nil:
    section.add "serviceFabricName", valid_595153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595154 = query.getOrDefault("api-version")
  valid_595154 = validateParameter(valid_595154, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595154 != nil:
    section.add "api-version", valid_595154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595156: Call_ServiceFabricSchedulesUpdate_595145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  let valid = call_595156.validator(path, query, header, formData, body)
  let scheme = call_595156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595156.url(scheme.get, call_595156.host, call_595156.base,
                         call_595156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595156, url, valid)

proc call*(call_595157: Call_ServiceFabricSchedulesUpdate_595145;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; schedule: JsonNode;
          serviceFabricName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesUpdate
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  ##           : A schedule.
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  var path_595158 = newJObject()
  var query_595159 = newJObject()
  var body_595160 = newJObject()
  add(path_595158, "resourceGroupName", newJString(resourceGroupName))
  add(query_595159, "api-version", newJString(apiVersion))
  add(path_595158, "name", newJString(name))
  add(path_595158, "subscriptionId", newJString(subscriptionId))
  add(path_595158, "userName", newJString(userName))
  add(path_595158, "labName", newJString(labName))
  if schedule != nil:
    body_595160 = schedule
  add(path_595158, "serviceFabricName", newJString(serviceFabricName))
  result = call_595157.call(path_595158, query_595159, nil, nil, body_595160)

var serviceFabricSchedulesUpdate* = Call_ServiceFabricSchedulesUpdate_595145(
    name: "serviceFabricSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}",
    validator: validate_ServiceFabricSchedulesUpdate_595146, base: "",
    url: url_ServiceFabricSchedulesUpdate_595147, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesDelete_595131 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricSchedulesDelete_595133(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "serviceFabricName" in path,
        "`serviceFabricName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "serviceFabricName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricSchedulesDelete_595132(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595134 = path.getOrDefault("resourceGroupName")
  valid_595134 = validateParameter(valid_595134, JString, required = true,
                                 default = nil)
  if valid_595134 != nil:
    section.add "resourceGroupName", valid_595134
  var valid_595135 = path.getOrDefault("name")
  valid_595135 = validateParameter(valid_595135, JString, required = true,
                                 default = nil)
  if valid_595135 != nil:
    section.add "name", valid_595135
  var valid_595136 = path.getOrDefault("subscriptionId")
  valid_595136 = validateParameter(valid_595136, JString, required = true,
                                 default = nil)
  if valid_595136 != nil:
    section.add "subscriptionId", valid_595136
  var valid_595137 = path.getOrDefault("userName")
  valid_595137 = validateParameter(valid_595137, JString, required = true,
                                 default = nil)
  if valid_595137 != nil:
    section.add "userName", valid_595137
  var valid_595138 = path.getOrDefault("labName")
  valid_595138 = validateParameter(valid_595138, JString, required = true,
                                 default = nil)
  if valid_595138 != nil:
    section.add "labName", valid_595138
  var valid_595139 = path.getOrDefault("serviceFabricName")
  valid_595139 = validateParameter(valid_595139, JString, required = true,
                                 default = nil)
  if valid_595139 != nil:
    section.add "serviceFabricName", valid_595139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595140 = query.getOrDefault("api-version")
  valid_595140 = validateParameter(valid_595140, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595140 != nil:
    section.add "api-version", valid_595140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595141: Call_ServiceFabricSchedulesDelete_595131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_595141.validator(path, query, header, formData, body)
  let scheme = call_595141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595141.url(scheme.get, call_595141.host, call_595141.base,
                         call_595141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595141, url, valid)

proc call*(call_595142: Call_ServiceFabricSchedulesDelete_595131;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; serviceFabricName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesDelete
  ## Delete schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  var path_595143 = newJObject()
  var query_595144 = newJObject()
  add(path_595143, "resourceGroupName", newJString(resourceGroupName))
  add(query_595144, "api-version", newJString(apiVersion))
  add(path_595143, "name", newJString(name))
  add(path_595143, "subscriptionId", newJString(subscriptionId))
  add(path_595143, "userName", newJString(userName))
  add(path_595143, "labName", newJString(labName))
  add(path_595143, "serviceFabricName", newJString(serviceFabricName))
  result = call_595142.call(path_595143, query_595144, nil, nil, nil)

var serviceFabricSchedulesDelete* = Call_ServiceFabricSchedulesDelete_595131(
    name: "serviceFabricSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}",
    validator: validate_ServiceFabricSchedulesDelete_595132, base: "",
    url: url_ServiceFabricSchedulesDelete_595133, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesExecute_595161 = ref object of OpenApiRestCall_593437
proc url_ServiceFabricSchedulesExecute_595163(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "serviceFabricName" in path,
        "`serviceFabricName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "serviceFabricName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricSchedulesExecute_595162(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595164 = path.getOrDefault("resourceGroupName")
  valid_595164 = validateParameter(valid_595164, JString, required = true,
                                 default = nil)
  if valid_595164 != nil:
    section.add "resourceGroupName", valid_595164
  var valid_595165 = path.getOrDefault("name")
  valid_595165 = validateParameter(valid_595165, JString, required = true,
                                 default = nil)
  if valid_595165 != nil:
    section.add "name", valid_595165
  var valid_595166 = path.getOrDefault("subscriptionId")
  valid_595166 = validateParameter(valid_595166, JString, required = true,
                                 default = nil)
  if valid_595166 != nil:
    section.add "subscriptionId", valid_595166
  var valid_595167 = path.getOrDefault("userName")
  valid_595167 = validateParameter(valid_595167, JString, required = true,
                                 default = nil)
  if valid_595167 != nil:
    section.add "userName", valid_595167
  var valid_595168 = path.getOrDefault("labName")
  valid_595168 = validateParameter(valid_595168, JString, required = true,
                                 default = nil)
  if valid_595168 != nil:
    section.add "labName", valid_595168
  var valid_595169 = path.getOrDefault("serviceFabricName")
  valid_595169 = validateParameter(valid_595169, JString, required = true,
                                 default = nil)
  if valid_595169 != nil:
    section.add "serviceFabricName", valid_595169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595170 = query.getOrDefault("api-version")
  valid_595170 = validateParameter(valid_595170, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595170 != nil:
    section.add "api-version", valid_595170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595171: Call_ServiceFabricSchedulesExecute_595161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_595171.validator(path, query, header, formData, body)
  let scheme = call_595171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595171.url(scheme.get, call_595171.host, call_595171.base,
                         call_595171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595171, url, valid)

proc call*(call_595172: Call_ServiceFabricSchedulesExecute_595161;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; serviceFabricName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  var path_595173 = newJObject()
  var query_595174 = newJObject()
  add(path_595173, "resourceGroupName", newJString(resourceGroupName))
  add(query_595174, "api-version", newJString(apiVersion))
  add(path_595173, "name", newJString(name))
  add(path_595173, "subscriptionId", newJString(subscriptionId))
  add(path_595173, "userName", newJString(userName))
  add(path_595173, "labName", newJString(labName))
  add(path_595173, "serviceFabricName", newJString(serviceFabricName))
  result = call_595172.call(path_595173, query_595174, nil, nil, nil)

var serviceFabricSchedulesExecute* = Call_ServiceFabricSchedulesExecute_595161(
    name: "serviceFabricSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}/execute",
    validator: validate_ServiceFabricSchedulesExecute_595162, base: "",
    url: url_ServiceFabricSchedulesExecute_595163, schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_595175 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesList_595177(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesList_595176(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List virtual machines in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595178 = path.getOrDefault("resourceGroupName")
  valid_595178 = validateParameter(valid_595178, JString, required = true,
                                 default = nil)
  if valid_595178 != nil:
    section.add "resourceGroupName", valid_595178
  var valid_595179 = path.getOrDefault("subscriptionId")
  valid_595179 = validateParameter(valid_595179, JString, required = true,
                                 default = nil)
  if valid_595179 != nil:
    section.add "subscriptionId", valid_595179
  var valid_595180 = path.getOrDefault("labName")
  valid_595180 = validateParameter(valid_595180, JString, required = true,
                                 default = nil)
  if valid_595180 != nil:
    section.add "labName", valid_595180
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_595181 = query.getOrDefault("$orderby")
  valid_595181 = validateParameter(valid_595181, JString, required = false,
                                 default = nil)
  if valid_595181 != nil:
    section.add "$orderby", valid_595181
  var valid_595182 = query.getOrDefault("$expand")
  valid_595182 = validateParameter(valid_595182, JString, required = false,
                                 default = nil)
  if valid_595182 != nil:
    section.add "$expand", valid_595182
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595183 = query.getOrDefault("api-version")
  valid_595183 = validateParameter(valid_595183, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595183 != nil:
    section.add "api-version", valid_595183
  var valid_595184 = query.getOrDefault("$top")
  valid_595184 = validateParameter(valid_595184, JInt, required = false, default = nil)
  if valid_595184 != nil:
    section.add "$top", valid_595184
  var valid_595185 = query.getOrDefault("$filter")
  valid_595185 = validateParameter(valid_595185, JString, required = false,
                                 default = nil)
  if valid_595185 != nil:
    section.add "$filter", valid_595185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595186: Call_VirtualMachinesList_595175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual machines in a given lab.
  ## 
  let valid = call_595186.validator(path, query, header, formData, body)
  let scheme = call_595186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595186.url(scheme.get, call_595186.host, call_595186.base,
                         call_595186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595186, url, valid)

proc call*(call_595187: Call_VirtualMachinesList_595175; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualMachinesList
  ## List virtual machines in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_595188 = newJObject()
  var query_595189 = newJObject()
  add(query_595189, "$orderby", newJString(Orderby))
  add(path_595188, "resourceGroupName", newJString(resourceGroupName))
  add(query_595189, "$expand", newJString(Expand))
  add(query_595189, "api-version", newJString(apiVersion))
  add(path_595188, "subscriptionId", newJString(subscriptionId))
  add(query_595189, "$top", newJInt(Top))
  add(path_595188, "labName", newJString(labName))
  add(query_595189, "$filter", newJString(Filter))
  result = call_595187.call(path_595188, query_595189, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_595175(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines",
    validator: validate_VirtualMachinesList_595176, base: "",
    url: url_VirtualMachinesList_595177, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_595203 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesCreateOrUpdate_595205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesCreateOrUpdate_595204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595206 = path.getOrDefault("resourceGroupName")
  valid_595206 = validateParameter(valid_595206, JString, required = true,
                                 default = nil)
  if valid_595206 != nil:
    section.add "resourceGroupName", valid_595206
  var valid_595207 = path.getOrDefault("name")
  valid_595207 = validateParameter(valid_595207, JString, required = true,
                                 default = nil)
  if valid_595207 != nil:
    section.add "name", valid_595207
  var valid_595208 = path.getOrDefault("subscriptionId")
  valid_595208 = validateParameter(valid_595208, JString, required = true,
                                 default = nil)
  if valid_595208 != nil:
    section.add "subscriptionId", valid_595208
  var valid_595209 = path.getOrDefault("labName")
  valid_595209 = validateParameter(valid_595209, JString, required = true,
                                 default = nil)
  if valid_595209 != nil:
    section.add "labName", valid_595209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595210 = query.getOrDefault("api-version")
  valid_595210 = validateParameter(valid_595210, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595210 != nil:
    section.add "api-version", valid_595210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labVirtualMachine: JObject (required)
  ##                    : A virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595212: Call_VirtualMachinesCreateOrUpdate_595203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_595212.validator(path, query, header, formData, body)
  let scheme = call_595212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595212.url(scheme.get, call_595212.host, call_595212.base,
                         call_595212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595212, url, valid)

proc call*(call_595213: Call_VirtualMachinesCreateOrUpdate_595203;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesCreateOrUpdate
  ## Create or replace an existing virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   labVirtualMachine: JObject (required)
  ##                    : A virtual machine.
  var path_595214 = newJObject()
  var query_595215 = newJObject()
  var body_595216 = newJObject()
  add(path_595214, "resourceGroupName", newJString(resourceGroupName))
  add(query_595215, "api-version", newJString(apiVersion))
  add(path_595214, "name", newJString(name))
  add(path_595214, "subscriptionId", newJString(subscriptionId))
  add(path_595214, "labName", newJString(labName))
  if labVirtualMachine != nil:
    body_595216 = labVirtualMachine
  result = call_595213.call(path_595214, query_595215, nil, nil, body_595216)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_595203(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesCreateOrUpdate_595204, base: "",
    url: url_VirtualMachinesCreateOrUpdate_595205, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_595190 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesGet_595192(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesGet_595191(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595193 = path.getOrDefault("resourceGroupName")
  valid_595193 = validateParameter(valid_595193, JString, required = true,
                                 default = nil)
  if valid_595193 != nil:
    section.add "resourceGroupName", valid_595193
  var valid_595194 = path.getOrDefault("name")
  valid_595194 = validateParameter(valid_595194, JString, required = true,
                                 default = nil)
  if valid_595194 != nil:
    section.add "name", valid_595194
  var valid_595195 = path.getOrDefault("subscriptionId")
  valid_595195 = validateParameter(valid_595195, JString, required = true,
                                 default = nil)
  if valid_595195 != nil:
    section.add "subscriptionId", valid_595195
  var valid_595196 = path.getOrDefault("labName")
  valid_595196 = validateParameter(valid_595196, JString, required = true,
                                 default = nil)
  if valid_595196 != nil:
    section.add "labName", valid_595196
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_595197 = query.getOrDefault("$expand")
  valid_595197 = validateParameter(valid_595197, JString, required = false,
                                 default = nil)
  if valid_595197 != nil:
    section.add "$expand", valid_595197
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595198 = query.getOrDefault("api-version")
  valid_595198 = validateParameter(valid_595198, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595198 != nil:
    section.add "api-version", valid_595198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595199: Call_VirtualMachinesGet_595190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual machine.
  ## 
  let valid = call_595199.validator(path, query, header, formData, body)
  let scheme = call_595199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595199.url(scheme.get, call_595199.host, call_595199.base,
                         call_595199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595199, url, valid)

proc call*(call_595200: Call_VirtualMachinesGet_595190; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesGet
  ## Get virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595201 = newJObject()
  var query_595202 = newJObject()
  add(path_595201, "resourceGroupName", newJString(resourceGroupName))
  add(query_595202, "$expand", newJString(Expand))
  add(path_595201, "name", newJString(name))
  add(query_595202, "api-version", newJString(apiVersion))
  add(path_595201, "subscriptionId", newJString(subscriptionId))
  add(path_595201, "labName", newJString(labName))
  result = call_595200.call(path_595201, query_595202, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_595190(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesGet_595191, base: "",
    url: url_VirtualMachinesGet_595192, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUpdate_595229 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesUpdate_595231(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesUpdate_595230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of virtual machines. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595232 = path.getOrDefault("resourceGroupName")
  valid_595232 = validateParameter(valid_595232, JString, required = true,
                                 default = nil)
  if valid_595232 != nil:
    section.add "resourceGroupName", valid_595232
  var valid_595233 = path.getOrDefault("name")
  valid_595233 = validateParameter(valid_595233, JString, required = true,
                                 default = nil)
  if valid_595233 != nil:
    section.add "name", valid_595233
  var valid_595234 = path.getOrDefault("subscriptionId")
  valid_595234 = validateParameter(valid_595234, JString, required = true,
                                 default = nil)
  if valid_595234 != nil:
    section.add "subscriptionId", valid_595234
  var valid_595235 = path.getOrDefault("labName")
  valid_595235 = validateParameter(valid_595235, JString, required = true,
                                 default = nil)
  if valid_595235 != nil:
    section.add "labName", valid_595235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595236 = query.getOrDefault("api-version")
  valid_595236 = validateParameter(valid_595236, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595236 != nil:
    section.add "api-version", valid_595236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labVirtualMachine: JObject (required)
  ##                    : A virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595238: Call_VirtualMachinesUpdate_595229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of virtual machines. All other properties will be ignored.
  ## 
  let valid = call_595238.validator(path, query, header, formData, body)
  let scheme = call_595238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595238.url(scheme.get, call_595238.host, call_595238.base,
                         call_595238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595238, url, valid)

proc call*(call_595239: Call_VirtualMachinesUpdate_595229;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesUpdate
  ## Allows modifying tags of virtual machines. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   labVirtualMachine: JObject (required)
  ##                    : A virtual machine.
  var path_595240 = newJObject()
  var query_595241 = newJObject()
  var body_595242 = newJObject()
  add(path_595240, "resourceGroupName", newJString(resourceGroupName))
  add(query_595241, "api-version", newJString(apiVersion))
  add(path_595240, "name", newJString(name))
  add(path_595240, "subscriptionId", newJString(subscriptionId))
  add(path_595240, "labName", newJString(labName))
  if labVirtualMachine != nil:
    body_595242 = labVirtualMachine
  result = call_595239.call(path_595240, query_595241, nil, nil, body_595242)

var virtualMachinesUpdate* = Call_VirtualMachinesUpdate_595229(
    name: "virtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesUpdate_595230, base: "",
    url: url_VirtualMachinesUpdate_595231, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_595217 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesDelete_595219(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesDelete_595218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595220 = path.getOrDefault("resourceGroupName")
  valid_595220 = validateParameter(valid_595220, JString, required = true,
                                 default = nil)
  if valid_595220 != nil:
    section.add "resourceGroupName", valid_595220
  var valid_595221 = path.getOrDefault("name")
  valid_595221 = validateParameter(valid_595221, JString, required = true,
                                 default = nil)
  if valid_595221 != nil:
    section.add "name", valid_595221
  var valid_595222 = path.getOrDefault("subscriptionId")
  valid_595222 = validateParameter(valid_595222, JString, required = true,
                                 default = nil)
  if valid_595222 != nil:
    section.add "subscriptionId", valid_595222
  var valid_595223 = path.getOrDefault("labName")
  valid_595223 = validateParameter(valid_595223, JString, required = true,
                                 default = nil)
  if valid_595223 != nil:
    section.add "labName", valid_595223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595224 = query.getOrDefault("api-version")
  valid_595224 = validateParameter(valid_595224, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595224 != nil:
    section.add "api-version", valid_595224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595225: Call_VirtualMachinesDelete_595217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_595225.validator(path, query, header, formData, body)
  let scheme = call_595225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595225.url(scheme.get, call_595225.host, call_595225.base,
                         call_595225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595225, url, valid)

proc call*(call_595226: Call_VirtualMachinesDelete_595217;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesDelete
  ## Delete virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595227 = newJObject()
  var query_595228 = newJObject()
  add(path_595227, "resourceGroupName", newJString(resourceGroupName))
  add(query_595228, "api-version", newJString(apiVersion))
  add(path_595227, "name", newJString(name))
  add(path_595227, "subscriptionId", newJString(subscriptionId))
  add(path_595227, "labName", newJString(labName))
  result = call_595226.call(path_595227, query_595228, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_595217(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesDelete_595218, base: "",
    url: url_VirtualMachinesDelete_595219, schemes: {Scheme.Https})
type
  Call_VirtualMachinesAddDataDisk_595243 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesAddDataDisk_595245(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/addDataDisk")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesAddDataDisk_595244(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Attach a new or existing data disk to virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595246 = path.getOrDefault("resourceGroupName")
  valid_595246 = validateParameter(valid_595246, JString, required = true,
                                 default = nil)
  if valid_595246 != nil:
    section.add "resourceGroupName", valid_595246
  var valid_595247 = path.getOrDefault("name")
  valid_595247 = validateParameter(valid_595247, JString, required = true,
                                 default = nil)
  if valid_595247 != nil:
    section.add "name", valid_595247
  var valid_595248 = path.getOrDefault("subscriptionId")
  valid_595248 = validateParameter(valid_595248, JString, required = true,
                                 default = nil)
  if valid_595248 != nil:
    section.add "subscriptionId", valid_595248
  var valid_595249 = path.getOrDefault("labName")
  valid_595249 = validateParameter(valid_595249, JString, required = true,
                                 default = nil)
  if valid_595249 != nil:
    section.add "labName", valid_595249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595250 = query.getOrDefault("api-version")
  valid_595250 = validateParameter(valid_595250, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595250 != nil:
    section.add "api-version", valid_595250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataDiskProperties: JObject (required)
  ##                     : Request body for adding a new or existing data disk to a virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595252: Call_VirtualMachinesAddDataDisk_595243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attach a new or existing data disk to virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_595252.validator(path, query, header, formData, body)
  let scheme = call_595252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595252.url(scheme.get, call_595252.host, call_595252.base,
                         call_595252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595252, url, valid)

proc call*(call_595253: Call_VirtualMachinesAddDataDisk_595243;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; dataDiskProperties: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesAddDataDisk
  ## Attach a new or existing data disk to virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   dataDiskProperties: JObject (required)
  ##                     : Request body for adding a new or existing data disk to a virtual machine.
  var path_595254 = newJObject()
  var query_595255 = newJObject()
  var body_595256 = newJObject()
  add(path_595254, "resourceGroupName", newJString(resourceGroupName))
  add(query_595255, "api-version", newJString(apiVersion))
  add(path_595254, "name", newJString(name))
  add(path_595254, "subscriptionId", newJString(subscriptionId))
  add(path_595254, "labName", newJString(labName))
  if dataDiskProperties != nil:
    body_595256 = dataDiskProperties
  result = call_595253.call(path_595254, query_595255, nil, nil, body_595256)

var virtualMachinesAddDataDisk* = Call_VirtualMachinesAddDataDisk_595243(
    name: "virtualMachinesAddDataDisk", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/addDataDisk",
    validator: validate_VirtualMachinesAddDataDisk_595244, base: "",
    url: url_VirtualMachinesAddDataDisk_595245, schemes: {Scheme.Https})
type
  Call_VirtualMachinesApplyArtifacts_595257 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesApplyArtifacts_595259(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/applyArtifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesApplyArtifacts_595258(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Apply artifacts to virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595260 = path.getOrDefault("resourceGroupName")
  valid_595260 = validateParameter(valid_595260, JString, required = true,
                                 default = nil)
  if valid_595260 != nil:
    section.add "resourceGroupName", valid_595260
  var valid_595261 = path.getOrDefault("name")
  valid_595261 = validateParameter(valid_595261, JString, required = true,
                                 default = nil)
  if valid_595261 != nil:
    section.add "name", valid_595261
  var valid_595262 = path.getOrDefault("subscriptionId")
  valid_595262 = validateParameter(valid_595262, JString, required = true,
                                 default = nil)
  if valid_595262 != nil:
    section.add "subscriptionId", valid_595262
  var valid_595263 = path.getOrDefault("labName")
  valid_595263 = validateParameter(valid_595263, JString, required = true,
                                 default = nil)
  if valid_595263 != nil:
    section.add "labName", valid_595263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595264 = query.getOrDefault("api-version")
  valid_595264 = validateParameter(valid_595264, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595264 != nil:
    section.add "api-version", valid_595264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applyArtifactsRequest: JObject (required)
  ##                        : Request body for applying artifacts to a virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595266: Call_VirtualMachinesApplyArtifacts_595257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply artifacts to virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_595266.validator(path, query, header, formData, body)
  let scheme = call_595266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595266.url(scheme.get, call_595266.host, call_595266.base,
                         call_595266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595266, url, valid)

proc call*(call_595267: Call_VirtualMachinesApplyArtifacts_595257;
          resourceGroupName: string; name: string; subscriptionId: string;
          applyArtifactsRequest: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesApplyArtifacts
  ## Apply artifacts to virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   applyArtifactsRequest: JObject (required)
  ##                        : Request body for applying artifacts to a virtual machine.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595268 = newJObject()
  var query_595269 = newJObject()
  var body_595270 = newJObject()
  add(path_595268, "resourceGroupName", newJString(resourceGroupName))
  add(query_595269, "api-version", newJString(apiVersion))
  add(path_595268, "name", newJString(name))
  add(path_595268, "subscriptionId", newJString(subscriptionId))
  if applyArtifactsRequest != nil:
    body_595270 = applyArtifactsRequest
  add(path_595268, "labName", newJString(labName))
  result = call_595267.call(path_595268, query_595269, nil, nil, body_595270)

var virtualMachinesApplyArtifacts* = Call_VirtualMachinesApplyArtifacts_595257(
    name: "virtualMachinesApplyArtifacts", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/applyArtifacts",
    validator: validate_VirtualMachinesApplyArtifacts_595258, base: "",
    url: url_VirtualMachinesApplyArtifacts_595259, schemes: {Scheme.Https})
type
  Call_VirtualMachinesClaim_595271 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesClaim_595273(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/claim")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesClaim_595272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Take ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595274 = path.getOrDefault("resourceGroupName")
  valid_595274 = validateParameter(valid_595274, JString, required = true,
                                 default = nil)
  if valid_595274 != nil:
    section.add "resourceGroupName", valid_595274
  var valid_595275 = path.getOrDefault("name")
  valid_595275 = validateParameter(valid_595275, JString, required = true,
                                 default = nil)
  if valid_595275 != nil:
    section.add "name", valid_595275
  var valid_595276 = path.getOrDefault("subscriptionId")
  valid_595276 = validateParameter(valid_595276, JString, required = true,
                                 default = nil)
  if valid_595276 != nil:
    section.add "subscriptionId", valid_595276
  var valid_595277 = path.getOrDefault("labName")
  valid_595277 = validateParameter(valid_595277, JString, required = true,
                                 default = nil)
  if valid_595277 != nil:
    section.add "labName", valid_595277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595278 = query.getOrDefault("api-version")
  valid_595278 = validateParameter(valid_595278, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595278 != nil:
    section.add "api-version", valid_595278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595279: Call_VirtualMachinesClaim_595271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  let valid = call_595279.validator(path, query, header, formData, body)
  let scheme = call_595279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595279.url(scheme.get, call_595279.host, call_595279.base,
                         call_595279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595279, url, valid)

proc call*(call_595280: Call_VirtualMachinesClaim_595271;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesClaim
  ## Take ownership of an existing virtual machine This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595281 = newJObject()
  var query_595282 = newJObject()
  add(path_595281, "resourceGroupName", newJString(resourceGroupName))
  add(query_595282, "api-version", newJString(apiVersion))
  add(path_595281, "name", newJString(name))
  add(path_595281, "subscriptionId", newJString(subscriptionId))
  add(path_595281, "labName", newJString(labName))
  result = call_595280.call(path_595281, query_595282, nil, nil, nil)

var virtualMachinesClaim* = Call_VirtualMachinesClaim_595271(
    name: "virtualMachinesClaim", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/claim",
    validator: validate_VirtualMachinesClaim_595272, base: "",
    url: url_VirtualMachinesClaim_595273, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDetachDataDisk_595283 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesDetachDataDisk_595285(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/detachDataDisk")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesDetachDataDisk_595284(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detach the specified disk from the virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595286 = path.getOrDefault("resourceGroupName")
  valid_595286 = validateParameter(valid_595286, JString, required = true,
                                 default = nil)
  if valid_595286 != nil:
    section.add "resourceGroupName", valid_595286
  var valid_595287 = path.getOrDefault("name")
  valid_595287 = validateParameter(valid_595287, JString, required = true,
                                 default = nil)
  if valid_595287 != nil:
    section.add "name", valid_595287
  var valid_595288 = path.getOrDefault("subscriptionId")
  valid_595288 = validateParameter(valid_595288, JString, required = true,
                                 default = nil)
  if valid_595288 != nil:
    section.add "subscriptionId", valid_595288
  var valid_595289 = path.getOrDefault("labName")
  valid_595289 = validateParameter(valid_595289, JString, required = true,
                                 default = nil)
  if valid_595289 != nil:
    section.add "labName", valid_595289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595290 = query.getOrDefault("api-version")
  valid_595290 = validateParameter(valid_595290, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595290 != nil:
    section.add "api-version", valid_595290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   detachDataDiskProperties: JObject (required)
  ##                           : Request body for detaching data disk from a virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595292: Call_VirtualMachinesDetachDataDisk_595283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the specified disk from the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_595292.validator(path, query, header, formData, body)
  let scheme = call_595292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595292.url(scheme.get, call_595292.host, call_595292.base,
                         call_595292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595292, url, valid)

proc call*(call_595293: Call_VirtualMachinesDetachDataDisk_595283;
          resourceGroupName: string; name: string; subscriptionId: string;
          detachDataDiskProperties: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesDetachDataDisk
  ## Detach the specified disk from the virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   detachDataDiskProperties: JObject (required)
  ##                           : Request body for detaching data disk from a virtual machine.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595294 = newJObject()
  var query_595295 = newJObject()
  var body_595296 = newJObject()
  add(path_595294, "resourceGroupName", newJString(resourceGroupName))
  add(query_595295, "api-version", newJString(apiVersion))
  add(path_595294, "name", newJString(name))
  add(path_595294, "subscriptionId", newJString(subscriptionId))
  if detachDataDiskProperties != nil:
    body_595296 = detachDataDiskProperties
  add(path_595294, "labName", newJString(labName))
  result = call_595293.call(path_595294, query_595295, nil, nil, body_595296)

var virtualMachinesDetachDataDisk* = Call_VirtualMachinesDetachDataDisk_595283(
    name: "virtualMachinesDetachDataDisk", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/detachDataDisk",
    validator: validate_VirtualMachinesDetachDataDisk_595284, base: "",
    url: url_VirtualMachinesDetachDataDisk_595285, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGetRdpFileContents_595297 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesGetRdpFileContents_595299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/getRdpFileContents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesGetRdpFileContents_595298(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a string that represents the contents of the RDP file for the virtual machine
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595300 = path.getOrDefault("resourceGroupName")
  valid_595300 = validateParameter(valid_595300, JString, required = true,
                                 default = nil)
  if valid_595300 != nil:
    section.add "resourceGroupName", valid_595300
  var valid_595301 = path.getOrDefault("name")
  valid_595301 = validateParameter(valid_595301, JString, required = true,
                                 default = nil)
  if valid_595301 != nil:
    section.add "name", valid_595301
  var valid_595302 = path.getOrDefault("subscriptionId")
  valid_595302 = validateParameter(valid_595302, JString, required = true,
                                 default = nil)
  if valid_595302 != nil:
    section.add "subscriptionId", valid_595302
  var valid_595303 = path.getOrDefault("labName")
  valid_595303 = validateParameter(valid_595303, JString, required = true,
                                 default = nil)
  if valid_595303 != nil:
    section.add "labName", valid_595303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595304 = query.getOrDefault("api-version")
  valid_595304 = validateParameter(valid_595304, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595304 != nil:
    section.add "api-version", valid_595304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595305: Call_VirtualMachinesGetRdpFileContents_595297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a string that represents the contents of the RDP file for the virtual machine
  ## 
  let valid = call_595305.validator(path, query, header, formData, body)
  let scheme = call_595305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595305.url(scheme.get, call_595305.host, call_595305.base,
                         call_595305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595305, url, valid)

proc call*(call_595306: Call_VirtualMachinesGetRdpFileContents_595297;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesGetRdpFileContents
  ## Gets a string that represents the contents of the RDP file for the virtual machine
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595307 = newJObject()
  var query_595308 = newJObject()
  add(path_595307, "resourceGroupName", newJString(resourceGroupName))
  add(query_595308, "api-version", newJString(apiVersion))
  add(path_595307, "name", newJString(name))
  add(path_595307, "subscriptionId", newJString(subscriptionId))
  add(path_595307, "labName", newJString(labName))
  result = call_595306.call(path_595307, query_595308, nil, nil, nil)

var virtualMachinesGetRdpFileContents* = Call_VirtualMachinesGetRdpFileContents_595297(
    name: "virtualMachinesGetRdpFileContents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/getRdpFileContents",
    validator: validate_VirtualMachinesGetRdpFileContents_595298, base: "",
    url: url_VirtualMachinesGetRdpFileContents_595299, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListApplicableSchedules_595309 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesListApplicableSchedules_595311(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/listApplicableSchedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesListApplicableSchedules_595310(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the applicable start/stop schedules, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595312 = path.getOrDefault("resourceGroupName")
  valid_595312 = validateParameter(valid_595312, JString, required = true,
                                 default = nil)
  if valid_595312 != nil:
    section.add "resourceGroupName", valid_595312
  var valid_595313 = path.getOrDefault("name")
  valid_595313 = validateParameter(valid_595313, JString, required = true,
                                 default = nil)
  if valid_595313 != nil:
    section.add "name", valid_595313
  var valid_595314 = path.getOrDefault("subscriptionId")
  valid_595314 = validateParameter(valid_595314, JString, required = true,
                                 default = nil)
  if valid_595314 != nil:
    section.add "subscriptionId", valid_595314
  var valid_595315 = path.getOrDefault("labName")
  valid_595315 = validateParameter(valid_595315, JString, required = true,
                                 default = nil)
  if valid_595315 != nil:
    section.add "labName", valid_595315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595316 = query.getOrDefault("api-version")
  valid_595316 = validateParameter(valid_595316, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595316 != nil:
    section.add "api-version", valid_595316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595317: Call_VirtualMachinesListApplicableSchedules_595309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the applicable start/stop schedules, if any.
  ## 
  let valid = call_595317.validator(path, query, header, formData, body)
  let scheme = call_595317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595317.url(scheme.get, call_595317.host, call_595317.base,
                         call_595317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595317, url, valid)

proc call*(call_595318: Call_VirtualMachinesListApplicableSchedules_595309;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesListApplicableSchedules
  ## Lists the applicable start/stop schedules, if any.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595319 = newJObject()
  var query_595320 = newJObject()
  add(path_595319, "resourceGroupName", newJString(resourceGroupName))
  add(query_595320, "api-version", newJString(apiVersion))
  add(path_595319, "name", newJString(name))
  add(path_595319, "subscriptionId", newJString(subscriptionId))
  add(path_595319, "labName", newJString(labName))
  result = call_595318.call(path_595319, query_595320, nil, nil, nil)

var virtualMachinesListApplicableSchedules* = Call_VirtualMachinesListApplicableSchedules_595309(
    name: "virtualMachinesListApplicableSchedules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/listApplicableSchedules",
    validator: validate_VirtualMachinesListApplicableSchedules_595310, base: "",
    url: url_VirtualMachinesListApplicableSchedules_595311,
    schemes: {Scheme.Https})
type
  Call_VirtualMachinesRedeploy_595321 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesRedeploy_595323(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/redeploy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesRedeploy_595322(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Redeploy a virtual machine This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595324 = path.getOrDefault("resourceGroupName")
  valid_595324 = validateParameter(valid_595324, JString, required = true,
                                 default = nil)
  if valid_595324 != nil:
    section.add "resourceGroupName", valid_595324
  var valid_595325 = path.getOrDefault("name")
  valid_595325 = validateParameter(valid_595325, JString, required = true,
                                 default = nil)
  if valid_595325 != nil:
    section.add "name", valid_595325
  var valid_595326 = path.getOrDefault("subscriptionId")
  valid_595326 = validateParameter(valid_595326, JString, required = true,
                                 default = nil)
  if valid_595326 != nil:
    section.add "subscriptionId", valid_595326
  var valid_595327 = path.getOrDefault("labName")
  valid_595327 = validateParameter(valid_595327, JString, required = true,
                                 default = nil)
  if valid_595327 != nil:
    section.add "labName", valid_595327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595328 = query.getOrDefault("api-version")
  valid_595328 = validateParameter(valid_595328, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595328 != nil:
    section.add "api-version", valid_595328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595329: Call_VirtualMachinesRedeploy_595321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Redeploy a virtual machine This operation can take a while to complete.
  ## 
  let valid = call_595329.validator(path, query, header, formData, body)
  let scheme = call_595329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595329.url(scheme.get, call_595329.host, call_595329.base,
                         call_595329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595329, url, valid)

proc call*(call_595330: Call_VirtualMachinesRedeploy_595321;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesRedeploy
  ## Redeploy a virtual machine This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595331 = newJObject()
  var query_595332 = newJObject()
  add(path_595331, "resourceGroupName", newJString(resourceGroupName))
  add(query_595332, "api-version", newJString(apiVersion))
  add(path_595331, "name", newJString(name))
  add(path_595331, "subscriptionId", newJString(subscriptionId))
  add(path_595331, "labName", newJString(labName))
  result = call_595330.call(path_595331, query_595332, nil, nil, nil)

var virtualMachinesRedeploy* = Call_VirtualMachinesRedeploy_595321(
    name: "virtualMachinesRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/redeploy",
    validator: validate_VirtualMachinesRedeploy_595322, base: "",
    url: url_VirtualMachinesRedeploy_595323, schemes: {Scheme.Https})
type
  Call_VirtualMachinesResize_595333 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesResize_595335(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/resize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesResize_595334(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resize Virtual Machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595336 = path.getOrDefault("resourceGroupName")
  valid_595336 = validateParameter(valid_595336, JString, required = true,
                                 default = nil)
  if valid_595336 != nil:
    section.add "resourceGroupName", valid_595336
  var valid_595337 = path.getOrDefault("name")
  valid_595337 = validateParameter(valid_595337, JString, required = true,
                                 default = nil)
  if valid_595337 != nil:
    section.add "name", valid_595337
  var valid_595338 = path.getOrDefault("subscriptionId")
  valid_595338 = validateParameter(valid_595338, JString, required = true,
                                 default = nil)
  if valid_595338 != nil:
    section.add "subscriptionId", valid_595338
  var valid_595339 = path.getOrDefault("labName")
  valid_595339 = validateParameter(valid_595339, JString, required = true,
                                 default = nil)
  if valid_595339 != nil:
    section.add "labName", valid_595339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595340 = query.getOrDefault("api-version")
  valid_595340 = validateParameter(valid_595340, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595340 != nil:
    section.add "api-version", valid_595340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resizeLabVirtualMachineProperties: JObject (required)
  ##                                    : Request body for resizing a virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595342: Call_VirtualMachinesResize_595333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resize Virtual Machine. This operation can take a while to complete.
  ## 
  let valid = call_595342.validator(path, query, header, formData, body)
  let scheme = call_595342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595342.url(scheme.get, call_595342.host, call_595342.base,
                         call_595342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595342, url, valid)

proc call*(call_595343: Call_VirtualMachinesResize_595333;
          resourceGroupName: string; name: string; subscriptionId: string;
          resizeLabVirtualMachineProperties: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesResize
  ## Resize Virtual Machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resizeLabVirtualMachineProperties: JObject (required)
  ##                                    : Request body for resizing a virtual machine.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595344 = newJObject()
  var query_595345 = newJObject()
  var body_595346 = newJObject()
  add(path_595344, "resourceGroupName", newJString(resourceGroupName))
  add(query_595345, "api-version", newJString(apiVersion))
  add(path_595344, "name", newJString(name))
  add(path_595344, "subscriptionId", newJString(subscriptionId))
  if resizeLabVirtualMachineProperties != nil:
    body_595346 = resizeLabVirtualMachineProperties
  add(path_595344, "labName", newJString(labName))
  result = call_595343.call(path_595344, query_595345, nil, nil, body_595346)

var virtualMachinesResize* = Call_VirtualMachinesResize_595333(
    name: "virtualMachinesResize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/resize",
    validator: validate_VirtualMachinesResize_595334, base: "",
    url: url_VirtualMachinesResize_595335, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRestart_595347 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesRestart_595349(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesRestart_595348(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restart a virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595350 = path.getOrDefault("resourceGroupName")
  valid_595350 = validateParameter(valid_595350, JString, required = true,
                                 default = nil)
  if valid_595350 != nil:
    section.add "resourceGroupName", valid_595350
  var valid_595351 = path.getOrDefault("name")
  valid_595351 = validateParameter(valid_595351, JString, required = true,
                                 default = nil)
  if valid_595351 != nil:
    section.add "name", valid_595351
  var valid_595352 = path.getOrDefault("subscriptionId")
  valid_595352 = validateParameter(valid_595352, JString, required = true,
                                 default = nil)
  if valid_595352 != nil:
    section.add "subscriptionId", valid_595352
  var valid_595353 = path.getOrDefault("labName")
  valid_595353 = validateParameter(valid_595353, JString, required = true,
                                 default = nil)
  if valid_595353 != nil:
    section.add "labName", valid_595353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595354 = query.getOrDefault("api-version")
  valid_595354 = validateParameter(valid_595354, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595354 != nil:
    section.add "api-version", valid_595354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595355: Call_VirtualMachinesRestart_595347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restart a virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_595355.validator(path, query, header, formData, body)
  let scheme = call_595355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595355.url(scheme.get, call_595355.host, call_595355.base,
                         call_595355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595355, url, valid)

proc call*(call_595356: Call_VirtualMachinesRestart_595347;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesRestart
  ## Restart a virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595357 = newJObject()
  var query_595358 = newJObject()
  add(path_595357, "resourceGroupName", newJString(resourceGroupName))
  add(query_595358, "api-version", newJString(apiVersion))
  add(path_595357, "name", newJString(name))
  add(path_595357, "subscriptionId", newJString(subscriptionId))
  add(path_595357, "labName", newJString(labName))
  result = call_595356.call(path_595357, query_595358, nil, nil, nil)

var virtualMachinesRestart* = Call_VirtualMachinesRestart_595347(
    name: "virtualMachinesRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/restart",
    validator: validate_VirtualMachinesRestart_595348, base: "",
    url: url_VirtualMachinesRestart_595349, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_595359 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesStart_595361(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesStart_595360(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start a virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595362 = path.getOrDefault("resourceGroupName")
  valid_595362 = validateParameter(valid_595362, JString, required = true,
                                 default = nil)
  if valid_595362 != nil:
    section.add "resourceGroupName", valid_595362
  var valid_595363 = path.getOrDefault("name")
  valid_595363 = validateParameter(valid_595363, JString, required = true,
                                 default = nil)
  if valid_595363 != nil:
    section.add "name", valid_595363
  var valid_595364 = path.getOrDefault("subscriptionId")
  valid_595364 = validateParameter(valid_595364, JString, required = true,
                                 default = nil)
  if valid_595364 != nil:
    section.add "subscriptionId", valid_595364
  var valid_595365 = path.getOrDefault("labName")
  valid_595365 = validateParameter(valid_595365, JString, required = true,
                                 default = nil)
  if valid_595365 != nil:
    section.add "labName", valid_595365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595366 = query.getOrDefault("api-version")
  valid_595366 = validateParameter(valid_595366, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595366 != nil:
    section.add "api-version", valid_595366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595367: Call_VirtualMachinesStart_595359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start a virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_595367.validator(path, query, header, formData, body)
  let scheme = call_595367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595367.url(scheme.get, call_595367.host, call_595367.base,
                         call_595367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595367, url, valid)

proc call*(call_595368: Call_VirtualMachinesStart_595359;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesStart
  ## Start a virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595369 = newJObject()
  var query_595370 = newJObject()
  add(path_595369, "resourceGroupName", newJString(resourceGroupName))
  add(query_595370, "api-version", newJString(apiVersion))
  add(path_595369, "name", newJString(name))
  add(path_595369, "subscriptionId", newJString(subscriptionId))
  add(path_595369, "labName", newJString(labName))
  result = call_595368.call(path_595369, query_595370, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_595359(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/start",
    validator: validate_VirtualMachinesStart_595360, base: "",
    url: url_VirtualMachinesStart_595361, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStop_595371 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesStop_595373(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesStop_595372(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Stop a virtual machine This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595374 = path.getOrDefault("resourceGroupName")
  valid_595374 = validateParameter(valid_595374, JString, required = true,
                                 default = nil)
  if valid_595374 != nil:
    section.add "resourceGroupName", valid_595374
  var valid_595375 = path.getOrDefault("name")
  valid_595375 = validateParameter(valid_595375, JString, required = true,
                                 default = nil)
  if valid_595375 != nil:
    section.add "name", valid_595375
  var valid_595376 = path.getOrDefault("subscriptionId")
  valid_595376 = validateParameter(valid_595376, JString, required = true,
                                 default = nil)
  if valid_595376 != nil:
    section.add "subscriptionId", valid_595376
  var valid_595377 = path.getOrDefault("labName")
  valid_595377 = validateParameter(valid_595377, JString, required = true,
                                 default = nil)
  if valid_595377 != nil:
    section.add "labName", valid_595377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595378 = query.getOrDefault("api-version")
  valid_595378 = validateParameter(valid_595378, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595378 != nil:
    section.add "api-version", valid_595378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595379: Call_VirtualMachinesStop_595371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop a virtual machine This operation can take a while to complete.
  ## 
  let valid = call_595379.validator(path, query, header, formData, body)
  let scheme = call_595379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595379.url(scheme.get, call_595379.host, call_595379.base,
                         call_595379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595379, url, valid)

proc call*(call_595380: Call_VirtualMachinesStop_595371; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesStop
  ## Stop a virtual machine This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595381 = newJObject()
  var query_595382 = newJObject()
  add(path_595381, "resourceGroupName", newJString(resourceGroupName))
  add(query_595382, "api-version", newJString(apiVersion))
  add(path_595381, "name", newJString(name))
  add(path_595381, "subscriptionId", newJString(subscriptionId))
  add(path_595381, "labName", newJString(labName))
  result = call_595380.call(path_595381, query_595382, nil, nil, nil)

var virtualMachinesStop* = Call_VirtualMachinesStop_595371(
    name: "virtualMachinesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/stop",
    validator: validate_VirtualMachinesStop_595372, base: "",
    url: url_VirtualMachinesStop_595373, schemes: {Scheme.Https})
type
  Call_VirtualMachinesTransferDisks_595383 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesTransferDisks_595385(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/transferDisks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesTransferDisks_595384(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Transfers all data disks attached to the virtual machine to be owned by the current user. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595386 = path.getOrDefault("resourceGroupName")
  valid_595386 = validateParameter(valid_595386, JString, required = true,
                                 default = nil)
  if valid_595386 != nil:
    section.add "resourceGroupName", valid_595386
  var valid_595387 = path.getOrDefault("name")
  valid_595387 = validateParameter(valid_595387, JString, required = true,
                                 default = nil)
  if valid_595387 != nil:
    section.add "name", valid_595387
  var valid_595388 = path.getOrDefault("subscriptionId")
  valid_595388 = validateParameter(valid_595388, JString, required = true,
                                 default = nil)
  if valid_595388 != nil:
    section.add "subscriptionId", valid_595388
  var valid_595389 = path.getOrDefault("labName")
  valid_595389 = validateParameter(valid_595389, JString, required = true,
                                 default = nil)
  if valid_595389 != nil:
    section.add "labName", valid_595389
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595390 = query.getOrDefault("api-version")
  valid_595390 = validateParameter(valid_595390, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595390 != nil:
    section.add "api-version", valid_595390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595391: Call_VirtualMachinesTransferDisks_595383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Transfers all data disks attached to the virtual machine to be owned by the current user. This operation can take a while to complete.
  ## 
  let valid = call_595391.validator(path, query, header, formData, body)
  let scheme = call_595391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595391.url(scheme.get, call_595391.host, call_595391.base,
                         call_595391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595391, url, valid)

proc call*(call_595392: Call_VirtualMachinesTransferDisks_595383;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesTransferDisks
  ## Transfers all data disks attached to the virtual machine to be owned by the current user. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595393 = newJObject()
  var query_595394 = newJObject()
  add(path_595393, "resourceGroupName", newJString(resourceGroupName))
  add(query_595394, "api-version", newJString(apiVersion))
  add(path_595393, "name", newJString(name))
  add(path_595393, "subscriptionId", newJString(subscriptionId))
  add(path_595393, "labName", newJString(labName))
  result = call_595392.call(path_595393, query_595394, nil, nil, nil)

var virtualMachinesTransferDisks* = Call_VirtualMachinesTransferDisks_595383(
    name: "virtualMachinesTransferDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/transferDisks",
    validator: validate_VirtualMachinesTransferDisks_595384, base: "",
    url: url_VirtualMachinesTransferDisks_595385, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUnClaim_595395 = ref object of OpenApiRestCall_593437
proc url_VirtualMachinesUnClaim_595397(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/unClaim")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesUnClaim_595396(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Release ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595398 = path.getOrDefault("resourceGroupName")
  valid_595398 = validateParameter(valid_595398, JString, required = true,
                                 default = nil)
  if valid_595398 != nil:
    section.add "resourceGroupName", valid_595398
  var valid_595399 = path.getOrDefault("name")
  valid_595399 = validateParameter(valid_595399, JString, required = true,
                                 default = nil)
  if valid_595399 != nil:
    section.add "name", valid_595399
  var valid_595400 = path.getOrDefault("subscriptionId")
  valid_595400 = validateParameter(valid_595400, JString, required = true,
                                 default = nil)
  if valid_595400 != nil:
    section.add "subscriptionId", valid_595400
  var valid_595401 = path.getOrDefault("labName")
  valid_595401 = validateParameter(valid_595401, JString, required = true,
                                 default = nil)
  if valid_595401 != nil:
    section.add "labName", valid_595401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595402 = query.getOrDefault("api-version")
  valid_595402 = validateParameter(valid_595402, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595402 != nil:
    section.add "api-version", valid_595402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595403: Call_VirtualMachinesUnClaim_595395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Release ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  let valid = call_595403.validator(path, query, header, formData, body)
  let scheme = call_595403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595403.url(scheme.get, call_595403.host, call_595403.base,
                         call_595403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595403, url, valid)

proc call*(call_595404: Call_VirtualMachinesUnClaim_595395;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesUnClaim
  ## Release ownership of an existing virtual machine This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595405 = newJObject()
  var query_595406 = newJObject()
  add(path_595405, "resourceGroupName", newJString(resourceGroupName))
  add(query_595406, "api-version", newJString(apiVersion))
  add(path_595405, "name", newJString(name))
  add(path_595405, "subscriptionId", newJString(subscriptionId))
  add(path_595405, "labName", newJString(labName))
  result = call_595404.call(path_595405, query_595406, nil, nil, nil)

var virtualMachinesUnClaim* = Call_VirtualMachinesUnClaim_595395(
    name: "virtualMachinesUnClaim", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/unClaim",
    validator: validate_VirtualMachinesUnClaim_595396, base: "",
    url: url_VirtualMachinesUnClaim_595397, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesList_595407 = ref object of OpenApiRestCall_593437
proc url_VirtualMachineSchedulesList_595409(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSchedulesList_595408(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a given virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595410 = path.getOrDefault("resourceGroupName")
  valid_595410 = validateParameter(valid_595410, JString, required = true,
                                 default = nil)
  if valid_595410 != nil:
    section.add "resourceGroupName", valid_595410
  var valid_595411 = path.getOrDefault("virtualMachineName")
  valid_595411 = validateParameter(valid_595411, JString, required = true,
                                 default = nil)
  if valid_595411 != nil:
    section.add "virtualMachineName", valid_595411
  var valid_595412 = path.getOrDefault("subscriptionId")
  valid_595412 = validateParameter(valid_595412, JString, required = true,
                                 default = nil)
  if valid_595412 != nil:
    section.add "subscriptionId", valid_595412
  var valid_595413 = path.getOrDefault("labName")
  valid_595413 = validateParameter(valid_595413, JString, required = true,
                                 default = nil)
  if valid_595413 != nil:
    section.add "labName", valid_595413
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_595414 = query.getOrDefault("$orderby")
  valid_595414 = validateParameter(valid_595414, JString, required = false,
                                 default = nil)
  if valid_595414 != nil:
    section.add "$orderby", valid_595414
  var valid_595415 = query.getOrDefault("$expand")
  valid_595415 = validateParameter(valid_595415, JString, required = false,
                                 default = nil)
  if valid_595415 != nil:
    section.add "$expand", valid_595415
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595416 = query.getOrDefault("api-version")
  valid_595416 = validateParameter(valid_595416, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595416 != nil:
    section.add "api-version", valid_595416
  var valid_595417 = query.getOrDefault("$top")
  valid_595417 = validateParameter(valid_595417, JInt, required = false, default = nil)
  if valid_595417 != nil:
    section.add "$top", valid_595417
  var valid_595418 = query.getOrDefault("$filter")
  valid_595418 = validateParameter(valid_595418, JString, required = false,
                                 default = nil)
  if valid_595418 != nil:
    section.add "$filter", valid_595418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595419: Call_VirtualMachineSchedulesList_595407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given virtual machine.
  ## 
  let valid = call_595419.validator(path, query, header, formData, body)
  let scheme = call_595419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595419.url(scheme.get, call_595419.host, call_595419.base,
                         call_595419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595419, url, valid)

proc call*(call_595420: Call_VirtualMachineSchedulesList_595407;
          resourceGroupName: string; virtualMachineName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualMachineSchedulesList
  ## List schedules in a given virtual machine.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_595421 = newJObject()
  var query_595422 = newJObject()
  add(query_595422, "$orderby", newJString(Orderby))
  add(path_595421, "resourceGroupName", newJString(resourceGroupName))
  add(query_595422, "$expand", newJString(Expand))
  add(path_595421, "virtualMachineName", newJString(virtualMachineName))
  add(query_595422, "api-version", newJString(apiVersion))
  add(path_595421, "subscriptionId", newJString(subscriptionId))
  add(query_595422, "$top", newJInt(Top))
  add(path_595421, "labName", newJString(labName))
  add(query_595422, "$filter", newJString(Filter))
  result = call_595420.call(path_595421, query_595422, nil, nil, nil)

var virtualMachineSchedulesList* = Call_VirtualMachineSchedulesList_595407(
    name: "virtualMachineSchedulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules",
    validator: validate_VirtualMachineSchedulesList_595408, base: "",
    url: url_VirtualMachineSchedulesList_595409, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesCreateOrUpdate_595437 = ref object of OpenApiRestCall_593437
proc url_VirtualMachineSchedulesCreateOrUpdate_595439(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSchedulesCreateOrUpdate_595438(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595440 = path.getOrDefault("resourceGroupName")
  valid_595440 = validateParameter(valid_595440, JString, required = true,
                                 default = nil)
  if valid_595440 != nil:
    section.add "resourceGroupName", valid_595440
  var valid_595441 = path.getOrDefault("virtualMachineName")
  valid_595441 = validateParameter(valid_595441, JString, required = true,
                                 default = nil)
  if valid_595441 != nil:
    section.add "virtualMachineName", valid_595441
  var valid_595442 = path.getOrDefault("name")
  valid_595442 = validateParameter(valid_595442, JString, required = true,
                                 default = nil)
  if valid_595442 != nil:
    section.add "name", valid_595442
  var valid_595443 = path.getOrDefault("subscriptionId")
  valid_595443 = validateParameter(valid_595443, JString, required = true,
                                 default = nil)
  if valid_595443 != nil:
    section.add "subscriptionId", valid_595443
  var valid_595444 = path.getOrDefault("labName")
  valid_595444 = validateParameter(valid_595444, JString, required = true,
                                 default = nil)
  if valid_595444 != nil:
    section.add "labName", valid_595444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595445 = query.getOrDefault("api-version")
  valid_595445 = validateParameter(valid_595445, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595445 != nil:
    section.add "api-version", valid_595445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595447: Call_VirtualMachineSchedulesCreateOrUpdate_595437;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_595447.validator(path, query, header, formData, body)
  let scheme = call_595447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595447.url(scheme.get, call_595447.host, call_595447.base,
                         call_595447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595447, url, valid)

proc call*(call_595448: Call_VirtualMachineSchedulesCreateOrUpdate_595437;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; schedule: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachineSchedulesCreateOrUpdate
  ## Create or replace an existing schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_595449 = newJObject()
  var query_595450 = newJObject()
  var body_595451 = newJObject()
  add(path_595449, "resourceGroupName", newJString(resourceGroupName))
  add(query_595450, "api-version", newJString(apiVersion))
  add(path_595449, "virtualMachineName", newJString(virtualMachineName))
  add(path_595449, "name", newJString(name))
  add(path_595449, "subscriptionId", newJString(subscriptionId))
  add(path_595449, "labName", newJString(labName))
  if schedule != nil:
    body_595451 = schedule
  result = call_595448.call(path_595449, query_595450, nil, nil, body_595451)

var virtualMachineSchedulesCreateOrUpdate* = Call_VirtualMachineSchedulesCreateOrUpdate_595437(
    name: "virtualMachineSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesCreateOrUpdate_595438, base: "",
    url: url_VirtualMachineSchedulesCreateOrUpdate_595439, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesGet_595423 = ref object of OpenApiRestCall_593437
proc url_VirtualMachineSchedulesGet_595425(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSchedulesGet_595424(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595426 = path.getOrDefault("resourceGroupName")
  valid_595426 = validateParameter(valid_595426, JString, required = true,
                                 default = nil)
  if valid_595426 != nil:
    section.add "resourceGroupName", valid_595426
  var valid_595427 = path.getOrDefault("virtualMachineName")
  valid_595427 = validateParameter(valid_595427, JString, required = true,
                                 default = nil)
  if valid_595427 != nil:
    section.add "virtualMachineName", valid_595427
  var valid_595428 = path.getOrDefault("name")
  valid_595428 = validateParameter(valid_595428, JString, required = true,
                                 default = nil)
  if valid_595428 != nil:
    section.add "name", valid_595428
  var valid_595429 = path.getOrDefault("subscriptionId")
  valid_595429 = validateParameter(valid_595429, JString, required = true,
                                 default = nil)
  if valid_595429 != nil:
    section.add "subscriptionId", valid_595429
  var valid_595430 = path.getOrDefault("labName")
  valid_595430 = validateParameter(valid_595430, JString, required = true,
                                 default = nil)
  if valid_595430 != nil:
    section.add "labName", valid_595430
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_595431 = query.getOrDefault("$expand")
  valid_595431 = validateParameter(valid_595431, JString, required = false,
                                 default = nil)
  if valid_595431 != nil:
    section.add "$expand", valid_595431
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595432 = query.getOrDefault("api-version")
  valid_595432 = validateParameter(valid_595432, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595432 != nil:
    section.add "api-version", valid_595432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595433: Call_VirtualMachineSchedulesGet_595423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_595433.validator(path, query, header, formData, body)
  let scheme = call_595433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595433.url(scheme.get, call_595433.host, call_595433.base,
                         call_595433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595433, url, valid)

proc call*(call_595434: Call_VirtualMachineSchedulesGet_595423;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachineSchedulesGet
  ## Get schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595435 = newJObject()
  var query_595436 = newJObject()
  add(path_595435, "resourceGroupName", newJString(resourceGroupName))
  add(query_595436, "$expand", newJString(Expand))
  add(path_595435, "virtualMachineName", newJString(virtualMachineName))
  add(path_595435, "name", newJString(name))
  add(query_595436, "api-version", newJString(apiVersion))
  add(path_595435, "subscriptionId", newJString(subscriptionId))
  add(path_595435, "labName", newJString(labName))
  result = call_595434.call(path_595435, query_595436, nil, nil, nil)

var virtualMachineSchedulesGet* = Call_VirtualMachineSchedulesGet_595423(
    name: "virtualMachineSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesGet_595424, base: "",
    url: url_VirtualMachineSchedulesGet_595425, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesUpdate_595465 = ref object of OpenApiRestCall_593437
proc url_VirtualMachineSchedulesUpdate_595467(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSchedulesUpdate_595466(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595468 = path.getOrDefault("resourceGroupName")
  valid_595468 = validateParameter(valid_595468, JString, required = true,
                                 default = nil)
  if valid_595468 != nil:
    section.add "resourceGroupName", valid_595468
  var valid_595469 = path.getOrDefault("virtualMachineName")
  valid_595469 = validateParameter(valid_595469, JString, required = true,
                                 default = nil)
  if valid_595469 != nil:
    section.add "virtualMachineName", valid_595469
  var valid_595470 = path.getOrDefault("name")
  valid_595470 = validateParameter(valid_595470, JString, required = true,
                                 default = nil)
  if valid_595470 != nil:
    section.add "name", valid_595470
  var valid_595471 = path.getOrDefault("subscriptionId")
  valid_595471 = validateParameter(valid_595471, JString, required = true,
                                 default = nil)
  if valid_595471 != nil:
    section.add "subscriptionId", valid_595471
  var valid_595472 = path.getOrDefault("labName")
  valid_595472 = validateParameter(valid_595472, JString, required = true,
                                 default = nil)
  if valid_595472 != nil:
    section.add "labName", valid_595472
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595473 = query.getOrDefault("api-version")
  valid_595473 = validateParameter(valid_595473, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595473 != nil:
    section.add "api-version", valid_595473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595475: Call_VirtualMachineSchedulesUpdate_595465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  let valid = call_595475.validator(path, query, header, formData, body)
  let scheme = call_595475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595475.url(scheme.get, call_595475.host, call_595475.base,
                         call_595475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595475, url, valid)

proc call*(call_595476: Call_VirtualMachineSchedulesUpdate_595465;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; schedule: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachineSchedulesUpdate
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_595477 = newJObject()
  var query_595478 = newJObject()
  var body_595479 = newJObject()
  add(path_595477, "resourceGroupName", newJString(resourceGroupName))
  add(query_595478, "api-version", newJString(apiVersion))
  add(path_595477, "virtualMachineName", newJString(virtualMachineName))
  add(path_595477, "name", newJString(name))
  add(path_595477, "subscriptionId", newJString(subscriptionId))
  add(path_595477, "labName", newJString(labName))
  if schedule != nil:
    body_595479 = schedule
  result = call_595476.call(path_595477, query_595478, nil, nil, body_595479)

var virtualMachineSchedulesUpdate* = Call_VirtualMachineSchedulesUpdate_595465(
    name: "virtualMachineSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesUpdate_595466, base: "",
    url: url_VirtualMachineSchedulesUpdate_595467, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesDelete_595452 = ref object of OpenApiRestCall_593437
proc url_VirtualMachineSchedulesDelete_595454(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSchedulesDelete_595453(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595455 = path.getOrDefault("resourceGroupName")
  valid_595455 = validateParameter(valid_595455, JString, required = true,
                                 default = nil)
  if valid_595455 != nil:
    section.add "resourceGroupName", valid_595455
  var valid_595456 = path.getOrDefault("virtualMachineName")
  valid_595456 = validateParameter(valid_595456, JString, required = true,
                                 default = nil)
  if valid_595456 != nil:
    section.add "virtualMachineName", valid_595456
  var valid_595457 = path.getOrDefault("name")
  valid_595457 = validateParameter(valid_595457, JString, required = true,
                                 default = nil)
  if valid_595457 != nil:
    section.add "name", valid_595457
  var valid_595458 = path.getOrDefault("subscriptionId")
  valid_595458 = validateParameter(valid_595458, JString, required = true,
                                 default = nil)
  if valid_595458 != nil:
    section.add "subscriptionId", valid_595458
  var valid_595459 = path.getOrDefault("labName")
  valid_595459 = validateParameter(valid_595459, JString, required = true,
                                 default = nil)
  if valid_595459 != nil:
    section.add "labName", valid_595459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595460 = query.getOrDefault("api-version")
  valid_595460 = validateParameter(valid_595460, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595460 != nil:
    section.add "api-version", valid_595460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595461: Call_VirtualMachineSchedulesDelete_595452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_595461.validator(path, query, header, formData, body)
  let scheme = call_595461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595461.url(scheme.get, call_595461.host, call_595461.base,
                         call_595461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595461, url, valid)

proc call*(call_595462: Call_VirtualMachineSchedulesDelete_595452;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachineSchedulesDelete
  ## Delete schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595463 = newJObject()
  var query_595464 = newJObject()
  add(path_595463, "resourceGroupName", newJString(resourceGroupName))
  add(query_595464, "api-version", newJString(apiVersion))
  add(path_595463, "virtualMachineName", newJString(virtualMachineName))
  add(path_595463, "name", newJString(name))
  add(path_595463, "subscriptionId", newJString(subscriptionId))
  add(path_595463, "labName", newJString(labName))
  result = call_595462.call(path_595463, query_595464, nil, nil, nil)

var virtualMachineSchedulesDelete* = Call_VirtualMachineSchedulesDelete_595452(
    name: "virtualMachineSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesDelete_595453, base: "",
    url: url_VirtualMachineSchedulesDelete_595454, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesExecute_595480 = ref object of OpenApiRestCall_593437
proc url_VirtualMachineSchedulesExecute_595482(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSchedulesExecute_595481(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595483 = path.getOrDefault("resourceGroupName")
  valid_595483 = validateParameter(valid_595483, JString, required = true,
                                 default = nil)
  if valid_595483 != nil:
    section.add "resourceGroupName", valid_595483
  var valid_595484 = path.getOrDefault("virtualMachineName")
  valid_595484 = validateParameter(valid_595484, JString, required = true,
                                 default = nil)
  if valid_595484 != nil:
    section.add "virtualMachineName", valid_595484
  var valid_595485 = path.getOrDefault("name")
  valid_595485 = validateParameter(valid_595485, JString, required = true,
                                 default = nil)
  if valid_595485 != nil:
    section.add "name", valid_595485
  var valid_595486 = path.getOrDefault("subscriptionId")
  valid_595486 = validateParameter(valid_595486, JString, required = true,
                                 default = nil)
  if valid_595486 != nil:
    section.add "subscriptionId", valid_595486
  var valid_595487 = path.getOrDefault("labName")
  valid_595487 = validateParameter(valid_595487, JString, required = true,
                                 default = nil)
  if valid_595487 != nil:
    section.add "labName", valid_595487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595488 = query.getOrDefault("api-version")
  valid_595488 = validateParameter(valid_595488, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595488 != nil:
    section.add "api-version", valid_595488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595489: Call_VirtualMachineSchedulesExecute_595480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_595489.validator(path, query, header, formData, body)
  let scheme = call_595489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595489.url(scheme.get, call_595489.host, call_595489.base,
                         call_595489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595489, url, valid)

proc call*(call_595490: Call_VirtualMachineSchedulesExecute_595480;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachineSchedulesExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595491 = newJObject()
  var query_595492 = newJObject()
  add(path_595491, "resourceGroupName", newJString(resourceGroupName))
  add(query_595492, "api-version", newJString(apiVersion))
  add(path_595491, "virtualMachineName", newJString(virtualMachineName))
  add(path_595491, "name", newJString(name))
  add(path_595491, "subscriptionId", newJString(subscriptionId))
  add(path_595491, "labName", newJString(labName))
  result = call_595490.call(path_595491, query_595492, nil, nil, nil)

var virtualMachineSchedulesExecute* = Call_VirtualMachineSchedulesExecute_595480(
    name: "virtualMachineSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}/execute",
    validator: validate_VirtualMachineSchedulesExecute_595481, base: "",
    url: url_VirtualMachineSchedulesExecute_595482, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_595493 = ref object of OpenApiRestCall_593437
proc url_VirtualNetworksList_595495(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksList_595494(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List virtual networks in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595496 = path.getOrDefault("resourceGroupName")
  valid_595496 = validateParameter(valid_595496, JString, required = true,
                                 default = nil)
  if valid_595496 != nil:
    section.add "resourceGroupName", valid_595496
  var valid_595497 = path.getOrDefault("subscriptionId")
  valid_595497 = validateParameter(valid_595497, JString, required = true,
                                 default = nil)
  if valid_595497 != nil:
    section.add "subscriptionId", valid_595497
  var valid_595498 = path.getOrDefault("labName")
  valid_595498 = validateParameter(valid_595498, JString, required = true,
                                 default = nil)
  if valid_595498 != nil:
    section.add "labName", valid_595498
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_595499 = query.getOrDefault("$orderby")
  valid_595499 = validateParameter(valid_595499, JString, required = false,
                                 default = nil)
  if valid_595499 != nil:
    section.add "$orderby", valid_595499
  var valid_595500 = query.getOrDefault("$expand")
  valid_595500 = validateParameter(valid_595500, JString, required = false,
                                 default = nil)
  if valid_595500 != nil:
    section.add "$expand", valid_595500
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595501 = query.getOrDefault("api-version")
  valid_595501 = validateParameter(valid_595501, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595501 != nil:
    section.add "api-version", valid_595501
  var valid_595502 = query.getOrDefault("$top")
  valid_595502 = validateParameter(valid_595502, JInt, required = false, default = nil)
  if valid_595502 != nil:
    section.add "$top", valid_595502
  var valid_595503 = query.getOrDefault("$filter")
  valid_595503 = validateParameter(valid_595503, JString, required = false,
                                 default = nil)
  if valid_595503 != nil:
    section.add "$filter", valid_595503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595504: Call_VirtualNetworksList_595493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual networks in a given lab.
  ## 
  let valid = call_595504.validator(path, query, header, formData, body)
  let scheme = call_595504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595504.url(scheme.get, call_595504.host, call_595504.base,
                         call_595504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595504, url, valid)

proc call*(call_595505: Call_VirtualNetworksList_595493; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualNetworksList
  ## List virtual networks in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_595506 = newJObject()
  var query_595507 = newJObject()
  add(query_595507, "$orderby", newJString(Orderby))
  add(path_595506, "resourceGroupName", newJString(resourceGroupName))
  add(query_595507, "$expand", newJString(Expand))
  add(query_595507, "api-version", newJString(apiVersion))
  add(path_595506, "subscriptionId", newJString(subscriptionId))
  add(query_595507, "$top", newJInt(Top))
  add(path_595506, "labName", newJString(labName))
  add(query_595507, "$filter", newJString(Filter))
  result = call_595505.call(path_595506, query_595507, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_595493(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks",
    validator: validate_VirtualNetworksList_595494, base: "",
    url: url_VirtualNetworksList_595495, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_595521 = ref object of OpenApiRestCall_593437
proc url_VirtualNetworksCreateOrUpdate_595523(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksCreateOrUpdate_595522(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595524 = path.getOrDefault("resourceGroupName")
  valid_595524 = validateParameter(valid_595524, JString, required = true,
                                 default = nil)
  if valid_595524 != nil:
    section.add "resourceGroupName", valid_595524
  var valid_595525 = path.getOrDefault("name")
  valid_595525 = validateParameter(valid_595525, JString, required = true,
                                 default = nil)
  if valid_595525 != nil:
    section.add "name", valid_595525
  var valid_595526 = path.getOrDefault("subscriptionId")
  valid_595526 = validateParameter(valid_595526, JString, required = true,
                                 default = nil)
  if valid_595526 != nil:
    section.add "subscriptionId", valid_595526
  var valid_595527 = path.getOrDefault("labName")
  valid_595527 = validateParameter(valid_595527, JString, required = true,
                                 default = nil)
  if valid_595527 != nil:
    section.add "labName", valid_595527
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595528 = query.getOrDefault("api-version")
  valid_595528 = validateParameter(valid_595528, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595528 != nil:
    section.add "api-version", valid_595528
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   virtualNetwork: JObject (required)
  ##                 : A virtual network.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595530: Call_VirtualNetworksCreateOrUpdate_595521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  let valid = call_595530.validator(path, query, header, formData, body)
  let scheme = call_595530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595530.url(scheme.get, call_595530.host, call_595530.base,
                         call_595530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595530, url, valid)

proc call*(call_595531: Call_VirtualNetworksCreateOrUpdate_595521;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualNetworksCreateOrUpdate
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   virtualNetwork: JObject (required)
  ##                 : A virtual network.
  var path_595532 = newJObject()
  var query_595533 = newJObject()
  var body_595534 = newJObject()
  add(path_595532, "resourceGroupName", newJString(resourceGroupName))
  add(query_595533, "api-version", newJString(apiVersion))
  add(path_595532, "name", newJString(name))
  add(path_595532, "subscriptionId", newJString(subscriptionId))
  add(path_595532, "labName", newJString(labName))
  if virtualNetwork != nil:
    body_595534 = virtualNetwork
  result = call_595531.call(path_595532, query_595533, nil, nil, body_595534)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_595521(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksCreateOrUpdate_595522, base: "",
    url: url_VirtualNetworksCreateOrUpdate_595523, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_595508 = ref object of OpenApiRestCall_593437
proc url_VirtualNetworksGet_595510(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksGet_595509(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595511 = path.getOrDefault("resourceGroupName")
  valid_595511 = validateParameter(valid_595511, JString, required = true,
                                 default = nil)
  if valid_595511 != nil:
    section.add "resourceGroupName", valid_595511
  var valid_595512 = path.getOrDefault("name")
  valid_595512 = validateParameter(valid_595512, JString, required = true,
                                 default = nil)
  if valid_595512 != nil:
    section.add "name", valid_595512
  var valid_595513 = path.getOrDefault("subscriptionId")
  valid_595513 = validateParameter(valid_595513, JString, required = true,
                                 default = nil)
  if valid_595513 != nil:
    section.add "subscriptionId", valid_595513
  var valid_595514 = path.getOrDefault("labName")
  valid_595514 = validateParameter(valid_595514, JString, required = true,
                                 default = nil)
  if valid_595514 != nil:
    section.add "labName", valid_595514
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_595515 = query.getOrDefault("$expand")
  valid_595515 = validateParameter(valid_595515, JString, required = false,
                                 default = nil)
  if valid_595515 != nil:
    section.add "$expand", valid_595515
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595516 = query.getOrDefault("api-version")
  valid_595516 = validateParameter(valid_595516, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595516 != nil:
    section.add "api-version", valid_595516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595517: Call_VirtualNetworksGet_595508; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual network.
  ## 
  let valid = call_595517.validator(path, query, header, formData, body)
  let scheme = call_595517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595517.url(scheme.get, call_595517.host, call_595517.base,
                         call_595517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595517, url, valid)

proc call*(call_595518: Call_VirtualNetworksGet_595508; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualNetworksGet
  ## Get virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595519 = newJObject()
  var query_595520 = newJObject()
  add(path_595519, "resourceGroupName", newJString(resourceGroupName))
  add(query_595520, "$expand", newJString(Expand))
  add(path_595519, "name", newJString(name))
  add(query_595520, "api-version", newJString(apiVersion))
  add(path_595519, "subscriptionId", newJString(subscriptionId))
  add(path_595519, "labName", newJString(labName))
  result = call_595518.call(path_595519, query_595520, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_595508(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksGet_595509, base: "",
    url: url_VirtualNetworksGet_595510, schemes: {Scheme.Https})
type
  Call_VirtualNetworksUpdate_595547 = ref object of OpenApiRestCall_593437
proc url_VirtualNetworksUpdate_595549(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksUpdate_595548(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of virtual networks. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595550 = path.getOrDefault("resourceGroupName")
  valid_595550 = validateParameter(valid_595550, JString, required = true,
                                 default = nil)
  if valid_595550 != nil:
    section.add "resourceGroupName", valid_595550
  var valid_595551 = path.getOrDefault("name")
  valid_595551 = validateParameter(valid_595551, JString, required = true,
                                 default = nil)
  if valid_595551 != nil:
    section.add "name", valid_595551
  var valid_595552 = path.getOrDefault("subscriptionId")
  valid_595552 = validateParameter(valid_595552, JString, required = true,
                                 default = nil)
  if valid_595552 != nil:
    section.add "subscriptionId", valid_595552
  var valid_595553 = path.getOrDefault("labName")
  valid_595553 = validateParameter(valid_595553, JString, required = true,
                                 default = nil)
  if valid_595553 != nil:
    section.add "labName", valid_595553
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595554 = query.getOrDefault("api-version")
  valid_595554 = validateParameter(valid_595554, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595554 != nil:
    section.add "api-version", valid_595554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   virtualNetwork: JObject (required)
  ##                 : A virtual network.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595556: Call_VirtualNetworksUpdate_595547; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of virtual networks. All other properties will be ignored.
  ## 
  let valid = call_595556.validator(path, query, header, formData, body)
  let scheme = call_595556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595556.url(scheme.get, call_595556.host, call_595556.base,
                         call_595556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595556, url, valid)

proc call*(call_595557: Call_VirtualNetworksUpdate_595547;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualNetworksUpdate
  ## Allows modifying tags of virtual networks. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   virtualNetwork: JObject (required)
  ##                 : A virtual network.
  var path_595558 = newJObject()
  var query_595559 = newJObject()
  var body_595560 = newJObject()
  add(path_595558, "resourceGroupName", newJString(resourceGroupName))
  add(query_595559, "api-version", newJString(apiVersion))
  add(path_595558, "name", newJString(name))
  add(path_595558, "subscriptionId", newJString(subscriptionId))
  add(path_595558, "labName", newJString(labName))
  if virtualNetwork != nil:
    body_595560 = virtualNetwork
  result = call_595557.call(path_595558, query_595559, nil, nil, body_595560)

var virtualNetworksUpdate* = Call_VirtualNetworksUpdate_595547(
    name: "virtualNetworksUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksUpdate_595548, base: "",
    url: url_VirtualNetworksUpdate_595549, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_595535 = ref object of OpenApiRestCall_593437
proc url_VirtualNetworksDelete_595537(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksDelete_595536(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595538 = path.getOrDefault("resourceGroupName")
  valid_595538 = validateParameter(valid_595538, JString, required = true,
                                 default = nil)
  if valid_595538 != nil:
    section.add "resourceGroupName", valid_595538
  var valid_595539 = path.getOrDefault("name")
  valid_595539 = validateParameter(valid_595539, JString, required = true,
                                 default = nil)
  if valid_595539 != nil:
    section.add "name", valid_595539
  var valid_595540 = path.getOrDefault("subscriptionId")
  valid_595540 = validateParameter(valid_595540, JString, required = true,
                                 default = nil)
  if valid_595540 != nil:
    section.add "subscriptionId", valid_595540
  var valid_595541 = path.getOrDefault("labName")
  valid_595541 = validateParameter(valid_595541, JString, required = true,
                                 default = nil)
  if valid_595541 != nil:
    section.add "labName", valid_595541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595542 = query.getOrDefault("api-version")
  valid_595542 = validateParameter(valid_595542, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595542 != nil:
    section.add "api-version", valid_595542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595543: Call_VirtualNetworksDelete_595535; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  let valid = call_595543.validator(path, query, header, formData, body)
  let scheme = call_595543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595543.url(scheme.get, call_595543.host, call_595543.base,
                         call_595543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595543, url, valid)

proc call*(call_595544: Call_VirtualNetworksDelete_595535;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualNetworksDelete
  ## Delete virtual network. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_595545 = newJObject()
  var query_595546 = newJObject()
  add(path_595545, "resourceGroupName", newJString(resourceGroupName))
  add(query_595546, "api-version", newJString(apiVersion))
  add(path_595545, "name", newJString(name))
  add(path_595545, "subscriptionId", newJString(subscriptionId))
  add(path_595545, "labName", newJString(labName))
  result = call_595544.call(path_595545, query_595546, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_595535(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksDelete_595536, base: "",
    url: url_VirtualNetworksDelete_595537, schemes: {Scheme.Https})
type
  Call_LabsCreateOrUpdate_595573 = ref object of OpenApiRestCall_593437
proc url_LabsCreateOrUpdate_595575(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsCreateOrUpdate_595574(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Create or replace an existing lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595576 = path.getOrDefault("resourceGroupName")
  valid_595576 = validateParameter(valid_595576, JString, required = true,
                                 default = nil)
  if valid_595576 != nil:
    section.add "resourceGroupName", valid_595576
  var valid_595577 = path.getOrDefault("name")
  valid_595577 = validateParameter(valid_595577, JString, required = true,
                                 default = nil)
  if valid_595577 != nil:
    section.add "name", valid_595577
  var valid_595578 = path.getOrDefault("subscriptionId")
  valid_595578 = validateParameter(valid_595578, JString, required = true,
                                 default = nil)
  if valid_595578 != nil:
    section.add "subscriptionId", valid_595578
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595579 = query.getOrDefault("api-version")
  valid_595579 = validateParameter(valid_595579, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595579 != nil:
    section.add "api-version", valid_595579
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   lab: JObject (required)
  ##      : A lab.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595581: Call_LabsCreateOrUpdate_595573; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing lab. This operation can take a while to complete.
  ## 
  let valid = call_595581.validator(path, query, header, formData, body)
  let scheme = call_595581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595581.url(scheme.get, call_595581.host, call_595581.base,
                         call_595581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595581, url, valid)

proc call*(call_595582: Call_LabsCreateOrUpdate_595573; resourceGroupName: string;
          name: string; subscriptionId: string; lab: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## labsCreateOrUpdate
  ## Create or replace an existing lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   lab: JObject (required)
  ##      : A lab.
  var path_595583 = newJObject()
  var query_595584 = newJObject()
  var body_595585 = newJObject()
  add(path_595583, "resourceGroupName", newJString(resourceGroupName))
  add(query_595584, "api-version", newJString(apiVersion))
  add(path_595583, "name", newJString(name))
  add(path_595583, "subscriptionId", newJString(subscriptionId))
  if lab != nil:
    body_595585 = lab
  result = call_595582.call(path_595583, query_595584, nil, nil, body_595585)

var labsCreateOrUpdate* = Call_LabsCreateOrUpdate_595573(
    name: "labsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabsCreateOrUpdate_595574, base: "",
    url: url_LabsCreateOrUpdate_595575, schemes: {Scheme.Https})
type
  Call_LabsGet_595561 = ref object of OpenApiRestCall_593437
proc url_LabsGet_595563(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsGet_595562(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Get lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595564 = path.getOrDefault("resourceGroupName")
  valid_595564 = validateParameter(valid_595564, JString, required = true,
                                 default = nil)
  if valid_595564 != nil:
    section.add "resourceGroupName", valid_595564
  var valid_595565 = path.getOrDefault("name")
  valid_595565 = validateParameter(valid_595565, JString, required = true,
                                 default = nil)
  if valid_595565 != nil:
    section.add "name", valid_595565
  var valid_595566 = path.getOrDefault("subscriptionId")
  valid_595566 = validateParameter(valid_595566, JString, required = true,
                                 default = nil)
  if valid_595566 != nil:
    section.add "subscriptionId", valid_595566
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_595567 = query.getOrDefault("$expand")
  valid_595567 = validateParameter(valid_595567, JString, required = false,
                                 default = nil)
  if valid_595567 != nil:
    section.add "$expand", valid_595567
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595568 = query.getOrDefault("api-version")
  valid_595568 = validateParameter(valid_595568, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595568 != nil:
    section.add "api-version", valid_595568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595569: Call_LabsGet_595561; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab.
  ## 
  let valid = call_595569.validator(path, query, header, formData, body)
  let scheme = call_595569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595569.url(scheme.get, call_595569.host, call_595569.base,
                         call_595569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595569, url, valid)

proc call*(call_595570: Call_LabsGet_595561; resourceGroupName: string; name: string;
          subscriptionId: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
  ## labsGet
  ## Get lab.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   name: string (required)
  ##       : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_595571 = newJObject()
  var query_595572 = newJObject()
  add(path_595571, "resourceGroupName", newJString(resourceGroupName))
  add(query_595572, "$expand", newJString(Expand))
  add(path_595571, "name", newJString(name))
  add(query_595572, "api-version", newJString(apiVersion))
  add(path_595571, "subscriptionId", newJString(subscriptionId))
  result = call_595570.call(path_595571, query_595572, nil, nil, nil)

var labsGet* = Call_LabsGet_595561(name: "labsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                validator: validate_LabsGet_595562, base: "",
                                url: url_LabsGet_595563, schemes: {Scheme.Https})
type
  Call_LabsUpdate_595597 = ref object of OpenApiRestCall_593437
proc url_LabsUpdate_595599(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsUpdate_595598(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of labs. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595600 = path.getOrDefault("resourceGroupName")
  valid_595600 = validateParameter(valid_595600, JString, required = true,
                                 default = nil)
  if valid_595600 != nil:
    section.add "resourceGroupName", valid_595600
  var valid_595601 = path.getOrDefault("name")
  valid_595601 = validateParameter(valid_595601, JString, required = true,
                                 default = nil)
  if valid_595601 != nil:
    section.add "name", valid_595601
  var valid_595602 = path.getOrDefault("subscriptionId")
  valid_595602 = validateParameter(valid_595602, JString, required = true,
                                 default = nil)
  if valid_595602 != nil:
    section.add "subscriptionId", valid_595602
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595603 = query.getOrDefault("api-version")
  valid_595603 = validateParameter(valid_595603, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595603 != nil:
    section.add "api-version", valid_595603
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   lab: JObject (required)
  ##      : A lab.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595605: Call_LabsUpdate_595597; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of labs. All other properties will be ignored.
  ## 
  let valid = call_595605.validator(path, query, header, formData, body)
  let scheme = call_595605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595605.url(scheme.get, call_595605.host, call_595605.base,
                         call_595605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595605, url, valid)

proc call*(call_595606: Call_LabsUpdate_595597; resourceGroupName: string;
          name: string; subscriptionId: string; lab: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## labsUpdate
  ## Allows modifying tags of labs. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   lab: JObject (required)
  ##      : A lab.
  var path_595607 = newJObject()
  var query_595608 = newJObject()
  var body_595609 = newJObject()
  add(path_595607, "resourceGroupName", newJString(resourceGroupName))
  add(query_595608, "api-version", newJString(apiVersion))
  add(path_595607, "name", newJString(name))
  add(path_595607, "subscriptionId", newJString(subscriptionId))
  if lab != nil:
    body_595609 = lab
  result = call_595606.call(path_595607, query_595608, nil, nil, body_595609)

var labsUpdate* = Call_LabsUpdate_595597(name: "labsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                      validator: validate_LabsUpdate_595598,
                                      base: "", url: url_LabsUpdate_595599,
                                      schemes: {Scheme.Https})
type
  Call_LabsDelete_595586 = ref object of OpenApiRestCall_593437
proc url_LabsDelete_595588(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsDelete_595587(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595589 = path.getOrDefault("resourceGroupName")
  valid_595589 = validateParameter(valid_595589, JString, required = true,
                                 default = nil)
  if valid_595589 != nil:
    section.add "resourceGroupName", valid_595589
  var valid_595590 = path.getOrDefault("name")
  valid_595590 = validateParameter(valid_595590, JString, required = true,
                                 default = nil)
  if valid_595590 != nil:
    section.add "name", valid_595590
  var valid_595591 = path.getOrDefault("subscriptionId")
  valid_595591 = validateParameter(valid_595591, JString, required = true,
                                 default = nil)
  if valid_595591 != nil:
    section.add "subscriptionId", valid_595591
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595592 = query.getOrDefault("api-version")
  valid_595592 = validateParameter(valid_595592, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595592 != nil:
    section.add "api-version", valid_595592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595593: Call_LabsDelete_595586; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab. This operation can take a while to complete.
  ## 
  let valid = call_595593.validator(path, query, header, formData, body)
  let scheme = call_595593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595593.url(scheme.get, call_595593.host, call_595593.base,
                         call_595593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595593, url, valid)

proc call*(call_595594: Call_LabsDelete_595586; resourceGroupName: string;
          name: string; subscriptionId: string; apiVersion: string = "2018-09-15"): Recallable =
  ## labsDelete
  ## Delete lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_595595 = newJObject()
  var query_595596 = newJObject()
  add(path_595595, "resourceGroupName", newJString(resourceGroupName))
  add(query_595596, "api-version", newJString(apiVersion))
  add(path_595595, "name", newJString(name))
  add(path_595595, "subscriptionId", newJString(subscriptionId))
  result = call_595594.call(path_595595, query_595596, nil, nil, nil)

var labsDelete* = Call_LabsDelete_595586(name: "labsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                      validator: validate_LabsDelete_595587,
                                      base: "", url: url_LabsDelete_595588,
                                      schemes: {Scheme.Https})
type
  Call_LabsClaimAnyVm_595610 = ref object of OpenApiRestCall_593437
proc url_LabsClaimAnyVm_595612(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/claimAnyVm")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsClaimAnyVm_595611(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Claim a random claimable virtual machine in the lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595613 = path.getOrDefault("resourceGroupName")
  valid_595613 = validateParameter(valid_595613, JString, required = true,
                                 default = nil)
  if valid_595613 != nil:
    section.add "resourceGroupName", valid_595613
  var valid_595614 = path.getOrDefault("name")
  valid_595614 = validateParameter(valid_595614, JString, required = true,
                                 default = nil)
  if valid_595614 != nil:
    section.add "name", valid_595614
  var valid_595615 = path.getOrDefault("subscriptionId")
  valid_595615 = validateParameter(valid_595615, JString, required = true,
                                 default = nil)
  if valid_595615 != nil:
    section.add "subscriptionId", valid_595615
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595616 = query.getOrDefault("api-version")
  valid_595616 = validateParameter(valid_595616, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595616 != nil:
    section.add "api-version", valid_595616
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595617: Call_LabsClaimAnyVm_595610; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claim a random claimable virtual machine in the lab. This operation can take a while to complete.
  ## 
  let valid = call_595617.validator(path, query, header, formData, body)
  let scheme = call_595617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595617.url(scheme.get, call_595617.host, call_595617.base,
                         call_595617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595617, url, valid)

proc call*(call_595618: Call_LabsClaimAnyVm_595610; resourceGroupName: string;
          name: string; subscriptionId: string; apiVersion: string = "2018-09-15"): Recallable =
  ## labsClaimAnyVm
  ## Claim a random claimable virtual machine in the lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_595619 = newJObject()
  var query_595620 = newJObject()
  add(path_595619, "resourceGroupName", newJString(resourceGroupName))
  add(query_595620, "api-version", newJString(apiVersion))
  add(path_595619, "name", newJString(name))
  add(path_595619, "subscriptionId", newJString(subscriptionId))
  result = call_595618.call(path_595619, query_595620, nil, nil, nil)

var labsClaimAnyVm* = Call_LabsClaimAnyVm_595610(name: "labsClaimAnyVm",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/claimAnyVm",
    validator: validate_LabsClaimAnyVm_595611, base: "", url: url_LabsClaimAnyVm_595612,
    schemes: {Scheme.Https})
type
  Call_LabsCreateEnvironment_595621 = ref object of OpenApiRestCall_593437
proc url_LabsCreateEnvironment_595623(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/createEnvironment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsCreateEnvironment_595622(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create virtual machines in a lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595624 = path.getOrDefault("resourceGroupName")
  valid_595624 = validateParameter(valid_595624, JString, required = true,
                                 default = nil)
  if valid_595624 != nil:
    section.add "resourceGroupName", valid_595624
  var valid_595625 = path.getOrDefault("name")
  valid_595625 = validateParameter(valid_595625, JString, required = true,
                                 default = nil)
  if valid_595625 != nil:
    section.add "name", valid_595625
  var valid_595626 = path.getOrDefault("subscriptionId")
  valid_595626 = validateParameter(valid_595626, JString, required = true,
                                 default = nil)
  if valid_595626 != nil:
    section.add "subscriptionId", valid_595626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595627 = query.getOrDefault("api-version")
  valid_595627 = validateParameter(valid_595627, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595627 != nil:
    section.add "api-version", valid_595627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labVirtualMachineCreationParameter: JObject (required)
  ##                                     : Properties for creating a virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595629: Call_LabsCreateEnvironment_595621; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create virtual machines in a lab. This operation can take a while to complete.
  ## 
  let valid = call_595629.validator(path, query, header, formData, body)
  let scheme = call_595629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595629.url(scheme.get, call_595629.host, call_595629.base,
                         call_595629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595629, url, valid)

proc call*(call_595630: Call_LabsCreateEnvironment_595621;
          resourceGroupName: string; name: string;
          labVirtualMachineCreationParameter: JsonNode; subscriptionId: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## labsCreateEnvironment
  ## Create virtual machines in a lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   labVirtualMachineCreationParameter: JObject (required)
  ##                                     : Properties for creating a virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_595631 = newJObject()
  var query_595632 = newJObject()
  var body_595633 = newJObject()
  add(path_595631, "resourceGroupName", newJString(resourceGroupName))
  add(query_595632, "api-version", newJString(apiVersion))
  add(path_595631, "name", newJString(name))
  if labVirtualMachineCreationParameter != nil:
    body_595633 = labVirtualMachineCreationParameter
  add(path_595631, "subscriptionId", newJString(subscriptionId))
  result = call_595630.call(path_595631, query_595632, nil, nil, body_595633)

var labsCreateEnvironment* = Call_LabsCreateEnvironment_595621(
    name: "labsCreateEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/createEnvironment",
    validator: validate_LabsCreateEnvironment_595622, base: "",
    url: url_LabsCreateEnvironment_595623, schemes: {Scheme.Https})
type
  Call_LabsExportResourceUsage_595634 = ref object of OpenApiRestCall_593437
proc url_LabsExportResourceUsage_595636(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/exportResourceUsage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsExportResourceUsage_595635(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the lab resource usage into a storage account This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595637 = path.getOrDefault("resourceGroupName")
  valid_595637 = validateParameter(valid_595637, JString, required = true,
                                 default = nil)
  if valid_595637 != nil:
    section.add "resourceGroupName", valid_595637
  var valid_595638 = path.getOrDefault("name")
  valid_595638 = validateParameter(valid_595638, JString, required = true,
                                 default = nil)
  if valid_595638 != nil:
    section.add "name", valid_595638
  var valid_595639 = path.getOrDefault("subscriptionId")
  valid_595639 = validateParameter(valid_595639, JString, required = true,
                                 default = nil)
  if valid_595639 != nil:
    section.add "subscriptionId", valid_595639
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595640 = query.getOrDefault("api-version")
  valid_595640 = validateParameter(valid_595640, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595640 != nil:
    section.add "api-version", valid_595640
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   exportResourceUsageParameters: JObject (required)
  ##                                : The parameters of the export operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595642: Call_LabsExportResourceUsage_595634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the lab resource usage into a storage account This operation can take a while to complete.
  ## 
  let valid = call_595642.validator(path, query, header, formData, body)
  let scheme = call_595642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595642.url(scheme.get, call_595642.host, call_595642.base,
                         call_595642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595642, url, valid)

proc call*(call_595643: Call_LabsExportResourceUsage_595634;
          resourceGroupName: string; name: string; subscriptionId: string;
          exportResourceUsageParameters: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## labsExportResourceUsage
  ## Exports the lab resource usage into a storage account This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   exportResourceUsageParameters: JObject (required)
  ##                                : The parameters of the export operation.
  var path_595644 = newJObject()
  var query_595645 = newJObject()
  var body_595646 = newJObject()
  add(path_595644, "resourceGroupName", newJString(resourceGroupName))
  add(query_595645, "api-version", newJString(apiVersion))
  add(path_595644, "name", newJString(name))
  add(path_595644, "subscriptionId", newJString(subscriptionId))
  if exportResourceUsageParameters != nil:
    body_595646 = exportResourceUsageParameters
  result = call_595643.call(path_595644, query_595645, nil, nil, body_595646)

var labsExportResourceUsage* = Call_LabsExportResourceUsage_595634(
    name: "labsExportResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/exportResourceUsage",
    validator: validate_LabsExportResourceUsage_595635, base: "",
    url: url_LabsExportResourceUsage_595636, schemes: {Scheme.Https})
type
  Call_LabsGenerateUploadUri_595647 = ref object of OpenApiRestCall_593437
proc url_LabsGenerateUploadUri_595649(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/generateUploadUri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsGenerateUploadUri_595648(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595650 = path.getOrDefault("resourceGroupName")
  valid_595650 = validateParameter(valid_595650, JString, required = true,
                                 default = nil)
  if valid_595650 != nil:
    section.add "resourceGroupName", valid_595650
  var valid_595651 = path.getOrDefault("name")
  valid_595651 = validateParameter(valid_595651, JString, required = true,
                                 default = nil)
  if valid_595651 != nil:
    section.add "name", valid_595651
  var valid_595652 = path.getOrDefault("subscriptionId")
  valid_595652 = validateParameter(valid_595652, JString, required = true,
                                 default = nil)
  if valid_595652 != nil:
    section.add "subscriptionId", valid_595652
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595653 = query.getOrDefault("api-version")
  valid_595653 = validateParameter(valid_595653, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595653 != nil:
    section.add "api-version", valid_595653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   generateUploadUriParameter: JObject (required)
  ##                             : Properties for generating an upload URI.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595655: Call_LabsGenerateUploadUri_595647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  let valid = call_595655.validator(path, query, header, formData, body)
  let scheme = call_595655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595655.url(scheme.get, call_595655.host, call_595655.base,
                         call_595655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595655, url, valid)

proc call*(call_595656: Call_LabsGenerateUploadUri_595647;
          resourceGroupName: string; name: string; subscriptionId: string;
          generateUploadUriParameter: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## labsGenerateUploadUri
  ## Generate a URI for uploading custom disk images to a Lab.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   generateUploadUriParameter: JObject (required)
  ##                             : Properties for generating an upload URI.
  var path_595657 = newJObject()
  var query_595658 = newJObject()
  var body_595659 = newJObject()
  add(path_595657, "resourceGroupName", newJString(resourceGroupName))
  add(query_595658, "api-version", newJString(apiVersion))
  add(path_595657, "name", newJString(name))
  add(path_595657, "subscriptionId", newJString(subscriptionId))
  if generateUploadUriParameter != nil:
    body_595659 = generateUploadUriParameter
  result = call_595656.call(path_595657, query_595658, nil, nil, body_595659)

var labsGenerateUploadUri* = Call_LabsGenerateUploadUri_595647(
    name: "labsGenerateUploadUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/generateUploadUri",
    validator: validate_LabsGenerateUploadUri_595648, base: "",
    url: url_LabsGenerateUploadUri_595649, schemes: {Scheme.Https})
type
  Call_LabsImportVirtualMachine_595660 = ref object of OpenApiRestCall_593437
proc url_LabsImportVirtualMachine_595662(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/importVirtualMachine")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsImportVirtualMachine_595661(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Import a virtual machine into a different lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595663 = path.getOrDefault("resourceGroupName")
  valid_595663 = validateParameter(valid_595663, JString, required = true,
                                 default = nil)
  if valid_595663 != nil:
    section.add "resourceGroupName", valid_595663
  var valid_595664 = path.getOrDefault("name")
  valid_595664 = validateParameter(valid_595664, JString, required = true,
                                 default = nil)
  if valid_595664 != nil:
    section.add "name", valid_595664
  var valid_595665 = path.getOrDefault("subscriptionId")
  valid_595665 = validateParameter(valid_595665, JString, required = true,
                                 default = nil)
  if valid_595665 != nil:
    section.add "subscriptionId", valid_595665
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595666 = query.getOrDefault("api-version")
  valid_595666 = validateParameter(valid_595666, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595666 != nil:
    section.add "api-version", valid_595666
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   importLabVirtualMachineRequest: JObject (required)
  ##                                 : This represents the payload required to import a virtual machine from a different lab into the current one
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595668: Call_LabsImportVirtualMachine_595660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Import a virtual machine into a different lab. This operation can take a while to complete.
  ## 
  let valid = call_595668.validator(path, query, header, formData, body)
  let scheme = call_595668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595668.url(scheme.get, call_595668.host, call_595668.base,
                         call_595668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595668, url, valid)

proc call*(call_595669: Call_LabsImportVirtualMachine_595660;
          resourceGroupName: string; name: string; subscriptionId: string;
          importLabVirtualMachineRequest: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## labsImportVirtualMachine
  ## Import a virtual machine into a different lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   importLabVirtualMachineRequest: JObject (required)
  ##                                 : This represents the payload required to import a virtual machine from a different lab into the current one
  var path_595670 = newJObject()
  var query_595671 = newJObject()
  var body_595672 = newJObject()
  add(path_595670, "resourceGroupName", newJString(resourceGroupName))
  add(query_595671, "api-version", newJString(apiVersion))
  add(path_595670, "name", newJString(name))
  add(path_595670, "subscriptionId", newJString(subscriptionId))
  if importLabVirtualMachineRequest != nil:
    body_595672 = importLabVirtualMachineRequest
  result = call_595669.call(path_595670, query_595671, nil, nil, body_595672)

var labsImportVirtualMachine* = Call_LabsImportVirtualMachine_595660(
    name: "labsImportVirtualMachine", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/importVirtualMachine",
    validator: validate_LabsImportVirtualMachine_595661, base: "",
    url: url_LabsImportVirtualMachine_595662, schemes: {Scheme.Https})
type
  Call_LabsListVhds_595673 = ref object of OpenApiRestCall_593437
proc url_LabsListVhds_595675(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/listVhds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsListVhds_595674(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List disk images available for custom image creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595676 = path.getOrDefault("resourceGroupName")
  valid_595676 = validateParameter(valid_595676, JString, required = true,
                                 default = nil)
  if valid_595676 != nil:
    section.add "resourceGroupName", valid_595676
  var valid_595677 = path.getOrDefault("name")
  valid_595677 = validateParameter(valid_595677, JString, required = true,
                                 default = nil)
  if valid_595677 != nil:
    section.add "name", valid_595677
  var valid_595678 = path.getOrDefault("subscriptionId")
  valid_595678 = validateParameter(valid_595678, JString, required = true,
                                 default = nil)
  if valid_595678 != nil:
    section.add "subscriptionId", valid_595678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595679 = query.getOrDefault("api-version")
  valid_595679 = validateParameter(valid_595679, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595679 != nil:
    section.add "api-version", valid_595679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595680: Call_LabsListVhds_595673; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disk images available for custom image creation.
  ## 
  let valid = call_595680.validator(path, query, header, formData, body)
  let scheme = call_595680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595680.url(scheme.get, call_595680.host, call_595680.base,
                         call_595680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595680, url, valid)

proc call*(call_595681: Call_LabsListVhds_595673; resourceGroupName: string;
          name: string; subscriptionId: string; apiVersion: string = "2018-09-15"): Recallable =
  ## labsListVhds
  ## List disk images available for custom image creation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_595682 = newJObject()
  var query_595683 = newJObject()
  add(path_595682, "resourceGroupName", newJString(resourceGroupName))
  add(query_595683, "api-version", newJString(apiVersion))
  add(path_595682, "name", newJString(name))
  add(path_595682, "subscriptionId", newJString(subscriptionId))
  result = call_595681.call(path_595682, query_595683, nil, nil, nil)

var labsListVhds* = Call_LabsListVhds_595673(name: "labsListVhds",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/listVhds",
    validator: validate_LabsListVhds_595674, base: "", url: url_LabsListVhds_595675,
    schemes: {Scheme.Https})
type
  Call_GlobalSchedulesListByResourceGroup_595684 = ref object of OpenApiRestCall_593437
proc url_GlobalSchedulesListByResourceGroup_595686(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesListByResourceGroup_595685(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595687 = path.getOrDefault("resourceGroupName")
  valid_595687 = validateParameter(valid_595687, JString, required = true,
                                 default = nil)
  if valid_595687 != nil:
    section.add "resourceGroupName", valid_595687
  var valid_595688 = path.getOrDefault("subscriptionId")
  valid_595688 = validateParameter(valid_595688, JString, required = true,
                                 default = nil)
  if valid_595688 != nil:
    section.add "subscriptionId", valid_595688
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_595689 = query.getOrDefault("$orderby")
  valid_595689 = validateParameter(valid_595689, JString, required = false,
                                 default = nil)
  if valid_595689 != nil:
    section.add "$orderby", valid_595689
  var valid_595690 = query.getOrDefault("$expand")
  valid_595690 = validateParameter(valid_595690, JString, required = false,
                                 default = nil)
  if valid_595690 != nil:
    section.add "$expand", valid_595690
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595691 = query.getOrDefault("api-version")
  valid_595691 = validateParameter(valid_595691, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595691 != nil:
    section.add "api-version", valid_595691
  var valid_595692 = query.getOrDefault("$top")
  valid_595692 = validateParameter(valid_595692, JInt, required = false, default = nil)
  if valid_595692 != nil:
    section.add "$top", valid_595692
  var valid_595693 = query.getOrDefault("$filter")
  valid_595693 = validateParameter(valid_595693, JString, required = false,
                                 default = nil)
  if valid_595693 != nil:
    section.add "$filter", valid_595693
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595694: Call_GlobalSchedulesListByResourceGroup_595684;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List schedules in a resource group.
  ## 
  let valid = call_595694.validator(path, query, header, formData, body)
  let scheme = call_595694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595694.url(scheme.get, call_595694.host, call_595694.base,
                         call_595694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595694, url, valid)

proc call*(call_595695: Call_GlobalSchedulesListByResourceGroup_595684;
          resourceGroupName: string; subscriptionId: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## globalSchedulesListByResourceGroup
  ## List schedules in a resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_595696 = newJObject()
  var query_595697 = newJObject()
  add(query_595697, "$orderby", newJString(Orderby))
  add(path_595696, "resourceGroupName", newJString(resourceGroupName))
  add(query_595697, "$expand", newJString(Expand))
  add(query_595697, "api-version", newJString(apiVersion))
  add(path_595696, "subscriptionId", newJString(subscriptionId))
  add(query_595697, "$top", newJInt(Top))
  add(query_595697, "$filter", newJString(Filter))
  result = call_595695.call(path_595696, query_595697, nil, nil, nil)

var globalSchedulesListByResourceGroup* = Call_GlobalSchedulesListByResourceGroup_595684(
    name: "globalSchedulesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules",
    validator: validate_GlobalSchedulesListByResourceGroup_595685, base: "",
    url: url_GlobalSchedulesListByResourceGroup_595686, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesCreateOrUpdate_595710 = ref object of OpenApiRestCall_593437
proc url_GlobalSchedulesCreateOrUpdate_595712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesCreateOrUpdate_595711(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595713 = path.getOrDefault("resourceGroupName")
  valid_595713 = validateParameter(valid_595713, JString, required = true,
                                 default = nil)
  if valid_595713 != nil:
    section.add "resourceGroupName", valid_595713
  var valid_595714 = path.getOrDefault("name")
  valid_595714 = validateParameter(valid_595714, JString, required = true,
                                 default = nil)
  if valid_595714 != nil:
    section.add "name", valid_595714
  var valid_595715 = path.getOrDefault("subscriptionId")
  valid_595715 = validateParameter(valid_595715, JString, required = true,
                                 default = nil)
  if valid_595715 != nil:
    section.add "subscriptionId", valid_595715
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595716 = query.getOrDefault("api-version")
  valid_595716 = validateParameter(valid_595716, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595716 != nil:
    section.add "api-version", valid_595716
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595718: Call_GlobalSchedulesCreateOrUpdate_595710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_595718.validator(path, query, header, formData, body)
  let scheme = call_595718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595718.url(scheme.get, call_595718.host, call_595718.base,
                         call_595718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595718, url, valid)

proc call*(call_595719: Call_GlobalSchedulesCreateOrUpdate_595710;
          resourceGroupName: string; name: string; subscriptionId: string;
          schedule: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## globalSchedulesCreateOrUpdate
  ## Create or replace an existing schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_595720 = newJObject()
  var query_595721 = newJObject()
  var body_595722 = newJObject()
  add(path_595720, "resourceGroupName", newJString(resourceGroupName))
  add(query_595721, "api-version", newJString(apiVersion))
  add(path_595720, "name", newJString(name))
  add(path_595720, "subscriptionId", newJString(subscriptionId))
  if schedule != nil:
    body_595722 = schedule
  result = call_595719.call(path_595720, query_595721, nil, nil, body_595722)

var globalSchedulesCreateOrUpdate* = Call_GlobalSchedulesCreateOrUpdate_595710(
    name: "globalSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesCreateOrUpdate_595711, base: "",
    url: url_GlobalSchedulesCreateOrUpdate_595712, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesGet_595698 = ref object of OpenApiRestCall_593437
proc url_GlobalSchedulesGet_595700(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesGet_595699(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595701 = path.getOrDefault("resourceGroupName")
  valid_595701 = validateParameter(valid_595701, JString, required = true,
                                 default = nil)
  if valid_595701 != nil:
    section.add "resourceGroupName", valid_595701
  var valid_595702 = path.getOrDefault("name")
  valid_595702 = validateParameter(valid_595702, JString, required = true,
                                 default = nil)
  if valid_595702 != nil:
    section.add "name", valid_595702
  var valid_595703 = path.getOrDefault("subscriptionId")
  valid_595703 = validateParameter(valid_595703, JString, required = true,
                                 default = nil)
  if valid_595703 != nil:
    section.add "subscriptionId", valid_595703
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_595704 = query.getOrDefault("$expand")
  valid_595704 = validateParameter(valid_595704, JString, required = false,
                                 default = nil)
  if valid_595704 != nil:
    section.add "$expand", valid_595704
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595705 = query.getOrDefault("api-version")
  valid_595705 = validateParameter(valid_595705, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595705 != nil:
    section.add "api-version", valid_595705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595706: Call_GlobalSchedulesGet_595698; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_595706.validator(path, query, header, formData, body)
  let scheme = call_595706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595706.url(scheme.get, call_595706.host, call_595706.base,
                         call_595706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595706, url, valid)

proc call*(call_595707: Call_GlobalSchedulesGet_595698; resourceGroupName: string;
          name: string; subscriptionId: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
  ## globalSchedulesGet
  ## Get schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_595708 = newJObject()
  var query_595709 = newJObject()
  add(path_595708, "resourceGroupName", newJString(resourceGroupName))
  add(query_595709, "$expand", newJString(Expand))
  add(path_595708, "name", newJString(name))
  add(query_595709, "api-version", newJString(apiVersion))
  add(path_595708, "subscriptionId", newJString(subscriptionId))
  result = call_595707.call(path_595708, query_595709, nil, nil, nil)

var globalSchedulesGet* = Call_GlobalSchedulesGet_595698(
    name: "globalSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesGet_595699, base: "",
    url: url_GlobalSchedulesGet_595700, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesUpdate_595734 = ref object of OpenApiRestCall_593437
proc url_GlobalSchedulesUpdate_595736(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesUpdate_595735(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595737 = path.getOrDefault("resourceGroupName")
  valid_595737 = validateParameter(valid_595737, JString, required = true,
                                 default = nil)
  if valid_595737 != nil:
    section.add "resourceGroupName", valid_595737
  var valid_595738 = path.getOrDefault("name")
  valid_595738 = validateParameter(valid_595738, JString, required = true,
                                 default = nil)
  if valid_595738 != nil:
    section.add "name", valid_595738
  var valid_595739 = path.getOrDefault("subscriptionId")
  valid_595739 = validateParameter(valid_595739, JString, required = true,
                                 default = nil)
  if valid_595739 != nil:
    section.add "subscriptionId", valid_595739
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595740 = query.getOrDefault("api-version")
  valid_595740 = validateParameter(valid_595740, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595740 != nil:
    section.add "api-version", valid_595740
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595742: Call_GlobalSchedulesUpdate_595734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  let valid = call_595742.validator(path, query, header, formData, body)
  let scheme = call_595742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595742.url(scheme.get, call_595742.host, call_595742.base,
                         call_595742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595742, url, valid)

proc call*(call_595743: Call_GlobalSchedulesUpdate_595734;
          resourceGroupName: string; name: string; subscriptionId: string;
          schedule: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## globalSchedulesUpdate
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_595744 = newJObject()
  var query_595745 = newJObject()
  var body_595746 = newJObject()
  add(path_595744, "resourceGroupName", newJString(resourceGroupName))
  add(query_595745, "api-version", newJString(apiVersion))
  add(path_595744, "name", newJString(name))
  add(path_595744, "subscriptionId", newJString(subscriptionId))
  if schedule != nil:
    body_595746 = schedule
  result = call_595743.call(path_595744, query_595745, nil, nil, body_595746)

var globalSchedulesUpdate* = Call_GlobalSchedulesUpdate_595734(
    name: "globalSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesUpdate_595735, base: "",
    url: url_GlobalSchedulesUpdate_595736, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesDelete_595723 = ref object of OpenApiRestCall_593437
proc url_GlobalSchedulesDelete_595725(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesDelete_595724(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595726 = path.getOrDefault("resourceGroupName")
  valid_595726 = validateParameter(valid_595726, JString, required = true,
                                 default = nil)
  if valid_595726 != nil:
    section.add "resourceGroupName", valid_595726
  var valid_595727 = path.getOrDefault("name")
  valid_595727 = validateParameter(valid_595727, JString, required = true,
                                 default = nil)
  if valid_595727 != nil:
    section.add "name", valid_595727
  var valid_595728 = path.getOrDefault("subscriptionId")
  valid_595728 = validateParameter(valid_595728, JString, required = true,
                                 default = nil)
  if valid_595728 != nil:
    section.add "subscriptionId", valid_595728
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595729 = query.getOrDefault("api-version")
  valid_595729 = validateParameter(valid_595729, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595729 != nil:
    section.add "api-version", valid_595729
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595730: Call_GlobalSchedulesDelete_595723; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_595730.validator(path, query, header, formData, body)
  let scheme = call_595730.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595730.url(scheme.get, call_595730.host, call_595730.base,
                         call_595730.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595730, url, valid)

proc call*(call_595731: Call_GlobalSchedulesDelete_595723;
          resourceGroupName: string; name: string; subscriptionId: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## globalSchedulesDelete
  ## Delete schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_595732 = newJObject()
  var query_595733 = newJObject()
  add(path_595732, "resourceGroupName", newJString(resourceGroupName))
  add(query_595733, "api-version", newJString(apiVersion))
  add(path_595732, "name", newJString(name))
  add(path_595732, "subscriptionId", newJString(subscriptionId))
  result = call_595731.call(path_595732, query_595733, nil, nil, nil)

var globalSchedulesDelete* = Call_GlobalSchedulesDelete_595723(
    name: "globalSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesDelete_595724, base: "",
    url: url_GlobalSchedulesDelete_595725, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesExecute_595747 = ref object of OpenApiRestCall_593437
proc url_GlobalSchedulesExecute_595749(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesExecute_595748(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595750 = path.getOrDefault("resourceGroupName")
  valid_595750 = validateParameter(valid_595750, JString, required = true,
                                 default = nil)
  if valid_595750 != nil:
    section.add "resourceGroupName", valid_595750
  var valid_595751 = path.getOrDefault("name")
  valid_595751 = validateParameter(valid_595751, JString, required = true,
                                 default = nil)
  if valid_595751 != nil:
    section.add "name", valid_595751
  var valid_595752 = path.getOrDefault("subscriptionId")
  valid_595752 = validateParameter(valid_595752, JString, required = true,
                                 default = nil)
  if valid_595752 != nil:
    section.add "subscriptionId", valid_595752
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595753 = query.getOrDefault("api-version")
  valid_595753 = validateParameter(valid_595753, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595753 != nil:
    section.add "api-version", valid_595753
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595754: Call_GlobalSchedulesExecute_595747; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_595754.validator(path, query, header, formData, body)
  let scheme = call_595754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595754.url(scheme.get, call_595754.host, call_595754.base,
                         call_595754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595754, url, valid)

proc call*(call_595755: Call_GlobalSchedulesExecute_595747;
          resourceGroupName: string; name: string; subscriptionId: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## globalSchedulesExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_595756 = newJObject()
  var query_595757 = newJObject()
  add(path_595756, "resourceGroupName", newJString(resourceGroupName))
  add(query_595757, "api-version", newJString(apiVersion))
  add(path_595756, "name", newJString(name))
  add(path_595756, "subscriptionId", newJString(subscriptionId))
  result = call_595755.call(path_595756, query_595757, nil, nil, nil)

var globalSchedulesExecute* = Call_GlobalSchedulesExecute_595747(
    name: "globalSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}/execute",
    validator: validate_GlobalSchedulesExecute_595748, base: "",
    url: url_GlobalSchedulesExecute_595749, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesRetarget_595758 = ref object of OpenApiRestCall_593437
proc url_GlobalSchedulesRetarget_595760(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/retarget")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesRetarget_595759(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a schedule's target resource Id. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595761 = path.getOrDefault("resourceGroupName")
  valid_595761 = validateParameter(valid_595761, JString, required = true,
                                 default = nil)
  if valid_595761 != nil:
    section.add "resourceGroupName", valid_595761
  var valid_595762 = path.getOrDefault("name")
  valid_595762 = validateParameter(valid_595762, JString, required = true,
                                 default = nil)
  if valid_595762 != nil:
    section.add "name", valid_595762
  var valid_595763 = path.getOrDefault("subscriptionId")
  valid_595763 = validateParameter(valid_595763, JString, required = true,
                                 default = nil)
  if valid_595763 != nil:
    section.add "subscriptionId", valid_595763
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595764 = query.getOrDefault("api-version")
  valid_595764 = validateParameter(valid_595764, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_595764 != nil:
    section.add "api-version", valid_595764
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   retargetScheduleProperties: JObject (required)
  ##                             : Properties for retargeting a virtual machine schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595766: Call_GlobalSchedulesRetarget_595758; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a schedule's target resource Id. This operation can take a while to complete.
  ## 
  let valid = call_595766.validator(path, query, header, formData, body)
  let scheme = call_595766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595766.url(scheme.get, call_595766.host, call_595766.base,
                         call_595766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595766, url, valid)

proc call*(call_595767: Call_GlobalSchedulesRetarget_595758;
          resourceGroupName: string; name: string; subscriptionId: string;
          retargetScheduleProperties: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## globalSchedulesRetarget
  ## Updates a schedule's target resource Id. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   retargetScheduleProperties: JObject (required)
  ##                             : Properties for retargeting a virtual machine schedule.
  var path_595768 = newJObject()
  var query_595769 = newJObject()
  var body_595770 = newJObject()
  add(path_595768, "resourceGroupName", newJString(resourceGroupName))
  add(query_595769, "api-version", newJString(apiVersion))
  add(path_595768, "name", newJString(name))
  add(path_595768, "subscriptionId", newJString(subscriptionId))
  if retargetScheduleProperties != nil:
    body_595770 = retargetScheduleProperties
  result = call_595767.call(path_595768, query_595769, nil, nil, body_595770)

var globalSchedulesRetarget* = Call_GlobalSchedulesRetarget_595758(
    name: "globalSchedulesRetarget", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}/retarget",
    validator: validate_GlobalSchedulesRetarget_595759, base: "",
    url: url_GlobalSchedulesRetarget_595760, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
