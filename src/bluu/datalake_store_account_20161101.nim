
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DataLakeStoreAccountManagementClient
## version: 2016-11-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Creates an Azure Data Lake Store account management client.
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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "datalake-store-account"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593660 = ref object of OpenApiRestCall_593438
proc url_OperationsList_593662(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593661(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Data Lake Store REST API operations.
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
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "api-version", valid_593821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_OperationsList_593660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Data Lake Store REST API operations.
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_OperationsList_593660; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Data Lake Store REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593916 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  result = call_593915.call(nil, query_593916, nil, nil, nil)

var operationsList* = Call_OperationsList_593660(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataLakeStore/operations",
    validator: validate_OperationsList_593661, base: "", url: url_OperationsList_593662,
    schemes: {Scheme.Https})
type
  Call_AccountsList_593956 = ref object of OpenApiRestCall_593438
proc url_AccountsList_593958(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsList_593957(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Store accounts within the subscription. The response includes a link to the next page of results, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
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
  var valid_593975 = query.getOrDefault("$orderby")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "$orderby", valid_593975
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  var valid_593977 = query.getOrDefault("$top")
  valid_593977 = validateParameter(valid_593977, JInt, required = false, default = nil)
  if valid_593977 != nil:
    section.add "$top", valid_593977
  var valid_593978 = query.getOrDefault("$select")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "$select", valid_593978
  var valid_593979 = query.getOrDefault("$skip")
  valid_593979 = validateParameter(valid_593979, JInt, required = false, default = nil)
  if valid_593979 != nil:
    section.add "$skip", valid_593979
  var valid_593980 = query.getOrDefault("$count")
  valid_593980 = validateParameter(valid_593980, JBool, required = false, default = nil)
  if valid_593980 != nil:
    section.add "$count", valid_593980
  var valid_593981 = query.getOrDefault("$filter")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "$filter", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_AccountsList_593956; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Data Lake Store accounts within the subscription. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_AccountsList_593956; apiVersion: string;
          subscriptionId: string; Orderby: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## accountsList
  ## Lists the Data Lake Store accounts within the subscription. The response includes a link to the next page of results, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  add(query_593985, "$orderby", newJString(Orderby))
  add(query_593985, "api-version", newJString(apiVersion))
  add(path_593984, "subscriptionId", newJString(subscriptionId))
  add(query_593985, "$top", newJInt(Top))
  add(query_593985, "$select", newJString(Select))
  add(query_593985, "$skip", newJInt(Skip))
  add(query_593985, "$count", newJBool(Count))
  add(query_593985, "$filter", newJString(Filter))
  result = call_593983.call(path_593984, query_593985, nil, nil, nil)

var accountsList* = Call_AccountsList_593956(name: "accountsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeStore/accounts",
    validator: validate_AccountsList_593957, base: "", url: url_AccountsList_593958,
    schemes: {Scheme.Https})
type
  Call_LocationsGetCapability_593986 = ref object of OpenApiRestCall_593438
proc url_LocationsGetCapability_593988(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeStore/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/capability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsGetCapability_593987(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets subscription-level properties and limits for Data Lake Store specified by resource location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The resource location without whitespace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593989 = path.getOrDefault("subscriptionId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "subscriptionId", valid_593989
  var valid_593990 = path.getOrDefault("location")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "location", valid_593990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593991 = query.getOrDefault("api-version")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "api-version", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_LocationsGetCapability_593986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets subscription-level properties and limits for Data Lake Store specified by resource location.
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_LocationsGetCapability_593986; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## locationsGetCapability
  ## Gets subscription-level properties and limits for Data Lake Store specified by resource location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The resource location without whitespace.
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "subscriptionId", newJString(subscriptionId))
  add(path_593994, "location", newJString(location))
  result = call_593993.call(path_593994, query_593995, nil, nil, nil)

var locationsGetCapability* = Call_LocationsGetCapability_593986(
    name: "locationsGetCapability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeStore/locations/{location}/capability",
    validator: validate_LocationsGetCapability_593987, base: "",
    url: url_LocationsGetCapability_593988, schemes: {Scheme.Https})
type
  Call_AccountsCheckNameAvailability_593996 = ref object of OpenApiRestCall_593438
proc url_AccountsCheckNameAvailability_593998(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.DataLakeStore/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCheckNameAvailability_593997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the specified account name is available or taken.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The resource location without whitespace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594016 = path.getOrDefault("subscriptionId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "subscriptionId", valid_594016
  var valid_594017 = path.getOrDefault("location")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "location", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594018 = query.getOrDefault("api-version")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "api-version", valid_594018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to check the Data Lake Store account name availability.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_AccountsCheckNameAvailability_593996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the specified account name is available or taken.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_AccountsCheckNameAvailability_593996;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          location: string): Recallable =
  ## accountsCheckNameAvailability
  ## Checks whether the specified account name is available or taken.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to check the Data Lake Store account name availability.
  ##   location: string (required)
  ##           : The resource location without whitespace.
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  var body_594024 = newJObject()
  add(query_594023, "api-version", newJString(apiVersion))
  add(path_594022, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594024 = parameters
  add(path_594022, "location", newJString(location))
  result = call_594021.call(path_594022, query_594023, nil, nil, body_594024)

var accountsCheckNameAvailability* = Call_AccountsCheckNameAvailability_593996(
    name: "accountsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeStore/locations/{location}/checkNameAvailability",
    validator: validate_AccountsCheckNameAvailability_593997, base: "",
    url: url_AccountsCheckNameAvailability_593998, schemes: {Scheme.Https})
type
  Call_LocationsGetUsage_594025 = ref object of OpenApiRestCall_593438
proc url_LocationsGetUsage_594027(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeStore/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsGetUsage_594026(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the current usage count and the limit for the resources of the location under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The resource location without whitespace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594028 = path.getOrDefault("subscriptionId")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "subscriptionId", valid_594028
  var valid_594029 = path.getOrDefault("location")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "location", valid_594029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594030 = query.getOrDefault("api-version")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "api-version", valid_594030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594031: Call_LocationsGetUsage_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current usage count and the limit for the resources of the location under the subscription.
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_LocationsGetUsage_594025; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## locationsGetUsage
  ## Gets the current usage count and the limit for the resources of the location under the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The resource location without whitespace.
  var path_594033 = newJObject()
  var query_594034 = newJObject()
  add(query_594034, "api-version", newJString(apiVersion))
  add(path_594033, "subscriptionId", newJString(subscriptionId))
  add(path_594033, "location", newJString(location))
  result = call_594032.call(path_594033, query_594034, nil, nil, nil)

var locationsGetUsage* = Call_LocationsGetUsage_594025(name: "locationsGetUsage",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeStore/locations/{location}/usages",
    validator: validate_LocationsGetUsage_594026, base: "",
    url: url_LocationsGetUsage_594027, schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_594035 = ref object of OpenApiRestCall_593438
proc url_AccountsListByResourceGroup_594037(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListByResourceGroup_594036(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Store accounts within a specific resource group. The response includes a link to the next page of results, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594038 = path.getOrDefault("resourceGroupName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "resourceGroupName", valid_594038
  var valid_594039 = path.getOrDefault("subscriptionId")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "subscriptionId", valid_594039
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
  ##         : A Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_594040 = query.getOrDefault("$orderby")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "$orderby", valid_594040
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594041 = query.getOrDefault("api-version")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "api-version", valid_594041
  var valid_594042 = query.getOrDefault("$top")
  valid_594042 = validateParameter(valid_594042, JInt, required = false, default = nil)
  if valid_594042 != nil:
    section.add "$top", valid_594042
  var valid_594043 = query.getOrDefault("$select")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "$select", valid_594043
  var valid_594044 = query.getOrDefault("$skip")
  valid_594044 = validateParameter(valid_594044, JInt, required = false, default = nil)
  if valid_594044 != nil:
    section.add "$skip", valid_594044
  var valid_594045 = query.getOrDefault("$count")
  valid_594045 = validateParameter(valid_594045, JBool, required = false, default = nil)
  if valid_594045 != nil:
    section.add "$count", valid_594045
  var valid_594046 = query.getOrDefault("$filter")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "$filter", valid_594046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_AccountsListByResourceGroup_594035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Data Lake Store accounts within a specific resource group. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_AccountsListByResourceGroup_594035;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Orderby: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## accountsListByResourceGroup
  ## Lists the Data Lake Store accounts within a specific resource group. The response includes a link to the next page of results, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : A Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  add(query_594050, "$orderby", newJString(Orderby))
  add(path_594049, "resourceGroupName", newJString(resourceGroupName))
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "subscriptionId", newJString(subscriptionId))
  add(query_594050, "$top", newJInt(Top))
  add(query_594050, "$select", newJString(Select))
  add(query_594050, "$skip", newJInt(Skip))
  add(query_594050, "$count", newJBool(Count))
  add(query_594050, "$filter", newJString(Filter))
  result = call_594048.call(path_594049, query_594050, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_594035(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts",
    validator: validate_AccountsListByResourceGroup_594036, base: "",
    url: url_AccountsListByResourceGroup_594037, schemes: {Scheme.Https})
type
  Call_AccountsCreate_594062 = ref object of OpenApiRestCall_593438
proc url_AccountsCreate_594064(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCreate_594063(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594065 = path.getOrDefault("resourceGroupName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "resourceGroupName", valid_594065
  var valid_594066 = path.getOrDefault("subscriptionId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "subscriptionId", valid_594066
  var valid_594067 = path.getOrDefault("accountName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "accountName", valid_594067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594068 = query.getOrDefault("api-version")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "api-version", valid_594068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create the Data Lake Store account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594070: Call_AccountsCreate_594062; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified Data Lake Store account.
  ## 
  let valid = call_594070.validator(path, query, header, formData, body)
  let scheme = call_594070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594070.url(scheme.get, call_594070.host, call_594070.base,
                         call_594070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594070, url, valid)

proc call*(call_594071: Call_AccountsCreate_594062; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## accountsCreate
  ## Creates the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create the Data Lake Store account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594072 = newJObject()
  var query_594073 = newJObject()
  var body_594074 = newJObject()
  add(path_594072, "resourceGroupName", newJString(resourceGroupName))
  add(query_594073, "api-version", newJString(apiVersion))
  add(path_594072, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594074 = parameters
  add(path_594072, "accountName", newJString(accountName))
  result = call_594071.call(path_594072, query_594073, nil, nil, body_594074)

var accountsCreate* = Call_AccountsCreate_594062(name: "accountsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}",
    validator: validate_AccountsCreate_594063, base: "", url: url_AccountsCreate_594064,
    schemes: {Scheme.Https})
type
  Call_AccountsGet_594051 = ref object of OpenApiRestCall_593438
proc url_AccountsGet_594053(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsGet_594052(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
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
  if body != nil:
    result.add "body", body

proc call*(call_594058: Call_AccountsGet_594051; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Store account.
  ## 
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_AccountsGet_594051; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsGet
  ## Gets the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594060 = newJObject()
  var query_594061 = newJObject()
  add(path_594060, "resourceGroupName", newJString(resourceGroupName))
  add(query_594061, "api-version", newJString(apiVersion))
  add(path_594060, "subscriptionId", newJString(subscriptionId))
  add(path_594060, "accountName", newJString(accountName))
  result = call_594059.call(path_594060, query_594061, nil, nil, nil)

var accountsGet* = Call_AccountsGet_594051(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}",
                                        validator: validate_AccountsGet_594052,
                                        base: "", url: url_AccountsGet_594053,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_594086 = ref object of OpenApiRestCall_593438
proc url_AccountsUpdate_594088(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsUpdate_594087(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Store account information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594089 = path.getOrDefault("resourceGroupName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "resourceGroupName", valid_594089
  var valid_594090 = path.getOrDefault("subscriptionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "subscriptionId", valid_594090
  var valid_594091 = path.getOrDefault("accountName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "accountName", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594092 = query.getOrDefault("api-version")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "api-version", valid_594092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update the Data Lake Store account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594094: Call_AccountsUpdate_594086; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Store account information.
  ## 
  let valid = call_594094.validator(path, query, header, formData, body)
  let scheme = call_594094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594094.url(scheme.get, call_594094.host, call_594094.base,
                         call_594094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594094, url, valid)

proc call*(call_594095: Call_AccountsUpdate_594086; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## accountsUpdate
  ## Updates the specified Data Lake Store account information.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update the Data Lake Store account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594096 = newJObject()
  var query_594097 = newJObject()
  var body_594098 = newJObject()
  add(path_594096, "resourceGroupName", newJString(resourceGroupName))
  add(query_594097, "api-version", newJString(apiVersion))
  add(path_594096, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594098 = parameters
  add(path_594096, "accountName", newJString(accountName))
  result = call_594095.call(path_594096, query_594097, nil, nil, body_594098)

var accountsUpdate* = Call_AccountsUpdate_594086(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}",
    validator: validate_AccountsUpdate_594087, base: "", url: url_AccountsUpdate_594088,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_594075 = ref object of OpenApiRestCall_593438
proc url_AccountsDelete_594077(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsDelete_594076(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
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
  if body != nil:
    result.add "body", body

proc call*(call_594082: Call_AccountsDelete_594075; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Data Lake Store account.
  ## 
  let valid = call_594082.validator(path, query, header, formData, body)
  let scheme = call_594082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594082.url(scheme.get, call_594082.host, call_594082.base,
                         call_594082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594082, url, valid)

proc call*(call_594083: Call_AccountsDelete_594075; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsDelete
  ## Deletes the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594084 = newJObject()
  var query_594085 = newJObject()
  add(path_594084, "resourceGroupName", newJString(resourceGroupName))
  add(query_594085, "api-version", newJString(apiVersion))
  add(path_594084, "subscriptionId", newJString(subscriptionId))
  add(path_594084, "accountName", newJString(accountName))
  result = call_594083.call(path_594084, query_594085, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_594075(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}",
    validator: validate_AccountsDelete_594076, base: "", url: url_AccountsDelete_594077,
    schemes: {Scheme.Https})
type
  Call_AccountsEnableKeyVault_594099 = ref object of OpenApiRestCall_593438
proc url_AccountsEnableKeyVault_594101(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/enableKeyVault")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsEnableKeyVault_594100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Attempts to enable a user managed Key Vault for encryption of the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
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
  var valid_594104 = path.getOrDefault("accountName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "accountName", valid_594104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594105 = query.getOrDefault("api-version")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "api-version", valid_594105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594106: Call_AccountsEnableKeyVault_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attempts to enable a user managed Key Vault for encryption of the specified Data Lake Store account.
  ## 
  let valid = call_594106.validator(path, query, header, formData, body)
  let scheme = call_594106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594106.url(scheme.get, call_594106.host, call_594106.base,
                         call_594106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594106, url, valid)

proc call*(call_594107: Call_AccountsEnableKeyVault_594099;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## accountsEnableKeyVault
  ## Attempts to enable a user managed Key Vault for encryption of the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594108 = newJObject()
  var query_594109 = newJObject()
  add(path_594108, "resourceGroupName", newJString(resourceGroupName))
  add(query_594109, "api-version", newJString(apiVersion))
  add(path_594108, "subscriptionId", newJString(subscriptionId))
  add(path_594108, "accountName", newJString(accountName))
  result = call_594107.call(path_594108, query_594109, nil, nil, nil)

var accountsEnableKeyVault* = Call_AccountsEnableKeyVault_594099(
    name: "accountsEnableKeyVault", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/enableKeyVault",
    validator: validate_AccountsEnableKeyVault_594100, base: "",
    url: url_AccountsEnableKeyVault_594101, schemes: {Scheme.Https})
type
  Call_FirewallRulesListByAccount_594110 = ref object of OpenApiRestCall_593438
proc url_FirewallRulesListByAccount_594112(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesListByAccount_594111(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Store firewall rules within the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594113 = path.getOrDefault("resourceGroupName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "resourceGroupName", valid_594113
  var valid_594114 = path.getOrDefault("subscriptionId")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "subscriptionId", valid_594114
  var valid_594115 = path.getOrDefault("accountName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "accountName", valid_594115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594116 = query.getOrDefault("api-version")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "api-version", valid_594116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594117: Call_FirewallRulesListByAccount_594110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Data Lake Store firewall rules within the specified Data Lake Store account.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_FirewallRulesListByAccount_594110;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## firewallRulesListByAccount
  ## Lists the Data Lake Store firewall rules within the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594119 = newJObject()
  var query_594120 = newJObject()
  add(path_594119, "resourceGroupName", newJString(resourceGroupName))
  add(query_594120, "api-version", newJString(apiVersion))
  add(path_594119, "subscriptionId", newJString(subscriptionId))
  add(path_594119, "accountName", newJString(accountName))
  result = call_594118.call(path_594119, query_594120, nil, nil, nil)

var firewallRulesListByAccount* = Call_FirewallRulesListByAccount_594110(
    name: "firewallRulesListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/firewallRules",
    validator: validate_FirewallRulesListByAccount_594111, base: "",
    url: url_FirewallRulesListByAccount_594112, schemes: {Scheme.Https})
type
  Call_FirewallRulesCreateOrUpdate_594133 = ref object of OpenApiRestCall_593438
proc url_FirewallRulesCreateOrUpdate_594135(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesCreateOrUpdate_594134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified firewall rule. During update, the firewall rule with the specified name will be replaced with this new firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to create or update.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594136 = path.getOrDefault("resourceGroupName")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "resourceGroupName", valid_594136
  var valid_594137 = path.getOrDefault("subscriptionId")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "subscriptionId", valid_594137
  var valid_594138 = path.getOrDefault("firewallRuleName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "firewallRuleName", valid_594138
  var valid_594139 = path.getOrDefault("accountName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "accountName", valid_594139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594140 = query.getOrDefault("api-version")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "api-version", valid_594140
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

proc call*(call_594142: Call_FirewallRulesCreateOrUpdate_594133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the specified firewall rule. During update, the firewall rule with the specified name will be replaced with this new firewall rule.
  ## 
  let valid = call_594142.validator(path, query, header, formData, body)
  let scheme = call_594142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594142.url(scheme.get, call_594142.host, call_594142.base,
                         call_594142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594142, url, valid)

proc call*(call_594143: Call_FirewallRulesCreateOrUpdate_594133;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; firewallRuleName: string; accountName: string): Recallable =
  ## firewallRulesCreateOrUpdate
  ## Creates or updates the specified firewall rule. During update, the firewall rule with the specified name will be replaced with this new firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the firewall rule.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to create or update.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594144 = newJObject()
  var query_594145 = newJObject()
  var body_594146 = newJObject()
  add(path_594144, "resourceGroupName", newJString(resourceGroupName))
  add(query_594145, "api-version", newJString(apiVersion))
  add(path_594144, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594146 = parameters
  add(path_594144, "firewallRuleName", newJString(firewallRuleName))
  add(path_594144, "accountName", newJString(accountName))
  result = call_594143.call(path_594144, query_594145, nil, nil, body_594146)

var firewallRulesCreateOrUpdate* = Call_FirewallRulesCreateOrUpdate_594133(
    name: "firewallRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesCreateOrUpdate_594134, base: "",
    url: url_FirewallRulesCreateOrUpdate_594135, schemes: {Scheme.Https})
type
  Call_FirewallRulesGet_594121 = ref object of OpenApiRestCall_593438
proc url_FirewallRulesGet_594123(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesGet_594122(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Store firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to retrieve.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594124 = path.getOrDefault("resourceGroupName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "resourceGroupName", valid_594124
  var valid_594125 = path.getOrDefault("subscriptionId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "subscriptionId", valid_594125
  var valid_594126 = path.getOrDefault("firewallRuleName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "firewallRuleName", valid_594126
  var valid_594127 = path.getOrDefault("accountName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "accountName", valid_594127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594128 = query.getOrDefault("api-version")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "api-version", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594129: Call_FirewallRulesGet_594121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Store firewall rule.
  ## 
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_FirewallRulesGet_594121; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; firewallRuleName: string;
          accountName: string): Recallable =
  ## firewallRulesGet
  ## Gets the specified Data Lake Store firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to retrieve.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594131 = newJObject()
  var query_594132 = newJObject()
  add(path_594131, "resourceGroupName", newJString(resourceGroupName))
  add(query_594132, "api-version", newJString(apiVersion))
  add(path_594131, "subscriptionId", newJString(subscriptionId))
  add(path_594131, "firewallRuleName", newJString(firewallRuleName))
  add(path_594131, "accountName", newJString(accountName))
  result = call_594130.call(path_594131, query_594132, nil, nil, nil)

var firewallRulesGet* = Call_FirewallRulesGet_594121(name: "firewallRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesGet_594122, base: "",
    url: url_FirewallRulesGet_594123, schemes: {Scheme.Https})
type
  Call_FirewallRulesUpdate_594159 = ref object of OpenApiRestCall_593438
proc url_FirewallRulesUpdate_594161(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesUpdate_594160(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to update.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594162 = path.getOrDefault("resourceGroupName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "resourceGroupName", valid_594162
  var valid_594163 = path.getOrDefault("subscriptionId")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "subscriptionId", valid_594163
  var valid_594164 = path.getOrDefault("firewallRuleName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "firewallRuleName", valid_594164
  var valid_594165 = path.getOrDefault("accountName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "accountName", valid_594165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594166 = query.getOrDefault("api-version")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "api-version", valid_594166
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

proc call*(call_594168: Call_FirewallRulesUpdate_594159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified firewall rule.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_FirewallRulesUpdate_594159; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; firewallRuleName: string;
          accountName: string; parameters: JsonNode = nil): Recallable =
  ## firewallRulesUpdate
  ## Updates the specified firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : Parameters supplied to update the firewall rule.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to update.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  var body_594172 = newJObject()
  add(path_594170, "resourceGroupName", newJString(resourceGroupName))
  add(query_594171, "api-version", newJString(apiVersion))
  add(path_594170, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594172 = parameters
  add(path_594170, "firewallRuleName", newJString(firewallRuleName))
  add(path_594170, "accountName", newJString(accountName))
  result = call_594169.call(path_594170, query_594171, nil, nil, body_594172)

var firewallRulesUpdate* = Call_FirewallRulesUpdate_594159(
    name: "firewallRulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesUpdate_594160, base: "",
    url: url_FirewallRulesUpdate_594161, schemes: {Scheme.Https})
type
  Call_FirewallRulesDelete_594147 = ref object of OpenApiRestCall_593438
proc url_FirewallRulesDelete_594149(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesDelete_594148(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified firewall rule from the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the firewall rule to delete.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594150 = path.getOrDefault("resourceGroupName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "resourceGroupName", valid_594150
  var valid_594151 = path.getOrDefault("subscriptionId")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "subscriptionId", valid_594151
  var valid_594152 = path.getOrDefault("firewallRuleName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "firewallRuleName", valid_594152
  var valid_594153 = path.getOrDefault("accountName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "accountName", valid_594153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594154 = query.getOrDefault("api-version")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "api-version", valid_594154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594155: Call_FirewallRulesDelete_594147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified firewall rule from the specified Data Lake Store account.
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_FirewallRulesDelete_594147; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; firewallRuleName: string;
          accountName: string): Recallable =
  ## firewallRulesDelete
  ## Deletes the specified firewall rule from the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   firewallRuleName: string (required)
  ##                   : The name of the firewall rule to delete.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594157 = newJObject()
  var query_594158 = newJObject()
  add(path_594157, "resourceGroupName", newJString(resourceGroupName))
  add(query_594158, "api-version", newJString(apiVersion))
  add(path_594157, "subscriptionId", newJString(subscriptionId))
  add(path_594157, "firewallRuleName", newJString(firewallRuleName))
  add(path_594157, "accountName", newJString(accountName))
  result = call_594156.call(path_594157, query_594158, nil, nil, nil)

var firewallRulesDelete* = Call_FirewallRulesDelete_594147(
    name: "firewallRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesDelete_594148, base: "",
    url: url_FirewallRulesDelete_594149, schemes: {Scheme.Https})
type
  Call_TrustedIdProvidersListByAccount_594173 = ref object of OpenApiRestCall_593438
proc url_TrustedIdProvidersListByAccount_594175(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/trustedIdProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TrustedIdProvidersListByAccount_594174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Store trusted identity providers within the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594176 = path.getOrDefault("resourceGroupName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "resourceGroupName", valid_594176
  var valid_594177 = path.getOrDefault("subscriptionId")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "subscriptionId", valid_594177
  var valid_594178 = path.getOrDefault("accountName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "accountName", valid_594178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594179 = query.getOrDefault("api-version")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "api-version", valid_594179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594180: Call_TrustedIdProvidersListByAccount_594173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Data Lake Store trusted identity providers within the specified Data Lake Store account.
  ## 
  let valid = call_594180.validator(path, query, header, formData, body)
  let scheme = call_594180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594180.url(scheme.get, call_594180.host, call_594180.base,
                         call_594180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594180, url, valid)

proc call*(call_594181: Call_TrustedIdProvidersListByAccount_594173;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## trustedIdProvidersListByAccount
  ## Lists the Data Lake Store trusted identity providers within the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594182 = newJObject()
  var query_594183 = newJObject()
  add(path_594182, "resourceGroupName", newJString(resourceGroupName))
  add(query_594183, "api-version", newJString(apiVersion))
  add(path_594182, "subscriptionId", newJString(subscriptionId))
  add(path_594182, "accountName", newJString(accountName))
  result = call_594181.call(path_594182, query_594183, nil, nil, nil)

var trustedIdProvidersListByAccount* = Call_TrustedIdProvidersListByAccount_594173(
    name: "trustedIdProvidersListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/trustedIdProviders",
    validator: validate_TrustedIdProvidersListByAccount_594174, base: "",
    url: url_TrustedIdProvidersListByAccount_594175, schemes: {Scheme.Https})
type
  Call_TrustedIdProvidersCreateOrUpdate_594196 = ref object of OpenApiRestCall_593438
proc url_TrustedIdProvidersCreateOrUpdate_594198(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "trustedIdProviderName" in path,
        "`trustedIdProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/trustedIdProviders/"),
               (kind: VariableSegment, value: "trustedIdProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TrustedIdProvidersCreateOrUpdate_594197(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified trusted identity provider. During update, the trusted identity provider with the specified name will be replaced with this new provider
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   trustedIdProviderName: JString (required)
  ##                        : The name of the trusted identity provider. This is used for differentiation of providers in the account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594199 = path.getOrDefault("resourceGroupName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "resourceGroupName", valid_594199
  var valid_594200 = path.getOrDefault("trustedIdProviderName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "trustedIdProviderName", valid_594200
  var valid_594201 = path.getOrDefault("subscriptionId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "subscriptionId", valid_594201
  var valid_594202 = path.getOrDefault("accountName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "accountName", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "api-version", valid_594203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or replace the trusted identity provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594205: Call_TrustedIdProvidersCreateOrUpdate_594196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the specified trusted identity provider. During update, the trusted identity provider with the specified name will be replaced with this new provider
  ## 
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_TrustedIdProvidersCreateOrUpdate_594196;
          resourceGroupName: string; apiVersion: string;
          trustedIdProviderName: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## trustedIdProvidersCreateOrUpdate
  ## Creates or updates the specified trusted identity provider. During update, the trusted identity provider with the specified name will be replaced with this new provider
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   trustedIdProviderName: string (required)
  ##                        : The name of the trusted identity provider. This is used for differentiation of providers in the account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or replace the trusted identity provider.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  var body_594209 = newJObject()
  add(path_594207, "resourceGroupName", newJString(resourceGroupName))
  add(query_594208, "api-version", newJString(apiVersion))
  add(path_594207, "trustedIdProviderName", newJString(trustedIdProviderName))
  add(path_594207, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594209 = parameters
  add(path_594207, "accountName", newJString(accountName))
  result = call_594206.call(path_594207, query_594208, nil, nil, body_594209)

var trustedIdProvidersCreateOrUpdate* = Call_TrustedIdProvidersCreateOrUpdate_594196(
    name: "trustedIdProvidersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/trustedIdProviders/{trustedIdProviderName}",
    validator: validate_TrustedIdProvidersCreateOrUpdate_594197, base: "",
    url: url_TrustedIdProvidersCreateOrUpdate_594198, schemes: {Scheme.Https})
type
  Call_TrustedIdProvidersGet_594184 = ref object of OpenApiRestCall_593438
proc url_TrustedIdProvidersGet_594186(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "trustedIdProviderName" in path,
        "`trustedIdProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/trustedIdProviders/"),
               (kind: VariableSegment, value: "trustedIdProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TrustedIdProvidersGet_594185(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Store trusted identity provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   trustedIdProviderName: JString (required)
  ##                        : The name of the trusted identity provider to retrieve.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594187 = path.getOrDefault("resourceGroupName")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "resourceGroupName", valid_594187
  var valid_594188 = path.getOrDefault("trustedIdProviderName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "trustedIdProviderName", valid_594188
  var valid_594189 = path.getOrDefault("subscriptionId")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "subscriptionId", valid_594189
  var valid_594190 = path.getOrDefault("accountName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "accountName", valid_594190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594191 = query.getOrDefault("api-version")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "api-version", valid_594191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594192: Call_TrustedIdProvidersGet_594184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Store trusted identity provider.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_TrustedIdProvidersGet_594184;
          resourceGroupName: string; apiVersion: string;
          trustedIdProviderName: string; subscriptionId: string; accountName: string): Recallable =
  ## trustedIdProvidersGet
  ## Gets the specified Data Lake Store trusted identity provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   trustedIdProviderName: string (required)
  ##                        : The name of the trusted identity provider to retrieve.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  add(path_594194, "resourceGroupName", newJString(resourceGroupName))
  add(query_594195, "api-version", newJString(apiVersion))
  add(path_594194, "trustedIdProviderName", newJString(trustedIdProviderName))
  add(path_594194, "subscriptionId", newJString(subscriptionId))
  add(path_594194, "accountName", newJString(accountName))
  result = call_594193.call(path_594194, query_594195, nil, nil, nil)

var trustedIdProvidersGet* = Call_TrustedIdProvidersGet_594184(
    name: "trustedIdProvidersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/trustedIdProviders/{trustedIdProviderName}",
    validator: validate_TrustedIdProvidersGet_594185, base: "",
    url: url_TrustedIdProvidersGet_594186, schemes: {Scheme.Https})
type
  Call_TrustedIdProvidersUpdate_594222 = ref object of OpenApiRestCall_593438
proc url_TrustedIdProvidersUpdate_594224(protocol: Scheme; host: string;
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
  assert "trustedIdProviderName" in path,
        "`trustedIdProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/trustedIdProviders/"),
               (kind: VariableSegment, value: "trustedIdProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TrustedIdProvidersUpdate_594223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified trusted identity provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   trustedIdProviderName: JString (required)
  ##                        : The name of the trusted identity provider. This is used for differentiation of providers in the account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594225 = path.getOrDefault("resourceGroupName")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "resourceGroupName", valid_594225
  var valid_594226 = path.getOrDefault("trustedIdProviderName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "trustedIdProviderName", valid_594226
  var valid_594227 = path.getOrDefault("subscriptionId")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "subscriptionId", valid_594227
  var valid_594228 = path.getOrDefault("accountName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "accountName", valid_594228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594229 = query.getOrDefault("api-version")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "api-version", valid_594229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to update the trusted identity provider.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594231: Call_TrustedIdProvidersUpdate_594222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified trusted identity provider.
  ## 
  let valid = call_594231.validator(path, query, header, formData, body)
  let scheme = call_594231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594231.url(scheme.get, call_594231.host, call_594231.base,
                         call_594231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594231, url, valid)

proc call*(call_594232: Call_TrustedIdProvidersUpdate_594222;
          resourceGroupName: string; apiVersion: string;
          trustedIdProviderName: string; subscriptionId: string;
          accountName: string; parameters: JsonNode = nil): Recallable =
  ## trustedIdProvidersUpdate
  ## Updates the specified trusted identity provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   trustedIdProviderName: string (required)
  ##                        : The name of the trusted identity provider. This is used for differentiation of providers in the account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : Parameters supplied to update the trusted identity provider.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594233 = newJObject()
  var query_594234 = newJObject()
  var body_594235 = newJObject()
  add(path_594233, "resourceGroupName", newJString(resourceGroupName))
  add(query_594234, "api-version", newJString(apiVersion))
  add(path_594233, "trustedIdProviderName", newJString(trustedIdProviderName))
  add(path_594233, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594235 = parameters
  add(path_594233, "accountName", newJString(accountName))
  result = call_594232.call(path_594233, query_594234, nil, nil, body_594235)

var trustedIdProvidersUpdate* = Call_TrustedIdProvidersUpdate_594222(
    name: "trustedIdProvidersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/trustedIdProviders/{trustedIdProviderName}",
    validator: validate_TrustedIdProvidersUpdate_594223, base: "",
    url: url_TrustedIdProvidersUpdate_594224, schemes: {Scheme.Https})
type
  Call_TrustedIdProvidersDelete_594210 = ref object of OpenApiRestCall_593438
proc url_TrustedIdProvidersDelete_594212(protocol: Scheme; host: string;
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
  assert "trustedIdProviderName" in path,
        "`trustedIdProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/trustedIdProviders/"),
               (kind: VariableSegment, value: "trustedIdProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TrustedIdProvidersDelete_594211(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified trusted identity provider from the specified Data Lake Store account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   trustedIdProviderName: JString (required)
  ##                        : The name of the trusted identity provider to delete.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594213 = path.getOrDefault("resourceGroupName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "resourceGroupName", valid_594213
  var valid_594214 = path.getOrDefault("trustedIdProviderName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "trustedIdProviderName", valid_594214
  var valid_594215 = path.getOrDefault("subscriptionId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "subscriptionId", valid_594215
  var valid_594216 = path.getOrDefault("accountName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "accountName", valid_594216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594217 = query.getOrDefault("api-version")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "api-version", valid_594217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594218: Call_TrustedIdProvidersDelete_594210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified trusted identity provider from the specified Data Lake Store account
  ## 
  let valid = call_594218.validator(path, query, header, formData, body)
  let scheme = call_594218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594218.url(scheme.get, call_594218.host, call_594218.base,
                         call_594218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594218, url, valid)

proc call*(call_594219: Call_TrustedIdProvidersDelete_594210;
          resourceGroupName: string; apiVersion: string;
          trustedIdProviderName: string; subscriptionId: string; accountName: string): Recallable =
  ## trustedIdProvidersDelete
  ## Deletes the specified trusted identity provider from the specified Data Lake Store account
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   trustedIdProviderName: string (required)
  ##                        : The name of the trusted identity provider to delete.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594220 = newJObject()
  var query_594221 = newJObject()
  add(path_594220, "resourceGroupName", newJString(resourceGroupName))
  add(query_594221, "api-version", newJString(apiVersion))
  add(path_594220, "trustedIdProviderName", newJString(trustedIdProviderName))
  add(path_594220, "subscriptionId", newJString(subscriptionId))
  add(path_594220, "accountName", newJString(accountName))
  result = call_594219.call(path_594220, query_594221, nil, nil, nil)

var trustedIdProvidersDelete* = Call_TrustedIdProvidersDelete_594210(
    name: "trustedIdProvidersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/trustedIdProviders/{trustedIdProviderName}",
    validator: validate_TrustedIdProvidersDelete_594211, base: "",
    url: url_TrustedIdProvidersDelete_594212, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesListByAccount_594236 = ref object of OpenApiRestCall_593438
proc url_VirtualNetworkRulesListByAccount_594238(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesListByAccount_594237(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Data Lake Store virtual network rules within the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594239 = path.getOrDefault("resourceGroupName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "resourceGroupName", valid_594239
  var valid_594240 = path.getOrDefault("subscriptionId")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "subscriptionId", valid_594240
  var valid_594241 = path.getOrDefault("accountName")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "accountName", valid_594241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594242 = query.getOrDefault("api-version")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "api-version", valid_594242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594243: Call_VirtualNetworkRulesListByAccount_594236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Data Lake Store virtual network rules within the specified Data Lake Store account.
  ## 
  let valid = call_594243.validator(path, query, header, formData, body)
  let scheme = call_594243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594243.url(scheme.get, call_594243.host, call_594243.base,
                         call_594243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594243, url, valid)

proc call*(call_594244: Call_VirtualNetworkRulesListByAccount_594236;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## virtualNetworkRulesListByAccount
  ## Lists the Data Lake Store virtual network rules within the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594245 = newJObject()
  var query_594246 = newJObject()
  add(path_594245, "resourceGroupName", newJString(resourceGroupName))
  add(query_594246, "api-version", newJString(apiVersion))
  add(path_594245, "subscriptionId", newJString(subscriptionId))
  add(path_594245, "accountName", newJString(accountName))
  result = call_594244.call(path_594245, query_594246, nil, nil, nil)

var virtualNetworkRulesListByAccount* = Call_VirtualNetworkRulesListByAccount_594236(
    name: "virtualNetworkRulesListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/virtualNetworkRules",
    validator: validate_VirtualNetworkRulesListByAccount_594237, base: "",
    url: url_VirtualNetworkRulesListByAccount_594238, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesCreateOrUpdate_594259 = ref object of OpenApiRestCall_593438
proc url_VirtualNetworkRulesCreateOrUpdate_594261(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesCreateOrUpdate_594260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified virtual network rule. During update, the virtual network rule with the specified name will be replaced with this new virtual network rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The name of the virtual network rule to create or update.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594262 = path.getOrDefault("resourceGroupName")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "resourceGroupName", valid_594262
  var valid_594263 = path.getOrDefault("subscriptionId")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "subscriptionId", valid_594263
  var valid_594264 = path.getOrDefault("virtualNetworkRuleName")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "virtualNetworkRuleName", valid_594264
  var valid_594265 = path.getOrDefault("accountName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "accountName", valid_594265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594266 = query.getOrDefault("api-version")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "api-version", valid_594266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the virtual network rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594268: Call_VirtualNetworkRulesCreateOrUpdate_594259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the specified virtual network rule. During update, the virtual network rule with the specified name will be replaced with this new virtual network rule.
  ## 
  let valid = call_594268.validator(path, query, header, formData, body)
  let scheme = call_594268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594268.url(scheme.get, call_594268.host, call_594268.base,
                         call_594268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594268, url, valid)

proc call*(call_594269: Call_VirtualNetworkRulesCreateOrUpdate_594259;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkRuleName: string; parameters: JsonNode; accountName: string): Recallable =
  ## virtualNetworkRulesCreateOrUpdate
  ## Creates or updates the specified virtual network rule. During update, the virtual network rule with the specified name will be replaced with this new virtual network rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkRuleName: string (required)
  ##                         : The name of the virtual network rule to create or update.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update the virtual network rule.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594270 = newJObject()
  var query_594271 = newJObject()
  var body_594272 = newJObject()
  add(path_594270, "resourceGroupName", newJString(resourceGroupName))
  add(query_594271, "api-version", newJString(apiVersion))
  add(path_594270, "subscriptionId", newJString(subscriptionId))
  add(path_594270, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  if parameters != nil:
    body_594272 = parameters
  add(path_594270, "accountName", newJString(accountName))
  result = call_594269.call(path_594270, query_594271, nil, nil, body_594272)

var virtualNetworkRulesCreateOrUpdate* = Call_VirtualNetworkRulesCreateOrUpdate_594259(
    name: "virtualNetworkRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/virtualNetworkRules/{virtualNetworkRuleName}",
    validator: validate_VirtualNetworkRulesCreateOrUpdate_594260, base: "",
    url: url_VirtualNetworkRulesCreateOrUpdate_594261, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesGet_594247 = ref object of OpenApiRestCall_593438
proc url_VirtualNetworkRulesGet_594249(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesGet_594248(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Store virtual network rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The name of the virtual network rule to retrieve.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594250 = path.getOrDefault("resourceGroupName")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "resourceGroupName", valid_594250
  var valid_594251 = path.getOrDefault("subscriptionId")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "subscriptionId", valid_594251
  var valid_594252 = path.getOrDefault("virtualNetworkRuleName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "virtualNetworkRuleName", valid_594252
  var valid_594253 = path.getOrDefault("accountName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "accountName", valid_594253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594254 = query.getOrDefault("api-version")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "api-version", valid_594254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594255: Call_VirtualNetworkRulesGet_594247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Store virtual network rule.
  ## 
  let valid = call_594255.validator(path, query, header, formData, body)
  let scheme = call_594255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594255.url(scheme.get, call_594255.host, call_594255.base,
                         call_594255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594255, url, valid)

proc call*(call_594256: Call_VirtualNetworkRulesGet_594247;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkRuleName: string; accountName: string): Recallable =
  ## virtualNetworkRulesGet
  ## Gets the specified Data Lake Store virtual network rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkRuleName: string (required)
  ##                         : The name of the virtual network rule to retrieve.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594257 = newJObject()
  var query_594258 = newJObject()
  add(path_594257, "resourceGroupName", newJString(resourceGroupName))
  add(query_594258, "api-version", newJString(apiVersion))
  add(path_594257, "subscriptionId", newJString(subscriptionId))
  add(path_594257, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  add(path_594257, "accountName", newJString(accountName))
  result = call_594256.call(path_594257, query_594258, nil, nil, nil)

var virtualNetworkRulesGet* = Call_VirtualNetworkRulesGet_594247(
    name: "virtualNetworkRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/virtualNetworkRules/{virtualNetworkRuleName}",
    validator: validate_VirtualNetworkRulesGet_594248, base: "",
    url: url_VirtualNetworkRulesGet_594249, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesUpdate_594285 = ref object of OpenApiRestCall_593438
proc url_VirtualNetworkRulesUpdate_594287(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesUpdate_594286(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified virtual network rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The name of the virtual network rule to update.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594288 = path.getOrDefault("resourceGroupName")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "resourceGroupName", valid_594288
  var valid_594289 = path.getOrDefault("subscriptionId")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "subscriptionId", valid_594289
  var valid_594290 = path.getOrDefault("virtualNetworkRuleName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "virtualNetworkRuleName", valid_594290
  var valid_594291 = path.getOrDefault("accountName")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "accountName", valid_594291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594292 = query.getOrDefault("api-version")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "api-version", valid_594292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to update the virtual network rule.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594294: Call_VirtualNetworkRulesUpdate_594285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified virtual network rule.
  ## 
  let valid = call_594294.validator(path, query, header, formData, body)
  let scheme = call_594294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594294.url(scheme.get, call_594294.host, call_594294.base,
                         call_594294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594294, url, valid)

proc call*(call_594295: Call_VirtualNetworkRulesUpdate_594285;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkRuleName: string; accountName: string;
          parameters: JsonNode = nil): Recallable =
  ## virtualNetworkRulesUpdate
  ## Updates the specified virtual network rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkRuleName: string (required)
  ##                         : The name of the virtual network rule to update.
  ##   parameters: JObject
  ##             : Parameters supplied to update the virtual network rule.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594296 = newJObject()
  var query_594297 = newJObject()
  var body_594298 = newJObject()
  add(path_594296, "resourceGroupName", newJString(resourceGroupName))
  add(query_594297, "api-version", newJString(apiVersion))
  add(path_594296, "subscriptionId", newJString(subscriptionId))
  add(path_594296, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  if parameters != nil:
    body_594298 = parameters
  add(path_594296, "accountName", newJString(accountName))
  result = call_594295.call(path_594296, query_594297, nil, nil, body_594298)

var virtualNetworkRulesUpdate* = Call_VirtualNetworkRulesUpdate_594285(
    name: "virtualNetworkRulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/virtualNetworkRules/{virtualNetworkRuleName}",
    validator: validate_VirtualNetworkRulesUpdate_594286, base: "",
    url: url_VirtualNetworkRulesUpdate_594287, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesDelete_594273 = ref object of OpenApiRestCall_593438
proc url_VirtualNetworkRulesDelete_594275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeStore/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesDelete_594274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified virtual network rule from the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The name of the virtual network rule to delete.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594276 = path.getOrDefault("resourceGroupName")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "resourceGroupName", valid_594276
  var valid_594277 = path.getOrDefault("subscriptionId")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "subscriptionId", valid_594277
  var valid_594278 = path.getOrDefault("virtualNetworkRuleName")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "virtualNetworkRuleName", valid_594278
  var valid_594279 = path.getOrDefault("accountName")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "accountName", valid_594279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594280 = query.getOrDefault("api-version")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "api-version", valid_594280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594281: Call_VirtualNetworkRulesDelete_594273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified virtual network rule from the specified Data Lake Store account.
  ## 
  let valid = call_594281.validator(path, query, header, formData, body)
  let scheme = call_594281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594281.url(scheme.get, call_594281.host, call_594281.base,
                         call_594281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594281, url, valid)

proc call*(call_594282: Call_VirtualNetworkRulesDelete_594273;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkRuleName: string; accountName: string): Recallable =
  ## virtualNetworkRulesDelete
  ## Deletes the specified virtual network rule from the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkRuleName: string (required)
  ##                         : The name of the virtual network rule to delete.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Store account.
  var path_594283 = newJObject()
  var query_594284 = newJObject()
  add(path_594283, "resourceGroupName", newJString(resourceGroupName))
  add(query_594284, "api-version", newJString(apiVersion))
  add(path_594283, "subscriptionId", newJString(subscriptionId))
  add(path_594283, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  add(path_594283, "accountName", newJString(accountName))
  result = call_594282.call(path_594283, query_594284, nil, nil, nil)

var virtualNetworkRulesDelete* = Call_VirtualNetworkRulesDelete_594273(
    name: "virtualNetworkRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeStore/accounts/{accountName}/virtualNetworkRules/{virtualNetworkRuleName}",
    validator: validate_VirtualNetworkRulesDelete_594274, base: "",
    url: url_VirtualNetworkRulesDelete_594275, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
