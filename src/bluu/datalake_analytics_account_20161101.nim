
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DataLakeAnalyticsAccountManagementClient
## version: 2016-11-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Creates an Azure Data Lake Analytics account management client.
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
  macServiceName = "datalake-analytics-account"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593659 = ref object of OpenApiRestCall_593437
proc url_OperationsList_593661(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593660(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Data Lake Analytics REST API operations.
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
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593843: Call_OperationsList_593659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Data Lake Analytics REST API operations.
  ## 
  let valid = call_593843.validator(path, query, header, formData, body)
  let scheme = call_593843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593843.url(scheme.get, call_593843.host, call_593843.base,
                         call_593843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593843, url, valid)

proc call*(call_593914: Call_OperationsList_593659; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Data Lake Analytics REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593915 = newJObject()
  add(query_593915, "api-version", newJString(apiVersion))
  result = call_593914.call(nil, query_593915, nil, nil, nil)

var operationsList* = Call_OperationsList_593659(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataLakeAnalytics/operations",
    validator: validate_OperationsList_593660, base: "", url: url_OperationsList_593661,
    schemes: {Scheme.Https})
type
  Call_AccountsList_593955 = ref object of OpenApiRestCall_593437
proc url_AccountsList_593957(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsList_593956(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_593974 = query.getOrDefault("$orderby")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "$orderby", valid_593974
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  var valid_593976 = query.getOrDefault("$top")
  valid_593976 = validateParameter(valid_593976, JInt, required = false, default = nil)
  if valid_593976 != nil:
    section.add "$top", valid_593976
  var valid_593977 = query.getOrDefault("$select")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "$select", valid_593977
  var valid_593978 = query.getOrDefault("$skip")
  valid_593978 = validateParameter(valid_593978, JInt, required = false, default = nil)
  if valid_593978 != nil:
    section.add "$skip", valid_593978
  var valid_593979 = query.getOrDefault("$count")
  valid_593979 = validateParameter(valid_593979, JBool, required = false, default = nil)
  if valid_593979 != nil:
    section.add "$count", valid_593979
  var valid_593980 = query.getOrDefault("$filter")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "$filter", valid_593980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_AccountsList_593955; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_AccountsList_593955; apiVersion: string;
          subscriptionId: string; Orderby: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## accountsList
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  add(query_593984, "$orderby", newJString(Orderby))
  add(query_593984, "api-version", newJString(apiVersion))
  add(path_593983, "subscriptionId", newJString(subscriptionId))
  add(query_593984, "$top", newJInt(Top))
  add(query_593984, "$select", newJString(Select))
  add(query_593984, "$skip", newJInt(Skip))
  add(query_593984, "$count", newJBool(Count))
  add(query_593984, "$filter", newJString(Filter))
  result = call_593982.call(path_593983, query_593984, nil, nil, nil)

var accountsList* = Call_AccountsList_593955(name: "accountsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeAnalytics/accounts",
    validator: validate_AccountsList_593956, base: "", url: url_AccountsList_593957,
    schemes: {Scheme.Https})
type
  Call_LocationsGetCapability_593985 = ref object of OpenApiRestCall_593437
proc url_LocationsGetCapability_593987(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.DataLakeAnalytics/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/capability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsGetCapability_593986(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets subscription-level properties and limits for Data Lake Analytics specified by resource location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The resource location without whitespace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593988 = path.getOrDefault("subscriptionId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "subscriptionId", valid_593988
  var valid_593989 = path.getOrDefault("location")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "location", valid_593989
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

proc call*(call_593991: Call_LocationsGetCapability_593985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets subscription-level properties and limits for Data Lake Analytics specified by resource location.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_LocationsGetCapability_593985; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## locationsGetCapability
  ## Gets subscription-level properties and limits for Data Lake Analytics specified by resource location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The resource location without whitespace.
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  add(query_593994, "api-version", newJString(apiVersion))
  add(path_593993, "subscriptionId", newJString(subscriptionId))
  add(path_593993, "location", newJString(location))
  result = call_593992.call(path_593993, query_593994, nil, nil, nil)

var locationsGetCapability* = Call_LocationsGetCapability_593985(
    name: "locationsGetCapability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeAnalytics/locations/{location}/capability",
    validator: validate_LocationsGetCapability_593986, base: "",
    url: url_LocationsGetCapability_593987, schemes: {Scheme.Https})
type
  Call_AccountsCheckNameAvailability_593995 = ref object of OpenApiRestCall_593437
proc url_AccountsCheckNameAvailability_593997(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.DataLakeAnalytics/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCheckNameAvailability_593996(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the specified account name is available or taken.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The resource location without whitespace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594015 = path.getOrDefault("subscriptionId")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "subscriptionId", valid_594015
  var valid_594016 = path.getOrDefault("location")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "location", valid_594016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594017 = query.getOrDefault("api-version")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "api-version", valid_594017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to check the Data Lake Analytics account name availability.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594019: Call_AccountsCheckNameAvailability_593995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the specified account name is available or taken.
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_AccountsCheckNameAvailability_593995;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          location: string): Recallable =
  ## accountsCheckNameAvailability
  ## Checks whether the specified account name is available or taken.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to check the Data Lake Analytics account name availability.
  ##   location: string (required)
  ##           : The resource location without whitespace.
  var path_594021 = newJObject()
  var query_594022 = newJObject()
  var body_594023 = newJObject()
  add(query_594022, "api-version", newJString(apiVersion))
  add(path_594021, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594023 = parameters
  add(path_594021, "location", newJString(location))
  result = call_594020.call(path_594021, query_594022, nil, nil, body_594023)

var accountsCheckNameAvailability* = Call_AccountsCheckNameAvailability_593995(
    name: "accountsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeAnalytics/locations/{location}/checkNameAvailability",
    validator: validate_AccountsCheckNameAvailability_593996, base: "",
    url: url_AccountsCheckNameAvailability_593997, schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_594024 = ref object of OpenApiRestCall_593437
proc url_AccountsListByResourceGroup_594026(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.DataLakeAnalytics/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListByResourceGroup_594025(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594027 = path.getOrDefault("resourceGroupName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "resourceGroupName", valid_594027
  var valid_594028 = path.getOrDefault("subscriptionId")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "subscriptionId", valid_594028
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_594029 = query.getOrDefault("$orderby")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "$orderby", valid_594029
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594030 = query.getOrDefault("api-version")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "api-version", valid_594030
  var valid_594031 = query.getOrDefault("$top")
  valid_594031 = validateParameter(valid_594031, JInt, required = false, default = nil)
  if valid_594031 != nil:
    section.add "$top", valid_594031
  var valid_594032 = query.getOrDefault("$select")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "$select", valid_594032
  var valid_594033 = query.getOrDefault("$skip")
  valid_594033 = validateParameter(valid_594033, JInt, required = false, default = nil)
  if valid_594033 != nil:
    section.add "$skip", valid_594033
  var valid_594034 = query.getOrDefault("$count")
  valid_594034 = validateParameter(valid_594034, JBool, required = false, default = nil)
  if valid_594034 != nil:
    section.add "$count", valid_594034
  var valid_594035 = query.getOrDefault("$filter")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "$filter", valid_594035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594036: Call_AccountsListByResourceGroup_594024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ## 
  let valid = call_594036.validator(path, query, header, formData, body)
  let scheme = call_594036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594036.url(scheme.get, call_594036.host, call_594036.base,
                         call_594036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594036, url, valid)

proc call*(call_594037: Call_AccountsListByResourceGroup_594024;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Orderby: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## accountsListByResourceGroup
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_594038 = newJObject()
  var query_594039 = newJObject()
  add(query_594039, "$orderby", newJString(Orderby))
  add(path_594038, "resourceGroupName", newJString(resourceGroupName))
  add(query_594039, "api-version", newJString(apiVersion))
  add(path_594038, "subscriptionId", newJString(subscriptionId))
  add(query_594039, "$top", newJInt(Top))
  add(query_594039, "$select", newJString(Select))
  add(query_594039, "$skip", newJInt(Skip))
  add(query_594039, "$count", newJBool(Count))
  add(query_594039, "$filter", newJString(Filter))
  result = call_594037.call(path_594038, query_594039, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_594024(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts",
    validator: validate_AccountsListByResourceGroup_594025, base: "",
    url: url_AccountsListByResourceGroup_594026, schemes: {Scheme.Https})
type
  Call_AccountsCreate_594051 = ref object of OpenApiRestCall_593437
proc url_AccountsCreate_594053(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCreate_594052(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594054 = path.getOrDefault("resourceGroupName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "resourceGroupName", valid_594054
  var valid_594055 = path.getOrDefault("subscriptionId")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "subscriptionId", valid_594055
  var valid_594056 = path.getOrDefault("accountName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "accountName", valid_594056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594057 = query.getOrDefault("api-version")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "api-version", valid_594057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a new Data Lake Analytics account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_AccountsCreate_594051; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_AccountsCreate_594051; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## accountsCreate
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a new Data Lake Analytics account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  var body_594063 = newJObject()
  add(path_594061, "resourceGroupName", newJString(resourceGroupName))
  add(query_594062, "api-version", newJString(apiVersion))
  add(path_594061, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594063 = parameters
  add(path_594061, "accountName", newJString(accountName))
  result = call_594060.call(path_594061, query_594062, nil, nil, body_594063)

var accountsCreate* = Call_AccountsCreate_594051(name: "accountsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
    validator: validate_AccountsCreate_594052, base: "", url: url_AccountsCreate_594053,
    schemes: {Scheme.Https})
type
  Call_AccountsGet_594040 = ref object of OpenApiRestCall_593437
proc url_AccountsGet_594042(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsGet_594041(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details of the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594043 = path.getOrDefault("resourceGroupName")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "resourceGroupName", valid_594043
  var valid_594044 = path.getOrDefault("subscriptionId")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "subscriptionId", valid_594044
  var valid_594045 = path.getOrDefault("accountName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "accountName", valid_594045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594046 = query.getOrDefault("api-version")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "api-version", valid_594046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_AccountsGet_594040; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details of the specified Data Lake Analytics account.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_AccountsGet_594040; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsGet
  ## Gets details of the specified Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  add(path_594049, "resourceGroupName", newJString(resourceGroupName))
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "subscriptionId", newJString(subscriptionId))
  add(path_594049, "accountName", newJString(accountName))
  result = call_594048.call(path_594049, query_594050, nil, nil, nil)

var accountsGet* = Call_AccountsGet_594040(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
                                        validator: validate_AccountsGet_594041,
                                        base: "", url: url_AccountsGet_594042,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_594075 = ref object of OpenApiRestCall_593437
proc url_AccountsUpdate_594077(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsUpdate_594076(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594078 = path.getOrDefault("resourceGroupName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "resourceGroupName", valid_594078
  var valid_594079 = path.getOrDefault("subscriptionId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "subscriptionId", valid_594079
  var valid_594080 = path.getOrDefault("accountName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "accountName", valid_594080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594081 = query.getOrDefault("api-version")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "api-version", valid_594081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to the update Data Lake Analytics account operation.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594083: Call_AccountsUpdate_594075; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ## 
  let valid = call_594083.validator(path, query, header, formData, body)
  let scheme = call_594083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594083.url(scheme.get, call_594083.host, call_594083.base,
                         call_594083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594083, url, valid)

proc call*(call_594084: Call_AccountsUpdate_594075; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string;
          parameters: JsonNode = nil): Recallable =
  ## accountsUpdate
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : Parameters supplied to the update Data Lake Analytics account operation.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594085 = newJObject()
  var query_594086 = newJObject()
  var body_594087 = newJObject()
  add(path_594085, "resourceGroupName", newJString(resourceGroupName))
  add(query_594086, "api-version", newJString(apiVersion))
  add(path_594085, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594087 = parameters
  add(path_594085, "accountName", newJString(accountName))
  result = call_594084.call(path_594085, query_594086, nil, nil, body_594087)

var accountsUpdate* = Call_AccountsUpdate_594075(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
    validator: validate_AccountsUpdate_594076, base: "", url: url_AccountsUpdate_594077,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_594064 = ref object of OpenApiRestCall_593437
proc url_AccountsDelete_594066(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsDelete_594065(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594067 = path.getOrDefault("resourceGroupName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "resourceGroupName", valid_594067
  var valid_594068 = path.getOrDefault("subscriptionId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "subscriptionId", valid_594068
  var valid_594069 = path.getOrDefault("accountName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "accountName", valid_594069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594070 = query.getOrDefault("api-version")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "api-version", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_AccountsDelete_594064; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_AccountsDelete_594064; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsDelete
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  add(path_594073, "resourceGroupName", newJString(resourceGroupName))
  add(query_594074, "api-version", newJString(apiVersion))
  add(path_594073, "subscriptionId", newJString(subscriptionId))
  add(path_594073, "accountName", newJString(accountName))
  result = call_594072.call(path_594073, query_594074, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_594064(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
    validator: validate_AccountsDelete_594065, base: "", url: url_AccountsDelete_594066,
    schemes: {Scheme.Https})
type
  Call_ComputePoliciesListByAccount_594088 = ref object of OpenApiRestCall_593437
proc url_ComputePoliciesListByAccount_594090(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/computePolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputePoliciesListByAccount_594089(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Analytics compute policies within the specified Data Lake Analytics account. An account supports, at most, 50 policies
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594091 = path.getOrDefault("resourceGroupName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "resourceGroupName", valid_594091
  var valid_594092 = path.getOrDefault("subscriptionId")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "subscriptionId", valid_594092
  var valid_594093 = path.getOrDefault("accountName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "accountName", valid_594093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594094 = query.getOrDefault("api-version")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "api-version", valid_594094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594095: Call_ComputePoliciesListByAccount_594088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Data Lake Analytics compute policies within the specified Data Lake Analytics account. An account supports, at most, 50 policies
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_ComputePoliciesListByAccount_594088;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## computePoliciesListByAccount
  ## Lists the Data Lake Analytics compute policies within the specified Data Lake Analytics account. An account supports, at most, 50 policies
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594097 = newJObject()
  var query_594098 = newJObject()
  add(path_594097, "resourceGroupName", newJString(resourceGroupName))
  add(query_594098, "api-version", newJString(apiVersion))
  add(path_594097, "subscriptionId", newJString(subscriptionId))
  add(path_594097, "accountName", newJString(accountName))
  result = call_594096.call(path_594097, query_594098, nil, nil, nil)

var computePoliciesListByAccount* = Call_ComputePoliciesListByAccount_594088(
    name: "computePoliciesListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies",
    validator: validate_ComputePoliciesListByAccount_594089, base: "",
    url: url_ComputePoliciesListByAccount_594090, schemes: {Scheme.Https})
type
  Call_ComputePoliciesCreateOrUpdate_594111 = ref object of OpenApiRestCall_593437
proc url_ComputePoliciesCreateOrUpdate_594113(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "computePolicyName" in path,
        "`computePolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/computePolicies/"),
               (kind: VariableSegment, value: "computePolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputePoliciesCreateOrUpdate_594112(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified compute policy. During update, the compute policy with the specified name will be replaced with this new compute policy. An account supports, at most, 50 policies
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: JString (required)
  ##                    : The name of the compute policy to create or update.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594114 = path.getOrDefault("resourceGroupName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "resourceGroupName", valid_594114
  var valid_594115 = path.getOrDefault("subscriptionId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "subscriptionId", valid_594115
  var valid_594116 = path.getOrDefault("computePolicyName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "computePolicyName", valid_594116
  var valid_594117 = path.getOrDefault("accountName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "accountName", valid_594117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594118 = query.getOrDefault("api-version")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "api-version", valid_594118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the compute policy. The max degree of parallelism per job property, min priority per job property, or both must be present.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594120: Call_ComputePoliciesCreateOrUpdate_594111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the specified compute policy. During update, the compute policy with the specified name will be replaced with this new compute policy. An account supports, at most, 50 policies
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_ComputePoliciesCreateOrUpdate_594111;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computePolicyName: string; parameters: JsonNode; accountName: string): Recallable =
  ## computePoliciesCreateOrUpdate
  ## Creates or updates the specified compute policy. During update, the compute policy with the specified name will be replaced with this new compute policy. An account supports, at most, 50 policies
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: string (required)
  ##                    : The name of the compute policy to create or update.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the compute policy. The max degree of parallelism per job property, min priority per job property, or both must be present.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  var body_594124 = newJObject()
  add(path_594122, "resourceGroupName", newJString(resourceGroupName))
  add(query_594123, "api-version", newJString(apiVersion))
  add(path_594122, "subscriptionId", newJString(subscriptionId))
  add(path_594122, "computePolicyName", newJString(computePolicyName))
  if parameters != nil:
    body_594124 = parameters
  add(path_594122, "accountName", newJString(accountName))
  result = call_594121.call(path_594122, query_594123, nil, nil, body_594124)

var computePoliciesCreateOrUpdate* = Call_ComputePoliciesCreateOrUpdate_594111(
    name: "computePoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies/{computePolicyName}",
    validator: validate_ComputePoliciesCreateOrUpdate_594112, base: "",
    url: url_ComputePoliciesCreateOrUpdate_594113, schemes: {Scheme.Https})
type
  Call_ComputePoliciesGet_594099 = ref object of OpenApiRestCall_593437
proc url_ComputePoliciesGet_594101(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "computePolicyName" in path,
        "`computePolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/computePolicies/"),
               (kind: VariableSegment, value: "computePolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputePoliciesGet_594100(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Analytics compute policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: JString (required)
  ##                    : The name of the compute policy to retrieve.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594102 = path.getOrDefault("resourceGroupName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "resourceGroupName", valid_594102
  var valid_594103 = path.getOrDefault("subscriptionId")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "subscriptionId", valid_594103
  var valid_594104 = path.getOrDefault("computePolicyName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "computePolicyName", valid_594104
  var valid_594105 = path.getOrDefault("accountName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "accountName", valid_594105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594106 = query.getOrDefault("api-version")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "api-version", valid_594106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_ComputePoliciesGet_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Analytics compute policy.
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_ComputePoliciesGet_594099; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; computePolicyName: string;
          accountName: string): Recallable =
  ## computePoliciesGet
  ## Gets the specified Data Lake Analytics compute policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: string (required)
  ##                    : The name of the compute policy to retrieve.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(path_594109, "resourceGroupName", newJString(resourceGroupName))
  add(query_594110, "api-version", newJString(apiVersion))
  add(path_594109, "subscriptionId", newJString(subscriptionId))
  add(path_594109, "computePolicyName", newJString(computePolicyName))
  add(path_594109, "accountName", newJString(accountName))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var computePoliciesGet* = Call_ComputePoliciesGet_594099(
    name: "computePoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies/{computePolicyName}",
    validator: validate_ComputePoliciesGet_594100, base: "",
    url: url_ComputePoliciesGet_594101, schemes: {Scheme.Https})
type
  Call_ComputePoliciesUpdate_594137 = ref object of OpenApiRestCall_593437
proc url_ComputePoliciesUpdate_594139(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "computePolicyName" in path,
        "`computePolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/computePolicies/"),
               (kind: VariableSegment, value: "computePolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputePoliciesUpdate_594138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified compute policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: JString (required)
  ##                    : The name of the compute policy to update.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594140 = path.getOrDefault("resourceGroupName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "resourceGroupName", valid_594140
  var valid_594141 = path.getOrDefault("subscriptionId")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "subscriptionId", valid_594141
  var valid_594142 = path.getOrDefault("computePolicyName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "computePolicyName", valid_594142
  var valid_594143 = path.getOrDefault("accountName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "accountName", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594144 = query.getOrDefault("api-version")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "api-version", valid_594144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to update the compute policy.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594146: Call_ComputePoliciesUpdate_594137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified compute policy.
  ## 
  let valid = call_594146.validator(path, query, header, formData, body)
  let scheme = call_594146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594146.url(scheme.get, call_594146.host, call_594146.base,
                         call_594146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594146, url, valid)

proc call*(call_594147: Call_ComputePoliciesUpdate_594137;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computePolicyName: string; accountName: string; parameters: JsonNode = nil): Recallable =
  ## computePoliciesUpdate
  ## Updates the specified compute policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: string (required)
  ##                    : The name of the compute policy to update.
  ##   parameters: JObject
  ##             : Parameters supplied to update the compute policy.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594148 = newJObject()
  var query_594149 = newJObject()
  var body_594150 = newJObject()
  add(path_594148, "resourceGroupName", newJString(resourceGroupName))
  add(query_594149, "api-version", newJString(apiVersion))
  add(path_594148, "subscriptionId", newJString(subscriptionId))
  add(path_594148, "computePolicyName", newJString(computePolicyName))
  if parameters != nil:
    body_594150 = parameters
  add(path_594148, "accountName", newJString(accountName))
  result = call_594147.call(path_594148, query_594149, nil, nil, body_594150)

var computePoliciesUpdate* = Call_ComputePoliciesUpdate_594137(
    name: "computePoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies/{computePolicyName}",
    validator: validate_ComputePoliciesUpdate_594138, base: "",
    url: url_ComputePoliciesUpdate_594139, schemes: {Scheme.Https})
type
  Call_ComputePoliciesDelete_594125 = ref object of OpenApiRestCall_593437
proc url_ComputePoliciesDelete_594127(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "computePolicyName" in path,
        "`computePolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/computePolicies/"),
               (kind: VariableSegment, value: "computePolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputePoliciesDelete_594126(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified compute policy from the specified Data Lake Analytics account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: JString (required)
  ##                    : The name of the compute policy to delete.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594128 = path.getOrDefault("resourceGroupName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "resourceGroupName", valid_594128
  var valid_594129 = path.getOrDefault("subscriptionId")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "subscriptionId", valid_594129
  var valid_594130 = path.getOrDefault("computePolicyName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "computePolicyName", valid_594130
  var valid_594131 = path.getOrDefault("accountName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "accountName", valid_594131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594132 = query.getOrDefault("api-version")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "api-version", valid_594132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_ComputePoliciesDelete_594125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified compute policy from the specified Data Lake Analytics account
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_ComputePoliciesDelete_594125;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computePolicyName: string; accountName: string): Recallable =
  ## computePoliciesDelete
  ## Deletes the specified compute policy from the specified Data Lake Analytics account
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   computePolicyName: string (required)
  ##                    : The name of the compute policy to delete.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  add(path_594135, "resourceGroupName", newJString(resourceGroupName))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "subscriptionId", newJString(subscriptionId))
  add(path_594135, "computePolicyName", newJString(computePolicyName))
  add(path_594135, "accountName", newJString(accountName))
  result = call_594134.call(path_594135, query_594136, nil, nil, nil)

var computePoliciesDelete* = Call_ComputePoliciesDelete_594125(
    name: "computePoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/computePolicies/{computePolicyName}",
    validator: validate_ComputePoliciesDelete_594126, base: "",
    url: url_ComputePoliciesDelete_594127, schemes: {Scheme.Https})
type
  Call_DataLakeStoreAccountsListByAccount_594151 = ref object of OpenApiRestCall_593437
proc url_DataLakeStoreAccountsListByAccount_594153(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/dataLakeStoreAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataLakeStoreAccountsListByAccount_594152(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594154 = path.getOrDefault("resourceGroupName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "resourceGroupName", valid_594154
  var valid_594155 = path.getOrDefault("subscriptionId")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "subscriptionId", valid_594155
  var valid_594156 = path.getOrDefault("accountName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "accountName", valid_594156
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_594157 = query.getOrDefault("$orderby")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "$orderby", valid_594157
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  var valid_594159 = query.getOrDefault("$top")
  valid_594159 = validateParameter(valid_594159, JInt, required = false, default = nil)
  if valid_594159 != nil:
    section.add "$top", valid_594159
  var valid_594160 = query.getOrDefault("$select")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "$select", valid_594160
  var valid_594161 = query.getOrDefault("$skip")
  valid_594161 = validateParameter(valid_594161, JInt, required = false, default = nil)
  if valid_594161 != nil:
    section.add "$skip", valid_594161
  var valid_594162 = query.getOrDefault("$count")
  valid_594162 = validateParameter(valid_594162, JBool, required = false, default = nil)
  if valid_594162 != nil:
    section.add "$count", valid_594162
  var valid_594163 = query.getOrDefault("$filter")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "$filter", valid_594163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594164: Call_DataLakeStoreAccountsListByAccount_594151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  let valid = call_594164.validator(path, query, header, formData, body)
  let scheme = call_594164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594164.url(scheme.get, call_594164.host, call_594164.base,
                         call_594164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594164, url, valid)

proc call*(call_594165: Call_DataLakeStoreAccountsListByAccount_594151;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Orderby: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## dataLakeStoreAccountsListByAccount
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_594166 = newJObject()
  var query_594167 = newJObject()
  add(query_594167, "$orderby", newJString(Orderby))
  add(path_594166, "resourceGroupName", newJString(resourceGroupName))
  add(query_594167, "api-version", newJString(apiVersion))
  add(path_594166, "subscriptionId", newJString(subscriptionId))
  add(query_594167, "$top", newJInt(Top))
  add(query_594167, "$select", newJString(Select))
  add(query_594167, "$skip", newJInt(Skip))
  add(query_594167, "$count", newJBool(Count))
  add(path_594166, "accountName", newJString(accountName))
  add(query_594167, "$filter", newJString(Filter))
  result = call_594165.call(path_594166, query_594167, nil, nil, nil)

var dataLakeStoreAccountsListByAccount* = Call_DataLakeStoreAccountsListByAccount_594151(
    name: "dataLakeStoreAccountsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/dataLakeStoreAccounts",
    validator: validate_DataLakeStoreAccountsListByAccount_594152, base: "",
    url: url_DataLakeStoreAccountsListByAccount_594153, schemes: {Scheme.Https})
type
  Call_DataLakeStoreAccountsAdd_594180 = ref object of OpenApiRestCall_593437
proc url_DataLakeStoreAccountsAdd_594182(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "dataLakeStoreAccountName" in path,
        "`dataLakeStoreAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/dataLakeStoreAccounts/"),
               (kind: VariableSegment, value: "dataLakeStoreAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataLakeStoreAccountsAdd_594181(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to add.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594183 = path.getOrDefault("resourceGroupName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "resourceGroupName", valid_594183
  var valid_594184 = path.getOrDefault("subscriptionId")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "subscriptionId", valid_594184
  var valid_594185 = path.getOrDefault("dataLakeStoreAccountName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "dataLakeStoreAccountName", valid_594185
  var valid_594186 = path.getOrDefault("accountName")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "accountName", valid_594186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594187 = query.getOrDefault("api-version")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "api-version", valid_594187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The details of the Data Lake Store account.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594189: Call_DataLakeStoreAccountsAdd_594180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ## 
  let valid = call_594189.validator(path, query, header, formData, body)
  let scheme = call_594189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594189.url(scheme.get, call_594189.host, call_594189.base,
                         call_594189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594189, url, valid)

proc call*(call_594190: Call_DataLakeStoreAccountsAdd_594180;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; accountName: string;
          parameters: JsonNode = nil): Recallable =
  ## dataLakeStoreAccountsAdd
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : The details of the Data Lake Store account.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to add.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594191 = newJObject()
  var query_594192 = newJObject()
  var body_594193 = newJObject()
  add(path_594191, "resourceGroupName", newJString(resourceGroupName))
  add(query_594192, "api-version", newJString(apiVersion))
  add(path_594191, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594193 = parameters
  add(path_594191, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_594191, "accountName", newJString(accountName))
  result = call_594190.call(path_594191, query_594192, nil, nil, body_594193)

var dataLakeStoreAccountsAdd* = Call_DataLakeStoreAccountsAdd_594180(
    name: "dataLakeStoreAccountsAdd", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/dataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_DataLakeStoreAccountsAdd_594181, base: "",
    url: url_DataLakeStoreAccountsAdd_594182, schemes: {Scheme.Https})
type
  Call_DataLakeStoreAccountsGet_594168 = ref object of OpenApiRestCall_593437
proc url_DataLakeStoreAccountsGet_594170(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "dataLakeStoreAccountName" in path,
        "`dataLakeStoreAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/dataLakeStoreAccounts/"),
               (kind: VariableSegment, value: "dataLakeStoreAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataLakeStoreAccountsGet_594169(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to retrieve
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594171 = path.getOrDefault("resourceGroupName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "resourceGroupName", valid_594171
  var valid_594172 = path.getOrDefault("subscriptionId")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "subscriptionId", valid_594172
  var valid_594173 = path.getOrDefault("dataLakeStoreAccountName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "dataLakeStoreAccountName", valid_594173
  var valid_594174 = path.getOrDefault("accountName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "accountName", valid_594174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594175 = query.getOrDefault("api-version")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "api-version", valid_594175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594176: Call_DataLakeStoreAccountsGet_594168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ## 
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_DataLakeStoreAccountsGet_594168;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; accountName: string): Recallable =
  ## dataLakeStoreAccountsGet
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to retrieve
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594178 = newJObject()
  var query_594179 = newJObject()
  add(path_594178, "resourceGroupName", newJString(resourceGroupName))
  add(query_594179, "api-version", newJString(apiVersion))
  add(path_594178, "subscriptionId", newJString(subscriptionId))
  add(path_594178, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_594178, "accountName", newJString(accountName))
  result = call_594177.call(path_594178, query_594179, nil, nil, nil)

var dataLakeStoreAccountsGet* = Call_DataLakeStoreAccountsGet_594168(
    name: "dataLakeStoreAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/dataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_DataLakeStoreAccountsGet_594169, base: "",
    url: url_DataLakeStoreAccountsGet_594170, schemes: {Scheme.Https})
type
  Call_DataLakeStoreAccountsDelete_594194 = ref object of OpenApiRestCall_593437
proc url_DataLakeStoreAccountsDelete_594196(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "dataLakeStoreAccountName" in path,
        "`dataLakeStoreAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/dataLakeStoreAccounts/"),
               (kind: VariableSegment, value: "dataLakeStoreAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataLakeStoreAccountsDelete_594195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to remove
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594197 = path.getOrDefault("resourceGroupName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "resourceGroupName", valid_594197
  var valid_594198 = path.getOrDefault("subscriptionId")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "subscriptionId", valid_594198
  var valid_594199 = path.getOrDefault("dataLakeStoreAccountName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "dataLakeStoreAccountName", valid_594199
  var valid_594200 = path.getOrDefault("accountName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "accountName", valid_594200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594201 = query.getOrDefault("api-version")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "api-version", valid_594201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594202: Call_DataLakeStoreAccountsDelete_594194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ## 
  let valid = call_594202.validator(path, query, header, formData, body)
  let scheme = call_594202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594202.url(scheme.get, call_594202.host, call_594202.base,
                         call_594202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594202, url, valid)

proc call*(call_594203: Call_DataLakeStoreAccountsDelete_594194;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; accountName: string): Recallable =
  ## dataLakeStoreAccountsDelete
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to remove
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594204 = newJObject()
  var query_594205 = newJObject()
  add(path_594204, "resourceGroupName", newJString(resourceGroupName))
  add(query_594205, "api-version", newJString(apiVersion))
  add(path_594204, "subscriptionId", newJString(subscriptionId))
  add(path_594204, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_594204, "accountName", newJString(accountName))
  result = call_594203.call(path_594204, query_594205, nil, nil, nil)

var dataLakeStoreAccountsDelete* = Call_DataLakeStoreAccountsDelete_594194(
    name: "dataLakeStoreAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/dataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_DataLakeStoreAccountsDelete_594195, base: "",
    url: url_DataLakeStoreAccountsDelete_594196, schemes: {Scheme.Https})
type
  Call_FirewallRulesListByAccount_594206 = ref object of OpenApiRestCall_593437
proc url_FirewallRulesListByAccount_594208(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesListByAccount_594207(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Analytics firewall rules within the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594209 = path.getOrDefault("resourceGroupName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "resourceGroupName", valid_594209
  var valid_594210 = path.getOrDefault("subscriptionId")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "subscriptionId", valid_594210
  var valid_594211 = path.getOrDefault("accountName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "accountName", valid_594211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594212 = query.getOrDefault("api-version")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "api-version", valid_594212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594213: Call_FirewallRulesListByAccount_594206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Data Lake Analytics firewall rules within the specified Data Lake Analytics account.
  ## 
  let valid = call_594213.validator(path, query, header, formData, body)
  let scheme = call_594213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594213.url(scheme.get, call_594213.host, call_594213.base,
                         call_594213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594213, url, valid)

proc call*(call_594214: Call_FirewallRulesListByAccount_594206;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## firewallRulesListByAccount
  ## Lists the Data Lake Analytics firewall rules within the specified Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594215 = newJObject()
  var query_594216 = newJObject()
  add(path_594215, "resourceGroupName", newJString(resourceGroupName))
  add(query_594216, "api-version", newJString(apiVersion))
  add(path_594215, "subscriptionId", newJString(subscriptionId))
  add(path_594215, "accountName", newJString(accountName))
  result = call_594214.call(path_594215, query_594216, nil, nil, nil)

var firewallRulesListByAccount* = Call_FirewallRulesListByAccount_594206(
    name: "firewallRulesListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules",
    validator: validate_FirewallRulesListByAccount_594207, base: "",
    url: url_FirewallRulesListByAccount_594208, schemes: {Scheme.Https})
type
  Call_FirewallRulesCreateOrUpdate_594229 = ref object of OpenApiRestCall_593437
proc url_FirewallRulesCreateOrUpdate_594231(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "firewallRuleName" in path,
        "`firewallRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesCreateOrUpdate_594230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified firewall rule. During update, the firewall rule with the specified name will be replaced with this new firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to create or update.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594232 = path.getOrDefault("resourceGroupName")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "resourceGroupName", valid_594232
  var valid_594233 = path.getOrDefault("subscriptionId")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "subscriptionId", valid_594233
  var valid_594234 = path.getOrDefault("firewallRuleName")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "firewallRuleName", valid_594234
  var valid_594235 = path.getOrDefault("accountName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "accountName", valid_594235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594236 = query.getOrDefault("api-version")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "api-version", valid_594236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the firewall rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594238: Call_FirewallRulesCreateOrUpdate_594229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the specified firewall rule. During update, the firewall rule with the specified name will be replaced with this new firewall rule.
  ## 
  let valid = call_594238.validator(path, query, header, formData, body)
  let scheme = call_594238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594238.url(scheme.get, call_594238.host, call_594238.base,
                         call_594238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594238, url, valid)

proc call*(call_594239: Call_FirewallRulesCreateOrUpdate_594229;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; firewallRuleName: string; accountName: string): Recallable =
  ## firewallRulesCreateOrUpdate
  ## Creates or updates the specified firewall rule. During update, the firewall rule with the specified name will be replaced with this new firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the firewall rule.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to create or update.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594240 = newJObject()
  var query_594241 = newJObject()
  var body_594242 = newJObject()
  add(path_594240, "resourceGroupName", newJString(resourceGroupName))
  add(query_594241, "api-version", newJString(apiVersion))
  add(path_594240, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594242 = parameters
  add(path_594240, "firewallRuleName", newJString(firewallRuleName))
  add(path_594240, "accountName", newJString(accountName))
  result = call_594239.call(path_594240, query_594241, nil, nil, body_594242)

var firewallRulesCreateOrUpdate* = Call_FirewallRulesCreateOrUpdate_594229(
    name: "firewallRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesCreateOrUpdate_594230, base: "",
    url: url_FirewallRulesCreateOrUpdate_594231, schemes: {Scheme.Https})
type
  Call_FirewallRulesGet_594217 = ref object of OpenApiRestCall_593437
proc url_FirewallRulesGet_594219(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "firewallRuleName" in path,
        "`firewallRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesGet_594218(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Analytics firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to retrieve.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594220 = path.getOrDefault("resourceGroupName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "resourceGroupName", valid_594220
  var valid_594221 = path.getOrDefault("subscriptionId")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "subscriptionId", valid_594221
  var valid_594222 = path.getOrDefault("firewallRuleName")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "firewallRuleName", valid_594222
  var valid_594223 = path.getOrDefault("accountName")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "accountName", valid_594223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594224 = query.getOrDefault("api-version")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "api-version", valid_594224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594225: Call_FirewallRulesGet_594217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Analytics firewall rule.
  ## 
  let valid = call_594225.validator(path, query, header, formData, body)
  let scheme = call_594225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594225.url(scheme.get, call_594225.host, call_594225.base,
                         call_594225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594225, url, valid)

proc call*(call_594226: Call_FirewallRulesGet_594217; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; firewallRuleName: string;
          accountName: string): Recallable =
  ## firewallRulesGet
  ## Gets the specified Data Lake Analytics firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to retrieve.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594227 = newJObject()
  var query_594228 = newJObject()
  add(path_594227, "resourceGroupName", newJString(resourceGroupName))
  add(query_594228, "api-version", newJString(apiVersion))
  add(path_594227, "subscriptionId", newJString(subscriptionId))
  add(path_594227, "firewallRuleName", newJString(firewallRuleName))
  add(path_594227, "accountName", newJString(accountName))
  result = call_594226.call(path_594227, query_594228, nil, nil, nil)

var firewallRulesGet* = Call_FirewallRulesGet_594217(name: "firewallRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesGet_594218, base: "",
    url: url_FirewallRulesGet_594219, schemes: {Scheme.Https})
type
  Call_FirewallRulesUpdate_594255 = ref object of OpenApiRestCall_593437
proc url_FirewallRulesUpdate_594257(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "firewallRuleName" in path,
        "`firewallRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesUpdate_594256(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the specified firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to update.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594258 = path.getOrDefault("resourceGroupName")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "resourceGroupName", valid_594258
  var valid_594259 = path.getOrDefault("subscriptionId")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "subscriptionId", valid_594259
  var valid_594260 = path.getOrDefault("firewallRuleName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "firewallRuleName", valid_594260
  var valid_594261 = path.getOrDefault("accountName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "accountName", valid_594261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594262 = query.getOrDefault("api-version")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "api-version", valid_594262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to update the firewall rule.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594264: Call_FirewallRulesUpdate_594255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified firewall rule.
  ## 
  let valid = call_594264.validator(path, query, header, formData, body)
  let scheme = call_594264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594264.url(scheme.get, call_594264.host, call_594264.base,
                         call_594264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594264, url, valid)

proc call*(call_594265: Call_FirewallRulesUpdate_594255; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; firewallRuleName: string;
          accountName: string; parameters: JsonNode = nil): Recallable =
  ## firewallRulesUpdate
  ## Updates the specified firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : Parameters supplied to update the firewall rule.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to update.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594266 = newJObject()
  var query_594267 = newJObject()
  var body_594268 = newJObject()
  add(path_594266, "resourceGroupName", newJString(resourceGroupName))
  add(query_594267, "api-version", newJString(apiVersion))
  add(path_594266, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594268 = parameters
  add(path_594266, "firewallRuleName", newJString(firewallRuleName))
  add(path_594266, "accountName", newJString(accountName))
  result = call_594265.call(path_594266, query_594267, nil, nil, body_594268)

var firewallRulesUpdate* = Call_FirewallRulesUpdate_594255(
    name: "firewallRulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesUpdate_594256, base: "",
    url: url_FirewallRulesUpdate_594257, schemes: {Scheme.Https})
type
  Call_FirewallRulesDelete_594243 = ref object of OpenApiRestCall_593437
proc url_FirewallRulesDelete_594245(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "firewallRuleName" in path,
        "`firewallRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesDelete_594244(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified firewall rule from the specified Data Lake Analytics account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to delete.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594246 = path.getOrDefault("resourceGroupName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "resourceGroupName", valid_594246
  var valid_594247 = path.getOrDefault("subscriptionId")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "subscriptionId", valid_594247
  var valid_594248 = path.getOrDefault("firewallRuleName")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "firewallRuleName", valid_594248
  var valid_594249 = path.getOrDefault("accountName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "accountName", valid_594249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594250 = query.getOrDefault("api-version")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "api-version", valid_594250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594251: Call_FirewallRulesDelete_594243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified firewall rule from the specified Data Lake Analytics account
  ## 
  let valid = call_594251.validator(path, query, header, formData, body)
  let scheme = call_594251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594251.url(scheme.get, call_594251.host, call_594251.base,
                         call_594251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594251, url, valid)

proc call*(call_594252: Call_FirewallRulesDelete_594243; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; firewallRuleName: string;
          accountName: string): Recallable =
  ## firewallRulesDelete
  ## Deletes the specified firewall rule from the specified Data Lake Analytics account
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to delete.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594253 = newJObject()
  var query_594254 = newJObject()
  add(path_594253, "resourceGroupName", newJString(resourceGroupName))
  add(query_594254, "api-version", newJString(apiVersion))
  add(path_594253, "subscriptionId", newJString(subscriptionId))
  add(path_594253, "firewallRuleName", newJString(firewallRuleName))
  add(path_594253, "accountName", newJString(accountName))
  result = call_594252.call(path_594253, query_594254, nil, nil, nil)

var firewallRulesDelete* = Call_FirewallRulesDelete_594243(
    name: "firewallRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesDelete_594244, base: "",
    url: url_FirewallRulesDelete_594245, schemes: {Scheme.Https})
type
  Call_StorageAccountsListByAccount_594269 = ref object of OpenApiRestCall_593437
proc url_StorageAccountsListByAccount_594271(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/storageAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListByAccount_594270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594272 = path.getOrDefault("resourceGroupName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "resourceGroupName", valid_594272
  var valid_594273 = path.getOrDefault("subscriptionId")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "subscriptionId", valid_594273
  var valid_594274 = path.getOrDefault("accountName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "accountName", valid_594274
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : The OData filter. Optional.
  section = newJObject()
  var valid_594275 = query.getOrDefault("$orderby")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "$orderby", valid_594275
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594276 = query.getOrDefault("api-version")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "api-version", valid_594276
  var valid_594277 = query.getOrDefault("$top")
  valid_594277 = validateParameter(valid_594277, JInt, required = false, default = nil)
  if valid_594277 != nil:
    section.add "$top", valid_594277
  var valid_594278 = query.getOrDefault("$select")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "$select", valid_594278
  var valid_594279 = query.getOrDefault("$skip")
  valid_594279 = validateParameter(valid_594279, JInt, required = false, default = nil)
  if valid_594279 != nil:
    section.add "$skip", valid_594279
  var valid_594280 = query.getOrDefault("$count")
  valid_594280 = validateParameter(valid_594280, JBool, required = false, default = nil)
  if valid_594280 != nil:
    section.add "$count", valid_594280
  var valid_594281 = query.getOrDefault("$filter")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "$filter", valid_594281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594282: Call_StorageAccountsListByAccount_594269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  let valid = call_594282.validator(path, query, header, formData, body)
  let scheme = call_594282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594282.url(scheme.get, call_594282.host, call_594282.base,
                         call_594282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594282, url, valid)

proc call*(call_594283: Call_StorageAccountsListByAccount_594269;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Orderby: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## storageAccountsListByAccount
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  ##   Filter: string
  ##         : The OData filter. Optional.
  var path_594284 = newJObject()
  var query_594285 = newJObject()
  add(query_594285, "$orderby", newJString(Orderby))
  add(path_594284, "resourceGroupName", newJString(resourceGroupName))
  add(query_594285, "api-version", newJString(apiVersion))
  add(path_594284, "subscriptionId", newJString(subscriptionId))
  add(query_594285, "$top", newJInt(Top))
  add(query_594285, "$select", newJString(Select))
  add(query_594285, "$skip", newJInt(Skip))
  add(query_594285, "$count", newJBool(Count))
  add(path_594284, "accountName", newJString(accountName))
  add(query_594285, "$filter", newJString(Filter))
  result = call_594283.call(path_594284, query_594285, nil, nil, nil)

var storageAccountsListByAccount* = Call_StorageAccountsListByAccount_594269(
    name: "storageAccountsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts",
    validator: validate_StorageAccountsListByAccount_594270, base: "",
    url: url_StorageAccountsListByAccount_594271, schemes: {Scheme.Https})
type
  Call_StorageAccountsAdd_594298 = ref object of OpenApiRestCall_593437
proc url_StorageAccountsAdd_594300(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsAdd_594299(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account to add
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594301 = path.getOrDefault("resourceGroupName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "resourceGroupName", valid_594301
  var valid_594302 = path.getOrDefault("storageAccountName")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "storageAccountName", valid_594302
  var valid_594303 = path.getOrDefault("subscriptionId")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "subscriptionId", valid_594303
  var valid_594304 = path.getOrDefault("accountName")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "accountName", valid_594304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594305 = query.getOrDefault("api-version")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "api-version", valid_594305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and optional suffix for the Azure Storage Account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594307: Call_StorageAccountsAdd_594298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ## 
  let valid = call_594307.validator(path, query, header, formData, body)
  let scheme = call_594307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594307.url(scheme.get, call_594307.host, call_594307.base,
                         call_594307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594307, url, valid)

proc call*(call_594308: Call_StorageAccountsAdd_594298; resourceGroupName: string;
          apiVersion: string; storageAccountName: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## storageAccountsAdd
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account to add
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and optional suffix for the Azure Storage Account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594309 = newJObject()
  var query_594310 = newJObject()
  var body_594311 = newJObject()
  add(path_594309, "resourceGroupName", newJString(resourceGroupName))
  add(query_594310, "api-version", newJString(apiVersion))
  add(path_594309, "storageAccountName", newJString(storageAccountName))
  add(path_594309, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594311 = parameters
  add(path_594309, "accountName", newJString(accountName))
  result = call_594308.call(path_594309, query_594310, nil, nil, body_594311)

var storageAccountsAdd* = Call_StorageAccountsAdd_594298(
    name: "storageAccountsAdd", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}",
    validator: validate_StorageAccountsAdd_594299, base: "",
    url: url_StorageAccountsAdd_594300, schemes: {Scheme.Https})
type
  Call_StorageAccountsGet_594286 = ref object of OpenApiRestCall_593437
proc url_StorageAccountsGet_594288(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsGet_594287(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account for which to retrieve the details.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594289 = path.getOrDefault("resourceGroupName")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "resourceGroupName", valid_594289
  var valid_594290 = path.getOrDefault("storageAccountName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "storageAccountName", valid_594290
  var valid_594291 = path.getOrDefault("subscriptionId")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "subscriptionId", valid_594291
  var valid_594292 = path.getOrDefault("accountName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "accountName", valid_594292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594293 = query.getOrDefault("api-version")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "api-version", valid_594293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594294: Call_StorageAccountsGet_594286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ## 
  let valid = call_594294.validator(path, query, header, formData, body)
  let scheme = call_594294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594294.url(scheme.get, call_594294.host, call_594294.base,
                         call_594294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594294, url, valid)

proc call*(call_594295: Call_StorageAccountsGet_594286; resourceGroupName: string;
          apiVersion: string; storageAccountName: string; subscriptionId: string;
          accountName: string): Recallable =
  ## storageAccountsGet
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account for which to retrieve the details.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594296 = newJObject()
  var query_594297 = newJObject()
  add(path_594296, "resourceGroupName", newJString(resourceGroupName))
  add(query_594297, "api-version", newJString(apiVersion))
  add(path_594296, "storageAccountName", newJString(storageAccountName))
  add(path_594296, "subscriptionId", newJString(subscriptionId))
  add(path_594296, "accountName", newJString(accountName))
  result = call_594295.call(path_594296, query_594297, nil, nil, nil)

var storageAccountsGet* = Call_StorageAccountsGet_594286(
    name: "storageAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}",
    validator: validate_StorageAccountsGet_594287, base: "",
    url: url_StorageAccountsGet_594288, schemes: {Scheme.Https})
type
  Call_StorageAccountsUpdate_594324 = ref object of OpenApiRestCall_593437
proc url_StorageAccountsUpdate_594326(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsUpdate_594325(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The Azure Storage account to modify
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594327 = path.getOrDefault("resourceGroupName")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "resourceGroupName", valid_594327
  var valid_594328 = path.getOrDefault("storageAccountName")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "storageAccountName", valid_594328
  var valid_594329 = path.getOrDefault("subscriptionId")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "subscriptionId", valid_594329
  var valid_594330 = path.getOrDefault("accountName")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "accountName", valid_594330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594331 = query.getOrDefault("api-version")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "api-version", valid_594331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The parameters containing the access key and suffix to update the storage account with, if any. Passing nothing results in no change.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594333: Call_StorageAccountsUpdate_594324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ## 
  let valid = call_594333.validator(path, query, header, formData, body)
  let scheme = call_594333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594333.url(scheme.get, call_594333.host, call_594333.base,
                         call_594333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594333, url, valid)

proc call*(call_594334: Call_StorageAccountsUpdate_594324;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; accountName: string; parameters: JsonNode = nil): Recallable =
  ## storageAccountsUpdate
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The Azure Storage account to modify
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : The parameters containing the access key and suffix to update the storage account with, if any. Passing nothing results in no change.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594335 = newJObject()
  var query_594336 = newJObject()
  var body_594337 = newJObject()
  add(path_594335, "resourceGroupName", newJString(resourceGroupName))
  add(query_594336, "api-version", newJString(apiVersion))
  add(path_594335, "storageAccountName", newJString(storageAccountName))
  add(path_594335, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594337 = parameters
  add(path_594335, "accountName", newJString(accountName))
  result = call_594334.call(path_594335, query_594336, nil, nil, body_594337)

var storageAccountsUpdate* = Call_StorageAccountsUpdate_594324(
    name: "storageAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}",
    validator: validate_StorageAccountsUpdate_594325, base: "",
    url: url_StorageAccountsUpdate_594326, schemes: {Scheme.Https})
type
  Call_StorageAccountsDelete_594312 = ref object of OpenApiRestCall_593437
proc url_StorageAccountsDelete_594314(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsDelete_594313(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account to remove
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594315 = path.getOrDefault("resourceGroupName")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "resourceGroupName", valid_594315
  var valid_594316 = path.getOrDefault("storageAccountName")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "storageAccountName", valid_594316
  var valid_594317 = path.getOrDefault("subscriptionId")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "subscriptionId", valid_594317
  var valid_594318 = path.getOrDefault("accountName")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "accountName", valid_594318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594319 = query.getOrDefault("api-version")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "api-version", valid_594319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594320: Call_StorageAccountsDelete_594312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ## 
  let valid = call_594320.validator(path, query, header, formData, body)
  let scheme = call_594320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594320.url(scheme.get, call_594320.host, call_594320.base,
                         call_594320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594320, url, valid)

proc call*(call_594321: Call_StorageAccountsDelete_594312;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## storageAccountsDelete
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account to remove
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594322 = newJObject()
  var query_594323 = newJObject()
  add(path_594322, "resourceGroupName", newJString(resourceGroupName))
  add(query_594323, "api-version", newJString(apiVersion))
  add(path_594322, "storageAccountName", newJString(storageAccountName))
  add(path_594322, "subscriptionId", newJString(subscriptionId))
  add(path_594322, "accountName", newJString(accountName))
  result = call_594321.call(path_594322, query_594323, nil, nil, nil)

var storageAccountsDelete* = Call_StorageAccountsDelete_594312(
    name: "storageAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}",
    validator: validate_StorageAccountsDelete_594313, base: "",
    url: url_StorageAccountsDelete_594314, schemes: {Scheme.Https})
type
  Call_StorageAccountsListStorageContainers_594338 = ref object of OpenApiRestCall_593437
proc url_StorageAccountsListStorageContainers_594340(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName"),
               (kind: ConstantSegment, value: "/containers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListStorageContainers_594339(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account from which to list blob containers.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594341 = path.getOrDefault("resourceGroupName")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "resourceGroupName", valid_594341
  var valid_594342 = path.getOrDefault("storageAccountName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "storageAccountName", valid_594342
  var valid_594343 = path.getOrDefault("subscriptionId")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "subscriptionId", valid_594343
  var valid_594344 = path.getOrDefault("accountName")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "accountName", valid_594344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594345 = query.getOrDefault("api-version")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "api-version", valid_594345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594346: Call_StorageAccountsListStorageContainers_594338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_594346.validator(path, query, header, formData, body)
  let scheme = call_594346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594346.url(scheme.get, call_594346.host, call_594346.base,
                         call_594346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594346, url, valid)

proc call*(call_594347: Call_StorageAccountsListStorageContainers_594338;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## storageAccountsListStorageContainers
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account from which to list blob containers.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594348 = newJObject()
  var query_594349 = newJObject()
  add(path_594348, "resourceGroupName", newJString(resourceGroupName))
  add(query_594349, "api-version", newJString(apiVersion))
  add(path_594348, "storageAccountName", newJString(storageAccountName))
  add(path_594348, "subscriptionId", newJString(subscriptionId))
  add(path_594348, "accountName", newJString(accountName))
  result = call_594347.call(path_594348, query_594349, nil, nil, nil)

var storageAccountsListStorageContainers* = Call_StorageAccountsListStorageContainers_594338(
    name: "storageAccountsListStorageContainers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}/containers",
    validator: validate_StorageAccountsListStorageContainers_594339, base: "",
    url: url_StorageAccountsListStorageContainers_594340, schemes: {Scheme.Https})
type
  Call_StorageAccountsGetStorageContainer_594350 = ref object of OpenApiRestCall_593437
proc url_StorageAccountsGetStorageContainer_594352(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsGetStorageContainer_594351(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   containerName: JString (required)
  ##                : The name of the Azure storage container to retrieve
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account from which to retrieve the blob container.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594353 = path.getOrDefault("resourceGroupName")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "resourceGroupName", valid_594353
  var valid_594354 = path.getOrDefault("containerName")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "containerName", valid_594354
  var valid_594355 = path.getOrDefault("storageAccountName")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "storageAccountName", valid_594355
  var valid_594356 = path.getOrDefault("subscriptionId")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "subscriptionId", valid_594356
  var valid_594357 = path.getOrDefault("accountName")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "accountName", valid_594357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594358 = query.getOrDefault("api-version")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "api-version", valid_594358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594359: Call_StorageAccountsGetStorageContainer_594350;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ## 
  let valid = call_594359.validator(path, query, header, formData, body)
  let scheme = call_594359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594359.url(scheme.get, call_594359.host, call_594359.base,
                         call_594359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594359, url, valid)

proc call*(call_594360: Call_StorageAccountsGetStorageContainer_594350;
          resourceGroupName: string; apiVersion: string; containerName: string;
          storageAccountName: string; subscriptionId: string; accountName: string): Recallable =
  ## storageAccountsGetStorageContainer
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : The name of the Azure storage container to retrieve
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account from which to retrieve the blob container.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594361 = newJObject()
  var query_594362 = newJObject()
  add(path_594361, "resourceGroupName", newJString(resourceGroupName))
  add(query_594362, "api-version", newJString(apiVersion))
  add(path_594361, "containerName", newJString(containerName))
  add(path_594361, "storageAccountName", newJString(storageAccountName))
  add(path_594361, "subscriptionId", newJString(subscriptionId))
  add(path_594361, "accountName", newJString(accountName))
  result = call_594360.call(path_594361, query_594362, nil, nil, nil)

var storageAccountsGetStorageContainer* = Call_StorageAccountsGetStorageContainer_594350(
    name: "storageAccountsGetStorageContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}/containers/{containerName}",
    validator: validate_StorageAccountsGetStorageContainer_594351, base: "",
    url: url_StorageAccountsGetStorageContainer_594352, schemes: {Scheme.Https})
type
  Call_StorageAccountsListSasTokens_594363 = ref object of OpenApiRestCall_593437
proc url_StorageAccountsListSasTokens_594365(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "storageAccountName" in path,
        "`storageAccountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/storageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/listSasTokens")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListSasTokens_594364(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   containerName: JString (required)
  ##                : The name of the Azure storage container for which the SAS token is being requested.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account for which the SAS token is being requested.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594366 = path.getOrDefault("resourceGroupName")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "resourceGroupName", valid_594366
  var valid_594367 = path.getOrDefault("containerName")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "containerName", valid_594367
  var valid_594368 = path.getOrDefault("storageAccountName")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "storageAccountName", valid_594368
  var valid_594369 = path.getOrDefault("subscriptionId")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "subscriptionId", valid_594369
  var valid_594370 = path.getOrDefault("accountName")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "accountName", valid_594370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594371 = query.getOrDefault("api-version")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "api-version", valid_594371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594372: Call_StorageAccountsListSasTokens_594363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ## 
  let valid = call_594372.validator(path, query, header, formData, body)
  let scheme = call_594372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594372.url(scheme.get, call_594372.host, call_594372.base,
                         call_594372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594372, url, valid)

proc call*(call_594373: Call_StorageAccountsListSasTokens_594363;
          resourceGroupName: string; apiVersion: string; containerName: string;
          storageAccountName: string; subscriptionId: string; accountName: string): Recallable =
  ## storageAccountsListSasTokens
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : The name of the Azure storage container for which the SAS token is being requested.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account for which the SAS token is being requested.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account.
  var path_594374 = newJObject()
  var query_594375 = newJObject()
  add(path_594374, "resourceGroupName", newJString(resourceGroupName))
  add(query_594375, "api-version", newJString(apiVersion))
  add(path_594374, "containerName", newJString(containerName))
  add(path_594374, "storageAccountName", newJString(storageAccountName))
  add(path_594374, "subscriptionId", newJString(subscriptionId))
  add(path_594374, "accountName", newJString(accountName))
  result = call_594373.call(path_594374, query_594375, nil, nil, nil)

var storageAccountsListSasTokens* = Call_StorageAccountsListSasTokens_594363(
    name: "storageAccountsListSasTokens", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/storageAccounts/{storageAccountName}/containers/{containerName}/listSasTokens",
    validator: validate_StorageAccountsListSasTokens_594364, base: "",
    url: url_StorageAccountsListSasTokens_594365, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
