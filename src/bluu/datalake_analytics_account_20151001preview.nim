
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DataLakeAnalyticsAccountManagementClient
## version: 2015-10-01-preview
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  Call_AccountList_593630 = ref object of OpenApiRestCall_593408
proc url_AccountList_593632(protocol: Scheme; host: string; base: string;
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

proc validate_AccountList_593631(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593806 = path.getOrDefault("subscriptionId")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = nil)
  if valid_593806 != nil:
    section.add "subscriptionId", valid_593806
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
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
  ##   $search: JString
  ##          : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   $format: JString
  ##          : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_593807 = query.getOrDefault("$orderby")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "$orderby", valid_593807
  var valid_593808 = query.getOrDefault("$expand")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "$expand", valid_593808
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593809 = query.getOrDefault("api-version")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "api-version", valid_593809
  var valid_593810 = query.getOrDefault("$top")
  valid_593810 = validateParameter(valid_593810, JInt, required = false, default = nil)
  if valid_593810 != nil:
    section.add "$top", valid_593810
  var valid_593811 = query.getOrDefault("$select")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "$select", valid_593811
  var valid_593812 = query.getOrDefault("$skip")
  valid_593812 = validateParameter(valid_593812, JInt, required = false, default = nil)
  if valid_593812 != nil:
    section.add "$skip", valid_593812
  var valid_593813 = query.getOrDefault("$count")
  valid_593813 = validateParameter(valid_593813, JBool, required = false, default = nil)
  if valid_593813 != nil:
    section.add "$count", valid_593813
  var valid_593814 = query.getOrDefault("$search")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "$search", valid_593814
  var valid_593815 = query.getOrDefault("$format")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = nil)
  if valid_593815 != nil:
    section.add "$format", valid_593815
  var valid_593816 = query.getOrDefault("$filter")
  valid_593816 = validateParameter(valid_593816, JString, required = false,
                                 default = nil)
  if valid_593816 != nil:
    section.add "$filter", valid_593816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593839: Call_AccountList_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
  ## 
  let valid = call_593839.validator(path, query, header, formData, body)
  let scheme = call_593839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593839.url(scheme.get, call_593839.host, call_593839.base,
                         call_593839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593839, url, valid)

proc call*(call_593910: Call_AccountList_593630; apiVersion: string;
          subscriptionId: string; Orderby: string = ""; Expand: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Search: string = "";
          Format: string = ""; Filter: string = ""): Recallable =
  ## accountList
  ## Gets the first page of Data Lake Analytics accounts, if any, within the current subscription. This includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
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
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   Format: string
  ##         : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_593911 = newJObject()
  var query_593913 = newJObject()
  add(query_593913, "$orderby", newJString(Orderby))
  add(query_593913, "$expand", newJString(Expand))
  add(query_593913, "api-version", newJString(apiVersion))
  add(path_593911, "subscriptionId", newJString(subscriptionId))
  add(query_593913, "$top", newJInt(Top))
  add(query_593913, "$select", newJString(Select))
  add(query_593913, "$skip", newJInt(Skip))
  add(query_593913, "$count", newJBool(Count))
  add(query_593913, "$search", newJString(Search))
  add(query_593913, "$format", newJString(Format))
  add(query_593913, "$filter", newJString(Filter))
  result = call_593910.call(path_593911, query_593913, nil, nil, nil)

var accountList* = Call_AccountList_593630(name: "accountList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataLakeAnalytics/accounts",
                                        validator: validate_AccountList_593631,
                                        base: "", url: url_AccountList_593632,
                                        schemes: {Scheme.Https})
type
  Call_AccountListByResourceGroup_593952 = ref object of OpenApiRestCall_593408
proc url_AccountListByResourceGroup_593954(protocol: Scheme; host: string;
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

proc validate_AccountListByResourceGroup_593953(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593955 = path.getOrDefault("resourceGroupName")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "resourceGroupName", valid_593955
  var valid_593956 = path.getOrDefault("subscriptionId")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "subscriptionId", valid_593956
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
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
  ##   $search: JString
  ##          : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   $format: JString
  ##          : The return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_593957 = query.getOrDefault("$orderby")
  valid_593957 = validateParameter(valid_593957, JString, required = false,
                                 default = nil)
  if valid_593957 != nil:
    section.add "$orderby", valid_593957
  var valid_593958 = query.getOrDefault("$expand")
  valid_593958 = validateParameter(valid_593958, JString, required = false,
                                 default = nil)
  if valid_593958 != nil:
    section.add "$expand", valid_593958
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593959 = query.getOrDefault("api-version")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "api-version", valid_593959
  var valid_593960 = query.getOrDefault("$top")
  valid_593960 = validateParameter(valid_593960, JInt, required = false, default = nil)
  if valid_593960 != nil:
    section.add "$top", valid_593960
  var valid_593961 = query.getOrDefault("$select")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "$select", valid_593961
  var valid_593962 = query.getOrDefault("$skip")
  valid_593962 = validateParameter(valid_593962, JInt, required = false, default = nil)
  if valid_593962 != nil:
    section.add "$skip", valid_593962
  var valid_593963 = query.getOrDefault("$count")
  valid_593963 = validateParameter(valid_593963, JBool, required = false, default = nil)
  if valid_593963 != nil:
    section.add "$count", valid_593963
  var valid_593964 = query.getOrDefault("$search")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "$search", valid_593964
  var valid_593965 = query.getOrDefault("$format")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "$format", valid_593965
  var valid_593966 = query.getOrDefault("$filter")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "$filter", valid_593966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593967: Call_AccountListByResourceGroup_593952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_AccountListByResourceGroup_593952;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Orderby: string = ""; Expand: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Search: string = ""; Format: string = "";
          Filter: string = ""): Recallable =
  ## accountListByResourceGroup
  ## Gets the first page of Data Lake Analytics accounts, if any, within a specific resource group. This includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
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
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   Format: string
  ##         : The return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_593969 = newJObject()
  var query_593970 = newJObject()
  add(query_593970, "$orderby", newJString(Orderby))
  add(path_593969, "resourceGroupName", newJString(resourceGroupName))
  add(query_593970, "$expand", newJString(Expand))
  add(query_593970, "api-version", newJString(apiVersion))
  add(path_593969, "subscriptionId", newJString(subscriptionId))
  add(query_593970, "$top", newJInt(Top))
  add(query_593970, "$select", newJString(Select))
  add(query_593970, "$skip", newJInt(Skip))
  add(query_593970, "$count", newJBool(Count))
  add(query_593970, "$search", newJString(Search))
  add(query_593970, "$format", newJString(Format))
  add(query_593970, "$filter", newJString(Filter))
  result = call_593968.call(path_593969, query_593970, nil, nil, nil)

var accountListByResourceGroup* = Call_AccountListByResourceGroup_593952(
    name: "accountListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts",
    validator: validate_AccountListByResourceGroup_593953, base: "",
    url: url_AccountListByResourceGroup_593954, schemes: {Scheme.Https})
type
  Call_AccountGet_593971 = ref object of OpenApiRestCall_593408
proc url_AccountGet_593973(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
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

proc validate_AccountGet_593972(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details of the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593974 = path.getOrDefault("resourceGroupName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "resourceGroupName", valid_593974
  var valid_593975 = path.getOrDefault("subscriptionId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "subscriptionId", valid_593975
  var valid_593976 = path.getOrDefault("accountName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "accountName", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_AccountGet_593971; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details of the specified Data Lake Analytics account.
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_AccountGet_593971; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountGet
  ## Gets details of the specified Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to retrieve.
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  add(path_593980, "resourceGroupName", newJString(resourceGroupName))
  add(query_593981, "api-version", newJString(apiVersion))
  add(path_593980, "subscriptionId", newJString(subscriptionId))
  add(path_593980, "accountName", newJString(accountName))
  result = call_593979.call(path_593980, query_593981, nil, nil, nil)

var accountGet* = Call_AccountGet_593971(name: "accountGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
                                      validator: validate_AccountGet_593972,
                                      base: "", url: url_AccountGet_593973,
                                      schemes: {Scheme.Https})
type
  Call_AccountDelete_593982 = ref object of OpenApiRestCall_593408
proc url_AccountDelete_593984(protocol: Scheme; host: string; base: string;
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

proc validate_AccountDelete_593983(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to delete
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593985 = path.getOrDefault("resourceGroupName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "resourceGroupName", valid_593985
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
  var valid_593987 = path.getOrDefault("accountName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "accountName", valid_593987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "api-version", valid_593988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_AccountDelete_593982; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_AccountDelete_593982; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountDelete
  ## Begins the delete process for the Data Lake Analytics account object specified by the account name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to delete
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  add(path_593991, "resourceGroupName", newJString(resourceGroupName))
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "subscriptionId", newJString(subscriptionId))
  add(path_593991, "accountName", newJString(accountName))
  result = call_593990.call(path_593991, query_593992, nil, nil, nil)

var accountDelete* = Call_AccountDelete_593982(name: "accountDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}",
    validator: validate_AccountDelete_593983, base: "", url: url_AccountDelete_593984,
    schemes: {Scheme.Https})
type
  Call_AccountListDataLakeStoreAccounts_593993 = ref object of OpenApiRestCall_593408
proc url_AccountListDataLakeStoreAccounts_593995(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/DataLakeStoreAccounts/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountListDataLakeStoreAccounts_593994(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account for which to list Data Lake Store accounts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593996 = path.getOrDefault("resourceGroupName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "resourceGroupName", valid_593996
  var valid_593997 = path.getOrDefault("subscriptionId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "subscriptionId", valid_593997
  var valid_593998 = path.getOrDefault("accountName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "accountName", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
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
  ##   $search: JString
  ##          : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   $format: JString
  ##          : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_593999 = query.getOrDefault("$orderby")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "$orderby", valid_593999
  var valid_594000 = query.getOrDefault("$expand")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "$expand", valid_594000
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  var valid_594002 = query.getOrDefault("$top")
  valid_594002 = validateParameter(valid_594002, JInt, required = false, default = nil)
  if valid_594002 != nil:
    section.add "$top", valid_594002
  var valid_594003 = query.getOrDefault("$select")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "$select", valid_594003
  var valid_594004 = query.getOrDefault("$skip")
  valid_594004 = validateParameter(valid_594004, JInt, required = false, default = nil)
  if valid_594004 != nil:
    section.add "$skip", valid_594004
  var valid_594005 = query.getOrDefault("$count")
  valid_594005 = validateParameter(valid_594005, JBool, required = false, default = nil)
  if valid_594005 != nil:
    section.add "$count", valid_594005
  var valid_594006 = query.getOrDefault("$search")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "$search", valid_594006
  var valid_594007 = query.getOrDefault("$format")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "$format", valid_594007
  var valid_594008 = query.getOrDefault("$filter")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "$filter", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_AccountListDataLakeStoreAccounts_593993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_AccountListDataLakeStoreAccounts_593993;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Orderby: string = ""; Expand: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Search: string = "";
          Format: string = ""; Filter: string = ""): Recallable =
  ## accountListDataLakeStoreAccounts
  ## Gets the first page of Data Lake Store accounts linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
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
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   Format: string
  ##         : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account for which to list Data Lake Store accounts.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(query_594012, "$orderby", newJString(Orderby))
  add(path_594011, "resourceGroupName", newJString(resourceGroupName))
  add(query_594012, "$expand", newJString(Expand))
  add(query_594012, "api-version", newJString(apiVersion))
  add(path_594011, "subscriptionId", newJString(subscriptionId))
  add(query_594012, "$top", newJInt(Top))
  add(query_594012, "$select", newJString(Select))
  add(query_594012, "$skip", newJInt(Skip))
  add(query_594012, "$count", newJBool(Count))
  add(query_594012, "$search", newJString(Search))
  add(query_594012, "$format", newJString(Format))
  add(path_594011, "accountName", newJString(accountName))
  add(query_594012, "$filter", newJString(Filter))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var accountListDataLakeStoreAccounts* = Call_AccountListDataLakeStoreAccounts_593993(
    name: "accountListDataLakeStoreAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/DataLakeStoreAccounts/",
    validator: validate_AccountListDataLakeStoreAccounts_593994, base: "",
    url: url_AccountListDataLakeStoreAccounts_593995, schemes: {Scheme.Https})
type
  Call_AccountAddDataLakeStoreAccount_594025 = ref object of OpenApiRestCall_593408
proc url_AccountAddDataLakeStoreAccount_594027(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/DataLakeStoreAccounts/"),
               (kind: VariableSegment, value: "dataLakeStoreAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountAddDataLakeStoreAccount_594026(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to add.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to which to add the Data Lake Store account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594045 = path.getOrDefault("resourceGroupName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "resourceGroupName", valid_594045
  var valid_594046 = path.getOrDefault("subscriptionId")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "subscriptionId", valid_594046
  var valid_594047 = path.getOrDefault("dataLakeStoreAccountName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "dataLakeStoreAccountName", valid_594047
  var valid_594048 = path.getOrDefault("accountName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "accountName", valid_594048
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
  ##   parameters: JObject (required)
  ##             : The details of the Data Lake Store account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594051: Call_AccountAddDataLakeStoreAccount_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_AccountAddDataLakeStoreAccount_594025;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; dataLakeStoreAccountName: string;
          accountName: string): Recallable =
  ## accountAddDataLakeStoreAccount
  ## Updates the specified Data Lake Analytics account to include the additional Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The details of the Data Lake Store account.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to add.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to which to add the Data Lake Store account.
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  var body_594055 = newJObject()
  add(path_594053, "resourceGroupName", newJString(resourceGroupName))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594055 = parameters
  add(path_594053, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_594053, "accountName", newJString(accountName))
  result = call_594052.call(path_594053, query_594054, nil, nil, body_594055)

var accountAddDataLakeStoreAccount* = Call_AccountAddDataLakeStoreAccount_594025(
    name: "accountAddDataLakeStoreAccount", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/DataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_AccountAddDataLakeStoreAccount_594026, base: "",
    url: url_AccountAddDataLakeStoreAccount_594027, schemes: {Scheme.Https})
type
  Call_AccountGetDataLakeStoreAccount_594013 = ref object of OpenApiRestCall_593408
proc url_AccountGetDataLakeStoreAccount_594015(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/DataLakeStoreAccounts/"),
               (kind: VariableSegment, value: "dataLakeStoreAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountGetDataLakeStoreAccount_594014(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to retrieve
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which to retrieve the Data Lake Store account details.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594016 = path.getOrDefault("resourceGroupName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "resourceGroupName", valid_594016
  var valid_594017 = path.getOrDefault("subscriptionId")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "subscriptionId", valid_594017
  var valid_594018 = path.getOrDefault("dataLakeStoreAccountName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "dataLakeStoreAccountName", valid_594018
  var valid_594019 = path.getOrDefault("accountName")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "accountName", valid_594019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594020 = query.getOrDefault("api-version")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "api-version", valid_594020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594021: Call_AccountGetDataLakeStoreAccount_594013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_AccountGetDataLakeStoreAccount_594013;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; accountName: string): Recallable =
  ## accountGetDataLakeStoreAccount
  ## Gets the specified Data Lake Store account details in the specified Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to retrieve
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which to retrieve the Data Lake Store account details.
  var path_594023 = newJObject()
  var query_594024 = newJObject()
  add(path_594023, "resourceGroupName", newJString(resourceGroupName))
  add(query_594024, "api-version", newJString(apiVersion))
  add(path_594023, "subscriptionId", newJString(subscriptionId))
  add(path_594023, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_594023, "accountName", newJString(accountName))
  result = call_594022.call(path_594023, query_594024, nil, nil, nil)

var accountGetDataLakeStoreAccount* = Call_AccountGetDataLakeStoreAccount_594013(
    name: "accountGetDataLakeStoreAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/DataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_AccountGetDataLakeStoreAccount_594014, base: "",
    url: url_AccountGetDataLakeStoreAccount_594015, schemes: {Scheme.Https})
type
  Call_AccountDeleteDataLakeStoreAccount_594056 = ref object of OpenApiRestCall_593408
proc url_AccountDeleteDataLakeStoreAccount_594058(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/DataLakeStoreAccounts/"),
               (kind: VariableSegment, value: "dataLakeStoreAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountDeleteDataLakeStoreAccount_594057(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: JString (required)
  ##                           : The name of the Data Lake Store account to remove
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which to remove the Data Lake Store account.
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
  var valid_594061 = path.getOrDefault("dataLakeStoreAccountName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "dataLakeStoreAccountName", valid_594061
  var valid_594062 = path.getOrDefault("accountName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "accountName", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_AccountDeleteDataLakeStoreAccount_594056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_AccountDeleteDataLakeStoreAccount_594056;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataLakeStoreAccountName: string; accountName: string): Recallable =
  ## accountDeleteDataLakeStoreAccount
  ## Updates the Data Lake Analytics account specified to remove the specified Data Lake Store account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   dataLakeStoreAccountName: string (required)
  ##                           : The name of the Data Lake Store account to remove
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which to remove the Data Lake Store account.
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  add(path_594066, "dataLakeStoreAccountName",
      newJString(dataLakeStoreAccountName))
  add(path_594066, "accountName", newJString(accountName))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var accountDeleteDataLakeStoreAccount* = Call_AccountDeleteDataLakeStoreAccount_594056(
    name: "accountDeleteDataLakeStoreAccount", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/DataLakeStoreAccounts/{dataLakeStoreAccountName}",
    validator: validate_AccountDeleteDataLakeStoreAccount_594057, base: "",
    url: url_AccountDeleteDataLakeStoreAccount_594058, schemes: {Scheme.Https})
type
  Call_AccountListStorageAccounts_594068 = ref object of OpenApiRestCall_593408
proc url_AccountListStorageAccounts_594070(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/StorageAccounts/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountListStorageAccounts_594069(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account for which to list Azure Storage accounts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594071 = path.getOrDefault("resourceGroupName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "resourceGroupName", valid_594071
  var valid_594072 = path.getOrDefault("subscriptionId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "subscriptionId", valid_594072
  var valid_594073 = path.getOrDefault("accountName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "accountName", valid_594073
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
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
  ##   $search: JString
  ##          : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   $format: JString
  ##          : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   $filter: JString
  ##          : The OData filter. Optional.
  section = newJObject()
  var valid_594074 = query.getOrDefault("$orderby")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "$orderby", valid_594074
  var valid_594075 = query.getOrDefault("$expand")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "$expand", valid_594075
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594076 = query.getOrDefault("api-version")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "api-version", valid_594076
  var valid_594077 = query.getOrDefault("$top")
  valid_594077 = validateParameter(valid_594077, JInt, required = false, default = nil)
  if valid_594077 != nil:
    section.add "$top", valid_594077
  var valid_594078 = query.getOrDefault("$select")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "$select", valid_594078
  var valid_594079 = query.getOrDefault("$skip")
  valid_594079 = validateParameter(valid_594079, JInt, required = false, default = nil)
  if valid_594079 != nil:
    section.add "$skip", valid_594079
  var valid_594080 = query.getOrDefault("$count")
  valid_594080 = validateParameter(valid_594080, JBool, required = false, default = nil)
  if valid_594080 != nil:
    section.add "$count", valid_594080
  var valid_594081 = query.getOrDefault("$search")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "$search", valid_594081
  var valid_594082 = query.getOrDefault("$format")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "$format", valid_594082
  var valid_594083 = query.getOrDefault("$filter")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "$filter", valid_594083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594084: Call_AccountListStorageAccounts_594068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_AccountListStorageAccounts_594068;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Orderby: string = ""; Expand: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Search: string = "";
          Format: string = ""; Filter: string = ""): Recallable =
  ## accountListStorageAccounts
  ## Gets the first page of Azure Storage accounts, if any, linked to the specified Data Lake Analytics account. The response includes a link to the next page, if any.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories/$expand=Products would expand Product data in line with each Category entry. Optional.
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
  ##   Search: string
  ##         : A free form search. A free-text search expression to match for whether a particular entry should be included in the feed, e.g. Categories?$search=blue OR green. Optional.
  ##   Format: string
  ##         : The desired return format. Return the response in particular format without access to request headers for standard content-type negotiation (e.g Orders?$format=json). Optional.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account for which to list Azure Storage accounts.
  ##   Filter: string
  ##         : The OData filter. Optional.
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  add(query_594087, "$orderby", newJString(Orderby))
  add(path_594086, "resourceGroupName", newJString(resourceGroupName))
  add(query_594087, "$expand", newJString(Expand))
  add(query_594087, "api-version", newJString(apiVersion))
  add(path_594086, "subscriptionId", newJString(subscriptionId))
  add(query_594087, "$top", newJInt(Top))
  add(query_594087, "$select", newJString(Select))
  add(query_594087, "$skip", newJInt(Skip))
  add(query_594087, "$count", newJBool(Count))
  add(query_594087, "$search", newJString(Search))
  add(query_594087, "$format", newJString(Format))
  add(path_594086, "accountName", newJString(accountName))
  add(query_594087, "$filter", newJString(Filter))
  result = call_594085.call(path_594086, query_594087, nil, nil, nil)

var accountListStorageAccounts* = Call_AccountListStorageAccounts_594068(
    name: "accountListStorageAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/",
    validator: validate_AccountListStorageAccounts_594069, base: "",
    url: url_AccountListStorageAccounts_594070, schemes: {Scheme.Https})
type
  Call_AccountAddStorageAccount_594100 = ref object of OpenApiRestCall_593408
proc url_AccountAddStorageAccount_594102(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountAddStorageAccount_594101(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account to add
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to which to add the Azure Storage account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594103 = path.getOrDefault("resourceGroupName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "resourceGroupName", valid_594103
  var valid_594104 = path.getOrDefault("storageAccountName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "storageAccountName", valid_594104
  var valid_594105 = path.getOrDefault("subscriptionId")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "subscriptionId", valid_594105
  var valid_594106 = path.getOrDefault("accountName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "accountName", valid_594106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594107 = query.getOrDefault("api-version")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "api-version", valid_594107
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

proc call*(call_594109: Call_AccountAddStorageAccount_594100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_AccountAddStorageAccount_594100;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; parameters: JsonNode; accountName: string): Recallable =
  ## accountAddStorageAccount
  ## Updates the specified Data Lake Analytics account to add an Azure Storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account to add
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and optional suffix for the Azure Storage Account.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to which to add the Azure Storage account.
  var path_594111 = newJObject()
  var query_594112 = newJObject()
  var body_594113 = newJObject()
  add(path_594111, "resourceGroupName", newJString(resourceGroupName))
  add(query_594112, "api-version", newJString(apiVersion))
  add(path_594111, "storageAccountName", newJString(storageAccountName))
  add(path_594111, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594113 = parameters
  add(path_594111, "accountName", newJString(accountName))
  result = call_594110.call(path_594111, query_594112, nil, nil, body_594113)

var accountAddStorageAccount* = Call_AccountAddStorageAccount_594100(
    name: "accountAddStorageAccount", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}",
    validator: validate_AccountAddStorageAccount_594101, base: "",
    url: url_AccountAddStorageAccount_594102, schemes: {Scheme.Https})
type
  Call_AccountGetStorageAccount_594088 = ref object of OpenApiRestCall_593408
proc url_AccountGetStorageAccount_594090(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountGetStorageAccount_594089(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account for which to retrieve the details.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which to retrieve Azure storage account details.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594091 = path.getOrDefault("resourceGroupName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "resourceGroupName", valid_594091
  var valid_594092 = path.getOrDefault("storageAccountName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "storageAccountName", valid_594092
  var valid_594093 = path.getOrDefault("subscriptionId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "subscriptionId", valid_594093
  var valid_594094 = path.getOrDefault("accountName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "accountName", valid_594094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594095 = query.getOrDefault("api-version")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "api-version", valid_594095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594096: Call_AccountGetStorageAccount_594088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_AccountGetStorageAccount_594088;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## accountGetStorageAccount
  ## Gets the specified Azure Storage account linked to the given Data Lake Analytics account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account for which to retrieve the details.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which to retrieve Azure storage account details.
  var path_594098 = newJObject()
  var query_594099 = newJObject()
  add(path_594098, "resourceGroupName", newJString(resourceGroupName))
  add(query_594099, "api-version", newJString(apiVersion))
  add(path_594098, "storageAccountName", newJString(storageAccountName))
  add(path_594098, "subscriptionId", newJString(subscriptionId))
  add(path_594098, "accountName", newJString(accountName))
  result = call_594097.call(path_594098, query_594099, nil, nil, nil)

var accountGetStorageAccount* = Call_AccountGetStorageAccount_594088(
    name: "accountGetStorageAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}",
    validator: validate_AccountGetStorageAccount_594089, base: "",
    url: url_AccountGetStorageAccount_594090, schemes: {Scheme.Https})
type
  Call_AccountUpdateStorageAccount_594126 = ref object of OpenApiRestCall_593408
proc url_AccountUpdateStorageAccount_594128(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountUpdateStorageAccount_594127(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The Azure Storage account to modify
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account to modify storage accounts in
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594129 = path.getOrDefault("resourceGroupName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "resourceGroupName", valid_594129
  var valid_594130 = path.getOrDefault("storageAccountName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "storageAccountName", valid_594130
  var valid_594131 = path.getOrDefault("subscriptionId")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "subscriptionId", valid_594131
  var valid_594132 = path.getOrDefault("accountName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "accountName", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and suffix to update the storage account with.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594135: Call_AccountUpdateStorageAccount_594126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_AccountUpdateStorageAccount_594126;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; parameters: JsonNode; accountName: string): Recallable =
  ## accountUpdateStorageAccount
  ## Updates the Data Lake Analytics account to replace Azure Storage blob account details, such as the access key and/or suffix.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The Azure Storage account to modify
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters containing the access key and suffix to update the storage account with.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account to modify storage accounts in
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  var body_594139 = newJObject()
  add(path_594137, "resourceGroupName", newJString(resourceGroupName))
  add(query_594138, "api-version", newJString(apiVersion))
  add(path_594137, "storageAccountName", newJString(storageAccountName))
  add(path_594137, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594139 = parameters
  add(path_594137, "accountName", newJString(accountName))
  result = call_594136.call(path_594137, query_594138, nil, nil, body_594139)

var accountUpdateStorageAccount* = Call_AccountUpdateStorageAccount_594126(
    name: "accountUpdateStorageAccount", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}",
    validator: validate_AccountUpdateStorageAccount_594127, base: "",
    url: url_AccountUpdateStorageAccount_594128, schemes: {Scheme.Https})
type
  Call_AccountDeleteStorageAccount_594114 = ref object of OpenApiRestCall_593408
proc url_AccountDeleteStorageAccount_594116(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountDeleteStorageAccount_594115(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure Storage account to remove
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which to remove the Azure Storage account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594117 = path.getOrDefault("resourceGroupName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "resourceGroupName", valid_594117
  var valid_594118 = path.getOrDefault("storageAccountName")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "storageAccountName", valid_594118
  var valid_594119 = path.getOrDefault("subscriptionId")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "subscriptionId", valid_594119
  var valid_594120 = path.getOrDefault("accountName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "accountName", valid_594120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594121 = query.getOrDefault("api-version")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "api-version", valid_594121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594122: Call_AccountDeleteStorageAccount_594114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ## 
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_AccountDeleteStorageAccount_594114;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## accountDeleteStorageAccount
  ## Updates the specified Data Lake Analytics account to remove an Azure Storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure Storage account to remove
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which to remove the Azure Storage account.
  var path_594124 = newJObject()
  var query_594125 = newJObject()
  add(path_594124, "resourceGroupName", newJString(resourceGroupName))
  add(query_594125, "api-version", newJString(apiVersion))
  add(path_594124, "storageAccountName", newJString(storageAccountName))
  add(path_594124, "subscriptionId", newJString(subscriptionId))
  add(path_594124, "accountName", newJString(accountName))
  result = call_594123.call(path_594124, query_594125, nil, nil, nil)

var accountDeleteStorageAccount* = Call_AccountDeleteStorageAccount_594114(
    name: "accountDeleteStorageAccount", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}",
    validator: validate_AccountDeleteStorageAccount_594115, base: "",
    url: url_AccountDeleteStorageAccount_594116, schemes: {Scheme.Https})
type
  Call_AccountListStorageContainers_594140 = ref object of OpenApiRestCall_593408
proc url_AccountListStorageContainers_594142(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName"),
               (kind: ConstantSegment, value: "/Containers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountListStorageContainers_594141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account from which to list blob containers.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account for which to list Azure Storage blob containers.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594143 = path.getOrDefault("resourceGroupName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "resourceGroupName", valid_594143
  var valid_594144 = path.getOrDefault("storageAccountName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "storageAccountName", valid_594144
  var valid_594145 = path.getOrDefault("subscriptionId")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "subscriptionId", valid_594145
  var valid_594146 = path.getOrDefault("accountName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "accountName", valid_594146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594147 = query.getOrDefault("api-version")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "api-version", valid_594147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594148: Call_AccountListStorageContainers_594140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_AccountListStorageContainers_594140;
          resourceGroupName: string; apiVersion: string; storageAccountName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## accountListStorageContainers
  ## Lists the Azure Storage containers, if any, associated with the specified Data Lake Analytics and Azure Storage account combination. The response includes a link to the next page of results, if any.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account from which to list blob containers.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account for which to list Azure Storage blob containers.
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  add(path_594150, "resourceGroupName", newJString(resourceGroupName))
  add(query_594151, "api-version", newJString(apiVersion))
  add(path_594150, "storageAccountName", newJString(storageAccountName))
  add(path_594150, "subscriptionId", newJString(subscriptionId))
  add(path_594150, "accountName", newJString(accountName))
  result = call_594149.call(path_594150, query_594151, nil, nil, nil)

var accountListStorageContainers* = Call_AccountListStorageContainers_594140(
    name: "accountListStorageContainers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}/Containers",
    validator: validate_AccountListStorageContainers_594141, base: "",
    url: url_AccountListStorageContainers_594142, schemes: {Scheme.Https})
type
  Call_AccountGetStorageContainer_594152 = ref object of OpenApiRestCall_593408
proc url_AccountGetStorageContainer_594154(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName"),
               (kind: ConstantSegment, value: "/Containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountGetStorageContainer_594153(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   containerName: JString (required)
  ##                : The name of the Azure storage container to retrieve
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account from which to retrieve the blob container.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account for which to retrieve blob container.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594155 = path.getOrDefault("resourceGroupName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "resourceGroupName", valid_594155
  var valid_594156 = path.getOrDefault("containerName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "containerName", valid_594156
  var valid_594157 = path.getOrDefault("storageAccountName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "storageAccountName", valid_594157
  var valid_594158 = path.getOrDefault("subscriptionId")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "subscriptionId", valid_594158
  var valid_594159 = path.getOrDefault("accountName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "accountName", valid_594159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594160 = query.getOrDefault("api-version")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "api-version", valid_594160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594161: Call_AccountGetStorageContainer_594152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ## 
  let valid = call_594161.validator(path, query, header, formData, body)
  let scheme = call_594161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594161.url(scheme.get, call_594161.host, call_594161.base,
                         call_594161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594161, url, valid)

proc call*(call_594162: Call_AccountGetStorageContainer_594152;
          resourceGroupName: string; apiVersion: string; containerName: string;
          storageAccountName: string; subscriptionId: string; accountName: string): Recallable =
  ## accountGetStorageContainer
  ## Gets the specified Azure Storage container associated with the given Data Lake Analytics and Azure Storage accounts.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : The name of the Azure storage container to retrieve
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account from which to retrieve the blob container.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account for which to retrieve blob container.
  var path_594163 = newJObject()
  var query_594164 = newJObject()
  add(path_594163, "resourceGroupName", newJString(resourceGroupName))
  add(query_594164, "api-version", newJString(apiVersion))
  add(path_594163, "containerName", newJString(containerName))
  add(path_594163, "storageAccountName", newJString(storageAccountName))
  add(path_594163, "subscriptionId", newJString(subscriptionId))
  add(path_594163, "accountName", newJString(accountName))
  result = call_594162.call(path_594163, query_594164, nil, nil, nil)

var accountGetStorageContainer* = Call_AccountGetStorageContainer_594152(
    name: "accountGetStorageContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}/Containers/{containerName}",
    validator: validate_AccountGetStorageContainer_594153, base: "",
    url: url_AccountGetStorageContainer_594154, schemes: {Scheme.Https})
type
  Call_AccountListSasTokens_594165 = ref object of OpenApiRestCall_593408
proc url_AccountListSasTokens_594167(protocol: Scheme; host: string; base: string;
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
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/StorageAccounts/"),
               (kind: VariableSegment, value: "storageAccountName"),
               (kind: ConstantSegment, value: "/Containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/listSasTokens")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountListSasTokens_594166(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   containerName: JString (required)
  ##                : The name of the Azure storage container for which the SAS token is being requested.
  ##   storageAccountName: JString (required)
  ##                     : The name of the Azure storage account for which the SAS token is being requested.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: JString (required)
  ##              : The name of the Data Lake Analytics account from which an Azure Storage account's SAS token is being requested.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594168 = path.getOrDefault("resourceGroupName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "resourceGroupName", valid_594168
  var valid_594169 = path.getOrDefault("containerName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "containerName", valid_594169
  var valid_594170 = path.getOrDefault("storageAccountName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "storageAccountName", valid_594170
  var valid_594171 = path.getOrDefault("subscriptionId")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "subscriptionId", valid_594171
  var valid_594172 = path.getOrDefault("accountName")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "accountName", valid_594172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594173 = query.getOrDefault("api-version")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "api-version", valid_594173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594174: Call_AccountListSasTokens_594165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ## 
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_AccountListSasTokens_594165;
          resourceGroupName: string; apiVersion: string; containerName: string;
          storageAccountName: string; subscriptionId: string; accountName: string): Recallable =
  ## accountListSasTokens
  ## Gets the SAS token associated with the specified Data Lake Analytics and Azure Storage account and container combination.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : The name of the Azure storage container for which the SAS token is being requested.
  ##   storageAccountName: string (required)
  ##                     : The name of the Azure storage account for which the SAS token is being requested.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   accountName: string (required)
  ##              : The name of the Data Lake Analytics account from which an Azure Storage account's SAS token is being requested.
  var path_594176 = newJObject()
  var query_594177 = newJObject()
  add(path_594176, "resourceGroupName", newJString(resourceGroupName))
  add(query_594177, "api-version", newJString(apiVersion))
  add(path_594176, "containerName", newJString(containerName))
  add(path_594176, "storageAccountName", newJString(storageAccountName))
  add(path_594176, "subscriptionId", newJString(subscriptionId))
  add(path_594176, "accountName", newJString(accountName))
  result = call_594175.call(path_594176, query_594177, nil, nil, nil)

var accountListSasTokens* = Call_AccountListSasTokens_594165(
    name: "accountListSasTokens", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{accountName}/StorageAccounts/{storageAccountName}/Containers/{containerName}/listSasTokens",
    validator: validate_AccountListSasTokens_594166, base: "",
    url: url_AccountListSasTokens_594167, schemes: {Scheme.Https})
type
  Call_AccountCreate_594178 = ref object of OpenApiRestCall_593408
proc url_AccountCreate_594180(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountCreate_594179(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.the account will be associated with.
  ##   name: JString (required)
  ##       : The name of the Data Lake Analytics account to create.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594181 = path.getOrDefault("resourceGroupName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "resourceGroupName", valid_594181
  var valid_594182 = path.getOrDefault("name")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "name", valid_594182
  var valid_594183 = path.getOrDefault("subscriptionId")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "subscriptionId", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594184 = query.getOrDefault("api-version")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "api-version", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create Data Lake Analytics account operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594186: Call_AccountCreate_594178; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads
  ## 
  let valid = call_594186.validator(path, query, header, formData, body)
  let scheme = call_594186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594186.url(scheme.get, call_594186.host, call_594186.base,
                         call_594186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594186, url, valid)

proc call*(call_594187: Call_AccountCreate_594178; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## accountCreate
  ## Creates the specified Data Lake Analytics account. This supplies the user with computation services for Data Lake Analytics workloads
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.the account will be associated with.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the Data Lake Analytics account to create.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create Data Lake Analytics account operation.
  var path_594188 = newJObject()
  var query_594189 = newJObject()
  var body_594190 = newJObject()
  add(path_594188, "resourceGroupName", newJString(resourceGroupName))
  add(query_594189, "api-version", newJString(apiVersion))
  add(path_594188, "name", newJString(name))
  add(path_594188, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594190 = parameters
  result = call_594187.call(path_594188, query_594189, nil, nil, body_594190)

var accountCreate* = Call_AccountCreate_594178(name: "accountCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{name}",
    validator: validate_AccountCreate_594179, base: "", url: url_AccountCreate_594180,
    schemes: {Scheme.Https})
type
  Call_AccountUpdate_594191 = ref object of OpenApiRestCall_593408
proc url_AccountUpdate_594193(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataLakeAnalytics/accounts/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountUpdate_594192(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   name: JString (required)
  ##       : The name of the Data Lake Analytics account to update.
  ##   subscriptionId: JString (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594194 = path.getOrDefault("resourceGroupName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "resourceGroupName", valid_594194
  var valid_594195 = path.getOrDefault("name")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "name", valid_594195
  var valid_594196 = path.getOrDefault("subscriptionId")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "subscriptionId", valid_594196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594197 = query.getOrDefault("api-version")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "api-version", valid_594197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update Data Lake Analytics account operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594199: Call_AccountUpdate_594191; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ## 
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_AccountUpdate_594191; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## accountUpdate
  ## Updates the Data Lake Analytics account object specified by the accountName with the contents of the account object.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure resource group that contains the Data Lake Analytics account.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the Data Lake Analytics account to update.
  ##   subscriptionId: string (required)
  ##                 : Get subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update Data Lake Analytics account operation.
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  var body_594203 = newJObject()
  add(path_594201, "resourceGroupName", newJString(resourceGroupName))
  add(query_594202, "api-version", newJString(apiVersion))
  add(path_594201, "name", newJString(name))
  add(path_594201, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594203 = parameters
  result = call_594200.call(path_594201, query_594202, nil, nil, body_594203)

var accountUpdate* = Call_AccountUpdate_594191(name: "accountUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/accounts/{name}",
    validator: validate_AccountUpdate_594192, base: "", url: url_AccountUpdate_594193,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
