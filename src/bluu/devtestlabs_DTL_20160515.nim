
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DevTestLabsClient
## version: 2016-05-15
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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
  Call_ProviderOperationsList_593643 = ref object of OpenApiRestCall_593421
proc url_ProviderOperationsList_593645(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderOperationsList_593644(path: JsonNode; query: JsonNode;
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
  var valid_593817 = query.getOrDefault("api-version")
  valid_593817 = validateParameter(valid_593817, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_593817 != nil:
    section.add "api-version", valid_593817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593840: Call_ProviderOperationsList_593643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Result of the request to list REST API operations
  ## 
  let valid = call_593840.validator(path, query, header, formData, body)
  let scheme = call_593840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593840.url(scheme.get, call_593840.host, call_593840.base,
                         call_593840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593840, url, valid)

proc call*(call_593911: Call_ProviderOperationsList_593643;
          apiVersion: string = "2016-05-15"): Recallable =
  ## providerOperationsList
  ## Result of the request to list REST API operations
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_593912 = newJObject()
  add(query_593912, "api-version", newJString(apiVersion))
  result = call_593911.call(nil, query_593912, nil, nil, nil)

var providerOperationsList* = Call_ProviderOperationsList_593643(
    name: "providerOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.DevTestLab/operations",
    validator: validate_ProviderOperationsList_593644, base: "",
    url: url_ProviderOperationsList_593645, schemes: {Scheme.Https})
type
  Call_LabsListBySubscription_593952 = ref object of OpenApiRestCall_593421
proc url_LabsListBySubscription_593954(protocol: Scheme; host: string; base: string;
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

proc validate_LabsListBySubscription_593953(path: JsonNode; query: JsonNode;
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
  var valid_593970 = path.getOrDefault("subscriptionId")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "subscriptionId", valid_593970
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_593971 = query.getOrDefault("$orderby")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "$orderby", valid_593971
  var valid_593972 = query.getOrDefault("$expand")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "$expand", valid_593972
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_593973 != nil:
    section.add "api-version", valid_593973
  var valid_593974 = query.getOrDefault("$top")
  valid_593974 = validateParameter(valid_593974, JInt, required = false, default = nil)
  if valid_593974 != nil:
    section.add "$top", valid_593974
  var valid_593975 = query.getOrDefault("$filter")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "$filter", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_LabsListBySubscription_593952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a subscription.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_LabsListBySubscription_593952; subscriptionId: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## labsListBySubscription
  ## List labs in a subscription.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  add(query_593979, "$orderby", newJString(Orderby))
  add(query_593979, "$expand", newJString(Expand))
  add(query_593979, "api-version", newJString(apiVersion))
  add(path_593978, "subscriptionId", newJString(subscriptionId))
  add(query_593979, "$top", newJInt(Top))
  add(query_593979, "$filter", newJString(Filter))
  result = call_593977.call(path_593978, query_593979, nil, nil, nil)

var labsListBySubscription* = Call_LabsListBySubscription_593952(
    name: "labsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabsListBySubscription_593953, base: "",
    url: url_LabsListBySubscription_593954, schemes: {Scheme.Https})
type
  Call_OperationsGet_593980 = ref object of OpenApiRestCall_593421
proc url_OperationsGet_593982(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsGet_593981(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593983 = path.getOrDefault("name")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "name", valid_593983
  var valid_593984 = path.getOrDefault("subscriptionId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "subscriptionId", valid_593984
  var valid_593985 = path.getOrDefault("locationName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "locationName", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_593986 != nil:
    section.add "api-version", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_OperationsGet_593980; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get operation.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_OperationsGet_593980; name: string;
          subscriptionId: string; locationName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "name", newJString(name))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  add(path_593989, "locationName", newJString(locationName))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var operationsGet* = Call_OperationsGet_593980(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/locations/{locationName}/operations/{name}",
    validator: validate_OperationsGet_593981, base: "", url: url_OperationsGet_593982,
    schemes: {Scheme.Https})
type
  Call_GlobalSchedulesListBySubscription_593991 = ref object of OpenApiRestCall_593421
proc url_GlobalSchedulesListBySubscription_593993(protocol: Scheme; host: string;
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

proc validate_GlobalSchedulesListBySubscription_593992(path: JsonNode;
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
  var valid_593994 = path.getOrDefault("subscriptionId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "subscriptionId", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_593995 = query.getOrDefault("$orderby")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "$orderby", valid_593995
  var valid_593996 = query.getOrDefault("$expand")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "$expand", valid_593996
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_593997 != nil:
    section.add "api-version", valid_593997
  var valid_593998 = query.getOrDefault("$top")
  valid_593998 = validateParameter(valid_593998, JInt, required = false, default = nil)
  if valid_593998 != nil:
    section.add "$top", valid_593998
  var valid_593999 = query.getOrDefault("$filter")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "$filter", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_GlobalSchedulesListBySubscription_593991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List schedules in a subscription.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_GlobalSchedulesListBySubscription_593991;
          subscriptionId: string; Orderby: string = ""; Expand: string = "";
          apiVersion: string = "2016-05-15"; Top: int = 0; Filter: string = ""): Recallable =
  ## globalSchedulesListBySubscription
  ## List schedules in a subscription.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(query_594003, "$orderby", newJString(Orderby))
  add(query_594003, "$expand", newJString(Expand))
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  add(query_594003, "$top", newJInt(Top))
  add(query_594003, "$filter", newJString(Filter))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var globalSchedulesListBySubscription* = Call_GlobalSchedulesListBySubscription_593991(
    name: "globalSchedulesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/schedules",
    validator: validate_GlobalSchedulesListBySubscription_593992, base: "",
    url: url_GlobalSchedulesListBySubscription_593993, schemes: {Scheme.Https})
type
  Call_LabsListByResourceGroup_594004 = ref object of OpenApiRestCall_593421
proc url_LabsListByResourceGroup_594006(protocol: Scheme; host: string; base: string;
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

proc validate_LabsListByResourceGroup_594005(path: JsonNode; query: JsonNode;
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
  var valid_594007 = path.getOrDefault("resourceGroupName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "resourceGroupName", valid_594007
  var valid_594008 = path.getOrDefault("subscriptionId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "subscriptionId", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594009 = query.getOrDefault("$orderby")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "$orderby", valid_594009
  var valid_594010 = query.getOrDefault("$expand")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "$expand", valid_594010
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594011 = query.getOrDefault("api-version")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594011 != nil:
    section.add "api-version", valid_594011
  var valid_594012 = query.getOrDefault("$top")
  valid_594012 = validateParameter(valid_594012, JInt, required = false, default = nil)
  if valid_594012 != nil:
    section.add "$top", valid_594012
  var valid_594013 = query.getOrDefault("$filter")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "$filter", valid_594013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_LabsListByResourceGroup_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a resource group.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_LabsListByResourceGroup_594004;
          resourceGroupName: string; subscriptionId: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## labsListByResourceGroup
  ## List labs in a resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  add(query_594017, "$orderby", newJString(Orderby))
  add(path_594016, "resourceGroupName", newJString(resourceGroupName))
  add(query_594017, "$expand", newJString(Expand))
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "subscriptionId", newJString(subscriptionId))
  add(query_594017, "$top", newJInt(Top))
  add(query_594017, "$filter", newJString(Filter))
  result = call_594015.call(path_594016, query_594017, nil, nil, nil)

var labsListByResourceGroup* = Call_LabsListByResourceGroup_594004(
    name: "labsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabsListByResourceGroup_594005, base: "",
    url: url_LabsListByResourceGroup_594006, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesList_594018 = ref object of OpenApiRestCall_593421
proc url_ArtifactSourcesList_594020(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesList_594019(path: JsonNode; query: JsonNode;
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
  var valid_594021 = path.getOrDefault("resourceGroupName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "resourceGroupName", valid_594021
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  var valid_594023 = path.getOrDefault("labName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "labName", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594024 = query.getOrDefault("$orderby")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "$orderby", valid_594024
  var valid_594025 = query.getOrDefault("$expand")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "$expand", valid_594025
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  var valid_594027 = query.getOrDefault("$top")
  valid_594027 = validateParameter(valid_594027, JInt, required = false, default = nil)
  if valid_594027 != nil:
    section.add "$top", valid_594027
  var valid_594028 = query.getOrDefault("$filter")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "$filter", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_ArtifactSourcesList_594018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifact sources in a given lab.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_ArtifactSourcesList_594018; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## artifactSourcesList
  ## List artifact sources in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(query_594032, "$orderby", newJString(Orderby))
  add(path_594031, "resourceGroupName", newJString(resourceGroupName))
  add(query_594032, "$expand", newJString(Expand))
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  add(query_594032, "$top", newJInt(Top))
  add(path_594031, "labName", newJString(labName))
  add(query_594032, "$filter", newJString(Filter))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var artifactSourcesList* = Call_ArtifactSourcesList_594018(
    name: "artifactSourcesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources",
    validator: validate_ArtifactSourcesList_594019, base: "",
    url: url_ArtifactSourcesList_594020, schemes: {Scheme.Https})
type
  Call_ArmTemplatesList_594033 = ref object of OpenApiRestCall_593421
proc url_ArmTemplatesList_594035(protocol: Scheme; host: string; base: string;
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

proc validate_ArmTemplatesList_594034(path: JsonNode; query: JsonNode;
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
  var valid_594036 = path.getOrDefault("resourceGroupName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "resourceGroupName", valid_594036
  var valid_594037 = path.getOrDefault("subscriptionId")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "subscriptionId", valid_594037
  var valid_594038 = path.getOrDefault("artifactSourceName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "artifactSourceName", valid_594038
  var valid_594039 = path.getOrDefault("labName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "labName", valid_594039
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
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
                                 default = newJString("2016-05-15"))
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

proc call*(call_594045: Call_ArmTemplatesList_594033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List azure resource manager templates in a given artifact source.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_ArmTemplatesList_594033; resourceGroupName: string;
          subscriptionId: string; artifactSourceName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## armTemplatesList
  ## List azure resource manager templates in a given artifact source.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(query_594048, "$orderby", newJString(Orderby))
  add(path_594047, "resourceGroupName", newJString(resourceGroupName))
  add(query_594048, "$expand", newJString(Expand))
  add(query_594048, "api-version", newJString(apiVersion))
  add(path_594047, "subscriptionId", newJString(subscriptionId))
  add(query_594048, "$top", newJInt(Top))
  add(path_594047, "artifactSourceName", newJString(artifactSourceName))
  add(path_594047, "labName", newJString(labName))
  add(query_594048, "$filter", newJString(Filter))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var armTemplatesList* = Call_ArmTemplatesList_594033(name: "armTemplatesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/armtemplates",
    validator: validate_ArmTemplatesList_594034, base: "",
    url: url_ArmTemplatesList_594035, schemes: {Scheme.Https})
type
  Call_ArmTemplatesGet_594049 = ref object of OpenApiRestCall_593421
proc url_ArmTemplatesGet_594051(protocol: Scheme; host: string; base: string;
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

proc validate_ArmTemplatesGet_594050(path: JsonNode; query: JsonNode;
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
  ##       : The name of the azure Resource Manager template.
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
  var valid_594053 = path.getOrDefault("name")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "name", valid_594053
  var valid_594054 = path.getOrDefault("subscriptionId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "subscriptionId", valid_594054
  var valid_594055 = path.getOrDefault("artifactSourceName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "artifactSourceName", valid_594055
  var valid_594056 = path.getOrDefault("labName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "labName", valid_594056
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594057 = query.getOrDefault("$expand")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "$expand", valid_594057
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594058 = query.getOrDefault("api-version")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594058 != nil:
    section.add "api-version", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_ArmTemplatesGet_594049; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get azure resource manager template.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_ArmTemplatesGet_594049; resourceGroupName: string;
          name: string; subscriptionId: string; artifactSourceName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
  ## armTemplatesGet
  ## Get azure resource manager template.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   name: string (required)
  ##       : The name of the azure Resource Manager template.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  add(path_594061, "resourceGroupName", newJString(resourceGroupName))
  add(query_594062, "$expand", newJString(Expand))
  add(path_594061, "name", newJString(name))
  add(query_594062, "api-version", newJString(apiVersion))
  add(path_594061, "subscriptionId", newJString(subscriptionId))
  add(path_594061, "artifactSourceName", newJString(artifactSourceName))
  add(path_594061, "labName", newJString(labName))
  result = call_594060.call(path_594061, query_594062, nil, nil, nil)

var armTemplatesGet* = Call_ArmTemplatesGet_594049(name: "armTemplatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/armtemplates/{name}",
    validator: validate_ArmTemplatesGet_594050, base: "", url: url_ArmTemplatesGet_594051,
    schemes: {Scheme.Https})
type
  Call_ArtifactsList_594063 = ref object of OpenApiRestCall_593421
proc url_ArtifactsList_594065(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsList_594064(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594066 = path.getOrDefault("resourceGroupName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "resourceGroupName", valid_594066
  var valid_594067 = path.getOrDefault("subscriptionId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "subscriptionId", valid_594067
  var valid_594068 = path.getOrDefault("artifactSourceName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "artifactSourceName", valid_594068
  var valid_594069 = path.getOrDefault("labName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "labName", valid_594069
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=title)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594070 = query.getOrDefault("$orderby")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "$orderby", valid_594070
  var valid_594071 = query.getOrDefault("$expand")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "$expand", valid_594071
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594072 != nil:
    section.add "api-version", valid_594072
  var valid_594073 = query.getOrDefault("$top")
  valid_594073 = validateParameter(valid_594073, JInt, required = false, default = nil)
  if valid_594073 != nil:
    section.add "$top", valid_594073
  var valid_594074 = query.getOrDefault("$filter")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "$filter", valid_594074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594075: Call_ArtifactsList_594063; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts in a given artifact source.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_ArtifactsList_594063; resourceGroupName: string;
          subscriptionId: string; artifactSourceName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## artifactsList
  ## List artifacts in a given artifact source.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=title)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  add(query_594078, "$orderby", newJString(Orderby))
  add(path_594077, "resourceGroupName", newJString(resourceGroupName))
  add(query_594078, "$expand", newJString(Expand))
  add(query_594078, "api-version", newJString(apiVersion))
  add(path_594077, "subscriptionId", newJString(subscriptionId))
  add(query_594078, "$top", newJInt(Top))
  add(path_594077, "artifactSourceName", newJString(artifactSourceName))
  add(path_594077, "labName", newJString(labName))
  add(query_594078, "$filter", newJString(Filter))
  result = call_594076.call(path_594077, query_594078, nil, nil, nil)

var artifactsList* = Call_ArtifactsList_594063(name: "artifactsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts",
    validator: validate_ArtifactsList_594064, base: "", url: url_ArtifactsList_594065,
    schemes: {Scheme.Https})
type
  Call_ArtifactsGet_594079 = ref object of OpenApiRestCall_593421
proc url_ArtifactsGet_594081(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsGet_594080(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594082 = path.getOrDefault("resourceGroupName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "resourceGroupName", valid_594082
  var valid_594083 = path.getOrDefault("name")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "name", valid_594083
  var valid_594084 = path.getOrDefault("subscriptionId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "subscriptionId", valid_594084
  var valid_594085 = path.getOrDefault("artifactSourceName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "artifactSourceName", valid_594085
  var valid_594086 = path.getOrDefault("labName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "labName", valid_594086
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=title)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594087 = query.getOrDefault("$expand")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "$expand", valid_594087
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594088 = query.getOrDefault("api-version")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594088 != nil:
    section.add "api-version", valid_594088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_ArtifactsGet_594079; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact.
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_ArtifactsGet_594079; resourceGroupName: string;
          name: string; subscriptionId: string; artifactSourceName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  add(path_594091, "resourceGroupName", newJString(resourceGroupName))
  add(query_594092, "$expand", newJString(Expand))
  add(path_594091, "name", newJString(name))
  add(query_594092, "api-version", newJString(apiVersion))
  add(path_594091, "subscriptionId", newJString(subscriptionId))
  add(path_594091, "artifactSourceName", newJString(artifactSourceName))
  add(path_594091, "labName", newJString(labName))
  result = call_594090.call(path_594091, query_594092, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_594079(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}",
    validator: validate_ArtifactsGet_594080, base: "", url: url_ArtifactsGet_594081,
    schemes: {Scheme.Https})
type
  Call_ArtifactsGenerateArmTemplate_594093 = ref object of OpenApiRestCall_593421
proc url_ArtifactsGenerateArmTemplate_594095(protocol: Scheme; host: string;
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

proc validate_ArtifactsGenerateArmTemplate_594094(path: JsonNode; query: JsonNode;
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
  var valid_594096 = path.getOrDefault("resourceGroupName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "resourceGroupName", valid_594096
  var valid_594097 = path.getOrDefault("name")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "name", valid_594097
  var valid_594098 = path.getOrDefault("subscriptionId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "subscriptionId", valid_594098
  var valid_594099 = path.getOrDefault("artifactSourceName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "artifactSourceName", valid_594099
  var valid_594100 = path.getOrDefault("labName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "labName", valid_594100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594101 = query.getOrDefault("api-version")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594101 != nil:
    section.add "api-version", valid_594101
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

proc call*(call_594103: Call_ArtifactsGenerateArmTemplate_594093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  let valid = call_594103.validator(path, query, header, formData, body)
  let scheme = call_594103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594103.url(scheme.get, call_594103.host, call_594103.base,
                         call_594103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594103, url, valid)

proc call*(call_594104: Call_ArtifactsGenerateArmTemplate_594093;
          resourceGroupName: string; name: string; subscriptionId: string;
          artifactSourceName: string; labName: string;
          generateArmTemplateRequest: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594105 = newJObject()
  var query_594106 = newJObject()
  var body_594107 = newJObject()
  add(path_594105, "resourceGroupName", newJString(resourceGroupName))
  add(query_594106, "api-version", newJString(apiVersion))
  add(path_594105, "name", newJString(name))
  add(path_594105, "subscriptionId", newJString(subscriptionId))
  add(path_594105, "artifactSourceName", newJString(artifactSourceName))
  add(path_594105, "labName", newJString(labName))
  if generateArmTemplateRequest != nil:
    body_594107 = generateArmTemplateRequest
  result = call_594104.call(path_594105, query_594106, nil, nil, body_594107)

var artifactsGenerateArmTemplate* = Call_ArtifactsGenerateArmTemplate_594093(
    name: "artifactsGenerateArmTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}/generateArmTemplate",
    validator: validate_ArtifactsGenerateArmTemplate_594094, base: "",
    url: url_ArtifactsGenerateArmTemplate_594095, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesCreateOrUpdate_594121 = ref object of OpenApiRestCall_593421
proc url_ArtifactSourcesCreateOrUpdate_594123(protocol: Scheme; host: string;
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

proc validate_ArtifactSourcesCreateOrUpdate_594122(path: JsonNode; query: JsonNode;
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
  var valid_594124 = path.getOrDefault("resourceGroupName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "resourceGroupName", valid_594124
  var valid_594125 = path.getOrDefault("name")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "name", valid_594125
  var valid_594126 = path.getOrDefault("subscriptionId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "subscriptionId", valid_594126
  var valid_594127 = path.getOrDefault("labName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "labName", valid_594127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594128 = query.getOrDefault("api-version")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594128 != nil:
    section.add "api-version", valid_594128
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

proc call*(call_594130: Call_ArtifactSourcesCreateOrUpdate_594121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing artifact source.
  ## 
  let valid = call_594130.validator(path, query, header, formData, body)
  let scheme = call_594130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594130.url(scheme.get, call_594130.host, call_594130.base,
                         call_594130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594130, url, valid)

proc call*(call_594131: Call_ArtifactSourcesCreateOrUpdate_594121;
          resourceGroupName: string; name: string; artifactSource: JsonNode;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594132 = newJObject()
  var query_594133 = newJObject()
  var body_594134 = newJObject()
  add(path_594132, "resourceGroupName", newJString(resourceGroupName))
  add(query_594133, "api-version", newJString(apiVersion))
  add(path_594132, "name", newJString(name))
  if artifactSource != nil:
    body_594134 = artifactSource
  add(path_594132, "subscriptionId", newJString(subscriptionId))
  add(path_594132, "labName", newJString(labName))
  result = call_594131.call(path_594132, query_594133, nil, nil, body_594134)

var artifactSourcesCreateOrUpdate* = Call_ArtifactSourcesCreateOrUpdate_594121(
    name: "artifactSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesCreateOrUpdate_594122, base: "",
    url: url_ArtifactSourcesCreateOrUpdate_594123, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesGet_594108 = ref object of OpenApiRestCall_593421
proc url_ArtifactSourcesGet_594110(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesGet_594109(path: JsonNode; query: JsonNode;
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
  var valid_594111 = path.getOrDefault("resourceGroupName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "resourceGroupName", valid_594111
  var valid_594112 = path.getOrDefault("name")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "name", valid_594112
  var valid_594113 = path.getOrDefault("subscriptionId")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "subscriptionId", valid_594113
  var valid_594114 = path.getOrDefault("labName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "labName", valid_594114
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594115 = query.getOrDefault("$expand")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "$expand", valid_594115
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594116 = query.getOrDefault("api-version")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594116 != nil:
    section.add "api-version", valid_594116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594117: Call_ArtifactSourcesGet_594108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact source.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_ArtifactSourcesGet_594108; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594119 = newJObject()
  var query_594120 = newJObject()
  add(path_594119, "resourceGroupName", newJString(resourceGroupName))
  add(query_594120, "$expand", newJString(Expand))
  add(path_594119, "name", newJString(name))
  add(query_594120, "api-version", newJString(apiVersion))
  add(path_594119, "subscriptionId", newJString(subscriptionId))
  add(path_594119, "labName", newJString(labName))
  result = call_594118.call(path_594119, query_594120, nil, nil, nil)

var artifactSourcesGet* = Call_ArtifactSourcesGet_594108(
    name: "artifactSourcesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesGet_594109, base: "",
    url: url_ArtifactSourcesGet_594110, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesUpdate_594147 = ref object of OpenApiRestCall_593421
proc url_ArtifactSourcesUpdate_594149(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesUpdate_594148(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of artifact sources.
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
  var valid_594150 = path.getOrDefault("resourceGroupName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "resourceGroupName", valid_594150
  var valid_594151 = path.getOrDefault("name")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "name", valid_594151
  var valid_594152 = path.getOrDefault("subscriptionId")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "subscriptionId", valid_594152
  var valid_594153 = path.getOrDefault("labName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "labName", valid_594153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594154 = query.getOrDefault("api-version")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594154 != nil:
    section.add "api-version", valid_594154
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

proc call*(call_594156: Call_ArtifactSourcesUpdate_594147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of artifact sources.
  ## 
  let valid = call_594156.validator(path, query, header, formData, body)
  let scheme = call_594156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594156.url(scheme.get, call_594156.host, call_594156.base,
                         call_594156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594156, url, valid)

proc call*(call_594157: Call_ArtifactSourcesUpdate_594147;
          resourceGroupName: string; name: string; artifactSource: JsonNode;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## artifactSourcesUpdate
  ## Modify properties of artifact sources.
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
  var path_594158 = newJObject()
  var query_594159 = newJObject()
  var body_594160 = newJObject()
  add(path_594158, "resourceGroupName", newJString(resourceGroupName))
  add(query_594159, "api-version", newJString(apiVersion))
  add(path_594158, "name", newJString(name))
  if artifactSource != nil:
    body_594160 = artifactSource
  add(path_594158, "subscriptionId", newJString(subscriptionId))
  add(path_594158, "labName", newJString(labName))
  result = call_594157.call(path_594158, query_594159, nil, nil, body_594160)

var artifactSourcesUpdate* = Call_ArtifactSourcesUpdate_594147(
    name: "artifactSourcesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesUpdate_594148, base: "",
    url: url_ArtifactSourcesUpdate_594149, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesDelete_594135 = ref object of OpenApiRestCall_593421
proc url_ArtifactSourcesDelete_594137(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesDelete_594136(path: JsonNode; query: JsonNode;
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
  var valid_594138 = path.getOrDefault("resourceGroupName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "resourceGroupName", valid_594138
  var valid_594139 = path.getOrDefault("name")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "name", valid_594139
  var valid_594140 = path.getOrDefault("subscriptionId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "subscriptionId", valid_594140
  var valid_594141 = path.getOrDefault("labName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "labName", valid_594141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594142 = query.getOrDefault("api-version")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594142 != nil:
    section.add "api-version", valid_594142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594143: Call_ArtifactSourcesDelete_594135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete artifact source.
  ## 
  let valid = call_594143.validator(path, query, header, formData, body)
  let scheme = call_594143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594143.url(scheme.get, call_594143.host, call_594143.base,
                         call_594143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594143, url, valid)

proc call*(call_594144: Call_ArtifactSourcesDelete_594135;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594145 = newJObject()
  var query_594146 = newJObject()
  add(path_594145, "resourceGroupName", newJString(resourceGroupName))
  add(query_594146, "api-version", newJString(apiVersion))
  add(path_594145, "name", newJString(name))
  add(path_594145, "subscriptionId", newJString(subscriptionId))
  add(path_594145, "labName", newJString(labName))
  result = call_594144.call(path_594145, query_594146, nil, nil, nil)

var artifactSourcesDelete* = Call_ArtifactSourcesDelete_594135(
    name: "artifactSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesDelete_594136, base: "",
    url: url_ArtifactSourcesDelete_594137, schemes: {Scheme.Https})
type
  Call_CostsCreateOrUpdate_594174 = ref object of OpenApiRestCall_593421
proc url_CostsCreateOrUpdate_594176(protocol: Scheme; host: string; base: string;
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

proc validate_CostsCreateOrUpdate_594175(path: JsonNode; query: JsonNode;
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
  var valid_594177 = path.getOrDefault("resourceGroupName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "resourceGroupName", valid_594177
  var valid_594178 = path.getOrDefault("name")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "name", valid_594178
  var valid_594179 = path.getOrDefault("subscriptionId")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "subscriptionId", valid_594179
  var valid_594180 = path.getOrDefault("labName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "labName", valid_594180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594181 = query.getOrDefault("api-version")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594181 != nil:
    section.add "api-version", valid_594181
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

proc call*(call_594183: Call_CostsCreateOrUpdate_594174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing cost.
  ## 
  let valid = call_594183.validator(path, query, header, formData, body)
  let scheme = call_594183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594183.url(scheme.get, call_594183.host, call_594183.base,
                         call_594183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594183, url, valid)

proc call*(call_594184: Call_CostsCreateOrUpdate_594174; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; labCost: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594185 = newJObject()
  var query_594186 = newJObject()
  var body_594187 = newJObject()
  add(path_594185, "resourceGroupName", newJString(resourceGroupName))
  add(query_594186, "api-version", newJString(apiVersion))
  add(path_594185, "name", newJString(name))
  add(path_594185, "subscriptionId", newJString(subscriptionId))
  add(path_594185, "labName", newJString(labName))
  if labCost != nil:
    body_594187 = labCost
  result = call_594184.call(path_594185, query_594186, nil, nil, body_594187)

var costsCreateOrUpdate* = Call_CostsCreateOrUpdate_594174(
    name: "costsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
    validator: validate_CostsCreateOrUpdate_594175, base: "",
    url: url_CostsCreateOrUpdate_594176, schemes: {Scheme.Https})
type
  Call_CostsGet_594161 = ref object of OpenApiRestCall_593421
proc url_CostsGet_594163(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CostsGet_594162(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594164 = path.getOrDefault("resourceGroupName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "resourceGroupName", valid_594164
  var valid_594165 = path.getOrDefault("name")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "name", valid_594165
  var valid_594166 = path.getOrDefault("subscriptionId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "subscriptionId", valid_594166
  var valid_594167 = path.getOrDefault("labName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "labName", valid_594167
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=labCostDetails)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594168 = query.getOrDefault("$expand")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "$expand", valid_594168
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594169 = query.getOrDefault("api-version")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594169 != nil:
    section.add "api-version", valid_594169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594170: Call_CostsGet_594161; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost.
  ## 
  let valid = call_594170.validator(path, query, header, formData, body)
  let scheme = call_594170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594170.url(scheme.get, call_594170.host, call_594170.base,
                         call_594170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594170, url, valid)

proc call*(call_594171: Call_CostsGet_594161; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594172 = newJObject()
  var query_594173 = newJObject()
  add(path_594172, "resourceGroupName", newJString(resourceGroupName))
  add(query_594173, "$expand", newJString(Expand))
  add(path_594172, "name", newJString(name))
  add(query_594173, "api-version", newJString(apiVersion))
  add(path_594172, "subscriptionId", newJString(subscriptionId))
  add(path_594172, "labName", newJString(labName))
  result = call_594171.call(path_594172, query_594173, nil, nil, nil)

var costsGet* = Call_CostsGet_594161(name: "costsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
                                  validator: validate_CostsGet_594162, base: "",
                                  url: url_CostsGet_594163,
                                  schemes: {Scheme.Https})
type
  Call_CustomImagesList_594188 = ref object of OpenApiRestCall_593421
proc url_CustomImagesList_594190(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesList_594189(path: JsonNode; query: JsonNode;
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
  var valid_594191 = path.getOrDefault("resourceGroupName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "resourceGroupName", valid_594191
  var valid_594192 = path.getOrDefault("subscriptionId")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "subscriptionId", valid_594192
  var valid_594193 = path.getOrDefault("labName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "labName", valid_594193
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=vm)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594194 = query.getOrDefault("$orderby")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "$orderby", valid_594194
  var valid_594195 = query.getOrDefault("$expand")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "$expand", valid_594195
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594196 = query.getOrDefault("api-version")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594196 != nil:
    section.add "api-version", valid_594196
  var valid_594197 = query.getOrDefault("$top")
  valid_594197 = validateParameter(valid_594197, JInt, required = false, default = nil)
  if valid_594197 != nil:
    section.add "$top", valid_594197
  var valid_594198 = query.getOrDefault("$filter")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "$filter", valid_594198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594199: Call_CustomImagesList_594188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List custom images in a given lab.
  ## 
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_CustomImagesList_594188; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## customImagesList
  ## List custom images in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=vm)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  add(query_594202, "$orderby", newJString(Orderby))
  add(path_594201, "resourceGroupName", newJString(resourceGroupName))
  add(query_594202, "$expand", newJString(Expand))
  add(query_594202, "api-version", newJString(apiVersion))
  add(path_594201, "subscriptionId", newJString(subscriptionId))
  add(query_594202, "$top", newJInt(Top))
  add(path_594201, "labName", newJString(labName))
  add(query_594202, "$filter", newJString(Filter))
  result = call_594200.call(path_594201, query_594202, nil, nil, nil)

var customImagesList* = Call_CustomImagesList_594188(name: "customImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages",
    validator: validate_CustomImagesList_594189, base: "",
    url: url_CustomImagesList_594190, schemes: {Scheme.Https})
type
  Call_CustomImagesCreateOrUpdate_594216 = ref object of OpenApiRestCall_593421
proc url_CustomImagesCreateOrUpdate_594218(protocol: Scheme; host: string;
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

proc validate_CustomImagesCreateOrUpdate_594217(path: JsonNode; query: JsonNode;
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
  var valid_594219 = path.getOrDefault("resourceGroupName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "resourceGroupName", valid_594219
  var valid_594220 = path.getOrDefault("name")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "name", valid_594220
  var valid_594221 = path.getOrDefault("subscriptionId")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "subscriptionId", valid_594221
  var valid_594222 = path.getOrDefault("labName")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "labName", valid_594222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594223 = query.getOrDefault("api-version")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594223 != nil:
    section.add "api-version", valid_594223
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

proc call*(call_594225: Call_CustomImagesCreateOrUpdate_594216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  let valid = call_594225.validator(path, query, header, formData, body)
  let scheme = call_594225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594225.url(scheme.get, call_594225.host, call_594225.base,
                         call_594225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594225, url, valid)

proc call*(call_594226: Call_CustomImagesCreateOrUpdate_594216;
          resourceGroupName: string; name: string; subscriptionId: string;
          customImage: JsonNode; labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594227 = newJObject()
  var query_594228 = newJObject()
  var body_594229 = newJObject()
  add(path_594227, "resourceGroupName", newJString(resourceGroupName))
  add(query_594228, "api-version", newJString(apiVersion))
  add(path_594227, "name", newJString(name))
  add(path_594227, "subscriptionId", newJString(subscriptionId))
  if customImage != nil:
    body_594229 = customImage
  add(path_594227, "labName", newJString(labName))
  result = call_594226.call(path_594227, query_594228, nil, nil, body_594229)

var customImagesCreateOrUpdate* = Call_CustomImagesCreateOrUpdate_594216(
    name: "customImagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesCreateOrUpdate_594217, base: "",
    url: url_CustomImagesCreateOrUpdate_594218, schemes: {Scheme.Https})
type
  Call_CustomImagesGet_594203 = ref object of OpenApiRestCall_593421
proc url_CustomImagesGet_594205(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesGet_594204(path: JsonNode; query: JsonNode;
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
  var valid_594206 = path.getOrDefault("resourceGroupName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "resourceGroupName", valid_594206
  var valid_594207 = path.getOrDefault("name")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "name", valid_594207
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
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=vm)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594210 = query.getOrDefault("$expand")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "$expand", valid_594210
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594211 = query.getOrDefault("api-version")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594211 != nil:
    section.add "api-version", valid_594211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594212: Call_CustomImagesGet_594203; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get custom image.
  ## 
  let valid = call_594212.validator(path, query, header, formData, body)
  let scheme = call_594212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594212.url(scheme.get, call_594212.host, call_594212.base,
                         call_594212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594212, url, valid)

proc call*(call_594213: Call_CustomImagesGet_594203; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594214 = newJObject()
  var query_594215 = newJObject()
  add(path_594214, "resourceGroupName", newJString(resourceGroupName))
  add(query_594215, "$expand", newJString(Expand))
  add(path_594214, "name", newJString(name))
  add(query_594215, "api-version", newJString(apiVersion))
  add(path_594214, "subscriptionId", newJString(subscriptionId))
  add(path_594214, "labName", newJString(labName))
  result = call_594213.call(path_594214, query_594215, nil, nil, nil)

var customImagesGet* = Call_CustomImagesGet_594203(name: "customImagesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesGet_594204, base: "", url: url_CustomImagesGet_594205,
    schemes: {Scheme.Https})
type
  Call_CustomImagesDelete_594230 = ref object of OpenApiRestCall_593421
proc url_CustomImagesDelete_594232(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesDelete_594231(path: JsonNode; query: JsonNode;
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
  var valid_594233 = path.getOrDefault("resourceGroupName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "resourceGroupName", valid_594233
  var valid_594234 = path.getOrDefault("name")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "name", valid_594234
  var valid_594235 = path.getOrDefault("subscriptionId")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "subscriptionId", valid_594235
  var valid_594236 = path.getOrDefault("labName")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "labName", valid_594236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594237 = query.getOrDefault("api-version")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594237 != nil:
    section.add "api-version", valid_594237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594238: Call_CustomImagesDelete_594230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  let valid = call_594238.validator(path, query, header, formData, body)
  let scheme = call_594238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594238.url(scheme.get, call_594238.host, call_594238.base,
                         call_594238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594238, url, valid)

proc call*(call_594239: Call_CustomImagesDelete_594230; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594240 = newJObject()
  var query_594241 = newJObject()
  add(path_594240, "resourceGroupName", newJString(resourceGroupName))
  add(query_594241, "api-version", newJString(apiVersion))
  add(path_594240, "name", newJString(name))
  add(path_594240, "subscriptionId", newJString(subscriptionId))
  add(path_594240, "labName", newJString(labName))
  result = call_594239.call(path_594240, query_594241, nil, nil, nil)

var customImagesDelete* = Call_CustomImagesDelete_594230(
    name: "customImagesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesDelete_594231, base: "",
    url: url_CustomImagesDelete_594232, schemes: {Scheme.Https})
type
  Call_FormulasList_594242 = ref object of OpenApiRestCall_593421
proc url_FormulasList_594244(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasList_594243(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594245 = path.getOrDefault("resourceGroupName")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "resourceGroupName", valid_594245
  var valid_594246 = path.getOrDefault("subscriptionId")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "subscriptionId", valid_594246
  var valid_594247 = path.getOrDefault("labName")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "labName", valid_594247
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594248 = query.getOrDefault("$orderby")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "$orderby", valid_594248
  var valid_594249 = query.getOrDefault("$expand")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "$expand", valid_594249
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594250 = query.getOrDefault("api-version")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594250 != nil:
    section.add "api-version", valid_594250
  var valid_594251 = query.getOrDefault("$top")
  valid_594251 = validateParameter(valid_594251, JInt, required = false, default = nil)
  if valid_594251 != nil:
    section.add "$top", valid_594251
  var valid_594252 = query.getOrDefault("$filter")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "$filter", valid_594252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594253: Call_FormulasList_594242; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List formulas in a given lab.
  ## 
  let valid = call_594253.validator(path, query, header, formData, body)
  let scheme = call_594253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594253.url(scheme.get, call_594253.host, call_594253.base,
                         call_594253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594253, url, valid)

proc call*(call_594254: Call_FormulasList_594242; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## formulasList
  ## List formulas in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594255 = newJObject()
  var query_594256 = newJObject()
  add(query_594256, "$orderby", newJString(Orderby))
  add(path_594255, "resourceGroupName", newJString(resourceGroupName))
  add(query_594256, "$expand", newJString(Expand))
  add(query_594256, "api-version", newJString(apiVersion))
  add(path_594255, "subscriptionId", newJString(subscriptionId))
  add(query_594256, "$top", newJInt(Top))
  add(path_594255, "labName", newJString(labName))
  add(query_594256, "$filter", newJString(Filter))
  result = call_594254.call(path_594255, query_594256, nil, nil, nil)

var formulasList* = Call_FormulasList_594242(name: "formulasList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas",
    validator: validate_FormulasList_594243, base: "", url: url_FormulasList_594244,
    schemes: {Scheme.Https})
type
  Call_FormulasCreateOrUpdate_594270 = ref object of OpenApiRestCall_593421
proc url_FormulasCreateOrUpdate_594272(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasCreateOrUpdate_594271(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Formula. This operation can take a while to complete.
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
  var valid_594273 = path.getOrDefault("resourceGroupName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "resourceGroupName", valid_594273
  var valid_594274 = path.getOrDefault("name")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "name", valid_594274
  var valid_594275 = path.getOrDefault("subscriptionId")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "subscriptionId", valid_594275
  var valid_594276 = path.getOrDefault("labName")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "labName", valid_594276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594277 = query.getOrDefault("api-version")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594277 != nil:
    section.add "api-version", valid_594277
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

proc call*(call_594279: Call_FormulasCreateOrUpdate_594270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ## 
  let valid = call_594279.validator(path, query, header, formData, body)
  let scheme = call_594279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594279.url(scheme.get, call_594279.host, call_594279.base,
                         call_594279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594279, url, valid)

proc call*(call_594280: Call_FormulasCreateOrUpdate_594270;
          resourceGroupName: string; formula: JsonNode; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## formulasCreateOrUpdate
  ## Create or replace an existing Formula. This operation can take a while to complete.
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
  var path_594281 = newJObject()
  var query_594282 = newJObject()
  var body_594283 = newJObject()
  add(path_594281, "resourceGroupName", newJString(resourceGroupName))
  if formula != nil:
    body_594283 = formula
  add(query_594282, "api-version", newJString(apiVersion))
  add(path_594281, "name", newJString(name))
  add(path_594281, "subscriptionId", newJString(subscriptionId))
  add(path_594281, "labName", newJString(labName))
  result = call_594280.call(path_594281, query_594282, nil, nil, body_594283)

var formulasCreateOrUpdate* = Call_FormulasCreateOrUpdate_594270(
    name: "formulasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasCreateOrUpdate_594271, base: "",
    url: url_FormulasCreateOrUpdate_594272, schemes: {Scheme.Https})
type
  Call_FormulasGet_594257 = ref object of OpenApiRestCall_593421
proc url_FormulasGet_594259(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasGet_594258(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594260 = path.getOrDefault("resourceGroupName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "resourceGroupName", valid_594260
  var valid_594261 = path.getOrDefault("name")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "name", valid_594261
  var valid_594262 = path.getOrDefault("subscriptionId")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "subscriptionId", valid_594262
  var valid_594263 = path.getOrDefault("labName")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "labName", valid_594263
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594264 = query.getOrDefault("$expand")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "$expand", valid_594264
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594265 = query.getOrDefault("api-version")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594265 != nil:
    section.add "api-version", valid_594265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594266: Call_FormulasGet_594257; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get formula.
  ## 
  let valid = call_594266.validator(path, query, header, formData, body)
  let scheme = call_594266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594266.url(scheme.get, call_594266.host, call_594266.base,
                         call_594266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594266, url, valid)

proc call*(call_594267: Call_FormulasGet_594257; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594268 = newJObject()
  var query_594269 = newJObject()
  add(path_594268, "resourceGroupName", newJString(resourceGroupName))
  add(query_594269, "$expand", newJString(Expand))
  add(path_594268, "name", newJString(name))
  add(query_594269, "api-version", newJString(apiVersion))
  add(path_594268, "subscriptionId", newJString(subscriptionId))
  add(path_594268, "labName", newJString(labName))
  result = call_594267.call(path_594268, query_594269, nil, nil, nil)

var formulasGet* = Call_FormulasGet_594257(name: "formulasGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
                                        validator: validate_FormulasGet_594258,
                                        base: "", url: url_FormulasGet_594259,
                                        schemes: {Scheme.Https})
type
  Call_FormulasDelete_594284 = ref object of OpenApiRestCall_593421
proc url_FormulasDelete_594286(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasDelete_594285(path: JsonNode; query: JsonNode;
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
  var valid_594287 = path.getOrDefault("resourceGroupName")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "resourceGroupName", valid_594287
  var valid_594288 = path.getOrDefault("name")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "name", valid_594288
  var valid_594289 = path.getOrDefault("subscriptionId")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "subscriptionId", valid_594289
  var valid_594290 = path.getOrDefault("labName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "labName", valid_594290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594291 = query.getOrDefault("api-version")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594291 != nil:
    section.add "api-version", valid_594291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594292: Call_FormulasDelete_594284; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete formula.
  ## 
  let valid = call_594292.validator(path, query, header, formData, body)
  let scheme = call_594292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594292.url(scheme.get, call_594292.host, call_594292.base,
                         call_594292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594292, url, valid)

proc call*(call_594293: Call_FormulasDelete_594284; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594294 = newJObject()
  var query_594295 = newJObject()
  add(path_594294, "resourceGroupName", newJString(resourceGroupName))
  add(query_594295, "api-version", newJString(apiVersion))
  add(path_594294, "name", newJString(name))
  add(path_594294, "subscriptionId", newJString(subscriptionId))
  add(path_594294, "labName", newJString(labName))
  result = call_594293.call(path_594294, query_594295, nil, nil, nil)

var formulasDelete* = Call_FormulasDelete_594284(name: "formulasDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasDelete_594285, base: "", url: url_FormulasDelete_594286,
    schemes: {Scheme.Https})
type
  Call_GalleryImagesList_594296 = ref object of OpenApiRestCall_593421
proc url_GalleryImagesList_594298(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImagesList_594297(path: JsonNode; query: JsonNode;
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
  var valid_594299 = path.getOrDefault("resourceGroupName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "resourceGroupName", valid_594299
  var valid_594300 = path.getOrDefault("subscriptionId")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "subscriptionId", valid_594300
  var valid_594301 = path.getOrDefault("labName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "labName", valid_594301
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=author)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594302 = query.getOrDefault("$orderby")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "$orderby", valid_594302
  var valid_594303 = query.getOrDefault("$expand")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "$expand", valid_594303
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594304 = query.getOrDefault("api-version")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594304 != nil:
    section.add "api-version", valid_594304
  var valid_594305 = query.getOrDefault("$top")
  valid_594305 = validateParameter(valid_594305, JInt, required = false, default = nil)
  if valid_594305 != nil:
    section.add "$top", valid_594305
  var valid_594306 = query.getOrDefault("$filter")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "$filter", valid_594306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594307: Call_GalleryImagesList_594296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery images in a given lab.
  ## 
  let valid = call_594307.validator(path, query, header, formData, body)
  let scheme = call_594307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594307.url(scheme.get, call_594307.host, call_594307.base,
                         call_594307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594307, url, valid)

proc call*(call_594308: Call_GalleryImagesList_594296; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## galleryImagesList
  ## List gallery images in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=author)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594309 = newJObject()
  var query_594310 = newJObject()
  add(query_594310, "$orderby", newJString(Orderby))
  add(path_594309, "resourceGroupName", newJString(resourceGroupName))
  add(query_594310, "$expand", newJString(Expand))
  add(query_594310, "api-version", newJString(apiVersion))
  add(path_594309, "subscriptionId", newJString(subscriptionId))
  add(query_594310, "$top", newJInt(Top))
  add(path_594309, "labName", newJString(labName))
  add(query_594310, "$filter", newJString(Filter))
  result = call_594308.call(path_594309, query_594310, nil, nil, nil)

var galleryImagesList* = Call_GalleryImagesList_594296(name: "galleryImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/galleryimages",
    validator: validate_GalleryImagesList_594297, base: "",
    url: url_GalleryImagesList_594298, schemes: {Scheme.Https})
type
  Call_NotificationChannelsList_594311 = ref object of OpenApiRestCall_593421
proc url_NotificationChannelsList_594313(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsList_594312(path: JsonNode; query: JsonNode;
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
  var valid_594314 = path.getOrDefault("resourceGroupName")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "resourceGroupName", valid_594314
  var valid_594315 = path.getOrDefault("subscriptionId")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "subscriptionId", valid_594315
  var valid_594316 = path.getOrDefault("labName")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "labName", valid_594316
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594317 = query.getOrDefault("$orderby")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "$orderby", valid_594317
  var valid_594318 = query.getOrDefault("$expand")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "$expand", valid_594318
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594319 = query.getOrDefault("api-version")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594319 != nil:
    section.add "api-version", valid_594319
  var valid_594320 = query.getOrDefault("$top")
  valid_594320 = validateParameter(valid_594320, JInt, required = false, default = nil)
  if valid_594320 != nil:
    section.add "$top", valid_594320
  var valid_594321 = query.getOrDefault("$filter")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "$filter", valid_594321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594322: Call_NotificationChannelsList_594311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List notification channels in a given lab.
  ## 
  let valid = call_594322.validator(path, query, header, formData, body)
  let scheme = call_594322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594322.url(scheme.get, call_594322.host, call_594322.base,
                         call_594322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594322, url, valid)

proc call*(call_594323: Call_NotificationChannelsList_594311;
          resourceGroupName: string; subscriptionId: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## notificationChannelsList
  ## List notification channels in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594324 = newJObject()
  var query_594325 = newJObject()
  add(query_594325, "$orderby", newJString(Orderby))
  add(path_594324, "resourceGroupName", newJString(resourceGroupName))
  add(query_594325, "$expand", newJString(Expand))
  add(query_594325, "api-version", newJString(apiVersion))
  add(path_594324, "subscriptionId", newJString(subscriptionId))
  add(query_594325, "$top", newJInt(Top))
  add(path_594324, "labName", newJString(labName))
  add(query_594325, "$filter", newJString(Filter))
  result = call_594323.call(path_594324, query_594325, nil, nil, nil)

var notificationChannelsList* = Call_NotificationChannelsList_594311(
    name: "notificationChannelsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels",
    validator: validate_NotificationChannelsList_594312, base: "",
    url: url_NotificationChannelsList_594313, schemes: {Scheme.Https})
type
  Call_NotificationChannelsCreateOrUpdate_594339 = ref object of OpenApiRestCall_593421
proc url_NotificationChannelsCreateOrUpdate_594341(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsCreateOrUpdate_594340(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing notificationChannel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594342 = path.getOrDefault("resourceGroupName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "resourceGroupName", valid_594342
  var valid_594343 = path.getOrDefault("name")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "name", valid_594343
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
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594346 = query.getOrDefault("api-version")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594346 != nil:
    section.add "api-version", valid_594346
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

proc call*(call_594348: Call_NotificationChannelsCreateOrUpdate_594339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing notificationChannel.
  ## 
  let valid = call_594348.validator(path, query, header, formData, body)
  let scheme = call_594348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594348.url(scheme.get, call_594348.host, call_594348.base,
                         call_594348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594348, url, valid)

proc call*(call_594349: Call_NotificationChannelsCreateOrUpdate_594339;
          notificationChannel: JsonNode; resourceGroupName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsCreateOrUpdate
  ## Create or replace an existing notificationChannel.
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594350 = newJObject()
  var query_594351 = newJObject()
  var body_594352 = newJObject()
  if notificationChannel != nil:
    body_594352 = notificationChannel
  add(path_594350, "resourceGroupName", newJString(resourceGroupName))
  add(query_594351, "api-version", newJString(apiVersion))
  add(path_594350, "name", newJString(name))
  add(path_594350, "subscriptionId", newJString(subscriptionId))
  add(path_594350, "labName", newJString(labName))
  result = call_594349.call(path_594350, query_594351, nil, nil, body_594352)

var notificationChannelsCreateOrUpdate* = Call_NotificationChannelsCreateOrUpdate_594339(
    name: "notificationChannelsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsCreateOrUpdate_594340, base: "",
    url: url_NotificationChannelsCreateOrUpdate_594341, schemes: {Scheme.Https})
type
  Call_NotificationChannelsGet_594326 = ref object of OpenApiRestCall_593421
proc url_NotificationChannelsGet_594328(protocol: Scheme; host: string; base: string;
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

proc validate_NotificationChannelsGet_594327(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get notification channels.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
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
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594333 = query.getOrDefault("$expand")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "$expand", valid_594333
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594334 = query.getOrDefault("api-version")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594334 != nil:
    section.add "api-version", valid_594334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594335: Call_NotificationChannelsGet_594326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get notification channels.
  ## 
  let valid = call_594335.validator(path, query, header, formData, body)
  let scheme = call_594335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594335.url(scheme.get, call_594335.host, call_594335.base,
                         call_594335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594335, url, valid)

proc call*(call_594336: Call_NotificationChannelsGet_594326;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsGet
  ## Get notification channels.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594337 = newJObject()
  var query_594338 = newJObject()
  add(path_594337, "resourceGroupName", newJString(resourceGroupName))
  add(query_594338, "$expand", newJString(Expand))
  add(path_594337, "name", newJString(name))
  add(query_594338, "api-version", newJString(apiVersion))
  add(path_594337, "subscriptionId", newJString(subscriptionId))
  add(path_594337, "labName", newJString(labName))
  result = call_594336.call(path_594337, query_594338, nil, nil, nil)

var notificationChannelsGet* = Call_NotificationChannelsGet_594326(
    name: "notificationChannelsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsGet_594327, base: "",
    url: url_NotificationChannelsGet_594328, schemes: {Scheme.Https})
type
  Call_NotificationChannelsUpdate_594365 = ref object of OpenApiRestCall_593421
proc url_NotificationChannelsUpdate_594367(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsUpdate_594366(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of notification channels.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594368 = path.getOrDefault("resourceGroupName")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "resourceGroupName", valid_594368
  var valid_594369 = path.getOrDefault("name")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "name", valid_594369
  var valid_594370 = path.getOrDefault("subscriptionId")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "subscriptionId", valid_594370
  var valid_594371 = path.getOrDefault("labName")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "labName", valid_594371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594372 = query.getOrDefault("api-version")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594372 != nil:
    section.add "api-version", valid_594372
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

proc call*(call_594374: Call_NotificationChannelsUpdate_594365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of notification channels.
  ## 
  let valid = call_594374.validator(path, query, header, formData, body)
  let scheme = call_594374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594374.url(scheme.get, call_594374.host, call_594374.base,
                         call_594374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594374, url, valid)

proc call*(call_594375: Call_NotificationChannelsUpdate_594365;
          notificationChannel: JsonNode; resourceGroupName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsUpdate
  ## Modify properties of notification channels.
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594376 = newJObject()
  var query_594377 = newJObject()
  var body_594378 = newJObject()
  if notificationChannel != nil:
    body_594378 = notificationChannel
  add(path_594376, "resourceGroupName", newJString(resourceGroupName))
  add(query_594377, "api-version", newJString(apiVersion))
  add(path_594376, "name", newJString(name))
  add(path_594376, "subscriptionId", newJString(subscriptionId))
  add(path_594376, "labName", newJString(labName))
  result = call_594375.call(path_594376, query_594377, nil, nil, body_594378)

var notificationChannelsUpdate* = Call_NotificationChannelsUpdate_594365(
    name: "notificationChannelsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsUpdate_594366, base: "",
    url: url_NotificationChannelsUpdate_594367, schemes: {Scheme.Https})
type
  Call_NotificationChannelsDelete_594353 = ref object of OpenApiRestCall_593421
proc url_NotificationChannelsDelete_594355(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsDelete_594354(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete notification channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594356 = path.getOrDefault("resourceGroupName")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "resourceGroupName", valid_594356
  var valid_594357 = path.getOrDefault("name")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "name", valid_594357
  var valid_594358 = path.getOrDefault("subscriptionId")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "subscriptionId", valid_594358
  var valid_594359 = path.getOrDefault("labName")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "labName", valid_594359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594360 = query.getOrDefault("api-version")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594360 != nil:
    section.add "api-version", valid_594360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594361: Call_NotificationChannelsDelete_594353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete notification channel.
  ## 
  let valid = call_594361.validator(path, query, header, formData, body)
  let scheme = call_594361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594361.url(scheme.get, call_594361.host, call_594361.base,
                         call_594361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594361, url, valid)

proc call*(call_594362: Call_NotificationChannelsDelete_594353;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsDelete
  ## Delete notification channel.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594363 = newJObject()
  var query_594364 = newJObject()
  add(path_594363, "resourceGroupName", newJString(resourceGroupName))
  add(query_594364, "api-version", newJString(apiVersion))
  add(path_594363, "name", newJString(name))
  add(path_594363, "subscriptionId", newJString(subscriptionId))
  add(path_594363, "labName", newJString(labName))
  result = call_594362.call(path_594363, query_594364, nil, nil, nil)

var notificationChannelsDelete* = Call_NotificationChannelsDelete_594353(
    name: "notificationChannelsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsDelete_594354, base: "",
    url: url_NotificationChannelsDelete_594355, schemes: {Scheme.Https})
type
  Call_NotificationChannelsNotify_594379 = ref object of OpenApiRestCall_593421
proc url_NotificationChannelsNotify_594381(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsNotify_594380(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send notification to provided channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594382 = path.getOrDefault("resourceGroupName")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "resourceGroupName", valid_594382
  var valid_594383 = path.getOrDefault("name")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "name", valid_594383
  var valid_594384 = path.getOrDefault("subscriptionId")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "subscriptionId", valid_594384
  var valid_594385 = path.getOrDefault("labName")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "labName", valid_594385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594386 = query.getOrDefault("api-version")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594386 != nil:
    section.add "api-version", valid_594386
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

proc call*(call_594388: Call_NotificationChannelsNotify_594379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send notification to provided channel.
  ## 
  let valid = call_594388.validator(path, query, header, formData, body)
  let scheme = call_594388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594388.url(scheme.get, call_594388.host, call_594388.base,
                         call_594388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594388, url, valid)

proc call*(call_594389: Call_NotificationChannelsNotify_594379;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; notifyParameters: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsNotify
  ## Send notification to provided channel.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   notifyParameters: JObject (required)
  ##                   : Properties for generating a Notification.
  var path_594390 = newJObject()
  var query_594391 = newJObject()
  var body_594392 = newJObject()
  add(path_594390, "resourceGroupName", newJString(resourceGroupName))
  add(query_594391, "api-version", newJString(apiVersion))
  add(path_594390, "name", newJString(name))
  add(path_594390, "subscriptionId", newJString(subscriptionId))
  add(path_594390, "labName", newJString(labName))
  if notifyParameters != nil:
    body_594392 = notifyParameters
  result = call_594389.call(path_594390, query_594391, nil, nil, body_594392)

var notificationChannelsNotify* = Call_NotificationChannelsNotify_594379(
    name: "notificationChannelsNotify", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}/notify",
    validator: validate_NotificationChannelsNotify_594380, base: "",
    url: url_NotificationChannelsNotify_594381, schemes: {Scheme.Https})
type
  Call_PolicySetsEvaluatePolicies_594393 = ref object of OpenApiRestCall_593421
proc url_PolicySetsEvaluatePolicies_594395(protocol: Scheme; host: string;
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

proc validate_PolicySetsEvaluatePolicies_594394(path: JsonNode; query: JsonNode;
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
  var valid_594396 = path.getOrDefault("resourceGroupName")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "resourceGroupName", valid_594396
  var valid_594397 = path.getOrDefault("name")
  valid_594397 = validateParameter(valid_594397, JString, required = true,
                                 default = nil)
  if valid_594397 != nil:
    section.add "name", valid_594397
  var valid_594398 = path.getOrDefault("subscriptionId")
  valid_594398 = validateParameter(valid_594398, JString, required = true,
                                 default = nil)
  if valid_594398 != nil:
    section.add "subscriptionId", valid_594398
  var valid_594399 = path.getOrDefault("labName")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "labName", valid_594399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594400 = query.getOrDefault("api-version")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594400 != nil:
    section.add "api-version", valid_594400
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

proc call*(call_594402: Call_PolicySetsEvaluatePolicies_594393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Evaluates lab policy.
  ## 
  let valid = call_594402.validator(path, query, header, formData, body)
  let scheme = call_594402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594402.url(scheme.get, call_594402.host, call_594402.base,
                         call_594402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594402, url, valid)

proc call*(call_594403: Call_PolicySetsEvaluatePolicies_594393;
          resourceGroupName: string; name: string; subscriptionId: string;
          evaluatePoliciesRequest: JsonNode; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594404 = newJObject()
  var query_594405 = newJObject()
  var body_594406 = newJObject()
  add(path_594404, "resourceGroupName", newJString(resourceGroupName))
  add(query_594405, "api-version", newJString(apiVersion))
  add(path_594404, "name", newJString(name))
  add(path_594404, "subscriptionId", newJString(subscriptionId))
  if evaluatePoliciesRequest != nil:
    body_594406 = evaluatePoliciesRequest
  add(path_594404, "labName", newJString(labName))
  result = call_594403.call(path_594404, query_594405, nil, nil, body_594406)

var policySetsEvaluatePolicies* = Call_PolicySetsEvaluatePolicies_594393(
    name: "policySetsEvaluatePolicies", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{name}/evaluatePolicies",
    validator: validate_PolicySetsEvaluatePolicies_594394, base: "",
    url: url_PolicySetsEvaluatePolicies_594395, schemes: {Scheme.Https})
type
  Call_PoliciesList_594407 = ref object of OpenApiRestCall_593421
proc url_PoliciesList_594409(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesList_594408(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594410 = path.getOrDefault("resourceGroupName")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "resourceGroupName", valid_594410
  var valid_594411 = path.getOrDefault("subscriptionId")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "subscriptionId", valid_594411
  var valid_594412 = path.getOrDefault("policySetName")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "policySetName", valid_594412
  var valid_594413 = path.getOrDefault("labName")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "labName", valid_594413
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594414 = query.getOrDefault("$orderby")
  valid_594414 = validateParameter(valid_594414, JString, required = false,
                                 default = nil)
  if valid_594414 != nil:
    section.add "$orderby", valid_594414
  var valid_594415 = query.getOrDefault("$expand")
  valid_594415 = validateParameter(valid_594415, JString, required = false,
                                 default = nil)
  if valid_594415 != nil:
    section.add "$expand", valid_594415
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594416 = query.getOrDefault("api-version")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594416 != nil:
    section.add "api-version", valid_594416
  var valid_594417 = query.getOrDefault("$top")
  valid_594417 = validateParameter(valid_594417, JInt, required = false, default = nil)
  if valid_594417 != nil:
    section.add "$top", valid_594417
  var valid_594418 = query.getOrDefault("$filter")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = nil)
  if valid_594418 != nil:
    section.add "$filter", valid_594418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594419: Call_PoliciesList_594407; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List policies in a given policy set.
  ## 
  let valid = call_594419.validator(path, query, header, formData, body)
  let scheme = call_594419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594419.url(scheme.get, call_594419.host, call_594419.base,
                         call_594419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594419, url, valid)

proc call*(call_594420: Call_PoliciesList_594407; resourceGroupName: string;
          subscriptionId: string; policySetName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## policiesList
  ## List policies in a given policy set.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594421 = newJObject()
  var query_594422 = newJObject()
  add(query_594422, "$orderby", newJString(Orderby))
  add(path_594421, "resourceGroupName", newJString(resourceGroupName))
  add(query_594422, "$expand", newJString(Expand))
  add(query_594422, "api-version", newJString(apiVersion))
  add(path_594421, "subscriptionId", newJString(subscriptionId))
  add(query_594422, "$top", newJInt(Top))
  add(path_594421, "policySetName", newJString(policySetName))
  add(path_594421, "labName", newJString(labName))
  add(query_594422, "$filter", newJString(Filter))
  result = call_594420.call(path_594421, query_594422, nil, nil, nil)

var policiesList* = Call_PoliciesList_594407(name: "policiesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies",
    validator: validate_PoliciesList_594408, base: "", url: url_PoliciesList_594409,
    schemes: {Scheme.Https})
type
  Call_PoliciesCreateOrUpdate_594437 = ref object of OpenApiRestCall_593421
proc url_PoliciesCreateOrUpdate_594439(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesCreateOrUpdate_594438(path: JsonNode; query: JsonNode;
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
  var valid_594443 = path.getOrDefault("policySetName")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "policySetName", valid_594443
  var valid_594444 = path.getOrDefault("labName")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "labName", valid_594444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594445 = query.getOrDefault("api-version")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594445 != nil:
    section.add "api-version", valid_594445
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

proc call*(call_594447: Call_PoliciesCreateOrUpdate_594437; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing policy.
  ## 
  let valid = call_594447.validator(path, query, header, formData, body)
  let scheme = call_594447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594447.url(scheme.get, call_594447.host, call_594447.base,
                         call_594447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594447, url, valid)

proc call*(call_594448: Call_PoliciesCreateOrUpdate_594437;
          resourceGroupName: string; name: string; subscriptionId: string;
          policySetName: string; labName: string; policy: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594449 = newJObject()
  var query_594450 = newJObject()
  var body_594451 = newJObject()
  add(path_594449, "resourceGroupName", newJString(resourceGroupName))
  add(query_594450, "api-version", newJString(apiVersion))
  add(path_594449, "name", newJString(name))
  add(path_594449, "subscriptionId", newJString(subscriptionId))
  add(path_594449, "policySetName", newJString(policySetName))
  add(path_594449, "labName", newJString(labName))
  if policy != nil:
    body_594451 = policy
  result = call_594448.call(path_594449, query_594450, nil, nil, body_594451)

var policiesCreateOrUpdate* = Call_PoliciesCreateOrUpdate_594437(
    name: "policiesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesCreateOrUpdate_594438, base: "",
    url: url_PoliciesCreateOrUpdate_594439, schemes: {Scheme.Https})
type
  Call_PoliciesGet_594423 = ref object of OpenApiRestCall_593421
proc url_PoliciesGet_594425(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesGet_594424(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594429 = path.getOrDefault("policySetName")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "policySetName", valid_594429
  var valid_594430 = path.getOrDefault("labName")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "labName", valid_594430
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594431 = query.getOrDefault("$expand")
  valid_594431 = validateParameter(valid_594431, JString, required = false,
                                 default = nil)
  if valid_594431 != nil:
    section.add "$expand", valid_594431
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594432 = query.getOrDefault("api-version")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594432 != nil:
    section.add "api-version", valid_594432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594433: Call_PoliciesGet_594423; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get policy.
  ## 
  let valid = call_594433.validator(path, query, header, formData, body)
  let scheme = call_594433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594433.url(scheme.get, call_594433.host, call_594433.base,
                         call_594433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594433, url, valid)

proc call*(call_594434: Call_PoliciesGet_594423; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594435 = newJObject()
  var query_594436 = newJObject()
  add(path_594435, "resourceGroupName", newJString(resourceGroupName))
  add(query_594436, "$expand", newJString(Expand))
  add(path_594435, "name", newJString(name))
  add(query_594436, "api-version", newJString(apiVersion))
  add(path_594435, "subscriptionId", newJString(subscriptionId))
  add(path_594435, "policySetName", newJString(policySetName))
  add(path_594435, "labName", newJString(labName))
  result = call_594434.call(path_594435, query_594436, nil, nil, nil)

var policiesGet* = Call_PoliciesGet_594423(name: "policiesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
                                        validator: validate_PoliciesGet_594424,
                                        base: "", url: url_PoliciesGet_594425,
                                        schemes: {Scheme.Https})
type
  Call_PoliciesUpdate_594465 = ref object of OpenApiRestCall_593421
proc url_PoliciesUpdate_594467(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesUpdate_594466(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Modify properties of policies.
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
  var valid_594468 = path.getOrDefault("resourceGroupName")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "resourceGroupName", valid_594468
  var valid_594469 = path.getOrDefault("name")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "name", valid_594469
  var valid_594470 = path.getOrDefault("subscriptionId")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "subscriptionId", valid_594470
  var valid_594471 = path.getOrDefault("policySetName")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "policySetName", valid_594471
  var valid_594472 = path.getOrDefault("labName")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "labName", valid_594472
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594473 = query.getOrDefault("api-version")
  valid_594473 = validateParameter(valid_594473, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594473 != nil:
    section.add "api-version", valid_594473
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

proc call*(call_594475: Call_PoliciesUpdate_594465; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of policies.
  ## 
  let valid = call_594475.validator(path, query, header, formData, body)
  let scheme = call_594475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594475.url(scheme.get, call_594475.host, call_594475.base,
                         call_594475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594475, url, valid)

proc call*(call_594476: Call_PoliciesUpdate_594465; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; policy: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## policiesUpdate
  ## Modify properties of policies.
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
  var path_594477 = newJObject()
  var query_594478 = newJObject()
  var body_594479 = newJObject()
  add(path_594477, "resourceGroupName", newJString(resourceGroupName))
  add(query_594478, "api-version", newJString(apiVersion))
  add(path_594477, "name", newJString(name))
  add(path_594477, "subscriptionId", newJString(subscriptionId))
  add(path_594477, "policySetName", newJString(policySetName))
  add(path_594477, "labName", newJString(labName))
  if policy != nil:
    body_594479 = policy
  result = call_594476.call(path_594477, query_594478, nil, nil, body_594479)

var policiesUpdate* = Call_PoliciesUpdate_594465(name: "policiesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesUpdate_594466, base: "", url: url_PoliciesUpdate_594467,
    schemes: {Scheme.Https})
type
  Call_PoliciesDelete_594452 = ref object of OpenApiRestCall_593421
proc url_PoliciesDelete_594454(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesDelete_594453(path: JsonNode; query: JsonNode;
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
  var valid_594455 = path.getOrDefault("resourceGroupName")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "resourceGroupName", valid_594455
  var valid_594456 = path.getOrDefault("name")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "name", valid_594456
  var valid_594457 = path.getOrDefault("subscriptionId")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = nil)
  if valid_594457 != nil:
    section.add "subscriptionId", valid_594457
  var valid_594458 = path.getOrDefault("policySetName")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "policySetName", valid_594458
  var valid_594459 = path.getOrDefault("labName")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "labName", valid_594459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594460 = query.getOrDefault("api-version")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594460 != nil:
    section.add "api-version", valid_594460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594461: Call_PoliciesDelete_594452; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy.
  ## 
  let valid = call_594461.validator(path, query, header, formData, body)
  let scheme = call_594461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594461.url(scheme.get, call_594461.host, call_594461.base,
                         call_594461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594461, url, valid)

proc call*(call_594462: Call_PoliciesDelete_594452; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594463 = newJObject()
  var query_594464 = newJObject()
  add(path_594463, "resourceGroupName", newJString(resourceGroupName))
  add(query_594464, "api-version", newJString(apiVersion))
  add(path_594463, "name", newJString(name))
  add(path_594463, "subscriptionId", newJString(subscriptionId))
  add(path_594463, "policySetName", newJString(policySetName))
  add(path_594463, "labName", newJString(labName))
  result = call_594462.call(path_594463, query_594464, nil, nil, nil)

var policiesDelete* = Call_PoliciesDelete_594452(name: "policiesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesDelete_594453, base: "", url: url_PoliciesDelete_594454,
    schemes: {Scheme.Https})
type
  Call_SchedulesList_594480 = ref object of OpenApiRestCall_593421
proc url_SchedulesList_594482(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesList_594481(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594483 = path.getOrDefault("resourceGroupName")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "resourceGroupName", valid_594483
  var valid_594484 = path.getOrDefault("subscriptionId")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = nil)
  if valid_594484 != nil:
    section.add "subscriptionId", valid_594484
  var valid_594485 = path.getOrDefault("labName")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "labName", valid_594485
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594486 = query.getOrDefault("$orderby")
  valid_594486 = validateParameter(valid_594486, JString, required = false,
                                 default = nil)
  if valid_594486 != nil:
    section.add "$orderby", valid_594486
  var valid_594487 = query.getOrDefault("$expand")
  valid_594487 = validateParameter(valid_594487, JString, required = false,
                                 default = nil)
  if valid_594487 != nil:
    section.add "$expand", valid_594487
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594488 = query.getOrDefault("api-version")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594488 != nil:
    section.add "api-version", valid_594488
  var valid_594489 = query.getOrDefault("$top")
  valid_594489 = validateParameter(valid_594489, JInt, required = false, default = nil)
  if valid_594489 != nil:
    section.add "$top", valid_594489
  var valid_594490 = query.getOrDefault("$filter")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = nil)
  if valid_594490 != nil:
    section.add "$filter", valid_594490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594491: Call_SchedulesList_594480; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given lab.
  ## 
  let valid = call_594491.validator(path, query, header, formData, body)
  let scheme = call_594491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594491.url(scheme.get, call_594491.host, call_594491.base,
                         call_594491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594491, url, valid)

proc call*(call_594492: Call_SchedulesList_594480; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## schedulesList
  ## List schedules in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594493 = newJObject()
  var query_594494 = newJObject()
  add(query_594494, "$orderby", newJString(Orderby))
  add(path_594493, "resourceGroupName", newJString(resourceGroupName))
  add(query_594494, "$expand", newJString(Expand))
  add(query_594494, "api-version", newJString(apiVersion))
  add(path_594493, "subscriptionId", newJString(subscriptionId))
  add(query_594494, "$top", newJInt(Top))
  add(path_594493, "labName", newJString(labName))
  add(query_594494, "$filter", newJString(Filter))
  result = call_594492.call(path_594493, query_594494, nil, nil, nil)

var schedulesList* = Call_SchedulesList_594480(name: "schedulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules",
    validator: validate_SchedulesList_594481, base: "", url: url_SchedulesList_594482,
    schemes: {Scheme.Https})
type
  Call_SchedulesCreateOrUpdate_594508 = ref object of OpenApiRestCall_593421
proc url_SchedulesCreateOrUpdate_594510(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesCreateOrUpdate_594509(path: JsonNode; query: JsonNode;
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
  var valid_594511 = path.getOrDefault("resourceGroupName")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "resourceGroupName", valid_594511
  var valid_594512 = path.getOrDefault("name")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "name", valid_594512
  var valid_594513 = path.getOrDefault("subscriptionId")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "subscriptionId", valid_594513
  var valid_594514 = path.getOrDefault("labName")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "labName", valid_594514
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594515 = query.getOrDefault("api-version")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594515 != nil:
    section.add "api-version", valid_594515
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

proc call*(call_594517: Call_SchedulesCreateOrUpdate_594508; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_594517.validator(path, query, header, formData, body)
  let scheme = call_594517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594517.url(scheme.get, call_594517.host, call_594517.base,
                         call_594517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594517, url, valid)

proc call*(call_594518: Call_SchedulesCreateOrUpdate_594508;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; schedule: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594519 = newJObject()
  var query_594520 = newJObject()
  var body_594521 = newJObject()
  add(path_594519, "resourceGroupName", newJString(resourceGroupName))
  add(query_594520, "api-version", newJString(apiVersion))
  add(path_594519, "name", newJString(name))
  add(path_594519, "subscriptionId", newJString(subscriptionId))
  add(path_594519, "labName", newJString(labName))
  if schedule != nil:
    body_594521 = schedule
  result = call_594518.call(path_594519, query_594520, nil, nil, body_594521)

var schedulesCreateOrUpdate* = Call_SchedulesCreateOrUpdate_594508(
    name: "schedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesCreateOrUpdate_594509, base: "",
    url: url_SchedulesCreateOrUpdate_594510, schemes: {Scheme.Https})
type
  Call_SchedulesGet_594495 = ref object of OpenApiRestCall_593421
proc url_SchedulesGet_594497(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesGet_594496(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594498 = path.getOrDefault("resourceGroupName")
  valid_594498 = validateParameter(valid_594498, JString, required = true,
                                 default = nil)
  if valid_594498 != nil:
    section.add "resourceGroupName", valid_594498
  var valid_594499 = path.getOrDefault("name")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "name", valid_594499
  var valid_594500 = path.getOrDefault("subscriptionId")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "subscriptionId", valid_594500
  var valid_594501 = path.getOrDefault("labName")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "labName", valid_594501
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594502 = query.getOrDefault("$expand")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = nil)
  if valid_594502 != nil:
    section.add "$expand", valid_594502
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594503 = query.getOrDefault("api-version")
  valid_594503 = validateParameter(valid_594503, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594503 != nil:
    section.add "api-version", valid_594503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594504: Call_SchedulesGet_594495; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_594504.validator(path, query, header, formData, body)
  let scheme = call_594504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594504.url(scheme.get, call_594504.host, call_594504.base,
                         call_594504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594504, url, valid)

proc call*(call_594505: Call_SchedulesGet_594495; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594506 = newJObject()
  var query_594507 = newJObject()
  add(path_594506, "resourceGroupName", newJString(resourceGroupName))
  add(query_594507, "$expand", newJString(Expand))
  add(path_594506, "name", newJString(name))
  add(query_594507, "api-version", newJString(apiVersion))
  add(path_594506, "subscriptionId", newJString(subscriptionId))
  add(path_594506, "labName", newJString(labName))
  result = call_594505.call(path_594506, query_594507, nil, nil, nil)

var schedulesGet* = Call_SchedulesGet_594495(name: "schedulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesGet_594496, base: "", url: url_SchedulesGet_594497,
    schemes: {Scheme.Https})
type
  Call_SchedulesUpdate_594534 = ref object of OpenApiRestCall_593421
proc url_SchedulesUpdate_594536(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesUpdate_594535(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Modify properties of schedules.
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
  var valid_594537 = path.getOrDefault("resourceGroupName")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "resourceGroupName", valid_594537
  var valid_594538 = path.getOrDefault("name")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "name", valid_594538
  var valid_594539 = path.getOrDefault("subscriptionId")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "subscriptionId", valid_594539
  var valid_594540 = path.getOrDefault("labName")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "labName", valid_594540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594541 = query.getOrDefault("api-version")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594541 != nil:
    section.add "api-version", valid_594541
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

proc call*(call_594543: Call_SchedulesUpdate_594534; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of schedules.
  ## 
  let valid = call_594543.validator(path, query, header, formData, body)
  let scheme = call_594543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594543.url(scheme.get, call_594543.host, call_594543.base,
                         call_594543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594543, url, valid)

proc call*(call_594544: Call_SchedulesUpdate_594534; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; schedule: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## schedulesUpdate
  ## Modify properties of schedules.
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
  var path_594545 = newJObject()
  var query_594546 = newJObject()
  var body_594547 = newJObject()
  add(path_594545, "resourceGroupName", newJString(resourceGroupName))
  add(query_594546, "api-version", newJString(apiVersion))
  add(path_594545, "name", newJString(name))
  add(path_594545, "subscriptionId", newJString(subscriptionId))
  add(path_594545, "labName", newJString(labName))
  if schedule != nil:
    body_594547 = schedule
  result = call_594544.call(path_594545, query_594546, nil, nil, body_594547)

var schedulesUpdate* = Call_SchedulesUpdate_594534(name: "schedulesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesUpdate_594535, base: "", url: url_SchedulesUpdate_594536,
    schemes: {Scheme.Https})
type
  Call_SchedulesDelete_594522 = ref object of OpenApiRestCall_593421
proc url_SchedulesDelete_594524(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesDelete_594523(path: JsonNode; query: JsonNode;
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
  var valid_594525 = path.getOrDefault("resourceGroupName")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "resourceGroupName", valid_594525
  var valid_594526 = path.getOrDefault("name")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "name", valid_594526
  var valid_594527 = path.getOrDefault("subscriptionId")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "subscriptionId", valid_594527
  var valid_594528 = path.getOrDefault("labName")
  valid_594528 = validateParameter(valid_594528, JString, required = true,
                                 default = nil)
  if valid_594528 != nil:
    section.add "labName", valid_594528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594529 = query.getOrDefault("api-version")
  valid_594529 = validateParameter(valid_594529, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594529 != nil:
    section.add "api-version", valid_594529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594530: Call_SchedulesDelete_594522; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_594530.validator(path, query, header, formData, body)
  let scheme = call_594530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594530.url(scheme.get, call_594530.host, call_594530.base,
                         call_594530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594530, url, valid)

proc call*(call_594531: Call_SchedulesDelete_594522; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594532 = newJObject()
  var query_594533 = newJObject()
  add(path_594532, "resourceGroupName", newJString(resourceGroupName))
  add(query_594533, "api-version", newJString(apiVersion))
  add(path_594532, "name", newJString(name))
  add(path_594532, "subscriptionId", newJString(subscriptionId))
  add(path_594532, "labName", newJString(labName))
  result = call_594531.call(path_594532, query_594533, nil, nil, nil)

var schedulesDelete* = Call_SchedulesDelete_594522(name: "schedulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesDelete_594523, base: "", url: url_SchedulesDelete_594524,
    schemes: {Scheme.Https})
type
  Call_SchedulesExecute_594548 = ref object of OpenApiRestCall_593421
proc url_SchedulesExecute_594550(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesExecute_594549(path: JsonNode; query: JsonNode;
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
  var valid_594551 = path.getOrDefault("resourceGroupName")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "resourceGroupName", valid_594551
  var valid_594552 = path.getOrDefault("name")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "name", valid_594552
  var valid_594553 = path.getOrDefault("subscriptionId")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "subscriptionId", valid_594553
  var valid_594554 = path.getOrDefault("labName")
  valid_594554 = validateParameter(valid_594554, JString, required = true,
                                 default = nil)
  if valid_594554 != nil:
    section.add "labName", valid_594554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594555 = query.getOrDefault("api-version")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594555 != nil:
    section.add "api-version", valid_594555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594556: Call_SchedulesExecute_594548; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_594556.validator(path, query, header, formData, body)
  let scheme = call_594556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594556.url(scheme.get, call_594556.host, call_594556.base,
                         call_594556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594556, url, valid)

proc call*(call_594557: Call_SchedulesExecute_594548; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594558 = newJObject()
  var query_594559 = newJObject()
  add(path_594558, "resourceGroupName", newJString(resourceGroupName))
  add(query_594559, "api-version", newJString(apiVersion))
  add(path_594558, "name", newJString(name))
  add(path_594558, "subscriptionId", newJString(subscriptionId))
  add(path_594558, "labName", newJString(labName))
  result = call_594557.call(path_594558, query_594559, nil, nil, nil)

var schedulesExecute* = Call_SchedulesExecute_594548(name: "schedulesExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/execute",
    validator: validate_SchedulesExecute_594549, base: "",
    url: url_SchedulesExecute_594550, schemes: {Scheme.Https})
type
  Call_SchedulesListApplicable_594560 = ref object of OpenApiRestCall_593421
proc url_SchedulesListApplicable_594562(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesListApplicable_594561(path: JsonNode; query: JsonNode;
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
  var valid_594563 = path.getOrDefault("resourceGroupName")
  valid_594563 = validateParameter(valid_594563, JString, required = true,
                                 default = nil)
  if valid_594563 != nil:
    section.add "resourceGroupName", valid_594563
  var valid_594564 = path.getOrDefault("name")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "name", valid_594564
  var valid_594565 = path.getOrDefault("subscriptionId")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "subscriptionId", valid_594565
  var valid_594566 = path.getOrDefault("labName")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "labName", valid_594566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594567 = query.getOrDefault("api-version")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594567 != nil:
    section.add "api-version", valid_594567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594568: Call_SchedulesListApplicable_594560; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all applicable schedules
  ## 
  let valid = call_594568.validator(path, query, header, formData, body)
  let scheme = call_594568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594568.url(scheme.get, call_594568.host, call_594568.base,
                         call_594568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594568, url, valid)

proc call*(call_594569: Call_SchedulesListApplicable_594560;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594570 = newJObject()
  var query_594571 = newJObject()
  add(path_594570, "resourceGroupName", newJString(resourceGroupName))
  add(query_594571, "api-version", newJString(apiVersion))
  add(path_594570, "name", newJString(name))
  add(path_594570, "subscriptionId", newJString(subscriptionId))
  add(path_594570, "labName", newJString(labName))
  result = call_594569.call(path_594570, query_594571, nil, nil, nil)

var schedulesListApplicable* = Call_SchedulesListApplicable_594560(
    name: "schedulesListApplicable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/listApplicable",
    validator: validate_SchedulesListApplicable_594561, base: "",
    url: url_SchedulesListApplicable_594562, schemes: {Scheme.Https})
type
  Call_ServiceRunnersList_594572 = ref object of OpenApiRestCall_593421
proc url_ServiceRunnersList_594574(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/servicerunners")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceRunnersList_594573(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List service runners in a given lab.
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
  var valid_594575 = path.getOrDefault("resourceGroupName")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "resourceGroupName", valid_594575
  var valid_594576 = path.getOrDefault("subscriptionId")
  valid_594576 = validateParameter(valid_594576, JString, required = true,
                                 default = nil)
  if valid_594576 != nil:
    section.add "subscriptionId", valid_594576
  var valid_594577 = path.getOrDefault("labName")
  valid_594577 = validateParameter(valid_594577, JString, required = true,
                                 default = nil)
  if valid_594577 != nil:
    section.add "labName", valid_594577
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594578 = query.getOrDefault("$orderby")
  valid_594578 = validateParameter(valid_594578, JString, required = false,
                                 default = nil)
  if valid_594578 != nil:
    section.add "$orderby", valid_594578
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594579 = query.getOrDefault("api-version")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594579 != nil:
    section.add "api-version", valid_594579
  var valid_594580 = query.getOrDefault("$top")
  valid_594580 = validateParameter(valid_594580, JInt, required = false, default = nil)
  if valid_594580 != nil:
    section.add "$top", valid_594580
  var valid_594581 = query.getOrDefault("$filter")
  valid_594581 = validateParameter(valid_594581, JString, required = false,
                                 default = nil)
  if valid_594581 != nil:
    section.add "$filter", valid_594581
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594582: Call_ServiceRunnersList_594572; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List service runners in a given lab.
  ## 
  let valid = call_594582.validator(path, query, header, formData, body)
  let scheme = call_594582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594582.url(scheme.get, call_594582.host, call_594582.base,
                         call_594582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594582, url, valid)

proc call*(call_594583: Call_ServiceRunnersList_594572; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          apiVersion: string = "2016-05-15"; Top: int = 0; Filter: string = ""): Recallable =
  ## serviceRunnersList
  ## List service runners in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594584 = newJObject()
  var query_594585 = newJObject()
  add(query_594585, "$orderby", newJString(Orderby))
  add(path_594584, "resourceGroupName", newJString(resourceGroupName))
  add(query_594585, "api-version", newJString(apiVersion))
  add(path_594584, "subscriptionId", newJString(subscriptionId))
  add(query_594585, "$top", newJInt(Top))
  add(path_594584, "labName", newJString(labName))
  add(query_594585, "$filter", newJString(Filter))
  result = call_594583.call(path_594584, query_594585, nil, nil, nil)

var serviceRunnersList* = Call_ServiceRunnersList_594572(
    name: "serviceRunnersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners",
    validator: validate_ServiceRunnersList_594573, base: "",
    url: url_ServiceRunnersList_594574, schemes: {Scheme.Https})
type
  Call_ServiceRunnersCreateOrUpdate_594598 = ref object of OpenApiRestCall_593421
proc url_ServiceRunnersCreateOrUpdate_594600(protocol: Scheme; host: string;
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

proc validate_ServiceRunnersCreateOrUpdate_594599(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Service runner.
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
  var valid_594601 = path.getOrDefault("resourceGroupName")
  valid_594601 = validateParameter(valid_594601, JString, required = true,
                                 default = nil)
  if valid_594601 != nil:
    section.add "resourceGroupName", valid_594601
  var valid_594602 = path.getOrDefault("name")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = nil)
  if valid_594602 != nil:
    section.add "name", valid_594602
  var valid_594603 = path.getOrDefault("subscriptionId")
  valid_594603 = validateParameter(valid_594603, JString, required = true,
                                 default = nil)
  if valid_594603 != nil:
    section.add "subscriptionId", valid_594603
  var valid_594604 = path.getOrDefault("labName")
  valid_594604 = validateParameter(valid_594604, JString, required = true,
                                 default = nil)
  if valid_594604 != nil:
    section.add "labName", valid_594604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594605 = query.getOrDefault("api-version")
  valid_594605 = validateParameter(valid_594605, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594605 != nil:
    section.add "api-version", valid_594605
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

proc call*(call_594607: Call_ServiceRunnersCreateOrUpdate_594598; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Service runner.
  ## 
  let valid = call_594607.validator(path, query, header, formData, body)
  let scheme = call_594607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594607.url(scheme.get, call_594607.host, call_594607.base,
                         call_594607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594607, url, valid)

proc call*(call_594608: Call_ServiceRunnersCreateOrUpdate_594598;
          resourceGroupName: string; name: string; subscriptionId: string;
          serviceRunner: JsonNode; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## serviceRunnersCreateOrUpdate
  ## Create or replace an existing Service runner.
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
  var path_594609 = newJObject()
  var query_594610 = newJObject()
  var body_594611 = newJObject()
  add(path_594609, "resourceGroupName", newJString(resourceGroupName))
  add(query_594610, "api-version", newJString(apiVersion))
  add(path_594609, "name", newJString(name))
  add(path_594609, "subscriptionId", newJString(subscriptionId))
  if serviceRunner != nil:
    body_594611 = serviceRunner
  add(path_594609, "labName", newJString(labName))
  result = call_594608.call(path_594609, query_594610, nil, nil, body_594611)

var serviceRunnersCreateOrUpdate* = Call_ServiceRunnersCreateOrUpdate_594598(
    name: "serviceRunnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersCreateOrUpdate_594599, base: "",
    url: url_ServiceRunnersCreateOrUpdate_594600, schemes: {Scheme.Https})
type
  Call_ServiceRunnersGet_594586 = ref object of OpenApiRestCall_593421
proc url_ServiceRunnersGet_594588(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceRunnersGet_594587(path: JsonNode; query: JsonNode;
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
  var valid_594589 = path.getOrDefault("resourceGroupName")
  valid_594589 = validateParameter(valid_594589, JString, required = true,
                                 default = nil)
  if valid_594589 != nil:
    section.add "resourceGroupName", valid_594589
  var valid_594590 = path.getOrDefault("name")
  valid_594590 = validateParameter(valid_594590, JString, required = true,
                                 default = nil)
  if valid_594590 != nil:
    section.add "name", valid_594590
  var valid_594591 = path.getOrDefault("subscriptionId")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "subscriptionId", valid_594591
  var valid_594592 = path.getOrDefault("labName")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = nil)
  if valid_594592 != nil:
    section.add "labName", valid_594592
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594593 = query.getOrDefault("api-version")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594593 != nil:
    section.add "api-version", valid_594593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594594: Call_ServiceRunnersGet_594586; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service runner.
  ## 
  let valid = call_594594.validator(path, query, header, formData, body)
  let scheme = call_594594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594594.url(scheme.get, call_594594.host, call_594594.base,
                         call_594594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594594, url, valid)

proc call*(call_594595: Call_ServiceRunnersGet_594586; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594596 = newJObject()
  var query_594597 = newJObject()
  add(path_594596, "resourceGroupName", newJString(resourceGroupName))
  add(query_594597, "api-version", newJString(apiVersion))
  add(path_594596, "name", newJString(name))
  add(path_594596, "subscriptionId", newJString(subscriptionId))
  add(path_594596, "labName", newJString(labName))
  result = call_594595.call(path_594596, query_594597, nil, nil, nil)

var serviceRunnersGet* = Call_ServiceRunnersGet_594586(name: "serviceRunnersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersGet_594587, base: "",
    url: url_ServiceRunnersGet_594588, schemes: {Scheme.Https})
type
  Call_ServiceRunnersDelete_594612 = ref object of OpenApiRestCall_593421
proc url_ServiceRunnersDelete_594614(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceRunnersDelete_594613(path: JsonNode; query: JsonNode;
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
  var valid_594615 = path.getOrDefault("resourceGroupName")
  valid_594615 = validateParameter(valid_594615, JString, required = true,
                                 default = nil)
  if valid_594615 != nil:
    section.add "resourceGroupName", valid_594615
  var valid_594616 = path.getOrDefault("name")
  valid_594616 = validateParameter(valid_594616, JString, required = true,
                                 default = nil)
  if valid_594616 != nil:
    section.add "name", valid_594616
  var valid_594617 = path.getOrDefault("subscriptionId")
  valid_594617 = validateParameter(valid_594617, JString, required = true,
                                 default = nil)
  if valid_594617 != nil:
    section.add "subscriptionId", valid_594617
  var valid_594618 = path.getOrDefault("labName")
  valid_594618 = validateParameter(valid_594618, JString, required = true,
                                 default = nil)
  if valid_594618 != nil:
    section.add "labName", valid_594618
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594619 = query.getOrDefault("api-version")
  valid_594619 = validateParameter(valid_594619, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594619 != nil:
    section.add "api-version", valid_594619
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594620: Call_ServiceRunnersDelete_594612; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete service runner.
  ## 
  let valid = call_594620.validator(path, query, header, formData, body)
  let scheme = call_594620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594620.url(scheme.get, call_594620.host, call_594620.base,
                         call_594620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594620, url, valid)

proc call*(call_594621: Call_ServiceRunnersDelete_594612;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594622 = newJObject()
  var query_594623 = newJObject()
  add(path_594622, "resourceGroupName", newJString(resourceGroupName))
  add(query_594623, "api-version", newJString(apiVersion))
  add(path_594622, "name", newJString(name))
  add(path_594622, "subscriptionId", newJString(subscriptionId))
  add(path_594622, "labName", newJString(labName))
  result = call_594621.call(path_594622, query_594623, nil, nil, nil)

var serviceRunnersDelete* = Call_ServiceRunnersDelete_594612(
    name: "serviceRunnersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersDelete_594613, base: "",
    url: url_ServiceRunnersDelete_594614, schemes: {Scheme.Https})
type
  Call_UsersList_594624 = ref object of OpenApiRestCall_593421
proc url_UsersList_594626(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersList_594625(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594627 = path.getOrDefault("resourceGroupName")
  valid_594627 = validateParameter(valid_594627, JString, required = true,
                                 default = nil)
  if valid_594627 != nil:
    section.add "resourceGroupName", valid_594627
  var valid_594628 = path.getOrDefault("subscriptionId")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "subscriptionId", valid_594628
  var valid_594629 = path.getOrDefault("labName")
  valid_594629 = validateParameter(valid_594629, JString, required = true,
                                 default = nil)
  if valid_594629 != nil:
    section.add "labName", valid_594629
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=identity)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594630 = query.getOrDefault("$orderby")
  valid_594630 = validateParameter(valid_594630, JString, required = false,
                                 default = nil)
  if valid_594630 != nil:
    section.add "$orderby", valid_594630
  var valid_594631 = query.getOrDefault("$expand")
  valid_594631 = validateParameter(valid_594631, JString, required = false,
                                 default = nil)
  if valid_594631 != nil:
    section.add "$expand", valid_594631
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594632 = query.getOrDefault("api-version")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594632 != nil:
    section.add "api-version", valid_594632
  var valid_594633 = query.getOrDefault("$top")
  valid_594633 = validateParameter(valid_594633, JInt, required = false, default = nil)
  if valid_594633 != nil:
    section.add "$top", valid_594633
  var valid_594634 = query.getOrDefault("$filter")
  valid_594634 = validateParameter(valid_594634, JString, required = false,
                                 default = nil)
  if valid_594634 != nil:
    section.add "$filter", valid_594634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594635: Call_UsersList_594624; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List user profiles in a given lab.
  ## 
  let valid = call_594635.validator(path, query, header, formData, body)
  let scheme = call_594635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594635.url(scheme.get, call_594635.host, call_594635.base,
                         call_594635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594635, url, valid)

proc call*(call_594636: Call_UsersList_594624; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## usersList
  ## List user profiles in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=identity)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594637 = newJObject()
  var query_594638 = newJObject()
  add(query_594638, "$orderby", newJString(Orderby))
  add(path_594637, "resourceGroupName", newJString(resourceGroupName))
  add(query_594638, "$expand", newJString(Expand))
  add(query_594638, "api-version", newJString(apiVersion))
  add(path_594637, "subscriptionId", newJString(subscriptionId))
  add(query_594638, "$top", newJInt(Top))
  add(path_594637, "labName", newJString(labName))
  add(query_594638, "$filter", newJString(Filter))
  result = call_594636.call(path_594637, query_594638, nil, nil, nil)

var usersList* = Call_UsersList_594624(name: "usersList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users",
                                    validator: validate_UsersList_594625,
                                    base: "", url: url_UsersList_594626,
                                    schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_594652 = ref object of OpenApiRestCall_593421
proc url_UsersCreateOrUpdate_594654(protocol: Scheme; host: string; base: string;
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

proc validate_UsersCreateOrUpdate_594653(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing user profile.
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
  var valid_594655 = path.getOrDefault("resourceGroupName")
  valid_594655 = validateParameter(valid_594655, JString, required = true,
                                 default = nil)
  if valid_594655 != nil:
    section.add "resourceGroupName", valid_594655
  var valid_594656 = path.getOrDefault("name")
  valid_594656 = validateParameter(valid_594656, JString, required = true,
                                 default = nil)
  if valid_594656 != nil:
    section.add "name", valid_594656
  var valid_594657 = path.getOrDefault("subscriptionId")
  valid_594657 = validateParameter(valid_594657, JString, required = true,
                                 default = nil)
  if valid_594657 != nil:
    section.add "subscriptionId", valid_594657
  var valid_594658 = path.getOrDefault("labName")
  valid_594658 = validateParameter(valid_594658, JString, required = true,
                                 default = nil)
  if valid_594658 != nil:
    section.add "labName", valid_594658
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594659 = query.getOrDefault("api-version")
  valid_594659 = validateParameter(valid_594659, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594659 != nil:
    section.add "api-version", valid_594659
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

proc call*(call_594661: Call_UsersCreateOrUpdate_594652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing user profile.
  ## 
  let valid = call_594661.validator(path, query, header, formData, body)
  let scheme = call_594661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594661.url(scheme.get, call_594661.host, call_594661.base,
                         call_594661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594661, url, valid)

proc call*(call_594662: Call_UsersCreateOrUpdate_594652; resourceGroupName: string;
          name: string; user: JsonNode; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## usersCreateOrUpdate
  ## Create or replace an existing user profile.
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
  var path_594663 = newJObject()
  var query_594664 = newJObject()
  var body_594665 = newJObject()
  add(path_594663, "resourceGroupName", newJString(resourceGroupName))
  add(query_594664, "api-version", newJString(apiVersion))
  add(path_594663, "name", newJString(name))
  if user != nil:
    body_594665 = user
  add(path_594663, "subscriptionId", newJString(subscriptionId))
  add(path_594663, "labName", newJString(labName))
  result = call_594662.call(path_594663, query_594664, nil, nil, body_594665)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_594652(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
    validator: validate_UsersCreateOrUpdate_594653, base: "",
    url: url_UsersCreateOrUpdate_594654, schemes: {Scheme.Https})
type
  Call_UsersGet_594639 = ref object of OpenApiRestCall_593421
proc url_UsersGet_594641(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersGet_594640(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594642 = path.getOrDefault("resourceGroupName")
  valid_594642 = validateParameter(valid_594642, JString, required = true,
                                 default = nil)
  if valid_594642 != nil:
    section.add "resourceGroupName", valid_594642
  var valid_594643 = path.getOrDefault("name")
  valid_594643 = validateParameter(valid_594643, JString, required = true,
                                 default = nil)
  if valid_594643 != nil:
    section.add "name", valid_594643
  var valid_594644 = path.getOrDefault("subscriptionId")
  valid_594644 = validateParameter(valid_594644, JString, required = true,
                                 default = nil)
  if valid_594644 != nil:
    section.add "subscriptionId", valid_594644
  var valid_594645 = path.getOrDefault("labName")
  valid_594645 = validateParameter(valid_594645, JString, required = true,
                                 default = nil)
  if valid_594645 != nil:
    section.add "labName", valid_594645
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=identity)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594646 = query.getOrDefault("$expand")
  valid_594646 = validateParameter(valid_594646, JString, required = false,
                                 default = nil)
  if valid_594646 != nil:
    section.add "$expand", valid_594646
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594647 = query.getOrDefault("api-version")
  valid_594647 = validateParameter(valid_594647, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594647 != nil:
    section.add "api-version", valid_594647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594648: Call_UsersGet_594639; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get user profile.
  ## 
  let valid = call_594648.validator(path, query, header, formData, body)
  let scheme = call_594648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594648.url(scheme.get, call_594648.host, call_594648.base,
                         call_594648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594648, url, valid)

proc call*(call_594649: Call_UsersGet_594639; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594650 = newJObject()
  var query_594651 = newJObject()
  add(path_594650, "resourceGroupName", newJString(resourceGroupName))
  add(query_594651, "$expand", newJString(Expand))
  add(path_594650, "name", newJString(name))
  add(query_594651, "api-version", newJString(apiVersion))
  add(path_594650, "subscriptionId", newJString(subscriptionId))
  add(path_594650, "labName", newJString(labName))
  result = call_594649.call(path_594650, query_594651, nil, nil, nil)

var usersGet* = Call_UsersGet_594639(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                  validator: validate_UsersGet_594640, base: "",
                                  url: url_UsersGet_594641,
                                  schemes: {Scheme.Https})
type
  Call_UsersUpdate_594678 = ref object of OpenApiRestCall_593421
proc url_UsersUpdate_594680(protocol: Scheme; host: string; base: string;
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

proc validate_UsersUpdate_594679(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of user profiles.
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
  var valid_594681 = path.getOrDefault("resourceGroupName")
  valid_594681 = validateParameter(valid_594681, JString, required = true,
                                 default = nil)
  if valid_594681 != nil:
    section.add "resourceGroupName", valid_594681
  var valid_594682 = path.getOrDefault("name")
  valid_594682 = validateParameter(valid_594682, JString, required = true,
                                 default = nil)
  if valid_594682 != nil:
    section.add "name", valid_594682
  var valid_594683 = path.getOrDefault("subscriptionId")
  valid_594683 = validateParameter(valid_594683, JString, required = true,
                                 default = nil)
  if valid_594683 != nil:
    section.add "subscriptionId", valid_594683
  var valid_594684 = path.getOrDefault("labName")
  valid_594684 = validateParameter(valid_594684, JString, required = true,
                                 default = nil)
  if valid_594684 != nil:
    section.add "labName", valid_594684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594685 = query.getOrDefault("api-version")
  valid_594685 = validateParameter(valid_594685, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594685 != nil:
    section.add "api-version", valid_594685
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

proc call*(call_594687: Call_UsersUpdate_594678; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of user profiles.
  ## 
  let valid = call_594687.validator(path, query, header, formData, body)
  let scheme = call_594687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594687.url(scheme.get, call_594687.host, call_594687.base,
                         call_594687.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594687, url, valid)

proc call*(call_594688: Call_UsersUpdate_594678; resourceGroupName: string;
          name: string; user: JsonNode; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## usersUpdate
  ## Modify properties of user profiles.
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
  var path_594689 = newJObject()
  var query_594690 = newJObject()
  var body_594691 = newJObject()
  add(path_594689, "resourceGroupName", newJString(resourceGroupName))
  add(query_594690, "api-version", newJString(apiVersion))
  add(path_594689, "name", newJString(name))
  if user != nil:
    body_594691 = user
  add(path_594689, "subscriptionId", newJString(subscriptionId))
  add(path_594689, "labName", newJString(labName))
  result = call_594688.call(path_594689, query_594690, nil, nil, body_594691)

var usersUpdate* = Call_UsersUpdate_594678(name: "usersUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                        validator: validate_UsersUpdate_594679,
                                        base: "", url: url_UsersUpdate_594680,
                                        schemes: {Scheme.Https})
type
  Call_UsersDelete_594666 = ref object of OpenApiRestCall_593421
proc url_UsersDelete_594668(protocol: Scheme; host: string; base: string;
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

proc validate_UsersDelete_594667(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594669 = path.getOrDefault("resourceGroupName")
  valid_594669 = validateParameter(valid_594669, JString, required = true,
                                 default = nil)
  if valid_594669 != nil:
    section.add "resourceGroupName", valid_594669
  var valid_594670 = path.getOrDefault("name")
  valid_594670 = validateParameter(valid_594670, JString, required = true,
                                 default = nil)
  if valid_594670 != nil:
    section.add "name", valid_594670
  var valid_594671 = path.getOrDefault("subscriptionId")
  valid_594671 = validateParameter(valid_594671, JString, required = true,
                                 default = nil)
  if valid_594671 != nil:
    section.add "subscriptionId", valid_594671
  var valid_594672 = path.getOrDefault("labName")
  valid_594672 = validateParameter(valid_594672, JString, required = true,
                                 default = nil)
  if valid_594672 != nil:
    section.add "labName", valid_594672
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594673 = query.getOrDefault("api-version")
  valid_594673 = validateParameter(valid_594673, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594673 != nil:
    section.add "api-version", valid_594673
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594674: Call_UsersDelete_594666; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user profile. This operation can take a while to complete.
  ## 
  let valid = call_594674.validator(path, query, header, formData, body)
  let scheme = call_594674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594674.url(scheme.get, call_594674.host, call_594674.base,
                         call_594674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594674, url, valid)

proc call*(call_594675: Call_UsersDelete_594666; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594676 = newJObject()
  var query_594677 = newJObject()
  add(path_594676, "resourceGroupName", newJString(resourceGroupName))
  add(query_594677, "api-version", newJString(apiVersion))
  add(path_594676, "name", newJString(name))
  add(path_594676, "subscriptionId", newJString(subscriptionId))
  add(path_594676, "labName", newJString(labName))
  result = call_594675.call(path_594676, query_594677, nil, nil, nil)

var usersDelete* = Call_UsersDelete_594666(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                        validator: validate_UsersDelete_594667,
                                        base: "", url: url_UsersDelete_594668,
                                        schemes: {Scheme.Https})
type
  Call_DisksList_594692 = ref object of OpenApiRestCall_593421
proc url_DisksList_594694(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DisksList_594693(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594695 = path.getOrDefault("resourceGroupName")
  valid_594695 = validateParameter(valid_594695, JString, required = true,
                                 default = nil)
  if valid_594695 != nil:
    section.add "resourceGroupName", valid_594695
  var valid_594696 = path.getOrDefault("subscriptionId")
  valid_594696 = validateParameter(valid_594696, JString, required = true,
                                 default = nil)
  if valid_594696 != nil:
    section.add "subscriptionId", valid_594696
  var valid_594697 = path.getOrDefault("userName")
  valid_594697 = validateParameter(valid_594697, JString, required = true,
                                 default = nil)
  if valid_594697 != nil:
    section.add "userName", valid_594697
  var valid_594698 = path.getOrDefault("labName")
  valid_594698 = validateParameter(valid_594698, JString, required = true,
                                 default = nil)
  if valid_594698 != nil:
    section.add "labName", valid_594698
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594699 = query.getOrDefault("$orderby")
  valid_594699 = validateParameter(valid_594699, JString, required = false,
                                 default = nil)
  if valid_594699 != nil:
    section.add "$orderby", valid_594699
  var valid_594700 = query.getOrDefault("$expand")
  valid_594700 = validateParameter(valid_594700, JString, required = false,
                                 default = nil)
  if valid_594700 != nil:
    section.add "$expand", valid_594700
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594701 = query.getOrDefault("api-version")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594701 != nil:
    section.add "api-version", valid_594701
  var valid_594702 = query.getOrDefault("$top")
  valid_594702 = validateParameter(valid_594702, JInt, required = false, default = nil)
  if valid_594702 != nil:
    section.add "$top", valid_594702
  var valid_594703 = query.getOrDefault("$filter")
  valid_594703 = validateParameter(valid_594703, JString, required = false,
                                 default = nil)
  if valid_594703 != nil:
    section.add "$filter", valid_594703
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594704: Call_DisksList_594692; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disks in a given user profile.
  ## 
  let valid = call_594704.validator(path, query, header, formData, body)
  let scheme = call_594704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594704.url(scheme.get, call_594704.host, call_594704.base,
                         call_594704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594704, url, valid)

proc call*(call_594705: Call_DisksList_594692; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## disksList
  ## List disks in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594706 = newJObject()
  var query_594707 = newJObject()
  add(query_594707, "$orderby", newJString(Orderby))
  add(path_594706, "resourceGroupName", newJString(resourceGroupName))
  add(query_594707, "$expand", newJString(Expand))
  add(query_594707, "api-version", newJString(apiVersion))
  add(path_594706, "subscriptionId", newJString(subscriptionId))
  add(query_594707, "$top", newJInt(Top))
  add(path_594706, "userName", newJString(userName))
  add(path_594706, "labName", newJString(labName))
  add(query_594707, "$filter", newJString(Filter))
  result = call_594705.call(path_594706, query_594707, nil, nil, nil)

var disksList* = Call_DisksList_594692(name: "disksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks",
                                    validator: validate_DisksList_594693,
                                    base: "", url: url_DisksList_594694,
                                    schemes: {Scheme.Https})
type
  Call_DisksCreateOrUpdate_594722 = ref object of OpenApiRestCall_593421
proc url_DisksCreateOrUpdate_594724(protocol: Scheme; host: string; base: string;
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

proc validate_DisksCreateOrUpdate_594723(path: JsonNode; query: JsonNode;
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
  var valid_594725 = path.getOrDefault("resourceGroupName")
  valid_594725 = validateParameter(valid_594725, JString, required = true,
                                 default = nil)
  if valid_594725 != nil:
    section.add "resourceGroupName", valid_594725
  var valid_594726 = path.getOrDefault("name")
  valid_594726 = validateParameter(valid_594726, JString, required = true,
                                 default = nil)
  if valid_594726 != nil:
    section.add "name", valid_594726
  var valid_594727 = path.getOrDefault("subscriptionId")
  valid_594727 = validateParameter(valid_594727, JString, required = true,
                                 default = nil)
  if valid_594727 != nil:
    section.add "subscriptionId", valid_594727
  var valid_594728 = path.getOrDefault("userName")
  valid_594728 = validateParameter(valid_594728, JString, required = true,
                                 default = nil)
  if valid_594728 != nil:
    section.add "userName", valid_594728
  var valid_594729 = path.getOrDefault("labName")
  valid_594729 = validateParameter(valid_594729, JString, required = true,
                                 default = nil)
  if valid_594729 != nil:
    section.add "labName", valid_594729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594730 = query.getOrDefault("api-version")
  valid_594730 = validateParameter(valid_594730, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594730 != nil:
    section.add "api-version", valid_594730
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

proc call*(call_594732: Call_DisksCreateOrUpdate_594722; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing disk. This operation can take a while to complete.
  ## 
  let valid = call_594732.validator(path, query, header, formData, body)
  let scheme = call_594732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594732.url(scheme.get, call_594732.host, call_594732.base,
                         call_594732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594732, url, valid)

proc call*(call_594733: Call_DisksCreateOrUpdate_594722; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; disk: JsonNode;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594734 = newJObject()
  var query_594735 = newJObject()
  var body_594736 = newJObject()
  add(path_594734, "resourceGroupName", newJString(resourceGroupName))
  add(query_594735, "api-version", newJString(apiVersion))
  add(path_594734, "name", newJString(name))
  add(path_594734, "subscriptionId", newJString(subscriptionId))
  add(path_594734, "userName", newJString(userName))
  if disk != nil:
    body_594736 = disk
  add(path_594734, "labName", newJString(labName))
  result = call_594733.call(path_594734, query_594735, nil, nil, body_594736)

var disksCreateOrUpdate* = Call_DisksCreateOrUpdate_594722(
    name: "disksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
    validator: validate_DisksCreateOrUpdate_594723, base: "",
    url: url_DisksCreateOrUpdate_594724, schemes: {Scheme.Https})
type
  Call_DisksGet_594708 = ref object of OpenApiRestCall_593421
proc url_DisksGet_594710(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DisksGet_594709(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594714 = path.getOrDefault("userName")
  valid_594714 = validateParameter(valid_594714, JString, required = true,
                                 default = nil)
  if valid_594714 != nil:
    section.add "userName", valid_594714
  var valid_594715 = path.getOrDefault("labName")
  valid_594715 = validateParameter(valid_594715, JString, required = true,
                                 default = nil)
  if valid_594715 != nil:
    section.add "labName", valid_594715
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594716 = query.getOrDefault("$expand")
  valid_594716 = validateParameter(valid_594716, JString, required = false,
                                 default = nil)
  if valid_594716 != nil:
    section.add "$expand", valid_594716
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594717 = query.getOrDefault("api-version")
  valid_594717 = validateParameter(valid_594717, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594717 != nil:
    section.add "api-version", valid_594717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594718: Call_DisksGet_594708; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get disk.
  ## 
  let valid = call_594718.validator(path, query, header, formData, body)
  let scheme = call_594718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594718.url(scheme.get, call_594718.host, call_594718.base,
                         call_594718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594718, url, valid)

proc call*(call_594719: Call_DisksGet_594708; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594720 = newJObject()
  var query_594721 = newJObject()
  add(path_594720, "resourceGroupName", newJString(resourceGroupName))
  add(query_594721, "$expand", newJString(Expand))
  add(path_594720, "name", newJString(name))
  add(query_594721, "api-version", newJString(apiVersion))
  add(path_594720, "subscriptionId", newJString(subscriptionId))
  add(path_594720, "userName", newJString(userName))
  add(path_594720, "labName", newJString(labName))
  result = call_594719.call(path_594720, query_594721, nil, nil, nil)

var disksGet* = Call_DisksGet_594708(name: "disksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                  validator: validate_DisksGet_594709, base: "",
                                  url: url_DisksGet_594710,
                                  schemes: {Scheme.Https})
type
  Call_DisksDelete_594737 = ref object of OpenApiRestCall_593421
proc url_DisksDelete_594739(protocol: Scheme; host: string; base: string;
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

proc validate_DisksDelete_594738(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594740 = path.getOrDefault("resourceGroupName")
  valid_594740 = validateParameter(valid_594740, JString, required = true,
                                 default = nil)
  if valid_594740 != nil:
    section.add "resourceGroupName", valid_594740
  var valid_594741 = path.getOrDefault("name")
  valid_594741 = validateParameter(valid_594741, JString, required = true,
                                 default = nil)
  if valid_594741 != nil:
    section.add "name", valid_594741
  var valid_594742 = path.getOrDefault("subscriptionId")
  valid_594742 = validateParameter(valid_594742, JString, required = true,
                                 default = nil)
  if valid_594742 != nil:
    section.add "subscriptionId", valid_594742
  var valid_594743 = path.getOrDefault("userName")
  valid_594743 = validateParameter(valid_594743, JString, required = true,
                                 default = nil)
  if valid_594743 != nil:
    section.add "userName", valid_594743
  var valid_594744 = path.getOrDefault("labName")
  valid_594744 = validateParameter(valid_594744, JString, required = true,
                                 default = nil)
  if valid_594744 != nil:
    section.add "labName", valid_594744
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594745 = query.getOrDefault("api-version")
  valid_594745 = validateParameter(valid_594745, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594745 != nil:
    section.add "api-version", valid_594745
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594746: Call_DisksDelete_594737; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete disk. This operation can take a while to complete.
  ## 
  let valid = call_594746.validator(path, query, header, formData, body)
  let scheme = call_594746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594746.url(scheme.get, call_594746.host, call_594746.base,
                         call_594746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594746, url, valid)

proc call*(call_594747: Call_DisksDelete_594737; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594748 = newJObject()
  var query_594749 = newJObject()
  add(path_594748, "resourceGroupName", newJString(resourceGroupName))
  add(query_594749, "api-version", newJString(apiVersion))
  add(path_594748, "name", newJString(name))
  add(path_594748, "subscriptionId", newJString(subscriptionId))
  add(path_594748, "userName", newJString(userName))
  add(path_594748, "labName", newJString(labName))
  result = call_594747.call(path_594748, query_594749, nil, nil, nil)

var disksDelete* = Call_DisksDelete_594737(name: "disksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                        validator: validate_DisksDelete_594738,
                                        base: "", url: url_DisksDelete_594739,
                                        schemes: {Scheme.Https})
type
  Call_DisksAttach_594750 = ref object of OpenApiRestCall_593421
proc url_DisksAttach_594752(protocol: Scheme; host: string; base: string;
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

proc validate_DisksAttach_594751(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594753 = path.getOrDefault("resourceGroupName")
  valid_594753 = validateParameter(valid_594753, JString, required = true,
                                 default = nil)
  if valid_594753 != nil:
    section.add "resourceGroupName", valid_594753
  var valid_594754 = path.getOrDefault("name")
  valid_594754 = validateParameter(valid_594754, JString, required = true,
                                 default = nil)
  if valid_594754 != nil:
    section.add "name", valid_594754
  var valid_594755 = path.getOrDefault("subscriptionId")
  valid_594755 = validateParameter(valid_594755, JString, required = true,
                                 default = nil)
  if valid_594755 != nil:
    section.add "subscriptionId", valid_594755
  var valid_594756 = path.getOrDefault("userName")
  valid_594756 = validateParameter(valid_594756, JString, required = true,
                                 default = nil)
  if valid_594756 != nil:
    section.add "userName", valid_594756
  var valid_594757 = path.getOrDefault("labName")
  valid_594757 = validateParameter(valid_594757, JString, required = true,
                                 default = nil)
  if valid_594757 != nil:
    section.add "labName", valid_594757
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594758 = query.getOrDefault("api-version")
  valid_594758 = validateParameter(valid_594758, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594758 != nil:
    section.add "api-version", valid_594758
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

proc call*(call_594760: Call_DisksAttach_594750; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attach and create the lease of the disk to the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_594760.validator(path, query, header, formData, body)
  let scheme = call_594760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594760.url(scheme.get, call_594760.host, call_594760.base,
                         call_594760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594760, url, valid)

proc call*(call_594761: Call_DisksAttach_594750; resourceGroupName: string;
          name: string; subscriptionId: string; attachDiskProperties: JsonNode;
          userName: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594762 = newJObject()
  var query_594763 = newJObject()
  var body_594764 = newJObject()
  add(path_594762, "resourceGroupName", newJString(resourceGroupName))
  add(query_594763, "api-version", newJString(apiVersion))
  add(path_594762, "name", newJString(name))
  add(path_594762, "subscriptionId", newJString(subscriptionId))
  if attachDiskProperties != nil:
    body_594764 = attachDiskProperties
  add(path_594762, "userName", newJString(userName))
  add(path_594762, "labName", newJString(labName))
  result = call_594761.call(path_594762, query_594763, nil, nil, body_594764)

var disksAttach* = Call_DisksAttach_594750(name: "disksAttach",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}/attach",
                                        validator: validate_DisksAttach_594751,
                                        base: "", url: url_DisksAttach_594752,
                                        schemes: {Scheme.Https})
type
  Call_DisksDetach_594765 = ref object of OpenApiRestCall_593421
proc url_DisksDetach_594767(protocol: Scheme; host: string; base: string;
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

proc validate_DisksDetach_594766(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594768 = path.getOrDefault("resourceGroupName")
  valid_594768 = validateParameter(valid_594768, JString, required = true,
                                 default = nil)
  if valid_594768 != nil:
    section.add "resourceGroupName", valid_594768
  var valid_594769 = path.getOrDefault("name")
  valid_594769 = validateParameter(valid_594769, JString, required = true,
                                 default = nil)
  if valid_594769 != nil:
    section.add "name", valid_594769
  var valid_594770 = path.getOrDefault("subscriptionId")
  valid_594770 = validateParameter(valid_594770, JString, required = true,
                                 default = nil)
  if valid_594770 != nil:
    section.add "subscriptionId", valid_594770
  var valid_594771 = path.getOrDefault("userName")
  valid_594771 = validateParameter(valid_594771, JString, required = true,
                                 default = nil)
  if valid_594771 != nil:
    section.add "userName", valid_594771
  var valid_594772 = path.getOrDefault("labName")
  valid_594772 = validateParameter(valid_594772, JString, required = true,
                                 default = nil)
  if valid_594772 != nil:
    section.add "labName", valid_594772
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594773 = query.getOrDefault("api-version")
  valid_594773 = validateParameter(valid_594773, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594773 != nil:
    section.add "api-version", valid_594773
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

proc call*(call_594775: Call_DisksDetach_594765; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach and break the lease of the disk attached to the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_594775.validator(path, query, header, formData, body)
  let scheme = call_594775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594775.url(scheme.get, call_594775.host, call_594775.base,
                         call_594775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594775, url, valid)

proc call*(call_594776: Call_DisksDetach_594765; resourceGroupName: string;
          name: string; subscriptionId: string; detachDiskProperties: JsonNode;
          userName: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594777 = newJObject()
  var query_594778 = newJObject()
  var body_594779 = newJObject()
  add(path_594777, "resourceGroupName", newJString(resourceGroupName))
  add(query_594778, "api-version", newJString(apiVersion))
  add(path_594777, "name", newJString(name))
  add(path_594777, "subscriptionId", newJString(subscriptionId))
  if detachDiskProperties != nil:
    body_594779 = detachDiskProperties
  add(path_594777, "userName", newJString(userName))
  add(path_594777, "labName", newJString(labName))
  result = call_594776.call(path_594777, query_594778, nil, nil, body_594779)

var disksDetach* = Call_DisksDetach_594765(name: "disksDetach",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}/detach",
                                        validator: validate_DisksDetach_594766,
                                        base: "", url: url_DisksDetach_594767,
                                        schemes: {Scheme.Https})
type
  Call_EnvironmentsList_594780 = ref object of OpenApiRestCall_593421
proc url_EnvironmentsList_594782(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsList_594781(path: JsonNode; query: JsonNode;
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
  var valid_594783 = path.getOrDefault("resourceGroupName")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "resourceGroupName", valid_594783
  var valid_594784 = path.getOrDefault("subscriptionId")
  valid_594784 = validateParameter(valid_594784, JString, required = true,
                                 default = nil)
  if valid_594784 != nil:
    section.add "subscriptionId", valid_594784
  var valid_594785 = path.getOrDefault("userName")
  valid_594785 = validateParameter(valid_594785, JString, required = true,
                                 default = nil)
  if valid_594785 != nil:
    section.add "userName", valid_594785
  var valid_594786 = path.getOrDefault("labName")
  valid_594786 = validateParameter(valid_594786, JString, required = true,
                                 default = nil)
  if valid_594786 != nil:
    section.add "labName", valid_594786
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594787 = query.getOrDefault("$orderby")
  valid_594787 = validateParameter(valid_594787, JString, required = false,
                                 default = nil)
  if valid_594787 != nil:
    section.add "$orderby", valid_594787
  var valid_594788 = query.getOrDefault("$expand")
  valid_594788 = validateParameter(valid_594788, JString, required = false,
                                 default = nil)
  if valid_594788 != nil:
    section.add "$expand", valid_594788
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594789 = query.getOrDefault("api-version")
  valid_594789 = validateParameter(valid_594789, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594789 != nil:
    section.add "api-version", valid_594789
  var valid_594790 = query.getOrDefault("$top")
  valid_594790 = validateParameter(valid_594790, JInt, required = false, default = nil)
  if valid_594790 != nil:
    section.add "$top", valid_594790
  var valid_594791 = query.getOrDefault("$filter")
  valid_594791 = validateParameter(valid_594791, JString, required = false,
                                 default = nil)
  if valid_594791 != nil:
    section.add "$filter", valid_594791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594792: Call_EnvironmentsList_594780; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List environments in a given user profile.
  ## 
  let valid = call_594792.validator(path, query, header, formData, body)
  let scheme = call_594792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594792.url(scheme.get, call_594792.host, call_594792.base,
                         call_594792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594792, url, valid)

proc call*(call_594793: Call_EnvironmentsList_594780; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## environmentsList
  ## List environments in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594794 = newJObject()
  var query_594795 = newJObject()
  add(query_594795, "$orderby", newJString(Orderby))
  add(path_594794, "resourceGroupName", newJString(resourceGroupName))
  add(query_594795, "$expand", newJString(Expand))
  add(query_594795, "api-version", newJString(apiVersion))
  add(path_594794, "subscriptionId", newJString(subscriptionId))
  add(query_594795, "$top", newJInt(Top))
  add(path_594794, "userName", newJString(userName))
  add(path_594794, "labName", newJString(labName))
  add(query_594795, "$filter", newJString(Filter))
  result = call_594793.call(path_594794, query_594795, nil, nil, nil)

var environmentsList* = Call_EnvironmentsList_594780(name: "environmentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments",
    validator: validate_EnvironmentsList_594781, base: "",
    url: url_EnvironmentsList_594782, schemes: {Scheme.Https})
type
  Call_EnvironmentsCreateOrUpdate_594810 = ref object of OpenApiRestCall_593421
proc url_EnvironmentsCreateOrUpdate_594812(protocol: Scheme; host: string;
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

proc validate_EnvironmentsCreateOrUpdate_594811(path: JsonNode; query: JsonNode;
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
                                 default = newJString("2016-05-15"))
  if valid_594818 != nil:
    section.add "api-version", valid_594818
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

proc call*(call_594820: Call_EnvironmentsCreateOrUpdate_594810; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing environment. This operation can take a while to complete.
  ## 
  let valid = call_594820.validator(path, query, header, formData, body)
  let scheme = call_594820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594820.url(scheme.get, call_594820.host, call_594820.base,
                         call_594820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594820, url, valid)

proc call*(call_594821: Call_EnvironmentsCreateOrUpdate_594810;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; dtlEnvironment: JsonNode; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594822 = newJObject()
  var query_594823 = newJObject()
  var body_594824 = newJObject()
  add(path_594822, "resourceGroupName", newJString(resourceGroupName))
  add(query_594823, "api-version", newJString(apiVersion))
  add(path_594822, "name", newJString(name))
  add(path_594822, "subscriptionId", newJString(subscriptionId))
  add(path_594822, "userName", newJString(userName))
  if dtlEnvironment != nil:
    body_594824 = dtlEnvironment
  add(path_594822, "labName", newJString(labName))
  result = call_594821.call(path_594822, query_594823, nil, nil, body_594824)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_594810(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsCreateOrUpdate_594811, base: "",
    url: url_EnvironmentsCreateOrUpdate_594812, schemes: {Scheme.Https})
type
  Call_EnvironmentsGet_594796 = ref object of OpenApiRestCall_593421
proc url_EnvironmentsGet_594798(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsGet_594797(path: JsonNode; query: JsonNode;
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
  var valid_594799 = path.getOrDefault("resourceGroupName")
  valid_594799 = validateParameter(valid_594799, JString, required = true,
                                 default = nil)
  if valid_594799 != nil:
    section.add "resourceGroupName", valid_594799
  var valid_594800 = path.getOrDefault("name")
  valid_594800 = validateParameter(valid_594800, JString, required = true,
                                 default = nil)
  if valid_594800 != nil:
    section.add "name", valid_594800
  var valid_594801 = path.getOrDefault("subscriptionId")
  valid_594801 = validateParameter(valid_594801, JString, required = true,
                                 default = nil)
  if valid_594801 != nil:
    section.add "subscriptionId", valid_594801
  var valid_594802 = path.getOrDefault("userName")
  valid_594802 = validateParameter(valid_594802, JString, required = true,
                                 default = nil)
  if valid_594802 != nil:
    section.add "userName", valid_594802
  var valid_594803 = path.getOrDefault("labName")
  valid_594803 = validateParameter(valid_594803, JString, required = true,
                                 default = nil)
  if valid_594803 != nil:
    section.add "labName", valid_594803
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594804 = query.getOrDefault("$expand")
  valid_594804 = validateParameter(valid_594804, JString, required = false,
                                 default = nil)
  if valid_594804 != nil:
    section.add "$expand", valid_594804
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594805 = query.getOrDefault("api-version")
  valid_594805 = validateParameter(valid_594805, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594805 != nil:
    section.add "api-version", valid_594805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594806: Call_EnvironmentsGet_594796; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get environment.
  ## 
  let valid = call_594806.validator(path, query, header, formData, body)
  let scheme = call_594806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594806.url(scheme.get, call_594806.host, call_594806.base,
                         call_594806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594806, url, valid)

proc call*(call_594807: Call_EnvironmentsGet_594796; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594808 = newJObject()
  var query_594809 = newJObject()
  add(path_594808, "resourceGroupName", newJString(resourceGroupName))
  add(query_594809, "$expand", newJString(Expand))
  add(path_594808, "name", newJString(name))
  add(query_594809, "api-version", newJString(apiVersion))
  add(path_594808, "subscriptionId", newJString(subscriptionId))
  add(path_594808, "userName", newJString(userName))
  add(path_594808, "labName", newJString(labName))
  result = call_594807.call(path_594808, query_594809, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_594796(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsGet_594797, base: "", url: url_EnvironmentsGet_594798,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_594825 = ref object of OpenApiRestCall_593421
proc url_EnvironmentsDelete_594827(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsDelete_594826(path: JsonNode; query: JsonNode;
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
  var valid_594828 = path.getOrDefault("resourceGroupName")
  valid_594828 = validateParameter(valid_594828, JString, required = true,
                                 default = nil)
  if valid_594828 != nil:
    section.add "resourceGroupName", valid_594828
  var valid_594829 = path.getOrDefault("name")
  valid_594829 = validateParameter(valid_594829, JString, required = true,
                                 default = nil)
  if valid_594829 != nil:
    section.add "name", valid_594829
  var valid_594830 = path.getOrDefault("subscriptionId")
  valid_594830 = validateParameter(valid_594830, JString, required = true,
                                 default = nil)
  if valid_594830 != nil:
    section.add "subscriptionId", valid_594830
  var valid_594831 = path.getOrDefault("userName")
  valid_594831 = validateParameter(valid_594831, JString, required = true,
                                 default = nil)
  if valid_594831 != nil:
    section.add "userName", valid_594831
  var valid_594832 = path.getOrDefault("labName")
  valid_594832 = validateParameter(valid_594832, JString, required = true,
                                 default = nil)
  if valid_594832 != nil:
    section.add "labName", valid_594832
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594833 = query.getOrDefault("api-version")
  valid_594833 = validateParameter(valid_594833, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594833 != nil:
    section.add "api-version", valid_594833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594834: Call_EnvironmentsDelete_594825; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete environment. This operation can take a while to complete.
  ## 
  let valid = call_594834.validator(path, query, header, formData, body)
  let scheme = call_594834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594834.url(scheme.get, call_594834.host, call_594834.base,
                         call_594834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594834, url, valid)

proc call*(call_594835: Call_EnvironmentsDelete_594825; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594836 = newJObject()
  var query_594837 = newJObject()
  add(path_594836, "resourceGroupName", newJString(resourceGroupName))
  add(query_594837, "api-version", newJString(apiVersion))
  add(path_594836, "name", newJString(name))
  add(path_594836, "subscriptionId", newJString(subscriptionId))
  add(path_594836, "userName", newJString(userName))
  add(path_594836, "labName", newJString(labName))
  result = call_594835.call(path_594836, query_594837, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_594825(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsDelete_594826, base: "",
    url: url_EnvironmentsDelete_594827, schemes: {Scheme.Https})
type
  Call_SecretsList_594838 = ref object of OpenApiRestCall_593421
proc url_SecretsList_594840(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsList_594839(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594841 = path.getOrDefault("resourceGroupName")
  valid_594841 = validateParameter(valid_594841, JString, required = true,
                                 default = nil)
  if valid_594841 != nil:
    section.add "resourceGroupName", valid_594841
  var valid_594842 = path.getOrDefault("subscriptionId")
  valid_594842 = validateParameter(valid_594842, JString, required = true,
                                 default = nil)
  if valid_594842 != nil:
    section.add "subscriptionId", valid_594842
  var valid_594843 = path.getOrDefault("userName")
  valid_594843 = validateParameter(valid_594843, JString, required = true,
                                 default = nil)
  if valid_594843 != nil:
    section.add "userName", valid_594843
  var valid_594844 = path.getOrDefault("labName")
  valid_594844 = validateParameter(valid_594844, JString, required = true,
                                 default = nil)
  if valid_594844 != nil:
    section.add "labName", valid_594844
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=value)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594845 = query.getOrDefault("$orderby")
  valid_594845 = validateParameter(valid_594845, JString, required = false,
                                 default = nil)
  if valid_594845 != nil:
    section.add "$orderby", valid_594845
  var valid_594846 = query.getOrDefault("$expand")
  valid_594846 = validateParameter(valid_594846, JString, required = false,
                                 default = nil)
  if valid_594846 != nil:
    section.add "$expand", valid_594846
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594847 = query.getOrDefault("api-version")
  valid_594847 = validateParameter(valid_594847, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594847 != nil:
    section.add "api-version", valid_594847
  var valid_594848 = query.getOrDefault("$top")
  valid_594848 = validateParameter(valid_594848, JInt, required = false, default = nil)
  if valid_594848 != nil:
    section.add "$top", valid_594848
  var valid_594849 = query.getOrDefault("$filter")
  valid_594849 = validateParameter(valid_594849, JString, required = false,
                                 default = nil)
  if valid_594849 != nil:
    section.add "$filter", valid_594849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594850: Call_SecretsList_594838; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List secrets in a given user profile.
  ## 
  let valid = call_594850.validator(path, query, header, formData, body)
  let scheme = call_594850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594850.url(scheme.get, call_594850.host, call_594850.base,
                         call_594850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594850, url, valid)

proc call*(call_594851: Call_SecretsList_594838; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## secretsList
  ## List secrets in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=value)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594852 = newJObject()
  var query_594853 = newJObject()
  add(query_594853, "$orderby", newJString(Orderby))
  add(path_594852, "resourceGroupName", newJString(resourceGroupName))
  add(query_594853, "$expand", newJString(Expand))
  add(query_594853, "api-version", newJString(apiVersion))
  add(path_594852, "subscriptionId", newJString(subscriptionId))
  add(query_594853, "$top", newJInt(Top))
  add(path_594852, "userName", newJString(userName))
  add(path_594852, "labName", newJString(labName))
  add(query_594853, "$filter", newJString(Filter))
  result = call_594851.call(path_594852, query_594853, nil, nil, nil)

var secretsList* = Call_SecretsList_594838(name: "secretsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets",
                                        validator: validate_SecretsList_594839,
                                        base: "", url: url_SecretsList_594840,
                                        schemes: {Scheme.Https})
type
  Call_SecretsCreateOrUpdate_594868 = ref object of OpenApiRestCall_593421
proc url_SecretsCreateOrUpdate_594870(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsCreateOrUpdate_594869(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing secret.
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
  var valid_594871 = path.getOrDefault("resourceGroupName")
  valid_594871 = validateParameter(valid_594871, JString, required = true,
                                 default = nil)
  if valid_594871 != nil:
    section.add "resourceGroupName", valid_594871
  var valid_594872 = path.getOrDefault("name")
  valid_594872 = validateParameter(valid_594872, JString, required = true,
                                 default = nil)
  if valid_594872 != nil:
    section.add "name", valid_594872
  var valid_594873 = path.getOrDefault("subscriptionId")
  valid_594873 = validateParameter(valid_594873, JString, required = true,
                                 default = nil)
  if valid_594873 != nil:
    section.add "subscriptionId", valid_594873
  var valid_594874 = path.getOrDefault("userName")
  valid_594874 = validateParameter(valid_594874, JString, required = true,
                                 default = nil)
  if valid_594874 != nil:
    section.add "userName", valid_594874
  var valid_594875 = path.getOrDefault("labName")
  valid_594875 = validateParameter(valid_594875, JString, required = true,
                                 default = nil)
  if valid_594875 != nil:
    section.add "labName", valid_594875
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594876 = query.getOrDefault("api-version")
  valid_594876 = validateParameter(valid_594876, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594876 != nil:
    section.add "api-version", valid_594876
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

proc call*(call_594878: Call_SecretsCreateOrUpdate_594868; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing secret.
  ## 
  let valid = call_594878.validator(path, query, header, formData, body)
  let scheme = call_594878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594878.url(scheme.get, call_594878.host, call_594878.base,
                         call_594878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594878, url, valid)

proc call*(call_594879: Call_SecretsCreateOrUpdate_594868;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; secret: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## secretsCreateOrUpdate
  ## Create or replace an existing secret.
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
  var path_594880 = newJObject()
  var query_594881 = newJObject()
  var body_594882 = newJObject()
  add(path_594880, "resourceGroupName", newJString(resourceGroupName))
  add(query_594881, "api-version", newJString(apiVersion))
  add(path_594880, "name", newJString(name))
  add(path_594880, "subscriptionId", newJString(subscriptionId))
  add(path_594880, "userName", newJString(userName))
  add(path_594880, "labName", newJString(labName))
  if secret != nil:
    body_594882 = secret
  result = call_594879.call(path_594880, query_594881, nil, nil, body_594882)

var secretsCreateOrUpdate* = Call_SecretsCreateOrUpdate_594868(
    name: "secretsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsCreateOrUpdate_594869, base: "",
    url: url_SecretsCreateOrUpdate_594870, schemes: {Scheme.Https})
type
  Call_SecretsGet_594854 = ref object of OpenApiRestCall_593421
proc url_SecretsGet_594856(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SecretsGet_594855(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594857 = path.getOrDefault("resourceGroupName")
  valid_594857 = validateParameter(valid_594857, JString, required = true,
                                 default = nil)
  if valid_594857 != nil:
    section.add "resourceGroupName", valid_594857
  var valid_594858 = path.getOrDefault("name")
  valid_594858 = validateParameter(valid_594858, JString, required = true,
                                 default = nil)
  if valid_594858 != nil:
    section.add "name", valid_594858
  var valid_594859 = path.getOrDefault("subscriptionId")
  valid_594859 = validateParameter(valid_594859, JString, required = true,
                                 default = nil)
  if valid_594859 != nil:
    section.add "subscriptionId", valid_594859
  var valid_594860 = path.getOrDefault("userName")
  valid_594860 = validateParameter(valid_594860, JString, required = true,
                                 default = nil)
  if valid_594860 != nil:
    section.add "userName", valid_594860
  var valid_594861 = path.getOrDefault("labName")
  valid_594861 = validateParameter(valid_594861, JString, required = true,
                                 default = nil)
  if valid_594861 != nil:
    section.add "labName", valid_594861
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=value)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594862 = query.getOrDefault("$expand")
  valid_594862 = validateParameter(valid_594862, JString, required = false,
                                 default = nil)
  if valid_594862 != nil:
    section.add "$expand", valid_594862
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594863 = query.getOrDefault("api-version")
  valid_594863 = validateParameter(valid_594863, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594863 != nil:
    section.add "api-version", valid_594863
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594864: Call_SecretsGet_594854; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get secret.
  ## 
  let valid = call_594864.validator(path, query, header, formData, body)
  let scheme = call_594864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594864.url(scheme.get, call_594864.host, call_594864.base,
                         call_594864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594864, url, valid)

proc call*(call_594865: Call_SecretsGet_594854; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594866 = newJObject()
  var query_594867 = newJObject()
  add(path_594866, "resourceGroupName", newJString(resourceGroupName))
  add(query_594867, "$expand", newJString(Expand))
  add(path_594866, "name", newJString(name))
  add(query_594867, "api-version", newJString(apiVersion))
  add(path_594866, "subscriptionId", newJString(subscriptionId))
  add(path_594866, "userName", newJString(userName))
  add(path_594866, "labName", newJString(labName))
  result = call_594865.call(path_594866, query_594867, nil, nil, nil)

var secretsGet* = Call_SecretsGet_594854(name: "secretsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
                                      validator: validate_SecretsGet_594855,
                                      base: "", url: url_SecretsGet_594856,
                                      schemes: {Scheme.Https})
type
  Call_SecretsDelete_594883 = ref object of OpenApiRestCall_593421
proc url_SecretsDelete_594885(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsDelete_594884(path: JsonNode; query: JsonNode; header: JsonNode;
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
                                 default = newJString("2016-05-15"))
  if valid_594891 != nil:
    section.add "api-version", valid_594891
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594892: Call_SecretsDelete_594883; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete secret.
  ## 
  let valid = call_594892.validator(path, query, header, formData, body)
  let scheme = call_594892.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594892.url(scheme.get, call_594892.host, call_594892.base,
                         call_594892.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594892, url, valid)

proc call*(call_594893: Call_SecretsDelete_594883; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594894 = newJObject()
  var query_594895 = newJObject()
  add(path_594894, "resourceGroupName", newJString(resourceGroupName))
  add(query_594895, "api-version", newJString(apiVersion))
  add(path_594894, "name", newJString(name))
  add(path_594894, "subscriptionId", newJString(subscriptionId))
  add(path_594894, "userName", newJString(userName))
  add(path_594894, "labName", newJString(labName))
  result = call_594893.call(path_594894, query_594895, nil, nil, nil)

var secretsDelete* = Call_SecretsDelete_594883(name: "secretsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsDelete_594884, base: "", url: url_SecretsDelete_594885,
    schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_594896 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinesList_594898(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesList_594897(path: JsonNode; query: JsonNode;
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
  var valid_594899 = path.getOrDefault("resourceGroupName")
  valid_594899 = validateParameter(valid_594899, JString, required = true,
                                 default = nil)
  if valid_594899 != nil:
    section.add "resourceGroupName", valid_594899
  var valid_594900 = path.getOrDefault("subscriptionId")
  valid_594900 = validateParameter(valid_594900, JString, required = true,
                                 default = nil)
  if valid_594900 != nil:
    section.add "subscriptionId", valid_594900
  var valid_594901 = path.getOrDefault("labName")
  valid_594901 = validateParameter(valid_594901, JString, required = true,
                                 default = nil)
  if valid_594901 != nil:
    section.add "labName", valid_594901
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_594902 = query.getOrDefault("$orderby")
  valid_594902 = validateParameter(valid_594902, JString, required = false,
                                 default = nil)
  if valid_594902 != nil:
    section.add "$orderby", valid_594902
  var valid_594903 = query.getOrDefault("$expand")
  valid_594903 = validateParameter(valid_594903, JString, required = false,
                                 default = nil)
  if valid_594903 != nil:
    section.add "$expand", valid_594903
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594904 = query.getOrDefault("api-version")
  valid_594904 = validateParameter(valid_594904, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594904 != nil:
    section.add "api-version", valid_594904
  var valid_594905 = query.getOrDefault("$top")
  valid_594905 = validateParameter(valid_594905, JInt, required = false, default = nil)
  if valid_594905 != nil:
    section.add "$top", valid_594905
  var valid_594906 = query.getOrDefault("$filter")
  valid_594906 = validateParameter(valid_594906, JString, required = false,
                                 default = nil)
  if valid_594906 != nil:
    section.add "$filter", valid_594906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594907: Call_VirtualMachinesList_594896; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual machines in a given lab.
  ## 
  let valid = call_594907.validator(path, query, header, formData, body)
  let scheme = call_594907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594907.url(scheme.get, call_594907.host, call_594907.base,
                         call_594907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594907, url, valid)

proc call*(call_594908: Call_VirtualMachinesList_594896; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualMachinesList
  ## List virtual machines in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_594909 = newJObject()
  var query_594910 = newJObject()
  add(query_594910, "$orderby", newJString(Orderby))
  add(path_594909, "resourceGroupName", newJString(resourceGroupName))
  add(query_594910, "$expand", newJString(Expand))
  add(query_594910, "api-version", newJString(apiVersion))
  add(path_594909, "subscriptionId", newJString(subscriptionId))
  add(query_594910, "$top", newJInt(Top))
  add(path_594909, "labName", newJString(labName))
  add(query_594910, "$filter", newJString(Filter))
  result = call_594908.call(path_594909, query_594910, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_594896(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines",
    validator: validate_VirtualMachinesList_594897, base: "",
    url: url_VirtualMachinesList_594898, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_594924 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinesCreateOrUpdate_594926(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesCreateOrUpdate_594925(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Virtual machine. This operation can take a while to complete.
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
  var valid_594927 = path.getOrDefault("resourceGroupName")
  valid_594927 = validateParameter(valid_594927, JString, required = true,
                                 default = nil)
  if valid_594927 != nil:
    section.add "resourceGroupName", valid_594927
  var valid_594928 = path.getOrDefault("name")
  valid_594928 = validateParameter(valid_594928, JString, required = true,
                                 default = nil)
  if valid_594928 != nil:
    section.add "name", valid_594928
  var valid_594929 = path.getOrDefault("subscriptionId")
  valid_594929 = validateParameter(valid_594929, JString, required = true,
                                 default = nil)
  if valid_594929 != nil:
    section.add "subscriptionId", valid_594929
  var valid_594930 = path.getOrDefault("labName")
  valid_594930 = validateParameter(valid_594930, JString, required = true,
                                 default = nil)
  if valid_594930 != nil:
    section.add "labName", valid_594930
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594931 = query.getOrDefault("api-version")
  valid_594931 = validateParameter(valid_594931, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594931 != nil:
    section.add "api-version", valid_594931
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

proc call*(call_594933: Call_VirtualMachinesCreateOrUpdate_594924; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_594933.validator(path, query, header, formData, body)
  let scheme = call_594933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594933.url(scheme.get, call_594933.host, call_594933.base,
                         call_594933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594933, url, valid)

proc call*(call_594934: Call_VirtualMachinesCreateOrUpdate_594924;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesCreateOrUpdate
  ## Create or replace an existing Virtual machine. This operation can take a while to complete.
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
  var path_594935 = newJObject()
  var query_594936 = newJObject()
  var body_594937 = newJObject()
  add(path_594935, "resourceGroupName", newJString(resourceGroupName))
  add(query_594936, "api-version", newJString(apiVersion))
  add(path_594935, "name", newJString(name))
  add(path_594935, "subscriptionId", newJString(subscriptionId))
  add(path_594935, "labName", newJString(labName))
  if labVirtualMachine != nil:
    body_594937 = labVirtualMachine
  result = call_594934.call(path_594935, query_594936, nil, nil, body_594937)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_594924(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesCreateOrUpdate_594925, base: "",
    url: url_VirtualMachinesCreateOrUpdate_594926, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_594911 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinesGet_594913(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesGet_594912(path: JsonNode; query: JsonNode;
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
  var valid_594914 = path.getOrDefault("resourceGroupName")
  valid_594914 = validateParameter(valid_594914, JString, required = true,
                                 default = nil)
  if valid_594914 != nil:
    section.add "resourceGroupName", valid_594914
  var valid_594915 = path.getOrDefault("name")
  valid_594915 = validateParameter(valid_594915, JString, required = true,
                                 default = nil)
  if valid_594915 != nil:
    section.add "name", valid_594915
  var valid_594916 = path.getOrDefault("subscriptionId")
  valid_594916 = validateParameter(valid_594916, JString, required = true,
                                 default = nil)
  if valid_594916 != nil:
    section.add "subscriptionId", valid_594916
  var valid_594917 = path.getOrDefault("labName")
  valid_594917 = validateParameter(valid_594917, JString, required = true,
                                 default = nil)
  if valid_594917 != nil:
    section.add "labName", valid_594917
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594918 = query.getOrDefault("$expand")
  valid_594918 = validateParameter(valid_594918, JString, required = false,
                                 default = nil)
  if valid_594918 != nil:
    section.add "$expand", valid_594918
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594919 = query.getOrDefault("api-version")
  valid_594919 = validateParameter(valid_594919, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594919 != nil:
    section.add "api-version", valid_594919
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594920: Call_VirtualMachinesGet_594911; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual machine.
  ## 
  let valid = call_594920.validator(path, query, header, formData, body)
  let scheme = call_594920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594920.url(scheme.get, call_594920.host, call_594920.base,
                         call_594920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594920, url, valid)

proc call*(call_594921: Call_VirtualMachinesGet_594911; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594922 = newJObject()
  var query_594923 = newJObject()
  add(path_594922, "resourceGroupName", newJString(resourceGroupName))
  add(query_594923, "$expand", newJString(Expand))
  add(path_594922, "name", newJString(name))
  add(query_594923, "api-version", newJString(apiVersion))
  add(path_594922, "subscriptionId", newJString(subscriptionId))
  add(path_594922, "labName", newJString(labName))
  result = call_594921.call(path_594922, query_594923, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_594911(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesGet_594912, base: "",
    url: url_VirtualMachinesGet_594913, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUpdate_594950 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinesUpdate_594952(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesUpdate_594951(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of virtual machines.
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
  var valid_594953 = path.getOrDefault("resourceGroupName")
  valid_594953 = validateParameter(valid_594953, JString, required = true,
                                 default = nil)
  if valid_594953 != nil:
    section.add "resourceGroupName", valid_594953
  var valid_594954 = path.getOrDefault("name")
  valid_594954 = validateParameter(valid_594954, JString, required = true,
                                 default = nil)
  if valid_594954 != nil:
    section.add "name", valid_594954
  var valid_594955 = path.getOrDefault("subscriptionId")
  valid_594955 = validateParameter(valid_594955, JString, required = true,
                                 default = nil)
  if valid_594955 != nil:
    section.add "subscriptionId", valid_594955
  var valid_594956 = path.getOrDefault("labName")
  valid_594956 = validateParameter(valid_594956, JString, required = true,
                                 default = nil)
  if valid_594956 != nil:
    section.add "labName", valid_594956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594957 = query.getOrDefault("api-version")
  valid_594957 = validateParameter(valid_594957, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594957 != nil:
    section.add "api-version", valid_594957
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

proc call*(call_594959: Call_VirtualMachinesUpdate_594950; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of virtual machines.
  ## 
  let valid = call_594959.validator(path, query, header, formData, body)
  let scheme = call_594959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594959.url(scheme.get, call_594959.host, call_594959.base,
                         call_594959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594959, url, valid)

proc call*(call_594960: Call_VirtualMachinesUpdate_594950;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesUpdate
  ## Modify properties of virtual machines.
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
  var path_594961 = newJObject()
  var query_594962 = newJObject()
  var body_594963 = newJObject()
  add(path_594961, "resourceGroupName", newJString(resourceGroupName))
  add(query_594962, "api-version", newJString(apiVersion))
  add(path_594961, "name", newJString(name))
  add(path_594961, "subscriptionId", newJString(subscriptionId))
  add(path_594961, "labName", newJString(labName))
  if labVirtualMachine != nil:
    body_594963 = labVirtualMachine
  result = call_594960.call(path_594961, query_594962, nil, nil, body_594963)

var virtualMachinesUpdate* = Call_VirtualMachinesUpdate_594950(
    name: "virtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesUpdate_594951, base: "",
    url: url_VirtualMachinesUpdate_594952, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_594938 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinesDelete_594940(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesDelete_594939(path: JsonNode; query: JsonNode;
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
  var valid_594941 = path.getOrDefault("resourceGroupName")
  valid_594941 = validateParameter(valid_594941, JString, required = true,
                                 default = nil)
  if valid_594941 != nil:
    section.add "resourceGroupName", valid_594941
  var valid_594942 = path.getOrDefault("name")
  valid_594942 = validateParameter(valid_594942, JString, required = true,
                                 default = nil)
  if valid_594942 != nil:
    section.add "name", valid_594942
  var valid_594943 = path.getOrDefault("subscriptionId")
  valid_594943 = validateParameter(valid_594943, JString, required = true,
                                 default = nil)
  if valid_594943 != nil:
    section.add "subscriptionId", valid_594943
  var valid_594944 = path.getOrDefault("labName")
  valid_594944 = validateParameter(valid_594944, JString, required = true,
                                 default = nil)
  if valid_594944 != nil:
    section.add "labName", valid_594944
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594945 = query.getOrDefault("api-version")
  valid_594945 = validateParameter(valid_594945, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594945 != nil:
    section.add "api-version", valid_594945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594946: Call_VirtualMachinesDelete_594938; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_594946.validator(path, query, header, formData, body)
  let scheme = call_594946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594946.url(scheme.get, call_594946.host, call_594946.base,
                         call_594946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594946, url, valid)

proc call*(call_594947: Call_VirtualMachinesDelete_594938;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594948 = newJObject()
  var query_594949 = newJObject()
  add(path_594948, "resourceGroupName", newJString(resourceGroupName))
  add(query_594949, "api-version", newJString(apiVersion))
  add(path_594948, "name", newJString(name))
  add(path_594948, "subscriptionId", newJString(subscriptionId))
  add(path_594948, "labName", newJString(labName))
  result = call_594947.call(path_594948, query_594949, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_594938(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesDelete_594939, base: "",
    url: url_VirtualMachinesDelete_594940, schemes: {Scheme.Https})
type
  Call_VirtualMachinesAddDataDisk_594964 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinesAddDataDisk_594966(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesAddDataDisk_594965(path: JsonNode; query: JsonNode;
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
  var valid_594967 = path.getOrDefault("resourceGroupName")
  valid_594967 = validateParameter(valid_594967, JString, required = true,
                                 default = nil)
  if valid_594967 != nil:
    section.add "resourceGroupName", valid_594967
  var valid_594968 = path.getOrDefault("name")
  valid_594968 = validateParameter(valid_594968, JString, required = true,
                                 default = nil)
  if valid_594968 != nil:
    section.add "name", valid_594968
  var valid_594969 = path.getOrDefault("subscriptionId")
  valid_594969 = validateParameter(valid_594969, JString, required = true,
                                 default = nil)
  if valid_594969 != nil:
    section.add "subscriptionId", valid_594969
  var valid_594970 = path.getOrDefault("labName")
  valid_594970 = validateParameter(valid_594970, JString, required = true,
                                 default = nil)
  if valid_594970 != nil:
    section.add "labName", valid_594970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594971 = query.getOrDefault("api-version")
  valid_594971 = validateParameter(valid_594971, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594971 != nil:
    section.add "api-version", valid_594971
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

proc call*(call_594973: Call_VirtualMachinesAddDataDisk_594964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attach a new or existing data disk to virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_594973.validator(path, query, header, formData, body)
  let scheme = call_594973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594973.url(scheme.get, call_594973.host, call_594973.base,
                         call_594973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594973, url, valid)

proc call*(call_594974: Call_VirtualMachinesAddDataDisk_594964;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; dataDiskProperties: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594975 = newJObject()
  var query_594976 = newJObject()
  var body_594977 = newJObject()
  add(path_594975, "resourceGroupName", newJString(resourceGroupName))
  add(query_594976, "api-version", newJString(apiVersion))
  add(path_594975, "name", newJString(name))
  add(path_594975, "subscriptionId", newJString(subscriptionId))
  add(path_594975, "labName", newJString(labName))
  if dataDiskProperties != nil:
    body_594977 = dataDiskProperties
  result = call_594974.call(path_594975, query_594976, nil, nil, body_594977)

var virtualMachinesAddDataDisk* = Call_VirtualMachinesAddDataDisk_594964(
    name: "virtualMachinesAddDataDisk", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/addDataDisk",
    validator: validate_VirtualMachinesAddDataDisk_594965, base: "",
    url: url_VirtualMachinesAddDataDisk_594966, schemes: {Scheme.Https})
type
  Call_VirtualMachinesApplyArtifacts_594978 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinesApplyArtifacts_594980(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesApplyArtifacts_594979(path: JsonNode; query: JsonNode;
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
  var valid_594981 = path.getOrDefault("resourceGroupName")
  valid_594981 = validateParameter(valid_594981, JString, required = true,
                                 default = nil)
  if valid_594981 != nil:
    section.add "resourceGroupName", valid_594981
  var valid_594982 = path.getOrDefault("name")
  valid_594982 = validateParameter(valid_594982, JString, required = true,
                                 default = nil)
  if valid_594982 != nil:
    section.add "name", valid_594982
  var valid_594983 = path.getOrDefault("subscriptionId")
  valid_594983 = validateParameter(valid_594983, JString, required = true,
                                 default = nil)
  if valid_594983 != nil:
    section.add "subscriptionId", valid_594983
  var valid_594984 = path.getOrDefault("labName")
  valid_594984 = validateParameter(valid_594984, JString, required = true,
                                 default = nil)
  if valid_594984 != nil:
    section.add "labName", valid_594984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594985 = query.getOrDefault("api-version")
  valid_594985 = validateParameter(valid_594985, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594985 != nil:
    section.add "api-version", valid_594985
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

proc call*(call_594987: Call_VirtualMachinesApplyArtifacts_594978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply artifacts to virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_594987.validator(path, query, header, formData, body)
  let scheme = call_594987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594987.url(scheme.get, call_594987.host, call_594987.base,
                         call_594987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594987, url, valid)

proc call*(call_594988: Call_VirtualMachinesApplyArtifacts_594978;
          resourceGroupName: string; name: string; subscriptionId: string;
          applyArtifactsRequest: JsonNode; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_594989 = newJObject()
  var query_594990 = newJObject()
  var body_594991 = newJObject()
  add(path_594989, "resourceGroupName", newJString(resourceGroupName))
  add(query_594990, "api-version", newJString(apiVersion))
  add(path_594989, "name", newJString(name))
  add(path_594989, "subscriptionId", newJString(subscriptionId))
  if applyArtifactsRequest != nil:
    body_594991 = applyArtifactsRequest
  add(path_594989, "labName", newJString(labName))
  result = call_594988.call(path_594989, query_594990, nil, nil, body_594991)

var virtualMachinesApplyArtifacts* = Call_VirtualMachinesApplyArtifacts_594978(
    name: "virtualMachinesApplyArtifacts", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/applyArtifacts",
    validator: validate_VirtualMachinesApplyArtifacts_594979, base: "",
    url: url_VirtualMachinesApplyArtifacts_594980, schemes: {Scheme.Https})
type
  Call_VirtualMachinesClaim_594992 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinesClaim_594994(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesClaim_594993(path: JsonNode; query: JsonNode;
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
  var valid_594995 = path.getOrDefault("resourceGroupName")
  valid_594995 = validateParameter(valid_594995, JString, required = true,
                                 default = nil)
  if valid_594995 != nil:
    section.add "resourceGroupName", valid_594995
  var valid_594996 = path.getOrDefault("name")
  valid_594996 = validateParameter(valid_594996, JString, required = true,
                                 default = nil)
  if valid_594996 != nil:
    section.add "name", valid_594996
  var valid_594997 = path.getOrDefault("subscriptionId")
  valid_594997 = validateParameter(valid_594997, JString, required = true,
                                 default = nil)
  if valid_594997 != nil:
    section.add "subscriptionId", valid_594997
  var valid_594998 = path.getOrDefault("labName")
  valid_594998 = validateParameter(valid_594998, JString, required = true,
                                 default = nil)
  if valid_594998 != nil:
    section.add "labName", valid_594998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594999 = query.getOrDefault("api-version")
  valid_594999 = validateParameter(valid_594999, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_594999 != nil:
    section.add "api-version", valid_594999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595000: Call_VirtualMachinesClaim_594992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  let valid = call_595000.validator(path, query, header, formData, body)
  let scheme = call_595000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595000.url(scheme.get, call_595000.host, call_595000.base,
                         call_595000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595000, url, valid)

proc call*(call_595001: Call_VirtualMachinesClaim_594992;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595002 = newJObject()
  var query_595003 = newJObject()
  add(path_595002, "resourceGroupName", newJString(resourceGroupName))
  add(query_595003, "api-version", newJString(apiVersion))
  add(path_595002, "name", newJString(name))
  add(path_595002, "subscriptionId", newJString(subscriptionId))
  add(path_595002, "labName", newJString(labName))
  result = call_595001.call(path_595002, query_595003, nil, nil, nil)

var virtualMachinesClaim* = Call_VirtualMachinesClaim_594992(
    name: "virtualMachinesClaim", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/claim",
    validator: validate_VirtualMachinesClaim_594993, base: "",
    url: url_VirtualMachinesClaim_594994, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDetachDataDisk_595004 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinesDetachDataDisk_595006(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesDetachDataDisk_595005(path: JsonNode; query: JsonNode;
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
  var valid_595007 = path.getOrDefault("resourceGroupName")
  valid_595007 = validateParameter(valid_595007, JString, required = true,
                                 default = nil)
  if valid_595007 != nil:
    section.add "resourceGroupName", valid_595007
  var valid_595008 = path.getOrDefault("name")
  valid_595008 = validateParameter(valid_595008, JString, required = true,
                                 default = nil)
  if valid_595008 != nil:
    section.add "name", valid_595008
  var valid_595009 = path.getOrDefault("subscriptionId")
  valid_595009 = validateParameter(valid_595009, JString, required = true,
                                 default = nil)
  if valid_595009 != nil:
    section.add "subscriptionId", valid_595009
  var valid_595010 = path.getOrDefault("labName")
  valid_595010 = validateParameter(valid_595010, JString, required = true,
                                 default = nil)
  if valid_595010 != nil:
    section.add "labName", valid_595010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595011 = query.getOrDefault("api-version")
  valid_595011 = validateParameter(valid_595011, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595011 != nil:
    section.add "api-version", valid_595011
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

proc call*(call_595013: Call_VirtualMachinesDetachDataDisk_595004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the specified disk from the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_595013.validator(path, query, header, formData, body)
  let scheme = call_595013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595013.url(scheme.get, call_595013.host, call_595013.base,
                         call_595013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595013, url, valid)

proc call*(call_595014: Call_VirtualMachinesDetachDataDisk_595004;
          resourceGroupName: string; name: string; subscriptionId: string;
          detachDataDiskProperties: JsonNode; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595015 = newJObject()
  var query_595016 = newJObject()
  var body_595017 = newJObject()
  add(path_595015, "resourceGroupName", newJString(resourceGroupName))
  add(query_595016, "api-version", newJString(apiVersion))
  add(path_595015, "name", newJString(name))
  add(path_595015, "subscriptionId", newJString(subscriptionId))
  if detachDataDiskProperties != nil:
    body_595017 = detachDataDiskProperties
  add(path_595015, "labName", newJString(labName))
  result = call_595014.call(path_595015, query_595016, nil, nil, body_595017)

var virtualMachinesDetachDataDisk* = Call_VirtualMachinesDetachDataDisk_595004(
    name: "virtualMachinesDetachDataDisk", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/detachDataDisk",
    validator: validate_VirtualMachinesDetachDataDisk_595005, base: "",
    url: url_VirtualMachinesDetachDataDisk_595006, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListApplicableSchedules_595018 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinesListApplicableSchedules_595020(protocol: Scheme;
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

proc validate_VirtualMachinesListApplicableSchedules_595019(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all applicable schedules
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
  var valid_595021 = path.getOrDefault("resourceGroupName")
  valid_595021 = validateParameter(valid_595021, JString, required = true,
                                 default = nil)
  if valid_595021 != nil:
    section.add "resourceGroupName", valid_595021
  var valid_595022 = path.getOrDefault("name")
  valid_595022 = validateParameter(valid_595022, JString, required = true,
                                 default = nil)
  if valid_595022 != nil:
    section.add "name", valid_595022
  var valid_595023 = path.getOrDefault("subscriptionId")
  valid_595023 = validateParameter(valid_595023, JString, required = true,
                                 default = nil)
  if valid_595023 != nil:
    section.add "subscriptionId", valid_595023
  var valid_595024 = path.getOrDefault("labName")
  valid_595024 = validateParameter(valid_595024, JString, required = true,
                                 default = nil)
  if valid_595024 != nil:
    section.add "labName", valid_595024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595025 = query.getOrDefault("api-version")
  valid_595025 = validateParameter(valid_595025, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595025 != nil:
    section.add "api-version", valid_595025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595026: Call_VirtualMachinesListApplicableSchedules_595018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all applicable schedules
  ## 
  let valid = call_595026.validator(path, query, header, formData, body)
  let scheme = call_595026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595026.url(scheme.get, call_595026.host, call_595026.base,
                         call_595026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595026, url, valid)

proc call*(call_595027: Call_VirtualMachinesListApplicableSchedules_595018;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesListApplicableSchedules
  ## Lists all applicable schedules
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
  var path_595028 = newJObject()
  var query_595029 = newJObject()
  add(path_595028, "resourceGroupName", newJString(resourceGroupName))
  add(query_595029, "api-version", newJString(apiVersion))
  add(path_595028, "name", newJString(name))
  add(path_595028, "subscriptionId", newJString(subscriptionId))
  add(path_595028, "labName", newJString(labName))
  result = call_595027.call(path_595028, query_595029, nil, nil, nil)

var virtualMachinesListApplicableSchedules* = Call_VirtualMachinesListApplicableSchedules_595018(
    name: "virtualMachinesListApplicableSchedules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/listApplicableSchedules",
    validator: validate_VirtualMachinesListApplicableSchedules_595019, base: "",
    url: url_VirtualMachinesListApplicableSchedules_595020,
    schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_595030 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinesStart_595032(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStart_595031(path: JsonNode; query: JsonNode;
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
  var valid_595033 = path.getOrDefault("resourceGroupName")
  valid_595033 = validateParameter(valid_595033, JString, required = true,
                                 default = nil)
  if valid_595033 != nil:
    section.add "resourceGroupName", valid_595033
  var valid_595034 = path.getOrDefault("name")
  valid_595034 = validateParameter(valid_595034, JString, required = true,
                                 default = nil)
  if valid_595034 != nil:
    section.add "name", valid_595034
  var valid_595035 = path.getOrDefault("subscriptionId")
  valid_595035 = validateParameter(valid_595035, JString, required = true,
                                 default = nil)
  if valid_595035 != nil:
    section.add "subscriptionId", valid_595035
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
                                 default = newJString("2016-05-15"))
  if valid_595037 != nil:
    section.add "api-version", valid_595037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595038: Call_VirtualMachinesStart_595030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start a virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_595038.validator(path, query, header, formData, body)
  let scheme = call_595038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595038.url(scheme.get, call_595038.host, call_595038.base,
                         call_595038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595038, url, valid)

proc call*(call_595039: Call_VirtualMachinesStart_595030;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595040 = newJObject()
  var query_595041 = newJObject()
  add(path_595040, "resourceGroupName", newJString(resourceGroupName))
  add(query_595041, "api-version", newJString(apiVersion))
  add(path_595040, "name", newJString(name))
  add(path_595040, "subscriptionId", newJString(subscriptionId))
  add(path_595040, "labName", newJString(labName))
  result = call_595039.call(path_595040, query_595041, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_595030(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/start",
    validator: validate_VirtualMachinesStart_595031, base: "",
    url: url_VirtualMachinesStart_595032, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStop_595042 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinesStop_595044(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStop_595043(path: JsonNode; query: JsonNode;
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
  var valid_595045 = path.getOrDefault("resourceGroupName")
  valid_595045 = validateParameter(valid_595045, JString, required = true,
                                 default = nil)
  if valid_595045 != nil:
    section.add "resourceGroupName", valid_595045
  var valid_595046 = path.getOrDefault("name")
  valid_595046 = validateParameter(valid_595046, JString, required = true,
                                 default = nil)
  if valid_595046 != nil:
    section.add "name", valid_595046
  var valid_595047 = path.getOrDefault("subscriptionId")
  valid_595047 = validateParameter(valid_595047, JString, required = true,
                                 default = nil)
  if valid_595047 != nil:
    section.add "subscriptionId", valid_595047
  var valid_595048 = path.getOrDefault("labName")
  valid_595048 = validateParameter(valid_595048, JString, required = true,
                                 default = nil)
  if valid_595048 != nil:
    section.add "labName", valid_595048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595049 = query.getOrDefault("api-version")
  valid_595049 = validateParameter(valid_595049, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595049 != nil:
    section.add "api-version", valid_595049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595050: Call_VirtualMachinesStop_595042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop a virtual machine This operation can take a while to complete.
  ## 
  let valid = call_595050.validator(path, query, header, formData, body)
  let scheme = call_595050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595050.url(scheme.get, call_595050.host, call_595050.base,
                         call_595050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595050, url, valid)

proc call*(call_595051: Call_VirtualMachinesStop_595042; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595052 = newJObject()
  var query_595053 = newJObject()
  add(path_595052, "resourceGroupName", newJString(resourceGroupName))
  add(query_595053, "api-version", newJString(apiVersion))
  add(path_595052, "name", newJString(name))
  add(path_595052, "subscriptionId", newJString(subscriptionId))
  add(path_595052, "labName", newJString(labName))
  result = call_595051.call(path_595052, query_595053, nil, nil, nil)

var virtualMachinesStop* = Call_VirtualMachinesStop_595042(
    name: "virtualMachinesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/stop",
    validator: validate_VirtualMachinesStop_595043, base: "",
    url: url_VirtualMachinesStop_595044, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesList_595054 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineSchedulesList_595056(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesList_595055(path: JsonNode; query: JsonNode;
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
  var valid_595057 = path.getOrDefault("resourceGroupName")
  valid_595057 = validateParameter(valid_595057, JString, required = true,
                                 default = nil)
  if valid_595057 != nil:
    section.add "resourceGroupName", valid_595057
  var valid_595058 = path.getOrDefault("virtualMachineName")
  valid_595058 = validateParameter(valid_595058, JString, required = true,
                                 default = nil)
  if valid_595058 != nil:
    section.add "virtualMachineName", valid_595058
  var valid_595059 = path.getOrDefault("subscriptionId")
  valid_595059 = validateParameter(valid_595059, JString, required = true,
                                 default = nil)
  if valid_595059 != nil:
    section.add "subscriptionId", valid_595059
  var valid_595060 = path.getOrDefault("labName")
  valid_595060 = validateParameter(valid_595060, JString, required = true,
                                 default = nil)
  if valid_595060 != nil:
    section.add "labName", valid_595060
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_595061 = query.getOrDefault("$orderby")
  valid_595061 = validateParameter(valid_595061, JString, required = false,
                                 default = nil)
  if valid_595061 != nil:
    section.add "$orderby", valid_595061
  var valid_595062 = query.getOrDefault("$expand")
  valid_595062 = validateParameter(valid_595062, JString, required = false,
                                 default = nil)
  if valid_595062 != nil:
    section.add "$expand", valid_595062
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595063 = query.getOrDefault("api-version")
  valid_595063 = validateParameter(valid_595063, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595063 != nil:
    section.add "api-version", valid_595063
  var valid_595064 = query.getOrDefault("$top")
  valid_595064 = validateParameter(valid_595064, JInt, required = false, default = nil)
  if valid_595064 != nil:
    section.add "$top", valid_595064
  var valid_595065 = query.getOrDefault("$filter")
  valid_595065 = validateParameter(valid_595065, JString, required = false,
                                 default = nil)
  if valid_595065 != nil:
    section.add "$filter", valid_595065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595066: Call_VirtualMachineSchedulesList_595054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given virtual machine.
  ## 
  let valid = call_595066.validator(path, query, header, formData, body)
  let scheme = call_595066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595066.url(scheme.get, call_595066.host, call_595066.base,
                         call_595066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595066, url, valid)

proc call*(call_595067: Call_VirtualMachineSchedulesList_595054;
          resourceGroupName: string; virtualMachineName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualMachineSchedulesList
  ## List schedules in a given virtual machine.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
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
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_595068 = newJObject()
  var query_595069 = newJObject()
  add(query_595069, "$orderby", newJString(Orderby))
  add(path_595068, "resourceGroupName", newJString(resourceGroupName))
  add(query_595069, "$expand", newJString(Expand))
  add(path_595068, "virtualMachineName", newJString(virtualMachineName))
  add(query_595069, "api-version", newJString(apiVersion))
  add(path_595068, "subscriptionId", newJString(subscriptionId))
  add(query_595069, "$top", newJInt(Top))
  add(path_595068, "labName", newJString(labName))
  add(query_595069, "$filter", newJString(Filter))
  result = call_595067.call(path_595068, query_595069, nil, nil, nil)

var virtualMachineSchedulesList* = Call_VirtualMachineSchedulesList_595054(
    name: "virtualMachineSchedulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules",
    validator: validate_VirtualMachineSchedulesList_595055, base: "",
    url: url_VirtualMachineSchedulesList_595056, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesCreateOrUpdate_595084 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineSchedulesCreateOrUpdate_595086(protocol: Scheme;
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

proc validate_VirtualMachineSchedulesCreateOrUpdate_595085(path: JsonNode;
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
  var valid_595087 = path.getOrDefault("resourceGroupName")
  valid_595087 = validateParameter(valid_595087, JString, required = true,
                                 default = nil)
  if valid_595087 != nil:
    section.add "resourceGroupName", valid_595087
  var valid_595088 = path.getOrDefault("virtualMachineName")
  valid_595088 = validateParameter(valid_595088, JString, required = true,
                                 default = nil)
  if valid_595088 != nil:
    section.add "virtualMachineName", valid_595088
  var valid_595089 = path.getOrDefault("name")
  valid_595089 = validateParameter(valid_595089, JString, required = true,
                                 default = nil)
  if valid_595089 != nil:
    section.add "name", valid_595089
  var valid_595090 = path.getOrDefault("subscriptionId")
  valid_595090 = validateParameter(valid_595090, JString, required = true,
                                 default = nil)
  if valid_595090 != nil:
    section.add "subscriptionId", valid_595090
  var valid_595091 = path.getOrDefault("labName")
  valid_595091 = validateParameter(valid_595091, JString, required = true,
                                 default = nil)
  if valid_595091 != nil:
    section.add "labName", valid_595091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595092 = query.getOrDefault("api-version")
  valid_595092 = validateParameter(valid_595092, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595092 != nil:
    section.add "api-version", valid_595092
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

proc call*(call_595094: Call_VirtualMachineSchedulesCreateOrUpdate_595084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_595094.validator(path, query, header, formData, body)
  let scheme = call_595094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595094.url(scheme.get, call_595094.host, call_595094.base,
                         call_595094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595094, url, valid)

proc call*(call_595095: Call_VirtualMachineSchedulesCreateOrUpdate_595084;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; schedule: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595096 = newJObject()
  var query_595097 = newJObject()
  var body_595098 = newJObject()
  add(path_595096, "resourceGroupName", newJString(resourceGroupName))
  add(query_595097, "api-version", newJString(apiVersion))
  add(path_595096, "virtualMachineName", newJString(virtualMachineName))
  add(path_595096, "name", newJString(name))
  add(path_595096, "subscriptionId", newJString(subscriptionId))
  add(path_595096, "labName", newJString(labName))
  if schedule != nil:
    body_595098 = schedule
  result = call_595095.call(path_595096, query_595097, nil, nil, body_595098)

var virtualMachineSchedulesCreateOrUpdate* = Call_VirtualMachineSchedulesCreateOrUpdate_595084(
    name: "virtualMachineSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesCreateOrUpdate_595085, base: "",
    url: url_VirtualMachineSchedulesCreateOrUpdate_595086, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesGet_595070 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineSchedulesGet_595072(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesGet_595071(path: JsonNode; query: JsonNode;
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
  var valid_595073 = path.getOrDefault("resourceGroupName")
  valid_595073 = validateParameter(valid_595073, JString, required = true,
                                 default = nil)
  if valid_595073 != nil:
    section.add "resourceGroupName", valid_595073
  var valid_595074 = path.getOrDefault("virtualMachineName")
  valid_595074 = validateParameter(valid_595074, JString, required = true,
                                 default = nil)
  if valid_595074 != nil:
    section.add "virtualMachineName", valid_595074
  var valid_595075 = path.getOrDefault("name")
  valid_595075 = validateParameter(valid_595075, JString, required = true,
                                 default = nil)
  if valid_595075 != nil:
    section.add "name", valid_595075
  var valid_595076 = path.getOrDefault("subscriptionId")
  valid_595076 = validateParameter(valid_595076, JString, required = true,
                                 default = nil)
  if valid_595076 != nil:
    section.add "subscriptionId", valid_595076
  var valid_595077 = path.getOrDefault("labName")
  valid_595077 = validateParameter(valid_595077, JString, required = true,
                                 default = nil)
  if valid_595077 != nil:
    section.add "labName", valid_595077
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_595078 = query.getOrDefault("$expand")
  valid_595078 = validateParameter(valid_595078, JString, required = false,
                                 default = nil)
  if valid_595078 != nil:
    section.add "$expand", valid_595078
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595079 = query.getOrDefault("api-version")
  valid_595079 = validateParameter(valid_595079, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595079 != nil:
    section.add "api-version", valid_595079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595080: Call_VirtualMachineSchedulesGet_595070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_595080.validator(path, query, header, formData, body)
  let scheme = call_595080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595080.url(scheme.get, call_595080.host, call_595080.base,
                         call_595080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595080, url, valid)

proc call*(call_595081: Call_VirtualMachineSchedulesGet_595070;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595082 = newJObject()
  var query_595083 = newJObject()
  add(path_595082, "resourceGroupName", newJString(resourceGroupName))
  add(query_595083, "$expand", newJString(Expand))
  add(path_595082, "virtualMachineName", newJString(virtualMachineName))
  add(path_595082, "name", newJString(name))
  add(query_595083, "api-version", newJString(apiVersion))
  add(path_595082, "subscriptionId", newJString(subscriptionId))
  add(path_595082, "labName", newJString(labName))
  result = call_595081.call(path_595082, query_595083, nil, nil, nil)

var virtualMachineSchedulesGet* = Call_VirtualMachineSchedulesGet_595070(
    name: "virtualMachineSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesGet_595071, base: "",
    url: url_VirtualMachineSchedulesGet_595072, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesUpdate_595112 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineSchedulesUpdate_595114(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesUpdate_595113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of schedules.
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
  var valid_595115 = path.getOrDefault("resourceGroupName")
  valid_595115 = validateParameter(valid_595115, JString, required = true,
                                 default = nil)
  if valid_595115 != nil:
    section.add "resourceGroupName", valid_595115
  var valid_595116 = path.getOrDefault("virtualMachineName")
  valid_595116 = validateParameter(valid_595116, JString, required = true,
                                 default = nil)
  if valid_595116 != nil:
    section.add "virtualMachineName", valid_595116
  var valid_595117 = path.getOrDefault("name")
  valid_595117 = validateParameter(valid_595117, JString, required = true,
                                 default = nil)
  if valid_595117 != nil:
    section.add "name", valid_595117
  var valid_595118 = path.getOrDefault("subscriptionId")
  valid_595118 = validateParameter(valid_595118, JString, required = true,
                                 default = nil)
  if valid_595118 != nil:
    section.add "subscriptionId", valid_595118
  var valid_595119 = path.getOrDefault("labName")
  valid_595119 = validateParameter(valid_595119, JString, required = true,
                                 default = nil)
  if valid_595119 != nil:
    section.add "labName", valid_595119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595120 = query.getOrDefault("api-version")
  valid_595120 = validateParameter(valid_595120, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595120 != nil:
    section.add "api-version", valid_595120
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

proc call*(call_595122: Call_VirtualMachineSchedulesUpdate_595112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of schedules.
  ## 
  let valid = call_595122.validator(path, query, header, formData, body)
  let scheme = call_595122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595122.url(scheme.get, call_595122.host, call_595122.base,
                         call_595122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595122, url, valid)

proc call*(call_595123: Call_VirtualMachineSchedulesUpdate_595112;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; schedule: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachineSchedulesUpdate
  ## Modify properties of schedules.
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
  var path_595124 = newJObject()
  var query_595125 = newJObject()
  var body_595126 = newJObject()
  add(path_595124, "resourceGroupName", newJString(resourceGroupName))
  add(query_595125, "api-version", newJString(apiVersion))
  add(path_595124, "virtualMachineName", newJString(virtualMachineName))
  add(path_595124, "name", newJString(name))
  add(path_595124, "subscriptionId", newJString(subscriptionId))
  add(path_595124, "labName", newJString(labName))
  if schedule != nil:
    body_595126 = schedule
  result = call_595123.call(path_595124, query_595125, nil, nil, body_595126)

var virtualMachineSchedulesUpdate* = Call_VirtualMachineSchedulesUpdate_595112(
    name: "virtualMachineSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesUpdate_595113, base: "",
    url: url_VirtualMachineSchedulesUpdate_595114, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesDelete_595099 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineSchedulesDelete_595101(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesDelete_595100(path: JsonNode; query: JsonNode;
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
  var valid_595102 = path.getOrDefault("resourceGroupName")
  valid_595102 = validateParameter(valid_595102, JString, required = true,
                                 default = nil)
  if valid_595102 != nil:
    section.add "resourceGroupName", valid_595102
  var valid_595103 = path.getOrDefault("virtualMachineName")
  valid_595103 = validateParameter(valid_595103, JString, required = true,
                                 default = nil)
  if valid_595103 != nil:
    section.add "virtualMachineName", valid_595103
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
  var valid_595106 = path.getOrDefault("labName")
  valid_595106 = validateParameter(valid_595106, JString, required = true,
                                 default = nil)
  if valid_595106 != nil:
    section.add "labName", valid_595106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595107 = query.getOrDefault("api-version")
  valid_595107 = validateParameter(valid_595107, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595107 != nil:
    section.add "api-version", valid_595107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595108: Call_VirtualMachineSchedulesDelete_595099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_595108.validator(path, query, header, formData, body)
  let scheme = call_595108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595108.url(scheme.get, call_595108.host, call_595108.base,
                         call_595108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595108, url, valid)

proc call*(call_595109: Call_VirtualMachineSchedulesDelete_595099;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595110 = newJObject()
  var query_595111 = newJObject()
  add(path_595110, "resourceGroupName", newJString(resourceGroupName))
  add(query_595111, "api-version", newJString(apiVersion))
  add(path_595110, "virtualMachineName", newJString(virtualMachineName))
  add(path_595110, "name", newJString(name))
  add(path_595110, "subscriptionId", newJString(subscriptionId))
  add(path_595110, "labName", newJString(labName))
  result = call_595109.call(path_595110, query_595111, nil, nil, nil)

var virtualMachineSchedulesDelete* = Call_VirtualMachineSchedulesDelete_595099(
    name: "virtualMachineSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesDelete_595100, base: "",
    url: url_VirtualMachineSchedulesDelete_595101, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesExecute_595127 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineSchedulesExecute_595129(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesExecute_595128(path: JsonNode;
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
  var valid_595130 = path.getOrDefault("resourceGroupName")
  valid_595130 = validateParameter(valid_595130, JString, required = true,
                                 default = nil)
  if valid_595130 != nil:
    section.add "resourceGroupName", valid_595130
  var valid_595131 = path.getOrDefault("virtualMachineName")
  valid_595131 = validateParameter(valid_595131, JString, required = true,
                                 default = nil)
  if valid_595131 != nil:
    section.add "virtualMachineName", valid_595131
  var valid_595132 = path.getOrDefault("name")
  valid_595132 = validateParameter(valid_595132, JString, required = true,
                                 default = nil)
  if valid_595132 != nil:
    section.add "name", valid_595132
  var valid_595133 = path.getOrDefault("subscriptionId")
  valid_595133 = validateParameter(valid_595133, JString, required = true,
                                 default = nil)
  if valid_595133 != nil:
    section.add "subscriptionId", valid_595133
  var valid_595134 = path.getOrDefault("labName")
  valid_595134 = validateParameter(valid_595134, JString, required = true,
                                 default = nil)
  if valid_595134 != nil:
    section.add "labName", valid_595134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595135 = query.getOrDefault("api-version")
  valid_595135 = validateParameter(valid_595135, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595135 != nil:
    section.add "api-version", valid_595135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595136: Call_VirtualMachineSchedulesExecute_595127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_595136.validator(path, query, header, formData, body)
  let scheme = call_595136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595136.url(scheme.get, call_595136.host, call_595136.base,
                         call_595136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595136, url, valid)

proc call*(call_595137: Call_VirtualMachineSchedulesExecute_595127;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595138 = newJObject()
  var query_595139 = newJObject()
  add(path_595138, "resourceGroupName", newJString(resourceGroupName))
  add(query_595139, "api-version", newJString(apiVersion))
  add(path_595138, "virtualMachineName", newJString(virtualMachineName))
  add(path_595138, "name", newJString(name))
  add(path_595138, "subscriptionId", newJString(subscriptionId))
  add(path_595138, "labName", newJString(labName))
  result = call_595137.call(path_595138, query_595139, nil, nil, nil)

var virtualMachineSchedulesExecute* = Call_VirtualMachineSchedulesExecute_595127(
    name: "virtualMachineSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}/execute",
    validator: validate_VirtualMachineSchedulesExecute_595128, base: "",
    url: url_VirtualMachineSchedulesExecute_595129, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_595140 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworksList_595142(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksList_595141(path: JsonNode; query: JsonNode;
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
  var valid_595143 = path.getOrDefault("resourceGroupName")
  valid_595143 = validateParameter(valid_595143, JString, required = true,
                                 default = nil)
  if valid_595143 != nil:
    section.add "resourceGroupName", valid_595143
  var valid_595144 = path.getOrDefault("subscriptionId")
  valid_595144 = validateParameter(valid_595144, JString, required = true,
                                 default = nil)
  if valid_595144 != nil:
    section.add "subscriptionId", valid_595144
  var valid_595145 = path.getOrDefault("labName")
  valid_595145 = validateParameter(valid_595145, JString, required = true,
                                 default = nil)
  if valid_595145 != nil:
    section.add "labName", valid_595145
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_595146 = query.getOrDefault("$orderby")
  valid_595146 = validateParameter(valid_595146, JString, required = false,
                                 default = nil)
  if valid_595146 != nil:
    section.add "$orderby", valid_595146
  var valid_595147 = query.getOrDefault("$expand")
  valid_595147 = validateParameter(valid_595147, JString, required = false,
                                 default = nil)
  if valid_595147 != nil:
    section.add "$expand", valid_595147
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595148 = query.getOrDefault("api-version")
  valid_595148 = validateParameter(valid_595148, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595148 != nil:
    section.add "api-version", valid_595148
  var valid_595149 = query.getOrDefault("$top")
  valid_595149 = validateParameter(valid_595149, JInt, required = false, default = nil)
  if valid_595149 != nil:
    section.add "$top", valid_595149
  var valid_595150 = query.getOrDefault("$filter")
  valid_595150 = validateParameter(valid_595150, JString, required = false,
                                 default = nil)
  if valid_595150 != nil:
    section.add "$filter", valid_595150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595151: Call_VirtualNetworksList_595140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual networks in a given lab.
  ## 
  let valid = call_595151.validator(path, query, header, formData, body)
  let scheme = call_595151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595151.url(scheme.get, call_595151.host, call_595151.base,
                         call_595151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595151, url, valid)

proc call*(call_595152: Call_VirtualNetworksList_595140; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualNetworksList
  ## List virtual networks in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_595153 = newJObject()
  var query_595154 = newJObject()
  add(query_595154, "$orderby", newJString(Orderby))
  add(path_595153, "resourceGroupName", newJString(resourceGroupName))
  add(query_595154, "$expand", newJString(Expand))
  add(query_595154, "api-version", newJString(apiVersion))
  add(path_595153, "subscriptionId", newJString(subscriptionId))
  add(query_595154, "$top", newJInt(Top))
  add(path_595153, "labName", newJString(labName))
  add(query_595154, "$filter", newJString(Filter))
  result = call_595152.call(path_595153, query_595154, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_595140(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks",
    validator: validate_VirtualNetworksList_595141, base: "",
    url: url_VirtualNetworksList_595142, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_595168 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworksCreateOrUpdate_595170(protocol: Scheme; host: string;
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

proc validate_VirtualNetworksCreateOrUpdate_595169(path: JsonNode; query: JsonNode;
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
  var valid_595171 = path.getOrDefault("resourceGroupName")
  valid_595171 = validateParameter(valid_595171, JString, required = true,
                                 default = nil)
  if valid_595171 != nil:
    section.add "resourceGroupName", valid_595171
  var valid_595172 = path.getOrDefault("name")
  valid_595172 = validateParameter(valid_595172, JString, required = true,
                                 default = nil)
  if valid_595172 != nil:
    section.add "name", valid_595172
  var valid_595173 = path.getOrDefault("subscriptionId")
  valid_595173 = validateParameter(valid_595173, JString, required = true,
                                 default = nil)
  if valid_595173 != nil:
    section.add "subscriptionId", valid_595173
  var valid_595174 = path.getOrDefault("labName")
  valid_595174 = validateParameter(valid_595174, JString, required = true,
                                 default = nil)
  if valid_595174 != nil:
    section.add "labName", valid_595174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595175 = query.getOrDefault("api-version")
  valid_595175 = validateParameter(valid_595175, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595175 != nil:
    section.add "api-version", valid_595175
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

proc call*(call_595177: Call_VirtualNetworksCreateOrUpdate_595168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  let valid = call_595177.validator(path, query, header, formData, body)
  let scheme = call_595177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595177.url(scheme.get, call_595177.host, call_595177.base,
                         call_595177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595177, url, valid)

proc call*(call_595178: Call_VirtualNetworksCreateOrUpdate_595168;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595179 = newJObject()
  var query_595180 = newJObject()
  var body_595181 = newJObject()
  add(path_595179, "resourceGroupName", newJString(resourceGroupName))
  add(query_595180, "api-version", newJString(apiVersion))
  add(path_595179, "name", newJString(name))
  add(path_595179, "subscriptionId", newJString(subscriptionId))
  add(path_595179, "labName", newJString(labName))
  if virtualNetwork != nil:
    body_595181 = virtualNetwork
  result = call_595178.call(path_595179, query_595180, nil, nil, body_595181)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_595168(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksCreateOrUpdate_595169, base: "",
    url: url_VirtualNetworksCreateOrUpdate_595170, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_595155 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworksGet_595157(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksGet_595156(path: JsonNode; query: JsonNode;
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
  var valid_595158 = path.getOrDefault("resourceGroupName")
  valid_595158 = validateParameter(valid_595158, JString, required = true,
                                 default = nil)
  if valid_595158 != nil:
    section.add "resourceGroupName", valid_595158
  var valid_595159 = path.getOrDefault("name")
  valid_595159 = validateParameter(valid_595159, JString, required = true,
                                 default = nil)
  if valid_595159 != nil:
    section.add "name", valid_595159
  var valid_595160 = path.getOrDefault("subscriptionId")
  valid_595160 = validateParameter(valid_595160, JString, required = true,
                                 default = nil)
  if valid_595160 != nil:
    section.add "subscriptionId", valid_595160
  var valid_595161 = path.getOrDefault("labName")
  valid_595161 = validateParameter(valid_595161, JString, required = true,
                                 default = nil)
  if valid_595161 != nil:
    section.add "labName", valid_595161
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_595162 = query.getOrDefault("$expand")
  valid_595162 = validateParameter(valid_595162, JString, required = false,
                                 default = nil)
  if valid_595162 != nil:
    section.add "$expand", valid_595162
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595163 = query.getOrDefault("api-version")
  valid_595163 = validateParameter(valid_595163, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595163 != nil:
    section.add "api-version", valid_595163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595164: Call_VirtualNetworksGet_595155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual network.
  ## 
  let valid = call_595164.validator(path, query, header, formData, body)
  let scheme = call_595164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595164.url(scheme.get, call_595164.host, call_595164.base,
                         call_595164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595164, url, valid)

proc call*(call_595165: Call_VirtualNetworksGet_595155; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595166 = newJObject()
  var query_595167 = newJObject()
  add(path_595166, "resourceGroupName", newJString(resourceGroupName))
  add(query_595167, "$expand", newJString(Expand))
  add(path_595166, "name", newJString(name))
  add(query_595167, "api-version", newJString(apiVersion))
  add(path_595166, "subscriptionId", newJString(subscriptionId))
  add(path_595166, "labName", newJString(labName))
  result = call_595165.call(path_595166, query_595167, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_595155(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksGet_595156, base: "",
    url: url_VirtualNetworksGet_595157, schemes: {Scheme.Https})
type
  Call_VirtualNetworksUpdate_595194 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworksUpdate_595196(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksUpdate_595195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of virtual networks.
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
  var valid_595197 = path.getOrDefault("resourceGroupName")
  valid_595197 = validateParameter(valid_595197, JString, required = true,
                                 default = nil)
  if valid_595197 != nil:
    section.add "resourceGroupName", valid_595197
  var valid_595198 = path.getOrDefault("name")
  valid_595198 = validateParameter(valid_595198, JString, required = true,
                                 default = nil)
  if valid_595198 != nil:
    section.add "name", valid_595198
  var valid_595199 = path.getOrDefault("subscriptionId")
  valid_595199 = validateParameter(valid_595199, JString, required = true,
                                 default = nil)
  if valid_595199 != nil:
    section.add "subscriptionId", valid_595199
  var valid_595200 = path.getOrDefault("labName")
  valid_595200 = validateParameter(valid_595200, JString, required = true,
                                 default = nil)
  if valid_595200 != nil:
    section.add "labName", valid_595200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595201 = query.getOrDefault("api-version")
  valid_595201 = validateParameter(valid_595201, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595201 != nil:
    section.add "api-version", valid_595201
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

proc call*(call_595203: Call_VirtualNetworksUpdate_595194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of virtual networks.
  ## 
  let valid = call_595203.validator(path, query, header, formData, body)
  let scheme = call_595203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595203.url(scheme.get, call_595203.host, call_595203.base,
                         call_595203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595203, url, valid)

proc call*(call_595204: Call_VirtualNetworksUpdate_595194;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualNetworksUpdate
  ## Modify properties of virtual networks.
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
  var path_595205 = newJObject()
  var query_595206 = newJObject()
  var body_595207 = newJObject()
  add(path_595205, "resourceGroupName", newJString(resourceGroupName))
  add(query_595206, "api-version", newJString(apiVersion))
  add(path_595205, "name", newJString(name))
  add(path_595205, "subscriptionId", newJString(subscriptionId))
  add(path_595205, "labName", newJString(labName))
  if virtualNetwork != nil:
    body_595207 = virtualNetwork
  result = call_595204.call(path_595205, query_595206, nil, nil, body_595207)

var virtualNetworksUpdate* = Call_VirtualNetworksUpdate_595194(
    name: "virtualNetworksUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksUpdate_595195, base: "",
    url: url_VirtualNetworksUpdate_595196, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_595182 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworksDelete_595184(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksDelete_595183(path: JsonNode; query: JsonNode;
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
  var valid_595185 = path.getOrDefault("resourceGroupName")
  valid_595185 = validateParameter(valid_595185, JString, required = true,
                                 default = nil)
  if valid_595185 != nil:
    section.add "resourceGroupName", valid_595185
  var valid_595186 = path.getOrDefault("name")
  valid_595186 = validateParameter(valid_595186, JString, required = true,
                                 default = nil)
  if valid_595186 != nil:
    section.add "name", valid_595186
  var valid_595187 = path.getOrDefault("subscriptionId")
  valid_595187 = validateParameter(valid_595187, JString, required = true,
                                 default = nil)
  if valid_595187 != nil:
    section.add "subscriptionId", valid_595187
  var valid_595188 = path.getOrDefault("labName")
  valid_595188 = validateParameter(valid_595188, JString, required = true,
                                 default = nil)
  if valid_595188 != nil:
    section.add "labName", valid_595188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595189 = query.getOrDefault("api-version")
  valid_595189 = validateParameter(valid_595189, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595189 != nil:
    section.add "api-version", valid_595189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595190: Call_VirtualNetworksDelete_595182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  let valid = call_595190.validator(path, query, header, formData, body)
  let scheme = call_595190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595190.url(scheme.get, call_595190.host, call_595190.base,
                         call_595190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595190, url, valid)

proc call*(call_595191: Call_VirtualNetworksDelete_595182;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595192 = newJObject()
  var query_595193 = newJObject()
  add(path_595192, "resourceGroupName", newJString(resourceGroupName))
  add(query_595193, "api-version", newJString(apiVersion))
  add(path_595192, "name", newJString(name))
  add(path_595192, "subscriptionId", newJString(subscriptionId))
  add(path_595192, "labName", newJString(labName))
  result = call_595191.call(path_595192, query_595193, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_595182(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksDelete_595183, base: "",
    url: url_VirtualNetworksDelete_595184, schemes: {Scheme.Https})
type
  Call_LabsCreateOrUpdate_595220 = ref object of OpenApiRestCall_593421
proc url_LabsCreateOrUpdate_595222(protocol: Scheme; host: string; base: string;
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

proc validate_LabsCreateOrUpdate_595221(path: JsonNode; query: JsonNode;
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
  var valid_595223 = path.getOrDefault("resourceGroupName")
  valid_595223 = validateParameter(valid_595223, JString, required = true,
                                 default = nil)
  if valid_595223 != nil:
    section.add "resourceGroupName", valid_595223
  var valid_595224 = path.getOrDefault("name")
  valid_595224 = validateParameter(valid_595224, JString, required = true,
                                 default = nil)
  if valid_595224 != nil:
    section.add "name", valid_595224
  var valid_595225 = path.getOrDefault("subscriptionId")
  valid_595225 = validateParameter(valid_595225, JString, required = true,
                                 default = nil)
  if valid_595225 != nil:
    section.add "subscriptionId", valid_595225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595226 = query.getOrDefault("api-version")
  valid_595226 = validateParameter(valid_595226, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595226 != nil:
    section.add "api-version", valid_595226
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

proc call*(call_595228: Call_LabsCreateOrUpdate_595220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing lab. This operation can take a while to complete.
  ## 
  let valid = call_595228.validator(path, query, header, formData, body)
  let scheme = call_595228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595228.url(scheme.get, call_595228.host, call_595228.base,
                         call_595228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595228, url, valid)

proc call*(call_595229: Call_LabsCreateOrUpdate_595220; resourceGroupName: string;
          name: string; subscriptionId: string; lab: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595230 = newJObject()
  var query_595231 = newJObject()
  var body_595232 = newJObject()
  add(path_595230, "resourceGroupName", newJString(resourceGroupName))
  add(query_595231, "api-version", newJString(apiVersion))
  add(path_595230, "name", newJString(name))
  add(path_595230, "subscriptionId", newJString(subscriptionId))
  if lab != nil:
    body_595232 = lab
  result = call_595229.call(path_595230, query_595231, nil, nil, body_595232)

var labsCreateOrUpdate* = Call_LabsCreateOrUpdate_595220(
    name: "labsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabsCreateOrUpdate_595221, base: "",
    url: url_LabsCreateOrUpdate_595222, schemes: {Scheme.Https})
type
  Call_LabsGet_595208 = ref object of OpenApiRestCall_593421
proc url_LabsGet_595210(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsGet_595209(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_595211 = path.getOrDefault("resourceGroupName")
  valid_595211 = validateParameter(valid_595211, JString, required = true,
                                 default = nil)
  if valid_595211 != nil:
    section.add "resourceGroupName", valid_595211
  var valid_595212 = path.getOrDefault("name")
  valid_595212 = validateParameter(valid_595212, JString, required = true,
                                 default = nil)
  if valid_595212 != nil:
    section.add "name", valid_595212
  var valid_595213 = path.getOrDefault("subscriptionId")
  valid_595213 = validateParameter(valid_595213, JString, required = true,
                                 default = nil)
  if valid_595213 != nil:
    section.add "subscriptionId", valid_595213
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_595214 = query.getOrDefault("$expand")
  valid_595214 = validateParameter(valid_595214, JString, required = false,
                                 default = nil)
  if valid_595214 != nil:
    section.add "$expand", valid_595214
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595215 = query.getOrDefault("api-version")
  valid_595215 = validateParameter(valid_595215, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595215 != nil:
    section.add "api-version", valid_595215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595216: Call_LabsGet_595208; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab.
  ## 
  let valid = call_595216.validator(path, query, header, formData, body)
  let scheme = call_595216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595216.url(scheme.get, call_595216.host, call_595216.base,
                         call_595216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595216, url, valid)

proc call*(call_595217: Call_LabsGet_595208; resourceGroupName: string; name: string;
          subscriptionId: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595218 = newJObject()
  var query_595219 = newJObject()
  add(path_595218, "resourceGroupName", newJString(resourceGroupName))
  add(query_595219, "$expand", newJString(Expand))
  add(path_595218, "name", newJString(name))
  add(query_595219, "api-version", newJString(apiVersion))
  add(path_595218, "subscriptionId", newJString(subscriptionId))
  result = call_595217.call(path_595218, query_595219, nil, nil, nil)

var labsGet* = Call_LabsGet_595208(name: "labsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                validator: validate_LabsGet_595209, base: "",
                                url: url_LabsGet_595210, schemes: {Scheme.Https})
type
  Call_LabsUpdate_595244 = ref object of OpenApiRestCall_593421
proc url_LabsUpdate_595246(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsUpdate_595245(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of labs.
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
  var valid_595247 = path.getOrDefault("resourceGroupName")
  valid_595247 = validateParameter(valid_595247, JString, required = true,
                                 default = nil)
  if valid_595247 != nil:
    section.add "resourceGroupName", valid_595247
  var valid_595248 = path.getOrDefault("name")
  valid_595248 = validateParameter(valid_595248, JString, required = true,
                                 default = nil)
  if valid_595248 != nil:
    section.add "name", valid_595248
  var valid_595249 = path.getOrDefault("subscriptionId")
  valid_595249 = validateParameter(valid_595249, JString, required = true,
                                 default = nil)
  if valid_595249 != nil:
    section.add "subscriptionId", valid_595249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595250 = query.getOrDefault("api-version")
  valid_595250 = validateParameter(valid_595250, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595250 != nil:
    section.add "api-version", valid_595250
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

proc call*(call_595252: Call_LabsUpdate_595244; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of labs.
  ## 
  let valid = call_595252.validator(path, query, header, formData, body)
  let scheme = call_595252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595252.url(scheme.get, call_595252.host, call_595252.base,
                         call_595252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595252, url, valid)

proc call*(call_595253: Call_LabsUpdate_595244; resourceGroupName: string;
          name: string; subscriptionId: string; lab: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## labsUpdate
  ## Modify properties of labs.
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
  var path_595254 = newJObject()
  var query_595255 = newJObject()
  var body_595256 = newJObject()
  add(path_595254, "resourceGroupName", newJString(resourceGroupName))
  add(query_595255, "api-version", newJString(apiVersion))
  add(path_595254, "name", newJString(name))
  add(path_595254, "subscriptionId", newJString(subscriptionId))
  if lab != nil:
    body_595256 = lab
  result = call_595253.call(path_595254, query_595255, nil, nil, body_595256)

var labsUpdate* = Call_LabsUpdate_595244(name: "labsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                      validator: validate_LabsUpdate_595245,
                                      base: "", url: url_LabsUpdate_595246,
                                      schemes: {Scheme.Https})
type
  Call_LabsDelete_595233 = ref object of OpenApiRestCall_593421
proc url_LabsDelete_595235(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsDelete_595234(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_595236 = path.getOrDefault("resourceGroupName")
  valid_595236 = validateParameter(valid_595236, JString, required = true,
                                 default = nil)
  if valid_595236 != nil:
    section.add "resourceGroupName", valid_595236
  var valid_595237 = path.getOrDefault("name")
  valid_595237 = validateParameter(valid_595237, JString, required = true,
                                 default = nil)
  if valid_595237 != nil:
    section.add "name", valid_595237
  var valid_595238 = path.getOrDefault("subscriptionId")
  valid_595238 = validateParameter(valid_595238, JString, required = true,
                                 default = nil)
  if valid_595238 != nil:
    section.add "subscriptionId", valid_595238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595239 = query.getOrDefault("api-version")
  valid_595239 = validateParameter(valid_595239, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595239 != nil:
    section.add "api-version", valid_595239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595240: Call_LabsDelete_595233; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab. This operation can take a while to complete.
  ## 
  let valid = call_595240.validator(path, query, header, formData, body)
  let scheme = call_595240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595240.url(scheme.get, call_595240.host, call_595240.base,
                         call_595240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595240, url, valid)

proc call*(call_595241: Call_LabsDelete_595233; resourceGroupName: string;
          name: string; subscriptionId: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595242 = newJObject()
  var query_595243 = newJObject()
  add(path_595242, "resourceGroupName", newJString(resourceGroupName))
  add(query_595243, "api-version", newJString(apiVersion))
  add(path_595242, "name", newJString(name))
  add(path_595242, "subscriptionId", newJString(subscriptionId))
  result = call_595241.call(path_595242, query_595243, nil, nil, nil)

var labsDelete* = Call_LabsDelete_595233(name: "labsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                      validator: validate_LabsDelete_595234,
                                      base: "", url: url_LabsDelete_595235,
                                      schemes: {Scheme.Https})
type
  Call_LabsClaimAnyVm_595257 = ref object of OpenApiRestCall_593421
proc url_LabsClaimAnyVm_595259(protocol: Scheme; host: string; base: string;
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

proc validate_LabsClaimAnyVm_595258(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595263 = query.getOrDefault("api-version")
  valid_595263 = validateParameter(valid_595263, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595263 != nil:
    section.add "api-version", valid_595263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595264: Call_LabsClaimAnyVm_595257; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claim a random claimable virtual machine in the lab. This operation can take a while to complete.
  ## 
  let valid = call_595264.validator(path, query, header, formData, body)
  let scheme = call_595264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595264.url(scheme.get, call_595264.host, call_595264.base,
                         call_595264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595264, url, valid)

proc call*(call_595265: Call_LabsClaimAnyVm_595257; resourceGroupName: string;
          name: string; subscriptionId: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595266 = newJObject()
  var query_595267 = newJObject()
  add(path_595266, "resourceGroupName", newJString(resourceGroupName))
  add(query_595267, "api-version", newJString(apiVersion))
  add(path_595266, "name", newJString(name))
  add(path_595266, "subscriptionId", newJString(subscriptionId))
  result = call_595265.call(path_595266, query_595267, nil, nil, nil)

var labsClaimAnyVm* = Call_LabsClaimAnyVm_595257(name: "labsClaimAnyVm",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/claimAnyVm",
    validator: validate_LabsClaimAnyVm_595258, base: "", url: url_LabsClaimAnyVm_595259,
    schemes: {Scheme.Https})
type
  Call_LabsCreateEnvironment_595268 = ref object of OpenApiRestCall_593421
proc url_LabsCreateEnvironment_595270(protocol: Scheme; host: string; base: string;
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

proc validate_LabsCreateEnvironment_595269(path: JsonNode; query: JsonNode;
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
  var valid_595271 = path.getOrDefault("resourceGroupName")
  valid_595271 = validateParameter(valid_595271, JString, required = true,
                                 default = nil)
  if valid_595271 != nil:
    section.add "resourceGroupName", valid_595271
  var valid_595272 = path.getOrDefault("name")
  valid_595272 = validateParameter(valid_595272, JString, required = true,
                                 default = nil)
  if valid_595272 != nil:
    section.add "name", valid_595272
  var valid_595273 = path.getOrDefault("subscriptionId")
  valid_595273 = validateParameter(valid_595273, JString, required = true,
                                 default = nil)
  if valid_595273 != nil:
    section.add "subscriptionId", valid_595273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595274 = query.getOrDefault("api-version")
  valid_595274 = validateParameter(valid_595274, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595274 != nil:
    section.add "api-version", valid_595274
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

proc call*(call_595276: Call_LabsCreateEnvironment_595268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create virtual machines in a lab. This operation can take a while to complete.
  ## 
  let valid = call_595276.validator(path, query, header, formData, body)
  let scheme = call_595276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595276.url(scheme.get, call_595276.host, call_595276.base,
                         call_595276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595276, url, valid)

proc call*(call_595277: Call_LabsCreateEnvironment_595268;
          resourceGroupName: string; name: string;
          labVirtualMachineCreationParameter: JsonNode; subscriptionId: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595278 = newJObject()
  var query_595279 = newJObject()
  var body_595280 = newJObject()
  add(path_595278, "resourceGroupName", newJString(resourceGroupName))
  add(query_595279, "api-version", newJString(apiVersion))
  add(path_595278, "name", newJString(name))
  if labVirtualMachineCreationParameter != nil:
    body_595280 = labVirtualMachineCreationParameter
  add(path_595278, "subscriptionId", newJString(subscriptionId))
  result = call_595277.call(path_595278, query_595279, nil, nil, body_595280)

var labsCreateEnvironment* = Call_LabsCreateEnvironment_595268(
    name: "labsCreateEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/createEnvironment",
    validator: validate_LabsCreateEnvironment_595269, base: "",
    url: url_LabsCreateEnvironment_595270, schemes: {Scheme.Https})
type
  Call_LabsExportResourceUsage_595281 = ref object of OpenApiRestCall_593421
proc url_LabsExportResourceUsage_595283(protocol: Scheme; host: string; base: string;
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

proc validate_LabsExportResourceUsage_595282(path: JsonNode; query: JsonNode;
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
  var valid_595284 = path.getOrDefault("resourceGroupName")
  valid_595284 = validateParameter(valid_595284, JString, required = true,
                                 default = nil)
  if valid_595284 != nil:
    section.add "resourceGroupName", valid_595284
  var valid_595285 = path.getOrDefault("name")
  valid_595285 = validateParameter(valid_595285, JString, required = true,
                                 default = nil)
  if valid_595285 != nil:
    section.add "name", valid_595285
  var valid_595286 = path.getOrDefault("subscriptionId")
  valid_595286 = validateParameter(valid_595286, JString, required = true,
                                 default = nil)
  if valid_595286 != nil:
    section.add "subscriptionId", valid_595286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595287 = query.getOrDefault("api-version")
  valid_595287 = validateParameter(valid_595287, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595287 != nil:
    section.add "api-version", valid_595287
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

proc call*(call_595289: Call_LabsExportResourceUsage_595281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the lab resource usage into a storage account This operation can take a while to complete.
  ## 
  let valid = call_595289.validator(path, query, header, formData, body)
  let scheme = call_595289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595289.url(scheme.get, call_595289.host, call_595289.base,
                         call_595289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595289, url, valid)

proc call*(call_595290: Call_LabsExportResourceUsage_595281;
          resourceGroupName: string; name: string; subscriptionId: string;
          exportResourceUsageParameters: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595291 = newJObject()
  var query_595292 = newJObject()
  var body_595293 = newJObject()
  add(path_595291, "resourceGroupName", newJString(resourceGroupName))
  add(query_595292, "api-version", newJString(apiVersion))
  add(path_595291, "name", newJString(name))
  add(path_595291, "subscriptionId", newJString(subscriptionId))
  if exportResourceUsageParameters != nil:
    body_595293 = exportResourceUsageParameters
  result = call_595290.call(path_595291, query_595292, nil, nil, body_595293)

var labsExportResourceUsage* = Call_LabsExportResourceUsage_595281(
    name: "labsExportResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/exportResourceUsage",
    validator: validate_LabsExportResourceUsage_595282, base: "",
    url: url_LabsExportResourceUsage_595283, schemes: {Scheme.Https})
type
  Call_LabsGenerateUploadUri_595294 = ref object of OpenApiRestCall_593421
proc url_LabsGenerateUploadUri_595296(protocol: Scheme; host: string; base: string;
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

proc validate_LabsGenerateUploadUri_595295(path: JsonNode; query: JsonNode;
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
  var valid_595297 = path.getOrDefault("resourceGroupName")
  valid_595297 = validateParameter(valid_595297, JString, required = true,
                                 default = nil)
  if valid_595297 != nil:
    section.add "resourceGroupName", valid_595297
  var valid_595298 = path.getOrDefault("name")
  valid_595298 = validateParameter(valid_595298, JString, required = true,
                                 default = nil)
  if valid_595298 != nil:
    section.add "name", valid_595298
  var valid_595299 = path.getOrDefault("subscriptionId")
  valid_595299 = validateParameter(valid_595299, JString, required = true,
                                 default = nil)
  if valid_595299 != nil:
    section.add "subscriptionId", valid_595299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595300 = query.getOrDefault("api-version")
  valid_595300 = validateParameter(valid_595300, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595300 != nil:
    section.add "api-version", valid_595300
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

proc call*(call_595302: Call_LabsGenerateUploadUri_595294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  let valid = call_595302.validator(path, query, header, formData, body)
  let scheme = call_595302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595302.url(scheme.get, call_595302.host, call_595302.base,
                         call_595302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595302, url, valid)

proc call*(call_595303: Call_LabsGenerateUploadUri_595294;
          resourceGroupName: string; name: string; subscriptionId: string;
          generateUploadUriParameter: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595304 = newJObject()
  var query_595305 = newJObject()
  var body_595306 = newJObject()
  add(path_595304, "resourceGroupName", newJString(resourceGroupName))
  add(query_595305, "api-version", newJString(apiVersion))
  add(path_595304, "name", newJString(name))
  add(path_595304, "subscriptionId", newJString(subscriptionId))
  if generateUploadUriParameter != nil:
    body_595306 = generateUploadUriParameter
  result = call_595303.call(path_595304, query_595305, nil, nil, body_595306)

var labsGenerateUploadUri* = Call_LabsGenerateUploadUri_595294(
    name: "labsGenerateUploadUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/generateUploadUri",
    validator: validate_LabsGenerateUploadUri_595295, base: "",
    url: url_LabsGenerateUploadUri_595296, schemes: {Scheme.Https})
type
  Call_LabsListVhds_595307 = ref object of OpenApiRestCall_593421
proc url_LabsListVhds_595309(protocol: Scheme; host: string; base: string;
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

proc validate_LabsListVhds_595308(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_595310 = path.getOrDefault("resourceGroupName")
  valid_595310 = validateParameter(valid_595310, JString, required = true,
                                 default = nil)
  if valid_595310 != nil:
    section.add "resourceGroupName", valid_595310
  var valid_595311 = path.getOrDefault("name")
  valid_595311 = validateParameter(valid_595311, JString, required = true,
                                 default = nil)
  if valid_595311 != nil:
    section.add "name", valid_595311
  var valid_595312 = path.getOrDefault("subscriptionId")
  valid_595312 = validateParameter(valid_595312, JString, required = true,
                                 default = nil)
  if valid_595312 != nil:
    section.add "subscriptionId", valid_595312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595313 = query.getOrDefault("api-version")
  valid_595313 = validateParameter(valid_595313, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595313 != nil:
    section.add "api-version", valid_595313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595314: Call_LabsListVhds_595307; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disk images available for custom image creation.
  ## 
  let valid = call_595314.validator(path, query, header, formData, body)
  let scheme = call_595314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595314.url(scheme.get, call_595314.host, call_595314.base,
                         call_595314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595314, url, valid)

proc call*(call_595315: Call_LabsListVhds_595307; resourceGroupName: string;
          name: string; subscriptionId: string; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595316 = newJObject()
  var query_595317 = newJObject()
  add(path_595316, "resourceGroupName", newJString(resourceGroupName))
  add(query_595317, "api-version", newJString(apiVersion))
  add(path_595316, "name", newJString(name))
  add(path_595316, "subscriptionId", newJString(subscriptionId))
  result = call_595315.call(path_595316, query_595317, nil, nil, nil)

var labsListVhds* = Call_LabsListVhds_595307(name: "labsListVhds",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/listVhds",
    validator: validate_LabsListVhds_595308, base: "", url: url_LabsListVhds_595309,
    schemes: {Scheme.Https})
type
  Call_GlobalSchedulesListByResourceGroup_595318 = ref object of OpenApiRestCall_593421
proc url_GlobalSchedulesListByResourceGroup_595320(protocol: Scheme; host: string;
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

proc validate_GlobalSchedulesListByResourceGroup_595319(path: JsonNode;
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
  var valid_595321 = path.getOrDefault("resourceGroupName")
  valid_595321 = validateParameter(valid_595321, JString, required = true,
                                 default = nil)
  if valid_595321 != nil:
    section.add "resourceGroupName", valid_595321
  var valid_595322 = path.getOrDefault("subscriptionId")
  valid_595322 = validateParameter(valid_595322, JString, required = true,
                                 default = nil)
  if valid_595322 != nil:
    section.add "subscriptionId", valid_595322
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_595323 = query.getOrDefault("$orderby")
  valid_595323 = validateParameter(valid_595323, JString, required = false,
                                 default = nil)
  if valid_595323 != nil:
    section.add "$orderby", valid_595323
  var valid_595324 = query.getOrDefault("$expand")
  valid_595324 = validateParameter(valid_595324, JString, required = false,
                                 default = nil)
  if valid_595324 != nil:
    section.add "$expand", valid_595324
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595325 = query.getOrDefault("api-version")
  valid_595325 = validateParameter(valid_595325, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595325 != nil:
    section.add "api-version", valid_595325
  var valid_595326 = query.getOrDefault("$top")
  valid_595326 = validateParameter(valid_595326, JInt, required = false, default = nil)
  if valid_595326 != nil:
    section.add "$top", valid_595326
  var valid_595327 = query.getOrDefault("$filter")
  valid_595327 = validateParameter(valid_595327, JString, required = false,
                                 default = nil)
  if valid_595327 != nil:
    section.add "$filter", valid_595327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595328: Call_GlobalSchedulesListByResourceGroup_595318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List schedules in a resource group.
  ## 
  let valid = call_595328.validator(path, query, header, formData, body)
  let scheme = call_595328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595328.url(scheme.get, call_595328.host, call_595328.base,
                         call_595328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595328, url, valid)

proc call*(call_595329: Call_GlobalSchedulesListByResourceGroup_595318;
          resourceGroupName: string; subscriptionId: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## globalSchedulesListByResourceGroup
  ## List schedules in a resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_595330 = newJObject()
  var query_595331 = newJObject()
  add(query_595331, "$orderby", newJString(Orderby))
  add(path_595330, "resourceGroupName", newJString(resourceGroupName))
  add(query_595331, "$expand", newJString(Expand))
  add(query_595331, "api-version", newJString(apiVersion))
  add(path_595330, "subscriptionId", newJString(subscriptionId))
  add(query_595331, "$top", newJInt(Top))
  add(query_595331, "$filter", newJString(Filter))
  result = call_595329.call(path_595330, query_595331, nil, nil, nil)

var globalSchedulesListByResourceGroup* = Call_GlobalSchedulesListByResourceGroup_595318(
    name: "globalSchedulesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules",
    validator: validate_GlobalSchedulesListByResourceGroup_595319, base: "",
    url: url_GlobalSchedulesListByResourceGroup_595320, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesCreateOrUpdate_595344 = ref object of OpenApiRestCall_593421
proc url_GlobalSchedulesCreateOrUpdate_595346(protocol: Scheme; host: string;
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

proc validate_GlobalSchedulesCreateOrUpdate_595345(path: JsonNode; query: JsonNode;
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
  var valid_595347 = path.getOrDefault("resourceGroupName")
  valid_595347 = validateParameter(valid_595347, JString, required = true,
                                 default = nil)
  if valid_595347 != nil:
    section.add "resourceGroupName", valid_595347
  var valid_595348 = path.getOrDefault("name")
  valid_595348 = validateParameter(valid_595348, JString, required = true,
                                 default = nil)
  if valid_595348 != nil:
    section.add "name", valid_595348
  var valid_595349 = path.getOrDefault("subscriptionId")
  valid_595349 = validateParameter(valid_595349, JString, required = true,
                                 default = nil)
  if valid_595349 != nil:
    section.add "subscriptionId", valid_595349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595350 = query.getOrDefault("api-version")
  valid_595350 = validateParameter(valid_595350, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595350 != nil:
    section.add "api-version", valid_595350
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

proc call*(call_595352: Call_GlobalSchedulesCreateOrUpdate_595344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_595352.validator(path, query, header, formData, body)
  let scheme = call_595352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595352.url(scheme.get, call_595352.host, call_595352.base,
                         call_595352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595352, url, valid)

proc call*(call_595353: Call_GlobalSchedulesCreateOrUpdate_595344;
          resourceGroupName: string; name: string; subscriptionId: string;
          schedule: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595354 = newJObject()
  var query_595355 = newJObject()
  var body_595356 = newJObject()
  add(path_595354, "resourceGroupName", newJString(resourceGroupName))
  add(query_595355, "api-version", newJString(apiVersion))
  add(path_595354, "name", newJString(name))
  add(path_595354, "subscriptionId", newJString(subscriptionId))
  if schedule != nil:
    body_595356 = schedule
  result = call_595353.call(path_595354, query_595355, nil, nil, body_595356)

var globalSchedulesCreateOrUpdate* = Call_GlobalSchedulesCreateOrUpdate_595344(
    name: "globalSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesCreateOrUpdate_595345, base: "",
    url: url_GlobalSchedulesCreateOrUpdate_595346, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesGet_595332 = ref object of OpenApiRestCall_593421
proc url_GlobalSchedulesGet_595334(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesGet_595333(path: JsonNode; query: JsonNode;
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
  var valid_595335 = path.getOrDefault("resourceGroupName")
  valid_595335 = validateParameter(valid_595335, JString, required = true,
                                 default = nil)
  if valid_595335 != nil:
    section.add "resourceGroupName", valid_595335
  var valid_595336 = path.getOrDefault("name")
  valid_595336 = validateParameter(valid_595336, JString, required = true,
                                 default = nil)
  if valid_595336 != nil:
    section.add "name", valid_595336
  var valid_595337 = path.getOrDefault("subscriptionId")
  valid_595337 = validateParameter(valid_595337, JString, required = true,
                                 default = nil)
  if valid_595337 != nil:
    section.add "subscriptionId", valid_595337
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_595338 = query.getOrDefault("$expand")
  valid_595338 = validateParameter(valid_595338, JString, required = false,
                                 default = nil)
  if valid_595338 != nil:
    section.add "$expand", valid_595338
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595339 = query.getOrDefault("api-version")
  valid_595339 = validateParameter(valid_595339, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595339 != nil:
    section.add "api-version", valid_595339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595340: Call_GlobalSchedulesGet_595332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_595340.validator(path, query, header, formData, body)
  let scheme = call_595340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595340.url(scheme.get, call_595340.host, call_595340.base,
                         call_595340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595340, url, valid)

proc call*(call_595341: Call_GlobalSchedulesGet_595332; resourceGroupName: string;
          name: string; subscriptionId: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595342 = newJObject()
  var query_595343 = newJObject()
  add(path_595342, "resourceGroupName", newJString(resourceGroupName))
  add(query_595343, "$expand", newJString(Expand))
  add(path_595342, "name", newJString(name))
  add(query_595343, "api-version", newJString(apiVersion))
  add(path_595342, "subscriptionId", newJString(subscriptionId))
  result = call_595341.call(path_595342, query_595343, nil, nil, nil)

var globalSchedulesGet* = Call_GlobalSchedulesGet_595332(
    name: "globalSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesGet_595333, base: "",
    url: url_GlobalSchedulesGet_595334, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesUpdate_595368 = ref object of OpenApiRestCall_593421
proc url_GlobalSchedulesUpdate_595370(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesUpdate_595369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of schedules.
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
  var valid_595371 = path.getOrDefault("resourceGroupName")
  valid_595371 = validateParameter(valid_595371, JString, required = true,
                                 default = nil)
  if valid_595371 != nil:
    section.add "resourceGroupName", valid_595371
  var valid_595372 = path.getOrDefault("name")
  valid_595372 = validateParameter(valid_595372, JString, required = true,
                                 default = nil)
  if valid_595372 != nil:
    section.add "name", valid_595372
  var valid_595373 = path.getOrDefault("subscriptionId")
  valid_595373 = validateParameter(valid_595373, JString, required = true,
                                 default = nil)
  if valid_595373 != nil:
    section.add "subscriptionId", valid_595373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595374 = query.getOrDefault("api-version")
  valid_595374 = validateParameter(valid_595374, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595374 != nil:
    section.add "api-version", valid_595374
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

proc call*(call_595376: Call_GlobalSchedulesUpdate_595368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of schedules.
  ## 
  let valid = call_595376.validator(path, query, header, formData, body)
  let scheme = call_595376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595376.url(scheme.get, call_595376.host, call_595376.base,
                         call_595376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595376, url, valid)

proc call*(call_595377: Call_GlobalSchedulesUpdate_595368;
          resourceGroupName: string; name: string; subscriptionId: string;
          schedule: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## globalSchedulesUpdate
  ## Modify properties of schedules.
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
  var path_595378 = newJObject()
  var query_595379 = newJObject()
  var body_595380 = newJObject()
  add(path_595378, "resourceGroupName", newJString(resourceGroupName))
  add(query_595379, "api-version", newJString(apiVersion))
  add(path_595378, "name", newJString(name))
  add(path_595378, "subscriptionId", newJString(subscriptionId))
  if schedule != nil:
    body_595380 = schedule
  result = call_595377.call(path_595378, query_595379, nil, nil, body_595380)

var globalSchedulesUpdate* = Call_GlobalSchedulesUpdate_595368(
    name: "globalSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesUpdate_595369, base: "",
    url: url_GlobalSchedulesUpdate_595370, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesDelete_595357 = ref object of OpenApiRestCall_593421
proc url_GlobalSchedulesDelete_595359(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesDelete_595358(path: JsonNode; query: JsonNode;
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
  var valid_595360 = path.getOrDefault("resourceGroupName")
  valid_595360 = validateParameter(valid_595360, JString, required = true,
                                 default = nil)
  if valid_595360 != nil:
    section.add "resourceGroupName", valid_595360
  var valid_595361 = path.getOrDefault("name")
  valid_595361 = validateParameter(valid_595361, JString, required = true,
                                 default = nil)
  if valid_595361 != nil:
    section.add "name", valid_595361
  var valid_595362 = path.getOrDefault("subscriptionId")
  valid_595362 = validateParameter(valid_595362, JString, required = true,
                                 default = nil)
  if valid_595362 != nil:
    section.add "subscriptionId", valid_595362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595363 = query.getOrDefault("api-version")
  valid_595363 = validateParameter(valid_595363, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595363 != nil:
    section.add "api-version", valid_595363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595364: Call_GlobalSchedulesDelete_595357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_595364.validator(path, query, header, formData, body)
  let scheme = call_595364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595364.url(scheme.get, call_595364.host, call_595364.base,
                         call_595364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595364, url, valid)

proc call*(call_595365: Call_GlobalSchedulesDelete_595357;
          resourceGroupName: string; name: string; subscriptionId: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595366 = newJObject()
  var query_595367 = newJObject()
  add(path_595366, "resourceGroupName", newJString(resourceGroupName))
  add(query_595367, "api-version", newJString(apiVersion))
  add(path_595366, "name", newJString(name))
  add(path_595366, "subscriptionId", newJString(subscriptionId))
  result = call_595365.call(path_595366, query_595367, nil, nil, nil)

var globalSchedulesDelete* = Call_GlobalSchedulesDelete_595357(
    name: "globalSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesDelete_595358, base: "",
    url: url_GlobalSchedulesDelete_595359, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesExecute_595381 = ref object of OpenApiRestCall_593421
proc url_GlobalSchedulesExecute_595383(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesExecute_595382(path: JsonNode; query: JsonNode;
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
  var valid_595384 = path.getOrDefault("resourceGroupName")
  valid_595384 = validateParameter(valid_595384, JString, required = true,
                                 default = nil)
  if valid_595384 != nil:
    section.add "resourceGroupName", valid_595384
  var valid_595385 = path.getOrDefault("name")
  valid_595385 = validateParameter(valid_595385, JString, required = true,
                                 default = nil)
  if valid_595385 != nil:
    section.add "name", valid_595385
  var valid_595386 = path.getOrDefault("subscriptionId")
  valid_595386 = validateParameter(valid_595386, JString, required = true,
                                 default = nil)
  if valid_595386 != nil:
    section.add "subscriptionId", valid_595386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595387 = query.getOrDefault("api-version")
  valid_595387 = validateParameter(valid_595387, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595387 != nil:
    section.add "api-version", valid_595387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595388: Call_GlobalSchedulesExecute_595381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_595388.validator(path, query, header, formData, body)
  let scheme = call_595388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595388.url(scheme.get, call_595388.host, call_595388.base,
                         call_595388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595388, url, valid)

proc call*(call_595389: Call_GlobalSchedulesExecute_595381;
          resourceGroupName: string; name: string; subscriptionId: string;
          apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595390 = newJObject()
  var query_595391 = newJObject()
  add(path_595390, "resourceGroupName", newJString(resourceGroupName))
  add(query_595391, "api-version", newJString(apiVersion))
  add(path_595390, "name", newJString(name))
  add(path_595390, "subscriptionId", newJString(subscriptionId))
  result = call_595389.call(path_595390, query_595391, nil, nil, nil)

var globalSchedulesExecute* = Call_GlobalSchedulesExecute_595381(
    name: "globalSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}/execute",
    validator: validate_GlobalSchedulesExecute_595382, base: "",
    url: url_GlobalSchedulesExecute_595383, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesRetarget_595392 = ref object of OpenApiRestCall_593421
proc url_GlobalSchedulesRetarget_595394(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesRetarget_595393(path: JsonNode; query: JsonNode;
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
  var valid_595395 = path.getOrDefault("resourceGroupName")
  valid_595395 = validateParameter(valid_595395, JString, required = true,
                                 default = nil)
  if valid_595395 != nil:
    section.add "resourceGroupName", valid_595395
  var valid_595396 = path.getOrDefault("name")
  valid_595396 = validateParameter(valid_595396, JString, required = true,
                                 default = nil)
  if valid_595396 != nil:
    section.add "name", valid_595396
  var valid_595397 = path.getOrDefault("subscriptionId")
  valid_595397 = validateParameter(valid_595397, JString, required = true,
                                 default = nil)
  if valid_595397 != nil:
    section.add "subscriptionId", valid_595397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595398 = query.getOrDefault("api-version")
  valid_595398 = validateParameter(valid_595398, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_595398 != nil:
    section.add "api-version", valid_595398
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

proc call*(call_595400: Call_GlobalSchedulesRetarget_595392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a schedule's target resource Id. This operation can take a while to complete.
  ## 
  let valid = call_595400.validator(path, query, header, formData, body)
  let scheme = call_595400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595400.url(scheme.get, call_595400.host, call_595400.base,
                         call_595400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595400, url, valid)

proc call*(call_595401: Call_GlobalSchedulesRetarget_595392;
          resourceGroupName: string; name: string; subscriptionId: string;
          retargetScheduleProperties: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
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
  var path_595402 = newJObject()
  var query_595403 = newJObject()
  var body_595404 = newJObject()
  add(path_595402, "resourceGroupName", newJString(resourceGroupName))
  add(query_595403, "api-version", newJString(apiVersion))
  add(path_595402, "name", newJString(name))
  add(path_595402, "subscriptionId", newJString(subscriptionId))
  if retargetScheduleProperties != nil:
    body_595404 = retargetScheduleProperties
  result = call_595401.call(path_595402, query_595403, nil, nil, body_595404)

var globalSchedulesRetarget* = Call_GlobalSchedulesRetarget_595392(
    name: "globalSchedulesRetarget", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}/retarget",
    validator: validate_GlobalSchedulesRetarget_595393, base: "",
    url: url_GlobalSchedulesRetarget_595394, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
